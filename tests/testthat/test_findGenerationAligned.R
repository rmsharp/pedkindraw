## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G8, gap
## C2, pedkindraw S49): findGeneration(alignMates = TRUE). The expected
## generations of the typed pedigrees were computed with kinship2 1.9.6.2's
## kindepth(align = TRUE) before RED and agree with it except where a test
## says otherwise. Helpers: helper-findGenerationAligned.R.

aligned <- function(ped) {
  findGeneration(ped$id, ped$sire, ped$dam, alignMates = TRUE)
}

test_that("alignMates = FALSE, the default, leaves every result as it was", {
  for (ped in alignedCheckPeds()) {
    plain <- suppressWarnings(findGeneration(ped$id, ped$sire, ped$dam))
    expect_identical(
      suppressWarnings(findGeneration(ped$id, ped$sire, ped$dam,
                                      alignMates = FALSE)),
      plain
    )
  }
  expect_equal(
    findGeneration(lacy1989Ped$id, lacy1989Ped$sire, lacy1989Ped$dam,
                   alignMates = FALSE),
    lacy1989Ped$gen
  )
})

test_that("alignMates must be TRUE or FALSE", {
  ped <- alignedTypedPeds()$founderMateStays
  for (bad in list(NA, "TRUE", 1L, c(TRUE, FALSE), NULL, logical(0L))) {
    expect_error(
      findGeneration(ped$id, ped$sire, ped$dam, alignMates = bad),
      "findGeneration: alignMates must be TRUE or FALSE", fixed = TRUE
    )
  }
})

test_that("a mate with no parents moves to its mate's generation", {
  ## lacy1989Ped: E, a founder, mates D (generation 1).
  expect_identical(aligned(lacy1989Ped), c(0L, 0L, 1L, 1L, 1L, 2L, 2L))
})

test_that("an animal moves once, to its nearest later mate, with its
  ancestors", {
  expect_identical(
    aligned(alignedTypedPeds()$nearestMateOnce),
    c(1L, 1L, 2L, 0L, 0L, 1L, 1L, 2L, 0L, 0L, 1L, 1L, 2L, 2L, 3L, 3L, 4L)
  )
})

test_that("the mover's own mates stay where they are", {
  ## S moves to M's generation; T, its other mate, stays in generation 0.
  expect_identical(aligned(alignedTypedPeds()$founderMateStays),
                   c(0L, 0L, 1L, 0L, 1L, 2L, 2L))
})

test_that("an ancestor's mate moves with it when it has no parents, and
  stays when it has", {
  expect_identical(
    aligned(alignedTypedPeds()$founderMateOfAncestor),
    c(1L, 1L, 2L, 1L, 2L, 0L, 0L, 1L, 1L, 2L, 3L)
  )
  expect_identical(
    aligned(alignedTypedPeds()$mateWithParentsStays),
    c(0L, 0L, 0L, 1L, 1L, 2L, 1L, 3L, 3L, 0L, 0L, 1L, 1L, 2L, 2L, 3L, 4L)
  )
})

test_that("an animal related to a later mate other than through their
  offspring stays", {
  ## p mates its own daughter D: p stays in generation 0.
  expect_identical(aligned(alignedTypedPeds()$relatedMateStays),
                   c(0L, 0L, 1L, 2L, 0L, 0L, 1L, 1L, 2L, 3L))
})

test_that("a mating of an offspring pushed down is visited in turn", {
  expect_identical(aligned(alignedTypedPeds()$pushedMatingVisited),
                   c(0L, 1L, 0L, 1L, 0L, 1L, 2L, 2L, 1L, 3L, 2L))
})

test_that("an offspring of the ancestors moved is pushed down only at the
  end", {
  ## sm moves to sib's generation (1) before sib is pushed to 2.
  expect_identical(
    aligned(alignedTypedPeds()$siblingPushedLast),
    c(1L, 1L, 2L, 2L, 0L, 0L, 1L, 1L, 2L, 3L, 1L, 3L)
  )
})

test_that("the order of the rows does not change the aligned generations", {
  ped <- alignedTypedPeds()$rowOrder
  expected <- c(0L, 0L, 1L, 0L, 2L, 1L, 1L, 2L, 3L)
  expect_identical(aligned(ped), expected)
  for (rows in list(9:1, c(1:7, 9L, 8L))) {
    expect_identical(aligned(ped[rows, ]), expected[rows])
  }
  withr::with_seed(49L, {
    for (ped in alignedCheckPeds()) {
      rows <- sample.int(nrow(ped))
      expect_identical(aligned(ped[rows, ]), aligned(ped)[rows])
    }
  })
})

test_that("ids are read as text: factors by their labels, numbers as
  digits", {
  ped <- alignedTypedPeds()$nearestMateOnce
  expected <- aligned(ped)
  asFactors <- data.frame(lapply(ped, factor))
  expect_identical(aligned(asFactors), expected)
  numbered <- data.frame(id = seq_len(nrow(ped)),
                         sire = match(ped$sire, ped$id),
                         dam = match(ped$dam, ped$id))
  expect_identical(aligned(numbered), expected)
})

test_that("animals that cannot be placed stay NA, with the same warning", {
  ped <- rbind(lacy1989Ped[, c("id", "sire", "dam")],
               data.frame(id = c("Z", "a", "b"), sire = c("GHOST", "b", "a"),
                          dam = c("E", NA, NA)))
  plainWarning <- tryCatch(findGeneration(ped$id, ped$sire, ped$dam),
                           warning = conditionMessage)
  alignedWarning <- tryCatch(aligned(ped), warning = conditionMessage)
  expect_identical(alignedWarning, plainWarning)
  gen <- suppressWarnings(aligned(ped))
  expect_identical(gen, c(0L, 0L, 1L, 1L, 1L, 2L, 2L, NA, NA, NA))
  expect_identical(
    suppressWarnings(findGeneration(c("a", "b"), c("b", "a"), c(NA, NA),
                                    alignMates = TRUE)),
    c(NA, NA)
  )
  expect_identical(
    findGeneration(character(0L), character(0L), character(0L),
                   alignMates = TRUE),
    logical(0L)
  )
})

test_that("every offspring is in a later generation than each known
  parent", {
  for (ped in alignedCheckPeds()) {
    gen <- aligned(ped)
    sire <- match(ped$sire, ped$id)
    dam <- match(ped$dam, ped$id)
    expect_true(all(is.na(sire) | gen > gen[sire]))
    expect_true(all(is.na(dam) | gen > gen[dam]))
  }
})

test_that("the aligned generations equal the slow version's, step by
  step, on the typed, fixture and seeded random pedigrees", {
  ## examplePedigree is left out: the slow version takes about 400 s on its
  ## 3,694 animals (S49). The tests above and kinship2's below cover it.
  checkPeds <- alignedCheckPeds()
  peds <- c(alignedTypedPeds(),
            checkPeds[names(checkPeds) != "examplePedigree"])
  for (ped in peds) {
    expect_identical(aligned(ped),
                     alignedGenerationsSlow(ped$id, ped$sire, ped$dam))
  }
  expect_length(peds, 214L)
})

test_that("the aligned generations equal kinship2's kindepth(align = TRUE)
  on its sample families, two fixture pedigrees and the typed ones", {
  skip_if_not_installed("kinship2")
  family1 <- kinship2SampleFamily(1L)$ped
  expect_identical(aligned(family1), as.integer(kinship2Aligned(family1)))
  expect_identical(
    sum(aligned(family1) != findGeneration(family1$id, family1$sire,
                                           family1$dam)),
    6L
  )
  family2 <- kinship2SampleFamily(2L)$ped
  expect_identical(aligned(family2), as.integer(kinship2Aligned(family2)))
  for (ped in list(lacy1989Ped, smallPed)) {
    expect_identical(aligned(ped), as.integer(kinship2Aligned(ped)))
  }
  typed <- alignedTypedPeds()
  for (name in setdiff(names(typed), "rowOrder")) {
    expect_identical(aligned(typed[[name]]),
                     as.integer(kinship2Aligned(typed[[name]])))
  }
  ## kinship2 places RY in generation 2 with the rows as typed, 1 with
  ## them reversed; pedkindraw places it in 1 either way.
  rowOrder <- typed$rowOrder
  expect_identical(as.integer(kinship2Aligned(rowOrder))[6L], 2L)
  expect_identical(as.integer(kinship2Aligned(rowOrder[9:1, ]))[4L], 1L)
})

test_that("the aligned generations equal kinship2's on most seeded random
  pedigrees with both parents or neither, and differ on few animals of the
  larger fixture pedigrees", {
  skip_if_not_installed("kinship2")
  peds <- alignedCheckPeds()
  equal <- 0L
  compared <- 0L
  for (name in paste0("bothParents", 1:100)) {
    expected <- kinship2Aligned(peds[[name]])
    if (is.null(expected)) next
    compared <- compared + 1L
    equal <- equal + identical(aligned(peds[[name]]), as.integer(expected))
  }
  ## When this test was written kinship2 returned on all 100, and the
  ## aligned generations equalled its on 73.
  expect_gte(compared, 100L)
  expect_gte(equal, 73L)
  ## The animals placed differently, as measured when this test was
  ## written; kinship2 returned on each.
  measured <- c(examplePedigree = 8L, pedWithGenotype = 24L,
                qcdRhesusPed = 34L, qcPed = 24L, rhesusPedigree = 3L)
  for (name in names(measured)) {
    expected <- kinship2Aligned(peds[[name]])
    expect_false(is.null(expected))
    expect_lte(sum(aligned(peds[[name]]) != expected), measured[[name]])
  }
})
