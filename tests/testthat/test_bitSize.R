## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). bitSize() returns kinship2's list,
## bitSize, nFounder and nNonFounder (R41), the bit size being
## shrinkPedigree()'s first (R40); it stops with shrinkPedigree()'s pedigree
## errors. Helpers: helper-shrinkSteps.R.
library(testthat)

test_that("bitSize() gives 2 per non-founder less 1 per founder, with the
  two counts", {
  ## A, B and E are founders; C, D and F are not.
  ped <- data.frame(id = c("A", "B", "C", "D", "E", "F"),
                    sire = c(NA, NA, "A", "A", NA, "D"),
                    dam = c(NA, NA, "B", "B", NA, "E"),
                    stringsAsFactors = FALSE)
  expect_identical(bitSize(ped),
                   list(bitSize = 3L, nFounder = 3L, nNonFounder = 3L))
})

test_that("bitSize() counts an animal with one known parent as a
  non-founder", {
  ped <- data.frame(id = c("A", "B", "C"), sire = c(NA, "A", NA),
                    dam = c(NA, NA, NA), stringsAsFactors = FALSE)
  expect_identical(bitSize(ped),
                   list(bitSize = 0L, nFounder = 2L, nNonFounder = 1L))
})

test_that("bitSize() of a pedigree with no rows is 0", {
  ped <- data.frame(id = character(0L), sire = character(0L),
                    dam = character(0L), stringsAsFactors = FALSE)
  expect_identical(bitSize(ped),
                   list(bitSize = 0L, nFounder = 0L, nNonFounder = 0L))
})

test_that("bitSize() reads factor and numeric ids as their text", {
  ped <- data.frame(id = factor(c("A", "B", "C")),
                    sire = factor(c(NA, NA, "A")),
                    dam = factor(c(NA, NA, "B")))
  expect_identical(bitSize(ped)$bitSize, 0L)
  numeric <- data.frame(id = c(1, 2, 3), sire = c(NA, NA, 1),
                        dam = c(NA, NA, 2))
  expect_identical(bitSize(numeric)$bitSize, 0L)
})

test_that("bitSize() equals shrinkPedigree()'s first bit size and counts
  isFounder()'s founders on every fixture pedigree", {
  peds <- shrinkStepPedigrees()
  for (name in names(peds)) {
    ped <- peds[[name]]
    result <- bitSize(ped)
    shrunk <- shrinkPedigree(ped, rep(TRUE, nrow(ped)), maxBits = Inf)
    expect_identical(result$bitSize, shrunk$bitSize[1L], info = name)
    expect_identical(result$nFounder, sum(isFounder(ped)), info = name)
    expect_identical(result$nFounder + result$nNonFounder, nrow(ped),
                     info = name)
  }
})

test_that("bitSize() stops with shrinkPedigree()'s pedigree errors", {
  expect_error(bitSize(data.frame(id = "A")),
               "Pedigree is missing sire, dam", fixed = TRUE)
  expect_error(bitSize(list(id = "A", sire = NA, dam = NA)),
               "ped must be a data frame", fixed = TRUE)
  expect_error(bitSize(data.frame(id = c("A", NA), sire = NA, dam = NA)),
               "No id may be missing or empty", fixed = TRUE)
  expect_error(bitSize(data.frame(id = c("A", ""), sire = NA, dam = NA)),
               "No id may be missing or empty", fixed = TRUE)
  expect_error(bitSize(data.frame(id = c("A", "A"), sire = NA, dam = NA)),
               "No id may appear twice", fixed = TRUE)
  expect_error(bitSize(data.frame(id = c("A", "B"), sire = c(NA, "Z"),
                                  dam = NA)),
               "Every sire and dam must be NA or an id in ped", fixed = TRUE)
  expect_error(bitSize(data.frame(id = c("A", "B", "C", "D"),
                                  sire = c(NA, NA, "A", "B"),
                                  dam = c(NA, NA, "B", "A"))),
               "An animal cannot be both a sire and a dam", fixed = TRUE)
})

test_that("bitSize() equals kinship2::bitSize() on the fixture pedigrees
  kinship2 accepts", {
  skip_if_not_installed("kinship2")
  peds <- shrinkStepPedigrees(forKinship2 = TRUE)
  for (name in names(peds)) {
    ped <- peds[[name]]
    theirs <- kinship2::bitSize(
      asKinship2Pedigree(ped, rep(FALSE, nrow(ped)))
    )
    expect_identical(
      bitSize(ped),
      lapply(theirs[c("bitSize", "nFounder", "nNonFounder")], as.integer),
      info = name
    )
  }
})
