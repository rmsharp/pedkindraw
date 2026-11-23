## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_perfHarness.R at
## nprcgenekeepr commit 3e06730c5, lines 54-65 (fakeGc()) and 79-131 (the six
## tests of the memory readers and measure()), for tools/timing/measure.R
## (docs/planning/pedkindraw-timing-plan.md section 4.1, Phase 17h1).
## Changes: the functions come from measure.R, sourced into an environment of
## their own (loadMeasure()), not from tools/perf/harness.R in one whose
## parent is nprcgenekeepr's namespace, so skipUnlessSourceTree() goes; two
## new tests of withSeed(), which nprcgenekeepr's suite does not test.
## Run from the project root:
##   Rscript -e 'testthat::test_file("tools/timing/tests/test_measure.R")'

library(testthat) # nolint: undesirable_function_linter.

## measure.R's functions in an environment of their own; empty before the
## script is written (RED), so that each test fails on its own.
loadMeasure <- function() {
  perf <- new.env()
  script <- file.path("..", "measure.R")
  if (file.exists(script)) sys.source(script, envir = perf)
  perf
}

## nprcgenekeepr's tests are not linted there; the copied blocks keep its
## numbers and expectations as written.
# nolint start: implicit_integer_linter, conjunct_test_linter.
## A gc() result in the shape R 4.6 prints, with a "limit (Mb)" column before
## "max used", or in the older shape without it. The memory numbers are the
## same in both, so a reader that finds "max used" by position gets one wrong.
fakeGc <- function(withLimit) {
  cols <- list(used = c(1e6, 2e6), `(Mb)` = c(53.5, 15.3),
               `gc trigger` = c(2e6, 8e6), `(Mb)` = c(107, 61.1),
               `limit (Mb)` = c(NA, 16384), `max used` = c(1.5e6, 3e6),
               `(Mb)` = c(80.2, 22.9))
  if (!withLimit) cols <- cols[names(cols) != "limit (Mb)"]
  matrix(unlist(cols), nrow = 2L,
         dimnames = list(c("Ncells", "Vcells"), names(cols)))
}

test_that("the memory reader finds 'max used' by name in both gc() shapes", {
  perf <- loadMeasure()
  expect_equal(perf$maxUsedMb(fakeGc(withLimit = TRUE)), 103.1)
  expect_equal(perf$maxUsedMb(fakeGc(withLimit = FALSE)), 103.1)
  expect_equal(perf$usedMb(fakeGc(withLimit = TRUE)), 68.8)
  expect_equal(perf$usedMb(fakeGc(withLimit = FALSE)), 68.8)
})

test_that("the memory reader stops when gc() has no 'max used' column", {
  perf <- loadMeasure()
  noMax <- fakeGc(withLimit = FALSE)[, 1:4]
  expect_error(perf$maxUsedMb(noMax), "max used")
})

test_that("on a real gc() result the peak is at least the memory in use", {
  perf <- loadMeasure()
  g <- gc()
  expect_gte(perf$maxUsedMb(g), perf$usedMb(g))
})

test_that("measure() returns time, peak memory, result size and the value", {
  perf <- loadMeasure()
  m <- perf$measure(rev(seq_len(1e5)))
  expect_named(m, c("seconds", "peakMb", "resultMb", "value"))
  for (field in c("seconds", "peakMb", "resultMb")) {
    expect_true(is.numeric(m[[field]]) && length(m[[field]]) == 1L,
                info = field)
    expect_true(is.finite(m[[field]]) && m[[field]] >= 0, info = field)
  }
  ## 100,000 integers take about 0.38 MB, so a zero here means the result
  ## was never sized.
  expect_gt(m$resultMb, 0.3)
  expect_identical(m$value, rev(seq_len(1e5)))
})

test_that("measure() runs its expression once, inside the timed window", {
  perf <- loadMeasure()
  calls <- 0L
  m <- perf$measure({
    calls <- calls + 1L
    Sys.sleep(0.05)
    calls
  })
  expect_identical(calls, 1L)
  expect_identical(m$value, 1L)
  expect_gte(m$seconds, 0.04)
})

test_that("measure() lets an error in its expression through", {
  perf <- loadMeasure()
  expect_error(perf$measure(stop("harness probe failure")),
               "harness probe failure")
})

# nolint end

test_that("withSeed() runs the code after set.seed(seed) and gives the
  caller's random state back", {
  perf <- loadMeasure()
  set.seed(5L)
  expected <- stats::runif(2L)
  set.seed(99L)
  before <- get(".Random.seed", envir = globalenv())
  got <- perf$withSeed(5L, stats::runif(2L))
  expect_identical(got, expected)
  expect_identical(get(".Random.seed", envir = globalenv()), before)
})

test_that("withSeed() leaves a caller with no random state with none", {
  perf <- loadMeasure()
  saved <- if (exists(".Random.seed", envir = globalenv())) {
    get(".Random.seed", envir = globalenv())
  }
  on.exit(if (!is.null(saved)) {
    # nolint next: object_name_linter.
    assign(".Random.seed", saved, envir = globalenv())
  })
  if (exists(".Random.seed", envir = globalenv())) {
    rm(".Random.seed", envir = globalenv())
  }
  perf$withSeed(5L, stats::runif(1L))
  expect_false(exists(".Random.seed", envir = globalenv()))
})
