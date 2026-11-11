## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/hasBothParents.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## 'ped' argument's description is written out (reportGV()'s words) instead of
## inherited from nprcgenekeepr's reportGV(), and the example types its
## pedigree instead of using nprcgenekeepr's pedOne.

#' Check whether an animal has both parents
#'
#' @param id a single ID to examine for parents. A vector of IDs is not
#' supported: the result is not one value per ID, and a recycling warning
#' appears only when the number of IDs does not divide the number of rows of
#' \code{ped}.
#' @param ped The pedigree information in data.frame format
#' @return TRUE if ID has both sire and dam identified in \code{ped}, FALSE
#' if one or both are unknown, and \code{logical(0)} if \code{id} is not in
#' \code{ped}.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
#'   sire = c(NA, NA, NA, NA, "s1", "s1", "s2", "s2"),
#'   dam = c(NA, NA, NA, NA, "d1", "d2", "d2", "d2"),
#'   stringsAsFactors = FALSE
#' )
#' hasBothParents("o2", ped)
#' ped$sire[ped$id == "o2"] <- NA
#' hasBothParents("o2", ped)
hasBothParents <- function(id, ped) {
  !is.na(ped$sire[ped$id == id]) & !is.na(ped$dam[ped$id == id])
}
