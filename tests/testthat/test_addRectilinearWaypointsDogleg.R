## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84, R161 and R162, pedkindraw S88): the D2 dogleg of
## .addRectilinearWaypoints() in R/makePedigreeDiagramData.R (copied from
## nprcgenekeepr, kept as copied). When a parent's node is on another row than
## its mating, the mate line is replaced by two edges through a projection
## node at the parent's x and the mating's y, which keep a marked
## (consanguineous) line's colour and width. No drawing reaches it: the layout
## puts every anchor and every non-anchor's node on its mating's row
## (test_addRectilinearWaypoints.R, "RESOLVED by issue #143's fix" and
## "#144's fix"), so these tests call the function with the layout's own
## tables and one node's row moved in 'pos'. Every expected value was computed
## with the function before this file was written (Learning 18).

doglegInputs <- function() {
  ## S x D have M and F; the full sibs M x F have C, a consanguineous mating
  ## whose two mate lines are marked. F anchors it; M is drawn as __dup_M_1.
  ped <- data.frame(id = c("S", "D", "M", "F", "C"),
                    sire = c(NA, NA, "S", "S", "M"),
                    dam = c(NA, NA, "D", "D", "F"),
                    sex = c("M", "F", "M", "F", "M"),
                    gen = c(0L, 0L, 1L, 1L, 2L), stringsAsFactors = FALSE)
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  forest <- .buildMatingUnitForest(ped)
  list(nodes = layout$nodes, edges = layout$edges, forest = forest,
       pos = .positionMatingUnitForest(ped, forest))
}

edgeRow <- function(edges, from, to) {
  edges[edges$from == from & edges$to == to, c("color", "width")]
}

test_that("the layout's own rows give no dogleg", {
  inputs <- doglegInputs()
  result <- .addRectilinearWaypoints(inputs$nodes, inputs$edges,
                                     inputs$forest, inputs$pos)
  expect_false(any(startsWith(result$nodes$id, "__proj_")))
  expect_identical(nrow(result$edges), 13L)
})

test_that("an anchor on another row than its mating is joined to it through
           a projection node that keeps the marked line's colour and width", {
  inputs <- doglegInputs()
  pos <- inputs$pos
  pos$gen[pos$id == "F"] <- 0L
  nodes <- inputs$nodes
  nodes$y[nodes$id == "F"] <- 0L
  result <- .addRectilinearWaypoints(nodes, inputs$edges, inputs$forest, pos)
  x <- stats::setNames(nodes$x, nodes$id)
  y <- stats::setNames(nodes$y, nodes$id)
  proj <- result$nodes[result$nodes$id == "__proj_F___union_2", ]
  expect_identical(nrow(proj), 1L)
  expect_identical(c(proj$x, proj$y), unname(c(x[["F"]], y[["__union_2"]])))
  expect_false(identical(y[["F"]], y[["__union_2"]]))
  expect_identical(proj$size, 0L)
  expect_identical(proj$color.background, "rgba(0,0,0,0)")
  marked <- data.frame(color = "#D55E00", width = 4)
  expect_equal(edgeRow(result$edges, "F", "__proj_F___union_2"), marked,
               ignore_attr = TRUE)
  expect_equal(edgeRow(result$edges, "__proj_F___union_2", "__union_2"),
               marked, ignore_attr = TRUE)
  expect_identical(nrow(edgeRow(result$edges, "F", "__union_2")), 0L)
  expect_identical(nrow(result$edges), 14L)
})

test_that("a non-anchor's duplicate on another row is joined the same way,
           its marker read from its own mate line", {
  inputs <- doglegInputs()
  pos <- inputs$pos
  pos$gen[pos$id == "__dup_M_1"] <- 2L
  ## The anchor's mate line unmarked by hand, so that only the duplicate's
  ## own line carries the marker.
  edges <- inputs$edges
  anchorLine <- edges$from == "F" & edges$to == "__union_2"
  edges$color[anchorLine] <- NA_character_
  edges$width[anchorLine] <- NA_real_
  result <- .addRectilinearWaypoints(inputs$nodes, edges, inputs$forest, pos)
  projId <- "__proj___dup_M_1___union_2"
  marked <- data.frame(color = "#D55E00", width = 4)
  expect_equal(edgeRow(result$edges, "__dup_M_1", projId), marked,
               ignore_attr = TRUE)
  expect_equal(edgeRow(result$edges, projId, "__union_2"), marked,
               ignore_attr = TRUE)
  expect_identical(nrow(edgeRow(result$edges, "__dup_M_1", "__union_2")), 0L)
  expect_equal(edgeRow(result$edges, "F", "__union_2"),
               data.frame(color = NA_character_, width = NA_real_),
               ignore_attr = TRUE)
})

test_that("an unmarked mate line's dogleg takes the waypoint colour and no
           width", {
  inputs <- doglegInputs()
  pos <- inputs$pos
  pos$gen[pos$id == "D"] <- -1L
  result <- .addRectilinearWaypoints(inputs$nodes, inputs$edges,
                                     inputs$forest, pos)
  plain <- data.frame(color = "#2B7CE9", width = NA_real_)
  expect_equal(edgeRow(result$edges, "D", "__proj_D___union_1"), plain,
               ignore_attr = TRUE)
  expect_equal(edgeRow(result$edges, "__proj_D___union_1", "__union_1"),
               plain, ignore_attr = TRUE)
  expect_identical(nrow(edgeRow(result$edges, "D", "__union_1")), 0L)
})
