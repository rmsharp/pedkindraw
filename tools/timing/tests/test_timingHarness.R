## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/tests/test_timingHarness.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: withSeed() from measure.R; the TIMING
## line also names the folder pedkindraw was loaded from (pkdLib); the
## packages are pedkindraw, kinship2 and Pedixplorer, and a case may name the
## packages it loads; PKD_LIB replaces CMP_LIB and NPG_LIB; the cases run on
## the 300-animal colony and the sample (caseValues(), helper-caseValues.R),
## not samplePed, and timeOne.R on the colony, not lacy1989Ped
## (tools/timing/data holds only the files savePedigrees.R rebuilds); new
## tests for PKD_LIB (section 5.5), the 78 cases and R154's inputs; and, in
## Phase 17h1b (R155), each run's row with its free memory (runRow()) and
## the record's row in record.csv (the commit and its build check, the
## versions, Chrome's and the machine's).
## Tests for the Phase 1 timing harness (docs/planning/
## standalone-pedigree-package-plan.md, Phase 1 steps 4-5): each measurement
## is one fresh Rscript (timeOne.R) run under /usr/bin/time -l, stopped past
## the time limit (counted from the call's start, not from loading) or the
## memory limit; the case list (timingCases.R); and the figures read back.
## They live beside the comparison scripts, not in the package suite (Mark's
## ruling, S1122). Run from the project root:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_timingHarness.R")'
## The tests that run a case need PKD_LIB, pedkindraw installed from a commit
## (docs/planning/pedkindraw-timing-plan.md section 5.5); they skip without
## it.

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("comparisonFormats.R")
sourceComparisonScript("timingHarness.R")
## withSeed(), which timingCases.R uses.
sourceComparisonScript("measure.R")
sourceComparisonScript("timingCases.R")

## ---- reading the reports --------------------------------------------------

timeReport <- c(
  "        0.20 real         0.11 user         0.04 sys",
  "            67960832  maximum resident set size",
  "                   0  average shared memory size",
  "                8908  page reclaims"
)

test_that("time's report gives the real seconds and the peak memory in bytes", {
  r <- parseTimeOutput(c("[1] 2", timeReport))
  expect_identical(r$realSeconds, 0.20)
  expect_identical(r$maxRssBytes, 67960832.0)
})

test_that("a report without the peak-memory line is an error naming it", {
  expect_error(
    parseTimeOutput(timeReport[-2L]),
    "maximum resident set size"
  )
})

test_that("the TIMING line gives seconds, heap peak, memory, packages and
  pedkindraw's folder", {
  out <- c(
    "a message", "CALL START",
    paste(
      "TIMING seconds=0.25 heapPeakMb=1.5 preRssMb=60.2",
      # nolint next: absolute_path_linter, nonportable_path_linter.
      "loaded=kinship2,pedkindraw pkdLib=/a b/lib"
    ),
    "after"
  )
  r <- parseTimingLine(out)
  expect_identical(r$seconds, 0.25)
  expect_identical(r$heapPeakMb, 1.5)
  expect_identical(r$preRssMb, 60.2)
  expect_identical(r$loaded, c("kinship2", "pedkindraw"))
  # nolint next: absolute_path_linter, nonportable_path_linter.
  expect_identical(r$pkdLib, "/a b/lib")
  none <- parseTimingLine("TIMING seconds=1 heapPeakMb=0 preRssMb=50 loaded=")
  expect_identical(none$loaded, character())
  expect_identical(none$pkdLib, "")
})

test_that("output without a TIMING line gives NULL", {
  expect_null(parseTimingLine(c("CALL START", "Error: boom")))
})

test_that("the 1-minute load is read from GNU uptime's line", {
  line <- paste(
    "14:43:12  up 2 days 20:20,  7 users,",
    "load average: 15.82, 13.22, 9.64"
  )
  expect_identical(parseLoadAverage(line), 15.82)
})

test_that("the 1-minute load is read from macOS uptime's line", {
  line <- "14:43  up 2 days, 20:20, 7 users, load averages: 3.01 2.50 2.10"
  expect_identical(parseLoadAverage(line), 3.01)
})

## ---- the quiet rule ---------------------------------------------------------

## macOS's `memory_pressure -Q`.
memoryPressureText <- c(
  "The system has 103079215104 (6291456 pages with a page size of 16384).",
  "System-wide memory free percentage: 53%"
)

test_that("the free memory share is read from memory_pressure's report", {
  expect_identical(parseMemoryFree(memoryPressureText), 53.0)
})

test_that("a report without the free share is an error naming it", {
  expect_error(
    parseMemoryFree(memoryPressureText[1L]),
    "memory free percentage"
  )
})

## A reader that gives the next value of `values` at each call, then the last.
sequenceOf <- function(values) {
  state <- new.env()
  state$i <- 0L
  function() {
    state$i <- min(state$i + 1L, length(values))
    values[[state$i]]
  }
}
## A pause that only counts how often it was called.
countingPause <- function() {
  state <- new.env()
  state$n <- 0L
  list(
    pause = function() state$n <- state$n + 1L,
    count = function() state$n
  )
}
noPause <- function() stop("no pause expected")

test_that("a quiet machine is taken at once, with idle, memory and load", {
  q <- waitForQuiet(80.0, Inf,
    memFloor = 50.0, idleOf = function() 90.0,
    memOf = function() 60.0, loadOf = function() 1.5, pause = noPause
  )
  expect_true(q$quiet)
  expect_identical(q$idle, 90.0)
  expect_identical(q$memFree, 60.0)
  expect_identical(q$load, 1.5)
})

test_that("it waits while memory is short, though the CPU is idle", {
  p <- countingPause()
  q <- waitForQuiet(80.0, Inf,
    memFloor = 50.0, idleOf = function() 95.0,
    memOf = sequenceOf(c(40.0, 45.0, 55.0)), loadOf = function() 1.0,
    pause = p$pause
  )
  expect_identical(p$count(), 2L)
  expect_true(q$quiet)
  expect_identical(q$memFree, 55.0)
})

test_that("it waits while the CPU is busy, though memory is free", {
  p <- countingPause()
  q <- waitForQuiet(80.0, Inf,
    memFloor = 50.0, idleOf = sequenceOf(c(60.0, 70.0, 85.0)),
    memOf = function() 60.0, loadOf = function() 1.0, pause = p$pause
  )
  expect_identical(p$count(), 2L)
  expect_true(q$quiet)
  expect_identical(q$idle, 85.0)
})

test_that("past maxWait it stops waiting and says the machine was not quiet", {
  q <- waitForQuiet(80.0, -1.0,
    memFloor = 50.0, idleOf = function() 20.0,
    memOf = function() 60.0, loadOf = function() 9.0, pause = noPause
  )
  expect_false(q$quiet)
  expect_identical(q$idle, 20.0)
})

test_that("with no memory floor the memory is not read (S1123's rule)", {
  q <- waitForQuiet(50.0, Inf,
    idleOf = function() 60.0,
    memOf = function() stop("memory read"), loadOf = function() 1.0,
    pause = noPause
  )
  expect_true(q$quiet)
  expect_true(is.na(q$memFree))
})

test_that("S1123's defaults stay: half the CPU idle, at most 10 minutes", {
  f <- formals(waitForQuiet)
  expect_identical(f$idleFloor, 50.0)
  expect_identical(f$maxWait, 600.0)
  expect_identical(f$memFloor, 0.0)
})

## ---- one cell: three runs, and the size ladder ----------------------------

okRun <- function(seconds, heap, rss, pre = 60.0) {
  list(
    status = "ok", message = "", seconds = seconds, heapPeakMb = heap,
    preRssMb = pre, maxRssBytes = rss
  )
}

test_that("three good runs give the median of each figure", {
  s <- summarizeRuns(list(
    okRun(3.0, 10.0, 5.0e8, 61.0), okRun(1.0, 30.0, 7.0e8, 60.0),
    okRun(2.0, 20.0, 6.0e8, 62.0)
  ))
  expect_identical(s$status, "ok")
  expect_identical(s$seconds, 2.0)
  expect_identical(s$heapPeakMb, 20.0)
  expect_identical(s$maxRssBytes, 6.0e8)
  expect_identical(s$preRssMb, 61.0)
  expect_identical(s$runs, 3L)
})

test_that("a failed run makes the cell fail with that run's status", {
  bad <- list(
    status = "time", message = "over 120 s", seconds = NA_real_,
    heapPeakMb = NA_real_, preRssMb = NA_real_, maxRssBytes = 9.0e8
  )
  s <- summarizeRuns(list(
    okRun(1.0, 10.0, 5.0e8), bad, okRun(1.0, 10.0, 5.0e8)
  ))
  expect_identical(s$status, "time")
  expect_identical(s$message, "over 120 s")
  expect_true(is.na(s$seconds))
})

ladder <- function(size, status, message = "") {
  data.frame(
    size = size, status = status, message = message,
    stringsAsFactors = FALSE
  )
}

test_that("capacity is the largest size before the first failure", {
  cap <- capacityOf(ladder(
    c(300L, 1000L, 3000L), c("ok", "ok", "time"),
    c("", "", "over 120 s")
  ))
  expect_identical(cap$capacity, 1000L)
  expect_identical(cap$failedAt, 3000L)
  expect_identical(cap$failure, "time")
  expect_identical(cap$message, "over 120 s")
})

test_that("a failure at the smallest size gives no capacity", {
  cap <- capacityOf(ladder(300L, "memory", "vector memory limit"))
  expect_true(is.na(cap$capacity))
  expect_identical(cap$failedAt, 300L)
  expect_identical(cap$failure, "memory")
})

test_that("no failure gives the largest size and no failure", {
  cap <- capacityOf(ladder(c(300L, 1000L, 100000L), "ok"))
  expect_identical(cap$capacity, 100000L)
  expect_true(is.na(cap$failedAt))
  expect_true(is.na(cap$failure))
})

test_that("sizes are taken in size order, not row order", {
  cap <- capacityOf(ladder(
    c(3000L, 300L, 1000L), c("time", "ok", "ok"),
    c("over 120 s", "", "")
  ))
  expect_identical(cap$capacity, 1000L)
  expect_identical(cap$failedAt, 3000L)
})

## ---- the limited runner, on tiny real child processes ---------------------

childScript <- function(lines) {
  f <- tempfile(fileext = ".R")
  writeLines(lines, f)
  f
}
# nolint next: nonportable_path_linter.
startLine <- "cat('CALL START\\n'); flush(stdout())"
timedRun <- function(...) {
  t0 <- proc.time()[["elapsed"]]
  r <- runLimited(..., wd = tempdir()) # nolint: object_usage_linter.
  r$wall <- proc.time()[["elapsed"]] - t0
  r
}

test_that("a child that finishes is ok, with its figures and peak memory", {
  f <- childScript(c(
    startLine,
    paste0(
      "cat('TIMING seconds=0.25 heapPeakMb=1.5 preRssMb=60 ",
      "loaded=kinship2\\n')" # nolint: nonportable_path_linter.
    )
  ))
  r <- timedRun(f, timeLimit = 10.0, memLimit = 8e9)
  expect_identical(r$status, "ok")
  expect_identical(r$seconds, 0.25)
  expect_identical(r$heapPeakMb, 1.5)
  expect_identical(r$preRssMb, 60.0)
  expect_identical(r$loaded, "kinship2")
  expect_gt(r$maxRssBytes, 1.0e7)
  expect_gt(r$realSeconds, 0.0)
})

test_that("a call running past the time limit is stopped as 'time'", {
  r <- timedRun(childScript(c(startLine, "Sys.sleep(8)")),
    timeLimit = 1.0, memLimit = 8e9
  )
  expect_identical(r$status, "time")
  expect_lt(r$wall, 5.0)
})

test_that("time spent before the call starts does not count", {
  f <- childScript(c(
    "Sys.sleep(2)", startLine,
    # nolint next: nonportable_path_linter.
    "cat('TIMING seconds=0.01 heapPeakMb=0 preRssMb=50 loaded=\\n')"
  ))
  r <- timedRun(f, timeLimit = 1.0, memLimit = 8e9)
  expect_identical(r$status, "ok")
})

test_that("a child over R's memory cap is 'memory'", {
  r <- timedRun(childScript(c(startLine, "x <- numeric(3e8)")),
    timeLimit = 30.0, memLimit = 1.0e9
  )
  expect_identical(r$status, "memory")
  expect_match(r$message, "vector memory limit")
})

test_that("a child whose process memory passes the limit is stopped", {
  f <- childScript(c(startLine, "x <- numeric(1e8); x[] <- 1", "Sys.sleep(8)"))
  r <- timedRun(f, timeLimit = 30.0, memLimit = 3.0e8, heapCap = NULL)
  expect_identical(r$status, "memory")
  expect_lt(r$wall, 6.0)
})

test_that("an R error is 'error' with its message", {
  r <- timedRun(childScript(c(startLine, "stop('boom')")),
    timeLimit = 10.0, memLimit = 8e9
  )
  expect_identical(r$status, "error")
  expect_match(r$message, "boom")
})

## ---- the cases ------------------------------------------------------------

packages <- c("pedkindraw", "kinship2", "Pedixplorer")

test_that("each case has a unique id, computation, package and two functions", {
  cases <- timingCases()
  ids <- vapply(cases, `[[`, "", "id")
  expect_false(anyDuplicated(ids) > 0L)
  for (k in cases) {
    expect_true(nzchar(k$computation), info = k$id)
    expect_true(k$package %in% packages, info = k$id)
    expect_true(is.function(k$prepare), info = k$id)
    expect_true(is.function(k$call), info = k$id)
    expect_true(is.character(k$loads), info = k$id)
  }
})

test_that("each case's code names only its own package and those it loads", {
  for (k in timingCases()) {
    used <- union(packagesNamed(k$prepare), packagesNamed(k$call))
    expect_true(all(used %in% c(k$package, k$loads)),
      info = paste(k$id, "names", toString(used))
    )
  }
})

## The plan's section 6 (17h1): each case returns on the 300-animal colony
## and the sample, but Pedixplorer's family_check(), which stops on the
## colony's own family numbers (R154, recorded). Pedixplorer's descendants()
## returns NULL when the probands have none, as the colony's 5 have none.
test_that("every case runs on the 300-animal colony and the sample and
  returns a value", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  for (name in c("colony", "sample")) {
    values <- caseValues(name)
    expect_length(values, 78L)
    for (id in names(values)) {
      if (identical(name, "colony") && identical(id, "pdx_famcheck")) {
        expect_s3_class(values[[id]], "error")
        expect_match(conditionMessage(values[[id]]),
          "'dimnames' applied to non-array",
          fixed = TRUE
        )
      } else if (identical(name, "colony") && identical(id, "pdx_desc")) {
        expect_null(values[[id]])
      } else {
        expect_false(inherits(values[[id]], "error"),
          info = paste(name, id)
        )
        expect_false(is.null(values[[id]]), info = paste(name, id))
      }
    }
  }
})

## The 300-animal colony where timeOne.R reads it (tools/timing/data, which
## git ignores; savePedigrees.R writes the same file).
colonyFile <- function() {
  file <- file.path("..", "data", "synthetic_300.csv")
  if (!file.exists(file)) {
    dir.create(dirname(file), showWarnings = FALSE)
    # nolint next: object_usage_linter.
    writeComparisonPedigree(generateColonyPedigree(300L, 1L), file)
  }
  invisible(file)
}

## runLimited() and projectRoot come from files lintr cannot see.
timeOne <- function(case, ped) {
  # nolint start: object_usage_linter.
  runLimited(normalizePath(file.path("..", "timeOne.R")), c(case, ped),
    timeLimit = 60.0, memLimit = 8e9, wd = projectRoot
  )
  # nolint end
}

test_that("timeOne.R runs a pedkindraw case and reports its figures and
  the folder pedkindraw came from", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  r <- timeOne("pkd_gen", "synthetic_300")
  expect_identical(r$status, "ok", info = r$message)
  expect_gte(r$seconds, 0.0)
  expect_gte(r$heapPeakMb, 0.0)
  expect_gt(r$preRssMb, 0.0)
  expect_true("pedkindraw" %in% r$loaded)
  expect_identical(r$pkdLib, normalizePath(Sys.getenv("PKD_LIB"), "/"))
})

test_that("a kinship2 case loads none of the other two packages", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  r <- timeOne("k2_kin", "synthetic_300")
  expect_identical(r$status, "ok", info = r$message)
  expect_identical(r$loaded, "kinship2")
})

## ---- pedkindraw's own library (plan section 5.5, section 8 dragon 2) ------

test_that("useTimingLibraries() puts PKD_LIB first and the library path it
  found next", {
  lib <- tempfile("pkdlib")
  dir.create(lib)
  before <- .libPaths() # nolint: undesirable_function_linter.
  old <- useTimingLibraries(pkdLib = lib)
  on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
  now <- .libPaths() # nolint: undesirable_function_linter.
  expect_identical(old, before)
  expect_identical(now[[1L]], normalizePath(lib, "/"))
  expect_identical(now[[2L]], before[[1L]])
})

test_that("checkPedkindrawFolder() passes pedkindraw's own scratch library", {
  lib <- tempfile("pkdlib")
  dir.create(lib)
  expect_silent(checkPedkindrawFolder(lib, lib))
})

test_that("checkPedkindrawFolder() stops when pedkindraw came from another
  folder, naming both and PKD_LIB", {
  lib <- tempfile("pkdlib")
  other <- tempfile("renvlib")
  dir.create(lib)
  dir.create(other)
  expect_error(checkPedkindrawFolder(other, lib), "PKD_LIB")
  expect_error(checkPedkindrawFolder(other, lib), basename(other),
    fixed = TRUE
  )
  expect_error(checkPedkindrawFolder(other, lib), basename(lib), fixed = TRUE)
})

test_that("a child whose PKD_LIB holds no pedkindraw fails, naming PKD_LIB", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  empty <- tempfile("emptylib")
  dir.create(empty)
  withr::local_envvar(PKD_LIB = empty)
  r <- timeOne("pkd_gen", "synthetic_300")
  expect_identical(r$status, "error")
  expect_match(r$message, "PKD_LIB")
})

test_that("a run that failed over PKD_LIB stops the record; others do not", {
  expect_true(stopsRecord(list(
    status = "error",
    # nolint next: nonportable_path_linter.
    message = "pedkindraw was loaded from /x, not from PKD_LIB (/y)"
  )))
  expect_false(stopsRecord(list(status = "ok", message = "")))
  expect_false(stopsRecord(list(status = "error", message = "boom")))
  expect_false(stopsRecord(list(status = "time", message = "over 120 s")))
})

## ---- the 78 cases (plan section 5.1, R153) and R154's inputs -------------

test_that("there are 78 cases: 37 pedkindraw, 18 kinship2, 23 Pedixplorer", {
  cases <- timingCases()
  expect_length(cases, 78L)
  counts <- table(vapply(cases, `[[`, "", "package"))
  expect_identical(
    as.integer(counts[c("pedkindraw", "kinship2", "Pedixplorer")]),
    c(37L, 18L, 23L)
  )
})

## The exports that draw are timed by the drawing harness (Phase 17h3), and
## runPedigreeApp() not at all (R153).
test_that("pedkindraw's cases call each of its 33 exports that do not draw", {
  exports <- sub(
    "^export\\((.*)\\)$", "\\1",
    grep("^export\\(", readLines(file.path(projectRoot, "NAMESPACE")),
      value = TRUE
    )
  )
  drawing <- c(
    "drawPedigreeDiagram", "makePedigreeDiagramData",
    "makePedigreeMatingLayout", "runPedigreeApp", "savePedigreeDiagram"
  )
  called <- unlist(lapply(timingCases(), function(k) {
    code <- deparse1(k$call, collapse = "\n")
    m <- regmatches(code, gregexpr("pedkindraw::[A-Za-z.]+", code))[[1L]]
    sub("^pedkindraw::", "", m)
  }))
  expect_setequal(unique(called), setdiff(exports, drawing))
  expect_length(setdiff(exports, drawing), 33L)
})

## The seed-1 colony of 300 animals, built in each test that needs it.
colony300 <- function() {
  generateColonyPedigree(300L, 1L) # nolint: object_usage_linter.
}

test_that("R154: 5 seeded animals with a known sire and no offspring", {
  colony <- colony300()
  i <- timingInputs(colony)
  expect_length(i$leaves, 5L)
  expect_false(anyDuplicated(i$leaves) > 0L)
  expect_false(anyNA(colony$sire[match(i$leaves, colony$id)]))
  expect_false(any(i$leaves %in% c(colony$sire, colony$dam)))
  expect_identical(i$leaves, timingInputs(colony)$leaves)
})

test_that("R154: IBD pairs, 1 for each animal and 0.5 for each sire and dam
  pair", {
  colony <- colony300()
  ibd <- timingInputs(colony)$ibd
  expect_named(ibd, c("id1", "id2", "x"))
  expect_identical(nrow(ibd), 852L)
  expect_identical(sum(ibd$x == 1.0), 300L)
  expect_identical(sum(ibd$x == 0.5), 552L)
  half <- ibd[ibd$x == 0.5, ]
  parents <- paste(colony$id, colony$sire)
  parents <- c(parents, paste(colony$id, colony$dam))
  expect_true(all(paste(half$id1, half$id2) %in% parents))
})

test_that("R154: 1 full-sibling pair per 100 animals, each from another
  sibship, coded DZ twin", {
  colony <- colony300()
  twins <- timingInputs(colony)$twins
  expect_named(twins, c("id1", "id2", "code"))
  expect_identical(nrow(twins), 3L)
  expect_identical(twins$code, rep("DZ twin", 3L))
  one <- match(twins$id1, colony$id)
  two <- match(twins$id2, colony$id)
  expect_identical(colony$sire[one], colony$sire[two])
  expect_identical(colony$dam[one], colony$dam[two])
  expect_false(anyNA(colony$sire[one]))
  expect_false(anyDuplicated(paste(colony$sire[one], colony$dam[one])) > 0L)
})

## A founder couple's family, a founder alone, a second family, and two
## animals whose only known parent, X, has no row: no founder reaches them.
test_that("familyNumbers() numbers families from 1 by their first founder", {
  expect_identical(
    familyNumbers(
      c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
      c(NA, NA, "A", NA, NA, NA, "E", "X", "X"),
      c(NA, NA, "B", NA, NA, NA, "F", NA, NA)
    ),
    c(1L, 1L, 1L, 2L, 3L, 3L, 3L, NA, NA)
  )
})

## ---- each run's row and the record (R155, Phase 17h1b) --------------------

## The figures of one run, as runLimited() returns them.
runFigures <- list(
  status = "ok", message = "", seconds = 0.5, heapPeakMb = 12.5,
  preRssMb = 60.0, maxRssBytes = 2.0 * 1048576.0, realSeconds = 1.75,
  loaded = c("kinship2", "Matrix"), pkdLib = ""
)

test_that("a run's row puts the free memory after the load, then the run's
  figures (R155)", {
  k <- list(id = "k2_kin", computation = "kinship", package = "kinship2")
  quiet <- list(quiet = TRUE, idle = 72.5, memFree = NA_real_, load = 3.25)
  row <- runRow(k, 300L, "measured", quiet, 45.0, runFigures,
    started = "2026-11-23 12:00:00"
  )
  expect_named(row, c(
    "case", "computation", "package", "size", "kind", "idle", "load",
    "memFree", "status", "message", "seconds", "heapPeakMb", "preRssMb",
    "maxRssMb", "realSeconds", "loaded", "pkdLib", "started"
  ))
  expect_identical(nrow(row), 1L)
  expect_identical(row$case, "k2_kin")
  expect_identical(row$size, 300L)
  expect_identical(row$idle, 72.5)
  expect_identical(row$load, 3.25)
  expect_identical(row$memFree, 45.0)
  expect_identical(row$seconds, 0.5)
  expect_identical(row$maxRssMb, 2.0)
  expect_identical(row$loaded, "kinship2,Matrix")
  expect_identical(row$started, "2026-11-23 12:00:00")
})

## `sysctl hw.model machdep.cpu.brand_string hw.ncpu hw.memsize` on this Mac.
sysctlText <- c(
  "hw.model: Mac14,6",
  "machdep.cpu.brand_string: Apple M2 Max",
  "hw.ncpu: 12",
  "hw.memsize: 103079215104"
)

test_that("the machine's model, chip, cores and memory are read from
  sysctl's report, in any order (R155)", {
  expected <- list(
    model = "Mac14,6", chip = "Apple M2 Max", cores = 12L, memoryGb = 96.0
  )
  expect_identical(parseMachine(sysctlText), expected)
  expect_identical(parseMachine(rev(sysctlText)), expected)
})

test_that("a sysctl report without one of its lines is an error naming it", {
  expect_error(parseMachine(sysctlText[-4L]), "hw.memsize", fixed = TRUE)
  expect_error(parseMachine(sysctlText[-2L]), "machdep.cpu.brand_string",
    fixed = TRUE
  )
})

## Chrome's program inside a made-up "Google Chrome.app" (names with spaces,
## as the real one's are), with an Info.plist giving `version`, or none when
## `version` is NULL.
fakeChrome <- function(version = "131.0.6778.86") {
  contents <- file.path(tempfile("chrome"), "Google Chrome.app", "Contents")
  dir.create(file.path(contents, "MacOS"), recursive = TRUE)
  program <- file.path(contents, "MacOS", "Google Chrome")
  file.create(program)
  if (!is.null(version)) {
    writeLines(c(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
      "<plist version=\"1.0\"><dict>",
      "<key>CFBundleShortVersionString</key>",
      paste0("<string>", version, "</string>"),
      "</dict></plist>"
    ), file.path(contents, "Info.plist"))
  }
  program
}

test_that("Chrome's version is read from its Info.plist, in folders whose
  names have spaces (R155)", {
  expect_identical(chromeVersion(fakeChrome()), "131.0.6778.86")
})

test_that("no Chrome, or a Chrome with no Info.plist, gives NA", {
  expect_identical(chromeVersion(NULL), NA_character_)
  expect_identical(chromeVersion(""), NA_character_)
  expect_identical(chromeVersion(fakeChrome(NULL)), NA_character_)
})

## A library folder holding one package's DESCRIPTION with `fields`.
fakeLibrary <- function(package, fields) {
  lib <- tempfile("lib")
  dir.create(file.path(lib, package), recursive = TRUE)
  writeLines(c(paste("Package:", package), fields),
    file.path(lib, package, "DESCRIPTION")
  )
  lib
}

test_that("package versions are read along the library path given, the
  first found, and a package on none of it is NA (R155)", {
  one <- fakeLibrary("fakePackage", "Version: 1.2.3")
  two <- fakeLibrary("fakePackage", "Version: 9.9.9")
  expect_identical(
    packageVersions(c("fakePackage", "noSuchPackage"), c(one, two)),
    c(fakePackage = "1.2.3", noSuchPackage = NA_character_)
  )
  expect_identical(
    packageVersions("fakePackage", c(two, one)),
    c(fakePackage = "9.9.9")
  )
})

## The installed pedkindraw's DESCRIPTION fields, as R CMD build writes them.
packagedLine <- "Packaged: 2026-11-23 17:39:10 UTC; someone"

test_that("the install's packaged time is read without the user name its
  field ends with (R155)", {
  lib <- fakeLibrary("pedkindraw", c("Version: 0.0.1", packagedLine))
  expect_identical(packagedTime(lib), "2026-11-23 17:39:10 UTC")
})

test_that("a library without pedkindraw, or a pedkindraw not installed from
  a built tarball, is an error naming PKD_LIB", {
  empty <- tempfile("lib")
  dir.create(empty)
  expect_error(packagedTime(empty), "PKD_LIB", fixed = TRUE)
  unpackaged <- fakeLibrary("pedkindraw", "Version: 0.0.1")
  expect_error(packagedTime(unpackaged), "PKD_LIB", fixed = TRUE)
  expect_error(packagedTime(unpackaged), "Packaged", fixed = TRUE)
})

## git in `repo`, its output.
git <- function(repo, ...) {
  system2("git", c("-C", shQuote(repo), ...), stdout = TRUE, stderr = TRUE)
}

## A git repository in a temporary folder holding R/a.R, DESCRIPTION,
## NAMESPACE and README.md, committed once at `date`; no git settings of the
## machine's are read.
gitRepository <- function(date = "2026-11-23T05:43:40+00:00") {
  repo <- tempfile("repo")
  dir.create(file.path(repo, "R"), recursive = TRUE)
  writeLines("a <- 1", file.path(repo, "R", "a.R"))
  writeLines("Package: x", file.path(repo, "DESCRIPTION"))
  writeLines("export(a)", file.path(repo, "NAMESPACE"))
  writeLines("x", file.path(repo, "README.md"))
  gitCommit(repo, date)
  repo
}
gitCommit <- function(repo, date) {
  withr::local_envvar(
    # nolint next: nonportable_path_linter, absolute_path_linter.
    GIT_CONFIG_GLOBAL = "/dev/null", GIT_CONFIG_NOSYSTEM = "1",
    GIT_AUTHOR_DATE = date, GIT_COMMITTER_DATE = date
  )
  if (!dir.exists(file.path(repo, ".git"))) git(repo, "init", "-q")
  git(repo, "add", ".")
  git(
    repo, "-c", "user.name=timing", "-c", "user.email=timing@example.invalid",
    "commit", "-q", "-m", "commit"
  )
}

test_that("a committed repository gives its commit, R/'s tree and the time
  of the last commit that changed R/, DESCRIPTION or NAMESPACE (R155)", {
  repo <- gitRepository()
  writeLines("y", file.path(repo, "README.md"))
  gitCommit(repo, "2026-11-23T20:00:00+00:00")
  f <- commitFacts(repo)
  expect_match(f$commit, "^[0-9a-f]{40}$")
  expect_identical(f$commit, git(repo, "rev-parse", "HEAD"))
  expect_identical(f$rTree, git(repo, "rev-parse", "HEAD:R"))
  expect_false(f$dirty)
  expect_identical(
    f$lastChange, as.POSIXct("2026-11-23 05:43:40", tz = "UTC")
  )
})

test_that("a changed or new file in R/, or a changed DESCRIPTION or
  NAMESPACE, is uncommitted; a change elsewhere is not (R155)", {
  repo <- gitRepository()
  writeLines("y", file.path(repo, "README.md"))
  expect_false(commitFacts(repo)$dirty)
  changes <- list(
    function(r) writeLines("a <- 2", file.path(r, "R", "a.R")),
    function(r) writeLines("b <- 1", file.path(r, "R", "b.R")),
    function(r) writeLines("Package: y", file.path(r, "DESCRIPTION")),
    function(r) writeLines("export(b)", file.path(r, "NAMESPACE"))
  )
  for (change in changes) {
    repo <- gitRepository()
    change(repo)
    expect_true(commitFacts(repo)$dirty)
  }
})

## commitFacts()'s answer for a repository.
facts <- function(dirty = FALSE, lastChange = "2026-11-23 05:43:40") {
  list(
    commit = strrep("a", 40L), rTree = strrep("b", 40L), dirty = dirty,
    lastChange = as.POSIXct(lastChange, tz = "UTC")
  )
}
packaged <- "2026-11-23 17:39:10 UTC"

test_that("the build check passes an install packaged at or after the last
  change (R155)", {
  expect_silent(checkBuild(facts(), packaged))
  expect_silent(checkBuild(facts(lastChange = "2026-11-23 17:39:10"), packaged))
})

test_that("the build check stops on uncommitted changes in R/, DESCRIPTION
  or NAMESPACE", {
  expect_error(checkBuild(facts(dirty = TRUE), packaged), "uncommitted",
    fixed = TRUE
  )
})

test_that("the build check stops on an install packaged before the last
  change, naming PKD_LIB", {
  late <- facts(lastChange = "2026-11-23 18:00:00")
  expect_error(checkBuild(late, packaged), "PKD_LIB", fixed = TRUE)
  expect_error(checkBuild(late, packaged), "packaged before", fixed = TRUE)
})

## recordRow()'s arguments, with the machine and Chrome typed. recordRow()
## and parseMachine() come from a file lintr cannot see.
recordOf <- function(record, repo = gitRepository()) {
  lib <- fakeLibrary("pedkindraw", c("Version: 0.0.1", packagedLine))
  # nolint start: object_usage_linter.
  recordRow(record, lib, repo,
    started = "2026-11-23 12:00:00", machine = parseMachine(sysctlText),
    chrome = fakeChrome()
  )
  # nolint end
}

test_that("a record row holds the 14 columns in order, with the values
  read (R155)", {
  repo <- gitRepository()
  row <- recordOf("computation", repo)
  expect_named(row, c(
    "record", "started", "commit", "rTree", "packaged", "R", "kinship2",
    "Pedixplorer", "chromote", "chrome", "model", "chip", "cores", "memoryGb"
  ))
  expect_identical(nrow(row), 1L)
  expect_identical(row$record, "computation")
  expect_identical(row$started, "2026-11-23 12:00:00")
  expect_identical(row$commit, git(repo, "rev-parse", "HEAD"))
  expect_identical(row$rTree, git(repo, "rev-parse", "HEAD:R"))
  expect_identical(row$packaged, "2026-11-23 17:39:10 UTC")
  expect_identical(row$R, paste(R.version$major, R.version$minor, sep = "."))
  for (p in c("kinship2", "Pedixplorer", "chromote")) {
    expect_identical(row[[p]], as.character(utils::packageVersion(p)))
  }
  expect_identical(row$chrome, "131.0.6778.86")
  expect_identical(row$model, "Mac14,6")
  expect_identical(row$chip, "Apple M2 Max")
  expect_identical(row$cores, 12L)
  expect_identical(row$memoryGb, 96.0)
})

test_that("a record is 'computation' or 'drawing', nothing else", {
  expect_identical(recordOf("drawing")$record, "drawing")
  expect_error(recordOf("timing"), "computation", fixed = TRUE)
})

test_that("a record row is refused when the build check fails", {
  repo <- gitRepository()
  writeLines("a <- 2", file.path(repo, "R", "a.R"))
  expect_error(recordOf("computation", repo), "uncommitted", fixed = TRUE)
})

test_that("record rows are appended to one file under one header (R155)", {
  file <- tempfile(fileext = ".csv")
  one <- data.frame(record = "computation", chip = "Apple M2 Max", cores = 12L)
  two <- data.frame(record = "drawing", chip = "Apple M2 Max", cores = 12L)
  appendRecordRow(one, file)
  appendRecordRow(two, file)
  expect_length(readLines(file), 3L)
  back <- utils::read.csv(file)
  expect_identical(back$record, c("computation", "drawing"))
  expect_identical(back$chip, rep("Apple M2 Max", 2L))
  expect_identical(back$cores, c(12L, 12L))
})

test_that("a record file with other columns is refused, naming the file", {
  file <- tempfile(fileext = ".csv")
  appendRecordRow(data.frame(record = "computation", cores = 12L), file)
  expect_error(
    appendRecordRow(data.frame(record = "drawing", chip = "x"), file),
    basename(file),
    fixed = TRUE
  )
  expect_length(readLines(file), 2L)
})
