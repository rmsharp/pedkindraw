## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getParents.R at nprcgenekeepr commit
## baef1e12c. Changes to the code (plan Phase 17c2, pedkindraw S36; a
## DIVERGENCE.md row): the pedigree argument is ped, was pedSourceDf, in the
## same position (R88). Changes to the help text: the ped argument; its
## sentence setting the argument order against getProbandPedigree(),
## getDescendantPedigree(), getPedDirectRelatives() and findOffspring() is
## dropped (pedkindraw S37, plan Phase 17c3: after R89 the first two take the
## pedigree first too, and pedkindraw does not have the other two), and the
## example types its own pedigree instead of loading nprcgenekeepr's dataset.

#' Get parents to corresponding animal IDs provided
#'
#' @param ped dataframe with pedigree structure having at least the
#' columns id, sire, and dam.
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
getParents <- function(ped, ids) {
  unique(c(
    ped$sire[(is.element(ped$id, ids) &
      !is.na(ped$sire))],
    ped$dam[(is.element(ped$id, ids) &
      !is.na(ped$dam))]
  ))
}
