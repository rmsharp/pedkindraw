## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
##
## Plan Phase G9 (pedkindraw S50; gap B7,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; Mark's picks "Help
## example" and "Run the example in a test"): ?shrinkPedigree's example draws
## the whole pedigree with the animals shrinkPedigree() removed filled, from
## idTrimmed, through a condition column. kinship2's plot.pedigree.shrink()
## draws only the animals kept (its help: "the trimmed pedigree.shrink
## object"). These tests run the help page's own example
## (helper-helpExample.R), so they fail if the example stops doing what its
## comments say.

## The objects the example leaves, run in an environment of their own whose
## parent is the global environment, as example() runs it.
shrinkExampleObjects <- function() {
  env <- new.env(parent = globalenv())
  eval(parse(text = helpExampleCode("shrinkPedigree")), envir = env)
  env
}

test_that("?shrinkPedigree's example shrinks the pedigree of F and G, the
           animals genotyped, removing C, A and B", {
  ex <- shrinkExampleObjects()
  expect_identical(ex$result$idTrimmed, c("C", "A", "B"))
  expect_identical(ex$result$idList$unavail, c("C", "A", "B"))
  expect_identical(ex$result$ped$id, c("D", "E", "F", "G"))
  expect_identical(ex$result$bitSize, c(5L, 2L))
})

test_that("?shrinkPedigree's example draws the whole pedigree, the removed
           animals filled and the kept ones open", {
  ex <- shrinkExampleObjects()
  nodes <- ex$layout$nodes
  fill <- nodes$color.background[match(ex$ped$id, nodes$id)]
  removed <- ex$ped$id %in% ex$result$idTrimmed
  expect_identical(nrow(ex$ped), 7L)
  expect_true(all(ex$ped$id %in% nodes$id))
  expect_identical(ex$ped$id[removed], c("A", "B", "C"))
  ## The first condition's colour, pink; white is an unaffected animal's.
  expect_identical(fill[removed], rep("#CC79A7", 3L))
  expect_identical(fill[!removed], rep("#FFFFFF", 4L))
})

test_that("?shrinkPedigree's example names the mark in the drawing's legend
           and in each animal's hover text", {
  ex <- shrinkExampleObjects()
  expect_s3_class(ex$diagram, "visNetwork")
  expect_identical(ex$layout$conditions$label, "Affected (removed)")
  expect_true("Affected (removed)" %in% ex$diagram$x$legend$nodes$label)
  titles <- ex$layout$nodes$title[match(c("C", "D"), ex$layout$nodes$id)]
  expect_identical(
    endsWith(as.character(titles), c("<b>Affected (removed):</b> Yes",
                                     "<b>Affected (removed):</b> No")),
    c(TRUE, TRUE)
  )
})

test_that("kinship2's pedigree.shrink() keeps and removes the same animals
           as the example's shrinkPedigree() call", {
  skip_if_not_installed("kinship2")
  ex <- shrinkExampleObjects()
  ped <- ex$ped
  k <- kinship2::pedigree(ped$id, ped$sire, ped$dam,
                          sex = c(M = 1L, F = 2L)[ped$sex], missid = NA)
  theirs <- kinship2::pedigree.shrink(
    k, avail = as.integer(ped$id %in% c("F", "G")), maxBits = 16L
  )
  expect_identical(sort(theirs$idTrimmed), sort(ex$result$idTrimmed))
  expect_identical(sort(theirs$pedObj$id), sort(ex$result$ped$id))
  ## kinship2's bit sizes are doubles, pedkindraw's integers.
  expect_equal(theirs$bitSize, ex$result$bitSize)
})
