## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 12,
## rulings R46-R48, pedkindraw S16). ibdMatrix() turns pairs of ids and their
## IBD values, as programs such as SOLAR write them, into a symmetric sparse
## matrix (kinship2's class, a dsCMatrix) with a row and a column per id.
## Every expected value was computed with kinship2 or a scratch prototype
## before this file was written (Learning 18). Helpers: helper-ibdMatrix.R.
library(testthat)

test_that("ibdMatrix() returns a dsCMatrix, the upper triangle stored, with a
  row and a column named for each id", {
  result <- ibdMatrix(c("a", "a", "b"), c("a", "b", "b"), c(1, 0.5, 1))
  expect_s4_class(result, "dsCMatrix")
  expect_identical(result@uplo, "U")
  expect_identical(result,
                   ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("a", "b"))))
})

test_that("ibdMatrix() gives the same matrix for a pair given either way
  round, and keeps a pair given twice with one value once", {
  expected <- ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("a", "b")))
  expect_identical(ibdMatrix(c("a", "b", "b"), c("a", "a", "b"),
                             c(1, 0.5, 1)), expected)
  expect_identical(ibdMatrix(c("a", "a", "b", "b"), c("a", "b", "b", "a"),
                             c(1, 0.5, 1, 0.5)), expected)
  expect_identical(ibdMatrix(c("a", "a", "b", "a"), c("a", "b", "b", "b"),
                             c(1, 0.5, 1, 0.5)), expected)
})

test_that("ibdMatrix() sorts number ids by value and character ids in byte
  order", {
  expect_identical(
    ibdMatrix(c(10, 9, 100, 9), c(10, 9, 100, 100), c(1, 1, 1, 0.25)),
    ibdExpected(ibdBase(c(1, 0, 0.25, 0, 1, 0, 0.25, 0, 1),
                        c("9", "10", "100")))
  )
  expect_identical(ibdMatrix(c(10L, 2L), c(10L, 2L), c(1, 1)),
                   ibdExpected(ibdBase(c(1, 0, 0, 1), c("2", "10"))))
  ids <- c("b", "B", "a", "A", "9", "10")
  expect_identical(
    ibdMatrix(ids, ids, rep(1, 6)),
    ibdExpected(ibdBase(diag(6), c("10", "9", "A", "B", "a", "b")))
  )
  ## Number ids mixed with character ones are character ids.
  expect_identical(
    ibdMatrix(c(9, 10, 9), c("9", "10", "10"), c(1, 1, 0.5)),
    ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("10", "9")))
  )
})

test_that("ibdMatrix() adds no row for a number between the ids given", {
  ## kinship2 gives these ids a 3 x 3 matrix with an empty row for 2.
  expect_identical(
    ibdMatrix(c(1, 1, 3), c(1, 3, 3), c(1, 0.5, 1)),
    ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("1", "3")))
  )
})

test_that("ibdMatrix() reads factor ids as character", {
  expected <- ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("a", "b")))
  expect_identical(
    ibdMatrix(factor(c("b", "b", "a"), levels = c("b", "a")),
              factor(c("b", "a", "a")), c(1, 0.5, 1)),
    expected
  )
})

test_that("ibdMatrix() takes a three-column data frame or matrix as id1", {
  expected <- ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("a", "b")))
  table <- data.frame(id1 = c("a", "a", "b"), id2 = c("a", "b", "b"),
                      x = c(1, 0.5, 1))
  expect_identical(ibdMatrix(table), expected)
  expect_identical(ibdMatrix(data.frame(table, stringsAsFactors = TRUE)),
                   expected)
  expect_identical(
    ibdMatrix(cbind(c(1, 1, 2), c(1, 2, 2), c(1, 0.5, 1))),
    ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("1", "2")))
  )
})

test_that("ibdMatrix() names the rows from idmap, kept in the order of the
  internal ids", {
  id1 <- c(1, 1, 2, 3, 3, 4)
  id2 <- c(1, 2, 2, 3, 4, 4)
  x <- c(1, 0.5, 1, 1, 0.25, 1)
  names <- c("M12", "F3", "M7", "F10")
  expected <- ibdExpected(ibdBase(c(1, 0.5, 0, 0, 0.5, 1, 0, 0,
                                    0, 0, 1, 0.25, 0, 0, 0.25, 1), names))
  expect_identical(
    ibdMatrix(id1, id2, x, idmap = data.frame(internal = 1:4,
                                              original = names)),
    expected
  )
  expect_identical(
    ibdMatrix(id1, id2, x, idmap = cbind(c("1", "2", "3", "4"), names)),
    expected
  )
  expect_identical(
    ibdMatrix(id1, id2, x,
              idmap = data.frame(internal = 1:4, original = names,
                                 stringsAsFactors = TRUE)),
    expected
  )
  ## An idmap id not in the pairs adds no row.
  expect_identical(
    ibdMatrix(id1, id2, x,
              idmap = data.frame(internal = 6:1,
                                 original = c("X", "Y", rev(names)))),
    expected
  )
  ## Internal ids 2 and 10 keep their order by value, whatever their names.
  expect_identical(
    ibdMatrix(c(10, 2), c(10, 2), c(1, 1),
              idmap = data.frame(internal = c(10, 2), original = c("A", "Z"))),
    ibdExpected(ibdBase(c(1, 0, 0, 1), c("Z", "A")))
  )
})

test_that("ibdMatrix() fills only the missing diagonal entries from
  diagonal", {
  expect_identical(
    ibdMatrix(c("a", "a"), c("a", "b"), c(0.9, 0.5), diagonal = 1),
    ibdExpected(ibdBase(c(0.9, 0.5, 0.5, 1), c("a", "b")))
  )
  expect_identical(
    ibdMatrix(c("a", "a"), c("a", "b"), c(1, 0.5), diagonal = 0),
    ibdExpected(ibdBase(c(1, 0.5, 0.5, 0), c("a", "b")))
  )
  expect_identical(
    ibdMatrix(c("a", "a", "b"), c("a", "b", "b"), c(1, 0.5, 1),
              diagonal = 0.5),
    ibdExpected(ibdBase(c(1, 0.5, 0.5, 1), c("a", "b")))
  )
})

test_that("ibdMatrix() does not store a 0 and keeps other values as
  given", {
  result <- ibdMatrix(c(1, 1, 2, 3, 2), c(1, 2, 2, 3, 3),
                      c(1, 0, 1.5, 1, -0.5))
  expect_identical(
    result,
    ibdExpected(ibdBase(c(1, 0, 0, 0, 1.5, -0.5, 0, -0.5, 1),
                        c("1", "2", "3")))
  )
  expect_length(result@x, 4L)
  expect_identical(ibdMatrix(c(1, 1, 2), c(1, 2, 2), c(1L, 0L, 1L)),
                   ibdExpected(ibdBase(c(1, 0, 0, 1), c("1", "2"))))
})

test_that("ibdMatrix() gives a 0 x 0 dsCMatrix for empty input", {
  expected <- ibdExpected(matrix(numeric(0), 0L, 0L))
  expect_identical(ibdMatrix(character(0), character(0), numeric(0)),
                   expected)
  expect_identical(ibdMatrix(numeric(0), numeric(0), numeric(0)), expected)
  expect_identical(
    ibdMatrix(data.frame(id1 = character(0), id2 = character(0),
                         x = numeric(0))),
    expected
  )
})

test_that("ibdMatrix() stops, naming the ids, when an id has no diagonal
  value and diagonal is not given", {
  expect_error(ibdMatrix(c("a", "a"), c("a", "b"), c(1, 0.5)),
               paste("Ids with no diagonal value: b. Give diagonal, for",
                     "example diagonal = 1"),
               fixed = TRUE)
  ## kinship2 never returned on this input.
  expect_error(ibdMatrix(c(1, 2), c(2, 3), c(0.5, 0.5)),
               "Ids with no diagonal value: 1, 2, 3.", fixed = TRUE)
  ids <- sprintf("i%02d", 1:12)
  expect_error(ibdMatrix(ids, c(ids[-1], ids[1]), rep(0.5, 12)),
               paste("Ids with no diagonal value: i01, i02, i03, i04, i05,",
                     "i06, i07, i08, i09, i10, and 2 more."),
               fixed = TRUE)
})

test_that("ibdMatrix() stops on vectors of unequal length", {
  message <- "id1, id2 and x must have the same length"
  expect_error(ibdMatrix(c(1, 1, 2), c(1, 2), c(1, 0.5, 1)), message,
               fixed = TRUE)
  expect_error(ibdMatrix(c(1, 1, 2), c(1, 2, 2), c(1, 0.5)), message,
               fixed = TRUE)
})

test_that("ibdMatrix() stops when one pair is given two different values", {
  expect_error(ibdMatrix(c("a", "a", "b", "b"), c("a", "b", "b", "a"),
                         c(1, 0.5, 1, 0.3)),
               "Pairs given two different values: (a, b).", fixed = TRUE)
  expect_error(ibdMatrix(c("a", "a", "b", "a", "a"), c("a", "b", "b", "b", "a"),
                         c(1, 0.5, 1, 0.3, 0.8)),
               "Pairs given two different values: (a, b), (a, a).",
               fixed = TRUE)
})

test_that("ibdMatrix() stops on a missing id and on a value that is missing,
  not finite or not a number", {
  expect_error(ibdMatrix(c(1, NA, 2), c(1, 2, 2), c(1, 0.5, 1)),
               "No id may be missing", fixed = TRUE)
  expect_error(ibdMatrix(c(1, 1, 2), c(1, NA, 2), c(1, 0.5, 1)),
               "No id may be missing", fixed = TRUE)
  message <- "x must be finite numbers"
  for (x in list(c(1, NA, 1), c(1, NaN, 1), c(1, Inf, 1),
                 c("1", "0.5", "1"), c(TRUE, TRUE, TRUE))) {
    expect_error(ibdMatrix(c(1, 1, 2), c(1, 2, 2), x), message, fixed = TRUE)
  }
})

test_that("ibdMatrix() stops on a table without 3 columns or with id2 or x
  also given, and when id2 or x is missing", {
  expect_error(ibdMatrix(data.frame(a = c(1, 2), b = c(1, 2))),
               "A table given as id1 must have 3 columns", fixed = TRUE)
  expect_error(ibdMatrix(cbind(1, 1, 1, 0)),
               "A table given as id1 must have 3 columns", fixed = TRUE)
  table <- data.frame(id1 = 1, id2 = 1, x = 1)
  expect_error(ibdMatrix(table, 1),
               "Give id2 and x only when id1 is not a table", fixed = TRUE)
  expect_error(ibdMatrix(table, x = 1),
               "Give id2 and x only when id1 is not a table", fixed = TRUE)
  message <- "Give id2 and x, or a table with 3 columns as id1"
  expect_error(ibdMatrix(c(1, 2)), message, fixed = TRUE)
  expect_error(ibdMatrix(c(1, 2), c(1, 2)), message, fixed = TRUE)
})

test_that("ibdMatrix() stops on a malformed idmap", {
  id1 <- c(1, 1, 2)
  id2 <- c(1, 2, 2)
  x <- c(1, 0.5, 1)
  message <- "idmap must be a matrix or data frame with 2 columns"
  for (idmap in list(cbind(1:2), data.frame(1:2, 1:2, 1:2),
                     list(1:2, c("A", "B")), c("A", "B"))) {
    expect_error(ibdMatrix(id1, id2, x, idmap = idmap), message, fixed = TRUE)
  }
  expect_error(ibdMatrix(id1, id2, x,
                         idmap = data.frame(c(1, NA), c("A", "B"))),
               "No idmap entry may be missing", fixed = TRUE)
  expect_error(ibdMatrix(id1, id2, x,
                         idmap = data.frame(1:2, c("A", NA))),
               "No idmap entry may be missing", fixed = TRUE)
  expect_error(ibdMatrix(id1, id2, x,
                         idmap = data.frame(c(1, 1, 2), c("A", "B", "C"))),
               "No id may appear twice in idmap's first column", fixed = TRUE)
  expect_error(ibdMatrix(id1, id2, x,
                         idmap = data.frame(1:2, c("A", "A"))),
               "No name may appear twice in idmap's second column",
               fixed = TRUE)
  expect_error(ibdMatrix(c(1, 2, 3), c(1, 2, 3), c(1, 1, 1),
                         idmap = data.frame(1, "A")),
               "Ids not in idmap: 2, 3.", fixed = TRUE)
})

test_that("ibdMatrix() stops on a diagonal that is not one finite number", {
  message <- "diagonal must be one finite number"
  for (diagonal in list(NA, NA_real_, Inf, "1", c(1, 1), numeric(0),
                        TRUE)) {
    expect_error(ibdMatrix("a", "b", 0.5, diagonal = diagonal), message,
                 fixed = TRUE)
  }
})

test_that("ibdMatrix() gives kinship2's ibdMatrix() values at every id on
  seeded random cases with every diagonal value, wherever kinship2
  returns", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (seed in 1:80) {
    case <- ibdRandomCase(seed, "fullDiag")
    result <- as.matrix(ibdOnCase(case))
    expected <- kinship2IbdOnCase(case)
    if (is.null(expected)) next
    ids <- rownames(result)
    ## kinship2's rows for numbers between the ids given are empty.
    added <- setdiff(rownames(expected), ids)
    expect_true(all(expected[added, ] == 0))
    expect_identical(result, expected[ids, ids, drop = FALSE])
    compared <- compared + 1L
  }
  ## kinship2 returned in 77 of the 80 cases when this test was written; in
  ## the other 3 it stopped on an error of its own.
  expect_gte(compared, 77L)
})

test_that("ibdMatrix() gives kinship2's ibdMatrix() values at every id on
  seeded random cases with diagonal given, wherever kinship2 returns", {
  skip_if_not_installed("kinship2")
  compared <- 0L
  for (seed in 1:80) {
    case <- ibdRandomCase(seed, "withDiagonal")
    result <- as.matrix(ibdOnCase(case))
    expected <- kinship2IbdOnCase(case)
    if (is.null(expected)) next
    ids <- rownames(result)
    added <- setdiff(rownames(expected), ids)
    expect_true(all(expected[added, ] == 0))
    expect_identical(result, expected[ids, ids, drop = FALSE])
    compared <- compared + 1L
  }
  ## kinship2 returned in 76 of the 80 cases when this test was written; in
  ## the other 4 it stopped on an error of its own.
  expect_gte(compared, 76L)
})
