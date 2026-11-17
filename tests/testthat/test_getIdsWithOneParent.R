## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17c2,
## ruling R88, pedkindraw S36). Neither package had a test file for
## getIdsWithOneParent(). Every expected value was computed by a scratch run
## before these tests were written.
library(testthat)
ped <- data.frame(
  id = c("A", "B", "C", "D", "E"),
  sire = c(NA, NA, "A", "A", NA),
  dam = c(NA, NA, "B", NA, "B"),
  stringsAsFactors = FALSE
)

## Mark's ruling R88 (docs/planning/standalone-pedigree-package-plan.md
## section 2; was uPed): the pedigree argument is ped, and a call that names
## it gives the same ids as one by position.
test_that("getIdsWithOneParent()'s pedigree argument is ped", {
  expect_named(formals(getIdsWithOneParent), "ped")
  expect_identical(getIdsWithOneParent(ped = ped), getIdsWithOneParent(ped))
})

test_that("getIdsWithOneParent() finds the animals with one known parent", {
  ## A and B have no known parent, C has both, D only a sire, E only a dam.
  expect_identical(getIdsWithOneParent(ped = ped), c("D", "E"))
  expect_identical(
    getIdsWithOneParent(ped = ped[ped$id %in% c("A", "B", "C"), ]),
    character(0)
  )
})
