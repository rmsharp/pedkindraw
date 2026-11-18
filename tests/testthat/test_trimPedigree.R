## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_trimPedigree.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped;
## helper-fixtures.R supplies smallPed. Ruling R89 (pedkindraw S37): the four
## calls below pass the pedigree first, and the last test, pedkindraw's own,
## asks for that order.
library(testthat)

ped <- smallPed
trim1 <- trimPedigree(ped, c("C", "K", "L", "D", "E"),
  removeUninformative = FALSE,
  addBackParents = FALSE
)
trim2 <- trimPedigree(ped, c("C", "K", "L", "D", "E"),
  removeUninformative = TRUE,
  addBackParents = FALSE
)
trim3 <- trimPedigree(ped, c("C", "K", "L", "D", "E"),
  removeUninformative = FALSE,
  addBackParents = TRUE
)
trim4 <- trimPedigree(ped, c("C", "K", "L", "D", "E"),
  removeUninformative = TRUE,
  addBackParents = TRUE
)
eTrim1 <- c("A", "B", "C", "D", "E", "K", "L", "Q")
eTrim2 <- c("A", "B", "C", "D", "E", "L")
eTrim3 <- c("A", "B", "C", "D", "E", "K", "L", "Q")
eTrim4 <- c("A", "B", "C", "D", "E", "L", "K")
test_that("trimPedigree retains the correct egos", {
  expect_true(all(trim1$id %in% eTrim1))
  expect_true(all(eTrim1 %in% trim1$id))
  expect_true(all(trim2$id %in% eTrim2))
  expect_true(all(eTrim2 %in% trim2$id))
  expect_true(all(trim3$id %in% eTrim3))
  expect_true(all(eTrim3 %in% trim3$id))
  expect_true(all(trim4$id %in% eTrim4))
  expect_true(all(eTrim4 %in% trim4$id))
})

## Mark's ruling R89 (docs/planning/standalone-pedigree-package-plan.md
## section 2): the pedigree is the first argument. A call in that order gives
## the same pedigree as one that names every argument, and one in
## nprcgenekeepr's order, the probands first, stops.
test_that("trimPedigree() takes the pedigree first", {
  expect_named(
    formals(trimPedigree),
    c("ped", "probands", "removeUninformative", "addBackParents")
  )
  probands <- c("C", "K", "L", "D", "E")
  byPosition <- trimPedigree(smallPed, probands, TRUE, TRUE)
  expect_identical(
    byPosition,
    trimPedigree(
      ped = smallPed, probands = probands, removeUninformative = TRUE,
      addBackParents = TRUE
    )
  )
  expect_identical(byPosition$id, c("A", "B", "C", "D", "E", "L", "K"))
  expect_error(
    trimPedigree(probands, smallPed),
    "$ operator is invalid for atomic vectors",
    fixed = TRUE
  )
})
