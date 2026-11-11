## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/getFounders.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example no longer loads nprcgenekeepr.

#' Get the founder ids from a pedigree
#'
#' Part of Pedigree Curation
#'
#' A founder is an animal whose sire and dam are both unknown (\code{NA}).
#' Animals with exactly one known parent (partial parentage) are
#' \strong{not} founders.
#'
#' @inheritParams getDescendantPedigree
#' @return A vector of the \code{id} values of the founders, in pedigree
#' order. It has the same type as \code{ped$id} and is empty when there are
#' no founders.
#'
#' @seealso \code{\link{isFounder}} for the founder logical mask.
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' getFounders(ped)
getFounders <- function(ped) {
  ped$id[isFounder(ped)]
}
