## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S62). The copied makePedigreeMatingLayout() checks its
## columnSpacing and rowSpacing arguments with .checkPositiveNumber()
## (R/symbolSize.R) and places its columns .spacingUnits() of
## .fullColumnUnits apart and its rows .spacingUnits() of .fullRowUnits
## apart (DIVERGENCE.md).

#' The distance, in units, between two columns at columnSpacing 1
#'
#' Phase G14 (R140). The distance between neighbouring animals in a row
#' before Phase G14, chosen in nprcgenekeepr by drawing a loop pedigree and
#' a wide sibship in a browser.
#' @noRd
.fullColumnUnits <- 120L

#' The distance, in units, between two rows at rowSpacing 1
#'
#' Phase G14 (R140). The distance between generations before Phase G14,
#' vis.js's own hierarchical layout's.
#' @noRd
.fullRowUnits <- 150L

#' A distance, in whole units, at a spacing
#'
#' Phase G14 (R140). \code{full} times \code{spacing}, rounded to a whole
#' unit and at least 1, so 1 gives the distance before Phase G14 exactly, an
#' integer as it was.
#' @param full the distance at spacing 1, in units.
#' @param spacing one positive number.
#' @return One integer.
#' @noRd
.spacingUnits <- function(full, spacing) {
  max(1L, as.integer(round(full * spacing)))
}
