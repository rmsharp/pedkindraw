## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G6, gap
## C5, pedkindraw S47). getMatings() lists each sire and dam with at least
## one offspring recorded with both, once, with the number of offspring they
## share: the matings the drawing's layout builds. Every expected value was
## computed with a scratch prototype before this file was written (Learning
## 18). The pedigrees and slow versions are in helper-offspringAndMatings.R.
library(testthat)

matings <- function(sire, dam, offspring) {
  data.frame(sire = sire, dam = dam, offspring = offspring,
             stringsAsFactors = FALSE)
}

test_that("getMatings() gives the gap case's one mating, A and B with 2", {
  expect_identical(getMatings(lookupsPed()), matings("A", "B", 2L))
})

test_that("getMatings() lists each mating once, in the order of its first
  offspring, and none for an offspring with one known parent", {
  expect_identical(getMatings(halfSibsPed()),
                   matings(c("A", "A", "K"), c("B", "E", "E"),
                           c(1L, 1L, 1L)))
  ped <- halfSibsPed()[c(1:4, 9L, 5:8), ]
  expect_identical(getMatings(ped),
                   matings(c("K", "A", "A"), c("E", "B", "E"),
                           c(1L, 1L, 1L)))
})

test_that("getMatings() counts the offspring of a mating, each once", {
  ped <- rbind(halfSibsPed(),
               data.frame(id = c("J", "L"), sire = c("A", "K"),
                          dam = c("B", "E")))
  expect_identical(getMatings(ped),
                   matings(c("A", "A", "K"), c("B", "E", "E"),
                           c(2L, 1L, 2L)))
  ## A row listed twice.
  expect_identical(getMatings(lookupsPed()[c(1L, 2L, 3L, 3L, 4L), ]),
                   matings("A", "B", 2L))
  ## An animal recorded as both the sire and the dam of one offspring.
  selfed <- data.frame(id = c("X", "C"), sire = c(NA, "X"), dam = c(NA, "X"),
                       stringsAsFactors = FALSE)
  expect_identical(getMatings(selfed), matings("X", "X", 1L))
})

test_that("getMatings() lists a sire and dam as recorded: a parent with no row,
  and each way round for animals recorded as both", {
  ped <- halfSibsPed()
  ped$sire[ped$id == "H"] <- "Z"
  expect_identical(getMatings(ped),
                   matings(c("A", "A", "Z", "K"), c("B", "E", "B", "E"),
                           c(1L, 1L, 1L, 1L)))
  expect_identical(getMatings(sireAndDamPed()),
                   matings(c("X", "Y"), c("Y", "X"), c(1L, 1L)))
})

test_that("getMatings() gives no rows, with its three columns, when no animal
  has both parents known", {
  expected <- matings(character(0L), character(0L), integer(0L))
  noBoth <- data.frame(id = c("A", "B", "C"), sire = c(NA, "A", NA),
                       dam = c(NA, NA, "B"), stringsAsFactors = FALSE)
  expect_identical(getMatings(noBoth), expected)
  expect_identical(getMatings(lookupsPed()[0L, ]), expected)
})

test_that("getMatings() reads factor and number columns as their text", {
  asFactors <- data.frame(lapply(halfSibsPed(), factor))
  expect_identical(getMatings(asFactors), getMatings(halfSibsPed()))
  numbered <- data.frame(id = 1:4, sire = c(NA, NA, 1L, 1L),
                         dam = c(NA, NA, 2L, 2L))
  expect_identical(getMatings(numbered), matings("1", "2", 2L))
})

test_that("getMatings() lists the drawing's matings, in its order, on every
  fixture pedigree and 100 seeded random ones", {
  peds <- matingCheckPeds()
  for (name in names(peds)) {
    expect_identical(getMatings(peds[[name]])[c("sire", "dam")],
                     layoutMatings(peds[[name]]), info = name)
  }
})

test_that("each animal's mates and each mating's offspring agree with the
  slow versions on every fixture pedigree and 100 seeded random ones", {
  peds <- matingCheckPeds()
  for (name in names(peds)) {
    ped <- peds[[name]]
    m <- getMatings(ped)
    ids <- as.character(ped$id)
    mates <- lapply(ids, function(i) sort(unique(c(m$dam[m$sire == i],
                                                   m$sire[m$dam == i]))))
    expect_identical(mates, lapply(ids, function(i) matesSlow(ped, i)),
                     info = name)
    shared <- vapply(seq_len(nrow(m)), function(r) {
      length(unique(ids[as.character(ped$sire) %in% m$sire[r] &
                          as.character(ped$dam) %in% m$dam[r]]))
    }, integer(1L))
    expect_identical(m$offspring, shared, info = name)
  }
})

test_that("getMatings() stops on a pedigree it cannot read", {
  expect_error(getMatings(list(id = "A", sire = NA, dam = NA)),
               "getMatings: ped must be a data frame")
  expect_error(getMatings(data.frame(id = "A", dam = NA)),
               "getMatings: ped lacks the column\\(s\\) sire")
})
