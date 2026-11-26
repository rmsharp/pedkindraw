## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G7, gap
## C6, pedkindraw S48). New code, derived from no other package.

#' Remove listed animals from a pedigree
#'
#' \code{removeAnimals()} removes the rows of the listed animals and sets to
#' \code{NA} each \code{sire} or \code{dam} entry that names one of them, so
#' that none of them is left as a parent with no row. An offspring of a
#' removed animal keeps its other parent: one known parent is legal here.
#' Afterwards \code{\link{checkPedigree}} reports none of the removed animals
#' as \code{rowlessParents}, a parent with no row, which
#' \code{\link{findGeneration}} cannot place and \code{\link{kinship}} cannot
#' take.
#'
#' On the pedigrees its tests compare, the result equals kinship2's
#' \code{pedigree.trim()} wherever that returns (it stops whenever an
#' offspring would keep only one parent), and Pedixplorer's
#' \code{subset(del_parents = "one")} except that Pedixplorer also clears the
#' parent that is not removed.
#'
#' @param ped a data frame with the columns \code{id}, \code{sire} and
#' \code{dam}, an unknown parent written \code{NA} (see
#' \code{\link{recodePedigree}}). Factor columns are read by their labels and
#' numbers as text.
#' @param ids a vector of the animals to remove, compared with \code{id},
#' \code{sire} and \code{dam} as text. An id need not have a row: a listed
#' sire or dam with no row of its own is cleared from its offspring. An id
#' found nowhere in \code{ped} is ignored, and \code{NA} among \code{ids}
#' removes the rows whose id is \code{NA}.
#' @return \code{ped} without the rows whose id is listed, and with each
#' listed \code{sire} or \code{dam} set to \code{NA}; its other rows, in their
#' order and with their row names, its columns and each column's type are
#' unchanged.
#'
#' @seealso \code{\link{removeUnknownAnimals}},
#' \code{\link{removeUninformativeFounders}}, \code{\link{checkPedigree}}
#'
#' @export
#' @examples
#' ## A and B have C and D; C and E have F and G; D and H have I.
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
#'   sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "H")
#' )
#' ## Without C's row, C is a sire with no row of its own.
#' checkPedigree(ped[ped$id != "C", ])
#' ## removeAnimals() also clears C as the sire of F and G, who keep their
#' ## dam E.
#' kept <- removeAnimals(ped, "C")
#' kept
#' checkPedigree(kept)
#' gen <- findGeneration(kept$id, kept$sire, kept$dam)
#' kinship(kept$id, kept$sire, kept$dam, gen)["F", "G"]
removeAnimals <- function(ped, ids) {
  .checkPedFrame(ped, "removeAnimals")
  .checkIds(ids, "removeAnimals")
  ids <- as.character(ids)
  ped <- ped[!(as.character(ped[["id"]]) %in% ids), , drop = FALSE]
  for (column in c("sire", "dam")) {
    ped[[column]][as.character(ped[[column]]) %in% ids] <- NA
  }
  ped
}
