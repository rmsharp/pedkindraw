## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G5, gap
## C4, rulings R114-R116, pedkindraw S46). recodePedigree() rewrites other
## codes for an unknown parent and for sex into pedkindraw's (NA; "M", "F",
## "H", "U"). Every expected value was computed with a scratch prototype
## before this file was written (Learning 18), and nprcgenekeepr's
## convertSexCodes() (at its 071b0f568), kinship2 and Pedixplorer were read
## on the same values there.
library(testthat)

## The gap case inputCodes (tools/gapCases.R): A and B, founders, with
## offspring C and D, the unknown parents written "0".
fourWithZeros <- function(sex = c("M", "F", "M", "F")) {
  data.frame(id = c("A", "B", "C", "D"), sire = c("0", "0", "A", "A"),
             dam = c("0", "0", "B", "B"), sex = sex,
             stringsAsFactors = FALSE)
}

## One row per sex value, every animal a founder.
sexOnly <- function(sex) {
  data.frame(id = paste0("a", seq_along(sex)), sire = NA, dam = NA,
             sex = sex, stringsAsFactors = FALSE)
}

test_that("recodePedigree() turns the gap case's \"0\" parents into NA, after
  which checkPedigree() reports nothing and findGeneration() places all four", {
  ped <- recodePedigree(fourWithZeros())
  expect_identical(ped$sire, c(NA, NA, "A", "A"))
  expect_identical(ped$dam, c(NA, NA, "B", "B"))
  expect_identical(checkPedigree(fourWithZeros())$check, "missingParentCodes")
  expect_identical(nrow(checkPedigree(ped)), 0L)
  expect_identical(findGeneration(ped$id, ped$sire, ped$dam),
                   c(0L, 0L, 1L, 1L))
})

test_that("recodePedigree() reads the gap case's four ways of writing sex, after
  which the layout draws squares and circles, no diamond", {
  for (written in list(c(1L, 2L, 1L, 2L), c("1", "2", "1", "2"),
                       c("male", "female", "male", "female"),
                       c("m", "f", "m", "f"))) {
    ped <- recodePedigree(fourWithZeros(written))
    expect_identical(ped$sex, c("M", "F", "M", "F"))
    expect_identical(nrow(checkPedigree(ped)), 0L)
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    layout <- makePedigreeMatingLayout(ped)
    expect_identical(layout$nodes$shape[match(ped$id, layout$nodes$id)],
                     c("square", "dot", "square", "dot"))
  }
})

test_that("recodePedigree() turns \"0\", \"NA\", empty and spaces-only parents
  into NA by default, the codes checkPedigree() reports", {
  ped <- data.frame(id = c("A", "B", "C", "D"),
                    sire = c("0", "", " ", "NA"),
                    dam = c("0", "", NA, "NA"))
  expect_identical(checkPedigree(ped)$id, c("", " ", "0", "NA"))
  recoded <- recodePedigree(ped)
  expect_identical(recoded$sire, rep(NA_character_, 4L))
  expect_identical(recoded$dam, rep(NA_character_, 4L))
  expect_identical(nrow(checkPedigree(recoded)), 0L)
})

test_that("recodePedigree() keeps a code that is the id of a row as a real
  parent, as checkPedigree() reads it", {
  ped <- data.frame(id = c("0", "NA", "A", "B"), sire = c(NA, NA, "0", "0"),
                    dam = c("", NA, "NA", "NA"))
  recoded <- recodePedigree(ped)
  expect_identical(recoded$sire, c(NA, NA, "0", "0"))
  expect_identical(recoded$dam, c(NA, NA, "NA", "NA"))
  expect_identical(nrow(checkPedigree(recoded)), 0L)
})

test_that("recodePedigree() turns into NA the parent codes named in
  missingParentCodes, and no others", {
  ped <- data.frame(id = c("A", "B", "C"), sire = c("-1", "0", "A"),
                    dam = c("-1", " ", "B"))
  expect_identical(recodePedigree(ped)$sire, c("-1", NA, "A"))
  expect_identical(recodePedigree(ped)$dam, c("-1", NA, "B"))
  recoded <- recodePedigree(ped, missingParentCodes = "-1")
  expect_identical(recoded$sire, c(NA, "0", "A"))
  expect_identical(recoded$dam, c(NA, " ", "B"))
  recoded <- recodePedigree(ped, missingParentCodes = c("-1", ""))
  expect_identical(recoded$dam, c(NA_character_, NA_character_, "B"))
  expect_identical(recodePedigree(ped, missingParentCodes = character(0L)),
                   ped)
})

test_that("recodePedigree() keeps each parent column's type: numbers stay
  numbers, factors stay factors, and a data.table stays one", {
  ped <- data.frame(id = 1L:3L, sire = c(0L, 0L, 1L), dam = c(0L, 0L, 2L))
  recoded <- recodePedigree(ped)
  expect_identical(recoded$sire, c(NA, NA, 1L))
  expect_identical(recoded$dam, c(NA, NA, 2L))
  ped <- data.frame(id = factor(c("A", "B", "C")),
                    sire = factor(c("0", "0", "A")),
                    dam = factor(c("", "0", "B")))
  recoded <- recodePedigree(ped)
  expect_s3_class(recoded$sire, "factor")
  expect_identical(as.character(recoded$sire), c(NA, NA, "A"))
  expect_identical(as.character(recoded$dam), c(NA, NA, "B"))
  recoded <- recodePedigree(data.table::as.data.table(fourWithZeros()))
  expect_s3_class(recoded, "data.table")
  expect_identical(recoded$sire, c(NA, NA, "A", "A"))
})

test_that("recodePedigree() writes each sex it knows as its code, ignoring case
  and spaces around it, a blank as NA, and leaves every other value", {
  written <- c("M", "F", "H", "U", NA, "", " ", "m", "f", "h", "u", "male",
               "Male", "FEMALE", " male ", "unknown", "Hermaphrodite", "1",
               "2", "3", "4", " 2 ", "terminated", "man", "woman", "mael",
               "X", "0", "NA")
  expect_identical(recodePedigree(sexOnly(written))$sex, c(
    "M", "F", "H", "U", NA, NA, NA, "M", "F", "H", "U", "M", "M", "F", "M",
    "U", "H", "M", "F", "U", "U", "F", "terminated", "man", "woman", "mael",
    "X", "0", "NA"
  ))
  expect_identical(recodePedigree(sexOnly(c(1L, 2L, 3L, 4L, 0L, NA)))$sex,
                   c("M", "F", "U", "U", "0", NA))
  expect_identical(recodePedigree(sexOnly(c(1, 2, 3, 4)))$sex,
                   c("M", "F", "U", "U"))
})

test_that("recodePedigree() reads sex as nprcgenekeepr's convertSexCodes()
  does, except H, NA, blanks and values neither knows, which it keeps", {
  ## convertSexCodes(x), its default ignoreHerm = TRUE, at nprcgenekeepr's
  ## 071b0f568, read in a scratch run.
  both <- c("M", "F", "U", "m", "f", "u", "male", "Male", "FEMALE", " male ",
            "unknown", "1", "2", "3", "4")
  convertSexCodesReads <- c("M", "F", "U", "M", "F", "U", "M", "M", "F", "M",
                            "U", "M", "F", "U", "U")
  expect_identical(recodePedigree(sexOnly(both))$sex, convertSexCodesReads)
  ## convertSexCodes() makes each of these "U".
  kept <- c("H", "h", "hermaphrodite", NA, "", " ", "mael", "X")
  expect_identical(recodePedigree(sexOnly(kept))$sex,
                   c("H", "H", "H", NA, NA, NA, "mael", "X"))
})

test_that("recodePedigree() leaves a sex it does not know for checkPedigree()
  to report", {
  ped <- recodePedigree(fourWithZeros(c("male", "female", "mael", "X")))
  expect_identical(checkPedigree(ped)$check, c("sexCodes", "sexCodes"))
  expect_identical(checkPedigree(ped)$id, c("C", "D"))
})

test_that("recodePedigree() rewrites a factor sex column's levels, merging
  levels that become one code, and keeps it a factor", {
  ped <- sexOnly(factor(c("male", "m", "", "F", "x", NA, "female")))
  recoded <- recodePedigree(ped)$sex
  expect_s3_class(recoded, "factor")
  expect_identical(levels(recoded), c("F", "M", "x"))
  expect_identical(as.character(recoded), c("M", "M", NA, "F", "x", NA, "F"))
  ped <- sexOnly(factor(c("F", "M"), levels = c("F", "M", "H", "U")))
  expect_identical(recodePedigree(ped), ped)
})

test_that("recodePedigree() changes only sire, dam and sex, and adds no sex
  column", {
  ped <- data.frame(id = c("A", "B", "C"), sire = c("0", "0", "A"),
                    dam = c("0", "0", "B"), sex = c("1", "2", "1"),
                    birth = as.Date(c("2001-01-01", "2002-02-02", NA)),
                    affected = c(TRUE, FALSE, NA), row.names = c("r", "s", "t"),
                    stringsAsFactors = FALSE)
  recoded <- recodePedigree(ped)
  expect_identical(names(recoded), names(ped))
  expect_identical(rownames(recoded), c("r", "s", "t"))
  expect_identical(recoded[c("id", "birth", "affected")],
                   ped[c("id", "birth", "affected")])
  noSex <- recodePedigree(ped[c("id", "sire", "dam")])
  expect_identical(names(noSex), c("id", "sire", "dam"))
})

test_that("recodePedigree() returns a pedigree already in pedkindraw's codes as
  it was, the fixture pedigrees among them, and its own result unchanged", {
  for (ped in list(lacy1989Ped, smallPed, qcPed, pedWithGenotype,
                   rhesusPedigree, qcdRhesusPed(), examplePedigree)) {
    expect_identical(recodePedigree(ped), ped)
  }
  once <- recodePedigree(fourWithZeros(c("male", "f", "", "mael")))
  expect_identical(recodePedigree(once), once)
  empty <- fourWithZeros()[0L, ]
  expect_identical(recodePedigree(empty), empty)
})

test_that("recodePedigree() makes kinship2's sample.ped and testped1, written
  with 0 for an unknown parent and 1/2 for sex, give kinship2's kinship", {
  skip_if_not_installed("kinship2")
  for (name in c("sample.ped", "testped1")) {
    k2 <- get(utils::data(list = name, package = "kinship2",
                          envir = environment()))
    ped <- recodePedigree(data.frame(id = k2$id, sire = k2$father,
                                     dam = k2$mother, sex = k2$sex))
    expect_identical(nrow(checkPedigree(ped)), 0L)
    gen <- findGeneration(ped$id, ped$sire, ped$dam)
    expect_false(anyNA(gen))
    expected <- kinship2::kinship(kinship2::pedigree(
      k2$id, k2$father, k2$mother, k2$sex, missid = 0L
    ))
    computed <- kinship(ped$id, ped$sire, ped$dam, gen)
    expect_identical(sort(rownames(computed)), sort(rownames(expected)))
    expect_identical(max(abs(computed[rownames(expected), colnames(expected)] -
                               expected)), 0)
  }
})

test_that("recodePedigree() makes kinship2's minnbreast, 28,081 animals, a
  pedigree checkPedigree() finds no problem in", {
  skip_if_not_installed("kinship2")
  mb <- get(utils::data("minnbreast", package = "kinship2",
                        envir = environment()))
  ped <- data.frame(id = mb$id, sire = mb$fatherid, dam = mb$motherid,
                    sex = mb$sex)
  expect_identical(checkPedigree(ped)$check, "missingParentCodes")
  recoded <- recodePedigree(ped)
  expect_identical(nrow(checkPedigree(recoded)), 0L)
  expect_identical(sum(is.na(recoded$sire)), 12721L)
  expect_identical(sum(is.na(recoded$sex)), 1761L)
})

test_that("recodePedigree() reads Pedixplorer's sampleped's sex, written 1, 2
  and 3, as Pedixplorer reads it", {
  skip_if_not_installed("Pedixplorer")
  sp <- get(utils::data("sampleped", package = "Pedixplorer",
                        envir = environment()))
  ped <- recodePedigree(data.frame(id = sp$id, sire = sp$dadid,
                                   dam = sp$momid, sex = sp$sex))
  pedixplorer <- as.character(Pedixplorer::sex_to_factor(sp$sex))
  expect_identical(ped$sex, unname(c(male = "M", female = "F",
                                     unknown = "U")[pedixplorer]))
  expect_identical(nrow(checkPedigree(ped)), 0L)
})

test_that("recodePedigree() stops when ped is not a pedigree data frame or
  missingParentCodes is not text without NA", {
  expect_error(recodePedigree(list(id = "a", sire = NA, dam = NA)),
               "recodePedigree: ped must be a data frame")
  expect_error(recodePedigree(data.frame(id = "a", sire = NA)),
               "recodePedigree: ped lacks the column\\(s\\) dam")
  for (codes in list(0L, NA_character_, c("0", NA), factor("0"), NULL)) {
    expect_error(recodePedigree(fourWithZeros(), missingParentCodes = codes),
                 "recodePedigree: missingParentCodes must be a character")
  }
})
