## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/findGeneration.R at nprcgenekeepr commit
## baef1e12c. Changes to the code (plan Phase G8, gap C2, pedkindraw S49; a
## DIVERGENCE.md row): the argument alignMates = FALSE, checked first; when
## TRUE the generations found are passed to .alignGenerations()
## (R/alignGenerations.R, pedkindraw's own code). At the default the result
## is the copied code's. Changes to the help text: alignMates and the
## aligned generations; the example types its own pedigree instead of
## loading nprcgenekeepr's dataset.

#' Determine the generation number for each ID
#'
#' This loops through the entire pedigree one generation at a
#' time. It finds the zeroth generation during first loop.
#' The first time through this loop no sire or dam is in parents.
#' This means that the animals without a sire and without a dam are
#' assigned to generation 0 and become the first parental generation.
#' The second time through this loop finds all of the animals that do
#' not have a sire or do not have a dam and at least one parent
#' is in the vector of parents defined the first time through.
#' The ids that were not assigned as parents in the previous loop
#' are given the incremented generation number.
#'
#' Subsequent trips in the loop repeat what was done the second time
#' through until no further animals can be added to the \code{nextGen}
#' vector.
#'
#' This does not work if the pedigree does not have all parent IDs as ego IDs.
#'
#' @section Aligned generations:
#' With \code{alignMates = TRUE}, animals are moved to later generations so
#' that, where it can be done, the sire and dam of each offspring are in the
#' same generation, as kinship2's \code{kindepth(align = TRUE)} does for
#' drawing. A mating is a sire and dam with an offspring that records both.
#' Starting from the generations above:
#' \enumerate{
#'   \item The matings whose sire and dam are in different generations are
#'   visited in the order of their offspring's generation, then of the
#'   sire's id and the dam's id, each mating at most once.
#'   \item At a visit, if the two still differ, the parent in the earlier
#'   generation moves to the generation of its nearest later mate, unless it
#'   has moved this way before or is related to one of its later mates other
#'   than through their own offspring. Its ancestors, and those of their
#'   mates who have no parents, move with it by the same number of
#'   generations.
#'   \item The descendants of the animals moved are put one generation after
#'   their later parent, and a mating of a descendant moved this way joins
#'   the end of the list, if it has not been visited.
#'   \item Last, every animal with a known parent is put one generation after
#'   its later parent.
#' }
#' kinship2's help describes the method in one sentence ("try to make both
#' parents of each child have the same depth"); these steps were measured
#' from its results. On the pedigrees the tests compare, the aligned
#' generations equal kinship2's on both families of its \code{sample.ped},
#' and on most others, and differ on a few animals of larger pedigrees.
#' Unlike kinship2's, they do not depend on the order of the rows, and they
#' place every offspring after each of its known parents. A perfect
#' alignment does not always exist: an animal related to a later mate stays
#' where it is. Animals that cannot be placed stay \code{NA}.
#'
#' @param id character vector with unique identifier for an individual
#' @param sire character vector with unique identifier for an
#' individual's father (\code{NA} if unknown).
#' @param dam character vector with unique identifier for an
#' individual's mother (\code{NA} if unknown).
#' @param alignMates \code{TRUE} or \code{FALSE}, the default. When
#' \code{TRUE}, the generations are aligned so that, where it can be done,
#' an offspring's sire and dam are in the same generation (see "Aligned
#' generations").
#' @return An integer vector indication the generation numbers for each id,
#' starting at 0 for individuals lacking IDs for both parents. Any id that
#' cannot be placed --- e.g. when the pedigree contains a cycle or references
#' a parent ID that is not itself present as an ego ID --- is returned as
#' \code{NA} and triggers a \code{warning} naming the affected ids. With
#' \code{alignMates = TRUE}, an individual lacking IDs for both parents may
#' be in a later generation than 0.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
#' ## E, with no parents, mates D, of generation 1, and joins it.
#' ped$aligned <- findGeneration(ped$id, ped$sire, ped$dam, alignMates = TRUE)
#' ped
findGeneration <- function(id, sire, dam, alignMates = FALSE) {
  if (!(isTRUE(alignMates) || isFALSE(alignMates))) {
    stop("findGeneration: alignMates must be TRUE or FALSE", call. = FALSE)
  }
  parents <- character(0L)
  gen <- rep(NA, length(id))
  i <- 0L

  repeat {
    cumulativeParents <- id[(is.na(sire) | (sire %in% parents)) &
      (is.na(dam) | (dam %in% parents))]
    nextGen <- setdiff(cumulativeParents, parents)

    if (isEmpty(nextGen)) {
      break
    }

    gen[id %in% nextGen] <- i
    i <- i + 1L

    parents <- cumulativeParents
  }
  if (anyNA(gen)) {
    unplaced <- id[is.na(gen)]
    danglingParents <- setdiff(c(sire[!is.na(sire)], dam[!is.na(dam)]), id)
    msg <- paste0(
      "findGeneration: ", length(unplaced),
      " id(s) could not be assigned a generation; the pedigree may contain ",
      "a cycle or a parent ID absent as an ego ID. Unplaced id(s): ",
      toString(unplaced)
    )
    if (length(danglingParents) > 0L) {
      msg <- paste0(
        msg, ". Parent ID(s) with no record: ",
        toString(danglingParents)
      )
    }
    warning(msg)
  }
  if (alignMates) {
    gen <- .alignGenerations(as.character(id), as.character(sire),
                             as.character(dam), gen)
  }
  gen
}
