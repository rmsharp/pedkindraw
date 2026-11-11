## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/helper-qcdRhesusPed.R at
## nprcgenekeepr commit baef1e12c. Changes: qcdRhesusPed() reads the saved
## result, fixtures/qcdRhesusPed.rds (tools/makeComputedTestFixtures.R ran
## nprcgenekeepr's code at that commit), instead of running runQcStudbook(),
## which pedkindraw does not have (the source's lines 18-26). Its age column
## is as of the day it was saved, 2026-11-11 (runQcStudbook() ages an animal
## with no exit date to Sys.Date()); no copied test reads age.

## Test-harness support (S905): the bundled rhesus pedigree as the app's QC
## step delivers it. The live app lays out the QC'd pedigree, never the raw
## CSV: modInput runs runQcStudbook() first, and that step reorders the rows,
## which moves the rectilinear waypoint count (BACKLOG row-order item).

#' The bundled rhesus pedigree after the app's QC step
#'
#' Reads \code{obfuscated_rhesus_mhc_ped.csv} and runs it through
#' \code{runQcStudbook()} the way \code{modInputServer} does (blank age floors,
#' so the species and sex default applies; \code{reportChanges = TRUE}).
#'
#' @return The \code{cleaned} data frame: the same 375 animals as the CSV, in
#'   the QC step's row order.
qcdRhesusPed <- function() {
  readRDS(test_path("fixtures", "qcdRhesusPed.rds"))
}
