## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84, R161 and R162, pedkindraw S88): three cases of
## .resolveEdgeNodeCollisions() in R/makePedigreeDiagramData.R (copied from
## nprcgenekeepr, kept as copied) that no drawing gives it: no edges at all; a
## curved connector with no other node to clear; and a straight edge whose
## three jogs each land on a row holding another obstacle, so it is left as a
## residual. The tests call the function with hand-built tables. Every
## expected value was computed with the function before this file was
## written (Learning 18).

twoNodes <- function() {
  data.frame(id = c("A", "B"), x = c(0, 100), y = c(0, 0), size = c(10, 10),
             stringsAsFactors = FALSE)
}

test_that("no edges: the nodes are returned unchanged and nothing is left", {
  edges <- data.frame(from = character(), to = character(),
                      stringsAsFactors = FALSE)
  expect_silent(result <- .resolveEdgeNodeCollisions(twoNodes(), edges))
  expect_identical(result$nodes, twoNodes())
  expect_identical(result$edges, edges)
  expect_identical(nrow(result$residuals), 0L)
})

test_that("a curved connector with no other node to clear keeps its
           roundness", {
  edges <- data.frame(from = "A", to = "B", smooth.enabled = TRUE,
                      smooth.type = "curvedCW", smooth.roundness = 0.2,
                      stringsAsFactors = FALSE)
  expect_silent(result <- .resolveEdgeNodeCollisions(twoNodes(), edges))
  expect_identical(result$edges, edges)
  expect_identical(nrow(result$residuals), 0L)
  expect_identical(.arcDiscHitCount(c(0, 0), c(100, 0), 0.2,
                                    data.frame(x = numeric(), y = numeric(),
                                               size = numeric())),
                   0L)
})

test_that("a straight edge whose every jog lands on another obstacle is left
           as a residual after three passes", {
  ## Each row's widest node has size 10, so each jog moves down 11, onto the
  ## next obstacle's row.
  nodes <- data.frame(id = c("A", "B", "O0", "O1", "O2", "O3"),
                      x = c(0, 100, 50, 50, 50, 50), y = c(0, 0, 0, 11, 22, 33),
                      size = 10, stringsAsFactors = FALSE)
  edges <- data.frame(from = "A", to = "B", stringsAsFactors = FALSE)
  result <- .resolveEdgeNodeCollisions(nodes, edges)
  expect_identical(result$residuals,
                   data.frame(from = "__jog_3_a", to = "__jog_3_b",
                              kind = "straight-residual",
                              stringsAsFactors = FALSE))
  jogs <- result$nodes[startsWith(result$nodes$id, "__jog_"), ]
  expect_identical(jogs$y, c(11, 11, 22, 22, 33, 33))
  expect_identical(jogs$x, rep(c(0, 100), 3L))
})
