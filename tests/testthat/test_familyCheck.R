## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 12,
## rulings R43-R45, pedkindraw S15). familyCheck() compares the family ids it
## is given with the family trees the parent links form: per family id, its
## animals (n), those related to no other animal (unrelated), the trees they
## fall in (split) and the other family ids sharing those trees (join, counted
## once per shared tree, as kinship2's familycheck() counts). Every expected
## value was computed with kinship2 or a scratch prototype before this file
## was written (Learning 18). Helpers: helper-familyCheck.R.
library(testthat)

## Nine animals: A and B are the parents of C, D and E of F; G, H and I have
## no parent and no offspring. So {A, B, C} is family tree 1, {D, E, F} tree
## 2, and G, H and I are related to no one.
checkPed <- function() {
  list(id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
       sire = c(NA, NA, "A", NA, NA, "D", NA, NA, NA),
       dam = c(NA, NA, "B", NA, NA, "E", NA, NA, NA))
}

## familyCheck() on checkPed() with the family ids given.
checkPedFamilies <- function(famid, ...) {
  ped <- checkPed()
  familyCheck(famid, ped$id, ped$sire, ped$dam, ...)
}

## The data frame familyCheck() returns, from its columns.
familyFrame <- function(famid, n, unrelated, split, join) {
  data.frame(famid = famid, n = as.integer(n),
             unrelated = as.integer(unrelated), split = as.integer(split),
             join = as.integer(join), stringsAsFactors = FALSE)
}

test_that("familyCheck() gives split 1 and join 0, and no join table, when
  each family id holds one tree and the animals related to no one", {
  result <- checkPedFamilies(c("a", "a", "a", "b", "b", "b", "b", "c", "c"))
  expect_identical(result, familyFrame(c("a", "b", "c"), c(3, 4, 2),
                                       c(0, 1, 2), c(1, 1, 0), c(0, 0, 0)))
  expect_null(attr(result, "join"))
})

test_that("familyCheck() gives split 2 for a family id that holds two
  trees", {
  expect_identical(
    checkPedFamilies(c("a", "a", "a", "a", "a", "a", "b", "c", "c")),
    familyFrame(c("a", "b", "c"), c(6, 1, 2), c(0, 1, 2), c(2, 0, 0),
                c(0, 0, 0))
  )
})

test_that("familyCheck() reports a tree split between two family ids as a
  join, with a join table of each one's animals in that tree (kinship2's
  familycheck() stops on this case)", {
  result <- checkPedFamilies(c("a", "a", "x", "b", "b", "b", "b", "c", "c"))
  expected <- familyFrame(c("a", "b", "c", "x"), c(2, 4, 2, 1), c(0, 1, 2, 0),
                          c(1, 1, 0, 1), c(1, 0, 0, 1))
  attr(expected, "join") <- matrix(c(2L, 1L), ncol = 1L,
                                   dimnames = list(c("a", "x"), "1"))
  expect_identical(result, expected)
})

test_that("familyCheck() counts another family id once for each tree the
  two share, as kinship2's familycheck() does", {
  ## p, q and r each hold one animal of tree 1 and one of tree 2.
  result <- checkPedFamilies(c("p", "q", "r", "p", "q", "r", "s", "s", "s"))
  expected <- familyFrame(c("p", "q", "r", "s"), c(2, 2, 2, 3),
                          c(0, 0, 0, 3), c(2, 2, 2, 0), c(4, 4, 4, 0))
  attr(expected, "join") <- matrix(1L, nrow = 3L, ncol = 2L,
                                   dimnames = list(c("p", "q", "r"),
                                                   c("1", "2")))
  expect_identical(result, expected)
})

test_that("familyCheck()'s join table holds only the joined family ids and
  the trees their animals are in, not their animals related to no one", {
  ## Trees: {1, 2, 3} is 1, {4, 5, 6} is 2, {10, 11, 12} is 3; animal 7 is
  ## related to no one but has family id "a". Tree 3 is not joined.
  id <- c("1", "2", "3", "4", "5", "6", "7", "10", "11", "12")
  sire <- c(NA, NA, "1", NA, NA, "4", NA, NA, NA, "10")
  dam <- c(NA, NA, "2", NA, NA, "5", NA, NA, NA, "11")
  famid <- c("a", "a", "x", "b", "b", "z", "a", "c", "c", "c")
  expected <- familyFrame(c("a", "b", "c", "x", "z"), c(3, 2, 3, 1, 1),
                          c(1, 0, 0, 0, 0), c(1, 1, 1, 1, 1),
                          c(1, 1, 0, 1, 1))
  attr(expected, "join") <- matrix(c(2L, 0L, 1L, 0L, 0L, 2L, 0L, 1L),
                                   nrow = 4L,
                                   dimnames = list(c("a", "b", "x", "z"),
                                                   c("1", "2")))
  expect_identical(familyCheck(famid, id, sire, dam), expected)
})

test_that("familyCheck() sorts character family ids in byte order and
  numbers by value, keeping their type", {
  ## kinship2's familycheck() follows the locale (a A b B in en_US).
  expect_identical(
    checkPedFamilies(c("b", "b", "b", "B", "B", "B", "a", "A", "A"))$famid,
    c("A", "B", "a", "b")
  )
  expect_identical(
    checkPedFamilies(c(10, 10, 10, 9, 9, 9, 2, 2, 2)),
    familyFrame(c(2, 9, 10), c(3, 3, 3), c(3, 0, 0), c(0, 1, 1), c(0, 0, 0))
  )
})

test_that("familyCheck() returns factor family ids as character, with a row
  only for the ids present", {
  famid <- factor(c("b", "b", "b", "a", "a", "a", "a", "a", "a"),
                  levels = c("z", "b", "a"))
  expect_identical(checkPedFamilies(famid),
                   familyFrame(c("a", "b"), c(6, 3), c(3, 0), c(1, 1),
                               c(0, 0)))
})

test_that("familyCheck() links no one through a parent with no row, so NA,
  \"\" and \"0\" for an unknown parent give the same answer", {
  famid <- c("f", "f", "f", "g")
  id <- c("A", "B", "C", "D")
  expected <- familyFrame(c("f", "g"), c(3, 1), c(0, 1), c(1, 0), c(0, 0))
  expect_identical(familyCheck(famid, id, c(NA, NA, "A", NA),
                               c(NA, NA, "B", NA)), expected)
  expect_identical(familyCheck(famid, id, c("", "", "A", ""),
                               c("", "", "B", "")), expected)
  expect_identical(familyCheck(famid, id, c("0", "0", "A", "0"),
                               c("0", "0", "B", "0")), expected)
  ## Two animals whose only parent, Z, has no row are related to no one.
  expect_identical(familyCheck(c("f", "f"), c("C", "D"), c("Z", "Z"),
                               c(NA, NA)),
                   familyFrame("f", 2, 2, 0, 0))
})

test_that("familyCheck() links an animal with one known parent to that
  parent", {
  expect_identical(familyCheck(c("f", "f", "f"), c("A", "B", "C"),
                               c(NA, NA, "A"), c(NA, NA, NA)),
                   familyFrame("f", 3, 1, 1, 0))
})

test_that("familyCheck() does not stop on an animal that is its own
  ancestor or its own parent", {
  ## B's sire is C and C's dam is B.
  expect_identical(familyCheck(c("f", "f", "f"), c("A", "B", "C"),
                               c(NA, "C", NA), c(NA, NA, "B")),
                   familyFrame("f", 3, 1, 1, 0))
  ## A is its own sire, and so related to no other animal.
  expect_identical(familyCheck(c("f", "f"), c("A", "B"), c("A", NA),
                               c(NA, NA)),
                   familyFrame("f", 2, 2, 0, 0))
})

test_that("familyCheck() uses newfam as given instead of computing the
  trees", {
  ## The tree numbers are made up: A and B in tree 5, C and D in tree 9, the
  ## rest related to no one.
  expect_identical(
    checkPedFamilies(c("a", "a", "a", "a", "b", "b", "b", "b", "b"),
                     newfam = c(5, 5, 9, 9, 0, 0, 0, 0, 0)),
    familyFrame(c("a", "b"), c(4, 5), c(0, 5), c(2, 0), c(0, 0))
  )
})

test_that("familyCheck() returns zero rows and no join table for empty
  input (kinship2's familycheck() stops)", {
  result <- familyCheck(character(0L), character(0L), character(0L),
                        character(0L))
  expect_identical(result, familyFrame(character(0L), integer(0L),
                                       integer(0L), integer(0L),
                                       integer(0L)))
  expect_null(attr(result, "join"))
})

test_that("familyCheck() stops on unequal lengths, a missing family id, a
  missing or repeated id, and a newfam of the wrong length or with NA", {
  ped <- checkPed()
  famid <- c("a", "a", "a", "b", "b", "b", "b", "c", "c")
  lengths <- "famid, id, sire and dam must have the same length"
  expect_error(familyCheck(famid[-1L], ped$id, ped$sire, ped$dam), lengths,
               fixed = TRUE)
  expect_error(familyCheck(famid, ped$id[-1L], ped$sire, ped$dam), lengths,
               fixed = TRUE)
  expect_error(familyCheck(famid, ped$id, ped$sire[-1L], ped$dam), lengths,
               fixed = TRUE)
  expect_error(familyCheck(famid, ped$id, ped$sire, ped$dam[-1L]), lengths,
               fixed = TRUE)
  expect_error(familyCheck(replace(famid, 2L, NA), ped$id, ped$sire, ped$dam),
               "No famid may be missing", fixed = TRUE)
  expect_error(familyCheck(famid, replace(ped$id, 9L, NA), ped$sire, ped$dam),
               "No id may be missing", fixed = TRUE)
  expect_error(familyCheck(famid, replace(ped$id, 9L, "A"), ped$sire,
                           ped$dam),
               "No id may appear twice", fixed = TRUE)
  expect_error(familyCheck(famid, ped$id, ped$sire, ped$dam, newfam = 1:3),
               "newfam must be as long as id", fixed = TRUE)
  expect_error(familyCheck(famid, ped$id, ped$sire, ped$dam,
                           newfam = c(NA, 0, 0, 0, 0, 0, 0, 0, 0)),
               "No newfam may be missing", fixed = TRUE)
})

test_that("familyCheck() gives kinship2's familycheck() answer on the
  fixture pedigrees, wherever kinship2 returns", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (ped in familyCheckPedigrees()) {
    for (famid in familyCheckPatterns(ped)) {
      expected <- kinship2FamilyCheck(famid, ped$id, ped$sire, ped$dam)
      if (is.null(expected)) next
      expect_identical(
        normalizedFamilyCheck(familyCheck(famid, ped$id, ped$sire, ped$dam)),
        expected
      )
      compared <- compared + 1L
    }
  }
  ## kinship2 returned in 68 of the 99 cases when this test was written; it
  ## stopped in the rest, each with every join in one tree.
  expect_gte(compared, 68L)
})

test_that("familyCheck() gives kinship2's familycheck() answer on seeded
  random families, wherever kinship2 returns", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (seed in 1:200) {
    case <- familyCheckRandomCase(seed)
    expected <- kinship2FamilyCheck(case$famid, case$id, case$sire, case$dam)
    if (is.null(expected)) next
    expect_identical(
      normalizedFamilyCheck(familyCheck(case$famid, case$id, case$sire,
                                        case$dam)),
      expected
    )
    compared <- compared + 1L
  }
  ## kinship2 returned in 97 of the 200 cases when this test was written.
  expect_gte(compared, 97L)
})

test_that("familyCheck() numbers the trees as kinship2's makefamid() does,
  so passing makefamid()'s numbers as newfam changes nothing", {
  skip_if_not_installed("kinship2")
  for (ped in familyCheckPedigrees()) {
    trees <- kinship2::makefamid(ped$id, ped$sire, ped$dam)
    for (famid in familyCheckPatterns(ped)) {
      expect_identical(
        familyCheck(famid, ped$id, ped$sire, ped$dam, newfam = trees),
        familyCheck(famid, ped$id, ped$sire, ped$dam)
      )
    }
  }
})
