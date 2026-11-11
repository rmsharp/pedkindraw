## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_getOffspring.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped;
## helper-fixtures.R supplies smallPed.
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
