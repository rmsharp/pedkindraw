## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/addBackSecondParents.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example types its own pedigree instead of using nprcgenekeepr's
## examplePedigree and qcStudbook().

#' Add back second parents to a trimmed pedigree
#'
#' Uses the \code{ped} dataframe, which has full complement of parents and the
#' \code{uPed} dataframe, which has all uninformative parents removed to
#' add back single parents to the \code{uPed} dataframe where one parent is
#' known. The parents are added back to the pedigree as an ID record with
#' NA for both sire and dam of the added back ID.
#'
#' @param uPed a trimmed pedigree dataframe with uninformative founders removed.
#' @param ped the full (untrimmed) pedigree dataframe, from which the second
#' parents are taken.
#' @return A pedigree with single parents added. It is a \code{data.table}
#' once any record is added and a plain dataframe when none is.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, NA, "A", "A", "D", "D"),
#'   dam = c(NA, NA, NA, "B", "C", "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ## Removing the uninformative founders B and C leaves D and E with
#' ## one known parent each; adding back the second parents restores
#' ## B and C as founders
#' p <- removeUninformativeFounders(ped)
#' nrow(p)
#' p <- addBackSecondParents(p, ped)
#' nrow(p)
#'
addBackSecondParents <- function(uPed, ped) {
  # Adding back second parents where one is known
  idsWithOneParent <- getIdsWithOneParent(uPed)
  addBack <- character(0L)
  ## Within this loop, the second parent is added to uPed as the sire
  ## or dam as is found in ped.
  for (id in idsWithOneParent) {
    if (hasBothParents(id, ped)) {
      if (is.na(uPed$sire[uPed$id == id])) {
        addBack <- c(addBack, ped$sire[ped$id == id])
        uPed[(uPed$id == id), "sire"] <- ped$sire[ped$id == id]
      } else {
        addBack <- c(addBack, ped$dam[ped$id == id])
        uPed[(uPed$id == id), "dam"] <- ped$dam[ped$id == id]
      }
    }
  }
  addIdRecords(ids = addBack, fullPed = ped, partialPed = uPed)
}
