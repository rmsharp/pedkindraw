## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G11, gap
## C1, rulings R129-R130, pedkindraw S52). getNearRelativePedigree(ped,
## probands, maxDist) keeps each animal whose distance from the probands,
## log2 of 1 over its largest kinship with one, is at most maxDist, and each
## parent of those whose own offspring and its mates' offspring number two or
## more, setting the other parents to NA, as Pedixplorer's
## useful_inds(max_dist = ) keeps them. Every expected value was computed
## with a prototype and with Pedixplorer 1.8.0 before RED (Learning 18). The
## typed pedigrees and the slow version are in
## helper-getNearRelativePedigree.R.

test_that("getNearRelativePedigree() takes ped, probands and maxDist", {
  expect_named(formals(getNearRelativePedigree),
               c("ped", "probands", "maxDist"))
})

test_that("getNearRelativePedigree() keeps the proband's family by distance,
           in the pedigree's order", {
  ped <- nearFamily()
  expect_identical(getNearRelativePedigree(ped, "O", 1)$id,
                   c("F", "M", "O"))
  expect_identical(getNearRelativePedigree(ped, "O", 2)$id,
                   c("G1", "G2", "F", "M", "O", "S", "K"))
  expect_identical(getNearRelativePedigree(ped, "O", 3)$id,
                   c("G1", "G2", "F", "U", "M", "O", "S", "K", "Y", "Z",
                     "N", "N2"))
  expect_identical(getNearRelativePedigree(ped, "O", 4)$id,
                   c("G1", "G2", "F", "U", "M", "O", "S", "K", "Y", "Z",
                     "N", "N2", "C"))
})

test_that("getNearRelativePedigree() keeps a parent whose own and its mates'
           offspring number two or more, and only a parent of an animal
           within the distance", {
  ped <- nearFamily()
  ## Y and Z each have one offspring, by S, who has two (N and N2).
  near3 <- getNearRelativePedigree(ped, "O", 3)
  expect_true(all(c("Y", "Z") %in% near3$id))
  ## Q's one offspring is K, and O has no other; X's is C, and U has no
  ## other: both are left out at every distance.
  for (k in c(1, 2, 3, 4, 10)) {
    kept <- getNearRelativePedigree(ped, "O", k)$id
    expect_false(any(c("Q", "X") %in% kept))
  }
  ## At distance 1 only O is within it: its parents F and M are kept, but
  ## not F's parents G1 and G2, though they have two offspring.
  near1 <- getNearRelativePedigree(ped, "O", 1)
  expect_false(any(c("G1", "G2") %in% near1$id))
})

test_that("getNearRelativePedigree() sets each parent left out to NA and
           leaves every other value, column and row name as it was", {
  ped <- nearFamily()
  ped$birth <- as.Date("2020-01-01") + seq_len(nrow(ped))
  ped$note <- paste("animal", seq_len(nrow(ped)))
  rownames(ped) <- paste0("r", seq_len(nrow(ped)))
  expected <- ped[ped$id %in% c("G1", "G2", "F", "M", "O", "S", "K"), ]
  expected$dam[expected$id == "K"] <- NA
  expect_identical(getNearRelativePedigree(ped, "O", 2), expected)
  near1 <- getNearRelativePedigree(ped, "O", 1)
  expect_identical(near1$sire, c(NA, NA, "F"))
  expect_identical(near1$dam, c(NA, NA, "M"))
  near4 <- getNearRelativePedigree(ped, "O", 4)
  expect_identical(near4$dam[near4$id %in% c("K", "C")], c(NA_character_,
                                                           NA_character_))
  expect_identical(near4$sire[near4$id == "C"], "U")
})

test_that("getNearRelativePedigree() reads distance from kinship, not steps:
           an inbred proband and a fraction of a distance", {
  ped <- nearInbred()
  near1 <- getNearRelativePedigree(ped, "I", 1)
  expect_identical(near1$id, c("P", "E", "I"))
  expect_identical(near1$dam, c(NA, NA, "E"))
  expect_identical(getNearRelativePedigree(ped, "I", 1.5)$id,
                   c("P", "D", "E", "I"))
})

test_that("getNearRelativePedigree() puts double first cousins at distance 3,
           where a first cousin is at 4", {
  ped <- nearCousins()
  expect_identical(getNearRelativePedigree(ped, "C1", 2)$id,
                   c("G1", "G2", "H1", "H2", "B1", "S1", "C1"))
  expect_identical(getNearRelativePedigree(ped, "C1", 3)$id,
                   c("G1", "G2", "H1", "H2", "B1", "B2", "S1", "S2", "C1",
                     "C2"))
  ## R is at 3.415, and its sire V (at 4) has one offspring, by S2, who has
  ## two; V's dam W is left out.
  near <- getNearRelativePedigree(ped, "C1", 3.5)
  expect_identical(near$id, c("G1", "G2", "H1", "H2", "B1", "B2", "S1", "S2",
                              "C1", "C2", "V", "R"))
  expect_identical(near$dam[near$id == "V"], NA_character_)
})

test_that("getNearRelativePedigree() measures from the nearest proband", {
  ped <- nearFamily()
  near1 <- getNearRelativePedigree(ped, c("O", "C"), 1)
  expect_identical(near1$id, c("F", "M", "O", "C"))
  expect_identical(near1$sire[near1$id == "C"], NA_character_)
  expect_identical(near1$dam[near1$id == "C"], NA_character_)
  expect_identical(getNearRelativePedigree(ped, c("O", "C"), 2)$id,
                   c("G1", "G2", "F", "U", "M", "X", "O", "S", "K", "C"))
})

test_that("getNearRelativePedigree() keeps an unrelated mate's offspring, not
           its mate's family", {
  ped <- nearFamily()
  expect_identical(getNearRelativePedigree(ped, "X", 1)$id, "X")
  near2 <- getNearRelativePedigree(ped, "X", 2)
  expect_identical(near2$id, c("X", "C"))
  expect_identical(near2$sire, c(NA_character_, NA_character_))
})

test_that("getNearRelativePedigree() returns no rows, with ped's columns,
           when no proband has a row", {
  ped <- nearFamily()
  expect_identical(getNearRelativePedigree(ped, character(0L), 2), ped[0L, ])
  expect_identical(getNearRelativePedigree(ped, "nobody", 2), ped[0L, ])
  expect_identical(getNearRelativePedigree(ped, NA, 2), ped[0L, ])
})

test_that("getNearRelativePedigree() ignores probands with no row and
           repeated probands", {
  ped <- nearFamily()
  expect_identical(getNearRelativePedigree(ped, c("O", "nobody", "O"), 2),
                   getNearRelativePedigree(ped, "O", 2))
})

test_that("getNearRelativePedigree() reads factors by their labels and
           numbers as text, keeping each column's type", {
  ped <- nearFamily()
  numbered <- data.frame(id = seq_len(nrow(ped)),
                         sire = match(ped$sire, ped$id),
                         dam = match(ped$dam, ped$id))
  near1 <- getNearRelativePedigree(numbered, 7L, 1)
  expect_identical(near1$id, c(3L, 5L, 7L))
  expect_identical(near1$sire, c(NA, NA, 3L))
  expect_identical(getNearRelativePedigree(numbered, "7", 1), near1)
  factors <- data.frame(id = factor(ped$id), sire = factor(ped$sire),
                        dam = factor(ped$dam))
  near2 <- getNearRelativePedigree(factors, factor("O"), 2)
  expect_s3_class(near2$id, "factor")
  expect_identical(levels(near2$dam), levels(factors$dam))
  expect_identical(as.character(near2$id),
                   c("G1", "G2", "F", "M", "O", "S", "K"))
  expect_true(is.na(near2$dam[as.character(near2$id) == "K"]))
})

test_that("getNearRelativePedigree() keeps a pedigree with one known parent,
           as the slow version does", {
  for (k in 1:4) {
    kept <- getNearRelativePedigree(smallPed, c("F", "I"), k)
    expect_identical(kept$id, nearRelativesSlow(smallPed, c("F", "I"), k))
    expect_identical(nrow(checkPedigree(kept)), 0L)
  }
})

test_that("getNearRelativePedigree() equals the slow version on seeded random
           pedigrees, whatever the row order", {
  distances <- c(1, 1.5, 2, 2.5, 3, 4, 6)
  for (seed in 1:300) {
    case <- nearRandomCase(seed)
    k <- distances[[seed %% length(distances) + 1L]]
    kept <- getNearRelativePedigree(case$ped, case$probands, k)
    expect_identical(kept$id, nearRelativesSlow(case$ped, case$probands, k))
    expect_true(all(case$probands %in% kept$id))
    expect_identical(nrow(checkPedigree(kept)), 0L)
    shuffled <- case$ped[withr::with_seed(seed, sample(nrow(case$ped))), ]
    expect_setequal(getNearRelativePedigree(shuffled, case$probands, k)$id,
                    kept$id)
  }
})

test_that("getNearRelativePedigree() keeps the 14, 30 and 33 animals
           Pedixplorer's useful_inds() keeps on its sample family 1", {
  skip_if_not_installed("Pedixplorer")
  case <- nearSampleFamily()
  expect_length(case$probands, 7L)
  kept <- lapply(1:3, function(k) {
    getNearRelativePedigree(case$ped, case$probands, k)$id
  })
  expect_identical(lengths(kept), c(14L, 30L, 33L))
  theirs <- pedixplorerNear(case$ped, case$probands, 1:3)
  for (k in 1:3) {
    expect_setequal(kept[[k]], theirs[[k]])
  }
})

test_that("getNearRelativePedigree() keeps the animals Pedixplorer's
           useful_inds() keeps on seeded random pedigrees", {
  skip_if_not_installed("Pedixplorer")
  compared <- 0L
  for (seed in 1:50) {
    case <- nearRandomCase(seed)
    theirs <- pedixplorerNear(case$ped, case$probands, 1:5)
    if (is.null(theirs)) {
      next
    }
    for (k in 1:5) {
      compared <- compared + 1L
      expect_setequal(getNearRelativePedigree(case$ped, case$probands, k)$id,
                      theirs[[k]])
    }
  }
  expect_gte(compared, 245L)
})

test_that("getNearRelativePedigree()'s pedigree can be laid out, every
           animal drawn", {
  kept <- getNearRelativePedigree(nearFamily(), "O", 3)
  kept$gen <- findGeneration(kept$id, kept$sire, kept$dam)
  layout <- suppressMessages(makePedigreeMatingLayout(kept))
  expect_length(layout$isolatedIds, 0L)
  expect_true(all(kept$id %in% layout$nodes$id))
})

test_that("getNearRelativePedigree() stops on a ped that is not a pedigree
           data frame", {
  expect_error(getNearRelativePedigree(list(id = "A"), "A", 2),
               "getNearRelativePedigree: ped must be a data frame",
               fixed = TRUE)
  expect_error(getNearRelativePedigree(data.frame(id = "A", sire = NA),
                                       "A", 2),
               "getNearRelativePedigree: ped lacks the column(s) dam",
               fixed = TRUE)
})

test_that("getNearRelativePedigree() stops when probands is not a vector", {
  expect_error(getNearRelativePedigree(nearFamily(), list("O"), 2),
               "getNearRelativePedigree: probands must be a vector of animal ids",
               fixed = TRUE)
})

test_that("getNearRelativePedigree() stops unless maxDist is one finite
           number, 1 or more", {
  for (bad in list(NA, NA_real_, "2", c(1, 2), numeric(0L), NULL, 0.5, 0,
                   -1, Inf, TRUE)) {
    expect_error(getNearRelativePedigree(nearFamily(), "O", bad),
                 paste("getNearRelativePedigree: maxDist must be one finite",
                       "number, 1 or more"),
                 fixed = TRUE)
  }
  expect_no_error(getNearRelativePedigree(nearFamily(), "O", 2L))
})

test_that("getNearRelativePedigree() stops, naming the animals, on a
           pedigree from which kinship cannot be read", {
  cycle <- data.frame(id = c("A", "B", "C"), sire = c("B", "A", NA),
                      dam = c("C", "C", NA))
  expect_error(getNearRelativePedigree(cycle, "A", 2),
               "getNearRelativePedigree: .*checkPedigree\\(\\) reports cycle: A, B")
  rowless <- data.frame(id = c("A", "B"), sire = c(NA, "S"), dam = c(NA, "A"))
  expect_error(getNearRelativePedigree(rowless, "A", 2),
               "rowlessParents: S \\(addParents\\(\\) adds a row")
  twice <- data.frame(id = c("A", "A", "B"), sire = NA, dam = NA)
  expect_error(getNearRelativePedigree(twice, "B", 2),
               "getNearRelativePedigree: .*duplicateIds: A")
  coded <- data.frame(id = c("A", "B"), sire = c("0", "0"), dam = c(NA, "A"))
  expect_error(getNearRelativePedigree(coded, "A", 2),
               "getNearRelativePedigree: .*missingParentCodes: \"0\"")
})

test_that("?getNearRelativePedigree's example keeps O's family at distances
           1 to 3", {
  env <- new.env(parent = globalenv())
  eval(parse(text = helpExampleCode("getNearRelativePedigree")), envir = env)
  expect_identical(env$near1$id, c("F", "M", "O"))
  expect_identical(env$near2$id, c("G1", "G2", "F", "M", "O", "S", "K"))
  expect_true(is.na(env$near2$dam[env$near2$id == "K"]))
  expect_identical(env$near3$id, c("G1", "G2", "F", "U", "M", "O", "S", "K",
                                   "Y", "Z", "N", "N2"))
})
