## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). It calls internals of
## R/shrinkPedigree.R, which is copied from nprcgenekeepr's clean-room
## rewrite and stays as copied. Written from kinship2's help page for
## bitSize(), not its source (R11).

#' Bit size of a pedigree
#'
#' The bit size of a pedigree, \code{2 * nNonFounder - nFounder}: the
#' measure \code{\link{shrinkPedigree}} reduces toward its \code{maxBits}
#' budget, and its first \code{bitSize} value. A founder is an animal whose
#' \code{sire} and \code{dam} are both unknown (\code{NA}); an animal with
#' one known parent is a non-founder (see \code{\link{isFounder}}).
#'
#' It returns the same list as \code{kinship2::bitSize()}, from a pedigree
#' data frame instead of a kinship2 pedigree object.
#'
#' It stops with \code{shrinkPedigree()}'s message when \code{ped} lacks
#' \code{id}, \code{sire} or \code{dam} (naming them), is not a data frame,
#' has an \code{id} that is missing, empty or repeated, has a \code{sire} or
#' \code{dam} that is not an \code{id} of \code{ped}, or has an animal that
#' is both a sire and a dam.
#'
#' @param ped a pedigree \code{data.frame} with the fields \code{id},
#' \code{sire} and \code{dam}.
#' @return A list of three integers: \code{bitSize}, \code{nFounder} and
#' \code{nNonFounder}.
#'
#' @seealso \code{\link{shrinkPedigree}}, \code{\link{findUnavailable}},
#' \code{\link{findAvailNonInform}}, \code{\link{findAvailAffected}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## A, B and E are founders; C, D and F are not
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F"),
#'   sire = c(NA, NA, "A", "A", NA, "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E"),
#'   stringsAsFactors = FALSE
#' )
#' bitSize(ped)
bitSize <- function(ped) {
  .checkShrinkInput(ped, logical(NROW(ped)), NULL, 16L)
  id <- as.character(ped$id)
  sireIdx <- match(as.character(ped$sire), id)
  damIdx <- match(as.character(ped$dam), id)
  nFounder <- sum(is.na(sireIdx) & is.na(damIdx))
  list(bitSize = .bitSize(sireIdx, damIdx, rep(TRUE, length(id))),
       nFounder = nFounder,
       nNonFounder = length(id) - nFounder)
}
