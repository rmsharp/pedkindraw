## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_kinshipHasBothParentsHelp.R
## at nprcgenekeepr commit baef1e12c. Changes: the 5 tests that read the
## help of kinship() and hasBothParents() are left out (Mark's pick, S8),
## the source's lines 29-81: the helpCases list, "the readers find each
## function's help" and the loop that makes one test per help page and
## place ("the man page of kinship has the approved sentence only", and the
## same for its roxygen block and for hasBothParents). They need
## nprcgenekeepr's helper-pageText.R, and pedkindraw's help never held the
## old sentences. The comment below is kept whole: it explains the
## sentences the remaining tests keep true, and its last paragraph
## describes the left-out tests' page readers. hasBothParentsPed() reads
## the pedOne fixture (helper-fixtures.R) instead of nprcgenekeepr::pedOne
## (the source's line 144). The last test expects the 3 IDs' warning twice
## (two expect_warning() calls, the source's lines 159-162): hasBothParents()
## warns once for its sire column and once for its dam column, and testthat's
## edition 3, which pedkindraw uses, catches one warning per expect_warning()
## where nprcgenekeepr's edition 2 caught both (Mark's pick, S8: pedkindraw
## stays on edition 3, and nprcgenekeepr will move to it too).
##
## S990 (BACKLOG.md docs-audit part 2; S986 findings 1 and 8, flags MB3 and
## PD12): two help sentences say something the code does not do. The owner
## approved the replacement wording S986, the same in both places each time
## (the roxygen block and the regenerated man page).
##
## kinship(), argument chrtype: the help said "An individual with unrecognized
## sex gets NA kinship with everyone, including their own self-kinship
## value." With chrtype = "x" the code gives a founder of unrecognized sex NA
## only on its own diagonal cell and 0 with the other founders; only an
## animal of unrecognized sex that has parents gets NA with everyone. Both
## equal kinship2's vector kinship(id, dadid, momid, sex, chrtype = "x"),
## the function this one ports (checked S990, kinship2 1.9.6.2).
##
## hasBothParents(), argument id: the help said a vector of IDs "gives a
## recycling warning". The result is not one value per ID (`ped$id == id`
## recycles the IDs down the rows), and the warning appears only when the
## number of IDs does not divide the number of rows of ped.
##
## Each page is read whole, in the two places the help lives, and must hold the
## approved sentence exactly once and the old one nowhere; a sentence this long
## cannot be matched by accident (Learning 89). Both readers need the source
## tree (man/ and R/ do not exist under an installed package) and skip without
## it. The behavior locks at the end pass at HEAD: they keep the new sentences
## true.

## Behavior locks (green at HEAD, not the RED drivers). The kinship sentence is
## only true while the code gives an unknown-sex founder NA on its own
## diagonal cell alone, and an unknown-sex animal with parents NA with
## everyone. Each lock carries a guard expectation, so it cannot pass on a
## fixture that does not show the case.

## Founders A (M), B (F), C (unrecognized); D and E are known-sex children of
## A and B. C has no descendants. With `withUnknownChild`, F is an
## unrecognized-sex child of A and B.
xKinship <- function(withUnknownChild) {
  id <- c("A", "B", "C", "D", "E")
  sire <- c(NA, NA, NA, "A", "A")
  dam <- c(NA, NA, NA, "B", "B")
  depth <- c(0L, 0L, 0L, 1L, 1L)
  sex <- c("M", "F", "U", "F", "M")
  if (withUnknownChild) {
    id <- c(id, "F")
    sire <- c(sire, "A")
    dam <- c(dam, "B")
    depth <- c(depth, 1L)
    sex <- c(sex, "U")
  }
  list(
    id = id, sire = sire, dam = dam, depth = depth, sex = sex,
    kmat = as.matrix(kinship(id, sire, dam, depth, chrtype = "x", sex = sex))
  )
}

test_that("a founder of unrecognized sex is NA only on its own diagonal cell", {
  fixture <- xKinship(withUnknownChild = FALSE)
  row <- fixture$kmat["C", ]
  expect_identical(sum(is.na(row)), 1L)
  expect_true(is.na(row[["C"]]))
  expect_identical(unname(row[c("A", "B")]), c(0, 0))
  expect_identical(unname(fixture$kmat[c("A", "B"), "C"]), c(0, 0))
})

test_that("an animal of unrecognized sex with parents is NA with everyone", {
  fixture <- xKinship(withUnknownChild = TRUE)
  expect_identical(fixture$sex[fixture$id == "F"], "U")
  expect_identical(fixture$dam[fixture$id == "F"], "B")
  expect_true(all(is.na(fixture$kmat["F", ])))
  expect_true(all(is.na(fixture$kmat[, "F"])))
})

test_that("both unrecognized-sex cases equal kinship2's vector kinship()", {
  skip_if_not_installed("kinship2")
  for (withUnknownChild in c(FALSE, TRUE)) {
    fixture <- xKinship(withUnknownChild)
    kinship2Sex <- c(M = 1, F = 2, U = 3)[fixture$sex]
    theirs <- kinship2::kinship(
      fixture$id, fixture$sire, fixture$dam,
      sex = unname(kinship2Sex), chrtype = "x"
    )
    expect_equal(unname(fixture$kmat), unname(as.matrix(theirs)))
    expect_true(anyNA(fixture$kmat))
  }
})

## The hasBothParents() sentence is only true while the IDs recycle down the
## rows of ped: pedOne has 8 rows, so 2 IDs divide it and 3 do not.
hasBothParentsPed <- function() {
  ped <- pedOne
  names(ped) <- c("id", "sire", "dam", "sex", "birth")
  ped
}

test_that("a vector of IDs does not give one value per ID", {
  ped <- hasBothParentsPed()
  ids <- c(ped$id[2L], ped$id[1L])
  expect_identical(length(ids), 2L)
  expect_identical(hasBothParents(ids, ped), logical(0L))
})

test_that("a vector of IDs warns only when its length does not divide the rows", {
  ped <- hasBothParentsPed()
  expect_identical(nrow(ped), 8L)
  expect_warning(
    expect_warning(
      hasBothParents(ped$id[1L:3L], ped),
      "longer object length is not a multiple of shorter object length"
    ),
    "longer object length is not a multiple of shorter object length"
  )
  expect_warning(hasBothParents(ped$id[1L:2L], ped), NA)
  expect_warning(hasBothParents(ped$id[1L:4L], ped), NA)
})
