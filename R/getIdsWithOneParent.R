## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getIdsWithOneParent.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example types its own pedigree instead of using nprcgenekeepr's
## examplePedigree and qcStudbook().

#' Get ids of animals with only one parent
#'
#' @param uPed a trimmed pedigree dataframe with uninformative founders removed.
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
getIdsWithOneParent <- function(uPed) {
  uPed$id[(is.na(uPed$sire) & !is.na(uPed$dam)) |
    (!is.na(uPed$sire) & is.na(uPed$dam))]
}
