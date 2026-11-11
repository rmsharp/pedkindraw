## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_removeUninformativeFounders.R
## at nprcgenekeepr commit baef1e12c. Changes: the line reading
## nprcgenekeepr::qcPed and the blank line after it are dropped;
## helper-fixtures.R supplies qcPed.
library(testthat)
pedOne <- data.frame(
  ego_id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  si_re = c(NA, NA, NA, NA, "s1", "s1", "s2", "s2"),
  dam_id = c(NA, NA, NA, NA, "d1", "d2", "d2", "d2"),
  sex = c("F", "M", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE, check.names = FALSE
)

test_that("removeUninformativeFounders removes correct records", {
  expect_error(removeUninformativeFounders(pedOne))
  names(pedOne) <- c("id", "sire", "dam")
  expect_silent(removeUninformativeFounders(pedOne))
  expect_identical(nrow(removeUninformativeFounders(qcPed)), 136L)
})
