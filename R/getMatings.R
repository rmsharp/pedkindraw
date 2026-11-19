## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G6, gap
## C5, pedkindraw S47). New code, derived from no other package.

#' List the matings of a pedigree
#'
#' A mating is a sire and a dam with at least one offspring recorded with both
#' of them. \code{getMatings()} lists each mating once, in the order its first
#' offspring comes in \code{ped}, with the number of offspring the two share;
#' these are the matings a drawing of the pedigree draws
#' (\code{\link{makePedigreeMatingLayout}}). An animal's mates are the
#' animals it is listed with.
#'
#' An offspring with only one known parent makes no mating (its parent's
#' \code{\link{countOffspring}} counts it). A sire or dam with no row of its
#' own is listed as recorded. Each offspring is counted once.
#'
#' @inheritParams countOffspring
#' @return A data frame with one row per mating and the columns \code{sire}
#' and \code{dam} (text) and \code{offspring} (an integer, the number of
#' animals with that sire and dam). It has no rows when no animal has both
#' parents known.
#'
#' @seealso \code{\link{countOffspring}}, \code{\link{getOffspring}}
#'
#' @export
#' @examples
#' ## A and B have C; A and E have F; A has G, its dam unknown; B has H,
#' ## its sire unknown; K and E have I.
#' ped <- data.frame(
#'   id = c("A", "B", "E", "K", "C", "F", "G", "H", "I"),
#'   sire = c(NA, NA, NA, NA, "A", "A", "A", NA, "K"),
#'   dam = c(NA, NA, NA, NA, "B", "E", NA, "B", "E")
#' )
#' matings <- getMatings(ped)
#' matings
#' ## The mates of E.
#' c(matings$dam[matings$sire == "E"], matings$sire[matings$dam == "E"])
getMatings <- function(ped) {
  .checkPedFrame(ped, "getMatings")
  sire <- as.character(ped[["sire"]])
  dam <- as.character(ped[["dam"]])
  both <- !is.na(sire) & !is.na(dam)
  links <- unique(data.frame(sire = sire[both], dam = dam[both],
                             child = as.character(ped[["id"]])[both],
                             stringsAsFactors = FALSE))
  key <- paste(links[["sire"]], links[["dam"]], sep = "\u0001")
  first <- !duplicated(key)
  data.frame(sire = links[["sire"]][first], dam = links[["dam"]][first],
             offspring = as.integer(table(factor(key, levels = key[first]))),
             stringsAsFactors = FALSE)
}
