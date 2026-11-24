## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/tests/test_drawingTiming.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.1, Phase 17h3; R157). Changes: PKD_LIB for CMP_LIB and
## NPG_LIB (pkdLibReady() for libsReady()); measure.R and
## generateColonyPedigree.R sourced too; section 5.1's 11 cases for the
## study's 8 (their ids, packages, kinds and loads, and the new kind "data");
## the cases drawn on the 300-animal colony and the sample, on the canvas
## (timingPedigree(), helper-caseValues.R), not on smallPed, with
## Pedixplorer's two aligned cases recorded as refusing the colony (R157);
## drawOne.R run on the colony, and the browser timer on pages drawn from a
## typed 7-animal pedigree (tools/timing/data has no smallPed), pedkindraw's
## page for nprcgenekeepr's and Pedixplorer's plotly page for ggpedigree's;
## the 2,000-animal colony's test dropped (test_savePedigrees.R checks every
## colony's md5, Phase 17h1). New tests: each run's row (drawingRunRow(),
## R155 and R156) and pedigreeSize(); the saved files on
## savePedigreeDiagram()'s own page, and the time limit each save case sets
## (R157; the plan's section 8, dragon 7); drawOne.R's pkdLib, a save case
## in the child, and its stop when PKD_LIB holds no pedkindraw.
## Tests for the drawing timing. Each drawing case (drawingTimingCases.R)
## goes from a comparison pedigree to a picture file (PNG, SVG or PDF), a web
## page (HTML) or pedkindraw's diagram data; drawOne.R times one case in a
## fresh process; for a web page, timeBrowserDraw() (drawingTiming.R) times
## the browser from navigation to the first painted frame after the widget's
## own draw event, and reads the JavaScript heap. These test the harness, not
## the packages: the figures come from runDrawingTiming.R. Run from the
## project root:
##   PKD_LIB=<scratch>/pkdlib Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_drawingTiming.R")'
## Tests that draw with pedkindraw need PKD_LIB, and the browser tests
## Chrome; they skip without them.

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("comparisonFormats.R")
sourceComparisonScript("generateColonyPedigree.R")
sourceComparisonScript("timingHarness.R")
sourceComparisonScript("measure.R")
sourceComparisonScript("drawingCapture.R")
sourceComparisonScript("drawingTimingCases.R")
sourceComparisonScript("drawingTiming.R")

## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.

## ---- one run: the R part and the browser part against the limit -----------

rRun <- function(seconds = 10.0, status = "ok", message = "") {
  list(
    status = status, message = message,
    seconds = if (identical(status, "ok")) seconds else NA_real_,
    heapPeakMb = 50.0, preRssMb = 300.0, maxRssBytes = 6.0e8,
    realSeconds = seconds + 2.0, loaded = "kinship2"
  )
}
browserRun <- function(seconds = 3.0, status = "ok", message = "") {
  list(
    status = status, message = message,
    seconds = if (identical(status, "ok")) seconds else NA_real_,
    jsHeapMb = if (identical(status, "ok")) 12.5 else NA_real_
  )
}

test_that("a static drawing's total is its R seconds", {
  d <- combineDrawRun(rRun(10.0), NULL, timeLimit = 120.0)
  expect_identical(d$status, "ok")
  expect_identical(d$rSeconds, 10.0)
  expect_identical(d$browserSeconds, NA_real_)
  expect_identical(d$totalSeconds, 10.0)
  expect_identical(d$jsHeapMb, NA_real_)
  expect_identical(d$maxRssBytes, 6.0e8)
})

test_that("a browser drawing's total is its R seconds plus the browser's", {
  d <- combineDrawRun(rRun(10.0), browserRun(3.0), timeLimit = 120.0)
  expect_identical(d$status, "ok")
  expect_identical(d$rSeconds, 10.0)
  expect_identical(d$browserSeconds, 3.0)
  expect_identical(d$totalSeconds, 13.0)
  expect_identical(d$jsHeapMb, 12.5)
})

test_that("a total over the limit is 'time', naming both parts' seconds", {
  d <- combineDrawRun(rRun(100.0), browserRun(30.0), timeLimit = 120.0)
  expect_identical(d$status, "time")
  expect_match(d$message, "100", fixed = TRUE)
  expect_match(d$message, "30", fixed = TRUE)
  expect_match(d$message, "120", fixed = TRUE)
  expect_identical(d$totalSeconds, 130.0)
})

test_that("a failed R run gives its status and message and no seconds", {
  failed <- rRun(status = "error", message = "subscript out of bounds")
  d <- combineDrawRun(failed, NULL, timeLimit = 120.0)
  expect_identical(d$status, "error")
  expect_identical(d$message, "subscript out of bounds")
  expect_identical(d$rSeconds, NA_real_)
  expect_identical(d$totalSeconds, NA_real_)
})

test_that("a failed browser run gives its status, keeping the R seconds", {
  d <- combineDrawRun(rRun(10.0),
    browserRun(status = "time", message = "no drawing within 110 s"),
    timeLimit = 120.0
  )
  expect_identical(d$status, "time")
  expect_match(d$message, "^browser: no drawing within 110 s$")
  expect_identical(d$rSeconds, 10.0)
  expect_identical(d$browserSeconds, NA_real_)
  expect_identical(d$totalSeconds, NA_real_)
})

## ---- one cell: the median of the measured runs -----------------------------

test_that("three good runs give the median of each figure", {
  runs <- list(
    combineDrawRun(rRun(10.0), browserRun(3.0), 120.0),
    combineDrawRun(rRun(12.0), browserRun(1.0), 120.0),
    combineDrawRun(rRun(11.0), browserRun(2.0), 120.0)
  )
  s <- summarizeDrawingRuns(runs)
  expect_identical(s$status, "ok")
  expect_identical(s$rSeconds, 11.0)
  expect_identical(s$browserSeconds, 2.0)
  expect_identical(s$totalSeconds, 13.0)
  expect_identical(s$jsHeapMb, 12.5)
  expect_identical(s$runs, 3L)
})

test_that("static runs give no browser figure and the median total", {
  runs <- lapply(c(4.0, 6.0, 5.0), function(x) {
    combineDrawRun(rRun(x), NULL, 120.0)
  })
  s <- summarizeDrawingRuns(runs)
  expect_identical(s$status, "ok")
  expect_identical(s$browserSeconds, NA_real_)
  expect_identical(s$totalSeconds, 5.0)
})

test_that("a failed run makes the cell fail with that run's status", {
  runs <- list(
    combineDrawRun(rRun(10.0), browserRun(3.0), 120.0),
    combineDrawRun(rRun(100.0), browserRun(30.0), 120.0),
    combineDrawRun(rRun(11.0), browserRun(2.0), 120.0)
  )
  s <- summarizeDrawingRuns(runs)
  expect_identical(s$status, "time")
  expect_match(s$message, "120", fixed = TRUE)
  expect_identical(s$totalSeconds, NA_real_)
  expect_identical(s$runs, 3L)
})

## ---- each run's row (R155, R156) -------------------------------------------

## A run's R part as runLimited() gives it, with the folder pedkindraw came
## from and the clock time it was launched.
launchedRun <- function(launched) {
  r <- rRun(10.0)
  r$pkdLib <- file.path(tempdir(), "pkdlib")
  r$launched <- launched
  r
}

test_that("a drawing run's row puts the free memory after the load, and the
  folder pedkindraw came from after the packages", {
  k <- list(id = "pkd_page", package = "pedkindraw", kind = "browser")
  r <- launchedRun(as.POSIXct("2026-11-23 12:00:00"))
  d <- combineDrawRun(r, browserRun(3.0), 120.0)
  row <- drawingRunRow(k, "synthetic_300", "measured",
    list(idle = 62.5, load = 7.9), 45.0, r, d
  )
  expect_named(row, c(
    "case", "package", "form", "pedigree", "size", "kind", "idle", "load",
    "memFree", "status", "message", "rSeconds", "browserSeconds",
    "totalSeconds", "heapPeakMb", "preRssMb", "maxRssMb", "jsHeapMb",
    "realSeconds", "loaded", "pkdLib", "started"
  ))
  expect_identical(nrow(row), 1L)
  expect_identical(row$form, "browser")
  expect_identical(row$size, 300L)
  expect_identical(row$idle, 62.5)
  expect_identical(row$memFree, 45.0)
  expect_identical(row$totalSeconds, 13.0)
  expect_identical(row$maxRssMb, 6.0e8 / 1048576.0)
  expect_identical(row$jsHeapMb, 12.5)
  expect_identical(row$realSeconds, 12.0)
  expect_identical(row$loaded, "kinship2")
  expect_identical(row$pkdLib, r$pkdLib)
  expect_identical(row$started, "2026-11-23 12:00:00")
})

test_that("a drawing run's row takes its start from the R part's launch,
  not from when the row is made (R156)", {
  launched <- Sys.time() - 3600.0
  r <- launchedRun(launched)
  k <- list(id = "k2_picture", package = "kinship2", kind = "static")
  row <- drawingRunRow(k, "rhesus375", "warm-up",
    list(idle = 70.0, load = 5.0), 50.0, r, combineDrawRun(r, NULL, 120.0)
  )
  expect_identical(row$started, timeStamp(launched))
  expect_identical(row$size, 375L)
  expect_identical(row$browserSeconds, NA_real_)
})

test_that("a pedigree's size is the sample's 375 or the colony's number", {
  expect_identical(pedigreeSize("rhesus375"), 375L)
  expect_identical(pedigreeSize("synthetic_300"), 300L)
  expect_identical(pedigreeSize("synthetic_3000"), 3000L)
})

## ---- the drawing cases (the plan's section 5.1, R157) ----------------------

caseIds <- c(
  "pkd_page", "pkd_page_direct", "pkd_svg", "pkd_pdf", "pkd_png", "pkd_data",
  "k2_picture", "pdx_picture", "pdx_picture_unaligned", "pdx_plotly",
  "pdx_plotly_unaligned"
)
byId <- function(id) Find(function(k) identical(k$id, id), drawingCases())

test_that("there are eleven cases, each with its fields", {
  cases <- drawingCases()
  ids <- vapply(cases, `[[`, "", "id")
  expect_identical(ids, caseIds)
  for (k in cases) {
    expect_named(k, c("id", "package", "kind", "loads", "prepare", "call"))
    expect_true(k$package %in% c("pedkindraw", "kinship2", "Pedixplorer"),
      info = k$id
    )
    expect_type(k$loads, "character")
    expect_type(k$prepare, "closure")
    expect_type(k$call, "closure")
  }
  expect_identical(
    vapply(cases, `[[`, "", "package"),
    c(rep("pedkindraw", 6L), "kinship2", rep("Pedixplorer", 4L))
  )
  expect_identical(
    vapply(cases, `[[`, "", "kind"),
    c(
      "browser", "browser", "static", "static", "static", "data", "static",
      "static", "static", "browser", "browser"
    )
  )
})

test_that("every package a case's code names is loaded before the clock", {
  for (k in drawingCases()) {
    used <- union(packagesNamed(k$prepare), packagesNamed(k$call))
    allowed <- c(k$package, k$loads, "grDevices", "graphics")
    expect_true(all(used %in% allowed),
      info = paste(k$id, "names", toString(setdiff(used, allowed)))
    )
    if (identical(k$kind, "browser")) {
      expect_true("htmlwidgets" %in% k$loads, info = k$id)
    }
    if (startsWith(k$id, "pdx_plotly")) {
      expect_true("plotly" %in% k$loads, info = k$id)
    }
  }
  for (id in c("pkd_page", "pkd_page_direct")) {
    expect_true("visNetwork" %in% byId(id)$loads, info = id)
  }
  ## savePedigreeDiagram() starts Chrome through chromote; withr sets the
  ## case's time limit.
  for (id in c("pkd_svg", "pkd_pdf", "pkd_png")) {
    expect_true(all(c("visNetwork", "chromote", "withr") %in% byId(id)$loads),
      info = id
    )
  }
})

drawReady <- function() pkdLibReady() && chromeReady()

## Case k's file, page or data from pedigree `p`, in folder `dir`.
drawCase <- function(k, p, dir, width = 3600L, height = 1500L) {
  k$call(k$prepare(p, width, height), file.path(dir, k$id), width, height)
}

## What case k drew in `dir`: its file, named for the case and its kind and
## starting as that kind of file does, or for pkd_data the diagram's nodes
## and edges.
expectDrawn <- function(k, value, dir) {
  if (identical(k$kind, "data")) {
    expect_s3_class(value$nodes, "data.frame")
    expect_s3_class(value$edges, "data.frame")
    expect_gt(nrow(value$nodes), 0L)
    expect_gt(nrow(value$edges), 0L)
    return(invisible(value))
  }
  ending <- switch(k$id,
    pkd_svg = ".svg",
    pkd_pdf = ".pdf",
    if (identical(k$kind, "browser")) ".html" else ".png"
  )
  expect_identical(value, file.path(dir, paste0(k$id, ending)), info = k$id)
  isPage <- function(file) {
    page <- paste(readLines(file, warn = FALSE), collapse = "\n")
    grepl("__drawTiming", page, fixed = TRUE)
  }
  check <- switch(ending,
    .svg = isSvg,
    .pdf = isPdf,
    .png = isPng,
    .html = isPage
  )
  expect_true(check(value), info = k$id)
  invisible(value)
}

## Draws each of `cases` from the timing pedigree `name` on the canvas; the
## pedkindraw drawn must be PKD_LIB's.
drawEach <- function(cases, name) {
  old <- useTimingLibraries()
  on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
  p <- timingPedigree(name)
  dir <- tempfile(name)
  dir.create(dir)
  for (k in cases) expectDrawn(k, drawCase(k, p, dir), dir)
  checkPedkindrawFolder(
    dirname(getNamespaceInfo("pedkindraw", "path")), Sys.getenv("PKD_LIB")
  )
}

test_that("every case draws the sample on the canvas", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  drawEach(drawingCases(), "sample")
})

## Pedixplorer's parent alignment refuses the colonies (R157, as in the
## study): its two aligned cases are recorded as refusing below.
aligned <- c("pdx_picture", "pdx_plotly")

test_that("every case but Pedixplorer's two aligned ones draws the
  300-animal colony on the canvas", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  drawEach(Filter(function(k) !k$id %in% aligned, drawingCases()), "colony")
})

test_that("Pedixplorer draws the 300-animal colony only with its alignment
  off (R157)", {
  p <- timingPedigree("colony")
  dir <- tempfile("unaligned")
  dir.create(dir)
  for (id in aligned) {
    expect_error(drawCase(byId(id), p, dir), "subscript out of bounds",
      info = id
    )
  }
  expect_true(isPng(drawCase(byId("pdx_picture_unaligned"), p, dir)))
})

test_that("the saved files are drawn on savePedigreeDiagram()'s own page,
  10 inches wide (R157)", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  old <- useTimingLibraries()
  on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
  p <- timingPedigree("sample")
  dir <- tempfile("page")
  dir.create(dir)
  ## A PNG's width is its header's fifth 4-byte number: 10 inches at 300 dpi.
  png <- drawCase(byId("pkd_png"), p, dir)
  header <- readBin(png, "integer", n = 5L, size = 4L, endian = "big")
  expect_identical(header[[5L]], 3000L)
  svg <- drawCase(byId("pkd_svg"), p, dir)
  expect_match(readChar(svg, 200L), "width=\"10in\"", fixed = TRUE)
})

test_that("a save case sets its own time limit, above the harness's 120 s,
  and puts the caller's back (dragon 7)", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  old <- useTimingLibraries()
  on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
  withr::local_options(pedkindraw.saveTimeout = 0.001)
  k <- byId("pkd_svg")
  x <- k$prepare(timingPedigree("sample"), 3600L, 1500L)
  dir <- tempfile("limit")
  dir.create(dir)
  ## The caller's limit stops the function itself...
  expect_error(
    pedkindraw::savePedigreeDiagram(x, file.path(dir, "own.svg")),
    "did not finish drawing within 0.001 seconds", fixed = TRUE
  )
  ## ...but not the case.
  expect_true(isSvg(k$call(x, file.path(dir, k$id), 3600L, 1500L)))
  expect_identical(getOption("pedkindraw.saveTimeout"), 0.001)
})

## ---- drawOne.R: one case in a fresh process ---------------------------------

## The 300-animal colony where drawOne.R reads it (savePedigrees.R writes
## it; a clone has none until then).
colonyFile <- function() {
  file <- file.path("..", "data", "synthetic_300.csv")
  if (!file.exists(file)) {
    dir.create(dirname(file), showWarnings = FALSE)
    writeComparisonPedigree(generateColonyPedigree(300L, 1L), file)
  }
  invisible(file)
}

drawOne <- function(case, ped, dir) {
  runLimited(normalizePath(file.path("..", "drawOne.R")),
    c(case, ped, dir, "1200", "800"),
    timeLimit = 60.0, memLimit = 8e9, wd = projectRoot
  )
}

test_that("drawOne.R draws pedkindraw's page and reports its figures and
  the folder pedkindraw came from", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  dir <- tempfile("one")
  dir.create(dir)
  r <- drawOne("pkd_page", "synthetic_300", dir)
  expect_identical(r$status, "ok", info = r$message)
  expect_gte(r$seconds, 0.0)
  expect_gte(r$heapPeakMb, 0.0)
  expect_gt(r$preRssMb, 0.0)
  expect_true("pedkindraw" %in% r$loaded)
  expect_identical(r$pkdLib, normalizePath(Sys.getenv("PKD_LIB"), "/"))
  expect_true(file.exists(file.path(dir, "pkd_page_synthetic_300.html")))
})

test_that("drawOne.R writes a saved file, Chrome started inside the child", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  colonyFile()
  dir <- tempfile("one")
  dir.create(dir)
  r <- drawOne("pkd_svg", "synthetic_300", dir)
  expect_identical(r$status, "ok", info = r$message)
  expect_true(isSvg(file.path(dir, "pkd_svg_synthetic_300.svg")))
})

test_that("a kinship2 drawing loads none of the other two packages", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  dir <- tempfile("one")
  dir.create(dir)
  r <- drawOne("k2_picture", "synthetic_300", dir)
  expect_identical(r$status, "ok", info = r$message)
  expect_identical(r$loaded, "kinship2")
  expect_true(isPng(file.path(dir, "k2_picture_synthetic_300.png")))
})

test_that("an unknown case is an error naming it", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  r <- drawOne("no_such_case", "synthetic_300", tempdir())
  expect_identical(r$status, "error")
  expect_match(r$message, "no drawing case 'no_such_case'", fixed = TRUE)
})

test_that("a pedkindraw drawing whose PKD_LIB holds no pedkindraw fails,
  naming PKD_LIB", {
  skip_if_not(pkdLibReady(), "PKD_LIB not set")
  colonyFile()
  empty <- tempfile("emptylib")
  dir.create(empty)
  withr::local_envvar(PKD_LIB = empty)
  r <- drawOne("pkd_page", "synthetic_300", tempdir())
  expect_identical(r$status, "error")
  expect_match(r$message, "PKD_LIB")
})

## ---- the browser timer ---------------------------------------------------

## Seven animals: C and D are full siblings, and so are F and G, D's
## offspring.
smallPedigree <- function() {
  data.frame(
    id = c("A", "B", "C", "D", "E", "F", "G"),
    sire = c(NA, NA, "A", "A", NA, "D", "D"),
    dam = c(NA, NA, "B", "B", NA, "E", "E"),
    sex = c("M", "F", "F", "M", "F", "M", "F"),
    stringsAsFactors = FALSE
  )
}
## A page of one case drawn from smallPedigree(), in a fresh folder.
smallPage <- function(id) {
  old <- useTimingLibraries()
  on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
  dir <- tempfile("page")
  dir.create(dir)
  drawCase(byId(id), smallPedigree(), dir, 1200L, 800L)
}

test_that("pedkindraw's page is timed to its first drawn frame", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  b <- timeBrowserDraw(smallPage("pkd_page"), 1200L, 800L, timeLimit = 60.0)
  expect_identical(b$status, "ok", info = b$message)
  expect_gt(b$seconds, 0.0)
  expect_lt(b$seconds, 30.0)
  expect_gt(b$jsHeapMb, 0.0)
})

test_that("Pedixplorer's plotly page is timed to its first drawn frame", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  b <- timeBrowserDraw(smallPage("pdx_plotly"), 1200L, 800L,
    timeLimit = 60.0
  )
  expect_identical(b$status, "ok", info = b$message)
  expect_gt(b$seconds, 0.0)
  expect_lt(b$seconds, 30.0)
  expect_gt(b$jsHeapMb, 0.0)
})

test_that("a page that never draws is 'time' once the limit passes", {
  skip_if_not(chromeReady(), "no Chrome")
  page <- tempfile(fileext = ".html")
  writeLines("<html><body><p>no drawing here</p></body></html>", page)
  started <- proc.time()[["elapsed"]]
  b <- timeBrowserDraw(page, 800L, 600L, timeLimit = 2.0)
  expect_identical(b$status, "time")
  expect_match(b$message, "2 s", fixed = TRUE)
  expect_identical(b$seconds, NA_real_)
  expect_lt(proc.time()[["elapsed"]] - started, 15.0)
})

test_that("a missing page is an error naming it", {
  page <- file.path(tempdir(), "no_such_page.html")
  b <- timeBrowserDraw(page, 800L, 600L, timeLimit = 5.0)
  expect_identical(b$status, "error")
  expect_match(b$message, "no_such_page.html", fixed = TRUE)
  expect_identical(b$seconds, NA_real_)
})

test_that("the timer can photograph the drawn page", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  shot <- tempfile(fileext = ".png")
  b <- timeBrowserDraw(smallPage("pkd_page"), 1200L, 800L,
    timeLimit = 60.0, screenshot = shot
  )
  expect_identical(b$status, "ok", info = b$message)
  expect_true(isPng(shot))
})

test_that("a zoomed picture of pedkindraw's page differs from fitted", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  page <- smallPage("pkd_page")
  fitted <- tempfile(fileext = ".png")
  zoomed <- tempfile(fileext = ".png")
  timeBrowserDraw(page, 1200L, 800L, timeLimit = 60.0, screenshot = fitted)
  zoomedVisScreenshot(page, zoomed, 1200L, 800L, scale = 2.0)
  expect_true(isPng(zoomed))
  expect_false(identical(
    tools::md5sum(fitted)[[1L]], tools::md5sum(zoomed)[[1L]]
  ))
})

test_that("a zoomed picture of a page with no vis network is an error", {
  skip_if_not(drawReady(), "PKD_LIB or Chrome missing")
  expect_error(
    zoomedVisScreenshot(smallPage("pdx_plotly"), tempfile(fileext = ".png"),
      1200L, 800L
    ),
    "visNetwork"
  )
})
# nolint end
