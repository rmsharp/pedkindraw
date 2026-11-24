## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84 and R161, pedkindraw S87): .extractNprcStructure() in
## R/comparePedigreeStructure.R (copied from nprcgenekeepr, kept as copied)
## skips a mating that has fewer than two mate lines. makePedigreeMatingLayout()
## always draws two, one from each parent (a parent with no row of its own
## included), so the only way to the skip is a layout with one mate line taken
## out by hand.

test_that(".extractNprcStructure() skips a mating with one mate line", {
  ped <- data.frame(id = c("SIRE", "DAM", "CHILD"), sire = c(NA, NA, "SIRE"),
                    dam = c(NA, NA, "DAM"), sex = c("M", "F", "F"),
                    gen = c(0L, 0L, 1L), stringsAsFactors = FALSE)
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  expect_identical(nrow(.extractNprcStructure(layout)$matePairs), 1L)
  mateLine <- startsWith(layout$edges$to, "__union_")
  layout$edges <- layout$edges[!(mateLine & layout$edges$from == "DAM"), ]
  structure <- .extractNprcStructure(layout)
  expect_identical(nrow(structure$matePairs), 0L)
  expect_identical(structure$individuals, c("SIRE", "DAM", "CHILD"))
})
