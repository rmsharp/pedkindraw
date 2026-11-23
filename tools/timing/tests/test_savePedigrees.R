## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## savePedigrees.R rebuilds the timing runs' pedigree files byte for byte as
## nprcgenekeepr's November study wrote them (docs/planning/
## pedkindraw-timing-plan.md sections 3.2, 4.1 and 6, Phase 17h1): the seven
## seed-1 colonies and the 375-animal sample, each md5 the study's
## results/pedigreeFiles.csv (nprcgenekeepr commit 3e06730c5). Run from the
## project root:
##   Rscript -e 'testthat::test_file("tools/timing/tests/test_savePedigrees.R")'

library(testthat) # nolint: undesirable_function_linter.

## The study's md5s, from nprcgenekeepr's
## tools/pedigreeComparison/results/pedigreeFiles.csv at 3e06730c5.
studyMd5 <- c(
  rhesus375.csv = "d045f56bf35c6b7d3fe260a356ac1058",
  synthetic_300.csv = "60816f400baaa21ab244b35e98783a7f",
  synthetic_1000.csv = "cc654ad1ef6ad476c0a91567250bb779",
  synthetic_2000.csv = "d4886a70f7eed9e3b3d3e21efadbf5a6",
  synthetic_3000.csv = "8c00af86e82d4b22327ff0c8b0048b28",
  synthetic_10000.csv = "1799ecd0995eac3e2f0c403764d45a2a",
  synthetic_30000.csv = "36944e72a100747344d9b96e5033ae20",
  synthetic_100000.csv = "b1d45f936d17b99e20a681608a45d3e6"
)

## savePedigrees.R run from the project root in a fresh process, writing into
## a scratch folder; its output and exit status.
runSave <- function(data, results) {
  script <- file.path("tools", "timing", "savePedigrees.R")
  processx::run(file.path(R.home("bin"), "Rscript"),
    c(script, paste0("--data=", data), paste0("--results=", results)),
    wd = projectRoot, error_on_status = FALSE # nolint: object_usage_linter.
  )
}

test_that("savePedigrees.R writes the 7 colonies and the sample, each the
  study's file byte for byte, and says so", {
  data <- tempfile("data")
  results <- tempfile("results")
  r <- runSave(data, results)
  expect_identical(r$status, 0L, info = r$stderr)
  expect_match(r$stdout, "8 of 8 files identical to the study's")
  written <- tools::md5sum(file.path(data, names(studyMd5)))
  expect_identical(unname(written), unname(studyMd5))
})

test_that("savePedigrees.R records each file's rows and md5", {
  data <- tempfile("data")
  results <- tempfile("results")
  runSave(data, results)
  files <- utils::read.csv(file.path(results, "pedigreeFiles.csv"),
    stringsAsFactors = FALSE
  )
  expect_named(files, c("file", "rows", "md5", "source"))
  expect_setequal(files$file, names(studyMd5))
  expect_identical(files$md5, unname(studyMd5[files$file]))
  expect_identical(
    files$rows[files$file == "synthetic_100000.csv"], 100000L
  )
  expect_identical(files$rows[files$file == "rhesus375.csv"], 375L)
})
