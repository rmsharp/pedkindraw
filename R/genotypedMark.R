## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133-R134,
## pedkindraw S54). The copied makePedigreeMatingLayout() reads a column
## genotyped with .readMarkColumn() (R/markColumns.R) and gives each node its
## outline width with .genotypedBorderWidths(); the copied
## drawPedigreeDiagram() adds a "Genotyped" legend row when any animal is
## genotyped (DIVERGENCE.md). S55's REFACTOR moved the column's reader to
## R/markColumns.R, which the carrier mark shares.

#' The outline width of a genotyped animal's symbol
#'
#' Phase G13 (R134). vis.js draws a node's outline 1 pixel wide; a genotyped
#' animal's is drawn 4 wide. Measured in headless Chrome in a 500-pixel
#' drawing (S54): 621 to 679 pixels change around a genotyped symbol with one
#' condition, 339 to 540 with three (the sections cover the inner half of the
#' outline), 299 to 613 in greyscale, and none around any other symbol.
#' @noRd
.genotypedBorderWidth <- 4L

#' The outline width of each node of a layout
#'
#' Phase G13 (R134). \code{.genotypedBorderWidth} for the node of a
#' genotyped animal and for each of its repeat-appearance nodes; 1, vis.js's
#' own width, for every other node: an animal not genotyped or not recorded,
#' a mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param genotyped what \code{.readMarkColumn()} returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return integer vector, as long as \code{nodeIds}.
#' @noRd
.genotypedBorderWidths <- function(nodeIds, genotyped, dupIds, dupRealIds) {
  ifelse(.markedNodes(nodeIds, genotyped, dupIds, dupRealIds),
         .genotypedBorderWidth, 1L)
}
