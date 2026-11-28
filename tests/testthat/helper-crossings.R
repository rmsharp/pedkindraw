## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (H1, R175,
## pedkindraw S104). It serves test_layoutTieOrder.R: the places where two
## solid lines of a layout cross, as S103's counter for the hand test's
## finding 3 counts them (docs/planning/cran-handtest-crossings.R). The dashed
## lines that join an animal drawn twice are left out (the drawing bends
## them), and two lines that meet at an end are joined there, not crossed.

## The pairs of a layout's solid lines that cross, each as
## "from-to x from-to"; character(0) when none does.
solidLineCrossings <- function(layout) {
  nodes <- layout$nodes
  edges <- layout$edges
  if ("dashes" %in% names(edges)) {
    edges <- edges[!vapply(edges$dashes, isTRUE, logical(1L)), , drop = FALSE]
  }
  at <- function(id) {
    row <- match(id, nodes$id)
    cbind(nodes$x[row], nodes$y[row])
  }
  from <- at(edges$from)
  to <- at(edges$to)
  ## The side of the line through a and b that p lies on: -1, 0 or 1.
  side <- function(a, b, p) {
    sign((b[[1L]] - a[[1L]]) * (p[[2L]] - a[[2L]]) -
           (b[[2L]] - a[[2L]]) * (p[[1L]] - a[[1L]]))
  }
  samePoint <- function(p, q) all(abs(p - q) < 1e-6)
  found <- character(0L)
  n <- nrow(edges)
  for (i in seq_len(max(n - 1L, 0L))) {
    for (j in (i + 1L):n) {
      p1 <- from[i, ]
      p2 <- to[i, ]
      q1 <- from[j, ]
      q2 <- to[j, ]
      if (samePoint(p1, q1) || samePoint(p1, q2) || samePoint(p2, q1) ||
            samePoint(p2, q2)) {
        next
      }
      if (side(p1, p2, q1) * side(p1, p2, q2) < 0 &&
            side(q1, q2, p1) * side(q1, q2, p2) < 0) {
        found <- c(found, sprintf("%s-%s x %s-%s", edges$from[[i]],
                                  edges$to[[i]], edges$from[[j]],
                                  edges$to[[j]]))
      }
    }
  }
  found
}
