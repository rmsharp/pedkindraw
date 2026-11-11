## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/affectedConditions.R at nprcgenekeepr commit
## baef1e12c, its lines 1-75 only: .conditionColors, .conditionColumns(),
## .conditionLabels() and .affectedSectionsOf(), which the layout uses (plan
## Phase 8). Changes: none to those lines. The file's other three functions,
## .conditionSectionsHandler(), .diagramAfterDrawing() and .diagramHeight() (its
## lines 77-201), only the drawing uses: they are copied with it in Phase 9
## (plan R32).

# More than one affected condition on the Pedigree Browser's Diagram (S1029)

#' The colors of the affected conditions, in order
#'
#' S1029. Condition 1 keeps the pink a lone \code{affected} column has always
#' had (\code{.affectedColor()}); the other three are the colour-blind-safe
#' Okabe-Ito orange, sky blue and bluish green. kinship2 allows four
#' conditions, so the length of this vector is the most the Diagram draws.
#' @noRd
.conditionColors <- c("#CC79A7", "#E69F00", "#56B4E9", "#009E73")

#' The pedigree columns that are affected conditions
#'
#' S1029 (owner ruling). Every column whose name starts with
#' \code{affected}, in the order the pedigree holds them. QC lower-cases a
#' header and drops its spaces, periods and underscores, so the test reads the
#' name as written: a raw data frame with \code{Affected2} has no such
#' column, as it never had \code{affected}.
#' @param ped data frame.
#' @return character vector of column names, \code{character(0)} for none.
#' @noRd
.conditionColumns <- function(ped) {
  grep("^affected", names(ped), value = TRUE)
}

#' What the legend and the tooltip call each condition
#'
#' S1029. \dQuote{Affected} for the column \code{affected}, \dQuote{Affected 2}
#' where the rest of the name is a number, and \dQuote{Affected (diabetes)}
#' for the rest of the name otherwise. A separator left at the front of the
#' rest (\code{affected_diabetes} in a raw data frame) is dropped.
#' @param columns character vector of condition column names.
#' @return character vector, as long as \code{columns}.
#' @noRd
.conditionLabels <- function(columns) {
  vapply(columns, function(column) {
    rest <- sub("^[._ -]+", "", sub("^affected", "", column))
    if (!nzchar(rest)) {
      "Affected"
    } else if (grepl("^[0-9]+$", rest)) {
      paste("Affected", rest)
    } else {
      sprintf("Affected (%s)", rest)
    }
  }, character(1L), USE.NAMES = FALSE)
}

#' The affectedSections string of each node
#'
#' S1029. One character per condition for an animal: \code{"1"} where it is
#' affected, \code{"0"} where it is unaffected or unknown. A repeat-appearance
#' node reads as its real animal; a mating-union, drop, bar or waypoint node is
#' not an animal and gets \code{""}, never \code{NA}.
#' @param nodeIds ids of the layout's nodes.
#' @param conditionOf list with one logical vector per drawn condition, named
#'   by real id.
#' @param realIds ids of the animals, in the order of the vectors.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return character vector, as long as \code{nodeIds}.
#' @noRd
.affectedSectionsOf <- function(nodeIds, conditionOf, realIds, dupIds,
                                dupRealIds) {
  flags <- do.call(cbind, lapply(conditionOf, function(v) {
    ifelse(!is.na(v) & v, "1", "0")
  }))
  sectionsOf <- stats::setNames(apply(flags, 1L, paste, collapse = ""),
                                realIds)
  animalOf <- ifelse(nodeIds %in% dupIds,
                     dupRealIds[match(nodeIds, dupIds)], nodeIds)
  ifelse(animalOf %in% realIds, unname(sectionsOf[animalOf]), "")
}
