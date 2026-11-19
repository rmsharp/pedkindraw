## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G10, gap
## C3 of docs/research/pedkindraw-gaps-2026-11-18.md, rulings R127-R128,
## pedkindraw S51). makePedigreeMatingLayout() returns the hints it used as
## the element `hints`, in the form its argument `hints` takes, so that
## passing them back gives the same layout:
## - `order` numbers each drawn animal with a parent by its row in the rows
##   the layout drew from (animals with no relative left out, the caller's
##   order applied); a founder is numbered only where the caller's order
##   named it, because naming a founder turns off the layout's own ordering
##   of founder lines.
## - `mate` is the caller's own rows, as given, then a row for each other
##   mating whose partners both have rows: `left` and `right` as drawn,
##   `anchor` the partner the offspring hang under. An animal that anchors
##   three or more matings, or one the caller's rows already place, gets no
##   row for its matings, since a row there can change how far its mates are
##   drawn.
## Measured before RED on a prototype (S51): passed back, the same layout in
## every case: the fixtures, the twins pedigree in both line styles, 400
## seeded random family pedigrees with and without the caller's hints, and 15
## colony cases with the caller's mate rows. Numbering the founders by where
## they are drawn gave the same layout in 34 of 60 random pedigrees; a row
## for every mating moved animals in 6 of 12 fixture runs, each with an
## animal of three or more matings.

## The help example's seven animals: A and B, founders, with C and D; E, a
## founder, D's mate; F and G, their offspring.
returnedSeven <- function() {
  layoutHintsPed(
    id = c("A", "B", "C", "D", "E", "F", "G"),
    sire = c(NA, NA, "A", "A", NA, "D", "D"),
    dam = c(NA, NA, "B", "B", NA, "E", "E"),
    sex = c("M", "F", "F", "M", "F", "M", "F")
  )
}

## The seven, and D's offspring with more mates: H (I), then J (K).
returnedMates <- function(mates) {
  ped <- returnedSeven()
  more <- list(H = c("I", "M"), J = c("K", "F"))[mates]
  for (dam in names(more)) {
    ped <- rbind(ped, data.frame(
      id = c(dam, more[[dam]][[1L]]), sire = c(NA, "D"), dam = c(NA, dam),
      sex = c("F", more[[dam]][[2L]]), gen = 0L, stringsAsFactors = FALSE
    ))
  }
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

## A layout and the layout made from its own hints, messages muffled (an
## animal with no relative is named in one). Before the hints are passed
## back, they must be there: passing back none would give the same layout
## whatever the layout returned.
returnedLayout <- function(ped, ...) {
  suppressMessages(makePedigreeMatingLayout(ped, ...))
}
returnedAgain <- function(ped, layout, ...) {
  expect_named(layout[["hints"]], c("order", "mate"))
  returnedLayout(ped, hints = layout[["hints"]], ...)
}

## A mate hint with no rows, as the layout returns it.
returnedNoMate <- function() {
  data.frame(left = character(), right = character(), anchor = character(),
             stringsAsFactors = FALSE)
}

test_that("the layout returns the hints it used as its last element, a list
           of order and mate", {
  layout <- returnedLayout(returnedSeven())
  expect_identical(names(layout),
                   c("nodes", "edges", "duplicateToReal", "isolatedIds",
                     "conditions", "conditionsNotDrawn", "hints"))
  expect_identical(names(layout$hints), c("order", "mate"))
  expect_type(layout$hints$order, "double")
  expect_s3_class(layout$hints$mate, "data.frame")
  expect_identical(names(layout$hints$mate), c("left", "right", "anchor"))
  expect_identical(vapply(layout$hints$mate, typeof, ""),
                   c(left = "character", right = "character",
                     anchor = "character"))
})

test_that("order numbers each drawn animal with a parent by its row; the
           founders are left out", {
  layout <- returnedLayout(returnedSeven())
  expect_identical(layout$hints$order, c(C = 3, D = 4, F = 6, G = 7))
})

test_that("mate has a row per mating, left and right as drawn, anchor the
           partner the offspring hang under", {
  layout <- returnedLayout(returnedSeven())
  expect_identical(layout$hints$mate,
                   layoutHintsMate(c("A", "D"), c("B", "E"), "left"))
})

test_that("passing the hints back gives the same layout, in both line
           styles", {
  ped <- returnedSeven()
  rectilinear <- returnedLayout(ped)
  expect_identical(returnedAgain(ped, rectilinear), rectilinear)
  direct <- returnedLayout(ped, edgeStyle = "direct")
  expect_identical(returnedAgain(ped, direct, edgeStyle = "direct"), direct)
})

test_that("an animal with no relative gets no number and moves no other
           animal's", {
  seven <- returnedSeven()
  ped <- rbind(layoutHintsPed("X", NA, NA, "F"), seven)
  layout <- returnedLayout(ped)
  expect_identical(layout$isolatedIds, "X")
  expect_identical(layout$hints, returnedLayout(seven)$hints)
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("the caller's order is applied first, and the founders it names
           keep a number", {
  ped <- returnedSeven()
  layout <- returnedLayout(ped, hints = list(order = c(E = 1, B = 2)))
  expect_identical(layout$hints$order,
                   c(E = 2, C = 3, D = 4, B = 5, F = 6, G = 7))
  expect_identical(layout$hints$mate,
                   layoutHintsMate(c("A", "D"), c("B", "E"), "left"))
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("an animal with two matings gets a row for each", {
  ped <- returnedMates("H")
  layout <- returnedLayout(ped)
  expect_identical(layout$hints$order,
                   c(C = 3, D = 4, F = 6, G = 7, I = 9))
  expect_identical(layout$hints$mate,
                   layoutHintsMate(c("A", "E", "D"), c("B", "D", "H"),
                                   c("left", "right", "left")))
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("the caller's mate rows come first, as given, and the animal they
           place gets no other row", {
  ped <- returnedMates("H")
  layout <- returnedLayout(
    ped, hints = list(mate = layoutHintsMate("H", "D", "right"))
  )
  expect_identical(layout$hints$mate,
                   layoutHintsMate(c("H", "A"), c("D", "B"),
                                   c("right", "left")))
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("an animal with three or more matings gets no row for any of
           them", {
  ped <- returnedMates(c("H", "J"))
  layout <- returnedLayout(ped)
  expect_identical(layout$hints$mate, layoutHintsMate("A", "B", "left"))
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("with every animal left out, the hints are empty, and passing them
           back gives the same layout", {
  ped <- layoutHintsPed(c("A", "B"), c(NA, NA), c(NA, NA), c("M", "F"))
  layout <- returnedLayout(ped)
  expect_identical(layout$hints,
                   list(order = stats::setNames(numeric(), character()),
                        mate = returnedNoMate()))
  expect_identical(returnedAgain(ped, layout), layout)
})

test_that("on qcPed, passing the hints back gives the same layout: 156
           animals numbered, 150 of its 153 matings, none of N2XF08's
           three", {
  skip_on_cran()
  ## The layout warns that 5 same-row line collisions on qcPed could not be
  ## resolved, once per call.
  expect_warning(layout <- makePedigreeMatingLayout(qcPed), "collision")
  expect_named(layout[["hints"]], c("order", "mate"))
  expect_warning(again <- makePedigreeMatingLayout(qcPed,
                                                   hints = layout$hints),
                 "collision")
  expect_identical(again, layout)
  expect_length(layout$hints$order, 156L)
  expect_identical(nrow(layout$hints$mate), 150L)
  expect_length(unique(qcPed$dam[qcPed$sire %in% "N2XF08"]), 3L)
  expect_false(any(c(layout$hints$mate$left, layout$hints$mate$right) ==
                     "N2XF08"))
})

test_that("on 40 seeded random family pedigrees, with no hints, the caller's
           order, half an order or some mate rows, passing the hints back
           gives the same layout", {
  skip_on_cran()
  seeds <- Filter(function(s) nrow(layoutHintsFamilies(s)) <= 150L,
                  seq_len(200L))[seq_len(40L)]
  same <- logical()
  sibships <- logical()
  rowsAsDrawn <- logical()
  for (k in seq_along(seeds)) {
    seed <- seeds[[k]]
    ped <- layoutHintsFamilies(seed)
    order <- layoutHintsRandomOrder(ped, seed)
    given <- switch(k %% 4L + 1L,
      NULL,
      list(order = order),
      list(order = order[seq_len(length(order) %/% 2L)]),
      {
        drawn <- layoutHintsMatings(
          returnedLayout(ped, edgeStyle = "direct")
        )
        if (is.null(drawn)) {
          NULL
        } else {
          pick <- drawn[seq(1L, nrow(drawn), by = 2L), , drop = FALSE]
          list(mate = layoutHintsMate(pick$right, pick$left))
        }
      }
    )
    layout <- returnedLayout(ped, edgeStyle = "direct", hints = given)
    same <- c(same, identical(
      returnedAgain(ped, layout, edgeStyle = "direct"), layout
    ))
    sibships <- c(sibships,
                  layoutHintsSibshipsInOrder(ped, layout, layout$hints$order))
    ## Each row the layout added (after the caller's): its pair as drawn
    ## (no rows to check while the layout returns no hints).
    mate <- layout[["hints"]][["mate"]]
    if (is.null(mate)) next
    added <- mate[seq_len(nrow(mate)) > NROW(given$mate), , drop = FALSE]
    drawn <- layoutHintsMatings(layout)
    at <- match(layoutHintsPairKey(added$left, added$right),
                layoutHintsPairKey(drawn$left, drawn$right))
    rowsAsDrawn <- c(rowsAsDrawn, !is.na(at) &
                       added$left == drawn$left[at] &
                       added$right == drawn$right[at])
  }
  expect_length(same, 40L)
  expect_true(all(same))
  expect_gte(length(sibships), 429L)
  expect_true(all(sibships))
  expect_gte(length(rowsAsDrawn), 447L)
  expect_true(all(rowsAsDrawn))
})
