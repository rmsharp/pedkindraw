## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/removeUninformativeFounders.R at nprcgenekeepr
## commit baef1e12c. Changes: help text only; the function's code is unchanged.
## The example types its own pedigree instead of using nprcgenekeepr's
## examplePedigree and qcStudbook().

#' Remove uninformative founders
#'
#' Founders (having unknown sire and dam) that appear only one time in a
#' pedigree are uninformative and can be removed from a pedigree without loss
#' of information. Removal repeats until no such founder remains, because
#' removing one can leave another founder appearing only once.
#'
#' @param ped dataframe that is the \code{Pedigree}. The \code{id},
#' \code{sire} and \code{dam} columns are required.
#' @return A reduced pedigree.
#'
#' @export
#' @examples
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, NA, "A", "A", "D", "D"),
#'   dam = c(NA, NA, NA, "B", "C", "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ## B and C are founders that appear only once, so they are removed;
#' ## A is the sire of two animals and stays
#' p <- removeUninformativeFounders(ped)
#' nrow(ped)
#' nrow(p)
removeUninformativeFounders <- function(ped) {
  required <- c("id", "sire", "dam")
  if (!all(required %in% names(ped))) {
    stop(
      "Pedigree is missing ",
      toString(required[!required %in% names(ped)])
    )
  }

  repeat {
    founders <- getFounders(ped)

    sires <- as.data.frame(table(ped$sire[ped$sire %in% founders]))
    dams <- as.data.frame(table(ped$dam[ped$dam %in% founders]))
    sires$Var1 <- as.character(sires$Var1)
    dams$Var1 <- as.character(dams$Var1)

    rmv <- c(sires$Var1[sires$Freq == 1L], dams$Var1[dams$Freq == 1L])
    if (isEmpty(rmv)) {
      break
    }

    ped$sire[ped$sire %in% rmv] <- NA
    ped$dam[ped$dam %in% rmv] <- NA
    ped <- ped[!(ped$id %in% rmv), ]
  }
  ped
}
