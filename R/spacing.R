## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G14, gap
## B5 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R140,
## pedkindraw S62). The copied makePedigreeMatingLayout() checks its
## columnSpacing and rowSpacing arguments with .checkPositiveNumber()
## (R/symbolSize.R) and places its columns .wholeMultiple() of
## .fullColumnUnits apart and its rows .wholeMultiple() of .fullRowUnits
## apart (DIVERGENCE.md). S62's REFACTOR: .wholeMultiple() (R/symbolSize.R)
## where .spacingUnits() was.

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
