## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S60). The copied makePedigreeMatingLayout() checks its
## symbolSize argument with .checkSymbolSize() and gives each animal's node
## .symbolUnits() of it; the copied drawPedigreeDiagram() adds the points of
## .symbolSizeRoom() when an animal's symbol is smaller than full size
## (DIVERGENCE.md).

#' The size, in units, of an animal's symbol at symbolSize 1
#'
#' Phase G14 (R140). The size every animal's node had before Phase G14; the
#' marks' places and the room builders' shifts were measured at it.
#' @noRd
.fullSymbolSize <- 25L

#' Stop on a symbolSize that is not one positive number
#'
#' Phase G14 (R140). \code{symbolSize} is a multiple of the full size, as
#' kinship2's and Pedixplorer's \code{symbolsize} are; neither sets an upper
#' limit, and neither does this.
#' @param x the argument.
#' @param caller the name of the function whose argument it is, for the
#'   message.
#' @return \code{NULL}, invisibly; stops otherwise.
#' @noRd
.checkSymbolSize <- function(x, caller) {
  ok <- is.numeric(x) && length(x) == 1L && is.finite(x) && x > 0.0
  if (!ok) {
    stop(caller, "() requires 'symbolSize' to be one positive number.",
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
