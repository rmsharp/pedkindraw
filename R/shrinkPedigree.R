## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/shrinkPedigree.R at nprcgenekeepr commit
## baef1e12c, its clean-room rewrite (plan C2). Changes: help text only; the
## code is unchanged. The example types its own pedigree (the values of
## nprcgenekeepr's lacy1989Ped) instead of loading nprcgenekeepr (the
## source's lines 209-210; plan R21). Its comments name nprcgenekeepr's
## specification, cleanroom/spec/C/SPEC.md.

## Written from the specification cleanroom/spec/C/SPEC.md (the clean-room
## rewrite); "SPEC.md" below is that file.

## The bit size of the present rows: 2 per non-founder less 1 per founder,
## an integer. sireIdx and damIdx are the parents' row positions (NA when
## unknown) and present marks the rows still in the pedigree.
.bitSize <- function(sireIdx, damIdx, present) {
  founder <- is.na(sireIdx[present]) & is.na(damIdx[present])
  as.integer(2L * sum(!founder) - sum(founder))
}

## Which rows are parents of a present row: a logical vector over all rows.
.isParent <- function(sireIdx, damIdx, present) {
  parent <- logical(length(present))
  parents <- c(sireIdx[present], damIdx[present])
  parent[parents[!is.na(parents)]] <- TRUE
  parent & present
}

## The removal pass of SPEC.md on rows given by their parents' positions:
## returns a list of present, sireIdx and damIdx after the pass (promoted
## offspring with both parents NA) and removed, the positions of the rows
## removed, in the order removed.
.removalPass <- function(sireIdx, damIdx, present, avail) {
  removed <- integer(0L)
  ## 1. unavailable leaves, until there is none
  repeat {
    leaves <- which(present & !avail &
                      !.isParent(sireIdx, damIdx, present))
    if (length(leaves) == 0L) break
    present[leaves] <- FALSE
    removed <- c(removed, leaves)
  }
  ## 2. couples, listed and qualified once
  both <- which(present & !is.na(sireIdx) & !is.na(damIdx))
  if (length(both) > 0L) {
    key <- paste(sireIdx[both], damIdx[both])
    first <- !duplicated(key)
    coupleSire <- sireIdx[both][first]
    coupleDam <- damIdx[both][first]
    nChildren <- tabulate(match(key, key[first]), sum(first))
    sireCount <- tabulate(match(coupleSire, coupleSire), length(coupleSire))
    damCount <- tabulate(match(coupleDam, coupleDam), length(coupleDam))
    qualify <- which(nChildren == 1L &
                       sireCount[match(coupleSire, coupleSire)] == 1L &
                       damCount[match(coupleDam, coupleDam)] == 1L)
    child <- both[first]
    for (j in qualify) {
      s <- coupleSire[j]
      d <- coupleDam[j]
      founders <- is.na(sireIdx[c(s, d)]) & is.na(damIdx[c(s, d)])
      if (all(founders) && !avail[s] && !avail[d]) {
        sireIdx[child[j]] <- NA_integer_
        damIdx[child[j]] <- NA_integer_
        present[c(s, d)] <- FALSE
        removed <- c(removed, s, d)
      }
    }
  }
  ## 3. childless founders, once
  childless <- which(present & is.na(sireIdx) & is.na(damIdx) &
                       !.isParent(sireIdx, damIdx, present))
  present[childless] <- FALSE
  list(present = present, sireIdx = sireIdx, damIdx = damIdx,
       removed = c(removed, childless))
}

## Stops with SPEC.md's message for the first check the input fails;
## returns list(genotyped, affected) read as logical vectors.
.checkShrinkInput <- function(ped, genotyped, affected, maxBits) {
  missingCols <- setdiff(c("id", "sire", "dam"), names(ped))
  if (length(missingCols) > 0L) {
    stop("Pedigree is missing ", toString(missingCols), call. = FALSE)
  }
  if (!is.data.frame(ped)) stop("ped must be a data frame", call. = FALSE)
  n <- nrow(ped)
  if (length(genotyped) != n) {
    stop("genotyped must be the same length as nrow(ped) (", n, ")",
         call. = FALSE)
  }
  genotyped <- as.logical(genotyped)
  if (anyNA(genotyped)) {
    stop("NA values not allowed in genotyped vector.", call. = FALSE)
  }
  if (is.null(affected)) affected <- ped[["affected"]]
  if (is.null(affected)) affected <- rep(FALSE, n)
  if (length(affected) != n) {
    stop("affected must be the same length as nrow(ped) (", n, ")",
         call. = FALSE)
  }
  affected <- suppressWarnings(as.logical(affected))
  if (!is.numeric(maxBits) || length(maxBits) != 1L || is.na(maxBits)) {
    stop("maxBits must be one number", call. = FALSE)
  }
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  if (anyNA(id) || !all(nzchar(id))) {
    stop("No id may be missing or empty", call. = FALSE)
  }
  if (anyDuplicated(id) > 0L) stop("No id may appear twice", call. = FALSE)
  parents <- c(sire, dam)
  if (!all(parents[!is.na(parents)] %in% id)) {
    stop("Every sire and dam must be NA or an id in ped", call. = FALSE)
  }
  if (length(intersect(sire[!is.na(sire)], dam[!is.na(dam)])) > 0L) {
    stop("An animal cannot be both a sire and a dam", call. = FALSE)
  }
  list(genotyped = genotyped, affected = affected)
}

#' Shrink a pedigree to fit within a bit-size budget
#'
#' Trims a pedigree down to the individuals needed to keep it genetically
#' informative within a genotyping-cost budget (\code{maxBits}), given which
#' individuals are genotyped (\code{genotyped}) and, optionally, which are
#' affected by a trait of interest (\code{affected}). It follows the method
#' of \code{kinship2::pedigree.shrink()}, working on this package's
#' \code{id}/\code{sire}/\code{dam} data-frame pedigree. Three tiers are
#' applied in order:
#' \enumerate{
#'   \item \strong{Unavailable trim.} Iteratively removes terminal (leaf)
#'   individuals who are not genotyped, then removes any founder couple
#'   with exactly one child together and no other mate, when both parents
#'   are themselves founders and neither is genotyped (the couple's shared
#'   child is promoted to founder status rather than removed), then removes
#'   any remaining childless founder ("stray marry-in") \emph{regardless of
#'   genotyped status}.
#'   \item \strong{Non-informative trim.} Removes a genotyped, non-parent
#'   individual whose own \code{sire} and \code{dam} are both known and both
#'   genotyped, when the individual is not \code{affected} (an \code{NA}
#'   \code{affected} status counts as unaffected here) -- they add no
#'   genotype information beyond what their parents already supply. An
#'   individual with only one known parent (one of \code{sire}/\code{dam}
#'   known, the other \code{NA}) is never trimmed by this tier. Such partial
#'   parentage is ordinary data in this package (see
#'   \code{\link{getIdsWithOneParent}}), whereas kinship2 does not allow it.
#'   \item \strong{Affected-priority trim.} While the pedigree's bit size
#'   (\code{2 * nNonFounder - nFounder}) still exceeds \code{maxBits},
#'   removes one genotyped, non-parent individual at a time -- trying
#'   \code{NA}-affected candidates first, then unaffected, then affected --
#'   choosing whichever single candidate's removal (including any cascade
#'   through tiers 1-2 above) minimizes the resulting bit size. Ties go to
#'   the first \code{id} in byte order (capitals before lower case, as
#'   \code{sort(method = "radix")} orders text), whatever the computer's
#'   language setting, so the same input always gives the same answer
#'   (kinship2 breaks ties at random). \code{idTrimmed} and
#'   \code{idList$affected} record every id
#'   actually removed each round, including those removed by a cascade, so
#'   \code{pedSizeOriginal - pedSizeFinal} always equals
#'   \code{length(idTrimmed)}.
#' }
#'
#' A fully genotyped pedigree can shrink to zero rows (see the example).
#'
#' It stops with a plain message when \code{ped} is not a data frame, when
#' an \code{id} is missing, empty or repeated, when a \code{sire} or
#' \code{dam} is not an \code{id} of \code{ped}, when an animal is both a
#' sire and a dam, or when \code{maxBits} is not one number.
#'
#' @param ped a pedigree \code{data.frame}. The fields \code{id},
#' \code{sire} and \code{dam} are required; an optional \code{affected}
#' logical column is used as the default source for \code{affected} (see
#' below). \code{sire}/\code{dam} are \code{NA} for a founder, and may be
#' \code{NA} for only one of the two (partial parentage) -- see the
#' non-informative-trim tier above for how that case is handled.
#' @param genotyped a logical vector, the same length as \code{nrow(ped)}
#' and in the same row order, \code{TRUE} where a genotype (or other
#' available biological sample) exists for that individual. \code{NA} is
#' not allowed, matching kinship2's own \code{avail} validation.
#' @param affected \code{NULL} (default) or a logical vector the same
#' length as \code{nrow(ped)}. When \code{NULL}, defaults to \code{ped$affected}
#' if that column exists, or to all-\code{FALSE} (unaffected) if it does
#' not -- ensuring the affected-priority trim can always make progress even
#' with no recorded affected status.
#' @param maxBits numeric, default \code{16L}. The bit-size budget the
#' affected-priority trim reduces toward.
#'
#' @return A list:
#' \describe{
#'   \item{ped}{The shrunk pedigree \code{data.frame}, with all of
#'   \code{ped}'s original columns; a promoted founder's \code{sire}/
#'   \code{dam} are set to \code{NA}.}
#'   \item{idTrimmed}{Character vector, every \code{id} removed, in removal
#'   order.}
#'   \item{idList}{A list with elements \code{unavail}, \code{noninform}
#'   and \code{affected} -- character vectors (\code{character(0)} when
#'   empty) grouping \code{idTrimmed} by which tier removed each id.}
#'   \item{bitSize}{Numeric vector: the pedigree's bit size before any
#'   trimming, after tiers 1-2, then one further value per affected-
#'   priority round.}
#'   \item{genotyped}{The final \code{genotyped} vector, aligned to
#'   \code{ped$id}.}
#'   \item{pedSizeOriginal, pedSizeIntermed, pedSizeFinal}{Integer row
#'   counts: original, after tiers 1-2, and final.}
#' }
#'
#' @seealso \code{\link{isFounder}}, \code{\link{getIdsWithOneParent}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#' @references \url{https://cran.r-project.org/package=kinship2}
#'
#' @export
#' @examples
#' ## Seven animals: C and D are full siblings, and so are F and G, D's
#' ## offspring
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' genotyped <- rep(TRUE, nrow(ped))
#' result <- shrinkPedigree(ped, genotyped, maxBits = 16L)
#' nrow(ped)
#' ## With every individual genotyped, the whole pedigree can be trimmed away.
#' nrow(result$ped)
## The pedigree trimmed to the animals that keep it informative, with the
## ids removed by each trim, the bit sizes and the pedigree sizes (SPEC.md).
shrinkPedigree <- function(ped, genotyped, affected = NULL, maxBits = 16L) {
  read <- .checkShrinkInput(ped, genotyped, affected, maxBits)
  genotyped <- read$genotyped
  affected <- read$affected
  p <- ped
  p$id <- as.character(p$id)
  p$sire <- as.character(p$sire)
  p$dam <- as.character(p$dam)
  id <- p$id
  n <- length(id)
  state <- list(present = rep(TRUE, n), sireIdx = match(p$sire, id),
                damIdx = match(p$dam, id), removed = integer(0L))
  bitSize <- .bitSize(state$sireIdx, state$damIdx, state$present)

  ## first trim
  state <- .removalPass(state$sireIdx, state$damIdx, state$present,
                        genotyped)
  unavail <- state$removed

  ## second trim
  noninform <- integer(0L)
  while (any(state$present)) {
    leaf <- state$present &
      !.isParent(state$sireIdx, state$damIdx, state$present)
    parentsAvail <- !is.na(state$sireIdx) & !is.na(state$damIdx) &
      genotyped[state$sireIdx] & genotyped[state$damIdx]
    parentsAvail[is.na(parentsAvail)] <- FALSE
    hide <- leaf & genotyped & (is.na(affected) | !affected) & parentsAvail
    state <- .removalPass(state$sireIdx, state$damIdx, state$present,
                          genotyped & !hide)
    if (length(state$removed) == 0L) break
    noninform <- c(noninform, state$removed)
  }
  pedSizeIntermed <- sum(state$present)
  bitSize <- c(bitSize, .bitSize(state$sireIdx, state$damIdx, state$present))

  ## third trim
  third <- integer(0L)
  while (bitSize[length(bitSize)] > maxBits && any(state$present)) {
    candidate <- state$present & genotyped &
      !.isParent(state$sireIdx, state$damIdx, state$present)
    known <- !is.na(affected)
    tiers <- list(!known, known & !affected, known & affected)
    pool <- integer(0L)
    for (tier in tiers) {
      pool <- which(candidate & tier)
      if (length(pool) > 0L) break
    }
    if (length(pool) == 0L) break
    pool <- pool[order(id[pool], method = "radix")]
    best <- NULL
    bestSize <- NA_integer_
    for (k in pool) {
      avail <- genotyped
      avail[k] <- FALSE
      trial <- .removalPass(state$sireIdx, state$damIdx, state$present,
                            avail)
      size <- .bitSize(trial$sireIdx, trial$damIdx, trial$present)
      if (is.null(best) || size < bestSize) {
        best <- trial
        bestSize <- size
      }
    }
    state <- best
    third <- c(third, best$removed)
    bitSize <- c(bitSize, bestSize)
  }

  keep <- which(state$present)
  promoted <- is.na(state$sireIdx) & is.na(state$damIdx)
  p$sire[promoted] <- NA_character_
  p$dam[promoted] <- NA_character_
  keptGenotyped <- genotyped[keep]
  names(keptGenotyped) <- id[keep]
  list(
    ped = p[keep, , drop = FALSE],
    idTrimmed = id[c(unavail, noninform, third)],
    idList = list(unavail = id[unavail], noninform = id[noninform],
                  affected = id[third]),
    bitSize = bitSize,
    genotyped = keptGenotyped,
    pedSizeOriginal = n,
    pedSizeIntermed = pedSizeIntermed,
    pedSizeFinal = length(keep)
  )
}
