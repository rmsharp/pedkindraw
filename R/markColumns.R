## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133-R136). The
## pieces every mark drawn on a symbol shares: the copied
## makePedigreeMatingLayout() reads each mark's column with .readMarkColumn()
## (genotyped, R134; carrier, R135; proband and consultand, R136) and finds
## the nodes it marks with .markedNodes(). S55's REFACTOR moved them here from
## R/genotypedMark.R (.readGenotyped(), .genotypedOddValues()) and
## R/carrierMark.R (.carrierNodes()), unchanged but for their names. S56's
## REFACTOR added .markLegendRow(), the legend row of a mark drawn by a
## script, which the copied drawPedigreeDiagram() had written out for the
## carrier, the proband and the consultand.

#' Read a mark's column of a pedigree
#'
#' Phase G13 (R134, R135). \code{NULL} when \code{ped} has no column
#' \code{column}. Otherwise the column as \code{TRUE}, \code{FALSE} or
#' \code{NA} for each animal, named by id: it may hold \code{TRUE},
#' \code{FALSE} and \code{NA}, the numbers 1 and 0, and the text
#' \code{as.logical()} reads (\code{"TRUE"}, \code{"false"}, \code{"T"} and
#' the like, as a CSV file gives them), as text or a factor. Anything else
#' stops, naming the caller, the column and what \code{.markOddValues()}
#' finds.
#' @param ped data frame with an \code{id} column.
#' @param column the column's name, such as \code{"genotyped"} or
#'   \code{"carrier"}.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, or a logical vector named by \code{ped$id}.
#' @noRd
.readMarkColumn <- function(ped, column, caller) {
  if (!column %in% names(ped)) {
    return(NULL)
  }
  x <- ped[[column]]
  if (is.factor(x)) x <- as.character(x)
  shown <- .markOddValues(x)
  if (!is.null(shown)) {
    stop(caller, "(): the column '", column, "' holds values other than ",
         "TRUE, FALSE and NA (", shown, "). Give TRUE or FALSE (or 1 or 0) ",
         "for each animal, NA where it is not recorded.", call. = FALSE)
  }
  stats::setNames(as.logical(x), as.character(ped$id))
}

#' What a mark's column holds besides TRUE, FALSE and NA
#'
#' Phase G13 (R134), for \code{.readMarkColumn()}'s message. \code{NULL} when
#' the column holds nothing else. A column that is not logical, numeric or
#' text is named by its class (\dQuote{a column of class Date}); otherwise
#' up to five of its other values, a number other than 0 and 1 as it is and
#' text \code{as.logical()} cannot read in single quotes, then \dQuote{...}
#' when there are more.
#' @param x the column, a factor already turned into text.
#' @return \code{NULL}, or a character string.
#' @noRd
.markOddValues <- function(x) {
  if (!is.logical(x) && !is.numeric(x) && !is.character(x)) {
    return(paste("a column of class", class(x)[[1L]]))
  }
  odd <- if (is.numeric(x)) {
    !is.na(x) & !(x %in% c(0.0, 1.0))
  } else {
    !is.na(x) & is.na(as.logical(x))
  }
  values <- unique(x[odd])
  if (length(values) == 0L) {
    return(NULL)
  }
  if (is.character(values)) values <- sprintf("'%s'", values)
  shown <- toString(utils::head(values, 5L))
  if (length(values) > 5L) shown <- paste0(shown, ", ...")
  shown
}

#' Which nodes of a layout a mark marks
#'
#' Phase G13 (R134, R135). \code{TRUE} for the node of an animal whose value
#' in \code{marks} is \code{TRUE} and for each of its repeat-appearance
#' nodes; \code{FALSE} for every other node: an animal whose value is
#' \code{FALSE} or not recorded, a mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param marks what \code{.readMarkColumn()} returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return logical vector, as long as \code{nodeIds}, never \code{NA}.
#' @noRd
.markedNodes <- function(nodeIds, marks, dupIds, dupRealIds) {
  animalOf <- ifelse(nodeIds %in% dupIds, dupRealIds[match(nodeIds, dupIds)],
                     nodeIds)
  marked <- unname(marks[animalOf])
  !is.na(marked) & marked
}

#' The legend's row for a mark drawn by a script
#'
#' Phase G13 (R135, R136). The legend is its own vis.Network and cannot run
#' the diagram's afterDrawing scripts, so the row of a mark one of them paints
#' (the carrier's dot, the proband's and the consultand's arrow) is a
#' picture, as the \dQuote{Deceased} row is; it is there only when some
#' animal has the mark. S56's REFACTOR: \code{drawPedigreeDiagram()} had the
#' same data frame written out three times.
#' @param label the row's label.
#' @param image the picture, a \code{data:} URI.
#' @param shown \code{TRUE} when some node has the mark.
#' @return A data frame of one row, or of none when \code{shown} is
#'   \code{FALSE}.
#' @noRd
.markLegendRow <- function(label, image, shown) {
  data.frame(
    label = label, shape = "image", color.background = NA_character_,
    image = image, stringsAsFactors = FALSE
  )[shown, , drop = FALSE]
}
