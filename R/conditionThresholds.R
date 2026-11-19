## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G12,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings
## R131-R132, pedkindraw S53). The copied builders makePedigreeDiagramData()
## and makePedigreeMatingLayout() call these for their argument
## conditionThresholds (DIVERGENCE.md). Written from Pedixplorer's help for
## generate_colors() and generate_aff_inds() and their measured results, not
## from its code (plan dragon 6): its threshold with sup_thres_aff TRUE or
## FALSE decides as > and < do here.

#' Read the cut-offs of the measured traits
#'
#' Phase G12. Each element of \code{conditionThresholds} names a condition
#' column of \code{ped} and gives its cut-off as a comparison: \code{>},
#' \code{>=}, \code{<} or \code{<=} and a number, such as \code{"> 5"} or
#' \code{">= 126"}; spaces around either are allowed. The column must hold
#' numbers (or only \code{NA}).
#' @param conditionThresholds the argument, \code{NULL} or a named character
#'   vector.
#' @param ped the pedigree.
#' @param caller the name of the calling function, for the messages.
#' @return \code{NULL} for \code{NULL}; otherwise a data frame with one row
#'   per cut-off: \code{column}, \code{op} (the comparison), \code{value}
#'   (the number) and \code{text} (the number as written).
#' @noRd
.checkConditionThresholds <- function(conditionThresholds, ped, caller) {
  if (is.null(conditionThresholds)) {
    return(NULL)
  }
  x <- conditionThresholds
  if (!is.character(x) || length(x) == 0L || is.null(names(x)) ||
        anyNA(x) || anyNA(names(x)) || !all(nzchar(names(x))) ||
        anyDuplicated(names(x)) > 0L) {
    stop(caller, "() requires 'conditionThresholds' to be NULL or a ",
         "character vector named by condition columns, such as ",
         "c(affected = \"> 5\").", call. = FALSE)
  }
  parts <- regmatches(x, regexec("^\\s*(>=|<=|>|<)\\s*(\\S+)\\s*$", x))
  read <- lengths(parts) == 3L
  value <- rep(NA_real_, length(x))
  value[read] <- suppressWarnings(as.numeric(vapply(parts[read], `[[`,
                                                     character(1L), 3L)))
  bad <- !is.finite(value)
  if (any(bad)) {
    stop(caller, "() requires each cut-off in 'conditionThresholds' to be ",
         ">, >=, < or <= and a number, such as \"> 5\"; cannot read: ",
         toString(sprintf("\"%s\"", x[bad])), ".", call. = FALSE)
  }
  notCondition <- setdiff(names(x), .conditionColumns(ped))
  if (length(notCondition) > 0L) {
    stop(caller, "() requires 'conditionThresholds' to name condition ",
         "columns of 'ped' (names starting with 'affected'); not one: ",
         toString(notCondition), ".", call. = FALSE)
  }
  notNumbers <- names(x)[!vapply(names(x), function(column) {
    is.numeric(ped[[column]]) || all(is.na(ped[[column]]))
  }, logical(1L))]
  if (length(notNumbers) > 0L) {
    stop(caller, "() requires a column with a cut-off in ",
         "'conditionThresholds' to hold numbers; not numbers: ",
         toString(notNumbers), ".", call. = FALSE)
  }
  data.frame(column = names(x),
             op = vapply(parts, `[[`, character(1L), 2L),
             value = value,
             text = vapply(parts, `[[`, character(1L), 3L),
             stringsAsFactors = FALSE)
}

#' Which values are affected by a cut-off
#'
#' Phase G12. \code{NA} (and \code{NaN}) stays unknown.
#' @param values the column's numbers.
#' @param op one of \code{">"}, \code{">="}, \code{"<"}, \code{"<="}.
#' @param value the cut-off.
#' @return logical vector, as long as \code{values}.
#' @noRd
.thresholdAffected <- function(values, op, value) {
  values <- as.numeric(values)
  switch(op,
         ">" = values > value,
         ">=" = values >= value,
         "<" = values < value,
         "<=" = values <= value)
}

#' The label of a condition with a cut-off
#'
#' Phase G12. The rule goes inside the label's brackets, the comparison as
#' a symbol (\code{>=} and \code{<=} written as the signs U+2265 and U+2264)
#' and the number as written: \dQuote{Affected (> 5)}, \dQuote{Affected
#' (glucose >= 126)} with the sign, \dQuote{Affected 2 (< 13)}.
#' @param label the label \code{.conditionLabels()} gives the column.
#' @param op the comparison.
#' @param text the number as written.
#' @return character, the label.
#' @noRd
.thresholdLabel <- function(label, op, text) {
  symbol <- switch(op, ">" = ">", ">=" = "\u2265", "<" = "<",
                   "<=" = "\u2264")
  rule <- paste(symbol, text)
  if (endsWith(label, ")")) {
    sub("\\)$", paste0(" ", rule, ")"), label)
  } else {
    sprintf("%s (%s)", label, rule)
  }
}

#' What the tooltip says of a condition with a cut-off
#'
#' Phase G12. \dQuote{Yes} or \dQuote{No} with the animal's number,
#' \dQuote{Unknown} without one.
#' @param affected logical vector, from \code{.thresholdAffected()}.
#' @param values the numbers.
#' @return character vector, as long as \code{affected}.
#' @noRd
.thresholdShown <- function(affected, values) {
  shown <- .affectedLabel(affected)
  known <- !is.na(affected)
  shown[known] <- sprintf("%s (%s)", shown[known],
                          vapply(values[known], format, character(1L)))
  shown
}

#' The advice of the builders' stop on a measured trait
#'
#' Phase G12. The end of \code{.checkConditionNumbers()}'s message in the
#' builders: give the column a cut-off.
#' @param column the condition column.
#' @return character, the advice.
#' @noRd
.thresholdAdvice <- function(column) {
  sprintf("give its cut-off in conditionThresholds, such as c(%s = \"> 5\").",
          column)
}
