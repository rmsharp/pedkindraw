## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/findPedigreeNumber.R at nprcgenekeepr commit
## baef1e12c. Changes: help text only; the function's code is unchanged. The
## example types two small families instead of copying nprcgenekeepr's
## dataset with stringi.

#' Determine the pedigree number for each ID
#'
#' One of Pedigree Curation functions
#'
#' @param id character vector with unique identifier for an individual
#' @param sire character vector with unique identifier for an
#' individual's father (\code{NA} if unknown).
#' @param dam character vector with unique identifier for an
#' individual's mother (\code{NA} if unknown).
#' @return Integer vector indicating the pedigree (family group) number for
#' each id. Ids that are connected through parent-offspring links share the
#' same number; numbering starts at 1. Numbering starts from ids with both
#' parents unknown (\code{NA}), so an id that cannot be reached from such an
#' id, for example one whose only parent is absent from \code{id}, or one in
#' a cycle, is returned as \code{NA}.
#'
#' @export
#' @examples
#' ## Two unrelated families: A and B are the parents of C, D and E of F.
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F"),
#'   sire = c(NA, NA, "A", NA, NA, "D"),
#'   dam = c(NA, NA, "B", NA, NA, "E"),
#'   stringsAsFactors = FALSE
#' )
#' ped$pedigree <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
#' ped$pedigree
findPedigreeNumber <- function(id, sire, dam) {
  founders <- id[is.na(sire) & is.na(dam)]
  pedNum <- rep(NA, length(id))
  n <- 1L

  while (!isEmpty(founders)) {
    population <- founders[1L]

    repeat {
      parents <- union(
        sire[id %in% population],
        dam[id %in% population]
      )
      parents <- parents[!is.na(parents)]

      offspring <- id[(sire %in% population) | (dam %in% population)]

      added <- setdiff(union(offspring, parents), population)

      if (isEmpty(added)) {
        break
      }

      population <- union(population, union(parents, offspring))
    }
    pedNum[id %in% population] <- n
    n <- n + 1L

    founders <- setdiff(founders, population)
  }
  pedNum
}
