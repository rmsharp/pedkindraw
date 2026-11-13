## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 13,
## rulings R49-R51, pedkindraw S17). checkPedigree() lists the problems in a
## pedigree, one row per problem id, and never repairs them. Every expected
## value was computed with a scratch prototype before this file was written
## (Learning 18). Helpers: helper-checkPedigree.R.
library(testthat)

## The expected result: a data frame of three character columns.
checkRows <- function(check = character(0L), id = character(0L),
                      detail = character(0L)) {
  data.frame(check = check, id = id, detail = detail,
             stringsAsFactors = FALSE)
}

test_that("checkPedigree() returns zero rows of three character columns for a
  pedigree without problems", {
  ped <- data.frame(id = c("s1", "d1", "o1"), sire = c(NA, NA, "s1"),
                    dam = c(NA, NA, "d1"), sex = c("M", "F", "U"))
  expect_identical(checkPedigree(ped), checkRows())
  expect_identical(checkPedigree(ped[0L, ]), checkRows())
})

test_that("checkPedigree() reports every check, in the order of the checks,
  and an animal under each check it fails", {
  ped <- data.frame(
    id = c(NA, "a", "a", "b", "c", "d", "e", "f", "g"),
    sire = c(NA, NA, NA, "b", "d", NA, "zz", "e", "a"),
    dam = c(NA, NA, NA, NA, NA, "c", "0", "b", NA),
    sex = c("M", "F", "F", "M", "F", "M", "U", "female", "H")
  )
  expect_identical(checkPedigree(ped), checkRows(
    check = c("missingIds", "duplicateIds", "ownParent", "cycle", "cycle",
              "rowlessParents", "missingParentCodes", "maleDams",
              "femaleSires", "unknownSexParents", "sireAndDam", "sexCodes"),
    id = c(NA, "a", "b", "c", "d", "zz", "0", "b", "a", "e", "b", "f"),
    detail = c("row 1", "rows 2, 3", "its own sire",
               "its own ancestor through d", "its own ancestor through c",
               "sire of e", "dam of e", "sire of b; dam of f", "sire of g",
               "sire of f",
               "sire of b; dam of f", "sex \"female\" in row 8")
  ))
})

test_that("checkPedigree() reports each id that is NA, empty or spaces only,
  one row per input row", {
  ped <- data.frame(id = c("a", NA, "", "b", " "), sire = NA, dam = NA)
  expect_identical(checkPedigree(ped), checkRows(
    check = rep("missingIds", 3L), id = c(NA, "", " "),
    detail = c("row 2", "row 3", "row 5")
  ))
})

test_that("checkPedigree() reports each duplicated id once, with its rows, ids
  in byte order", {
  ped <- data.frame(id = c("b", "a", "c", "a", "b", "a"), sire = NA,
                    dam = NA)
  expect_identical(checkPedigree(ped), checkRows(
    check = rep("duplicateIds", 2L), id = c("a", "b"),
    detail = c("rows 2, 4, 6", "rows 1, 5")
  ))
})

test_that("checkPedigree() reports an animal that is its own sire, dam or
  both; one used as both is also a sire and a dam", {
  ped <- data.frame(id = c("A", "B", "C"), sire = c("A", NA, "C"),
                    dam = c(NA, "B", "C"))
  expect_identical(checkPedigree(ped), checkRows(
    check = c("ownParent", "ownParent", "ownParent", "sireAndDam"),
    id = c("A", "B", "C", "C"),
    detail = c("its own sire", "its own dam", "its own sire and dam",
               "sire of C; dam of C")
  ))
})

test_that("checkPedigree() reports each animal that is its own ancestor
  through another animal, naming the others in its cycle", {
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F"),
    sire = c("C", "A", "B", "A", NA, NA),
    dam = c(NA, NA, NA, NA, "F", "E")
  )
  expect_identical(checkPedigree(ped), checkRows(
    check = rep("cycle", 5L), id = c("A", "B", "C", "E", "F"),
    detail = c("its own ancestor through B, C",
               "its own ancestor through A, C",
               "its own ancestor through A, B",
               "its own ancestor through F", "its own ancestor through E")
  ))
})

test_that("checkPedigree() reports each parent with no row once, with its
  offspring", {
  ped <- data.frame(id = c("A", "B"), sire = c("S1", "S1"),
                    dam = c("D1", NA))
  expect_identical(checkPedigree(ped), checkRows(
    check = rep("rowlessParents", 2L), id = c("D1", "S1"),
    detail = c("dam of A", "sire of A, B")
  ))
})

test_that("checkPedigree() reports \"0\", \"NA\", empty and spaces-only
  parents as codes, not as parents with no row or as sire and dam", {
  ped <- data.frame(id = c("A", "B", "C", "D"),
                    sire = c("0", "", " ", "NA"),
                    dam = c("0", "", NA, "NA"))
  expect_identical(checkPedigree(ped), checkRows(
    check = rep("missingParentCodes", 4L), id = c("", " ", "0", "NA"),
    detail = c("sire of B; dam of B", "sire of C", "sire of A; dam of A",
               "sire of D; dam of D")
  ))
})

test_that("checkPedigree() counts a code that has a row of its own as a real
  parent", {
  ped <- data.frame(id = c("0", "A"), sire = c(NA, "0"), dam = NA)
  expect_identical(checkPedigree(ped), checkRows())
})

test_that("checkPedigree() reads number ids as text, so 0 for an unknown
  parent is a code", {
  ped <- data.frame(id = c(1L, 2L, 3L), sire = c(0L, 0L, 1L),
                    dam = c(0L, 0L, 2L))
  expect_identical(checkPedigree(ped), checkRows(
    check = "missingParentCodes", id = "0",
    detail = "sire of 1, 2; dam of 1, 2"
  ))
})

test_that("checkPedigree() reports male dams, female sires and parents of
  unknown sex (U or NA), but not a hermaphrodite parent or a non-parent of
  unknown sex", {
  ped <- data.frame(
    id = c("s1", "d1", "s2", "d2", "s3", "o1", "o2", "o3", "o4"),
    sire = c(NA, NA, NA, NA, NA, "s1", "s2", "s3", "s1"),
    dam = c(NA, NA, NA, NA, NA, "d1", "d2", "d1", "d2"),
    sex = c("F", "M", "U", NA, "H", "M", "F", "U", "F")
  )
  expect_identical(checkPedigree(ped), checkRows(
    check = c("maleDams", "femaleSires", "unknownSexParents",
              "unknownSexParents"),
    id = c("d1", "s1", "d2", "s2"),
    detail = c("dam of o1, o3", "sire of o1, o4", "dam of o2, o4",
               "sire of o2")
  ))
})

test_that("checkPedigree() takes a parent's sex from its first row", {
  ped <- data.frame(id = c("d1", "d1", "o1"), sire = NA,
                    dam = c(NA, NA, "d1"), sex = c("M", "F", "F"))
  expect_identical(checkPedigree(ped), checkRows(
    check = c("duplicateIds", "maleDams"), id = c("d1", "d1"),
    detail = c("rows 1, 2", "dam of o1")
  ))
})

test_that("checkPedigree() runs no sex check without a sex column", {
  ped <- data.frame(id = c("a", "b", "c"), sire = c(NA, NA, "a"),
                    dam = c(NA, NA, "b"))
  expect_identical(checkPedigree(ped), checkRows())
})

test_that("checkPedigree() reports an id used both as a sire and as a dam,
  with or without a row", {
  ped <- data.frame(id = c("x", "A", "B", "C"),
                    sire = c(NA, "x", "y", "y"), dam = c(NA, "z", "x", "y"))
  expect_identical(checkPedigree(ped), checkRows(
    check = c("rowlessParents", "rowlessParents", "sireAndDam",
              "sireAndDam"),
    id = c("y", "z", "x", "y"),
    detail = c("sire of B, C; dam of C", "dam of A", "sire of A; dam of B",
               "sire of B, C; dam of C")
  ))
})

test_that("checkPedigree() reports each sex that is not M, F, H, U or NA, one
  row per input row, and no other sex check for it", {
  ped <- data.frame(id = c("a", "b", "c", "d", "e"),
                    sire = c(NA, NA, "a", NA, NA), dam = c(NA, NA, "b", NA, NA),
                    sex = c("male", "F", "f", NA, "U"))
  expect_identical(checkPedigree(ped), checkRows(
    check = c("sexCodes", "sexCodes"), id = c("a", "c"),
    detail = c("sex \"male\" in row 1", "sex \"f\" in row 3")
  ))
})

test_that("checkPedigree() lists ten offspring at most, then a count", {
  kids <- sprintf("o%02d", 1L:12L)
  ped <- data.frame(id = kids, sire = "s", dam = NA)
  expect_identical(checkPedigree(ped), checkRows(
    check = "rowlessParents", id = "s",
    detail = paste0("sire of ", toString(kids[1L:10L]), " and 2 more")
  ))
})

test_that("checkPedigree() reads factor columns by their labels", {
  ped <- data.frame(id = c("s1", "d1", "o1"), sire = c(NA, NA, "s1"),
                    dam = c(NA, NA, "d1"), sex = c("F", "M", "U"))
  asFactors <- as.data.frame(lapply(ped, factor))
  expected <- checkRows(check = c("maleDams", "femaleSires"),
                        id = c("d1", "s1"),
                        detail = c("dam of o1", "sire of o1"))
  expect_identical(checkPedigree(ped), expected)
  expect_identical(checkPedigree(asFactors), expected)
})

test_that("checkPedigree() stops when ped is not a data frame or lacks id,
  sire or dam, naming the missing columns", {
  expect_error(checkPedigree(list(id = "a", sire = NA, dam = NA)),
               "data frame")
  expect_error(checkPedigree(cbind(id = "a", sire = NA, dam = NA)),
               "data frame")
  expect_error(checkPedigree(NULL), "data frame")
  expect_error(checkPedigree(data.frame(id = "a", sire = NA)), "dam")
  expect_error(checkPedigree(data.frame(ID = "a", Sire = NA, dam = NA)),
               "id, sire")
})

test_that("checkPedigree() finds no problem in seven of the fixture
  pedigrees, and pedOne's and pedSix's", {
  firstThree <- function(p) {
    names(p)[1L:3L] <- c("id", "sire", "dam")
    p
  }
  for (ped in list(lacy1989Ped, smallPed, qcPed, pedWithGenotype,
                   rhesusPedigree, qcdRhesusPed(), examplePedigree)) {
    expect_identical(checkPedigree(ped), checkRows())
  }
  expect_identical(checkPedigree(firstThree(pedOne)), checkRows(
    check = c("maleDams", "femaleSires"), id = c("d1", "s1"),
    detail = c("dam of o1", "sire of o1, o2")
  ))
  ## pedSix's sex column is named Sex, so no sex check runs.
  expect_identical(checkPedigree(firstThree(pedSix)), checkRows(
    check = rep("rowlessParents", 4L), id = c("d0", "d4", "s0", "s4"),
    detail = c("dam of d1", "dam of s2", "sire of d1", "sire of s2")
  ))
})

test_that("checkPedigree() reports kinship2's sample.ped coding of an unknown
  parent as 0", {
  skip_if_not_installed("kinship2")
  sp <- get(utils::data("sample.ped", package = "kinship2",
                        envir = environment()))
  ped <- data.frame(id = sp$id, sire = sp$father, dam = sp$mother,
                    sex = c("M", "F")[sp$sex])
  result <- checkPedigree(ped)
  expect_identical(result$check, "missingParentCodes")
  expect_identical(result$id, "0")
})

test_that("checkPedigree() finds no parent problem after addParents() and
  correctParentSex() repair them", {
  ped <- data.frame(id = c("s1", "d1", "o1", "o2", "o3"),
                    sire = c(NA, NA, "s1", "s1", "s9"),
                    dam = c(NA, NA, "d1", "d1", "d9"),
                    sex = c("F", "M", "F", "M", "F"))
  expect_identical(checkPedigree(ped), checkRows(
    check = c("rowlessParents", "rowlessParents", "maleDams", "femaleSires"),
    id = c("d9", "s9", "d1", "s1"),
    detail = c("dam of o3", "sire of o3", "dam of o1, o2", "sire of o1, o2")
  ))
  repaired <- addParents(ped)
  repaired$sex <- correctParentSex(repaired$id, repaired$sire, repaired$dam,
                                   repaired$sex, repaired$recordStatus)
  expect_identical(checkPedigree(repaired), checkRows())
})

test_that("checkPedigree() gives the slow checker's checks and ids on 300
  seeded random pedigrees", {
  for (seed in 1L:300L) {
    ped <- checkPedigreeRandomCase(seed)$ped
    expect_identical(checkPedigree(ped)[, c("check", "id")],
                     checkPedigreeSlow(ped), info = paste("seed", seed))
  }
})

test_that("checkPedigree() names the problem wherever kinship2's pedigree()
  refuses, and none it refuses wherever it accepts", {
  skip_if_not_installed("kinship2")
  expected <- list(
    duplicateIds = "duplicateIds",
    notFemale = c("maleDams", "unknownSexParents", "sireAndDam"),
    notMale = c("femaleSires", "unknownSexParents"),
    notFound = c("rowlessParents", "missingParentCodes"),
    missingIds = "missingIds"
  )
  refused <- c("missingIds", "duplicateIds", "rowlessParents", "maleDams",
               "femaleSires", "unknownSexParents", "sireAndDam")
  compared <- 0L
  for (seed in 1L:300L) {
    ped <- checkPedigreeRandomCase(seed)$ped
    answer <- kinship2CheckAnswer(ped)
    ## Set aside: one known parent (legal here), an H parent (legal here) and
    ## a sex outside M, F, H, U (this file gives kinship2 "unknown" for it).
    if (answer == "oneParent" ||
          any(ped$sex %in% "H" & ped$id %in% c(ped$sire, ped$dam)) ||
          any(!is.na(ped$sex) & !(ped$sex %in% c("M", "F", "H", "U")))) {
      next
    }
    result <- checkPedigree(ped)
    if (answer == "accepted") {
      expect_false(any(result$check %in% refused |
                         (result$check == "missingParentCodes" &
                            result$id != "")), info = paste("seed", seed))
    } else {
      expect_true(any(result$check %in% expected[[answer]]),
                  info = paste("seed", seed, answer))
    }
    compared <- compared + 1L
  }
  ## 224 of the 300 were compared when this test was written (154 refusals,
  ## 70 acceptances), all agreeing.
  expect_gte(compared, 220L)
})
