## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_removeUnknownAnimals.R at
## nprcgenekeepr commit baef1e12c. Changes: nprcgenekeepr::smallPed becomes
## smallPed and the line reading nprcgenekeepr::pedSix is dropped
## (helper-fixtures.R supplies both); library(stringi) is dropped and stringi's
## stri_c() becomes paste0(), which gives identical test names here (all 7
## checked in S7), so pedkindraw needs no stringi.
library(testthat)
ped <- smallPed
newPed <- cbind(ped,
  recordStatus = rep("original", nrow(ped)),
  stringsAsFactors = FALSE
)
addedPed <- newPed
addedPed[1L:3L, "recordStatus"] <- "added"
test_that(paste0(
  "removeUnknownAnimals removes nothing with no \"added\" ",
  "(unknown) animals"
), {
  ped1 <- removeUnknownAnimals(newPed)
  expect_identical(nrow(ped1), nrow(newPed))
  expect_identical(nrow(ped1), nrow(addedPed))
})

test_that(paste0(
  "removeUnknownAnimals removes \"added\" ",
  "(unknown) animals"
), {
  ped2 <- removeUnknownAnimals(addedPed)
  expect_false(nrow(ped2) == nrow(addedPed))
  expect_identical(nrow(ped2) + 3L, nrow(addedPed))
})

test_that(paste0(
  "removeUnknownAnimals returns a pedigree without a recordStatus column ",
  "unchanged"
), {
  expect_false("recordStatus" %in% names(ped))
  expect_identical(removeUnknownAnimals(ped), ped)
  expect_false("recordStatus" %in% names(pedSix))
  expect_identical(removeUnknownAnimals(pedSix), pedSix)
})

test_that("removeUnknownAnimals keeps columns when all animals are \"added\"", {
  allAddedPed <- newPed
  allAddedPed$recordStatus <- "added"
  noneLeft <- removeUnknownAnimals(allAddedPed)
  expect_identical(nrow(noneLeft), 0L)
  expect_identical(names(noneLeft), names(allAddedPed))
})

test_that("removeUnknownAnimals handles zero-row pedigrees", {
  expect_identical(removeUnknownAnimals(ped[0L, ]), ped[0L, ])
  zeroWithStatus <- newPed[0L, ]
  result <- removeUnknownAnimals(zeroWithStatus)
  expect_identical(nrow(result), 0L)
  expect_identical(names(result), names(zeroWithStatus))
})

## Only animals marked "added" are placeholders. A missing (NA) or
## unrecognised recordStatus is not "added", so the animal is kept.
test_that(paste0(
  "removeUnknownAnimals returns a pedigree with no \"added\" animals ",
  "unchanged"
), {
  expect_identical(removeUnknownAnimals(newPed), newPed)
})

test_that(paste0(
  "removeUnknownAnimals keeps an animal whose recordStatus is NA ",
  "without adding a phantom row"
), {
  naPed <- newPed
  naPed[5L, "recordStatus"] <- NA_character_
  result <- removeUnknownAnimals(naPed)
  expect_false(anyNA(result$id))
  expect_true(ped$id[5L] %in% result$id)
  expect_identical(result, naPed)
})

test_that("removeUnknownAnimals keeps every animal when all statuses are NA", {
  allNaPed <- newPed
  allNaPed$recordStatus <- NA_character_
  result <- removeUnknownAnimals(allNaPed)
  expect_false(anyNA(result$id))
  expect_identical(result, allNaPed)
})

test_that("removeUnknownAnimals keeps an animal with an unrecognised status", {
  weirdPed <- newPed
  weirdPed[5L, "recordStatus"] <- "weird"
  result <- removeUnknownAnimals(weirdPed)
  expect_identical(result, weirdPed)
})

test_that(paste0(
  "removeUnknownAnimals removes only \"added\" animals when NA and ",
  "unrecognised statuses are also present"
), {
  mixedPed <- addedPed
  mixedPed[5L, "recordStatus"] <- NA_character_
  mixedPed[6L, "recordStatus"] <- "weird"
  result <- removeUnknownAnimals(mixedPed)
  expect_false(anyNA(result$id))
  expect_identical(result$id, mixedPed$id[-(1L:3L)])
  expect_identical(result$recordStatus, mixedPed$recordStatus[-(1L:3L)])
})

test_that(paste0(
  "removeUnknownAnimals handles a factor recordStatus that has an NA ",
  "value"
), {
  factorPed <- addedPed
  factorPed$recordStatus <- factor(factorPed$recordStatus)
  factorPed[5L, "recordStatus"] <- NA
  result <- removeUnknownAnimals(factorPed)
  expect_false(anyNA(result$id))
  expect_identical(result$id, factorPed$id[-(1L:3L)])
})
