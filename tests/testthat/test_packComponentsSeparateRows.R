## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84, R161 and R162, pedkindraw S88): .packComponents() in
## R/makePedigreeDiagramData.R (copied from nprcgenekeepr, kept as copied)
## sets two families side by side. When they share a row, each shared row
## keeps one column between them; when they share none, the whole of the
## second family starts one column right of the whole of the first. The
## caller gives each animal's row in 'gen', so two families on rows that do
## not overlap reach that second rule through makePedigreeMatingLayout().
## Every expected value was computed with the function before this file was
## written (Learning 18).

twoFamilies <- function(gen) {
  data.frame(id = c("A", "B", "C", "D", "E", "F"),
             sire = c(NA, NA, "A", NA, NA, "D"),
             dam = c(NA, NA, "B", NA, NA, "E"),
             sex = c("M", "F", "M", "M", "F", "F"), gen = gen,
             stringsAsFactors = FALSE)
}

realNodes <- function(layout) {
  nodes <- layout$nodes[!startsWith(layout$nodes$id, "__"), ]
  stats::setNames(nodes$x, nodes$id)
}

test_that("two families on rows that do not overlap are one column apart", {
  layout <- makePedigreeMatingLayout(twoFamilies(c(0L, 0L, 1L, 2L, 2L, 3L)))
  x <- realNodes(layout)
  y <- stats::setNames(layout$nodes$y, layout$nodes$id)
  expect_identical(unname(y[c("A", "B", "C", "D", "E", "F")]),
                   c(0, 0, 150, 300, 300, 450))
  expect_equal(min(x[c("D", "E", "F")]) - max(x[c("A", "B", "C")]), 120)
  expect_equal(unname(x[["D"]] - x[["B"]]), 120)
})

test_that("the same families sharing rows are packed row by row instead", {
  layout <- makePedigreeMatingLayout(twoFamilies(c(0L, 0L, 1L, 1L, 1L, 2L)))
  x <- realNodes(layout)
  expect_equal(unname(x[["D"]] - x[["C"]]), 120)
  expect_equal(unname(x[["D"]] - x[["B"]]), 60)
})
