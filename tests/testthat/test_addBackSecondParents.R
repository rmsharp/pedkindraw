## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_addBackSecondParents.R at
## nprcgenekeepr commit baef1e12c. Changes: ruling R88 (pedkindraw S36): the
## last test, pedkindraw's own, asks for the arguments trimmedPed and ped, not
## uPed and ped.
uPedOne <- data.frame(
  id = c(NA, "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, "d1", "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
pedOne <- data.frame(
  id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, "d1", "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
uPedOne <- uPedOne[!is.na(uPedOne$id), ]
uPedTwo <- data.frame(
  id = c(NA, "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, NA, NA, "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, "d1", "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
pedTwo <- data.frame(
  id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, "d1", "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
uPedTwo <- uPedTwo[!is.na(uPedTwo$id), ]

uPedThree <- data.frame(
  id = c("s1", NA, "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, NA, "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
pedThree <- data.frame(
  id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, "s0", "s4", NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, "d0", "d4", NA, "d1", "d2", "d2", "d2"),
  sex = c("M", "F", "M", "F", "F", "F", "F", "M"),
  stringsAsFactors = FALSE
)
uPedThree <- uPedThree[!is.na(uPedThree$id), ]
test_that("addBackSecondParents adds parents correctly", {
  newPed <- addBackSecondParents(uPedOne, pedOne)
  expect_identical(nrow(uPedOne), nrow(newPed)) # no change
  newPed <- addBackSecondParents(uPedTwo, pedTwo)
  expect_identical(nrow(uPedTwo) + 1L, nrow(newPed)) # "s1" added back
  newPed <- addBackSecondParents(uPedThree, pedThree)
  expect_identical(nrow(uPedThree) + 1L, nrow(newPed)) # "d1" added back
})

## Mark's ruling R88 (docs/planning/standalone-pedigree-package-plan.md
## section 2; was uPed): the trimmed pedigree is trimmedPed and the full one
## ped, in the same positions, and a call that names them gives the same
## pedigree as one by position.
test_that("addBackSecondParents()'s arguments are trimmedPed and ped", {
  expect_named(formals(addBackSecondParents), c("trimmedPed", "ped"))
  expect_identical(
    addBackSecondParents(trimmedPed = uPedTwo, ped = pedTwo),
    addBackSecondParents(uPedTwo, pedTwo)
  )
})
