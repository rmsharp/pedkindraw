## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_getParents.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped;
## helper-fixtures.R supplies smallPed. Ruling R88 (pedkindraw S36): the last
## test, pedkindraw's own, asks for the pedigree argument ped, not
## pedSourceDf.
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

## Mark's ruling R88 (docs/planning/standalone-pedigree-package-plan.md
## section 2; was pedSourceDf): the pedigree argument is ped, in the same
## position, and a call that names it gives the same ids as one by position.
## Under the old name, R's partial matching of argument names already let
## ped = reach pedSourceDf, so there only the names check fails.
test_that("getParents()'s pedigree argument is ped", {
  expect_named(formals(getParents), c("ped", "ids"))
  expect_identical(
    getParents(ped = smallPed, ids = c("D", "A")),
    getParents(smallPed, c("D", "A"))
  )
})
