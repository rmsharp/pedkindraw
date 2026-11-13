## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). It calls internals of
## R/shrinkPedigree.R, which is copied from nprcgenekeepr's clean-room
## rewrite and stays as copied; its loop is the second trim of
## shrinkPedigree(), which its tests check it against. Written from kinship2's
## help page for findAvailNonInform(), not its source (R11).

#' Find genotyped animals that add no information to a pedigree
#'
#' The ids \code{\link{shrinkPedigree}} removes in its second trim, in the
#' order it removes them. An animal is uninformative when it is genotyped,
#' is no animal's parent, is not \code{affected} (an \code{NA} status counts
#' as unaffected), and has both parents known and genotyped. Each round
#' removes the uninformative animals, with any animal their removal leaves
#' removable as in the first trim (see \code{\link{findUnavailable}}), such
#' as a founder left with no offspring; the rounds go on until one removes
#' nothing, so a parent left as a leaf can go in a later round. An animal
#' with one known parent is never uninformative.
#'
#' It runs the first trim itself and returns only the second trim's ids, so
#' it takes the whole pedigree. kinship2's \code{findAvailNonInform()} makes
#' one pass and does not follow on to the parents it leaves;
#' \code{kinship2::pedigree.shrink()}'s second step does, as this function
#' does. On every pedigree its tests compare, it and
#' \code{findUnavailable()} together remove the same animals as
#' \code{pedigree.shrink()}'s first two steps.
#'
#' It stops with \code{shrinkPedigree()}'s message for a bad pedigree, or
#' for a \code{genotyped} or \code{affected} vector of the wrong length, or
#' an \code{NA} in \code{genotyped}.
#'
#' @param ped a pedigree \code{data.frame} with the fields \code{id},
#' \code{sire} and \code{dam}, and optionally a logical \code{affected}
#' column.
#' @param genotyped a logical vector, one value per row of \code{ped},
#' \code{TRUE} where the animal is genotyped (or otherwise available).
#' \code{NA} is not allowed.
#' @param affected \code{NULL} (default) or a logical vector, one value per
#' row of \code{ped}. When \code{NULL}, \code{ped$affected} is used if it
#' exists, and otherwise every animal counts as unaffected.
#' @return A character vector of ids in the order they are removed;
#' \code{character(0)} when none is.
#'
#' @seealso \code{\link{shrinkPedigree}}, \code{\link{findUnavailable}},
#' \code{\link{findAvailAffected}}, \code{\link{bitSize}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## All genotyped. G and H are uninformative; with G gone, E has no
#' ## offspring and goes; then C is uninformative. D is affected, and I has
#' ## one known parent.
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "G", "H", "I"),
#'   sire = c(NA, NA, "A", "A", NA, "C", "A", "A"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "B", NA),
#'   affected = c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, NA, FALSE),
#'   stringsAsFactors = FALSE
#' )
#' findAvailNonInform(ped, rep(TRUE, nrow(ped)))
findAvailNonInform <- function(ped, genotyped, affected = NULL) {
  read <- .checkShrinkInput(ped, genotyped, affected, 16L)
  genotyped <- read$genotyped
  affected <- read$affected
  id <- as.character(ped$id)
  state <- .removalPass(match(as.character(ped$sire), id),
                        match(as.character(ped$dam), id),
                        rep(TRUE, length(id)), genotyped)
  noninform <- integer(0L)
  while (any(state$present)) {
    leaf <- state$present &
      !.isParent(state$sireIdx, state$damIdx, state$present)
    parentsAvail <- !is.na(state$sireIdx) & !is.na(state$damIdx) &
      genotyped[state$sireIdx] & genotyped[state$damIdx]
    parentsAvail[is.na(parentsAvail)] <- FALSE
    hide <- leaf & genotyped & (is.na(affected) | !affected) & parentsAvail
    state <- .removalPass(state$sireIdx, state$damIdx, state$present,
                          genotyped & !hide)
    if (length(state$removed) == 0L) break
    noninform <- c(noninform, state$removed)
  }
  id[noninform]
}
