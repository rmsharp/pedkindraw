## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getParents.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## links to getPedDirectRelatives() and findOffspring(), which pedkindraw
## does not have, are dropped, and the example types its own pedigree
## instead of loading nprcgenekeepr's dataset.

#' Get parents to corresponding animal IDs provided
#'
#' @param pedSourceDf dataframe with pedigree structure having at least the
#' columns id, sire, and dam. The pedigree is the first argument, unlike
#' \code{\link{getProbandPedigree}()} and
#' \code{\link{getDescendantPedigree}()}, which take the animal ids first.
#' @param ids character vector of animal IDs
#' @return A character vector with the IDs of the parents of the provided ID
#' list.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' getParents(ped, c("C", "F"))
getParents <- function(pedSourceDf, ids) {
  unique(c(
    pedSourceDf$sire[(is.element(pedSourceDf$id, ids) &
      !is.na(pedSourceDf$sire))],
    pedSourceDf$dam[(is.element(pedSourceDf$id, ids) &
      !is.na(pedSourceDf$dam))]
  ))
}
