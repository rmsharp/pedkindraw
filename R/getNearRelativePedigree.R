## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G11, gap
## C1, pedkindraw S52). New code, written from Pedixplorer's help pages for
## useful_inds(), min_dist_inf() and num_child() and its measured results,
## Pedixplorer's source not read (R11, R14).

#' Reduce a pedigree to the near relatives of a group
#'
#' Keeps each animal within a distance of the probands, and the parents that
#' join those animals' families, as Pedixplorer's \code{useful_inds()} does
#' when given \code{max_dist}.
#'
#' An animal's distance is \code{log2(1 / k)}, where \code{k} is its largest
#' kinship (\code{\link{kinship}}) with a proband: 1 for a
#' proband itself, 2 for a parent, offspring or full sibling, 3 for a
#' grandparent, grandoffspring, half sibling, uncle, aunt, nephew or niece, 4
#' for a first cousin, and so on. Distance is read from kinship, not counted
#' in steps, so a double first cousin is at 3 and an inbred animal can be at
#' less than 1; an animal not related to any proband has no distance and
#' is kept only as a parent.
#'
#' Every animal within \code{maxDist} is kept. So is each parent of a kept
#' animal whose own offspring and the offspring of its mates (with any
#' partner), counted once, number two or more; any other parent is left out,
#' and its id is set to \code{NA} in its offspring's row, as
#' \code{\link{removeAnimals}} does. On the pedigrees its tests compare, the
#' animals kept are the ones Pedixplorer 1.8.0's
#' \code{useful_inds(max_dist = maxDist)} marks useful, with the same
#' informative animals.
#'
#' Pedixplorer chooses its informative animals with \code{is_informative()},
#' by default those both available and affected; pass those as
#' \code{probands}, for instance \code{ped$id[genotyped & ped$affected]}.
#'
#' A pedigree from which kinship cannot be read is refused:
#' \code{getNearRelativePedigree()} stops, naming the animals, when
#' \code{\link{checkPedigree}} reports \code{missingIds}, \code{duplicateIds},
#' \code{ownParent}, \code{cycle}, \code{rowlessParents}
#' (\code{\link{addParents}} adds a row for each such parent) or
#' \code{missingParentCodes}. Sex is not read, and one known parent is legal.
#'
#' @param ped a data frame with the columns \code{id}, \code{sire} and
#' \code{dam} (an unknown parent is \code{NA}). Factor columns are read by
#' their labels and numbers as text.
#' @param probands a vector of the animals whose near relatives are kept,
#' compared with \code{id} as text. An id with no row is ignored.
#' @param maxDist one finite number, 1 or more: the largest distance kept.
#' @return \code{ped} with only the rows kept, in their order and with their
#' row names, each column and its type unchanged, and \code{NA} for each
#' \code{sire} or \code{dam} left out; no rows when no proband has a row.
#'
#' @seealso \code{\link{getProbandPedigree}},
#' \code{\link{getDescendantPedigree}}, \code{\link{trimPedigree}},
#' \code{\link{removeAnimals}}, \code{\link{kinship}}
#'
#' @export
#' @examples
#' ## O is the proband. F and M are its parents, S its sister and K its
#' ## offspring by Q. G1 and G2 are F's parents, U is F's brother and C is
#' ## U's offspring by X. S has N by Y and N2 by Z.
#' ped <- data.frame(
#'   id = c("G1", "G2", "F", "U", "M", "X", "O", "S", "Q", "K", "Y", "Z",
#'          "N", "N2", "C"),
#'   sire = c(NA, NA, "G1", "G1", NA, NA, "F", "F", NA, "O", NA, NA, "Y",
#'            "Z", "U"),
#'   dam = c(NA, NA, "G2", "G2", NA, NA, "M", "M", NA, "Q", NA, NA, "S",
#'           "S", "X")
#' )
#' ## Distance 1: O, and its parents F and M, who have two offspring.
#' near1 <- getNearRelativePedigree(ped, "O", 1)
#' near1$id
#' ## Distance 2: also S, K, G1 and G2. Q is left out (K is its only
#' ## offspring and O has no other), so K's dam is NA.
#' near2 <- getNearRelativePedigree(ped, "O", 2)
#' near2[near2$id == "K", ]
#' ## Distance 3: also U, N and N2, and their sires Y and Z, each with one
#' ## offspring by S, who has two.
#' near3 <- getNearRelativePedigree(ped, "O", 3)
#' near3$id
getNearRelativePedigree <- function(ped, probands, maxDist) {
  .checkPedFrame(ped, "getNearRelativePedigree")
  .checkIds(probands, "getNearRelativePedigree", "probands")
  if (!is.numeric(maxDist) || length(maxDist) != 1L ||
        !is.finite(maxDist) || maxDist < 1.0) {
    stop("getNearRelativePedigree: maxDist must be one finite number, ",
         "1 or more", call. = FALSE)
  }
  refusal <- .unrelatedStopMessage(checkPedigree(ped[c("id", "sire", "dam")]),
                                   "getNearRelativePedigree")
  if (!is.null(refusal)) {
    stop(refusal, call. = FALSE)
  }
  id <- as.character(ped[["id"]])
  sire <- as.character(ped[["sire"]])
  dam <- as.character(ped[["dam"]])
  chosen <- id %in% as.character(probands)
  if (!any(chosen)) {
    return(ped[0L, , drop = FALSE])
  }
  kin <- kinship(id, sire, dam, findGeneration(id, sire, dam), sparse = TRUE)
  best <- apply(kin[, chosen, drop = FALSE], 1L, max)
  near <- best >= 2.0^-maxDist
  parent <- !near & id %in% c(sire[near], dam[near])
  family <- vapply(which(parent), function(i) {
    kids <- which(sire %in% id[i] | dam %in% id[i])
    mates <- setdiff(c(sire[kids], dam[kids]), c(id[i], NA))
    length(unique(c(kids, which(sire %in% mates | dam %in% mates))))
  }, integer(1L))
  keep <- near
  keep[which(parent)[family >= 2L]] <- TRUE
  removeAnimals(ped, id[!keep])
}
