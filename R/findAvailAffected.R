## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). It calls internals of
## R/shrinkPedigree.R, which is copied from nprcgenekeepr's clean-room
## rewrite and stays as copied; one call is one round of shrinkPedigree()'s
## third trim, which its tests check it against. Written from kinship2's help
## page for findAvailAffected(), not its source (R11).

#' Remove the one animal of an affected status that shrinks a pedigree most
#'
#' One round of \code{\link{shrinkPedigree}}'s third trim on the pedigree it
#' is given. Among the genotyped animals that are no animal's parent and
#' whose \code{affected} status is \code{affstatus}, it removes the one whose
#' removal leaves the smallest bit size (see \code{\link{bitSize}}), with
#' any animal that removal leaves removable as in the first trim (see
#' \code{\link{findUnavailable}}): an ungenotyped parent left as a leaf, an
#' ungenotyped founder couple left with one child, a founder left with no
#' offspring. Ties go to the first \code{id} in byte order (capitals before
#' lower case), whatever the computer's language setting, as in
#' \code{shrinkPedigree()}; kinship2 breaks ties at random.
#'
#' \code{shrinkPedigree()} tries an \code{NA} status first, then
#' \code{FALSE}, then \code{TRUE}, and repeats until the bit size is within
#' its \code{maxBits}. Called the same way on the pedigree its first two
#' trims leave (\code{shrinkPedigree(ped, genotyped, maxBits = Inf)$ped}),
#' this function makes the same removals.
#'
#' It stops with \code{shrinkPedigree()}'s message for a bad pedigree, or
#' for a \code{genotyped} or \code{affected} vector of the wrong length, or
#' an \code{NA} in \code{genotyped}, and when \code{affstatus} is not one of
#' \code{NA}, \code{FALSE} and \code{TRUE}.
#'
#' @param ped a pedigree \code{data.frame} with the fields \code{id},
#' \code{sire} and \code{dam}, and optionally a logical \code{affected}
#' column.
#' @param genotyped a logical vector, one value per row of \code{ped},
#' \code{TRUE} where the animal is genotyped (or otherwise available).
#' \code{NA} is not allowed.
#' @param affected \code{NULL} or a logical vector, one value per row of
#' \code{ped}. When \code{NULL}, \code{ped$affected} is used if it exists,
#' and otherwise every animal counts as unaffected (\code{FALSE}).
#' @param affstatus the affected status of the animals to choose from:
#' \code{NA}, \code{FALSE} or \code{TRUE}.
#' @return A list, with \code{kinship2::findAvailAffected()}'s names:
#' \describe{
#'   \item{ped}{The pedigree after the removal, every column kept;
#'   \code{id}, \code{sire} and \code{dam} as character, and an animal made
#'   a founder has its \code{sire} and \code{dam} set to \code{NA}. When
#'   nothing is removed, \code{ped} with every row.}
#'   \item{idTrimmed}{Character vector, every id removed, in the order
#'   removed; \code{character(0)} when none is.}
#'   \item{isTrimmed}{\code{TRUE} when an animal was removed; \code{FALSE}
#'   when no genotyped non-parent has that status.}
#'   \item{bitSize}{Integer, the bit size of the returned \code{ped}.}
#' }
#'
#' @seealso \code{\link{shrinkPedigree}}, \code{\link{findUnavailable}},
#' \code{\link{findAvailNonInform}}, \code{\link{bitSize}}
#'
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93.
#'
#' @export
#' @examples
#' ## K and M are genotyped non-parents of unknown affected status. Removing K
#' ## also removes its ungenotyped sire P and leaves its dam Q a founder with
#' ## no offspring, so the bit size falls from 5 to 2; removing M leaves 3.
#' ped <- data.frame(
#'   id = c("GA", "GB", "P", "K", "Q", "L", "M"),
#'   sire = c(NA, NA, "GA", "P", NA, "GA", "GA"),
#'   dam = c(NA, NA, "GB", "Q", NA, "GB", "GB"),
#'   stringsAsFactors = FALSE
#' )
#' genotyped <- c(TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)
#' affected <- c(FALSE, FALSE, FALSE, NA, FALSE, TRUE, NA)
#' result <- findAvailAffected(ped, genotyped, affected, NA)
#' result$idTrimmed
#' result$bitSize
findAvailAffected <- function(ped, genotyped, affected, affstatus) {
  read <- .checkShrinkInput(ped, genotyped, affected, 16L)
  if (!is.logical(affstatus) || length(affstatus) != 1L) {
    stop("affstatus must be NA, FALSE or TRUE", call. = FALSE)
  }
  genotyped <- read$genotyped
  affected <- read$affected
  pos <- .parentPositions(ped)
  id <- pos$id
  sireIdx <- pos$sireIdx
  damIdx <- pos$damIdx
  p <- ped
  p$id <- id
  p$sire <- as.character(p$sire)
  p$dam <- as.character(p$dam)
  present <- rep(TRUE, length(id))
  status <- if (is.na(affstatus)) {
    is.na(affected)
  } else {
    !is.na(affected) & affected == affstatus
  }
  pool <- which(genotyped & status & !.isParent(sireIdx, damIdx, present))
  if (length(pool) == 0L) {
    return(list(ped = p, idTrimmed = character(0L), isTrimmed = FALSE,
                bitSize = .bitSize(sireIdx, damIdx, present)))
  }
  pool <- pool[order(id[pool], method = "radix")]
  best <- NULL
  bestSize <- NA_integer_
  for (k in pool) {
    avail <- genotyped
    avail[k] <- FALSE
    trial <- .removalPass(sireIdx, damIdx, present, avail)
    size <- .bitSize(trial$sireIdx, trial$damIdx, trial$present)
    if (is.null(best) || size < bestSize) {
      best <- trial
      bestSize <- size
    }
  }
  promoted <- is.na(best$sireIdx) & is.na(best$damIdx)
  p$sire[promoted] <- NA_character_
  p$dam[promoted] <- NA_character_
  list(ped = p[which(best$present), , drop = FALSE],
       idTrimmed = id[best$removed], isTrimmed = TRUE, bitSize = bestSize)
}
