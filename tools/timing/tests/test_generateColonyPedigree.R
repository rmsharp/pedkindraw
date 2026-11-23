## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr
## tools/pedigreeComparison/tests/test_generateColonyPedigree.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: the path in the comment on how to run it.
## Tests for generateColonyPedigree(), the seeded synthetic colony every
## Phase 1 agreement, timing and capacity figure rests on
## (docs/planning/standalone-pedigree-package-plan.md, Phase 1 step 3).
## They live beside the comparison scripts, not in the package suite (Mark's
## ruling, S1122). Run from the project root:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_generateColonyPedigree.R")'

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("generateColonyPedigree.R")

## One colony per size and seed, built once and shared by the tests.
colony <- local({
  cache <- list()
  function(n, seed = 1L) {
    key <- paste(n, seed)
    if (is.null(cache[[key]])) {
      cache[[key]] <<- generateColonyPedigree(n, seed)
    }
    cache[[key]]
  }
})

## Generation number: founders 0, otherwise one more than the older parent.
## Parents are earlier rows (tested below), so one pass in row order works.
generationOf <- function(ped) {
  sireRow <- match(ped$sire, ped$id)
  damRow <- match(ped$dam, ped$id)
  g <- integer(nrow(ped))
  for (i in seq_len(nrow(ped))) {
    if (!is.na(sireRow[i])) {
      g[i] <- max(g[sireRow[i]], g[damRow[i]]) + 1L
    }
  }
  g
}

test_that("it returns exactly n rows of id, sire, dam, sex and birth", {
  for (n in c(1L, 7L, 25L, 1000L)) {
    ped <- generateColonyPedigree(n, 1L)
    expect_s3_class(ped, "data.frame")
    expect_named(ped, c("id", "sire", "dam", "sex", "birth"))
    expect_identical(nrow(ped), n)
  }
  ped <- colony(1000L)
  expect_type(ped$id, "character")
  expect_type(ped$sire, "character")
  expect_type(ped$dam, "character")
  expect_type(ped$sex, "character")
  expect_s3_class(ped$birth, "Date")
})

test_that("ids are unique and never missing or empty", {
  ped <- colony(10000L)
  expect_false(anyDuplicated(ped$id) > 0L)
  expect_false(anyNA(ped$id))
  expect_true(all(nzchar(ped$id)))
})

test_that("the same seed gives the same colony, another seed a different one", {
  expect_identical(generateColonyPedigree(500L, 7L),
                   generateColonyPedigree(500L, 7L))
  expect_false(identical(generateColonyPedigree(500L, 7L),
                         generateColonyPedigree(500L, 8L)))
})

test_that("it leaves the caller's random-number state alone", {
  set.seed(99L)
  before <- get(".Random.seed", envir = globalenv())
  generateColonyPedigree(200L, 1L)
  expect_identical(get(".Random.seed", envir = globalenv()), before)
})

test_that("a caller with no random-number state is left with none", {
  saved <- if (exists(".Random.seed", envir = globalenv())) {
    get(".Random.seed", envir = globalenv())
  }
  on.exit(if (!is.null(saved)) {
    # nolint next: object_name_linter.
    assign(".Random.seed", saved, envir = globalenv())
  })
  if (exists(".Random.seed", envir = globalenv())) {
    rm(".Random.seed", envir = globalenv())
  }
  generateColonyPedigree(200L, 1L)
  expect_false(exists(".Random.seed", envir = globalenv()))
})

test_that("every animal has both parents or neither", {
  ped <- colony(10000L)
  expect_false(any(xor(is.na(ped$sire), is.na(ped$dam))))
})

test_that("every parent is an earlier animal, born at least 3 years before", {
  ped <- colony(10000L)
  child <- which(!is.na(ped$sire))
  sireRow <- match(ped$sire[child], ped$id)
  damRow <- match(ped$dam[child], ped$id)
  expect_false(anyNA(sireRow))
  expect_false(anyNA(damRow))
  expect_true(all(sireRow < child))
  expect_true(all(damRow < child))
  threeYears <- 3.0 * 365.0
  expect_true(all(ped$birth[child] - ped$birth[sireRow] >= threeYears))
  expect_true(all(ped$birth[child] - ped$birth[damRow] >= threeYears))
})

test_that("sires are male and dams are female", {
  ped <- colony(10000L)
  expect_true(all(ped$sex[match(stats::na.omit(ped$sire), ped$id)] == "M"))
  expect_true(all(ped$sex[match(stats::na.omit(ped$dam), ped$id)] == "F"))
})

test_that("sex is M or F, and about half the animals are female", {
  ped <- colony(10000L)
  expect_true(all(ped$sex %in% c("M", "F")))
  share <- mean(ped$sex == "F")
  expect_gte(share, 0.4)
  expect_lte(share, 0.6)
})

test_that("a small share of animals have unknown parents", {
  share <- mean(is.na(colony(10000L)$sire))
  expect_gte(share, 0.01)
  expect_lte(share, 0.10)
})

test_that("importRate adds animals of unknown parentage", {
  none <- generateColonyPedigree(2000L, 3L, importRate = 0.0)
  many <- generateColonyPedigree(2000L, 3L, importRate = 0.05)
  expect_lt(sum(is.na(none$sire)), sum(is.na(many$sire)))
})

test_that("sires have many more offspring than dams, so half sibs abound", {
  ped <- colony(10000L)
  perSire <- mean(table(stats::na.omit(ped$sire)))
  perDam <- mean(table(stats::na.omit(ped$dam)))
  expect_gte(perSire, 3.0 * perDam)
})

test_that("generations overlap: some birth years hold 3 or more generations", {
  ped <- colony(10000L)
  g <- generationOf(ped)
  perYear <- tapply(g, format(ped$birth, "%Y"), function(x) length(unique(x)))
  expect_gte(max(perYear), 3L)
})

test_that("a 10,000-animal colony is at least 5 generations deep", {
  expect_gte(max(generationOf(colony(10000L))), 5L)
})

test_that("n below the founder count gives n founders", {
  ped <- generateColonyPedigree(5L, 1L)
  expect_identical(nrow(ped), 5L)
  expect_true(all(is.na(ped$sire) & is.na(ped$dam)))
})

test_that("a bad n is refused with a message naming n", {
  for (bad in list(0L, -1L, 2.5, NA_integer_, "10", c(5L, 6L), NULL)) {
    expect_error(generateColonyPedigree(bad, 1L), "n must be")
  }
})

test_that("a bad seed is refused with a message naming seed", {
  for (bad in list(NA_integer_, "a", c(1L, 2L), NULL)) {
    expect_error(generateColonyPedigree(10L, bad), "seed must be")
  }
})

test_that("a bad importRate is refused with a message naming importRate", {
  for (bad in list(-0.1, 1.0, NA_real_, "0.1", c(0.1, 0.2))) {
    expect_error(generateColonyPedigree(10L, 1L, importRate = bad),
                 "importRate must be")
  }
})
