# G17d, S77: which rows the app's CSV file saves (F17), measured before the
# pre-RED picker (Learning 17). With shiny::testServer() and no browser: a
# pedigree is opened and drawn in each way of choosing the animals, then two
# candidate CSV files are written as the app would write them: (a) the rows
# the Animals tab shows (shown(): the file's own columns, the four renamed
# id, sire, dam and sex) and (b) the drawing's data frame (prepared()$ped:
# the four, the conditions and the marks under pedkindraw's names). Each file
# is opened again in a fresh server, as a user would open it, the same
# conditions and cut-off chosen, everyone drawn; printed: the columns, the
# rows, and whether the layout is identical() to the first drawing's. Run on a
# spreadsheet-like typed file (a sire with no row of its own, a column of
# numbers with a cut-off, marks under other names) and on the sample's five
# families and whole drawing. Not package code. Run from the repository root
# with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17dCsv.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))

fileInput <- function(path) {
  data.frame(name = basename(path), size = file.size(path), type = "text/csv",
             datapath = path, stringsAsFactors = FALSE)
}

## Open `path` in a fresh server, choose the columns, conditions, cut-off and
## view, and keep the drawing's layout and both candidate files.
drawIn <- function(path, columns, conditions, cutoff, view, focal = "",
                   family = NULL, close = 3L) {
  ## testServer() evaluates its code in the server's environment, where view,
  ## focal and the others name the server's own reactives (dragon 14): the
  ## arguments are copied to names the server does not use.
  pPath <- path
  pColumns <- columns
  pConditions <- conditions
  pCutoff <- cutoff
  pView <- view
  pFocal <- focal
  pFamily <- family
  pClose <- close
  kept <- new.env()
  suppressPackageStartupMessages(shiny::testServer(.pedigreeAppServer(), {
    session$setInputs(file = fileInput(pPath))
    session$setInputs(idColumn = pColumns[["id"]],
                      sireColumn = pColumns[["sire"]],
                      damColumn = pColumns[["dam"]],
                      sexColumn = pColumns[["sex"]])
    session$setInputs(conditions = pConditions)
    if (!is.null(pCutoff)) {
      pK <- match(pCutoff$column, names(rawData()))
      pArgs <- list(pCutoff$op, pCutoff$value)
      names(pArgs) <- paste0(c("cutOp", "cutValue"), pK)
      do.call(session$setInputs, pArgs)
    }
    session$setInputs(view = pView, focal = pFocal, howClose = pClose)
    if (!is.null(pFamily)) session$setInputs(family = pFamily)
    kept$layout <- drawing()$layout
    kept$families <- families()
    kept$shown <- shown()
    kept$drawn <- prepared()$ped
    kept$added <- completed()$added
  }))
  as.list(kept)
}

write <- function(rows) {
  path <- tempfile(fileext = ".csv")
  utils::write.csv(rows, path, row.names = FALSE, na = "")
  path
}

roundTrip <- function(label, path, columns, conditions, cutoff, ...) {
  first <- drawIn(path, columns, conditions, cutoff, ...)
  four <- c(id = "id", sire = "sire", dam = "dam", sex = "sex")
  a <- write(first$shown)
  againA <- drawIn(a, four, conditions, cutoff, "all")
  drawnConditions <- .appConditionNames(conditions)
  cutB <- if (is.null(cutoff)) NULL else
    list(column = drawnConditions[match(cutoff$column, conditions)],
         op = cutoff$op, value = cutoff$value)
  b <- write(first$drawn)
  againB <- drawIn(b, four, drawnConditions, cutB, "all")
  cat(sprintf(paste0("%-34s %3d animals drawn; (a) %d cols, same: %-5s",
                     "(b) %d cols, same: %s\n"), label,
              sum(!startsWith(first$layout$nodes$id, "__")),
              ncol(first$shown), identical(first$layout, againA$layout),
              ncol(first$drawn), identical(first$layout, againB$layout)))
  invisible(list(first = first, a = againA, b = againB))
}

typed <- data.frame(
  ID = c("s1", "d1", "o1", "o2", "m1", "g1", "g2", "f1", "f2", "f3"),
  Father = c(NA, NA, "s1", "s1", "x9", "m1", "m1", NA, NA, "f1"),
  Mother = c(NA, NA, "d1", "d1", NA, "o1", "o1", NA, NA, "f2"),
  Gender = c("male", "female", "female", "male", "male", "female", "male",
             "M", "F", "F"),
  Affected = c(0, 0, 1, 0, 0, 1, 0, 0, 1, 0),
  glucose = c(90, 130, 150, 88, 101, 127, 95, 140, 99, 126),
  Avail = c("Y", "N", "Y", "Y", "N", "Y", "N", "N", "Y", "Y"),
  Deceased = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE,
               FALSE),
  birth = c("2001-01-01", "2002-02-02", "2005-05-05", "2006-06-06",
            "2004-04-04", "2010-10-10", "2011-11-11", "2000-01-01",
            "2000-02-02", "2008-08-08")
)
typedPath <- write(typed)
typedColumns <- c(id = "ID", sire = "Father", dam = "Mother", sex = "Gender")
cut <- list(column = "glucose", op = ">=", value = 126)
cat("Typed file: 10 rows, sire x9 has no row; conditions Affected and glucose",
    ">= 126\n")
r <- roundTrip("everyone", typedPath, typedColumns, c("Affected", "glucose"),
               cut, view = "all")
cat("  (a)'s columns:", toString(names(r$first$shown)), "\n")
cat("  (b)'s columns:", toString(names(r$first$drawn)), "\n")
cat("  added parents first:", toString(r$first$added), "; after (a):",
    toString(r$a$added), "; after (b):", toString(r$b$added), "\n")
roundTrip("one family (the largest)", typedPath, typedColumns,
          c("Affected", "glucose"), cut, view = "family", family = "1")
roundTrip("o1's ancestors and descendants", typedPath, typedColumns,
          c("Affected", "glucose"), cut, view = "lineal", focal = "o1")
roundTrip("o1's near relatives (3)", typedPath, typedColumns,
          c("Affected", "glucose"), cut, view = "near", focal = "o1")

cat("\nThe sample (no conditions, no marks):\n")
four <- c(id = "id", sire = "sire", dam = "dam", sex = "sex")
samplePath <- .appSamplePath()
first <- suppressWarnings(roundTrip("everyone", samplePath, four, character(0),
                                    NULL, view = "all"))
for (f in unname(.appFamilyChoices(first$first$families))) {
  suppressWarnings(roundTrip(sprintf("family %s", f), samplePath, four,
                             character(0), NULL, view = "family", family = f))
}
