## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). findUnavailable() returns the ids
## shrinkPedigree()'s first trim removes, in the order it removes them (R40,
## R41), and stops with shrinkPedigree()'s errors. Helpers:
## helper-shrinkSteps.R.
library(testthat)

## Nine animals. D, G and I are ungenotyped leaves; with D gone, A and B are
## an ungenotyped founder couple with one child (C), so they go and C becomes
## a founder; with I gone, H is a founder with no offspring (a stray
## marry-in) and goes although genotyped.
unavailablePed <- function() {
  data.frame(id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
             sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "H"),
             dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "E"),
             stringsAsFactors = FALSE)
}
unavailableGenotyped <- function() {
  c(FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE)
}

test_that("findUnavailable() removes ungenotyped leaves, an ungenotyped
  founder couple and a stray marry-in, in that order", {
  expect_identical(findUnavailable(unavailablePed(), unavailableGenotyped()),
                   c("D", "G", "I", "A", "B", "H"))
})

test_that("findUnavailable() returns character(0) when every animal is
  genotyped and every founder has offspring", {
  expect_identical(findUnavailable(unavailablePed(), rep(TRUE, 9L)),
                   character(0L))
})

test_that("findUnavailable() returns every id when no animal is genotyped
  (kinship2's findUnavailable() stops instead)", {
  ped <- unavailablePed()
  result <- findUnavailable(ped, rep(FALSE, 9L))
  expect_type(result, "character")
  expect_setequal(result, ped$id)
  expect_length(result, 9L)
})

test_that("findUnavailable() reads factor ids and 0/1 genotyped values", {
  ped <- unavailablePed()
  ped[] <- lapply(ped, factor)
  expect_identical(
    findUnavailable(ped, as.integer(unavailableGenotyped())),
    c("D", "G", "I", "A", "B", "H")
  )
})

test_that("findUnavailable() gives shrinkPedigree()'s first-trim ids on
  every fixture pedigree and genotyped pattern", {
  reached <- 0L
  peds <- shrinkStepPedigrees()
  for (name in names(peds)) {
    ped <- peds[[name]]
    patterns <- shrinkStepGenotyped(nrow(ped))
    for (pattern in names(patterns)) {
      genotyped <- patterns[[pattern]]
      expected <- shrinkPedigree(ped, genotyped, maxBits = Inf)$idList$unavail
      expect_identical(findUnavailable(ped, genotyped), expected,
                       info = paste(name, pattern))
      if (pattern != "none" && length(expected) > 0L) reached <- reached + 1L
    }
  }
  ## The cases are not vacuous: most partly genotyped ones remove animals.
  expect_gt(reached, 10L)
})

test_that("findUnavailable() stops with shrinkPedigree()'s errors", {
  ped <- unavailablePed()
  genotyped <- unavailableGenotyped()
  expect_error(findUnavailable(ped[c("id", "sire")], genotyped),
               "Pedigree is missing dam", fixed = TRUE)
  expect_error(findUnavailable(as.list(ped), genotyped),
               "ped must be a data frame", fixed = TRUE)
  expect_error(findUnavailable(ped, genotyped[-1L]),
               "genotyped must be the same length as nrow(ped) (9)",
               fixed = TRUE)
  expect_error(findUnavailable(ped, c(NA, genotyped[-1L])),
               "NA values not allowed in genotyped vector.", fixed = TRUE)
  repeated <- ped
  repeated$id[2L] <- "A"
  expect_error(findUnavailable(repeated, genotyped),
               "No id may appear twice", fixed = TRUE)
  unknownParent <- ped
  unknownParent$sire[3L] <- "Z"
  expect_error(findUnavailable(unknownParent, genotyped),
               "Every sire and dam must be NA or an id in ped", fixed = TRUE)
})

## Seven animals, in this row order. GP1 and GP2 are an ungenotyped founder
## couple with one child, M; M and the founder F, both ungenotyped, have one
## child, X, the only genotyped animal; X's one offspring, Y, is ungenotyped,
## and so is Y's other parent W.
twoCouplesPed <- function() {
  data.frame(id = c("GP1", "GP2", "M", "F", "X", "W", "Y"),
             sire = c(NA, NA, "GP1", NA, "F", NA, "W"),
             dam = c(NA, NA, "GP2", NA, "M", NA, "X"),
             stringsAsFactors = FALSE)
}

test_that("findUnavailable() removes a couple whose member became a founder
  earlier in the same trim, where kinship2 waits for its next step", {
  ped <- twoCouplesPed()
  genotyped <- c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)
  ## Y and W go as ungenotyped leaves, GP1 and GP2 as a couple, which makes M
  ## a founder; then M and F qualify as a couple, which makes X a founder with
  ## no offspring.
  expect_identical(findUnavailable(ped, genotyped),
                   c("Y", "W", "GP1", "GP2", "F", "M", "X"))
  ## With X's row above M's, the couple M and F is looked at before M is a
  ## founder, and the second trim removes it, as kinship2 does.
  reordered <- c(1L, 2L, 5L, 3L, 4L, 6L, 7L)
  expect_identical(findUnavailable(ped[reordered, ], genotyped[reordered]),
                   c("Y", "W", "GP1", "GP2"))
  expect_identical(
    findAvailNonInform(ped[reordered, ], genotyped[reordered]),
    c("F", "M", "X")
  )
  skip_if_not_installed("kinship2")
  kinship2Ped <- asKinship2Pedigree(ped, rep(FALSE, 7L))
  expect_setequal(as.character(kinship2::findUnavailable(kinship2Ped,
                                                         genotyped)),
                  c("GP1", "GP2", "W", "Y"))
})
