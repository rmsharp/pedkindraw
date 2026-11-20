## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S61). The copied makePedigreeMatingLayout() checks its
## textSize argument with .checkTextSize() and, when .textPixels() of it is
## not vis.js's 14, gives every node that font.size; .infertileRoom()
## (R/infertileMark.R) and .miscarriageRoom() (R/miscarriageMark.R) keep a
## moved id's room by .idLabelDepth(); the copied drawPedigreeDiagram() adds
## the points of .textSizeRoom() when the text is larger than vis.js's 14
## (DIVERGENCE.md).

#' The size, in pixels, of the animals' ids and names at textSize 1
#'
#' Phase G14 (R140). vis.js's own font size, which every label had before
#' Phase G14; the room builders' allowance for an id was measured at it.
#' @noRd
.fullTextSize <- 14L

#' Stop on a textSize that is not one positive number
#'
#' Phase G14 (R140). \code{textSize} is a multiple of vis.js's 14 pixels, as
#' kinship2's and Pedixplorer's \code{cex} is of their text; neither sets an
#' upper limit, and neither does this.
#' @param x the argument.
#' @param caller the name of the function whose argument it is, for the
#'   message.
#' @return \code{NULL}, invisibly; stops otherwise.
#' @noRd
.checkTextSize <- function(x, caller) {
  ok <- is.numeric(x) && length(x) == 1L && is.finite(x) && x > 0.0
  if (!ok) {
    stop(caller, "() requires 'textSize' to be one positive number.",
         call. = FALSE)
  }
  invisible(NULL)
}

#' The ids' and names' size, in whole pixels, at a textSize
#'
#' Phase G14 (R140). \code{.fullTextSize} times \code{textSize}, rounded to
#' a whole pixel and at least 1, so 1 gives vis.js's 14 exactly.
#' @param textSize one positive number.
#' @return One integer.
#' @noRd
.textPixels <- function(textSize) {
  max(1L, as.integer(round(.fullTextSize * textSize)))
}

#' Each node's text size, in pixels
#'
#' Phase G14 (R140).
#' @param nodes the nodes to draw.
#' @return One number per node: its \code{font.size}, or \code{.fullTextSize}
#'   for every node when they have none.
#' @noRd
.nodeTextPixels <- function(nodes) {
  px <- nodes[["font.size"]]
  if (is.null(px)) rep(.fullTextSize, nrow(nodes)) else px
}

#' How far below its symbol an id's line of text reaches
#'
#' Phase G14 (R140). vis.js writes a node's label under its shape, the top
#' of the label half its font size and 4 pixels below the shape, each line
#' its font size tall (measured S61 in headless Chrome, its label box at 7
#' to 28 pixels, in every shape and at several sizes), so one line reaches
#' 4 plus 1.5 times the font size below the symbol: 25 units at vis.js's
#' 14, the allowance \code{.infertileRoom()} and \code{.miscarriageRoom()}
#' had before Phase G14.
#' @param px the text size, in pixels.
#' @return The depth, in units, one per size.
#' @noRd
.idLabelDepth <- function(px) {
  4.0 + 1.5 * px
}

#' The widths of the characters vis.js writes, in ems
#'
#' Phase G14 (R140). vis.js writes the labels in Arial, whose widths are
#' Helvetica's; R ships Helvetica's font metrics
#' (\code{grDevices}' \file{afm/Helvetica.afm.gz}), read here for the
#' printable ASCII characters (S61: the widths of 132 labels, 7 to 28
#' pixels, within 0.05 pixels of vis.js's own in headless Chrome).
#' @noRd
.labelCharWidths <- local({
  afm <- readLines(system.file("afm", "Helvetica.afm.gz",
                               package = "grDevices"))
  chars <- grep("^C [0-9]+ ;", afm, value = TRUE, useBytes = TRUE)
  code <- as.integer(sub("^C ([0-9]+) ;.*", "\\1", chars, useBytes = TRUE))
  wx <- as.numeric(sub(".*; WX ([0-9]+) ;.*", "\\1", chars, useBytes = TRUE))
  ascii <- code >= 32L & code <= 126L
  stats::setNames(wx[ascii] / 1000.0,
                  intToUtf8(code[ascii], multiple = TRUE))
})

#' The width of each label's widest line, in pixels
#'
#' Phase G14 (R140). The sum of its characters' widths
#' (\code{.labelCharWidths}), one em for a character not there (wider than
#' any that is but the widest), times the text size.
#' @param labels the labels, lines split by a newline.
#' @param px the text size, in pixels, one or one per label.
#' @return One width per label; 0 for an empty one.
#' @noRd
.labelWidths <- function(labels, px) {
  ems <- vapply(strsplit(labels, "\n", fixed = TRUE), function(lines) {
    if (length(lines) == 0L) {
      return(0.0)
    }
    max(vapply(strsplit(lines, "", fixed = TRUE), function(chars) {
      em <- unname(.labelCharWidths[chars])
      em[is.na(em)] <- 1.0
      sum(em)
    }, numeric(1L)))
  }, numeric(1L))
  ems * px
}

#' Invisible points at the outermost ends of larger labels
#'
#' Phase G14 (R140). vis.js fits its view to the nodes' shapes, not to their
#' labels' overhang (gaps plan dragon 57), so with text larger than its 14
#' pixels the long ids at the drawing's edges were cut off (measured S61 in
#' a 500-pixel drawing: 8-10 pixels at textSize 1.4 and 27-29 at 2). When
#' an animal's node (a real id's or a repeat appearance's) has text larger
#' than \code{.fullTextSize}, this adds three invisible points, built by
#' \code{.markRoom()}: where the leftmost label ends (\code{"__text_l_"} and
#' its node's id), where the rightmost ends (\code{"__text_r_"}), and under
#' the lowest label (\code{"__text_b_"}), each 2 units below its node's
#' label, so the fit takes every label in. The widths are
#' \code{.labelWidths()}; a label of more than one line (a name under the
#' id) reaches one text size lower for each line past the first. The
#' prefix is one the layout reserves (\code{.reservedIdPrefixes}).
#' @param nodes the nodes to draw.
#' @return \code{nodes} with three more rows when the text is larger than
#'   \code{.fullTextSize}; \code{nodes} itself otherwise.
#' @noRd
.textSizeRoom <- function(nodes) {
  animal <- !grepl(.reservedIdPattern, nodes$id) |
    startsWith(nodes$id, "__dup_")
  px <- .nodeTextPixels(nodes)
  large <- animal & px > .fullTextSize
  if (!any(large)) {
    return(nodes)
  }
  half <- .labelWidths(nodes$label, px) / 2.0
  lines <- lengths(strsplit(nodes$label, "\n", fixed = TRUE))
  below <- .idLabelDepth(px) + pmax(lines - 1L, 0L) * px + 2.0
  at <- function(i) seq_len(nrow(nodes)) == i
  left <- which.min(ifelse(large, nodes$x - half, Inf))
  right <- which.max(ifelse(large, nodes$x + half, -Inf))
  low <- which.max(ifelse(large, nodes$y + nodes$size + below, -Inf))
  out <- .markRoom(nodes, at(left), "__text_l_", c(0.0, 1.0),
                   c(-half[[left]], below[[left]]))
  out <- .markRoom(out, c(at(right), FALSE), "__text_r_", c(0.0, 1.0),
                   c(half[[right]], below[[right]]))
  .markRoom(out, c(at(low), FALSE, FALSE), "__text_b_", c(0.0, 1.0),
            c(0.0, below[[low]]))
}
