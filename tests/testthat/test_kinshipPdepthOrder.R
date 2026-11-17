## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17c1,
## ruling R92, pedkindraw S35). kinship() fills each animal from its sire and
## dam generation by generation, in pdepth's order, so it stops when a known
## parent's pdepth is not below its offspring's. Before R92, kinship2's call
## form kinship(id, dadid, momid, sex) gave a wrong matrix with no error:
## wrong in 425 of minnbreast's 426 families. Every expected value was
## computed with a scratch copy of the check before this file was written
## (Learning 18).
library(testthat)

## The message kinship() stops with: animal `id`, at pdepth `depth`, has a
## `role` ("sire" or "dam"), `parent`, at pdepth `parentDepth`.
lateParentMessage <- function(id, depth, role, parent, parentDepth) {
  paste0("pdepth must be greater for each animal than for its sire and dam: ",
         id, " has ", depth, " and its ", role, " ", parent, " has ",
         parentDepth, " (pdepth is the 4th argument, generation numbers ",
         "such as findGeneration() gives, not sex)")
}

## Three animals: A and B are the sire and dam of C.
trioKinship <- function(pdepth, sire = c(NA, NA, "A"), ...) {
  kinship(c("A", "B", "C"), sire, c(NA, NA, "B"), pdepth, ...)
}

test_that("kinship() stops when a dam's pdepth equals its offspring's", {
  expect_error(trioKinship(c(0L, 1L, 1L)),
               lateParentMessage("C", 1, "dam", "B", 1), fixed = TRUE)
})

test_that("kinship() stops when a sire's pdepth is above its offspring's", {
  expect_error(trioKinship(c(2L, 0L, 1L)),
               lateParentMessage("C", 1, "sire", "A", 2), fixed = TRUE)
})

test_that("kinship() names the sire when both parents are out of order", {
  expect_error(trioKinship(c(1L, 1L, 1L)),
               lateParentMessage("C", 1, "sire", "A", 1), fixed = TRUE)
})

test_that("kinship() names the first animal in id's order that is out of
  order", {
  id <- c("A", "B", "C", "D")
  sire <- c(NA, NA, "A", "A")
  dam <- c(NA, NA, "B", "B")
  expect_error(kinship(id, sire, dam, c(0L, 0L, 0L, 0L)),
               lateParentMessage("C", 0, "sire", "A", 0), fixed = TRUE)
  expect_error(kinship(id, sire, dam, c(0L, 0L, 1L, 0L)),
               lateParentMessage("D", 0, "sire", "A", 0), fixed = TRUE)
})

test_that("kinship() stops an animal listed as its own sire", {
  expect_error(trioKinship(c(0L, 0L, 1L), sire = c("A", NA, "A")),
               lateParentMessage("A", 0, "sire", "A", 0), fixed = TRUE)
})

test_that("kinship() stops generation numbers out of order on the X
  chromosome, as a sparse matrix and as numbers that are not integers", {
  message <- lateParentMessage("C", 1, "dam", "B", 1)
  expect_error(trioKinship(c(0L, 1L, 1L), chrtype = "x",
                           sex = c("M", "F", "F")), message, fixed = TRUE)
  expect_error(trioKinship(c(0L, 1L, 1L), sparse = TRUE), message,
               fixed = TRUE)
  expect_error(trioKinship(c(0, 1, 1)), message, fixed = TRUE)
})

test_that("kinship() takes generation numbers with a gap, founders all at 0,
  a parent not in id, and identical twins at one depth", {
  expect_identical(trioKinship(c(0L, 0L, 2L)), trioKinship(c(0L, 0L, 1L)))
  expect_identical(kinship(c("A", "B", "C"), rep(NA, 3L), rep(NA, 3L),
                           c(0L, 0L, 0L)),
                   matrix(c(0.5, 0, 0, 0, 0.5, 0, 0, 0, 0.5), 3L,
                          dimnames = list(c("A", "B", "C"),
                                          c("A", "B", "C"))))
  ## A sire that is not in id is unknown, as before R92.
  expect_identical(trioKinship(c(0L, 0L, 1L), sire = c(NA, NA, "X")),
                   trioKinship(c(0L, 0L, 1L), sire = c(NA, NA, NA)))
  twins <- data.frame(id1 = "t1", id2 = "t2", code = "MZ twin")
  kmat <- kinship(c("s", "d", "t1", "t2"), c(NA, NA, "s", "s"),
                  c(NA, NA, "d", "d"), c(0L, 0L, 1L, 1L),
                  twinRelations = twins)
  expect_identical(kmat[["t1", "t2"]], 0.5)
})

test_that("kinship()'s other input checks still come first", {
  late <- c(1L, 1L, 1L)
  expect_error(kinship(c("A", "A", "C"), c(NA, NA, "A"), c(NA, NA, "B"),
                       late),
               "All id values must be unique", fixed = TRUE)
  expect_error(trioKinship(c(NA, 1L, 1L)),
               "pdepth must not be missing for any animal", fixed = TRUE)
  expect_error(trioKinship(late, chrtype = "x"), "invalid sex vector",
               fixed = TRUE)
  expect_error(trioKinship(late, twinRelations = data.frame(
    id1 = "Z", id2 = "A", code = "MZ twin"
  )), "All twinRelations id1/id2 values must be present in id.", fixed = TRUE)
})

## kinship2's sample.ped (2 families) or minnbreast (426), one list per
## family: the ids, sires and dams as text, a 0 parent unknown, and sex in
## kinship2's codes (1 male, 2 female, 3 unknown: minnbreast's missing sex).
kinship2Families <- function(name) {
  d <- get(utils::data(list = name, package = "kinship2",
                       envir = environment()))
  if (identical(name, "minnbreast")) {
    sex <- match(d$sex, c("M", "F"))
    sex[is.na(sex)] <- 3L
    d <- data.frame(ped = d$famid, id = d$id, father = d$fatherid,
                    mother = d$motherid, sex = sex)
  }
  lapply(split(d, d$ped), function(f) {
    list(id = as.character(f$id),
         sire = ifelse(f$father == 0, NA, as.character(f$father)),
         dam = ifelse(f$mother == 0, NA, as.character(f$mother)),
         sex = f$sex)
  })
}

test_that("kinship() stops kinship2's call form kinship(id, dadid, momid,
  sex) in every family of sample.ped and minnbreast, and takes
  findGeneration()'s numbers in every one", {
  skip_if_not_installed("kinship2")
  for (name in c("sample.ped", "minnbreast")) {
    families <- kinship2Families(name)
    expect_length(families, c(sample.ped = 2L, minnbreast = 426L)[[name]])
    stopped <- vapply(families, function(f) {
      message <- tryCatch({
        kinship(f$id, f$sire, f$dam, f$sex)
        ""
      }, error = conditionMessage)
      startsWith(message, "pdepth must be greater for each animal")
    }, NA)
    expect_identical(sum(stopped), length(families))
    taken <- vapply(families, function(f) {
      is.matrix(kinship(f$id, f$sire, f$dam,
                        findGeneration(f$id, f$sire, f$dam)))
    }, NA)
    expect_identical(sum(taken), length(families))
  }
})
