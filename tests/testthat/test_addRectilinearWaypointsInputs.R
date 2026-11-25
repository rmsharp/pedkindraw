## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84, R161 and R162, pedkindraw S88): three kinds of input that
## .addRectilinearWaypoints() in R/makePedigreeDiagramData.R (copied from
## nprcgenekeepr, kept as copied) handles and the copied tests do not give it.
## A mating whose sire and dam both have no row (an orphan mating, issue #154)
## is reached through makePedigreeMatingLayout(). Tables without the colour
## columns, and a node whose row is unknown, are not: the layout always adds
## those columns and places every node, so those tests call the function with
## the layout's own tables changed by hand. Every expected value was computed
## with the function before this file was written (Learning 18).

orphanPed <- function() {
  data.frame(id = c("C", "D", "E"), sire = c("X", NA, "C"),
             dam = c("Y", NA, "D"), sex = c("M", "F", "F"),
             gen = c(1L, 1L, 2L), stringsAsFactors = FALSE)
}

test_that("an orphan mating gets its sibship bar and no dogleg", {
  layout <- makePedigreeMatingLayout(orphanPed())
  ids <- layout$nodes$id
  expect_true(all(c("__union_1", "__drop___union_1", "__bar_C") %in% ids))
  expect_false(any(startsWith(ids, "__proj_")))
  y <- stats::setNames(layout$nodes$y, ids)
  expect_identical(unname(y[c("C", "D", "E", "__bar_C", "__bar_E")]),
                   c(150, 150, 300, 90, 240))
})

test_that("an orphan mating does not end the dogleg check of the matings
           after it", {
  ped <- orphanPed()
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  forest <- .buildMatingUnitForest(ped)
  expect_identical(forest$matingUnits$anchor, c(NA, "C"))
  pos <- .positionMatingUnitForest(ped, forest)
  pos$gen[pos$id == "C"] <- 0L
  result <- .addRectilinearWaypoints(layout$nodes, layout$edges, forest, pos)
  expect_true("__proj_C___union_2" %in% result$nodes$id)
})

sibshipInputs <- function() {
  ped <- data.frame(id = c("P1", "P2", "C1", "C2"),
                    sire = c(NA, NA, "P1", "P1"), dam = c(NA, NA, "P2", "P2"),
                    sex = c("M", "F", "M", "F"), gen = c(0L, 0L, 1L, 1L),
                    stringsAsFactors = FALSE)
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  forest <- .buildMatingUnitForest(ped)
  list(nodes = layout$nodes, edges = layout$edges, forest = forest,
       pos = .positionMatingUnitForest(ped, forest))
}

test_that("tables without the colour columns get them, NA for what they
           held and the waypoint colour for what is added", {
  inputs <- sibshipInputs()
  edges <- inputs$edges
  edges$color <- NULL
  edges$width <- NULL
  nodes <- inputs$nodes
  nodes$color.background <- NULL
  result <- .addRectilinearWaypoints(nodes, edges, inputs$forest, inputs$pos)
  added <- startsWith(result$edges$from, "__") &
    !startsWith(result$edges$to, "__union_")
  expect_identical(result$edges$color[!added], c(NA_character_, NA_character_))
  expect_identical(result$edges$width[!added], c(NA_real_, NA_real_))
  expect_identical(unique(result$edges$color[added]), "#2B7CE9")
  expect_identical(unique(result$edges$width[added]), NA_real_)
  kept <- result$nodes$id %in% inputs$nodes$id
  expect_identical(result$nodes$color.background[kept], rep(NA_character_, 5L))
  expect_identical(unique(result$nodes$color.background[!kept]),
                   "rgba(0,0,0,0)")
})

test_that("a mating whose row is unknown has its sibship bar on its
           offspring's row", {
  inputs <- sibshipInputs()
  nodes <- inputs$nodes
  at <- .addRectilinearWaypoints(nodes, inputs$edges, inputs$forest,
                                 inputs$pos)
  barY <- function(result) {
    unique(result$nodes$y[startsWith(result$nodes$id, "__drop_") |
                            startsWith(result$nodes$id, "__bar_")])
  }
  expect_identical(barY(at), 90)
  nodes$y[nodes$id == "__union_1"] <- NA
  result <- .addRectilinearWaypoints(nodes, inputs$edges, inputs$forest,
                                     inputs$pos)
  expect_identical(barY(result), 150L)
})
