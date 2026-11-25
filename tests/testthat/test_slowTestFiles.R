## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_slowTestFiles.R at
## nprcgenekeepr commit 3e06730c5 (the file as at its 7eb919335), all of it
## but its header (lines 1-13, rewritten here) and its lines 80-90 (the test
## that a CRAN check runs nprcgenekeepr's read fix's tests, which pedkindraw
## does not have). The code is unchanged.
##
## CRAN plan Phase 17k (docs/planning/cran-submission-plan.md; plan R165):
## CRAN rejects a package whose whole check takes more than 10 minutes on its
## Windows check machine, and win-builder R-devel read 980 s for this tree,
## 788 s of it the tests (S92). slowTestFiles.txt names the test files a CRAN
## check leaves out, and tests/testthat.R leaves them out when CRAN runs the
## check: cranTestFilter() (helper-slowTestFiles.R) gives test_check() a
## filter for them unless NOT_CRAN is "true", as it is on CI and in local
## runs, so every test still runs there (nprcgenekeepr's owner ruling S1092:
## one list in one place, not a skip line in each file).

## Write `lines` as the slowTestFiles.txt in `dir`.
writeSlowList <- function(dir, lines) {
  writeLines(lines, file.path(dir, "slowTestFiles.txt"))
}

test_that("slowTestFiles() reads one file name a line, without comments or blank lines", {
  dir <- withr::local_tempdir()
  writeSlowList(dir, c("## Test files CRAN leaves out", "", "test_alpha.R",
                       "  test_beta.R  ", "test-gamma.R  # 3.1 s", "   "))
  expect_identical(slowTestFiles(dir),
                   c("test_alpha.R", "test_beta.R", "test-gamma.R"))
})

test_that("slowTestFiles() names no file when the list is missing or holds only comments", {
  dir <- withr::local_tempdir()
  expect_identical(slowTestFiles(dir), character(0))
  writeSlowList(dir, c("## nothing listed", ""))
  expect_identical(slowTestFiles(dir), character(0))
})

test_that("cranTestFilter() leaves every file in when NOT_CRAN is \"true\"", {
  dir <- withr::local_tempdir()
  writeSlowList(dir, "test_beta.R")
  expect_null(cranTestFilter(dir, notCran = "true"))
  expect_null(cranTestFilter(dir, notCran = "TRUE"))
  withr::local_envvar(NOT_CRAN = "true")
  expect_null(cranTestFilter(dir))
})

test_that("cranTestFilter() leaves every file in when the list names none", {
  dir <- withr::local_tempdir()
  expect_null(cranTestFilter(dir, notCran = ""))
  writeSlowList(dir, "## none listed")
  expect_null(cranTestFilter(dir, notCran = "false"))
})

test_that("cranTestFilter() leaves out exactly the listed files when NOT_CRAN is not \"true\"", {
  dir <- withr::local_tempdir()
  for (f in c("test_alpha.R", "test_beta.R", "test_betaMore.R",
              "test-gamma.R")) {
    writeLines("test_that('runs', expect_true(TRUE))", file.path(dir, f))
  }
  writeSlowList(dir, c("test_beta.R", "test-gamma.R"))
  runFiles <- function(filter) {
    res <- as.data.frame(testthat::test_dir(dir, filter = filter,
                                            invert = TRUE, reporter = "silent",
                                            stop_on_failure = FALSE))
    sort(unique(res$file))
  }
  expected <- c("test_alpha.R", "test_betaMore.R")
  expect_identical(runFiles(cranTestFilter(dir, notCran = "")), expected)
  expect_identical(runFiles(cranTestFilter(dir, notCran = "false")), expected)
  withr::local_envvar(NOT_CRAN = NA)
  expect_identical(runFiles(cranTestFilter(dir)), expected)
})

test_that("slowTestFiles.txt names test files in this folder, each once", {
  expect_true(file.exists(testthat::test_path("slowTestFiles.txt")))
  listed <- slowTestFiles(testthat::test_path())
  expect_gt(length(listed), 0L)
  expect_identical(listed[duplicated(listed)], character(0))
  testFiles <- list.files(testthat::test_path(), pattern = "^test.*\\.[Rr]$")
  expect_identical(setdiff(listed, testFiles), character(0))
})


test_that("tests/testthat.R hands cranTestFilter() to test_check() with invert = TRUE", {
  runner <- testthat::test_path("..", "testthat.R")
  skip_if_not(file.exists(runner), "tests/testthat.R is not beside this folder")
  exprs <- as.list(parse(runner))
  isCallTo <- function(e, name) is.call(e) && identical(e[[1L]], as.name(name))
  checkAt <- which(vapply(exprs, isCallTo, logical(1L), name = "test_check"))
  expect_length(checkAt, 1L)
  checkCall <- exprs[[checkAt[1L]]]
  expect_true(isCallTo(checkCall$filter, "cranTestFilter"))
  expect_identical(checkCall$invert, TRUE)
  sourced <- vapply(exprs[seq_len(checkAt[1L] - 1L)], function(e) {
    isCallTo(e, "source") && grepl("helper-slowTestFiles.R", deparse1(e),
                                   fixed = TRUE)
  }, logical(1L))
  expect_true(any(sourced))
})
