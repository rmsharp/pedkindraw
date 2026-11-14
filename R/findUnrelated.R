## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 13,
## rulings R52-R54, pedkindraw S18). New code (R9), written from kinship2's
## help page for pedigree.unrelated() and its measured results, kinship2's
## source not read (R11, R14).

#' Find a set of unrelated genotyped animals
#'
#' Chooses genotyped animals of which no two are related, as many as it can,
#' and gives the same set every time.
#'
#' Two animals are related when they share an ancestor or one descends from
#' the other, which is when their kinship is above 0. The animals are chosen
#' one at a time: among the genotyped animals still in play, the one related
#' to the fewest of them (itself counted) is taken, ties going to the first id
#' in byte order (capitals before lower case), and it and every animal related
#' to it leave play. The counts are taken again after each pick. A swap pass
#' then looks for a chosen animal that can be traded for two left-out animals,
#' each related to it and to no other chosen animal and not related to each
#' other; the first such trade (by chosen animal, then pair, in byte order) is
#' made, any animal now related to no chosen one is added by the same rule,
#' and the pass starts again until no trade is left.
#'
#' So every two chosen animals are unrelated, no genotyped animal can be
#' added, no chosen animal can be traded for two, and the row order of
#' \code{ped} does not change the answer. The set is not always the largest
#' possible one.
#'
#' Sex is not read, so a male dam or an unknown sex does not matter here, and
#' one known parent is legal. A pedigree from which relatedness cannot be
#' read is refused: \code{findUnrelated()} stops, naming the animals, when
#' \code{\link{checkPedigree}} reports \code{missingIds}, \code{duplicateIds},
#' \code{ownParent}, \code{cycle}, \code{rowlessParents}
#' (\code{\link{addParents}} adds a row for each such parent) or
#' \code{missingParentCodes}.
#'
#' kinship2's \code{pedigree.unrelated()} breaks its ties at random, so it can
#' give a different set each time it runs. On the comparison pedigrees its
#' tests use (kinship2's \code{sample.ped} families 1 and 2, and a 375-animal
#' rhesus pedigree with 30 percent genotyped), \code{findUnrelated()} chooses
#' 4, 2 and 44 animals, the sizes kinship2 1.9.6.2 gave; on the seeded random
#' pedigrees its tests compare, it never chooses fewer animals than kinship2.
#'
#' @param ped a data frame with the columns \code{id}, \code{sire} and
#' \code{dam} (an unknown parent is \code{NA}). Factor columns are read by
#' their labels and numbers as text; other columns are not read.
#' @param genotyped a logical vector, one value per row of \code{ped}:
#' \code{TRUE} for an animal that may be chosen (one with DNA, for instance).
#' kinship2's 0/1 \code{avail} is given as \code{avail == 1}.
#' @return A character vector of the chosen ids, in byte order;
#' \code{character(0)} when no animal is genotyped.
#'
#' @seealso \code{\link{checkPedigree}}, \code{\link{addParents}},
#' \code{\link{kinship}}
#'
#' @export
#' @examples
#' ## s1 and d1 are the parents of the full siblings o1 and o2; f1 is
#' ## unrelated to them.
#' ped <- data.frame(
#'   id = c("s1", "d1", "o1", "o2", "f1"),
#'   sire = c(NA, NA, "s1", "s1", NA),
#'   dam = c(NA, NA, "d1", "d1", NA)
#' )
#' ## Everyone genotyped: f1, then d1 and s1, who are not related.
#' findUnrelated(ped, rep(TRUE, 5L))
#' ## Only the offspring and f1 genotyped: one of the siblings and f1.
#' findUnrelated(ped, ped$id %in% c("o1", "o2", "f1"))
findUnrelated <- function(ped, genotyped) {
  .checkPedFrame(ped, "findUnrelated")
  if (!is.logical(genotyped)) {
    stop("findUnrelated: genotyped must be TRUE or FALSE for each row of ped",
         call. = FALSE)
  }
  if (length(genotyped) != nrow(ped)) {
    stop("findUnrelated: genotyped has ", length(genotyped),
         " value(s) for the ", nrow(ped), " row(s) of ped", call. = FALSE)
  }
  if (anyNA(genotyped)) {
    stop("findUnrelated: genotyped is NA in row(s) ",
         .checkListed(which(is.na(genotyped))), call. = FALSE)
  }
  ped <- ped[c("id", "sire", "dam")]
  refusal <- .unrelatedStopMessage(checkPedigree(ped))
  if (!is.null(refusal)) {
    stop(refusal, call. = FALSE)
  }
  id <- as.character(ped[["id"]])
  chosen <- which(genotyped)
  if (length(chosen) == 0L) {
    return(character(0L))
  }
  chosen <- chosen[order(id[chosen], method = "radix")]
  founders <- .founderAncestors(id, as.character(ped[["sire"]]),
                                as.character(ped[["dam"]]))
  related <- Matrix::tcrossprod(founders[chosen, , drop = FALSE])
  related <- methods::as(methods::as(related, "generalMatrix"),
                         "CsparseMatrix")
  picked <- .unrelatedPick(related)
  picked <- .unrelatedSwap(related, picked)
  sort(id[chosen][picked], method = "radix")
}

## The checkPedigree() checks that leave relatedness undefined (plan R53).
.unrelatedStops <- c(
  "missingIds", "duplicateIds", "ownParent", "cycle", "rowlessParents",
  "missingParentCodes"
)

## The message findUnrelated() stops with, given checkPedigree()'s rows, or
## NULL when none of them leaves relatedness undefined: the animals under each
## such check (rows for missing ids, codes quoted), ten at most per check.
.unrelatedStopMessage <- function(problems) {
  problems <- problems[problems$check %in% .unrelatedStops, ]
  if (nrow(problems) == 0L) {
    return(NULL)
  }
  named <- problems$id
  codes <- problems$check == "missingParentCodes"
  named[codes] <- paste0("\"", named[codes], "\"")
  rows <- problems$check == "missingIds"
  named[rows] <- problems$detail[rows]
  byCheck <- split(named, factor(problems$check, .unrelatedStops))
  byCheck <- byCheck[lengths(byCheck) > 0L]
  listed <- paste0(names(byCheck), ": ",
                   vapply(byCheck, .checkListed, character(1L)),
                   collapse = "; ")
  hint <- if ("rowlessParents" %in% names(byCheck)) {
    " (addParents() adds a row for each parent that has none)"
  } else {
    ""
  }
  paste0("findUnrelated: relatedness cannot be read from ped, ",
         "checkPedigree() reports ", listed, hint)
}

## One row per animal, one column per founder (an animal with no known
## parent): 1 where the founder is the animal or one of its ancestors. Every
## ancestor is a founder or has one above it, so two animals are related
## exactly when their rows share a column.
.founderAncestors <- function(id, sire, dam) {
  n <- length(id)
  si <- match(sire, id)
  di <- match(dam, id)
  founder <- is.na(si) & is.na(di)
  known <- c(!is.na(si), !is.na(di))
  parent <- Matrix::sparseMatrix(i = rep(seq_len(n), 2L)[known],
                                 j = c(si, di)[known], x = 1.0,
                                 dims = c(n, n))
  start <- Matrix::sparseMatrix(i = which(founder), j = seq_len(sum(founder)),
                                x = 1.0, dims = c(n, sum(founder)))
  reached <- start
  repeat {
    nxt <- start + parent %*% reached
    nxt@x[] <- 1.0
    if (Matrix::nnzero(nxt) == Matrix::nnzero(reached)) {
      return(nxt)
    }
    reached <- nxt
  }
}

## Animal v's relatives (itself included), from the related matrix.
.unrelatedNeighbours <- function(related, v) {
  related@i[(related@p[v] + 1L):related@p[v + 1L]] + 1L
}

## For each animal, how many of the given animals it is related to.
.unrelatedCount <- function(related, animals) {
  tabulate(c(integer(0L), unlist(lapply(animals, function(v) {
    .unrelatedNeighbours(related, v)
  }))), nrow(related))
}

## The pick: the animal related to the fewest still in play, ties to the
## first (the rows are in byte order of id); it and its relatives leave play.
.unrelatedPick <- function(related, inPlay = rep(TRUE, nrow(related))) {
  count <- .unrelatedCount(related, which(inPlay))
  picked <- integer(0L)
  repeat {
    left <- which(inPlay)
    if (length(left) == 0L) {
      return(picked)
    }
    v <- left[which.min(count[left])]
    picked <- c(picked, v)
    out <- .unrelatedNeighbours(related, v)
    out <- out[inPlay[out]]
    inPlay[out] <- FALSE
    count <- count - .unrelatedCount(related, out)
  }
}

## The swap pass: while a chosen animal has two left-out animals related to it
## and to no other chosen animal, and unrelated to each other, the first such
## pair takes its place and the pick adds any animal now related to none.
.unrelatedSwap <- function(related, picked) {
  inSet <- logical(nrow(related))
  inSet[picked] <- TRUE
  repeat {
    covered <- .unrelatedCount(related, which(inSet))
    swapped <- FALSE
    for (v in which(inSet)) {
      u <- .unrelatedNeighbours(related, v)
      u <- u[!inSet[u] & covered[u] == 1L]
      if (length(u) < 2L) {
        next
      }
      pairs <- which(!as.matrix(related[u, u, drop = FALSE]) &
                       upper.tri(diag(length(u))), arr.ind = TRUE)
      if (nrow(pairs) == 0L) {
        next
      }
      pairs <- pairs[order(pairs[, 1L], pairs[, 2L]), , drop = FALSE]
      inSet[v] <- FALSE
      inSet[u[pairs[1L, ]]] <- TRUE
      free <- .unrelatedCount(related, which(inSet)) == 0L
      inSet[.unrelatedPick(related, free)] <- TRUE
      swapped <- TRUE
      break
    }
    if (!swapped) {
      return(which(inSet))
    }
  }
}
