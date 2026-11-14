## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase 14,
## rulings R55-R57, pedkindraw S19). New code (R7), written from kinship2's
## help page for pedigree() and the objects it was measured to make,
## kinship2's source not read (R11, R14).

#' Convert a kinship2 pedigree object to the package's data frames
#'
#' Turns a kinship2 \code{pedigree} or \code{pedigreeList} object back into
#' the data frames the rest of the package takes: a pedigree with one row per
#' animal, and a table of twin pairs.
#'
#' The rows keep the object's order, which is the order the animals were
#' given to \code{kinship2::pedigree()}. Each parent is read by its own index,
#' so an unknown parent (index 0) never moves another animal's parent. Ids
#' become text: a factor's labels, and whole numbers written in full
#' (\code{"100000"}, not \code{"1e+05"}), so no id is renamed.
#'
#' Sex becomes \code{M}, \code{F} or \code{U}: male, female, and unknown or
#' terminated. kinship2 has no code for a hermaphrodite, so an animal entered
#' as \code{H} comes back \code{U}. A single \code{affected} vector becomes
#' the column \code{affected}; the columns of an \code{affected} matrix become
#' \code{affected_<column name>}, or \code{affected_1}, \code{affected_2} and
#' so on when the matrix has no column names. Their values stay as kinship2
#' holds them: 0, 1 or \code{NA}. A \code{status} of 1 becomes
#' \code{"DECEASED"} and 0 \code{"ALIVE"}. An object with no \code{affected}
#' or no \code{status} gives no such column. kinship2 keeps no other column,
#' so names, dates and the like are not in its objects to convert.
#'
#' Twin pairs come from the object's \code{relation} codes 1, 2 and 3 (MZ, DZ
#' and UZ twins), whether kinship2 stored them as numbers or as text; code 4,
#' a spouse pair, is left out, since the package draws a mating from its
#' offspring.
#'
#' A \code{pedigreeList} (several families) is converted whole when no id
#' appears in two families, with a \code{famid} column naming each animal's
#' family. When ids repeat across families, \code{asPedFrame()} stops and
#' names them (ten at most, in byte order); one family, such as
#' \code{x["2"]}, is a \code{pedigree} and converts on its own.
#'
#' A kinship2 object is a plain list, so it is read without calling kinship2:
#' kinship2 need not be installed, for an object read back from a file for
#' instance. \code{asPedFrame()} stops for an object of any other class,
#' naming the class, and for a \code{pedigree} or \code{pedigreeList} that
#' lacks a part it needs (\code{id}, \code{findex}, \code{mindex}, \code{sex},
#' and \code{famid} for a \code{pedigreeList}), naming the parts.
#'
#' @param x a kinship2 \code{pedigree} or \code{pedigreeList} object.
#' @param ... not used.
#' @return A list of two:
#' \describe{
#'   \item{\code{ped}}{a data frame with the character columns \code{id},
#'   \code{sire}, \code{dam} (an unknown parent is \code{NA}) and \code{sex};
#'   then \code{famid} for a \code{pedigreeList}; then the condition columns;
#'   then \code{status}.}
#'   \item{\code{twinRelations}}{a data frame with the character columns
#'   \code{id1}, \code{id2} and \code{code} (\code{"MZ twin"},
#'   \code{"DZ twin"} or \code{"UZ twin"}), or \code{NULL} when the object has
#'   no twin pair.}
#' }
#'
#' @seealso \code{\link{checkPedigree}}, \code{\link{checkTwinRelations}},
#' \code{\link{drawPedigreeDiagram}}
#'
#' @export
#' @examples
#' if (requireNamespace("kinship2", quietly = TRUE)) {
#'   ## A and B are the parents of C and D, DZ twins; A has died and C is
#'   ## affected.
#'   p <- kinship2::pedigree(
#'     id = c("A", "B", "C", "D"),
#'     dadid = c(NA, NA, "A", "A"),
#'     momid = c(NA, NA, "B", "B"),
#'     sex = c("male", "female", "male", "female"),
#'     affected = c(0, 0, 1, 0),
#'     status = c(1, 0, 0, 0),
#'     relation = data.frame(id1 = "C", id2 = "D", code = 2)
#'   )
#'   asPedFrame(p)
#' }
asPedFrame <- function(x, ...) {
  UseMethod("asPedFrame")
}

#' @rdname asPedFrame
#' @export
asPedFrame.default <- function(x, ...) {
  stop("asPedFrame(): cannot convert an object of class ",
       toString(dQuote(class(x), q = FALSE)),
       "; it converts kinship2's pedigree and pedigreeList objects",
       call. = FALSE)
}

#' @rdname asPedFrame
#' @export
asPedFrame.pedigree <- function(x, ...) {
  .asPedFrameKinship2(x, family = FALSE)
}

#' @rdname asPedFrame
#' @export
asPedFrame.pedigreeList <- function(x, ...) {
  .asPedFrameKinship2(x, family = TRUE)
}

## The two data frames of a kinship2 pedigree (family FALSE) or pedigreeList
## (family TRUE) object, read from the list's parts (plan R56).
.asPedFrameKinship2 <- function(x, family) {
  needed <- c("id", "findex", "mindex", "sex", if (family) "famid")
  lacking <- setdiff(needed, names(x))
  if (length(lacking) > 0L) {
    stop("asPedFrame(): the object lacks ", toString(lacking), call. = FALSE)
  }
  id <- .asPedFrameText(x[["id"]])
  if (family) {
    repeated <- sort(unique(id[duplicated(id)]), method = "radix")
    if (length(repeated) > 0L) {
      stop("asPedFrame(): ids repeat across families: ",
           toString(utils::head(repeated, 10L)), call. = FALSE)
    }
  }
  parentOf <- function(index) {
    parent <- rep(NA_character_, length(index))
    known <- index > 0L
    parent[known] <- id[index[known]]
    parent
  }
  sexOf <- c(male = "M", female = "F", unknown = "U", terminated = "U")
  ped <- data.frame(id = id, sire = parentOf(x[["findex"]]),
                    dam = parentOf(x[["mindex"]]),
                    sex = unname(sexOf[as.character(x[["sex"]])]),
                    stringsAsFactors = FALSE)
  if (family) {
    ped$famid <- .asPedFrameText(x[["famid"]])
  }
  ped <- .asPedFrameConditions(ped, x[["affected"]])
  if (!is.null(x[["status"]])) {
    ped$status <- ifelse(x[["status"]] == 1L, "DECEASED", "ALIVE")
  }
  list(ped = ped, twinRelations = .asPedFrameTwins(x[["relation"]], id))
}

## ped with kinship2's conditions added: a single affected vector as the
## column affected, a matrix's columns as affected_<column name>, or
## affected_<column number> when the matrix has no column names (plan R56).
.asPedFrameConditions <- function(ped, affected) {
  if (is.null(affected)) {
    return(ped)
  }
  if (!is.matrix(affected)) {
    ped$affected <- affected
    return(ped)
  }
  conditionNames <- colnames(affected)
  if (is.null(conditionNames)) {
    conditionNames <- as.character(seq_len(ncol(affected)))
  }
  for (j in seq_len(ncol(affected))) {
    ped[[paste0("affected_", conditionNames[j])]] <- affected[, j]
  }
  ped
}

## Ids as text: a factor's labels, and whole numbers written in full
## ("100000", where as.character() gives "1e+05"; plan R56).
.asPedFrameText <- function(x) {
  text <- as.character(x)
  if (is.numeric(x)) {
    whole <- !is.na(x) & x == trunc(x) & abs(x) < 1e15
    text[whole] <- sprintf("%.0f", x[whole])
  }
  text
}

## The twin pairs of a kinship2 relation table: codes 1-3 (stored as a factor
## or as whole numbers), the spouse code 4 left out; NULL when no pair is
## left (plan R56).
.asPedFrameTwins <- function(relation, id) {
  if (is.null(relation)) {
    return(NULL)
  }
  code <- as.integer(relation[["code"]])
  twin <- code %in% 1L:3L
  if (!any(twin)) {
    return(NULL)
  }
  data.frame(id1 = id[relation[["indx1"]][twin]],
             id2 = id[relation[["indx2"]][twin]],
             code = c("MZ twin", "DZ twin", "UZ twin")[code[twin]],
             stringsAsFactors = FALSE)
}
