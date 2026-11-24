## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own (S85, Phase 17i1, docs/planning/pedkindraw-timing-plan.md
## sections 4.5 and 5.7; R159): checks that every table of the speed
## vignette, vignettes/speed.Rmd, equals the table built from the timing
## records in tools/timing/results/, cell for cell, captions included; that
## every table on the page has its <!-- speed-table: <name> --> line; and that
## every number in the page's prose is in a table or is one of the method's
## own (speedMethodNumbers() in tools/timing/speedTables.R, which does the
## work). Base R only: CI runs it (R159).
##
## Usage, from the project root:
##   Rscript tools/checkSpeedTables.R [--root=<dir>] [--print=<name>|all]
## --root names a folder holding vignettes/speed.Rmd and tools/timing/results/
## (by default the folder above this script's tools/, the project root; the
## tests use a copy). --print prints the
## table that name stands for, with its marker and caption, as the page must
## hold it, and checks nothing. Prints each difference; exit status 0 only
## when there is none.

args <- commandArgs(trailingOnly = TRUE)
option <- function(name, default) {
  given <- args[startsWith(args, paste0("--", name, "="))]
  if (length(given) == 0L) default else sub("^[^=]*=", "", given[1L])
}
self <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
here <- if (length(self) == 1L) dirname(self) else "tools"
# nolint start: undesirable_function_linter.
source(file.path(here, "timing", "speedTables.R"))
# nolint end
## The speed*() functions come from speedTables.R, which lintr cannot see.
# nolint start: object_usage_linter.
root <- option("root", dirname(here))
printName <- option("print", "")

src <- tryCatch(speedSources(root), error = function(e) {
  message(conditionMessage(e))
  quit(status = 1L)
})
tables <- speedTables(src)

if (nzchar(printName)) {
  chosen <- if (printName == "all") names(tables) else printName
  unknown <- setdiff(chosen, names(tables))
  if (length(unknown) > 0L) {
    message("no table '", unknown[1L], "'; the tables are ",
            toString(names(tables)))
    quit(status = 1L)
  }
  for (name in chosen) {
    writeLines(c(speedTableLines(name, tables[[name]]), ""))
  }
  quit(status = 0L)
}

page <- file.path(root, "vignettes", "speed.Rmd")
if (!file.exists(page)) {
  message("no ", file.path("vignettes", "speed.Rmd"), " under ", root)
  quit(status = 1L)
}
result <- speedCheck(readLines(page, warn = FALSE, encoding = "UTF-8"), src)
if (length(result$problems) > 0L) writeLines(result$problems)
cat(sprintf(
  paste("%d tables, %d cells equal to the records; %d numbers in the prose;",
        "%d problems\n"),
  result$tables, result$equal, result$prose, length(result$problems)
))
quit(status = if (length(result$problems) > 0L) 1L else 0L)
# nolint end
