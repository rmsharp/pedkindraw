## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G6, gap
## C5, pedkindraw S47). countOffspring() counts each animal's offspring: the
## animals naming it as sire or dam, each once. Every expected value was
## computed with a scratch prototype before this file was written (Learning
## 18), and Pedixplorer 1.8.0's num_child() and nprcgenekeepr's
## findOffspring() (at its 3e06730c5) were read on the same pedigrees there.
## The pedigrees and slow versions are in helper-offspringAndMatings.R.
library(testthat)

test_that("countOffspring() gives the gap case's counts 2, 2, 0, 0", {
  expect_identical(countOffspring(lookupsPed()),
                   c(A = 2L, B = 2L, C = 0L, D = 0L))
})

test_that("countOffspring() counts offspring as sire and as dam, the other
  parent known or not", {
  expect_identical(countOffspring(halfSibsPed()),
                   c(A = 3L, B = 2L, E = 2L, K = 1L, C = 0L, F = 0L, G = 0L,
                     H = 0L, I = 0L))
})

test_that("countOffspring() counts the ids asked for, in their order, an id
  with no offspring or no row getting 0", {
  ped <- halfSibsPed()
  expect_identical(countOffspring(ped, c("K", "A", "Z", "C")),
                   c(K = 1L, A = 3L, Z = 0L, C = 0L))
  expect_identical(countOffspring(ped, c("A", NA)),
                   stats::setNames(c(3L, 0L), c("A", NA)))
  expect_identical(countOffspring(ped, character(0L)),
                   stats::setNames(integer(0L), character(0L)))
})

test_that("countOffspring() counts a parent that has no row of its own when
  asked, and lists only the rows' ids by default", {
  ped <- halfSibsPed()
  ped$sire[ped$id == "H"] <- "Z"
  expect_identical(countOffspring(ped, "Z"), c(Z = 1L))
  expect_identical(names(countOffspring(ped)), ped$id)
})

test_that("countOffspring() counts each offspring once", {
  ## A row listed twice.
  ped <- lookupsPed()
  expect_identical(countOffspring(ped[c(1L, 2L, 3L, 3L, 4L), ], "A"),
                   c(A = 2L))
  ## An animal recorded as both the sire and the dam of one offspring.
  selfed <- data.frame(id = c("X", "C"), sire = c(NA, "X"), dam = c(NA, "X"),
                       stringsAsFactors = FALSE)
  expect_identical(countOffspring(selfed), c(X = 1L, C = 0L))
})

test_that("countOffspring() counts an animal recorded as both a sire and a
  dam for its offspring of both kinds", {
  ## Pedixplorer's num_child_dir and nprcgenekeepr's findOffspring() count
  ## one kind here, 1 each.
  expect_identical(countOffspring(sireAndDamPed()),
                   c(X = 2L, Y = 2L, P = 0L, Q = 0L))
})

test_that("countOffspring() reads factor and number columns as their text", {
  ped <- halfSibsPed()
  asFactors <- data.frame(lapply(ped, factor))
  expect_identical(countOffspring(asFactors), countOffspring(ped))
  expect_identical(countOffspring(asFactors, factor("A")), c(A = 3L))
  numbered <- data.frame(id = 1:4, sire = c(NA, NA, 1L, 1L),
                         dam = c(NA, NA, 2L, 2L))
  expect_identical(countOffspring(numbered),
                   c(`1` = 2L, `2` = 2L, `3` = 0L, `4` = 0L))
  expect_identical(countOffspring(numbered, 2), c(`2` = 2L))
})

test_that("countOffspring() gives an empty count for a pedigree with no rows", {
  expect_identical(countOffspring(lookupsPed()[0L, ]),
                   stats::setNames(integer(0L), character(0L)))
})

test_that("each count is the number of animals getOffspring() lists, on every
  fixture pedigree and 100 seeded random ones", {
  for (name in names(matingFixturePeds())) {
    ped <- matingFixturePeds()[[name]]
    expect_identical(countOffspring(ped),
                     countOffspringSlow(ped, ped$id), info = name)
  }
  withr::with_seed(47L, {
    for (k in seq_len(100L)) {
      ped <- randomMatingPed(sample(3:150, 1L))
      expect_identical(countOffspring(ped), countOffspringSlow(ped, ped$id),
                       info = k)
    }
  })
})

test_that("countOffspring() equals Pedixplorer's num_child_dir on every
  pedigree compared that has a mating", {
  skip_if_not_installed("Pedixplorer")
  peds <- matingFixturePeds()
  withr::with_seed(47L, {
    for (k in seq_len(100L)) {
      peds[[paste0("random", k)]] <- randomMatingPed(sample(3:150, 1L))
    }
  })
  peds$lookups <- lookupsPed()
  peds$halfSibs <- halfSibsPed()
  compared <- 0L
  for (name in names(peds)) {
    ped <- peds[[name]]
    if (nrow(getMatings(ped)) == 0L) next
    ids <- as.character(ped$id)
    px <- Pedixplorer::num_child(ids, as.character(ped$sire),
                                 as.character(ped$dam))
    ## Pedixplorer stores its counts as doubles.
    expect_identical(unname(countOffspring(ped)),
                     as.integer(px$num_child_dir[match(ids, px$id)]),
                     info = name)
    compared <- compared + 1L
  }
  expect_gte(compared, 100L)
})

test_that("countOffspring() stops on a pedigree or ids it cannot read", {
  expect_error(countOffspring(list(id = "A", sire = NA, dam = NA)),
               "countOffspring: ped must be a data frame")
  expect_error(countOffspring(data.frame(id = "A", sire = NA)),
               "countOffspring: ped lacks the column\\(s\\) dam")
  expect_error(countOffspring(lookupsPed(), list("A")),
               "countOffspring: ids must be a vector of animal ids")
  expect_error(countOffspring(lookupsPed(), NULL),
               "countOffspring: ids must be a vector of animal ids")
})
