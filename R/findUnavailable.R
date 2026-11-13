## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). It calls internals of
## R/shrinkPedigree.R, which is copied from nprcgenekeepr's clean-room
## rewrite and stays as copied. Written from kinship2's help page for
## findUnavailable(), not its source (R11).

#' Find the animals a pedigree can lose because they are unavailable
#'
#' The ids \code{\link{shrinkPedigree}} removes in its first trim, in the
#' order it removes them: animals that are not genotyped and have no
#' genotyped descendant (ungenotyped leaves, removed until none is left);
#' then each founder couple with one child together and no other mate when
#' neither founder is genotyped (the child becomes a founder); then each
#' founder left with no offspring (a stray marry-in), genotyped or not.
#'
#' It is the step of \code{shrinkPedigree()} that \code{kinship2}'s
#' \code{findUnavailable()} performs, from a pedigree data frame instead of a
#' kinship2 pedigree object. Two differences: when no animal is genotyped,
#' kinship2's function stops with an error, and this one returns every id;
#' and when removing an ungenotyped founder couple makes its ungenotyped
#' child a founder, this function, like \code{shrinkPedigree()}, removes in
#' the same trim the couple that child forms with another ungenotyped
#' founder, if that couple's child comes later in \code{ped}, where kinship2
#' leaves that couple for its next step. On every pedigree its tests
#' compare, this function and \code{\link{findAvailNonInform}} together
#' remove the same animals as \code{kinship2::pedigree.shrink()}'s first two
#' steps. An animal may have one known parent.
#'
#' It stops with \code{shrinkPedigree()}'s message for a bad pedigree or a
#' \code{genotyped} vector of the wrong length or with an \code{NA}.
#'
#' @param ped a pedigree \code{data.frame} with the fields \code{id},
#' \code{sire} and \code{dam}.
#' @param genotyped a logical vector, one value per row of \code{ped},
#' \code{TRUE} where the animal is genotyped (or otherwise available).
#' \code{NA} is not allowed.
#' @return A character vector of ids in the order they are removed;
#' \code{character(0)} when none is.
#'
#' @seealso \code{\link{shrinkPedigree}}, \code{\link{findAvailNonInform}},
#' \code{\link{findAvailAffected}}, \code{\link{bitSize}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## D, G and I are ungenotyped leaves; then A and B are an ungenotyped
#' ## founder couple with one child, C; then H is a founder with no offspring
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
#'   sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "H"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "E"),
#'   stringsAsFactors = FALSE
#' )
#' genotyped <- c(FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE)
#' findUnavailable(ped, genotyped)
findUnavailable <- function(ped, genotyped) {
  read <- .checkShrinkInput(ped, genotyped, NULL, 16L)
  pos <- .parentPositions(ped)
  pass <- .removalPass(pos$sireIdx, pos$damIdx, rep(TRUE, length(pos$id)),
                       read$genotyped)
  pos$id[pass$removed]
}
