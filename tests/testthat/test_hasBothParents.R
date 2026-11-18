## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17c3,
## ruling R89, pedkindraw S37). nprcgenekeepr has no test file named for
## hasBothParents(); its tests of the function are in
## test_kinshipHasBothParentsHelp.R, copied here. Every expected value was
## computed by a scratch run before these tests were written.
library(testthat)
ped <- data.frame(
  id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, NA, NA, NA, "s1", "s1", "s2", NA),
  dam = c(NA, NA, NA, NA, "d1", "d2", NA, "d2"),
  stringsAsFactors = FALSE
)

## Mark's ruling R89 (docs/planning/standalone-pedigree-package-plan.md
## section 2): the pedigree is the first argument, as in getParents(). A call
## in that order gives the same answer as one that names both arguments, and
## one in nprcgenekeepr's order, the id first, stops.
test_that("hasBothParents() takes the pedigree first", {
  expect_named(formals(hasBothParents), c("ped", "id"))
  expect_identical(
    hasBothParents(ped, "o1"),
    hasBothParents(ped = ped, id = "o1")
  )
  expect_error(
    hasBothParents("o1", ped),
    "$ operator is invalid for atomic vectors",
    fixed = TRUE
  )
})

test_that("hasBothParents() is TRUE only when both parents are known", {
  expect_true(hasBothParents(ped, "o1"))
  expect_false(hasBothParents(ped, "o3"))
  expect_false(hasBothParents(ped, "o4"))
  expect_false(hasBothParents(ped, "s1"))
  expect_identical(hasBothParents(ped, "zz"), logical(0L))
})
