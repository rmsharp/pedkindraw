## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getProbandPedigree.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## 'ped' argument's description is written out (trimPedigree()'s words)
## instead of inherited from trimPedigree(), which pedkindraw does not have
## yet, and the example types its own pedigree instead of using
## nprcgenekeepr's datasets and getPotentialSires().

#' Reduce a pedigree to probands and their ancestors
#'
#' Filters a pedigree down to the provided group (the probands) together
#' with all of their ancestors, removing unnecessary individuals from the
#' studbook. This version builds
#' the pedigree back in time starting from a group of probands. This will
#' include all ancestors of the probands, even ones that might be
#' uninformative.
#'
#' @param probands a character vector with the list of animals whose ancestors
#' should be included in the final pedigree.
#' @param ped datatable that is the \code{Pedigree}. It contains pedigree
#' information. The fields \code{id}, \code{sire} and \code{dam} are
#' required.
#' @return A reduced pedigree.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ## F's ancestors are its parents D and E and D's parents A and B
#' getProbandPedigree(probands = "F", ped = ped)$id
getProbandPedigree <- function(probands, ped) {
  probands <- unlist(walkPedigree(probands, ped, "ancestors"))
  ped <- ped[ped$id %in% probands, ]
  ped
}
