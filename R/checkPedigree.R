## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 13,
## rulings R49-R51, pedkindraw S17). New code (R9), derived from no other
## package.

#' Check a pedigree for problems
#'
#' Lists each problem found in a pedigree, one row per problem id, and changes
#' nothing. Repairing a problem is left to the user: \code{\link{addParents}}
#' adds a row for each parent that has none, and \code{\link{correctParentSex}}
#' sets the sex of a male dam or a female sire.
#'
#' The checks, in the order their rows come:
#' \describe{
#'   \item{\code{missingIds}}{an id that is \code{NA}, empty or spaces only;
#'   one row per such row of \code{ped}, in row order.}
#'   \item{\code{duplicateIds}}{an id on more than one row.}
#'   \item{\code{ownParent}}{an animal that is its own sire or dam.}
#'   \item{\code{cycle}}{an animal that is its own ancestor through at least
#'   one other animal; \code{detail} names the other animals that are both its
#'   ancestors and its descendants.}
#'   \item{\code{rowlessParents}}{a sire or dam that has no row of its own.}
#'   \item{\code{missingParentCodes}}{\code{"0"}, \code{"NA"}, or an empty or
#'   spaces-only value used for an unknown parent, which should be \code{NA}.
#'   Such a value that is also the id of a row is a real parent.}
#'   \item{\code{maleDams}}{a dam whose sex is \code{M}.}
#'   \item{\code{femaleSires}}{a sire whose sex is \code{F}.}
#'   \item{\code{unknownSexParents}}{a sire or dam whose sex is \code{U} or
#'   \code{NA}.}
#'   \item{\code{sireAndDam}}{one id used both as a sire and as a dam.}
#'   \item{\code{sexCodes}}{a sex other than \code{M}, \code{F}, \code{H},
#'   \code{U} or \code{NA}, such as \code{"male"}; one row per such row of
#'   \code{ped}, in row order. Such an animal gets no other sex check.}
#' }
#' Within a check the ids come in byte order (capitals before lower case),
#' except where row order is stated. An animal can appear under several
#' checks. A parent's sex is the sex on its first row, and the four sex checks
#' run only when \code{ped} has a \code{sex} column. For a parent, \code{detail}
#' lists its offspring, ten at most and then a count ("sire of B, C; dam of
#' D").
#'
#' Not reported, because they are legal here: one known parent, an animal of
#' unknown sex that is no parent, a hermaphrodite (\code{H}), and number ids.
#'
#' On the seeded random pedigrees its tests compare with kinship2 1.9.6.2's
#' \code{pedigree()}, it names the problem wherever kinship2 refuses the
#' pedigree, and none of the problems kinship2 refuses wherever kinship2
#' accepts it; cases with one known parent, a hermaphrodite parent or a sex
#' other than \code{M}, \code{F}, \code{H} and \code{U} are set aside. In the
#' cases measured before it was written, kinship2 accepted cycles, an animal
#' that is its own parent and \code{""} for an unknown parent, which are
#' reported here, and refused one known parent and a hermaphrodite parent,
#' which are not.
#'
#' @param ped a data frame with the columns \code{id}, \code{sire} and
#' \code{dam} (an unknown parent is \code{NA}) and optionally \code{sex}
#' (\code{M}, \code{F}, \code{H} or \code{U}). Factor columns are read by
#' their labels and numbers as text; other columns are not read.
#' @return A data frame with the character columns \code{check} (the name of
#' the check), \code{id} (the animal, parent id or code the problem is about)
#' and \code{detail} (what was found), one row per problem id; zero rows when
#' no problem is found.
#'
#' @seealso \code{\link{addParents}}, \code{\link{correctParentSex}}
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("s1", "d1", "o1", "o2", "o2"),
#'   sire = c(NA, NA, "s1", "s9", "s1"),
#'   dam = c(NA, "0", "d1", "d1", "d1"),
#'   sex = c("F", "F", "M", "F", "F")
#' )
#' checkPedigree(ped)
#' ## A pedigree without problems gives zero rows.
#' checkPedigree(data.frame(id = c("s", "d", "o"), sire = c(NA, NA, "s"),
#'                          dam = c(NA, NA, "d")))
checkPedigree <- function(ped) {
  if (!is.data.frame(ped)) {
    stop("checkPedigree: ped must be a data frame", call. = FALSE)
  }
  lacking <- setdiff(c("id", "sire", "dam"), names(ped))
  if (length(lacking) > 0L) {
    stop("checkPedigree: ped lacks the column(s) ", toString(lacking),
         call. = FALSE)
  }
  id <- as.character(ped[["id"]])
  sire <- as.character(ped[["sire"]])
  dam <- as.character(ped[["dam"]])
  missingId <- is.na(id) | !nzchar(trimws(id))
  ids <- unique(id[!missingId])
  isCode <- !is.na(c(sire, dam)) & !(c(sire, dam) %in% ids) &
    (c(sire, dam) %in% c("0", "NA") | !nzchar(trimws(c(sire, dam))))
  codes <- unique(c(sire, dam)[isCode])
  parents <- unique(c(sire, dam)[!is.na(c(sire, dam)) & !isCode])
  sires <- unique(sire[sire %in% ids])
  dams <- unique(dam[dam %in% ids])
  offspring <- function(x) .checkOffspring(x, id, sire, dam)

  ownSire <- !missingId & !is.na(sire) & sire == id
  ownDam <- !missingId & !is.na(dam) & dam == id
  own <- .checkSorted(id[ownSire | ownDam])
  duplicates <- .checkSorted(id[!missingId][duplicated(id[!missingId])])
  linked <- function(parent) !missingId & parent %in% ids & parent != id
  cycles <- .checkCycles(c(id[linked(sire)], id[linked(dam)]),
                         c(sire[linked(sire)], dam[linked(dam)]))
  rowless <- .checkSorted(parents[!(parents %in% ids)])
  codes <- .checkSorted(codes)
  sireAndDam <- .checkSorted(intersect(sire[sire %in% parents],
                                       dam[dam %in% parents]))

  rows <- list(
    .checkRows("missingIds", id[missingId],
               paste("row", which(missingId))),
    .checkRows("duplicateIds", duplicates, vapply(duplicates, function(x) {
      paste("rows", toString(which(id == x)))
    }, character(1L), USE.NAMES = FALSE)),
    .checkRows("ownParent", own, vapply(own, function(x) {
      role <- any(ownSire[id %in% x]) + 2L * any(ownDam[id %in% x])
      paste("its own", c("sire", "dam", "sire and dam")[role])
    }, character(1L), USE.NAMES = FALSE)),
    .checkRows("cycle", names(cycles), unname(cycles)),
    .checkRows("rowlessParents", rowless, offspring(rowless)),
    .checkRows("missingParentCodes", codes, offspring(codes))
  )
  if ("sex" %in% names(ped)) {
    sex <- as.character(ped[["sex"]])
    firstSex <- function(x) sex[match(x, id)]
    maleDams <- .checkSorted(dams[firstSex(dams) %in% sexCodes[["male"]]])
    femaleSires <- .checkSorted(
      sires[firstSex(sires) %in% sexCodes[["female"]]]
    )
    rowParents <- unique(c(sires, dams))
    unknown <- .checkSorted(rowParents[is.na(firstSex(rowParents)) |
      firstSex(rowParents) %in% sexCodes[["unknown"]]])
    rows <- c(rows, list(
      .checkRows("maleDams", maleDams, offspring(maleDams)),
      .checkRows("femaleSires", femaleSires, offspring(femaleSires)),
      .checkRows("unknownSexParents", unknown, offspring(unknown))
    ))
  }
  rows <- c(rows, list(
    .checkRows("sireAndDam", sireAndDam, offspring(sireAndDam))
  ))
  if ("sex" %in% names(ped)) {
    odd <- !is.na(sex) & !(sex %in% sexCodes)
    rows <- c(rows, list(.checkRows(
      "sexCodes", id[odd], sprintf("sex \"%s\" in row %d", sex[odd],
                                   which(odd))
    )))
  }
  result <- do.call(rbind, rows)
  rownames(result) <- NULL
  result
}

## The rows of one check: a data frame of check, id and detail, with zero rows
## when no id is given.
.checkRows <- function(check, ids, detail) {
  if (length(ids) == 0L) {
    detail <- character(0L)
  }
  data.frame(check = rep(check, length(ids)), id = as.character(ids),
             detail = detail, stringsAsFactors = FALSE)
}

## The values once each, in byte order (capitals before lower case).
.checkSorted <- function(x) sort(unique(x), method = "radix")

## The values once each, as one string separated by commas: the first 10 and,
## when there are more, how many more.
.checkListed <- function(x) {
  x <- unique(x)
  if (length(x) <= 10L) {
    return(toString(x))
  }
  paste(toString(x[seq_len(10L)]), "and", length(x) - 10L, "more")
}

## For each parent value, the offspring it is sire and dam of
## ("sire of B, C; dam of D").
.checkOffspring <- function(parents, id, sire, dam) {
  ofSire <- split(id[sire %in% parents], sire[sire %in% parents])
  ofDam <- split(id[dam %in% parents], dam[dam %in% parents])
  listed <- function(groups, x, role) {
    i <- match(x, names(groups))
    if (is.na(i)) NULL else paste(role, .checkListed(groups[[i]]))
  }
  vapply(parents, function(x) {
    paste(c(listed(ofSire, x, "sire of"), listed(ofDam, x, "dam of")),
          collapse = "; ")
  }, character(1L), USE.NAMES = FALSE)
}

## The animals that are their own ancestor through another animal, given each
## link from a child to a parent (both with a row, a parent never its child).
## Animals without a parent or without a child among those left are dropped
## until none is; each animal left is checked by following its parents. The
## result is named by the animals, in byte order, and says which other animals
## are both their ancestors and their descendants.
.checkCycles <- function(child, parent) {
  left <- unique(c(child, parent))
  keep <- rep(TRUE, length(child))
  repeat {
    inCycle <- intersect(child[keep], parent[keep])
    if (length(inCycle) == length(left)) break
    left <- inCycle
    keep <- keep & child %in% left & parent %in% left
  }
  child <- child[keep]
  parent <- parent[keep]
  reached <- function(start, from, to) {
    found <- character(0L)
    front <- start
    repeat {
      nxt <- setdiff(unique(to[from %in% front]), found)
      if (length(nxt) == 0L) {
        return(found)
      }
      found <- c(found, nxt)
      front <- nxt
    }
  }
  result <- character(0L)
  for (x in .checkSorted(left)) {
    ancestors <- reached(x, child, parent)
    if (x %in% ancestors) {
      others <- setdiff(intersect(ancestors, reached(x, parent, child)), x)
      result[[x]] <- paste("its own ancestor through",
                           .checkListed(.checkSorted(others)))
    }
  }
  result
}
