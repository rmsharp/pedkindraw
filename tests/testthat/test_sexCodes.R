## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_sexCodes.R at nprcgenekeepr
## commit baef1e12c. Changes: only the test of the four values is copied
## (Mark's pick, S7). Left out: the source's comment on its R/ scan (lines
## 3-14), the scan's helpers and its four tests (lines 17-46 and 55-167: "no
## bare sex-code literals remain anywhere in R/ outside the allowlist", "every
## allowlisted file and line still exists in R/", "the R/ scan flags a new
## letter, honours the allowlist, skips comments" and "the guard flags each
## bare-literal form it claims to catch"). Their allowlist names nprcgenekeepr
## files pedkindraw does not have, and they need nprcgenekeepr's
## rSourceAvailable() helper.
library(testthat)

test_that("sexCodes defines the four canonical values", {
  expect_identical(sexCodes[["male"]], "M")
  expect_identical(sexCodes[["female"]], "F")
  expect_identical(sexCodes[["hermaphrodite"]], "H")
  expect_identical(sexCodes[["unknown"]], "U")
})
