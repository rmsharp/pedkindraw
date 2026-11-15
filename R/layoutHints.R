## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 15a,
## rulings R60-R63, pedkindraw S22). New code (R3), written from kinship2's
## and Pedixplorer's help pages and the measurements of
## docs/planning/layout-hints-design.md, their source not read (R14). The
## layout's copied functions call these helpers from a few lines each
## (DIVERGENCE.md).

#' Check the hints given to makePedigreeMatingLayout()
#'
#' @param hints \code{NULL} or a list whose only element is \code{order}, a
#'   numeric vector named by animal id.
#' @param ids the ids of \code{ped}, every row's.
#' @return \code{NULL} when the hints ask for nothing (\code{NULL},
#'   \code{list()}, \code{order = NULL} or an empty \code{order}); otherwise
#'   \code{list(order = order)}. Stops on a hint it cannot use.
#' @noRd
.checkLayoutHints <- function(hints, ids) {
  if (is.null(hints)) {
    return(NULL)
  }
  if (!is.list(hints) || is.data.frame(hints)) {
    stop("makePedigreeMatingLayout() requires 'hints' to be NULL or a list ",
         "with the element 'order'.")
  }
  if (length(hints) == 0L) {
    return(NULL)
  }
  elementNames <- names(hints)
  if (is.null(elementNames) || anyNA(elementNames) ||
        !all(nzchar(elementNames))) {
    stop("makePedigreeMatingLayout() requires every element of 'hints' to ",
         "be named.")
  }
  unknown <- setdiff(elementNames, "order")
  if (length(unknown) > 0L) {
    stop("makePedigreeMatingLayout() does not know the 'hints' element(s): ",
         toString(unknown), ". Known: order.")
  }
  hintOrder <- hints$order
  if (is.null(hintOrder)) {
    return(NULL)
  }
  if (!is.numeric(hintOrder)) {
    stop("makePedigreeMatingLayout() requires 'hints$order' to be a ",
         "numeric vector named by animal id.")
  }
  if (length(hintOrder) == 0L) {
    return(NULL)
  }
  orderNames <- names(hintOrder)
  if (is.null(orderNames) || anyNA(orderNames) ||
        !all(nzchar(orderNames))) {
    stop("makePedigreeMatingLayout() requires every number in ",
         "'hints$order' to be named by an animal id.")
  }
  repeated <- unique(orderNames[duplicated(orderNames)])
  if (length(repeated) > 0L) {
    stop("makePedigreeMatingLayout() found id(s) named more than once in ",
         "'hints$order': ", toString(repeated))
  }
  absent <- setdiff(orderNames, as.character(ids))
  if (length(absent) > 0L) {
    stop("makePedigreeMatingLayout() found id(s) in 'hints$order' that are ",
         "not in 'ped': ", toString(absent))
  }
  if (anyNA(hintOrder)) {
    stop("makePedigreeMatingLayout() found NA in 'hints$order' for: ",
         toString(orderNames[is.na(hintOrder)]))
  }
  list(order = hintOrder)
}

#' Reorder the rows of ped by an order hint
#'
#' The layout reads left-to-right order from the rows of \code{ped}, so
#' sorting the rows sorts siblings and separate families. The named animals
#' trade places among their own rows, in increasing order of their numbers
#' (equal numbers keep their row order); every other row keeps its place.
#'
#' @param ped the pedigree data frame.
#' @param hintOrder a numeric vector named by ids of \code{ped}.
#' @return \code{ped} with its rows reordered.
#' @noRd
.layoutHintRows <- function(ped, hintOrder) {
  key <- unname(hintOrder[as.character(ped$id)])
  named <- which(!is.na(key))
  rows <- seq_len(nrow(ped))
  rows[named] <- named[order(key[named], named)]
  ped[rows, , drop = FALSE]
}

#' Does an order hint name a founder of this family?
#'
#' Where it does, the layout keeps the founder order the hint gives and
#' skips its own founder-reordering step (\code{.orderRootSubtrees()}).
#'
#' @param hintOrder \code{NULL} or a numeric vector named by id.
#' @param founderIds the family's founders (no known parent).
#' @return \code{TRUE} or \code{FALSE}.
#' @noRd
.layoutHintKeepsRoots <- function(hintOrder, founderIds) {
  !is.null(hintOrder) && any(founderIds %in% names(hintOrder))
}

#' Order a family's founder lines by an order hint
#'
#' A founder line is placed by its founder couple's female, as kinship2 and
#' Pedixplorer place founder couples ("the female founders are ordered as
#' though they were sisters"): a female's own number, or for a male the
#' smallest number among the female founders he has offspring with in the
#' matings he anchors, else his own. Lines with a number trade places among
#' themselves in increasing order (equal numbers keep their order); lines
#' without one keep their places.
#'
#' @param rootIds the family's founder lines, in row order.
#' @param hintOrder a numeric vector named by id.
#' @param matingUnits the family's mating-unit table.
#' @param founderIds the family's founders.
#' @param sexOf a character vector of sex codes named by id.
#' @return \code{rootIds} reordered.
#' @noRd
.layoutHintRoots <- function(rootIds, hintOrder, matingUnits, founderIds,
                             sexOf) {
  female <- sexCodes[["female"]]
  key <- vapply(rootIds, function(r) {
    own <- as.numeric(hintOrder[r])
    if (identical(unname(sexOf[r]), female)) {
      return(own)
    }
    anchored <- !is.na(matingUnits$anchor) & matingUnits$anchor == r
    mates <- intersect(matingUnits$nonAnchor[anchored], founderIds)
    mates <- mates[unname(sexOf[mates]) %in% female]
    numbers <- as.numeric(hintOrder[mates])
    numbers <- numbers[!is.na(numbers)]
    if (length(numbers) == 0L) own else min(numbers)
  }, numeric(1L), USE.NAMES = FALSE)
  keyed <- which(!is.na(key))
  lines <- seq_along(rootIds)
  lines[keyed] <- keyed[order(key[keyed], keyed)]
  rootIds[lines]
}
