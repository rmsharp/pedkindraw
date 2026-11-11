## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/trimPedigree.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example types its own pedigree instead of using nprcgenekeepr's
## examplePedigree, qcStudbook() and setPopulation().

#' Trim a pedigree to a group's ancestors
#'
#' Filters a pedigree down to the provided group (the probands) and all of
#' their ancestors, removing unnecessary individuals from the studbook. By
#' default only that filtering is done. Uninformative founders are removed
#' only when \code{removeUninformative = TRUE}, and single parents are added
#' back only when both \code{removeUninformative} and \code{addBackParents}
#' are \code{TRUE}.
#'
#' @param probands a character vector with the list of animals whose ancestors
#' should be included in the final pedigree.
#' @param ped datatable that is the \code{Pedigree}. It contains pedigree
#' information. The fields \code{id}, \code{sire} and \code{dam} are
#' required.
#' @param removeUninformative logical defaults to \code{FALSE}. If set to
#' \code{TRUE}, uninformative founders are removed.
#'
#' Founders (having unknown sire and dam) that appear only one time in a
#' pedigree are uninformative and can be removed from a pedigree without loss
#' of information.
#' @param addBackParents logical defaults to \code{FALSE}. If set to
#' \code{TRUE}, the function adds back single parents to the \code{p} dataframe
#' when one parent is known. It is ignored unless
#' \code{removeUninformative = TRUE}.
#' The function \code{addBackSecondParents} uses the \code{ped} dataframe,
#' which has full complement of parents and the
#' \code{p} dataframe, which has all uninformative parents removed to add
#' back single parents to the \code{p} dataframe.
#' @return A pedigree containing the probands and all of their ancestors.
#' Uninformative founders are removed only when \code{removeUninformative}
#' is \code{TRUE}, and single parents are added back only when
#' \code{addBackParents} is also \code{TRUE}.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G", "H"),
#'   sire = c(NA, NA, NA, "A", "A", "D", "D", NA),
#'   dam = c(NA, NA, NA, "B", "C", "E", "E", NA),
#'   stringsAsFactors = FALSE
#' )
#' ## F and G and their ancestors; H is not one of them
#' trimmedPed <- trimPedigree(c("F", "G"), ped)
#' trimmedPedInformative <- trimPedigree(c("F", "G"), ped,
#'   removeUninformative = TRUE
#' )
#' nrow(ped)
#' nrow(trimmedPed)
#' nrow(trimmedPedInformative)
trimPedigree <- function(probands, ped, removeUninformative = FALSE,
                         addBackParents = FALSE) {
  ped <- getProbandPedigree(probands, ped)
  if (removeUninformative) {
    p <- removeUninformativeFounders(ped)
    if (addBackParents) {
      p <- addBackSecondParents(p, ped)
    }
  } else {
    p <- ped
  }
  p
}
