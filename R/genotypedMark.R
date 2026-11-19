## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133-R134,
## pedkindraw S54). The copied makePedigreeMatingLayout() reads a column
## genotyped with .readGenotyped() and gives each node its outline width with
## .genotypedBorderWidths(); the copied drawPedigreeDiagram() adds a
## "Genotyped" legend row when any animal is genotyped (DIVERGENCE.md).

#' The outline width of a genotyped animal's symbol
#'
#' Phase G13 (R134). vis.js draws a node's outline 1 pixel wide; a genotyped
#' animal's is drawn 4 wide. Measured in headless Chrome in a 500-pixel
#' drawing (S54): 621 to 679 pixels change around a genotyped symbol with one
#' condition, 339 to 540 with three (the sections cover the inner half of the
#' outline), 299 to 613 in greyscale, and none around any other symbol.
#' @noRd
.genotypedBorderWidth <- 4L

#' Read the genotyped column of a pedigree
#'
#' Phase G13 (R134). \code{NULL} when \code{ped} has no column
#' \code{genotyped}. Otherwise the column as \code{TRUE}, \code{FALSE} or
#' \code{NA} for each animal, named by id: it may hold \code{TRUE},
#' \code{FALSE} and \code{NA}, the numbers 1 and 0, and the text
#' \code{as.logical()} reads (\code{"TRUE"}, \code{"false"}, \code{"T"} and
#' the like, as a CSV file gives them), as text or a factor. Anything else
#' stops, naming the caller, the column and up to five of the values.
#' @param ped data frame with an \code{id} column.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, or a logical vector named by \code{ped$id}.
#' @noRd
.readGenotyped <- function(ped, caller) {
  if (!"genotyped" %in% names(ped)) {
    return(NULL)
  }
  x <- ped[["genotyped"]]
  if (is.logical(x)) {
    read <- x
    bad <- logical(length(x))
  } else if (is.numeric(x)) {
    read <- as.logical(x)
    bad <- !is.na(x) & !(x %in% c(0.0, 1.0))
  } else if (is.character(x) || is.factor(x)) {
    x <- as.character(x)
    read <- as.logical(x)
    bad <- !is.na(x) & is.na(read)
  } else {
    stop(caller, "(): the column 'genotyped' holds values other than TRUE, ",
         "FALSE and NA (a column of class ", class(x)[[1L]], "). Give TRUE ",
         "or FALSE (or 1 or 0) for each animal, NA where it is not recorded.",
         call. = FALSE)
  }
  if (any(bad)) {
    values <- unique(x[bad])
    shown <- if (is.numeric(values)) {
      utils::head(values, 5L)
    } else {
      sprintf("'%s'", utils::head(values, 5L))
    }
    shown <- toString(shown)
    if (length(values) > 5L) shown <- paste0(shown, ", ...")
    stop(caller, "(): the column 'genotyped' holds values other than TRUE, ",
         "FALSE and NA (", shown, "). Give TRUE or FALSE (or 1 or 0) for ",
         "each animal, NA where it is not recorded.", call. = FALSE)
  }
  stats::setNames(read, as.character(ped$id))
}

#' The outline width of each node of a layout
#'
#' Phase G13 (R134). \code{.genotypedBorderWidth} for the node of a
#' genotyped animal and for each of its repeat-appearance nodes; 1, vis.js's
#' own width, for every other node: an animal not genotyped or not recorded,
#' a mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param genotyped what \code{.readGenotyped()} returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return integer vector, as long as \code{nodeIds}.
#' @noRd
.genotypedBorderWidths <- function(nodeIds, genotyped, dupIds, dupRealIds) {
  animalOf <- ifelse(nodeIds %in% dupIds, dupRealIds[match(nodeIds, dupIds)],
                     nodeIds)
  typed <- unname(genotyped[animalOf])
  ifelse(!is.na(typed) & typed, .genotypedBorderWidth, 1L)
}
