## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G6, gap
## C5, pedkindraw S47). getMatings() lists each sire and dam with at least
## one offspring recorded with both, once, with the number of offspring they
## share: the matings the drawing's layout builds. Every expected value was
## computed with a scratch prototype before this file was written (Learning
## 18). The pedigrees and slow versions are in helper-offspringAndMatings.R.
## S66 (plan Phase G15b, gap B1, R141; Mark's picks): with 'matings', the
## declared pairs with no offspring together follow the matings built from
## offspring, in their rows' order, with offspring 0; a row naming a pair
## with offspring together is dropped without a message; the rows are the
## drawing's mating points, in its order. The typed shapes are in
## helper-matesNoOffspring.R.
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

test_that("matings is getMatings()'s last argument, NULL by default; NULL or
  a table with no rows changes nothing", {
  expect_identical(names(formals(getMatings)), c("ped", "matings"))
  expect_null(formals(getMatings)$matings)
  ped <- halfSibsPed()
  expect_identical(getMatings(ped, NULL), getMatings(ped))
  expect_identical(getMatings(ped, .matesTable(character(), character())),
                   getMatings(ped))
})

test_that("declared matings with no offspring follow the matings built from
  offspring, in their rows' order, each as written, with offspring 0", {
  shape <- .matesShapes()$matesNoOffspring
  expect_identical(getMatings(shape$ped, shape$matings),
                   matings(c("A", "E"), c("B", "F"), c(2L, 0L)))
  ## E and F in the first rows of ped: still after A and B.
  expect_identical(getMatings(shape$ped[c(5L, 6L, 1L:4L), ], shape$matings),
                   matings(c("A", "E"), c("B", "F"), c(2L, 0L)))
  ## No mating with offspring; two declared rows, in their order.
  two <- .matesShapes()$twoChildless
  expect_identical(getMatings(two$ped, two$matings),
                   matings(c("A", "A"), c("B", "G"), c(0L, 0L)))
  expect_identical(getMatings(two$ped, two$matings[2L:1L, ]),
                   matings(c("A", "A"), c("G", "B"), c(0L, 0L)))
  ## The sexes are not checked: F, a female, listed as sire as written.
  first <- .matesShapes()$femaleFirst
  expect_identical(getMatings(first$ped, first$matings),
                   matings(c("A", "F"), c("B", "E"), c(2L, 0L)))
  ## Factor columns read as text; other columns ignored.
  expect_identical(
    getMatings(shape$ped, data.frame(sire = factor("E"), dam = factor("F"),
                                     note = "x")),
    matings(c("A", "E"), c("B", "F"), c(2L, 0L))
  )
})

test_that("a declared row naming a pair with offspring together, in either
  role, adds nothing and says nothing; a pair named twice is listed once", {
  expect_no_message(got <- getMatings(lookupsPed(), .matesTable("B", "A")))
  expect_identical(got, matings("A", "B", 2L))
  shape <- .matesShapes()$matesNoOffspring
  expect_identical(
    getMatings(shape$ped, .matesTable(c("E", "F", "E", "A"),
                                      c("F", "E", "F", "B"))),
    matings(c("A", "E"), c("B", "F"), c(2L, 0L))
  )
})

test_that("getMatings(ped, getMatings(ped)) is getMatings(ped), with no
  message, on every fixture pedigree, 100 seeded random ones and the typed
  ones", {
  selfed <- data.frame(id = c("X", "C"), sire = c(NA, "X"), dam = c(NA, "X"),
                       stringsAsFactors = FALSE)
  rowless <- halfSibsPed()
  rowless$sire[rowless$id == "H"] <- "Z"
  peds <- c(matingCheckPeds(),
            list(halfSibs = halfSibsPed(), sireAndDam = sireAndDamPed(),
                 selfed = selfed, rowlessSire = rowless))
  for (name in names(peds)) {
    listed <- getMatings(peds[[name]])
    expect_no_message(got <- getMatings(peds[[name]], listed))
    expect_identical(got, listed, info = name)
  }
})

test_that("a declared row naming an animal without a row in ped is left out,
  with a message naming getMatings(); the other rows are listed", {
  shape <- .matesShapes()$matesNoOffspring
  expect_message(
    got <- getMatings(shape$ped, .matesTable(c("E", "C"), c("F", "Z"))),
    paste0("getMatings\\(\\): 1 mating\\(s\\) in 'matings' naming an ",
           "animal not in 'ped' left out: C and Z")
  )
  expect_identical(got, matings(c("A", "E"), c("B", "F"), c(2L, 0L)))
  ## Z, a sire with no row of its own (of H, with B), declared with E: left
  ## out, as the drawing, which draws no animal without a row, leaves it.
  rowless <- halfSibsPed()
  rowless$sire[rowless$id == "H"] <- "Z"
  expect_message(got <- getMatings(rowless, .matesTable("Z", "E")),
                 "left out: Z and E")
  expect_identical(got, getMatings(rowless))
})

test_that("getMatings() stops on a matings table it cannot read, naming
  itself, after checking ped", {
  ped <- .matesShapes()$matesNoOffspring$ped
  notFrame <- paste0("getMatings\\(\\) requires 'matings' to be NULL or a ",
                     "data frame with the columns sire and dam")
  expect_error(getMatings(ped, list(sire = "E", dam = "F")), notFrame)
  expect_error(getMatings(ped, "E"), notFrame)
  expect_error(getMatings(ped, data.frame(sire = "E")),
               paste0("getMatings\\(\\) requires 'matings' to have the ",
                      "columns sire and dam. Missing: dam"))
  expect_error(getMatings(ped, .matesTable("E", NA)),
               "getMatings\\(\\) found NA in 'matings' columns sire and dam")
  expect_error(getMatings(ped, .matesTable("E", "E")),
               paste0("getMatings\\(\\) found the same id as sire and dam ",
                      "in 'matings': E"))
  expect_error(getMatings(list(id = "A", sire = NA, dam = NA), "E"),
               "getMatings: ped must be a data frame")
})

test_that("with declared matings, getMatings() lists the matings the
  drawing draws, in its order, on the typed shapes and 100 seeded random
  pedigrees", {
  skip_on_cran()
  cases <- declaredMatingCases()
  expect_identical(length(cases), 112L)
  nDeclared <- 0L
  for (name in names(cases)) {
    ped <- cases[[name]]$ped
    m <- cases[[name]]$matings
    got <- getMatings(ped, m)
    nDeclared <- nDeclared + sum(got$offspring == 0L)
    expect_identical(got[c("sire", "dam")], layoutMatings(ped, m),
                     info = name)
    expect_identical(drawnMatings(.matesLayout(ped, m)), matingPairs(got),
                     info = name)
  }
  expect_gte(nDeclared, 200L)
})
