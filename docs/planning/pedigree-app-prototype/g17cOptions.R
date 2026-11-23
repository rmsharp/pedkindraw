# G17c, S76: the three ways the pre-RED picker offers for reading a file's
# yes-or-no columns, each run on g17cValues.R's value pairs (Learning 17).
# "now": every value as text, as the app reads it today. "read.csv": the
# column typed by utils::type.convert(), as a script that reads the file
# with read.csv()'s defaults gets it. "words": a prototype of the common
# words (yes: true, t, yes, y, 1; no: false, f, no, n, 0; any case, spaces
# trimmed; a column of numbers as numbers), not the GREEN code. Printed for
# each: how o1 (yes), o2 (no) and d1 (empty) are drawn in the condition
# column affected and in the mark column genotyped, or where it stops. Not
# package code. Run from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17cOptions.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
base <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"),
                   dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
pairs <- list(c("TRUE", "FALSE"), c("true", "false"), c("T", "F"),
              c("1", "0"), c("Y", "N"), c("yes", "no"), c("2", "1"),
              c("affected", "unaffected"), c("2.5", "0.3"))
words <- function(x) {
  x <- trimws(x)
  number <- suppressWarnings(as.numeric(x))
  if (all(is.na(x) | !is.na(number))) {
    return(number)
  }
  key <- tolower(x)
  read <- ifelse(key %in% c("true", "t", "yes", "y", "1"), TRUE,
                 ifelse(key %in% c("false", "f", "no", "n", "0"), FALSE, NA))
  if (any(!is.na(x) & is.na(read))) {
    return(structure(x, unread = unique(x[!is.na(x) & is.na(read)])))
  }
  read
}
ways <- list(now = identity,
             read.csv = function(x) utils::type.convert(x, as.is = TRUE),
             words = words)
drawnAs <- function(ped, column) {
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  layout <- tryCatch(suppressWarnings(suppressMessages(
    makePedigreeMatingLayout(ped))), error = function(e) e)
  if (inherits(layout, "error")) {
    return("STOPS")
  }
  n <- layout$nodes
  at <- match(c("o1", "o2", "d1"), n$id)
  value <- if (column == "affected") {
    c("#CC79A7" = "yes", "#FFFFFF" = "no", "#BEBEBE" = "unknown")[
      n$color.background[at]]
  } else {
    c("4" = "yes", "1" = "no")[as.character(n$borderWidth[at])]
  }
  paste(value, collapse = "/")
}
expected <- c(affected = "yes/no/unknown", genotyped = "yes/no/no")
for (column in c("affected", "genotyped")) {
  cat(sprintf("== %s (right: %s)\n", column, expected[[column]]))
  right <- stats::setNames(integer(length(ways)), names(ways))
  for (p in pairs) {
    cells <- c(p[[2L]], NA, p[[1L]], p[[2L]])
    shown <- vapply(names(ways), function(w) {
      ped <- base
      value <- ways[[w]](cells)
      if (!is.null(attr(value, "unread"))) {
        return(paste0("the app names '", toString(attr(value, "unread")),
                      "'"))
      }
      ped[[column]] <- value
      drawnAs(ped, column)
    }, character(1L))
    right <- right + (shown == expected[[column]])
    cat(sprintf("  %-20s %s\n", paste0(p[[1L]], "/", p[[2L]]),
                paste(sprintf("%s: %s", names(ways), shown), collapse = " | ")))
  }
  cat(sprintf("  drawn right, of %d pairs: %s\n", length(pairs),
              paste(sprintf("%s %d", names(right), right), collapse = ", ")))
}
