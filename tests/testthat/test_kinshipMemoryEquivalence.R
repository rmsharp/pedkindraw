## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_kinshipMemoryEquivalence.R
## at nprcgenekeepr commit baef1e12c. Changes: only the test of kinship()'s
## messages for malformed input (ruling C11) is copied, with the two
## functions it needs, seededPedigree() and malformedKinshipCases() (Mark's
## pick, S8); outcome() is in helper-outcome.R. Left out, the source's
## lines 3-28, 56-159, 196-202 and 213-464: the comment on nprcgenekeepr's
## performance campaign; kinshipSeeds, seededKinshipCases() and
## kinshipGrid(), which need nprcgenekeepr's qcStudbook() and example data;
## expectSameOutcomes(); three tests that compare kinship() with results
## nprcgenekeepr saved in its cleanroom/ folder before the rewrite
## ("kinship() gives the saved matrix on the grid", "checked kinship()
## inputs give the saved message or matrix", "kinship(sparse = TRUE) gives
## the saved sparse matrix"); and eight tests of nprcgenekeepr's
## kinMatrix2LongForm(), highKinshipPairs() and getAnimalsWithHighKinship().
## pedkindraw's tools/compareResultsWithNprcgenekeepr.R compares kinship()
## with nprcgenekeepr's instead.

## A seeded pedigree of n animals in birth order: a fifth are founders, each
## later animal draws a sire and a dam from the animals before it, one parent
## in ten is left unknown, and one animal in twenty has an unknown sex ("U" or
## NA), the cases that reach the missing-parent row on the X chromosome.
seededPedigree <- function(n, seed) {
  withr::with_seed(seed, {
    id <- sprintf("A%03d", seq_len(n))
    founders <- max(2L, n %/% 5L)
    sire <- dam <- rep(NA_character_, n)
    sex <- sample(c("M", "F"), n, replace = TRUE)
    sex[seq_len(founders)] <- rep(c("M", "F"), length.out = founders)
    for (i in seq.int(founders + 1L, n)) {
      males <- which(sex[seq_len(i - 1L)] == "M")
      females <- which(sex[seq_len(i - 1L)] == "F")
      sire[i] <- id[males[sample.int(length(males), 1L)]]
      dam[i] <- id[females[sample.int(length(females), 1L)]]
      if (stats::runif(1L) < 0.1) sire[i] <- NA
      if (stats::runif(1L) < 0.1) dam[i] <- NA
    }
    unknown <- stats::runif(n) < 0.05
    sex[unknown] <- sample(c("U", NA), sum(unknown), replace = TRUE)
    list(id = id, sire = sire, dam = dam,
         gen = findGeneration(id, sire, dam), sex = sex)
  })
}

## kinship()'s inputs of the wrong shape (Mark's ruling C11): before the
## clean-room rewrite they ran a fallback of today's code, which gave R's own
## messages or a wrong matrix; now each stops with one plain message.
malformedKinshipCases <- function() {
  p <- seededPedigree(12L, 1L)
  list(
    `sparse = NA` = list(p$id, p$sire, p$dam, p$gen, sparse = NA),
    `sparse = 0` = list(p$id, p$sire, p$dam, p$gen, sparse = 0L),
    `no animals` = list(character(0L), character(0L), character(0L),
                        integer(0L)),
    `a missing generation` = list(p$id, p$sire, p$dam,
                                  replace(p$gen, 3L, NA)),
    `one generation short` = list(p$id, p$sire, p$dam, p$gen[-1L]),
    `one sire short` = list(p$id, p$sire[-1L], p$dam, p$gen),
    `one dam short` = list(p$id, p$sire, p$dam[-1L], p$gen),
    `no generations` = list(p$id, p$sire, p$dam, NULL),
    `generations as a list` = list(p$id, p$sire, p$dam, as.list(p$gen)),
    `generations as a function` = list(p$id, p$sire, p$dam, function() 1L)
  )
}

## The message each malformed input stops with.
malformedKinshipMessages <- c(
  `sparse = NA` = "sparse must be TRUE or FALSE",
  `sparse = 0` = "sparse must be TRUE or FALSE",
  `no animals` = "id must hold at least one animal",
  `a missing generation` = "pdepth must not be missing for any animal",
  `one generation short` =
    "fatherId, motherId and pdepth must each be as long as id",
  `one sire short` = "fatherId, motherId and pdepth must each be as long as id",
  `one dam short` = "fatherId, motherId and pdepth must each be as long as id",
  `no generations` = "pdepth must be a vector of generation numbers",
  `generations as a list` = "pdepth must be a vector of generation numbers",
  `generations as a function` = "pdepth must be a vector of generation numbers"
)

test_that("malformed kinship() inputs stop with Mark's C11 messages", {
  cases <- malformedKinshipCases()
  expect_named(cases, names(malformedKinshipMessages))
  for (name in names(cases)) {
    expect_identical(outcome(kinship, cases[[name]]),
                     list(error = malformedKinshipMessages[[name]],
                          warnings = character(0L)),
                     info = name)
  }
})
