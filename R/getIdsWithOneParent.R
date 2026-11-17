## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getIdsWithOneParent.R at nprcgenekeepr commit
## baef1e12c. Changes to the code (plan Phase 17c2, pedkindraw S36; a
## DIVERGENCE.md row): the pedigree argument is ped, was uPed (R88). Changes
## to the help text: the ped argument; the example types its own pedigree
## instead of using nprcgenekeepr's examplePedigree and qcStudbook().

#' Get ids of animals with only one parent
#'
#' @param ped a trimmed pedigree dataframe with uninformative founders removed.
#' @return Character vector of the IDs of animals with exactly one known
#' parent.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, NA, "A", "A", "D", "D"),
#'   dam = c(NA, NA, NA, "B", "C", "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ## B and C are founders that appear only once (uninformative), so
#' ## removing them leaves D and E with one known parent each
#' p <- removeUninformativeFounders(ped)
#' p
#' getIdsWithOneParent(p)
getIdsWithOneParent <- function(ped) {
  ped$id[(is.na(ped$sire) & !is.na(ped$dam)) |
    (!is.na(ped$sire) & is.na(ped$dam))]
}
