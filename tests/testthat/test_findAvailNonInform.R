## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 11,
## rulings R40-R42, pedkindraw S14). findAvailNonInform() returns the ids
## shrinkPedigree()'s second trim removes, in the order it removes them,
## running the first trim itself (R40, R41), and stops with shrinkPedigree()'s
## errors. With findUnavailable() it removes what kinship2's pedigree.shrink()
## removes in its first two steps (R42). Helpers: helper-shrinkSteps.R.
library(testthat)

## Eight animals, all genotyped. G (parents C and E) and H (parents A and B,
## affected NA) are uninformative leaves; with G gone, E is a founder with no
## offspring; then C is an uninformative leaf. D is affected and I has one
## known parent, so both stay, and A and B stay as their parents.
nonInformPed <- function() {
  data.frame(id = c("A", "B", "C", "D", "E", "G", "H", "I"),
             sire = c(NA, NA, "A", "A", NA, "C", "A", "A"),
             dam = c(NA, NA, "B", "B", NA, "E", "B", NA),
             affected = c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, NA, FALSE),
             stringsAsFactors = FALSE)
}

test_that("findAvailNonInform() removes uninformative genotyped leaves and
  follows on to the parents they leave", {
  ped <- nonInformPed()
  expect_identical(findAvailNonInform(ped, rep(TRUE, 8L), ped$affected),
                   c("G", "H", "E", "C"))
})

test_that("findAvailNonInform() reads affected from the pedigree's column
  when the argument is NULL", {
  expect_identical(findAvailNonInform(nonInformPed(), rep(TRUE, 8L)),
                   c("G", "H", "E", "C"))
})

test_that("findAvailNonInform() treats every animal as unaffected when there
  is no affected argument or column", {
  ped <- nonInformPed()
  ped$affected <- NULL
  ## D is now uninformative too. With D, G, H and C gone, B has no offspring
  ## left (I's dam is unknown), so B goes as a founder with none; A stays as
  ## I's sire.
  expect_identical(findAvailNonInform(ped, rep(TRUE, 8L)),
                   c("D", "G", "H", "E", "C", "B"))
})

test_that("findAvailNonInform() runs the first trim itself and returns only
  the second trim's ids", {
  ped <- rbind(nonInformPed(),
               data.frame(id = "J", sire = "A", dam = "B", affected = FALSE))
  genotyped <- c(rep(TRUE, 8L), FALSE)
  expect_identical(findUnavailable(ped, genotyped), "J")
  expect_identical(findAvailNonInform(ped, genotyped),
                   c("G", "H", "E", "C"))
})

test_that("findAvailNonInform() returns character(0) when nothing is
  uninformative", {
  ped <- nonInformPed()
  expect_identical(findAvailNonInform(ped, rep(FALSE, 8L)), character(0L))
  expect_identical(findAvailNonInform(ped, rep(TRUE, 8L), rep(TRUE, 8L)),
                   character(0L))
})

test_that("findAvailNonInform() gives shrinkPedigree()'s second-trim ids on
  every fixture pedigree, genotyped pattern and affected status", {
  reached <- 0L
  peds <- shrinkStepPedigrees()
  for (name in names(peds)) {
    ped <- peds[[name]]
    affected <- shrinkStepAffected(nrow(ped))
    patterns <- shrinkStepGenotyped(nrow(ped))
    for (pattern in names(patterns)) {
      genotyped <- patterns[[pattern]]
      expected <- shrinkPedigree(ped, genotyped, affected = affected,
                                 maxBits = Inf)$idList$noninform
      expect_identical(findAvailNonInform(ped, genotyped, affected),
                       expected, info = paste(name, pattern))
      if (length(expected) > 0L) reached <- reached + 1L
    }
  }
  ## The cases are not vacuous: most partly or fully genotyped ones remove
  ## animals.
  expect_gt(reached, 10L)
})

test_that("findAvailNonInform() stops with shrinkPedigree()'s errors", {
  ped <- nonInformPed()
  genotyped <- rep(TRUE, 8L)
  expect_error(findAvailNonInform(ped[c("sire", "dam")], genotyped),
               "Pedigree is missing id", fixed = TRUE)
  expect_error(findAvailNonInform(ped, genotyped[-1L]),
               "genotyped must be the same length as nrow(ped) (8)",
               fixed = TRUE)
  expect_error(findAvailNonInform(ped, c(NA, genotyped[-1L])),
               "NA values not allowed in genotyped vector.", fixed = TRUE)
  expect_error(findAvailNonInform(ped, genotyped, c(TRUE, FALSE)),
               "affected must be the same length as nrow(ped) (8)",
               fixed = TRUE)
  bothParents <- ped
  bothParents$sire[5L] <- "B"
  expect_error(findAvailNonInform(bothParents, genotyped),
               "An animal cannot be both a sire and a dam", fixed = TRUE)
})

test_that("findUnavailable() and findAvailNonInform() together remove what
  kinship2's pedigree.shrink() removes in its first two steps", {
  skip_if_not_installed("kinship2")
  peds <- shrinkStepPedigrees(forKinship2 = TRUE)
  for (name in names(peds)) {
    ped <- peds[[name]]
    affected <- shrinkStepAffected(nrow(ped))
    patterns <- shrinkStepGenotyped(nrow(ped))
    ## kinship2 stops when no animal is genotyped.
    patterns$none <- NULL
    for (pattern in names(patterns)) {
      genotyped <- patterns[[pattern]]
      ours <- c(findUnavailable(ped, genotyped),
                findAvailNonInform(ped, genotyped, affected))
      ## A budget at the bit size after the first two steps, so kinship2
      ## runs its second step and stops there when it agrees.
      firstTwo <- shrinkPedigree(ped, genotyped, affected = affected,
                                 maxBits = Inf)
      theirs <- kinship2::pedigree.shrink(
        asKinship2Pedigree(ped, affected), genotyped,
        maxBits = firstTwo$bitSize[2L]
      )
      expect_setequal(ours, c(splitKinship2Ids(theirs$idList$unavail),
                              splitKinship2Ids(theirs$idList$noninform)))
      expect_identical(as.integer(theirs$bitSize), firstTwo$bitSize,
                       info = paste(name, pattern))
    }
  }
})
