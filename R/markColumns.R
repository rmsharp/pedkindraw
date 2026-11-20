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
## carrier, the proband and the consultand. S57's REFACTOR added .markField()
## and .markRoom(), the invisible points that keep a mark drawn outside a
## symbol inside the drawing, which .probandArrowRoom() (R/probandMark.R) and
## .evaluatedStarRoom() (R/evaluatedMark.R) had each written out. S58 (R138):
## .markRoom() empties a point's fertility field, the infertile mark's, which
## is text, not TRUE or FALSE. S58's REFACTOR added .oddValuesShown() and
## .nodeAnimals(), which .markOddValues() and .markedNodes() share with the
## fertility column's .readFertility() and .fertilityNodes()
## (R/infertileMark.R), each of which had the same lines. S59 (R139):
## .markRoom() empties a point's miscarriage field, the miscarriage mark's,
## which is text too. S59's REFACTOR added .readWordColumn(), which the
## fertility and miscarriage columns' readers (.readFertility(),
## R/infertileMark.R; .readMiscarriage(), R/miscarriageMark.R) had each
## written out, and .idsShown(), which .checkProbandConsultand()
## (R/probandMark.R) and .checkMiscarriage() (R/miscarriageMark.R) had each
## written out.

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
  .oddValuesShown(x[odd])
}

#' Up to five values a column cannot read, as a message shows them
#'
#' Phase G13 (R134, R138): a number as it is, text in single quotes, then
#' \dQuote{...} when there are more than five. S58's REFACTOR:
#' \code{.markOddValues()} and the fertility column's reader
#' (\code{.readFertility()}, R/infertileMark.R) had the same lines.
#' @param odd the values that cannot be read.
#' @return \code{NULL} when there is none, or a character string.
#' @noRd
.oddValuesShown <- function(odd) {
  values <- unique(odd)
  if (length(values) == 0L) {
    return(NULL)
  }
  if (is.character(values)) values <- sprintf("'%s'", values)
  shown <- toString(utils::head(values, 5L))
  if (length(values) > 5L) shown <- paste0(shown, ", ...")
  shown
}

#' Read a pedigree's column of words
#'
#' Phase G13 (R138, R139). S59's REFACTOR: the fertility and miscarriage
#' columns' readers (\code{.readFertility()}, \code{.readMiscarriage()}) had
#' the same lines. \code{NULL} when \code{ped} has no such column.
#' Otherwise what each value means, \code{words} at its key, named by id:
#' \code{NA} for \code{NA} and for a key \code{words} maps to \code{NA}.
#' The column may be logical, numbers, text or a factor, read as text. Any
#' other class, or a value whose key is not among \code{words}' names,
#' stops, naming the caller, the column and up to five such values, then
#' \code{advice}.
#' @param ped data frame with an \code{id} column.
#' @param column the column's name.
#' @param words what each key means, named by the key.
#' @param key a function giving each value's key from its text.
#' @param caller the caller's name, without parentheses, for the message.
#' @param advice the message's last sentence: the values to give.
#' @return \code{NULL}, or a character vector named by \code{ped$id}.
#' @noRd
.readWordColumn <- function(ped, column, words, key, caller, advice) {
  if (!column %in% names(ped)) {
    return(NULL)
  }
  x <- ped[[column]]
  if (is.factor(x)) x <- as.character(x)
  if (!is.logical(x) && !is.numeric(x) && !is.character(x)) {
    shown <- paste("a column of class", class(x)[[1L]])
  } else {
    keys <- key(as.character(x))
    kind <- unname(words[keys])
    shown <- .oddValuesShown(x[!is.na(x) & !keys %in% names(words)])
  }
  if (!is.null(shown)) {
    stop(caller, "(): the column '", column, "' holds values it cannot ",
         "read (", shown, "). ", advice, call. = FALSE)
  }
  stats::setNames(kind, as.character(ped$id))
}

#' Up to five animals' ids, as a message names them
#'
#' Phase G13 (R136, R139): the first five, then \dQuote{...} when there are
#' more. S59's REFACTOR: \code{.checkProbandConsultand()} and
#' \code{.checkMiscarriage()} had the same lines.
#' @param ids the animals' ids.
#' @return A character string.
#' @noRd
.idsShown <- function(ids) {
  shown <- toString(utils::head(ids, 5L))
  if (length(ids) > 5L) shown <- paste0(shown, ", ...")
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
  marked <- unname(marks[.nodeAnimals(nodeIds, dupIds, dupRealIds)])
  !is.na(marked) & marked
}

#' The animal each node of a layout stands for
#'
#' Phase G13 (R134, R138): a repeat-appearance node's real id, every other
#' node's own id (a mating union's or a routing point's matches no animal).
#' S58's REFACTOR: \code{.markedNodes()} and the fertility column's
#' \code{.fertilityNodes()} (R/infertileMark.R) had the same line.
#' @param nodeIds ids of the layout's nodes.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return character vector, as long as \code{nodeIds}.
#' @noRd
.nodeAnimals <- function(nodeIds, dupIds, dupRealIds) {
  ifelse(nodeIds %in% dupIds, dupRealIds[match(nodeIds, dupIds)], nodeIds)
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

#' Which nodes have a mark's field TRUE
#'
#' Phase G13 (R136, R137). S57's REFACTOR, from \code{.probandArrowRoom()}.
#' @param nodes the nodes to draw.
#' @param column the field's name, such as \code{"proband"}.
#' @return logical vector, one per node, never \code{NA}; all \code{FALSE}
#'   when the nodes have no such field.
#' @noRd
.markField <- function(nodes, column) {
  x <- nodes[[column]]
  if (is.null(x)) logical(nrow(nodes)) else !is.na(x) & x
}

#' Invisible points beside the marked nodes
#'
#' Phase G13 (R136, R137). vis.js fits its view to the nodes with a twentieth
#' of the range to spare on each side, so a mark a script draws outside a
#' node's box (the proband's and the consultand's arrow, the evaluated star)
#' could fall outside the canvas at the drawing's edge. This adds one point
#' per marked node, invisible as the layout's routing points are (size 0, a
#' transparent fill and outline, no label, every logical field
#' \code{FALSE} and a \code{fertility} and a \code{miscarriage} field
#' \code{""}, so no mark is drawn there), so vis.js's fit takes the marks
#' in. S57's REFACTOR:
#' \code{.probandArrowRoom()} and \code{.evaluatedStarRoom()} had the same
#' lines.
#' @param nodes the nodes to draw.
#' @param marked logical vector, one per node: the nodes that get a point.
#' @param prefix the start of each point's id, which its node's id follows; a
#'   prefix the layout reserves (\code{.reservedIdPrefixes}).
#' @param at where each point goes, \code{x} and \code{y} (y down), in units
#'   of its node's \code{size} from the node's centre.
#' @param shift a further shift of each point, \code{x} and \code{y}, in
#'   units.
#' @return \code{nodes} with one more row per marked node; \code{nodes}
#'   itself when none is marked.
#' @noRd
.markRoom <- function(nodes, marked, prefix, at, shift) {
  if (!any(marked)) {
    return(nodes)
  }
  if (!"color.border" %in% names(nodes)) {
    nodes$color.border <- NA_character_
  }
  room <- nodes[marked, , drop = FALSE]
  for (column in names(room)) {
    if (is.logical(room[[column]])) room[[column]] <- FALSE
  }
  room$id <- paste0(prefix, room$id)
  room$label <- ""
  room$shape <- "dot"
  room$title <- NA_character_
  room$x <- room$x + room$size * at[[1L]] + shift[[1L]]
  room$y <- room$y + room$size * at[[2L]] + shift[[2L]]
  room$size <- 0L
  room$color.background <- "rgba(0,0,0,0)"
  room$color.border <- "rgba(0,0,0,0)"
  if ("affectedSections" %in% names(room)) room$affectedSections <- ""
  if ("borderWidth" %in% names(room)) room$borderWidth <- 1L
  if ("fertility" %in% names(room)) room$fertility <- ""
  if ("miscarriage" %in% names(room)) room$miscarriage <- ""
  out <- rbind(nodes, room)
  rownames(out) <- NULL
  out
}
