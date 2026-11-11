## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/removeUnknownAnimals.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## 'ped' argument's description is written out (reportGV()'s words) instead of
## inherited from nprcgenekeepr's reportGV(), and the example types its own
## pedigree and makes the placeholders with addParents() instead of using
## nprcgenekeepr's smallPed.

#' Remove placeholder animals added for unknown parents
#'
#' @param ped The pedigree information in data.frame format
#' @return Pedigree with the animals whose \code{recordStatus} is
#' \code{"added"} removed. Every other animal is kept, including one whose
#' \code{recordStatus} is missing (\code{NA}) or has any other value. A
#' pedigree without a \code{recordStatus} column has no animals marked as
#' added, so it is returned unchanged.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("o1", "o2"),
#'   sire = c("s1", "s1"),
#'   dam = c("d1", "d1"),
#'   sex = c("F", "M"),
#'   stringsAsFactors = FALSE
#' )
#' ## addParents() adds records for the parents s1 and d1, marked "added"
#' withParents <- addParents(ped)
#' withParents
#' removeUnknownAnimals(withParents)
removeUnknownAnimals <- function(ped) {
  if (!("recordStatus" %in% names(ped))) {
    return(ped)
  }
  ## isAddedRecord() says which rows are removed. Its mask has no NA, so the
  ## row subscript cannot return an all-NA phantom row.
  ped[!isAddedRecord(ped$recordStatus), ]
}
