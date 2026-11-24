## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84 and R161, pedkindraw S87): shrinkPedigree()'s third trim when no
## animal is left that it may remove (R/shrinkPedigree.R, copied from
## nprcgenekeepr and kept as copied). The trim removes genotyped animals that
## are no one's parent; two animals each the other's sire, which the input
## checks allow, are both parents, so the trim stops with the bit size above
## 'maxBits' (Learning 11: found S13, reached until now only by the results
## tool's case shrinkLoop). Every expected value was computed with the function
## before this file was written (Learning 18).

loopPed <- function() {
  data.frame(id = c("A", "B"), sire = c("B", "A"), dam = NA_character_,
             stringsAsFactors = FALSE)
}

test_that("the third trim stops, above the budget, when every genotyped
           animal is a parent", {
  result <- shrinkPedigree(loopPed(), c(TRUE, TRUE), maxBits = 0L)
  expect_identical(result$ped, loopPed())
  expect_identical(result$idTrimmed, character(0L))
  expect_identical(result$idList$affected, character(0L))
  expect_identical(result$bitSize, c(4L, 4L))
  expect_identical(result$pedSizeFinal, 2L)
})

test_that("the third trim removes the offspring, then stops at the two
           animals each the other's sire", {
  ped <- data.frame(id = c("A", "B", "C"), sire = c("B", "A", "A"),
                    dam = NA_character_, stringsAsFactors = FALSE)
  result <- shrinkPedigree(ped, c(TRUE, TRUE, TRUE), maxBits = 0L)
  expect_identical(result$ped, loopPed())
  expect_identical(result$idTrimmed, "C")
  expect_identical(result$idList$affected, "C")
  expect_identical(result$bitSize, c(6L, 6L, 4L))
  expect_identical(result$pedSizeFinal, 2L)
})
