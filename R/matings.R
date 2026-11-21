## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G15a, gap
## B1 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R141,
## pedkindraw S65; docs/planning/mates-without-offspring-plan.md). The copied
## makePedigreeMatingLayout() reads its matings argument with
## .checkMatings(), before its hints (DIVERGENCE.md); plan Phase G15b's
## getMatings(matings = ) is to share it.

#' Check the declared matings given to makePedigreeMatingLayout()
#'
#' Plan Phase G15a (R141; Mark's picks, S65). Each row declares a mating,
#' drawn whether or not the two have offspring together. A row naming an
#' animal without a row of its own in \code{ped} (as after trimming) is left
#' out, with one message naming each such pair; a pair named more than once,
#' in either column, is kept once; the sexes are not checked.
#'
#' @param matings \code{NULL} or a data frame with the columns \code{sire}
#'   and \code{dam}, text or factor; other columns are ignored.
#' @param ped the pedigree data frame, every row's.
#' @return \code{NULL} when no row is left, otherwise a data frame of
#'   \code{sire} and \code{dam} as character, each pair at its first row.
#'   Stops on a table it cannot read.
#' @noRd
.checkMatings <- function(matings, ped) {
  if (is.null(matings)) {
    return(NULL)
  }
  if (!is.data.frame(matings)) {
    stop("makePedigreeMatingLayout() requires 'matings' to be NULL or a ",
         "data frame with the columns sire and dam.")
  }
  absentCols <- setdiff(c("sire", "dam"), names(matings))
  if (length(absentCols) > 0L) {
    stop("makePedigreeMatingLayout() requires 'matings' to have the ",
         "columns sire and dam. Missing: ", toString(absentCols))
  }
  sire <- as.character(matings$sire)
  dam <- as.character(matings$dam)
  if (anyNA(sire) || anyNA(dam)) {
    stop("makePedigreeMatingLayout() found NA in 'matings' columns sire ",
         "and dam.")
  }
  same <- sire == dam
  if (any(same)) {
    stop("makePedigreeMatingLayout() found the same id as sire and dam in ",
         "'matings': ", toString(unique(sire[same])))
  }
  ids <- as.character(ped$id)
  absent <- !(sire %in% ids & dam %in% ids)
  if (any(absent)) {
    message(sprintf(
      paste0("makePedigreeMatingLayout(): %d mating(s) in 'matings' naming ",
             "an animal not in 'ped' left out: %s"),
      sum(absent), toString(paste(sire[absent], "and", dam[absent]))
    ))
  }
  sire <- sire[!absent]
  dam <- dam[!absent]
  keep <- !duplicated(.layoutHintPairKey(sire, dam))
  if (!any(keep)) {
    return(NULL)
  }
  data.frame(sire = sire[keep], dam = dam[keep], stringsAsFactors = FALSE)
}
