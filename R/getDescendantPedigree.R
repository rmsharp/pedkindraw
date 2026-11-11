## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getDescendantPedigree.R at nprcgenekeepr
## commit baef1e12c. Changes: help text only; the function's code is
## unchanged. The example types its own pedigree instead of loading
## nprcgenekeepr's dataset.

#' Reduce a pedigree to a group and its descendants
#'
#' Filters a pedigree down to only the descendants of the provided group,
#' building the pedigree forward in time starting from a group of probands.
#' This is the downward (descendants-only) mirror of
#' \code{\link{getProbandPedigree}}: it takes the transitive closure over
#' offspring and returns the probands together with all of their descendants.
#' It does not include collateral relatives (siblings, cousins, or mates).
#'
#' @param probands a character vector with the list of animals whose
#' descendants should be included in the final pedigree.
#' @param ped datatable that is the \code{Pedigree}. It contains pedigree
#' information. The fields \code{id}, \code{sire} and \code{dam} are required.
#' @return A reduced pedigree containing the probands and all of their
#' descendants.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ## D's descendants are F and G
#' getDescendantPedigree(probands = "D", ped = ped)$id
getDescendantPedigree <- function(probands, ped) {
  probands <- unlist(walkPedigree(probands, ped, "descendants"))
  ped <- ped[ped$id %in% probands, ]
  ped
}
