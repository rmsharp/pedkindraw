## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getOffspring.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example types its own pedigree instead of loading nprcgenekeepr's
## dataset.

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
getOffspring <- function(pedSourceDf, ids) {
  unique(c(
    pedSourceDf$id[(is.element(pedSourceDf$sire, ids) &
      !is.na(pedSourceDf$sire))],
    pedSourceDf$id[(is.element(pedSourceDf$dam, ids) &
      !is.na(pedSourceDf$dam))]
  ))
}
