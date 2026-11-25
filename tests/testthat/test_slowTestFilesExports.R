## Copyright(c) 2026 R. Mark Sharp
## This file is part of pedkindraw
##
## CRAN plan Phase 17k (docs/planning/cran-submission-plan.md; plan R165):
## slowTestFiles.txt leaves most test files out of a CRAN check, chosen so
## that a test the check still runs calls every export (S92: a run-time trace
## of every export over the CRAN-mode tests, slowest file first, a file left
## out only while every export is still called by a file kept). This file
## checks the list by reading the test files' code: each export is called by
## name in a file the list does not name, outside any test_that() block that
## calls skip_on_cran() and before any top-level skip_on_cran().

## The names a test file calls in the code a CRAN check runs: each function
## call the parser finds (`f()` or `pkg::f()`), leaving out each test_that()
## block that calls skip_on_cran() and everything after a top-level
## skip_on_cran().
cranCalls <- function(file) {
  exprs <- parse(file, keep.source = TRUE)
  runs <- rep(TRUE, length(exprs))
  for (i in seq_along(exprs)) {
    e <- exprs[[i]]
    if (is.call(e) && identical(e[[1L]], as.name("skip_on_cran"))) {
      runs[i:length(exprs)] <- FALSE
      break
    }
    isBlock <- is.call(e) && identical(e[[1L]], as.name("test_that"))
    if (isBlock && "skip_on_cran" %in% all.names(e)) {
      runs[i] <- FALSE
    }
  }
  lines <- unlist(lapply(attr(exprs, "srcref")[runs],
                         function(ref) seq(ref[1L], ref[3L])))
  tokens <- utils::getParseData(exprs)
  calls <- tokens[tokens$token == "SYMBOL_FUNCTION_CALL", ]
  unique(calls$text[calls$line1 %in% lines])
}

test_that("cranCalls() reads the calls of each block a CRAN check runs", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "test_a.R")
  writeLines(c(
    "x <- alpha(1)",
    "test_that('runs', expect_equal(pedkindraw::beta(x), gamma()))",
    "test_that('skips', { skip_on_cran(); delta() })",
    "test_that('nested', { y <- list(f = epsilon(2)); m <- diag(2)[, 1] })"
  ), file)
  called <- cranCalls(file)
  expect_true(all(c("alpha", "beta", "gamma", "epsilon") %in% called))
  expect_false("delta" %in% called)
})

test_that("cranCalls() reads nothing after a top-level skip_on_cran()", {
  dir <- withr::local_tempdir()
  file <- file.path(dir, "test_b.R")
  writeLines(c(
    "test_that('before', expect_true(alpha()))",
    "skip_on_cran()",
    "test_that('after', expect_true(beta()))"
  ), file)
  called <- cranCalls(file)
  expect_true("alpha" %in% called)
  expect_false("beta" %in% called)
})

test_that("a test a CRAN check runs calls each export (R165)", {
  dir <- testthat::test_path()
  listed <- slowTestFiles(dir)
  expect_gt(length(listed), 0L)
  run <- setdiff(list.files(dir, pattern = "^test.*\\.[Rr]$"), listed)
  called <- unique(unlist(lapply(file.path(dir, run), cranCalls)))
  exports <- sort(getNamespaceExports("pedkindraw"))
  expect_identical(setdiff(exports, called), character(0))
})
