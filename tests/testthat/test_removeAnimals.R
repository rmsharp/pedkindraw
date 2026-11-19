## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G7, gap
## C6, pedkindraw S48). removeAnimals() removes the listed animals and clears
## each sire or dam entry that names one of them, keeping the other parent.
## Every expected value was computed with a scratch prototype before this
## file was written (Learning 18), and kinship2 1.9.6.2's pedigree.trim() and
## Pedixplorer 1.8.0's subset() were run on the same pedigrees there.
library(testthat)

test_that("removeAnimals() removes the gap case's C and clears F's and G's
  sire, after which checkPedigree() reports nothing and kinship() computes", {
  ped <- removeAnimalsPed()
  expect_identical(checkPedigree(ped[ped$id != "C", ])$check,
                   "rowlessParents")
  result <- removeAnimals(ped, "C")
  expected <- ped[-3L, ]
  expected$sire[expected$id %in% c("F", "G")] <- NA
  expect_identical(result, expected)
  expect_identical(nrow(checkPedigree(result)), 0L)
  gen <- findGeneration(result$id, result$sire, result$dam)
  expect_identical(gen, c(0L, 0L, 1L, 0L, 1L, 1L, 0L, 2L))
  k <- kinship(result$id, result$sire, result$dam, gen)
  expect_identical(k["F", "G"], 0.125)
  expect_identical(k["F", "F"], 0.5)
})

test_that("removeAnimals() keeps the parent not removed, where Pedixplorer's
  subset(del_parents = \"one\") clears it too", {
  result <- removeAnimals(removeAnimalsPed(), "C")
  expect_identical(result$dam[result$id %in% c("F", "G")], c("E", "E"))
  expect_identical(getOffspring(result, "E"), c("F", "G"))
  skip_if_not_installed("Pedixplorer")
  ped <- removeAnimalsPed()
  p <- Pedixplorer::Pedigree(data.frame(id = ped$id, dadid = ped$sire,
                                        momid = ped$dam,
                                        sex = sexNumbers(ped)))
  q <- Pedixplorer::ped(Pedixplorer::subset(p, setdiff(ped$id, "C"),
                                            del_parents = "one"))
  expect_identical(pedixplorerTrio(q, c("F", "G"))$dam,
                   c(NA_character_, NA_character_))
})

test_that("removeAnimals() clears both of an animal's parents when both are
  removed", {
  ped <- removeAnimalsPed()
  result <- removeAnimals(ped, c("A", "B"))
  expect_identical(result$id, c("C", "D", "E", "F", "G", "H", "I"))
  expect_identical(result$sire, c(NA, NA, NA, "C", "C", NA, "D"))
  expect_identical(result$dam, c(NA, NA, NA, "E", "E", NA, "H"))
  expect_identical(nrow(checkPedigree(result)), 0L)
})

test_that("removeAnimals() clears the links to a listed parent that has no row
  of its own", {
  ped <- removeAnimalsPed()
  rowless <- ped[ped$id != "C", ]
  expect_identical(removeAnimals(rowless, "C"), removeAnimals(ped, "C"))
})

test_that("removeAnimals() ignores an id that is nowhere in the pedigree, and
  removing again changes nothing", {
  ped <- removeAnimalsPed()
  expect_identical(removeAnimals(ped, "Z"), ped)
  expect_identical(removeAnimals(ped, character(0L)), ped)
  expect_identical(removeAnimals(ped, c("Z", "C")), removeAnimals(ped, "C"))
  once <- removeAnimals(ped, c("C", "I"))
  expect_identical(removeAnimals(once, c("C", "I")), once)
})

test_that("removeAnimals() removes every row of a listed id, and NA among the
  ids removes the rows whose id is NA", {
  ped <- removeAnimalsPed()
  twice <- rbind(ped, ped[3L, ])
  rownames(twice) <- NULL
  expect_identical(removeAnimals(twice, "C"), removeAnimals(ped, "C"))
  ped$id[2L] <- NA
  result <- removeAnimals(ped, NA)
  expect_identical(result$id, c("A", "C", "D", "E", "F", "G", "H", "I"))
  expect_identical(result$dam, c(NA, "B", "B", NA, "E", "E", NA, "H"))
})

test_that("removeAnimals() can remove every animal, leaving zero rows and the
  same columns", {
  ped <- removeAnimalsPed()
  result <- removeAnimals(ped, ped$id)
  expect_identical(nrow(result), 0L)
  expect_identical(lapply(result, class), lapply(ped, class))
})

test_that("removeAnimals() keeps the other columns and each column's type:
  number ids, factors and a data.table", {
  ped <- data.frame(id = 1L:5L, sire = c(NA, NA, 1L, 1L, 3L),
                    dam = c(NA, NA, 2L, 2L, 4L), weight = c(9, 8, 7, 6, 5))
  result <- removeAnimals(ped, 3L)
  expect_identical(result$id, c(1L, 2L, 4L, 5L))
  expect_identical(result$sire, c(NA, NA, 1L, NA))
  expect_identical(result$weight, c(9, 8, 6, 5))
  expect_identical(removeAnimals(ped, "3"), result)
  ped <- removeAnimalsPed()
  for (column in c("id", "sire", "dam", "sex")) {
    ped[[column]] <- factor(ped[[column]])
  }
  result <- removeAnimals(ped, factor("C"))
  expect_s3_class(result$sire, "factor")
  expect_identical(levels(result$sire), levels(ped$sire))
  expect_identical(as.character(result$sire),
                   c(NA, NA, "A", NA, NA, NA, NA, "D"))
  expect_identical(as.character(result$sex), c("M", "F", "M", "F", "M", "F",
                                               "F", "F"))
  result <- removeAnimals(data.table::as.data.table(removeAnimalsPed()), "C")
  expect_s3_class(result, "data.table")
  expect_identical(result$sire, c(NA, NA, "A", NA, NA, NA, NA, "D"))
})

test_that("removeAnimals() agrees with a slow version written from its
  definition on the fixture pedigrees and 100 seeded random ones", {
  peds <- matingCheckPeds()
  lists <- removalLists(peds, 4801L)
  oneParentKept <- 0L
  for (name in names(peds)) {
    ped <- peds[[name]]
    ids <- lists[[name]]
    result <- removeAnimals(ped, ids)
    expect_identical(pedTrio(result), removeAnimalsSlow(ped, ids),
                     info = name)
    others <- setdiff(names(ped), c("sire", "dam"))
    kept <- !(as.character(ped$id) %in% ids)
    expect_identical(result[others], ped[kept, others, drop = FALSE],
                     info = name)
    cleared <- pedTrio(ped[kept, ])
    oneParentKept <- oneParentKept +
      any(xor(cleared$sire %in% ids, cleared$dam %in% ids) &
            !is.na(cleared$sire) & !is.na(cleared$dam))
  }
  ## The pedigrees where an offspring of a removed animal keeps its other
  ## parent, which Pedixplorer would clear.
  expect_gte(oneParentKept, 100L)
})

test_that("after removeAnimals(), kinship() computes on each seeded random
  pedigree", {
  peds <- matingCheckPeds()
  peds <- peds[startsWith(names(peds), "random")]
  lists <- removalLists(peds, 4802L)
  for (name in names(peds)) {
    result <- removeAnimals(peds[[name]], lists[[name]])
    expect_false("rowlessParents" %in% checkPedigree(result)$check,
                 info = name)
    k <- kinship(result$id, result$sire, result$dam,
                 findGeneration(result$id, result$sire, result$dam))
    expect_false(anyNA(k), info = name)
  }
})

test_that("removeAnimals() equals kinship2's pedigree.trim() wherever kinship2
  returns, when no offspring keeps only one parent", {
  skip_if_not_installed("kinship2")
  peds <- removeCheckPeds()
  lists <- removalLists(peds, 4803L)
  compared <- 0L
  for (name in names(peds)) {
    ped <- peds[[name]]
    ids <- withMates(ped, lists[[name]])
    sex <- sexNumbers(ped)
    built <- tryCatch(kinship2::pedigree(as.character(ped$id),
                                         as.character(ped$sire),
                                         as.character(ped$dam),
                                         sex, missid = NA),
                      error = function(e) NULL)
    trimmed <- if (is.null(built)) {
      NULL
    } else {
      tryCatch(kinship2::pedigree.trim(ids, built), error = function(e) NULL)
    }
    if (!is.null(trimmed)) {
      compared <- compared + 1L
      expect_identical(pedTrio(removeAnimals(ped, ids)),
                       kinship2Trio(trimmed), info = name)
    }
  }
  expect_gte(compared, 100L)
})

test_that("removeAnimals() equals Pedixplorer's subset(del_parents = \"one\")
  but for the parent not removed, which Pedixplorer clears too", {
  skip_if_not_installed("Pedixplorer")
  peds <- removeCheckPeds()
  lists <- removalLists(peds, 4804L)
  compared <- 0L
  differs <- 0L
  for (name in names(peds)) {
    ped <- peds[[name]]
    ids <- lists[[name]]
    sex <- sexNumbers(ped)
    p <- quietPedixplorer(Pedixplorer::Pedigree(data.frame(
      id = as.character(ped$id), dadid = as.character(ped$sire),
      momid = as.character(ped$dam), sex = sex, stringsAsFactors = FALSE
    )))
    if (is.data.frame(p)) next
    compared <- compared + 1L
    kept <- setdiff(Pedixplorer::id(Pedixplorer::ped(p)), ids)
    q <- Pedixplorer::ped(quietPedixplorer(
      Pedixplorer::subset(p, kept, del_parents = "one")
    ))
    mine <- pedTrio(removeAnimals(ped, ids))
    lost <- pedTrio(ped[!(as.character(ped$id) %in% ids), ])
    lostOne <- lost$sire %in% ids | lost$dam %in% ids
    differs <- differs + any(lostOne & !(is.na(mine$sire) & is.na(mine$dam)))
    mine$sire[lostOne] <- NA
    mine$dam[lostOne] <- NA
    expect_identical(pedixplorerTrio(q, mine$id), mine, info = name)
  }
  expect_gte(compared, 100L)
  expect_gte(differs, 100L)
})

test_that("removeAnimals() stops when ped is not a pedigree data frame or ids
  is not a vector of ids", {
  ped <- removeAnimalsPed()
  expect_error(removeAnimals(as.list(ped), "C"),
               "removeAnimals: ped must be a data frame", fixed = TRUE)
  expect_error(removeAnimals(ped[, c("id", "dam")], "C"),
               "removeAnimals: ped lacks the column(s) sire", fixed = TRUE)
  for (bad in list(list("C"), NULL, ped, matrix("C"))) {
    expect_error(removeAnimals(ped, bad),
                 "removeAnimals: ids must be a vector of animal ids",
                 fixed = TRUE)
  }
})
