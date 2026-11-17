## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_getOffspring.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped;
## helper-fixtures.R supplies smallPed. Ruling R88 (pedkindraw S36): the last
## test, pedkindraw's own, asks for the pedigree argument ped, not
## pedSourceDf.
library(testthat)
test_that("getOffspring returns the correct IDs", {
  expect_identical(
    getOffspring(smallPed, ids = c("A", "B")),
    c("C", "D", "H", "I", "M")
  )
  expect_identical(
    getOffspring(smallPed, ids = c("M")),
    "P"
  )
  expect_identical(
    getOffspring(smallPed, ids = c("Q")),
    "A"
  )
})

## Mark's ruling R88 (docs/planning/standalone-pedigree-package-plan.md
## section 2; was pedSourceDf): the pedigree argument is ped, in the same
## position, and a call that names it gives the same ids as one by position.
## Under the old name, R's partial matching of argument names already let
## ped = reach pedSourceDf, so there only the names check fails.
test_that("getOffspring()'s pedigree argument is ped", {
  expect_named(formals(getOffspring), c("ped", "ids"))
  expect_identical(
    getOffspring(ped = smallPed, ids = c("A", "B")),
    getOffspring(smallPed, c("A", "B"))
  )
})
