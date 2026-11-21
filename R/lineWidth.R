## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S63). The copied makePedigreeMatingLayout() checks its
## lineWidth argument with .checkPositiveNumber() (R/symbolSize.R) and, at any
## other width than 1, gives its lines, dashes and outlines the width with
## .lineWidthLayout(); the copied drawPedigreeDiagram() reads it back with
## .layoutLineWidth() and passes it to each mark's handler, which strokes its
## lines that many times today's width (DIVERGENCE.md). S63's REFACTOR:
## .strokeWidthJs(), the line each of the six handlers wrote out, and
## .outlineAt(), the outline rule .lineWidthLayout() and
## drawPedigreeDiagram()'s Genotyped row each wrote out.

#' The dash pattern vis.js draws for an edge whose dashes are TRUE
#'
#' Phase G14 (R140). 5 units on and 5 off, vis.js's own pattern, which the
#' repeat-appearance links take; at another line width it is written out,
#' times the width, so its gaps grow with the line.
#' @noRd
.visDashes <- c(5.0, 5.0)

#' A layout's nodes and edges at a line width
#'
#' Phase G14 (R140; Mark's picks, S63). Every edge is \code{lineWidth} wide
#' and the half-siblings' mating line (4 before) 4 times it; every dash
#' pattern is multiplied by it, \code{TRUE} as vis.js's own 5 and 5, so a
#' thick line keeps its gaps (vis.js draws each dash with round ends, which
#' a thick line would close); every outline is \code{lineWidth - 1} wider
#' than before, so an ordinary one is \code{lineWidth} pixels and a genotyped
#' one \code{lineWidth + 3}; and every node carries \code{lineWidth}, which
#' \code{drawPedigreeDiagram()} gives the marks. Not rounded.
#' @param nodes the layout's nodes.
#' @param edges the layout's edges.
#' @param lineWidth one positive number, not 1.
#' @return A list with \code{nodes} and \code{edges}.
#' @noRd
.lineWidthLayout <- function(nodes, edges, lineWidth) {
  edges$width <- ifelse(is.na(edges$width), 1.0, edges$width) * lineWidth
  edges$dashes <- lapply(edges$dashes, function(dashes) {
    if (isTRUE(dashes)) {
      .visDashes * lineWidth
    } else if (is.numeric(dashes)) {
      dashes * lineWidth
    } else {
      dashes
    }
  })
  outline <- nodes[["borderWidth"]]
  if (is.null(outline)) outline <- rep(1.0, nrow(nodes))
  nodes$borderWidth <- .outlineAt(outline, lineWidth)
  nodes$lineWidth <- rep(lineWidth, nrow(nodes))
  list(nodes = nodes, edges = edges)
}

#' An outline's width at a line width
#'
#' Phase G14 (R140; Mark's pick, S63). The outline \code{lineWidth - 1}
#' wider than at the line width 1: an ordinary outline (1) \code{lineWidth}
#' pixels and a genotyped one (\code{.genotypedBorderWidth}, 4)
#' \code{lineWidth + 3}. S63's REFACTOR: \code{.lineWidthLayout()} and
#' \code{drawPedigreeDiagram()}'s Genotyped row each wrote it.
#' @param outline the outline's width at the line width 1.
#' @param lineWidth one positive number.
#' @return The width, a number.
#' @noRd
.outlineAt <- function(outline, lineWidth) {
  outline + lineWidth - 1.0
}

#' The line of a mark's handler that sets its stroke width
#'
#' Phase G14 (R140). The canvas's line width, \code{width} times the
#' layout's \code{lineWidth}, written as a number, so at the line width 1
#' each handler's text is as before (the fidelity check compares it). S63's
#' REFACTOR: the six handlers (the slash's, the arrow's, the star's, the
#' bars', the miscarriage line's and the sections') each wrote it.
#' @param width the stroke's width at the line width 1.
#' @param lineWidth one positive number.
#' @return One line of JavaScript, as a character string.
#' @noRd
.strokeWidthJs <- function(width, lineWidth) {
  paste0("  ctx.lineWidth = ", format(width * lineWidth, digits = 4L), ";\n")
}

#' The line width a layout was made with
#'
#' Phase G14 (R140). The \code{lineWidth} its nodes carry, or 1 when they
#' carry none (a layout at the line width 1, or made before Phase G14).
#' @param nodes the layout's nodes.
#' @return One number.
#' @noRd
.layoutLineWidth <- function(nodes) {
  lineWidth <- nodes[["lineWidth"]]
  if (length(lineWidth) == 0L) 1.0 else lineWidth[[1L]]
}
