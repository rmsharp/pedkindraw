## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S60). The copied makePedigreeMatingLayout() checks its
## symbolSize and textSize arguments with .checkPositiveNumber() and gives
## each animal's node .symbolUnits() of symbolSize; the copied
## drawPedigreeDiagram() adds the points of .symbolSizeRoom() when an
## animal's symbol is smaller than full size (DIVERGENCE.md). S60's REFACTOR
## added .sizedIdDown(), the move of an id below a mark, which
## .infertileRoom() (R/infertileMark.R) and .miscarriageRoom()
## (R/miscarriageMark.R) had each written out. S61's REFACTOR added
## .checkPositiveNumber(), where .checkSymbolSize() and R/textSize.R's
## .checkTextSize() each checked one setting.

#' The size, in units, of an animal's symbol at symbolSize 1
#'
#' Phase G14 (R140). The size every animal's node had before Phase G14; the
#' marks' places and the room builders' shifts were measured at it.
#' @noRd
.fullSymbolSize <- 25L

#' Stop on a size setting that is not one positive number
#'
#' Phase G14 (R140). Each size setting (\code{symbolSize}, \code{textSize})
#' is a multiple of the size drawn before it, as kinship2's and
#' Pedixplorer's \code{symbolsize} and \code{cex} are; neither sets an upper
#' limit, and neither does this. S61's REFACTOR: \code{.checkSymbolSize()}
#' and \code{.checkTextSize()} had the same lines.
#' @param x the argument.
#' @param name the argument's name, for the message.
#' @param caller the name of the function whose argument it is, for the
#'   message.
#' @return \code{NULL}, invisibly; stops otherwise.
#' @noRd
.checkPositiveNumber <- function(x, name, caller) {
  ok <- is.numeric(x) && length(x) == 1L && is.finite(x) && x > 0.0
  if (!ok) {
    stop(caller, "() requires '", name, "' to be one positive number.",
         call. = FALSE)
  }
  invisible(NULL)
}

#' An animal's node size, in whole units, at a symbolSize
#'
#' Phase G14 (R140). \code{.fullSymbolSize} times \code{symbolSize}, rounded
#' to a whole unit and at least 1, so the node's size stays an integer, as it
#' was, and 1 gives the full size exactly.
#' @param symbolSize one positive number.
#' @return One integer.
#' @noRd
.symbolUnits <- function(symbolSize) {
  max(1L, as.integer(round(.fullSymbolSize * symbolSize)))
}

#' How far an id moves down at its node's size
#'
#' Phase G14 (R140). A mark's id move, measured at a full-size symbol
#' (\code{.infertileMark$idDown}, \code{.miscarriageMark$idDown}), is taken
#' in proportion to each node's size and rounded to a whole unit, so the id
#' clears a mark drawn in units of that size. S60's REFACTOR:
#' \code{.infertileRoom()} and \code{.miscarriageRoom()} had the same line.
#' @param idDown the move at a full-size symbol, in units.
#' @param size the nodes' sizes.
#' @return An integer vector, one per size.
#' @noRd
.sizedIdDown <- function(idDown, size) {
  as.integer(round(idDown * size / .fullSymbolSize))
}

#' Invisible points that keep a full-size symbol's room
#'
#' Phase G14 (R140). vis.js fits its view to the nodes' shapes, not to the
#' overhang of their labels (gaps plan dragon 57), so with symbols smaller
#' than full size the long ids at the drawing's edges were cut off (measured
#' S60, 4-5 pixels at symbolSize 0.6 in a 500-pixel drawing). Each animal's
#' node (a real id's or a repeat appearance's) smaller than
#' \code{.fullSymbolSize} gets two invisible points where a full-size
#' triangle's lower corners are, so the fit is at least as for full-size
#' symbols. The points are built by \code{.markRoom()}; their ids are
#' \code{"__size_l_"} and \code{"__size_r_"} and the node's id, a prefix the
#' layout reserves (\code{.reservedIdPrefixes}).
#' @param nodes the nodes to draw.
#' @return \code{nodes} with two more rows per animal smaller than full size;
#'   \code{nodes} itself when there is none.
#' @noRd
.symbolSizeRoom <- function(nodes) {
  animal <- !grepl(.reservedIdPattern, nodes$id) |
    startsWith(nodes$id, "__dup_")
  small <- animal & nodes$size < .fullSymbolSize
  half <- 1.15 * .fullSymbolSize
  out <- .markRoom(nodes, small, "__size_l_", c(0.0, 0.0),
                   c(-half, .fullSymbolSize))
  .markRoom(out, c(small, logical(nrow(out) - nrow(nodes))), "__size_r_",
            c(0.0, 0.0), c(half, .fullSymbolSize))
}
