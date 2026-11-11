## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_getParents.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped;
## helper-fixtures.R supplies smallPed.
library(testthat)
ped <- smallPed
parents <- getParents(ped, "D")
test_that("getParents correctly returns correct IDs", {
  parents <- getParents(ped, "D")
  expect_true(all(parents %in% c("A", "B")))
  expect_true(all(c("A", "B") %in% parents))
  parents <- getParents(ped, c("D", "A"))
  expect_true(all(parents %in% c("A", "B", "Q")))
  expect_true(all(c("A", "B", "Q") %in% parents))
})
