## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (the backlog item
## "makePedigreeMatingLayout() stops on a pedigree with a parent id that has no
## row", rulings R162 and R163, pedkindraw S89). makePedigreeMatingLayout()
## (R/makePedigreeDiagramData.R, copied from nprcgenekeepr) stopped with R's
## own messages when an animal's only recorded parent has no row of its own:
## the positioner never reached that animal, and the forest drew a line to it
## from a parent no node stands for. Such a parent is not drawn, as the copied
## code intends for one (issue #154, S461, S682); the animal is drawn with no
## line up, as a founder is. A repeated id stops, naming it. Every expected
## value was computed with the change before this file was written (Learning
## 18).

## One animal whose sire has no row and whose dam is unknown.
noRowSirePed <- function() {
  data.frame(id = "A", sire = "X", dam = NA, sex = "F", gen = 1L,
             stringsAsFactors = FALSE)
}

## The real animals' places in a layout, as "id(x,y)" with x rounded.
realPlaces <- function(layout) {
  real <- layout$nodes[!startsWith(layout$nodes$id, "__"), ]
  paste0(real$id, "(", round(real$x, 2L), ",", real$y, ")")
}

test_that("an animal whose only recorded parent has no row is drawn with no
           line up, in both line styles", {
  for (style in c("rectilinear", "direct")) {
    layout <- makePedigreeMatingLayout(noRowSirePed(), edgeStyle = style)
    expect_identical(layout$nodes$id, "A")
    expect_identical(c(layout$nodes$x, layout$nodes$y), c(0, 150))
    expect_identical(nrow(layout$edges), 0L)
  }
})

test_that("such an animal beside a family is drawn on its own row's line, and
           the family as before", {
  ped <- data.frame(id = c("P", "Q", "R", "A"), sire = c(NA, NA, "P", "X"),
                    dam = c(NA, NA, "Q", NA), sex = c("M", "F", "M", "F"),
                    gen = c(0L, 0L, 1L, 1L), stringsAsFactors = FALSE)
  for (style in c("rectilinear", "direct")) {
    layout <- makePedigreeMatingLayout(ped, edgeStyle = style)
    expect_identical(realPlaces(layout), c("P(-59.85,0)", "Q(60.15,0)",
                                           "R(0.15,150)", "A(120.15,150)"))
    expect_false(any(c(layout$edges$from, layout$edges$to) %in% "X"))
    expect_false("A" %in% layout$edges$to)
  }
})

test_that("such an animal mated to a drawn animal anchors their mating, and
           their offspring hangs from it", {
  ped <- data.frame(id = c("G", "F", "H", "A", "K"),
                    sire = c(NA, NA, "G", "X", "H"),
                    dam = c(NA, NA, "F", NA, "A"),
                    sex = c("M", "F", "M", "F", "M"),
                    gen = c(0L, 0L, 1L, 1L, 2L), stringsAsFactors = FALSE)
  places <- c("G(-149.89,0)", "F(-29.89,0)", "H(-89.89,150)",
              "A(150.11,150)", "K(90.11,300)")
  direct <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  expect_identical(realPlaces(direct), places)
  expect_true(all(c("A>__union_2", "__dup_H_1>__union_2", "__union_2>K") %in%
                    paste(direct$edges$from, direct$edges$to, sep = ">")))
  rectilinear <- makePedigreeMatingLayout(ped)
  expect_identical(realPlaces(rectilinear), places)
  expect_true(all(c("__bar_K", "__drop___union_2") %in% rectilinear$nodes$id))
})

test_that("two siblings whose only recorded parent has no row are drawn side
           by side, not joined", {
  ped <- data.frame(id = c("A", "B"), sire = c("X", "X"), dam = NA,
                    sex = c("M", "F"), gen = 1L, stringsAsFactors = FALSE)
  for (style in c("rectilinear", "direct")) {
    layout <- makePedigreeMatingLayout(ped, edgeStyle = style)
    expect_identical(realPlaces(layout), c("A(0,150)", "B(120,150)"))
    expect_identical(nrow(layout$edges), 0L)
  }
})

test_that("the forest draws a line from a parent with a row, and none from a
           parent with no row", {
  ped <- data.frame(id = c("P", "A", "B"), sire = c(NA, "P", "X"), dam = NA,
                    sex = c("M", "F", "M"), gen = c(0L, 1L, 1L),
                    stringsAsFactors = FALSE)
  forest <- .buildMatingUnitForest(ped)
  expect_identical(forest$childEdges,
                   data.frame(from = "P", to = "A", stringsAsFactors = FALSE))
  layout <- makePedigreeMatingLayout(ped, edgeStyle = "direct")
  expect_identical(realPlaces(layout), c("P(0,0)", "A(0,150)", "B(120,150)"))
  expect_identical(paste(layout$edges$from, layout$edges$to), "P A")
})

test_that("every animal of a random pedigree with parents that have no row is
           placed, in both line styles", {
  skip_on_cran()
  ## Parents come from earlier rows, gen is each animal's depth, and one to
  ## three animals get a sire X1-X3 or a dam Y1-Y3 that has no row (the search
  ## of R163, smaller).
  randomPed <- function() {
    n <- sample(4:25, 1L)
    sex <- sample(c("M", "F"), n, replace = TRUE)
    id <- sprintf("I%02d", seq_len(n))
    sire <- dam <- rep(NA_character_, n)
    for (i in 3:n) {
      m <- which(sex[seq_len(i - 1L)] == "M")
      f <- which(sex[seq_len(i - 1L)] == "F")
      if (length(m) > 0L && stats::runif(1L) < 0.85) {
        sire[i] <- id[m[sample.int(length(m), 1L)]]
      }
      if (length(f) > 0L && stats::runif(1L) < 0.85) {
        dam[i] <- id[f[sample.int(length(f), 1L)]]
      }
    }
    for (r in sample.int(n, sample(1:3, 1L))) {
      if (stats::runif(1L) < 0.5) {
        sire[r] <- sprintf("X%d", sample(1:3, 1L))
      } else {
        dam[r] <- sprintf("Y%d", sample(1:3, 1L))
      }
    }
    gen <- integer(n)
    for (i in seq_len(n)) {
      rows <- match(c(sire[i], dam[i]), id)
      rows <- rows[!is.na(rows)]
      gen[i] <- if (length(rows) == 0L) 0L else 1L + max(gen[rows])
    }
    data.frame(id = id, sire = sire, dam = dam, sex = sex, gen = gen,
               stringsAsFactors = FALSE)
  }
  peds <- withr::with_seed(163L, replicate(20L, randomPed(), simplify = FALSE))
  ## The layout's documented warning, an edge-node collision it cannot clear,
  ## is muffled: these tests are of the places, not of the lines' routes.
  quiet <- function(expr) {
    withCallingHandlers(
      suppressMessages(expr),
      warning = function(w) {
        if (grepl("edge-node collision", conditionMessage(w), fixed = TRUE)) {
          invokeRestart("muffleWarning")
        }
      }
    )
  }
  placed <- 0L
  for (ped in peds) {
    for (style in c("rectilinear", "direct")) {
      layout <- quiet(makePedigreeMatingLayout(ped, edgeStyle = style))
      real <- layout$nodes[!startsWith(layout$nodes$id, "__"), ]
      expect_true(all(is.finite(real$x) & is.finite(real$y)))
      expect_true(all(real$id %in% ped$id))
      expect_false(any(layout$edges$to %in% real$id &
                         !layout$edges$from %in% layout$nodes$id))
      placed <- placed + nrow(real)
    }
  }
  expect_gte(placed, 550L)
})

test_that("an id on more than one row stops before any work, naming each
           repeated id once", {
  twoRows <- data.frame(id = c("A", "A"), sire = NA, dam = NA,
                        sex = c("M", "M"), gen = 0L, stringsAsFactors = FALSE)
  expect_error(
    expect_no_message(makePedigreeMatingLayout(twoRows)),
    paste0("makePedigreeMatingLayout() requires each id in 'ped' once: ",
           "on more than one row: A"),
    fixed = TRUE
  )
  family <- data.frame(id = c("A", "B", "A", "C", "B"),
                       sire = c(NA, NA, NA, "A", NA),
                       dam = c(NA, NA, NA, "B", NA),
                       sex = c("M", "F", "M", "F", "F"),
                       gen = c(0L, 0L, 0L, 1L, 0L), stringsAsFactors = FALSE)
  expect_error(makePedigreeMatingLayout(family),
               "on more than one row: A, B", fixed = TRUE)
  family$affected <- 2L
  expect_error(makePedigreeMatingLayout(family),
               "on more than one row: A, B", fixed = TRUE)
})
