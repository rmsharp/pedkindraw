## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getOffspring.R at nprcgenekeepr commit
## baef1e12c. Changes to the code (plan Phase 17c2, pedkindraw S36; a
## DIVERGENCE.md row): the pedigree argument is ped, was pedSourceDf, in the
## same position (R88); its help comes from getParents()'s. Changes to the
## help text: the example types its own pedigree instead of loading
## nprcgenekeepr's dataset.

#' Get offspring to corresponding animal IDs provided
#'
#' @inheritParams getParents
#' @return A character vector containing all of the offspring IDs for all of the
#' IDs provided in the second argument \code{ids}. All offspring are combined
#' and duplicates are removed.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' getOffspring(ped, c("A", "E"))
getOffspring <- function(ped, ids) {
  unique(c(
    ped$id[(is.element(ped$sire, ids) &
      !is.na(ped$sire))],
    ped$id[(is.element(ped$dam, ids) &
      !is.na(ped$dam))]
  ))
}
