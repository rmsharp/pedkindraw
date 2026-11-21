## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G15a, gap
## B1 of docs/research/pedkindraw-gaps-2026-11-18.md; ruling R141,
## pedkindraw S65; docs/planning/mates-without-offspring-plan.md). The copied
## makePedigreeMatingLayout() reads its matings argument with
## .checkMatings(), before its hints (DIVERGENCE.md); getMatings(matings = )
## shares it (plan Phase G15b, pedkindraw S66).

#' Check the declared matings given to makePedigreeMatingLayout() or
#' getMatings()
#'
#' Plan Phase G15a (R141; Mark's picks, S65). Each row declares a mating,
#' drawn whether or not the two have offspring together. A row naming a pair
#' with offspring together in \code{ped}, in either column, changes nothing,
#' so it is set aside first, without a message (Mark's pick, S66, plan Phase
#' G15b: a table \code{getMatings()} returns can be passed back). A row
#' naming an animal without a row of its own in \code{ped} (as after
#' trimming) is left out, with one message naming each such pair; a pair
#' named more than once, in either column, is kept once; the sexes are not
#' checked.
#'
#' @param matings \code{NULL} or a data frame with the columns \code{sire}
#'   and \code{dam}, text or factor; other columns are ignored.
#' @param ped the pedigree data frame, every row's.
#' @param caller the name of the function checking, without its
#'   parentheses, which each message starts with.
#' @return \code{NULL} when no row is left, otherwise a data frame of
#'   \code{sire} and \code{dam} as character, each pair at its first row,
#'   none with offspring together. Stops on a table it cannot read.
#' @noRd
.checkMatings <- function(matings, ped, caller = "makePedigreeMatingLayout") {
  if (is.null(matings)) {
    return(NULL)
  }
  if (!is.data.frame(matings)) {
    stop(caller, "() requires 'matings' to be NULL or a ",
         "data frame with the columns sire and dam.")
  }
  absentCols <- setdiff(c("sire", "dam"), names(matings))
  if (length(absentCols) > 0L) {
    stop(caller, "() requires 'matings' to have the ",
         "columns sire and dam. Missing: ", toString(absentCols))
  }
  sire <- as.character(matings$sire)
  dam <- as.character(matings$dam)
  if (anyNA(sire) || anyNA(dam)) {
    stop(caller, "() found NA in 'matings' columns sire ",
         "and dam.")
  }
  pedSire <- as.character(ped$sire)
  pedDam <- as.character(ped$dam)
  both <- !is.na(pedSire) & !is.na(pedDam)
  withOffspring <- .layoutHintPairKey(sire, dam) %in%
    .layoutHintPairKey(pedSire[both], pedDam[both])
  sire <- sire[!withOffspring]
  dam <- dam[!withOffspring]
  same <- sire == dam
  if (any(same)) {
    stop(caller, "() found the same id as sire and dam in ",
         "'matings': ", toString(unique(sire[same])))
  }
  ids <- as.character(ped$id)
  absent <- !(sire %in% ids & dam %in% ids)
  if (any(absent)) {
    message(sprintf(
      paste0(caller, "(): %d mating(s) in 'matings' naming ",
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
