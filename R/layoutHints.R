## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 15a,
## rulings R60-R63, pedkindraw S22; Phase 15b, the mate hint, pedkindraw
## S23). New code (R3), written from kinship2's and Pedixplorer's help pages
## and the measurements of docs/planning/layout-hints-design.md, their
## source not read (R14). The layout's copied functions call these helpers
## from a few lines each (DIVERGENCE.md).

#' Check the hints given to makePedigreeMatingLayout()
#'
#' @param hints \code{NULL} or a list with the elements \code{order} (a
#'   numeric vector named by animal id) and \code{mate} (a data frame with
#'   the columns \code{left}, \code{right} and \code{anchor}), either one
#'   or both.
#' @param ped the pedigree data frame, every row's (\code{id}, \code{sire},
#'   \code{dam}, \code{gen}).
#' @return \code{NULL} when the hints ask for nothing (\code{NULL},
#'   \code{list()}, or each element \code{NULL} or empty); otherwise
#'   \code{list(order = , mate = )}, an element \code{NULL} where it asks
#'   for nothing. Stops on a hint it cannot use.
#' @noRd
.checkLayoutHints <- function(hints, ped) {
  if (is.null(hints)) {
    return(NULL)
  }
  if (!is.list(hints) || is.data.frame(hints)) {
    stop("makePedigreeMatingLayout() requires 'hints' to be NULL or a list ",
         "with the elements 'order' and 'mate'.")
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
  unknown <- setdiff(elementNames, c("order", "mate"))
  if (length(unknown) > 0L) {
    stop("makePedigreeMatingLayout() does not know the 'hints' element(s): ",
         toString(unknown), ". Known: order, mate.")
  }
  hintOrder <- .checkLayoutHintOrder(hints$order, ped$id)
  hintMate <- .checkLayoutHintMate(hints$mate, ped)
  if (is.null(hintOrder) && is.null(hintMate)) {
    return(NULL)
  }
  list(order = hintOrder, mate = hintMate)
}

#' Check an order hint
#'
#' @param hintOrder \code{NULL} or a numeric vector named by animal id.
#' @param ids the ids of \code{ped}, every row's.
#' @return \code{NULL} when the order is \code{NULL} or empty, otherwise
#'   \code{hintOrder}. Stops on an order it cannot use.
#' @noRd
.checkLayoutHintOrder <- function(hintOrder, ids) {
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
  hintOrder
}

#' Check a mate hint
#'
#' Each row names a sire and dam with offspring together in \code{ped}, in
#' either column: \code{left} is drawn left of \code{right} at that
#' mating, and \code{anchor} (\code{"left"}, \code{"right"} or
#' \code{"either"}) names the partner whose own place the offspring hang
#' under.
#'
#' @param hintMate \code{NULL} or a data frame with the columns \code{left},
#'   \code{right} and \code{anchor}.
#' @param ped the pedigree data frame, every row's.
#' @return \code{NULL} when \code{hintMate} is \code{NULL} or has no rows,
#'   otherwise a data frame of the three columns as character. Stops on a
#'   row it cannot use.
#' @noRd
.checkLayoutHintMate <- function(hintMate, ped) {
  if (is.null(hintMate)) {
    return(NULL)
  }
  if (!is.data.frame(hintMate)) {
    stop("makePedigreeMatingLayout() requires 'hints$mate' to be a data ",
         "frame with the columns left, right and anchor.")
  }
  absentCols <- setdiff(c("left", "right", "anchor"), names(hintMate))
  if (length(absentCols) > 0L) {
    stop("makePedigreeMatingLayout() requires 'hints$mate' to have the ",
         "columns left, right and anchor. Missing: ", toString(absentCols))
  }
  if (nrow(hintMate) == 0L) {
    return(NULL)
  }
  left <- as.character(hintMate$left)
  right <- as.character(hintMate$right)
  anchor <- as.character(hintMate$anchor)
  if (anyNA(left) || anyNA(right)) {
    stop("makePedigreeMatingLayout() found NA in 'hints$mate' columns left ",
         "and right.")
  }
  same <- left == right
  if (any(same)) {
    stop("makePedigreeMatingLayout() found the same id as left and right ",
         "in 'hints$mate': ", toString(left[same]))
  }
  ids <- as.character(ped$id)
  absent <- setdiff(c(left, right), ids)
  if (length(absent) > 0L) {
    stop("makePedigreeMatingLayout() found id(s) in 'hints$mate' that are ",
         "not in 'ped': ", toString(unique(absent)))
  }
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  both <- !is.na(sire) & !is.na(dam)
  pairs <- c(paste(sire[both], dam[both], sep = "\u0001"),
             paste(dam[both], sire[both], sep = "\u0001"))
  together <- paste(left, right, sep = "\u0001") %in% pairs
  if (!all(together)) {
    stop("makePedigreeMatingLayout() found pair(s) in 'hints$mate' with no ",
         "offspring together in 'ped': ",
         toString(paste(left[!together], "and", right[!together])))
  }
  pairKey <- ifelse(left < right, paste(left, right, sep = "\u0001"),
                    paste(right, left, sep = "\u0001"))
  repeated <- duplicated(pairKey)
  if (any(repeated)) {
    stop("makePedigreeMatingLayout() found pair(s) named more than once in ",
         "'hints$mate': ",
         toString(paste(left[repeated], "and", right[repeated])))
  }
  badAnchor <- is.na(anchor) | !anchor %in% c("left", "right", "either")
  if (any(badAnchor)) {
    stop("makePedigreeMatingLayout() requires each 'hints$mate' anchor to ",
         "be \"left\", \"right\" or \"either\". Found: ",
         toString(unique(anchor[badAnchor])))
  }
  gen <- stats::setNames(ped$gen, ids)
  gen[is.na(gen)] <- 0L
  anchored <- ifelse(anchor == "left", left, right)
  other <- ifelse(anchor == "left", right, left)
  early <- anchor != "either" & gen[anchored] < gen[other]
  if (any(early)) {
    stop("makePedigreeMatingLayout() cannot anchor a mating on the partner ",
         "of the earlier generation (the layout draws a mating on the row ",
         "of its later partner); 'hints$mate' anchors: ",
         toString(paste0(anchored[early], " (generation ", gen[anchored[early]],
                         ") with ", other[early], " (generation ",
                         gen[other[early]], ")")))
  }
  data.frame(left = left, right = right, anchor = anchor,
             stringsAsFactors = FALSE)
}

#' Positions after numbered items trade places
#'
#' The items with a number trade places among their own positions, in
#' increasing order of their numbers (equal numbers keep their order); the
#' items without one keep their places.
#'
#' @param key a numeric vector, \code{NA} for an item without a number.
#' @return A permutation of \code{seq_along(key)}.
#' @noRd
.layoutHintPlaces <- function(key) {
  numbered <- which(!is.na(key))
  places <- seq_along(key)
  places[numbered] <- numbered[order(key[numbered], numbered)]
  places
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
  ped[.layoutHintPlaces(key), , drop = FALSE]
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
  rootIds[.layoutHintPlaces(key)]
}

#' The row of a mate hint that names a pair
#'
#' @param hintMate a checked mate hint (or \code{NULL}).
#' @param a,b the pair's ids, in either order.
#' @return The row number, or \code{NA} when no row names the pair.
#' @noRd
.layoutHintMateRow <- function(hintMate, a, b) {
  hit <- which((hintMate$left == a & hintMate$right == b) |
                 (hintMate$left == b & hintMate$right == a))
  if (length(hit) == 0L) NA_integer_ else hit[[1L]]
}

#' The partner a mate hint makes the anchor of a mating
#'
#' @param hintMate a checked mate hint (or \code{NULL}).
#' @param p1,p2 the mating's sire and dam.
#' @return The hinted anchor's id, or \code{NA} where no row names the pair
#'   or its anchor is \code{"either"}.
#' @noRd
.layoutHintAnchor <- function(hintMate, p1, p2) {
  if (is.null(hintMate)) {
    return(NA_character_)
  }
  i <- .layoutHintMateRow(hintMate, p1, p2)
  if (is.na(i) || hintMate$anchor[[i]] == "either") {
    return(NA_character_)
  }
  if (hintMate$anchor[[i]] == "left") {
    hintMate$left[[i]]
  } else {
    hintMate$right[[i]]
  }
}

#' Find an anchor's matings in a mate hint
#'
#' @param hintMate a checked mate hint.
#' @param matingUnits the mating-unit table.
#' @param unitIds the anchor's matings.
#' @param anchor the anchor's id.
#' @return A list: \code{row}, the hint's row naming each mating
#'   (\code{NA} where none), and \code{side}, the side its mate is drawn on
#'   relative to the anchor (-1 left, 1 right; \code{NA} where none).
#' @noRd
.layoutHintMatingSides <- function(hintMate, matingUnits, unitIds, anchor) {
  units <- matingUnits[match(unitIds, matingUnits$id), , drop = FALSE]
  hintRow <- vapply(seq_along(unitIds), function(k) {
    .layoutHintMateRow(hintMate, units$sire[[k]], units$dam[[k]])
  }, integer(1L))
  named <- !is.na(hintRow)
  side <- rep(NA_real_, length(unitIds))
  side[named] <- ifelse(hintMate$left[hintRow[named]] == anchor, 1.0, -1.0)
  list(row = hintRow, side = side)
}

#' The hinted sides of an anchor's mates
#'
#' For each of an anchor's matings, the side its mate is drawn on relative
#' to the anchor where a mate hint names the mating (-1 left, 1 right), and
#' a factor for the mate's distance from the anchor that draws mates on one
#' side left to right in the order of the hint's rows, unhinted mates
#' nearest the anchor, as kinship2 draws them.
#'
#' @param hintMate a checked mate hint (or \code{NULL}).
#' @param matingUnits the mating-unit table.
#' @param unitIds the anchor's matings, in the layout's order (by their
#'   offspring's position); the layout draws the first left and the second
#'   right, and leaves the side of a third or later to its fallback.
#' @param anchor the anchor's id.
#' @return A list: \code{side}, the hinted side per mating (\code{NA} where
#'   none), and \code{scale}, a factor per mating in (0, 1].
#' @noRd
.layoutHintSides <- function(hintMate, matingUnits, unitIds, anchor) {
  n <- length(unitIds)
  scale <- rep(1.0, n)
  if (is.null(hintMate)) {
    return(list(side = rep(NA_real_, n), scale = scale))
  }
  found <- .layoutHintMatingSides(hintMate, matingUnits, unitIds, anchor)
  side <- found$side
  hintRow <- found$row
  named <- !is.na(hintRow)
  if (n < 2L || !any(named)) {
    return(list(side = side, scale = scale))
  }
  layoutSide <- c(-1.0, 1.0, rep(0.0, n - 2L))
  drawnSide <- ifelse(named, side, layoutSide)
  for (s in c(-1.0, 1.0)) {
    onSide <- which(drawnSide == s)
    if (length(onSide) < 2L) next
    free <- onSide[!named[onSide]]
    hinted <- onSide[named[onSide]]
    hinted <- hinted[order(s * hintRow[hinted])]
    nearFirst <- c(free, hinted)
    scale[nearFirst] <- 3.0^(seq_along(nearFirst) - length(nearFirst))
  }
  list(side = side, scale = scale)
}

#' Order an anchor's families by a mate hint
#'
#' The offspring of an anchor's matings are drawn left to right in the
#' order of its matings; with a mate hint, the matings whose mate is hinted
#' to the left come first (in the order of the hint's rows), then the
#' unhinted ones (in their own order), then those hinted to the right (in
#' the order of the hint's rows), so the offspring follow their parents.
#'
#' @param hintMate a checked mate hint (or \code{NULL}).
#' @param matingUnits the mating-unit table.
#' @param unitIds the anchor's matings.
#' @param anchor the anchor's id.
#' @return \code{unitIds} reordered.
#' @noRd
.layoutHintFamilies <- function(hintMate, matingUnits, unitIds, anchor) {
  if (is.null(hintMate) || length(unitIds) < 2L) {
    return(unitIds)
  }
  found <- .layoutHintMatingSides(hintMate, matingUnits, unitIds, anchor)
  named <- !is.na(found$row)
  side <- ifelse(named, found$side, 0.0)
  unitIds[order(side, ifelse(named, found$row, 0L), seq_along(unitIds))]
}
