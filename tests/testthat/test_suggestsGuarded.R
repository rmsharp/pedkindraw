## Copyright(c) 2026 R. Mark Sharp
## This file is part of pedkindraw
##
## CRAN plan Phase 17l (docs/planning/cran-submission-plan.md; S95, Mark's pick
## "Guards plus a guard test"): every test that calls a suggested package a
## check without suggested packages hides (`pkg::f`) has a
## skip_if_not_installed() for it first, in its block or earlier in its file,
## or calls a helper that has one (helper-suggestsGuarded.R). Measured S95
## under a scratch R home holding only R's 29 standard packages: CRAN mode
## passed, since testthat skips a missing package on CRAN only; the full suite
## (NOT_CRAN "true") failed 4 blocks calling mockery. The check reads only a
## block's own `pkg::` calls, not those inside the helpers it calls, and is on
## slowTestFiles.txt: it reads the tests, so CRAN need not run it.

## Writes `lines` to a test file in a temporary folder and returns its path.
.guardCase <- function(lines, envir = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = envir)
  file <- file.path(dir, "test_case.R")
  writeLines(lines, file)
  file
}

test_that("hiddenSuggests() leaves out testthat, the vignette builder and their dependencies", {
  hidden <- hiddenSuggests()
  suggests <- trimws(sub("\\(.*$", "", strsplit(read.dcf(
    system.file("DESCRIPTION", package = "pedkindraw"), "Suggests"
  ), ",")[[1L]]))
  expect_true(all(hidden %in% suggests))
  expect_false(any(c("testthat", "knitr", "withr", "callr") %in% hidden))
  expect_true(all(c("mockery", "kinship2", "Pedixplorer") %in% hidden))
})

test_that("a block calling a hidden package with no guard is found, at its first call", {
  file <- .guardCase(c(
    "test_that('a', {",
    "  x <- 1",
    "  m <- mockery::mock(1)",
    "  mockery::stub(f, 'g', m)",
    "})"
  ))
  expect_identical(
    unguardedSuggests(file, "mockery"),
    data.frame(file = "test_case.R", line = 3L, package = "mockery")
  )
})

test_that("skip_if_not_installed() before the call guards the block; after it does not", {
  guardedFirst <- .guardCase(c(
    "test_that('a', {",
    "  skip_if_not_installed('mockery')",
    "  m <- mockery::mock(1)",
    "})"
  ))
  expect_identical(nrow(unguardedSuggests(guardedFirst, "mockery")), 0L)
  guardedLate <- .guardCase(c(
    "test_that('a', {",
    "  m <- mockery::mock(1)",
    "  skip_if_not_installed(\"mockery\")",
    "})"
  ))
  expect_identical(unguardedSuggests(guardedLate, "mockery")$line, 2L)
})

test_that("a guard for one package does not guard another, and an unhidden package needs none", {
  file <- .guardCase(c(
    "test_that('a', {",
    "  skip_if_not_installed('kinship2')",
    "  p <- kinship2::pedigree(1, 0, 0, 1)",
    "  m <- mockery::mock(1)",
    "  d <- withr::local_tempdir()",
    "})"
  ))
  expect_identical(
    unguardedSuggests(file, c("kinship2", "mockery")),
    data.frame(file = "test_case.R", line = 4L, package = "mockery")
  )
})

test_that("a call inside if (requireNamespace(pkg)) is guarded", {
  file <- .guardCase(c(
    "test_that('a', {",
    "  if (requireNamespace(\"kinship2\", quietly = TRUE)) {",
    "    p <- kinship2::pedigree(1, 0, 0, 1)",
    "  }",
    "  if (requireNamespace('Pedixplorer', quietly = TRUE)) x <- 1",
    "  m <- mockery::mock(1)",
    "})"
  ))
  expect_identical(
    unguardedSuggests(file, c("kinship2", "mockery")),
    data.frame(file = "test_case.R", line = 6L, package = "mockery")
  )
})

test_that("a package named in a string is not a call", {
  file <- .guardCase(c(
    "test_that('a', {",
    "  skip_if_not_installed('mockery')",
    "  mockery::stub(f, 'chromote::find_chrome', NULL)",
    "})"
  ))
  expect_identical(nrow(unguardedSuggests(file, c("mockery", "chromote"))), 0L)
})

test_that("a top-level guard covers the blocks after it, not those before", {
  file <- .guardCase(c(
    "test_that('before', expect_true(is.function(mockery::mock)))",
    "skip_if_not_installed('mockery')",
    "test_that('after', expect_true(is.function(mockery::mock)))"
  ))
  expect_identical(unguardedSuggests(file, "mockery")$line, 1L)
})

test_that("a function definition is not read; a guard function called first guards", {
  file <- .guardCase(c(
    ".needMock <- function() {",
    "  skip_if_not_installed('mockery')",
    "  mockery::mock(1)",
    "}",
    ".chained <- function() .needMock()",
    "test_that('a', {",
    "  .chained()",
    "  m <- mockery::mock(1)",
    "})",
    "test_that('b', {",
    "  m <- mockery::mock(1)",
    "})"
  ))
  guards <- guardFunctions(file)
  expect_identical(guards, list(.needMock = "mockery", .chained = "mockery"))
  expect_identical(unguardedSuggests(file, "mockery", guards)$line, 11L)
})

test_that("each test file guards every hidden suggested package it calls", {
  dir <- testthat::test_path()
  guards <- guardFunctions(list.files(dir, "^helper.*[.]R$", full.names = TRUE))
  hidden <- hiddenSuggests()
  found <- do.call(rbind, lapply(
    list.files(dir, "^test.*[.]R$", full.names = TRUE),
    unguardedSuggests, hidden = hidden, guards = guards
  ))
  expect_identical(
    nrow(found), 0L,
    info = paste(found$file, found$line, found$package, sep = ":",
                 collapse = ", ")
  )
})
