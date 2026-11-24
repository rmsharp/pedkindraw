## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own, not copied from nprcgenekeepr (S85, Phase 17i1,
## docs/planning/pedkindraw-timing-plan.md sections 4.5, 5.7 and 6; R159).
## Tests for the speed vignette's check: tools/checkSpeedTables.R builds every
## table of vignettes/speed.Rmd from the timing records in
## tools/timing/results/ (tools/timing/speedTables.R does the work) and fails
## on any difference: a changed cell, swapped rows, a table with no marker
## line, a changed result file, a number in the prose that is in no table.
## The 17i DONE's "scratch tree" is a copy of the page and the results in a
## temporary folder (speedCopy()). Run from the project root:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_checkSpeedTables.R")'

library(testthat) # nolint: undesirable_function_linter.

## projectRoot and packagesNamed() come from helper-checks.R, the speed*()
## functions from speedTables.R, the case lists from timingCases.R and
## drawingTimingCases.R, which lintr cannot see.
# nolint start: object_usage_linter.

sourceComparisonScript("speedTables.R")
## The case lists the page's names are checked against.
sourceComparisonScript("comparisonFormats.R")
sourceComparisonScript("measure.R")
sourceComparisonScript("timingCases.R")
sourceComparisonScript("drawingTimingCases.R")

checkScript <- file.path(projectRoot, "tools", "checkSpeedTables.R")
resultsDir <- file.path(projectRoot, "tools", "timing", "results")

## A copy of what the check reads, the page and the result files, in a
## temporary folder removed when the calling test ends.
speedCopy <- function(env = parent.frame()) {
  root <- tempfile("speed")
  dir.create(file.path(root, "vignettes"), recursive = TRUE)
  dir.create(file.path(root, "tools", "timing", "results"), recursive = TRUE)
  file.copy(file.path(projectRoot, "vignettes", "speed.Rmd"),
            file.path(root, "vignettes"))
  file.copy(list.files(resultsDir, pattern = "[.]csv$", full.names = TRUE),
            file.path(root, "tools", "timing", "results"))
  withr::defer(unlink(root, recursive = TRUE), envir = env)
  root
}

## Runs the check in a fresh R with no site or user settings; its exit status
## and everything it printed.
runCheck <- function(...) {
  out <- suppressWarnings(system2(
    file.path(R.home("bin"), "Rscript"),
    c("--vanilla", shQuote(checkScript), ...),
    stdout = TRUE, stderr = TRUE
  ))
  list(status = attr(out, "status") %||% 0L, out = paste(out, collapse = "\n"))
}

## Replaces the one line of `file` holding `from` with `to`.
changeLine <- function(file, from, to) {
  lines <- readLines(file, warn = FALSE, encoding = "UTF-8")
  at <- grep(from, lines, fixed = TRUE)
  expect_length(at, 1L)
  lines[at] <- to
  writeLines(lines, file)
}

pageOf <- function(root) file.path(root, "vignettes", "speed.Rmd")
idsOf <- function(cases) vapply(cases, `[[`, "", "id")

## ---- what the tables name -------------------------------------------------

test_that("the page's computation rows are timingCases.R's 78 cases, each in
           the group of the list it is in", {
  cases <- speedComputationCases()
  expect_identical(anyDuplicated(cases$case), 0L)
  expect_setequal(cases$case[cases$group == "study"], idsOf(studyCases()))
  expect_setequal(cases$case[cases$group == "paired"], idsOf(pairedCases()))
  expect_setequal(cases$case[cases$group == "pedkindraw"],
                  idsOf(pedkindrawOnlyCases()))
  expect_identical(nrow(cases), 78L)
})

test_that("each function the page names is one its case's timed call calls,
           with the arguments it shows", {
  cases <- speedComputationCases()
  calls <- timingCases()
  names(calls) <- idsOf(calls)
  for (i in seq_len(nrow(cases))) {
    shown <- gsub("`", "", cases$fn[i], fixed = TRUE)
    name <- sub("\\(.*$", "", shown)
    inside <- sub("^[^(]*\\((.*)\\)$", "\\1", shown)
    code <- deparse1(calls[[cases$case[i]]]$call, collapse = "\n")
    ## Called, or passed to lapply() as Pedixplorer::ancestors is.
    expect_true(grepl(paste0(name, "("), code, fixed = TRUE) ||
                  grepl(paste0("::", name), code, fixed = TRUE),
                label = paste(cases$case[i], "calls", name))
    for (a in strsplit(inside, ", ", fixed = TRUE)[[1L]]) {
      expect_true(grepl(a, code, fixed = TRUE),
                  label = paste(cases$case[i], "passes", a))
    }
  }
})

test_that("the page's drawing rows are drawingTimingCases.R's 11 cases", {
  cases <- speedDrawingCases()
  expect_identical(anyDuplicated(cases$case), 0L)
  expect_setequal(cases$case, idsOf(drawingCases()))
})

test_that("the records hold a row for each case the page names, and the page
           names every case they hold", {
  expect_setequal(
    unique(utils::read.csv(file.path(resultsDir, "timing.csv"))$case),
    speedComputationCases()$case
  )
  expect_setequal(
    unique(utils::read.csv(file.path(resultsDir, "drawingTiming.csv"))$case),
    speedDrawingCases()$case
  )
})

## ---- how a cell is written ------------------------------------------------

test_that("seconds are written to three significant figures, under a
           millisecond as <0.001", {
  expect_identical(speedSeconds(0.0004), "<0.001")
  expect_identical(speedSeconds(0.001), "0.001")
  expect_identical(speedSeconds(0.0123456), "0.0123")
  expect_identical(speedSeconds(15.979), "16")
  expect_identical(speedSeconds(105.6), "106")
  expect_identical(speedSeconds(1234.5), "1,230")
})

test_that("a failed size reads time, memory, error or crash, and a timed call
           that never started reads 'not timed'", {
  expect_identical(speedFailWord("time", "over 120 s after the call started"),
                   "time")
  expect_identical(speedFailWord("memory", "R heap over 29.8 GiB"), "memory")
  expect_identical(speedFailWord("error", "subscript out of bounds"), "error")
  expect_identical(speedFailWord("error", "*** caught segfault ***"), "crash")
  expect_identical(speedFailWord("error", "no 'CALL START' within 300 s"),
                   "not timed")
})

test_that("the SVG and PNG saves at 3,000 read 'not timed' and no table says
           'refused' (R158, dragon 33)", {
  tables <- speedTables(speedSources(projectRoot))
  drawing <- tables[["drawing-seconds"]]
  at3000 <- match("3,000", drawing$header)
  rows <- vapply(drawing$rows, `[[`, "", 2L)
  for (save in c("SVG file", "PNG file")) {
    row <- drawing$rows[[which(startsWith(rows, save))]]
    expect_identical(row[[at3000]], "not timed")
  }
  every <- unlist(lapply(tables, function(t) c(unlist(t$rows), t$caption)))
  expect_false(any(grepl("refused", every, fixed = TRUE)))
})

test_that("speedTables.R calls no package but utils and stats, so CI runs it
           with none installed (R159)", {
  e <- new.env()
  sys.source(file.path(projectRoot, "tools", "timing", "speedTables.R"),
             envir = e)
  named <- unique(unlist(lapply(as.list(e), function(f) {
    if (is.function(f)) packagesNamed(f) else character()
  })))
  expect_true(all(named %in% c("utils", "stats")), label = toString(named))
  text <- readLines(file.path(projectRoot, "tools", "timing", "speedTables.R"))
  expect_false(any(grepl("(library|require|requireNamespace)\\(", text)))
})

## ---- the check -------------------------------------------------------------

test_that("the check passes on the page and the records as committed, and
           says what it compared", {
  r <- runCheck()
  expect_identical(r$status, 0L, label = r$out)
  expect_match(r$out, paste(
    "8 tables, [0-9]+ cells equal to the records; [0-9]+ numbers in the",
    "prose; 0 problems"
  ))
})

test_that("a changed number in a table fails, naming the table, line and
           column", {
  root <- speedCopy()
  page <- pageOf(root)
  lines <- readLines(page, warn = FALSE, encoding = "UTF-8")
  ## The first such row is in 'computation-study'; the second in
  ## 'computation-capacity'.
  at <- grep("^\\| Kinship, autosomal \\| pedkindraw \\|", lines)[1L]
  expect_false(is.na(at))
  cells <- speedCells(lines[at])
  cells[8L] <- "99.9"
  lines[at] <- speedRowLine(cells)
  writeLines(lines, page)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "table 'computation-study', line [0-9]+, column '30,000'")
  expect_match(r$out, "'99.9'", fixed = TRUE)
})

test_that("two rows swapped fail", {
  root <- speedCopy()
  page <- pageOf(root)
  lines <- readLines(page, warn = FALSE, encoding = "UTF-8")
  ## The first of each, in 'computation-study'.
  a <- grep("^\\| Kinship, autosomal \\| pedkindraw \\|", lines)[1L]
  b <- grep("^\\| Kinship, autosomal \\| kinship2 \\|", lines)[1L]
  expect_false(anyNA(c(a, b)))
  lines[c(a, b)] <- lines[c(b, a)]
  writeLines(lines, page)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out,
               "table 'computation-study', line [0-9]+, column 'Package'")
})

test_that("a table with no marker line before it fails", {
  root <- speedCopy()
  page <- pageOf(root)
  lines <- readLines(page, warn = FALSE, encoding = "UTF-8")
  marker <- grep("<!-- speed-table: drawing-parts -->", lines, fixed = TRUE)
  expect_length(marker, 1L)
  writeLines(lines[-marker], page)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "a table with no <!-- speed-table: <name> --> line",
               fixed = TRUE)
  expect_match(r$out, "no table 'drawing-parts' on the page", fixed = TRUE)
})

test_that("a changed result file fails", {
  root <- speedCopy()
  file <- file.path(root, "tools", "timing", "results", "timing.csv")
  d <- utils::read.csv(file, stringsAsFactors = FALSE)
  at <- which(d$case == "pkd_kin" & d$size == 30000L)
  expect_length(at, 1L)
  d$seconds[at] <- 31.0
  utils::write.csv(d, file, row.names = FALSE)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "the records '31'", fixed = TRUE)
})

test_that("a changed record row changes the captions, and fails", {
  root <- speedCopy()
  file <- file.path(root, "tools", "timing", "results", "record.csv")
  d <- utils::read.csv(file, stringsAsFactors = FALSE)
  d$kinship2 <- "1.9.7"
  utils::write.csv(d, file, row.names = FALSE)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "the caption is", fixed = TRUE)
  expect_match(r$out, "kinship2 1.9.7", fixed = TRUE)
})

test_that("a number in the prose that is in no table fails", {
  root <- speedCopy()
  page <- pageOf(root)
  lines <- readLines(page, warn = FALSE, encoding = "UTF-8")
  writeLines(c(lines, "", "A drawing of 777 animals took 12.345 seconds."),
             page)
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "the number 12.345 is in no table", fixed = TRUE)
  expect_match(r$out, "the number 777 is in no table", fixed = TRUE)
})

test_that("a missing page fails", {
  root <- speedCopy()
  unlink(pageOf(root))
  r <- runCheck(paste0("--root=", root))
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, paste("no", file.path("vignettes", "speed.Rmd")),
               fixed = TRUE)
})

test_that("--print=<name> prints the table as the page holds it, and an
           unknown name fails", {
  r <- runCheck("--print=drawing-capacity")
  expect_identical(r$status, 0L, label = r$out)
  lines <- strsplit(r$out, "\n", fixed = TRUE)[[1L]]
  expect_identical(lines[1L], "<!-- speed-table: drawing-capacity -->")
  expect_true(any(grepl("not timed at 3,000", lines, fixed = TRUE)))
  expect_true(any(startsWith(lines, "Table: ")))
  page <- readLines(file.path(projectRoot, "vignettes", "speed.Rmd"),
                    warn = FALSE, encoding = "UTF-8")
  shown <- lines[startsWith(lines, "|")]
  expect_true(all(shown %in% page))
  r <- runCheck("--print=nonesuch")
  expect_identical(r$status, 1L, label = r$out)
  expect_match(r$out, "no table 'nonesuch'; the tables are records,",
               fixed = TRUE)
})

## ---- CI (R159) -------------------------------------------------------------

test_that("a workflow of its own runs the check on Linux when the page, the
           results or the check change (R159)", {
  file <- file.path(projectRoot, ".github", "workflows", "speed-tables.yaml")
  expect_true(file.exists(file))
  text <- paste(readLines(file, warn = FALSE), collapse = "\n")
  expect_match(text, "runs-on: ubuntu-latest", fixed = TRUE)
  expect_match(text, paste("Rscript", file.path("tools", "checkSpeedTables.R")),
               fixed = TRUE)
  ## The workflow's own path filters, as GitHub reads them.
  # nolint start: nonportable_path_linter.
  for (path in c("vignettes/speed.Rmd", "tools/timing/results/**",
                 "tools/checkSpeedTables.R", "tools/timing/speedTables.R",
                 ".github/workflows/speed-tables.yaml")) {
    # nolint end
    expect_match(text, path, fixed = TRUE)
  }
  expect_false(grepl("windows|macos", text))
})
# nolint end
