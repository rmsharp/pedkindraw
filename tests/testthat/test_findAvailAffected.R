## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). findAvailAffected() makes one removal of
## shrinkPedigree()'s third trim on the pedigree it is given, among the
## genotyped non-parents whose affected status is affstatus (R40), and returns
## kinship2's four fields, ped, idTrimmed, isTrimmed and bitSize (R41).
## Repeated calls walk shrinkPedigree()'s third trim. Helpers:
## helper-shrinkSteps.R.
library(testthat)

## Seven animals with bit size 5. K and M are the genotyped non-parents of
## unknown (NA) affected status, L the one that is affected. Removing K leaves
## its ungenotyped sire P a leaf and its dam Q a founder with no offspring, so
## all three go (bit size 2); removing M alone leaves bit size 3.
affectedPed <- function() {
  data.frame(id = c("GA", "GB", "P", "K", "Q", "L", "M"),
             sire = c(NA, NA, "GA", "P", NA, "GA", "GA"),
             dam = c(NA, NA, "GB", "Q", NA, "GB", "GB"),
             note = letters[1:7],
             stringsAsFactors = FALSE)
}
affectedGenotyped <- function() c(TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)
affectedStatus <- function() c(FALSE, FALSE, FALSE, NA, FALSE, TRUE, NA)

test_that("findAvailAffected() returns kinship2's four fields", {
  result <- findAvailAffected(affectedPed(), affectedGenotyped(),
                              affectedStatus(), NA)
  expect_named(result, c("ped", "idTrimmed", "isTrimmed", "bitSize"))
})

test_that("findAvailAffected() makes the removal that leaves the smallest
  bit size, with the animals it leaves removable", {
  ped <- affectedPed()
  result <- findAvailAffected(ped, affectedGenotyped(), affectedStatus(), NA)
  expect_true(result$isTrimmed)
  expect_identical(result$idTrimmed, c("K", "P", "Q"))
  expect_identical(result$bitSize, 2L)
  ## Every column is kept, for the rows that remain.
  expect_identical(result$ped, ped[c(1L, 2L, 6L, 7L), ])
  expect_identical(result$bitSize, bitSize(result$ped)$bitSize)
})

test_that("findAvailAffected() chooses only among animals whose affected
  status is affstatus", {
  ped <- affectedPed()
  result <- findAvailAffected(ped, affectedGenotyped(), affectedStatus(),
                              TRUE)
  expect_identical(result$idTrimmed, "L")
  expect_identical(result$bitSize, 3L)
  expect_identical(result$ped, ped[-6L, ])
})

test_that("findAvailAffected() returns the pedigree unchanged when no animal
  of that status can be removed", {
  ped <- affectedPed()
  expected <- list(ped = ped, idTrimmed = character(0L), isTrimmed = FALSE,
                   bitSize = 5L)
  ## No genotyped non-parent is unaffected.
  expect_identical(findAvailAffected(ped, affectedGenotyped(),
                                     affectedStatus(), FALSE),
                   expected)
  ## No animal is genotyped.
  expect_identical(findAvailAffected(ped, rep(FALSE, 7L), affectedStatus(),
                                     NA),
                   expected)
})

test_that("findAvailAffected() reads affected from the pedigree, or counts
  every animal unaffected, when the argument is NULL", {
  ped <- affectedPed()
  ## No affected column: K, L and M are unaffected candidates.
  expect_identical(
    findAvailAffected(ped, affectedGenotyped(), NULL, FALSE)$idTrimmed,
    c("K", "P", "Q")
  )
  expect_false(
    findAvailAffected(ped, affectedGenotyped(), NULL, NA)$isTrimmed
  )
  ped$affected <- affectedStatus()
  expect_identical(
    findAvailAffected(ped, affectedGenotyped(), NULL, TRUE)$idTrimmed,
    "L"
  )
})

test_that("findAvailAffected() breaks a tie by the first id and blanks the
  parents of an animal it makes a founder", {
  ## U1 and U2 are an ungenotyped founder couple with one child, X. Removing
  ## Y or Z (both of unknown affected status) leaves bit size 0: U1 and U2
  ## go, and X becomes a founder. Y comes first.
  ped <- data.frame(id = c("U1", "U2", "X", "W", "Y", "Z"),
                    sire = c(NA, NA, "U1", NA, "X", "X"),
                    dam = c(NA, NA, "U2", NA, "W", "W"),
                    stringsAsFactors = FALSE)
  result <- findAvailAffected(ped, c(FALSE, FALSE, TRUE, TRUE, TRUE, TRUE),
                              c(FALSE, FALSE, FALSE, FALSE, NA, NA), NA)
  expect_identical(result$idTrimmed, c("Y", "U1", "U2"))
  expect_identical(result$bitSize, 0L)
  expected <- ped[c(3L, 4L, 6L), ]
  expected$sire[1L] <- NA_character_
  expected$dam[1L] <- NA_character_
  expect_identical(result$ped, expected)
})

test_that("findAvailAffected() breaks a tie by byte order, capitals first,
  as shrinkPedigree() does (C16)", {
  ped <- data.frame(id = c("S", "T", "b", "C"), sire = c(NA, NA, "S", "S"),
                    dam = c(NA, NA, "T", "T"), stringsAsFactors = FALSE)
  result <- findAvailAffected(ped, rep(TRUE, 4L), rep(NA, 4L), NA)
  expect_identical(result$idTrimmed, "C")
  expect_identical(result$bitSize, 0L)
})

test_that("repeated findAvailAffected() calls walk shrinkPedigree()'s third
  trim on the fixture pedigrees", {
  rounds <- 0L
  peds <- shrinkStepPedigrees()[c("lacy1989Ped", "smallPed", "qcPed",
                                  "rhesusPedigree")]
  for (name in names(peds)) {
    ped <- peds[[name]]
    affected <- shrinkStepAffected(nrow(ped))
    patterns <- shrinkStepGenotyped(nrow(ped))[c("all", "r60", "r90")]
    for (pattern in names(patterns)) {
      genotyped <- patterns[[pattern]]
      for (maxBits in c(16L, 0L)) {
        label <- paste(name, pattern, maxBits)
        shrunk <- shrinkPedigree(ped, genotyped, affected = affected,
                                 maxBits = maxBits)
        walked <- walkThirdTrim(ped, genotyped, affected, maxBits)
        expect_identical(walked$idTrimmed, shrunk$idList$affected,
                         info = label)
        expect_identical(walked$bitSize, shrunk$bitSize, info = label)
        expect_identical(walked$ped, shrunk$ped, info = label)
        rounds <- rounds + length(shrunk$bitSize) - 2L
      }
    }
  }
  ## The third trim runs: the cases take hundreds of rounds between them.
  expect_gt(rounds, 100L)
})

test_that("findAvailAffected() stops on an affstatus that is not NA, FALSE
  or TRUE", {
  ped <- affectedPed()
  for (status in list(1L, "TRUE", c(NA, TRUE), logical(0L), NULL)) {
    expect_error(findAvailAffected(ped, affectedGenotyped(),
                                   affectedStatus(), status),
                 "affstatus must be NA, FALSE or TRUE", fixed = TRUE)
  }
})

test_that("findAvailAffected() stops with shrinkPedigree()'s errors", {
  ped <- affectedPed()
  expect_error(findAvailAffected(ped["id"], affectedGenotyped(),
                                 affectedStatus(), NA),
               "Pedigree is missing sire, dam", fixed = TRUE)
  expect_error(findAvailAffected(ped, affectedGenotyped()[-1L],
                                 affectedStatus(), NA),
               "genotyped must be the same length as nrow(ped) (7)",
               fixed = TRUE)
  expect_error(findAvailAffected(ped, c(NA, affectedGenotyped()[-1L]),
                                 affectedStatus(), NA),
               "NA values not allowed in genotyped vector.", fixed = TRUE)
  expect_error(findAvailAffected(ped, affectedGenotyped(), c(TRUE, FALSE),
                                 NA),
               "affected must be the same length as nrow(ped) (7)",
               fixed = TRUE)
})
