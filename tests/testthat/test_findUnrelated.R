## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 13,
## rulings R52-R54, pedkindraw S18). findUnrelated() picks genotyped animals
## with kinship 0 between every two, to which no genotyped animal can be added
## and in which no chosen animal can be traded for two, the same set every
## time. Every expected value was computed with a scratch prototype before this
## file was written (Learning 18). Helpers: helper-findUnrelated.R (and
## checkPedigreeClean() in helper-checkPedigree.R).
library(testthat)

## A pedigree of the given ids, every parent unknown unless given.
founders <- function(id, sire = NA, dam = NA) {
  data.frame(id = id, sire = sire, dam = dam, stringsAsFactors = FALSE)
}

test_that("findUnrelated() returns character(0) when no animal is
  genotyped", {
  ped <- founders(c("a", "b"))
  expect_identical(findUnrelated(ped, c(FALSE, FALSE)), character(0L))
  expect_identical(findUnrelated(ped[0L, ], logical(0L)), character(0L))
})

test_that("findUnrelated() keeps every genotyped animal when none is related
  to another, in byte order", {
  ped <- founders(c("b", "B", "a", "A1", "c"))
  expect_identical(findUnrelated(ped, c(TRUE, TRUE, TRUE, TRUE, FALSE)),
                   c("A1", "B", "a", "b"))
})

test_that("findUnrelated() returns only genotyped animals, none related to
  another", {
  ## s1 and d1 are the parents of the full sibs o1 and o2; f1 is unrelated.
  ped <- data.frame(id = c("s1", "d1", "o1", "o2", "f1"),
                    sire = c(NA, NA, "s1", "s1", NA),
                    dam = c(NA, NA, "d1", "d1", NA))
  ## f1 has no relative and goes first; s1 and d1 then have 3 relatives
  ## (themselves counted) against 4 for o1 and o2, d1 goes by byte order and
  ## takes o1 and o2 with it, and s1 is left.
  expect_identical(findUnrelated(ped, rep(TRUE, 5L)), c("d1", "f1", "s1"))
  expect_identical(findUnrelated(ped, c(FALSE, FALSE, TRUE, TRUE, TRUE)),
                   c("f1", "o1"))
})

test_that("findUnrelated() takes the animal with the fewest relatives first,
  whatever its id", {
  ## a shares f1 with b and f2 with c; b and c are unrelated. a has the most
  ## relatives, so b and c are chosen although a comes first in byte order.
  ped <- data.frame(id = c("f1", "f2", "f3", "f4", "a", "b", "c"),
                    sire = c(NA, NA, NA, NA, "f1", "f1", "f4"),
                    dam = c(NA, NA, NA, NA, "f2", "f3", "f2"))
  expect_identical(findUnrelated(ped, ped$id %in% c("a", "b", "c")),
                   c("b", "c"))
})

test_that("findUnrelated() breaks a tie in relatives by byte order", {
  ## The full sibs b and B have one relative each, each other.
  ped <- data.frame(id = c("s", "d", "b", "B"), sire = c(NA, NA, "s", "s"),
                    dam = c(NA, NA, "d", "d"))
  expect_identical(findUnrelated(ped, c(FALSE, FALSE, TRUE, TRUE)), "B")
})

test_that("findUnrelated() counts relatives again after each pick", {
  ## a is related only to its offspring r and goes first, taking r out. r was
  ## related to b, d and e (half sibs through f2), not to c, so at the start
  ## c had 4 relatives and b, d and e 5; after the pick b, c, d and e have 4
  ## each and b goes by byte order. Counted only once, c would be chosen.
  ped <- data.frame(
    id = c("a", "f2", "f3", "f4", "r", "b", "c", "d", "e"),
    sire = c(NA, NA, NA, NA, "a", "f3", "f3", "f3", "f3"),
    dam = c(NA, NA, NA, NA, "f2", "f2", "f4", "f2", "f2")
  )
  genotyped <- ped$id %in% c("a", "r", "b", "c", "d", "e")
  expect_identical(findUnrelated(ped, genotyped), c("a", "b"))
})

test_that("findUnrelated() trades one chosen animal for two unrelated ones
  where it can", {
  ## v (fewest relatives: u and w) is picked first, then x; the swap pass then
  ## puts u and w, each related to v and to no other chosen animal and not to
  ## each other, in v's place. y1-y3, the offspring of m and x, are related to
  ## u, w and x through m's parents and x.
  ped <- data.frame(
    id = c("f1", "f2", "f3", "f4", "x", "m", "u", "v", "w", "y1", "y2", "y3"),
    sire = c(NA, NA, NA, NA, NA, "f4", "f1", "f1", "f4", "m", "m", "m"),
    dam = c(NA, NA, NA, NA, NA, "f3", "f3", "f2", "f2", "x", "x", "x")
  )
  genotyped <- ped$id %in% c("x", "u", "v", "w", "y1", "y2", "y3")
  expect_identical(findUnrelated(ped, genotyped), c("u", "w", "x"))
  expect_true(all(findUnrelatedSlow(ped, genotyped, c("u", "w", "x"))))
  expect_false(findUnrelatedSlow(ped, genotyped, c("v", "x"))[["noTrade"]])
})

test_that("findUnrelated() gives the same set whatever the row order", {
  r <- findUnrelatedRhesus()
  expected <- findUnrelated(r$ped, r$genotyped)
  for (seed in 1L:5L) {
    rows <- withr::with_seed(seed, sample(nrow(r$ped)))
    expect_identical(findUnrelated(r$ped[rows, ], r$genotyped[rows]),
                     expected, info = paste("seed", seed))
  }
})

test_that("findUnrelated() gives 44 animals on the comparison's rhesus
  pedigree with 30 percent genotyped, as kinship2 and Pedixplorer do", {
  r <- findUnrelatedRhesus()
  result <- findUnrelated(r$ped, r$genotyped)
  expect_identical(result, c(
    "0FKJ81", "0Q077X", "36W7XS", "3XP1ZD", "4CHDK1", "4F3ASD", "5GQC24",
    "6S4HCB", "79RXRZ", "7U5H8G", "8933XB", "8DKELJ", "8P17E3", "97Y192",
    "A3A34I", "AE08C8", "B948B1", "C2YD43", "CMJQGU", "D0Z114", "DLZL49",
    "FG9RYY", "G2DMVF", "GQUCRY", "HKTQ40", "IP1TGT", "KCBMY9", "LVP52A",
    "MK90CB", "N2JRUE", "PLT00S", "QWUKUY", "RXPJPP", "SH0L6S", "SLN0TF",
    "SNHNX6", "SQ908D", "TTE0Z7", "UWJKEQ", "WDUGSA", "WUPTU8", "X20HK8",
    "X6TGUV", "ZZ646X"
  ))
  expect_true(all(findUnrelatedSlow(r$ped, r$genotyped, result)))
})

test_that("findUnrelated() gives 4 and 2 animals on kinship2's sample.ped
  families 1 and 2 with their own avail, as kinship2 and Pedixplorer do", {
  skip_if_not_installed("kinship2")
  one <- kinship2SampleFamily(1L)
  two <- kinship2SampleFamily(2L)
  expect_identical(findUnrelated(one$ped, one$genotyped),
                   c("109", "110", "113", "116"))
  expect_identical(findUnrelated(two$ped, two$genotyped), c("201", "203"))
})

test_that("findUnrelated() does not read sex", {
  ## d1 is a male dam and s1 a female sire; the four founders are unrelated.
  ped <- pedOne
  names(ped)[1L:4L] <- c("id", "sire", "dam", "sex")
  expected <- c("d1", "d2", "s1", "s2")
  expect_identical(findUnrelated(ped, rep(TRUE, 8L)), expected)
  expect_identical(findUnrelated(ped[c("id", "sire", "dam")], rep(TRUE, 8L)),
                   expected)
  ped$sex <- c("male", NA, "U", "H", "F", "F", "F", "M")
  expect_identical(findUnrelated(ped, rep(TRUE, 8L)), expected)
})

test_that("findUnrelated() accepts one known parent", {
  ## o's sire s is known and its dam is not: s and o are related.
  ped <- data.frame(id = c("s", "o", "f"), sire = c(NA, "s", NA),
                    dam = c(NA, NA, NA))
  expect_identical(findUnrelated(ped, rep(TRUE, 3L)), c("f", "o"))
  ## smallPed's A has only a sire.
  result <- findUnrelated(smallPed, rep(TRUE, nrow(smallPed)))
  expect_identical(result, c("A", "B", "E", "J", "K", "N", "O"))
  expect_true(all(findUnrelatedSlow(smallPed, rep(TRUE, nrow(smallPed)),
                                    result)))
})

test_that("findUnrelated() reads a parent value that is an id of a row as
  that animal, even \"0\", and reads factors and numbers as text", {
  ## "0" has a row, so a and b are half sibs.
  ped <- data.frame(id = c("0", "a", "b"), sire = c(NA, "0", "0"),
                    dam = c(NA, NA, NA))
  expect_identical(findUnrelated(ped, c(FALSE, TRUE, TRUE)), "a")
  numbers <- data.frame(id = c(10L, 2L, 3L), sire = c(NA, 10L, NA),
                        dam = NA_integer_)
  ## 2 is 10's offspring and 3 is unrelated: 10 and 2 tie, and "10" comes
  ## before "2" in byte order.
  expect_identical(findUnrelated(numbers, rep(TRUE, 3L)), c("10", "3"))
  asFactors <- as.data.frame(lapply(numbers, factor))
  expect_identical(findUnrelated(asFactors, rep(TRUE, 3L)), c("10", "3"))
})

test_that("findUnrelated() stops when ped is not a data frame or lacks id,
  sire or dam, naming the missing columns", {
  expect_error(findUnrelated(list(id = "a", sire = NA, dam = NA), TRUE),
               "data frame")
  expect_error(findUnrelated(cbind(id = "a", sire = NA, dam = NA), TRUE),
               "data frame")
  expect_error(findUnrelated(NULL, TRUE), "data frame")
  expect_error(findUnrelated(data.frame(id = "a", sire = NA), TRUE), "dam")
  expect_error(findUnrelated(data.frame(ID = "a", Sire = NA, dam = NA), TRUE),
               "id, sire")
})

test_that("findUnrelated() stops when genotyped is not logical, not one value
  per row, or has an NA", {
  ped <- founders(c("a", "b", "c"))
  expect_error(findUnrelated(ped, c(1L, 0L, 1L)), "TRUE or FALSE")
  expect_error(findUnrelated(ped, c("TRUE", "FALSE", "TRUE")),
               "TRUE or FALSE")
  expect_error(findUnrelated(ped, NULL), "TRUE or FALSE")
  expect_error(findUnrelated(ped, c(TRUE, FALSE)),
               "genotyped has 2 value(s) for the 3 row(s) of ped",
               fixed = TRUE)
  expect_error(findUnrelated(ped, c(TRUE, NA, NA)),
               "genotyped is NA in row(s) 2, 3", fixed = TRUE)
})

test_that("findUnrelated() stops on each problem that leaves relatedness
  undefined, naming the animals", {
  stopsOn <- function(ped, text) {
    expect_error(findUnrelated(ped, rep(TRUE, nrow(ped))), text,
                 fixed = TRUE)
  }
  stopsOn(founders(c("a", NA, " ")), "missingIds: row 2, row 3")
  stopsOn(founders(c("a", "b", "a")), "duplicateIds: a")
  stopsOn(founders(c("a", "b"), sire = c("a", NA)), "ownParent: a")
  stopsOn(data.frame(id = c("c", "d", "e"), sire = c("d", "c", "c"),
                     dam = NA), "cycle: c, d")
  stopsOn(founders(c("a", "b"), sire = c(NA, "zz")), "rowlessParents: zz")
  stopsOn(founders(c("a", "b"), sire = c(NA, "zz")),
          "addParents() adds a row for each parent that has none")
  stopsOn(founders(c("a", "b"), sire = c("0", "0"), dam = c("", "")),
          "missingParentCodes: \"\", \"0\"")
  ## Several problems are listed in checkPedigree()'s order in one message.
  stopsOn(data.frame(id = c("a", "a", "b"), sire = c(NA, NA, "zz"),
                     dam = c(NA, NA, "b")),
          paste("checkPedigree() reports duplicateIds: a; ownParent: b;",
                "rowlessParents: zz"))
})

test_that("findUnrelated() stops on pedSix's four parents with no row and
  runs once addParents() adds them", {
  ped <- pedSix
  names(ped)[1L:4L] <- c("id", "sire", "dam", "sex")
  expect_error(findUnrelated(ped, rep(TRUE, nrow(ped))),
               "rowlessParents: d0, d4, s0, s4", fixed = TRUE)
  repaired <- addParents(ped)
  genotyped <- repaired$id %in% ped$id
  result <- findUnrelated(repaired, genotyped)
  expect_true(all(findUnrelatedSlow(repaired, genotyped, result)))
})

test_that("findUnrelated() passes the slow check on 300 seeded random
  pedigrees", {
  for (seed in 1L:300L) {
    case <- findUnrelatedRandomCase(seed)
    result <- findUnrelated(case$ped, case$genotyped)
    expect_identical(findUnrelatedSlow(case$ped, case$genotyped, result),
                     c(genotyped = TRUE, unrelated = TRUE, maximal = TRUE,
                       noTrade = TRUE), info = paste("seed", seed))
  }
})

test_that("findUnrelated() chooses at least as many animals as kinship2's
  pedigree.unrelated() on the seeded random pedigrees", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (seed in 1L:300L) {
    case <- findUnrelatedRandomCase(seed)
    theirs <- kinship2Unrelated(case$ped, case$genotyped, seed)
    if (is.null(theirs)) {
      next
    }
    expect_gte(length(findUnrelated(case$ped, case$genotyped)),
               length(theirs))
    compared <- compared + 1L
  }
  ## kinship2 1.9.6.2 returned on all 300 when this test was written.
  expect_gte(compared, 290L)
})
