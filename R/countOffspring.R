## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G6, gap
## C5, pedkindraw S47). New code, derived from no other package.

#' Count each animal's offspring
#'
#' \code{countOffspring()} counts, for each animal, the animals that name it
#' as their sire or dam. Each offspring is counted once, so an animal's count
#' is the length of \code{\link{getOffspring}(ped, id)}. An id with no
#' offspring in \code{ped} gets 0, \code{NA} among them.
#'
#' The count is Pedixplorer's \code{num_child_dir} on the pedigrees this
#' package's tests compare, where a sire and dam have an offspring together.
#' An animal recorded as both a sire and a dam (which
#' \code{\link{checkPedigree}} reports) is counted for its offspring of both
#' kinds.
#'
#' @param ped a data frame with the columns \code{id}, \code{sire} and
#' \code{dam}, an unknown parent written \code{NA} (see
#' \code{\link{recodePedigree}}). Factor columns are read by their labels and
#' numbers as text.
#' @param ids a vector of the animals to count, by default every animal of
#' \code{ped}. An id need not have a row of its own: a sire or dam recorded
#' only as a parent is counted too.
#' @return An integer vector of each animal's number of offspring, named by
#' \code{ids} as text, in their order.
#'
#' @seealso \code{\link{getOffspring}}, \code{\link{getMatings}}
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
#' countOffspring(ped)
#' countOffspring(ped, c("A", "E"))
countOffspring <- function(ped, ids = ped[["id"]]) {
  .checkPedFrame(ped, "countOffspring")
  if (is.list(ids) || !(is.vector(ids) || is.factor(ids))) {
    stop("countOffspring: ids must be a vector of animal ids", call. = FALSE)
  }
  child <- as.character(ped[["id"]])
  parent <- c(as.character(ped[["sire"]]), as.character(ped[["dam"]]))
  known <- !is.na(parent)
  links <- unique(data.frame(parent = parent[known],
                             child = c(child, child)[known],
                             stringsAsFactors = FALSE))
  ids <- as.character(ids)
  counts <- as.integer(table(links[["parent"]])[ids])
  counts[is.na(counts)] <- 0L
  stats::setNames(counts, ids)
}
