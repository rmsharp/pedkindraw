## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 15b,
## rulings R60-R63, pedkindraw S23). makePedigreeMatingLayout(hints =
## list(mate = )) draws a mate on the hinted side of its partner and hangs
## the offspring under the hinted partner (docs/planning/
## layout-hints-design.md, sections 7 and 9). Mark's picks at S23's pre-RED
## picker: strict checks; no anchor on the partner of the earlier
## generation; an animal with several mates drawn as kinship2 draws it (its
## families follow its mates, mates hinted to one side in the order of the
## hint's rows); the element named 'mate', not kinship2's 'spouse'. Every
## expected value was computed with a scratch prototype before this file was
## written (Learning 18). Helpers: helper-layoutHints.R. Plan Phase G10
## (pedkindraw S51, R127-R128): the layout returns the hints it used, which
## record the rows a caller gave, so the three checks that a hint asking for
## the drawing as it is gives the plain layout compare the layouts without
## their hints (layoutHintsDrawn()).
library(testthat)

layoutHintsQuiet <- function(ped, ...) {
  suppressMessages(makePedigreeMatingLayout(ped, ...))
}
layoutHintsMated <- function(ped, hintMate, ...) {
  layoutHintsQuiet(ped, hints = list(mate = hintMate), ...)
}
## A layout without its hints: what it draws.
layoutHintsDrawn <- function(layout) {
  layout[names(layout) != "hints"]
}

## A x B have C, D, E; D x F have G, H (the design's M1).
pedM1 <- layoutHintsPed(
  id = c("A", "B", "C", "D", "E", "F", "G", "H"),
  sire = c(NA, NA, "A", "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", "B", NA, "F", "F"),
  sex = c("M", "F", "F", "M", "M", "F", "M", "F")
)
## Sire A, offspring of P x Q, has offspring with dams B and C.
pedTwoDams <- layoutHintsPed(
  id = c("P", "Q", "A", "B", "C", "K1", "K2", "K3", "K4"),
  sire = c(NA, NA, "P", NA, NA, "A", "A", "A", "A"),
  dam = c(NA, NA, "Q", NA, NA, "B", "B", "C", "C"),
  sex = c("M", "F", "M", "F", "F", "M", "F", "M", "F")
)
## Sire A, offspring of P x Q, has offspring with dams B, C and D.
pedThreeDams <- layoutHintsPed(
  id = c("P", "Q", "A", "B", "C", "D", "K1", "K2", "K3"),
  sire = c(NA, NA, "P", NA, NA, NA, "A", "A", "A"),
  dam = c(NA, NA, "Q", NA, NA, NA, "B", "C", "D"),
  sex = c("M", "F", "M", "F", "F", "F", "M", "F", "M")
)
## Sire A (offspring of P x Q) and dam C (offspring of R x S), one
## generation, have K1 and K2.
pedAnchor <- layoutHintsPed(
  id = c("P", "Q", "R", "S", "A", "B", "C", "D", "K1", "K2"),
  sire = c(NA, NA, NA, NA, "P", "P", "R", "R", "A", "A"),
  dam = c(NA, NA, NA, NA, "Q", "Q", "S", "S", "C", "C"),
  sex = c("M", "F", "M", "F", "M", "F", "F", "M", "M", "F")
)

test_that("a mate hint draws a mate on the hinted side (the design's M6), as
           kinship2 draws it", {
  expect_identical(layoutHintsRowText(layoutHintsQuiet(pedM1)),
                   "A B / C D F E / G H")
  ## The dam B left of the sire A: the male-left rule is turned off.
  expect_identical(
    layoutHintsRowText(layoutHintsMated(pedM1, layoutHintsMate("B", "A"))),
    "B A / C D F E / G H"
  )
  expect_identical(
    layoutHintsRowText(layoutHintsMated(pedM1, layoutHintsMate("F", "D"))),
    "A B / C F D E / G H"
  )
  both <- layoutHintsMated(pedM1, layoutHintsMate(c("B", "F"), c("A", "D")))
  expect_identical(layoutHintsRowText(both), "B A / C F D E / G H")
  ## Factor columns draw the same.
  expect_identical(
    layoutHintsMated(pedM1, data.frame(left = c("B", "F"),
                                       right = c("A", "D"),
                                       anchor = "either",
                                       stringsAsFactors = TRUE)),
    both
  )
  ## The edge style does not move an animal.
  expect_identical(
    layoutHintsX(layoutHintsMated(pedM1, layoutHintsMate(c("B", "F"),
                                                         c("A", "D")),
                                  edgeStyle = "direct")),
    layoutHintsX(both)
  )
})

test_that("no hint, mate = NULL, a mate hint with no rows and a hint that
           asks for the drawing as it is all give the layout of no hint", {
  plain <- layoutHintsQuiet(pedM1)
  expect_identical(layoutHintsQuiet(pedM1, hints = list(mate = NULL)), plain)
  expect_identical(
    layoutHintsMated(pedM1, layoutHintsMate(character(0L), character(0L),
                                            character(0L))),
    plain
  )
  expect_identical(
    layoutHintsQuiet(pedM1, hints = list(order = NULL, mate = NULL)),
    plain
  )
  expect_identical(
    layoutHintsDrawn(layoutHintsMated(pedM1, layoutHintsMate("A", "B"))),
    layoutHintsDrawn(plain)
  )
  expect_identical(
    layoutHintsDrawn(
      layoutHintsMated(pedM1, layoutHintsMate(c("A", "D"), c("B", "F")))
    ),
    layoutHintsDrawn(plain)
  )
})

test_that("an anchor hangs the offspring under the hinted partner, the other
           partner drawn beside it as a repeat node", {
  plain <- layoutHintsQuiet(pedAnchor)
  expect_identical(layoutHintsRowTextAll(plain),
                   "P Q R S / A C' B C D / K1 K2")
  expect_identical(unname(plain$duplicateToReal), "C")
  expect_identical(
    layoutHintsDrawn(
      layoutHintsMated(pedAnchor, layoutHintsMate("A", "C", "left"))
    ),
    layoutHintsDrawn(plain)
  )
  dam <- layoutHintsMated(pedAnchor, layoutHintsMate("A", "C", "right"))
  expect_identical(layoutHintsRowTextAll(dam), "P Q R S / A B A' C D / K1 K2")
  expect_identical(unname(dam$duplicateToReal), "A")
  x <- layoutHintsX(dam)
  expect_gt(min(x[c("K1", "K2")]), x[["B"]])
  expect_identical(
    layoutHintsRowTextAll(layoutHintsMated(pedAnchor,
                                           layoutHintsMate("C", "A", "left"))),
    "P Q R S / A B C A' D / K1 K2"
  )
  expect_identical(
    layoutHintsRowTextAll(layoutHintsMated(pedAnchor,
                                           layoutHintsMate("C", "A",
                                                           "right"))),
    "P Q R S / C' A B C D / K1 K2"
  )
})

test_that("a sire with two or three dams is drawn as kinship2 draws it: his
           families follow his mates, mates hinted to one side in the order
           of the hint's rows", {
  rows <- function(ped, hintMate) {
    layoutHintsRowText(layoutHintsMated(ped, hintMate))
  }
  expect_identical(layoutHintsRowText(layoutHintsQuiet(pedTwoDams)),
                   "P Q / B A C / K1 K2 K3 K4")
  ## One mate hinted: the other dam takes the other side.
  expect_identical(rows(pedTwoDams, layoutHintsMate("A", "B")),
                   "P Q / C A B / K3 K4 K1 K2")
  expect_identical(rows(pedTwoDams, layoutHintsMate("C", "A")),
                   "P Q / C A B / K3 K4 K1 K2")
  ## Both to one side, in the order of the rows.
  expect_identical(rows(pedTwoDams, layoutHintsMate(c("A", "A"), c("B", "C"))),
                   "P Q / A B C / K1 K2 K3 K4")
  expect_identical(rows(pedTwoDams, layoutHintsMate(c("A", "A"), c("C", "B"))),
                   "P Q / A C B / K3 K4 K1 K2")
  expect_identical(rows(pedTwoDams, layoutHintsMate(c("B", "C"), c("A", "A"))),
                   "P Q / B C A / K1 K2 K3 K4")
  expect_identical(layoutHintsRowText(layoutHintsQuiet(pedThreeDams)),
                   "P Q / B A C D / K1 K2 K3")
  expect_identical(
    rows(pedThreeDams, layoutHintsMate(c("A", "A", "A"), c("D", "B", "C"))),
    "P Q / A D B C / K3 K1 K2"
  )
  expect_identical(
    rows(pedThreeDams, layoutHintsMate(c("D", "B", "C"), c("A", "A", "A"))),
    "P Q / D B C A / K3 K1 K2"
  )
  ## Unhinted dams sit nearest the sire.
  expect_identical(rows(pedThreeDams, layoutHintsMate("A", "B")),
                   "P Q / C A D B / K2 K3 K1")
  expect_identical(rows(pedThreeDams, layoutHintsMate("D", "A")),
                   "P Q / D A B C / K3 K1 K2")
  expect_identical(
    rows(pedThreeDams, layoutHintsMate(c("B", "A"), c("A", "C"))),
    "P Q / B A D C / K1 K3 K2"
  )
})

test_that("a founder sire drawn at each of his matings takes each hint at
           that mating", {
  ## A has no parents, so each dam anchors her mating and A is drawn again
  ## (A') at the second.
  ped <- layoutHintsPed(
    id = c("A", "B", "C", "K1", "K2", "K3", "K4"),
    sire = c(NA, NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, NA, "B", "B", "C", "C"),
    sex = c("M", "F", "F", "M", "F", "M", "F")
  )
  expect_identical(layoutHintsRowTextAll(layoutHintsQuiet(ped)),
                   "A B A' C / K1 K2 K3 K4")
  expect_identical(
    layoutHintsRowTextAll(layoutHintsMated(ped, layoutHintsMate("C", "A"))),
    "A B C A' / K1 K2 K3 K4"
  )
  expect_identical(
    layoutHintsRowTextAll(layoutHintsMated(ped, layoutHintsMate(c("B", "C"),
                                                                c("A", "A")))),
    "B A C A' / K1 K2 K3 K4"
  )
})

test_that("an order hint and a mate hint work together", {
  hinted <- layoutHintsQuiet(pedM1, hints = list(
    order = c(E = 1, D = 2, C = 3, H = 4, G = 5),
    mate = layoutHintsMate(c("B", "F"), c("A", "D"))
  ))
  expect_identical(layoutHintsRowText(hinted), "B A / E F D C / H G")
})

test_that("makePedigreeMatingLayout() stops on a mate hint it cannot use", {
  lay <- function(hintMate, ped = pedM1) {
    makePedigreeMatingLayout(ped, hints = list(mate = hintMate))
  }
  expect_error(lay(cbind(left = "B", right = "A", anchor = "either")),
               "requires 'hints\\$mate' to be a data frame")
  expect_error(lay(data.frame(left = "B", right = "A")),
               "columns left, right and anchor. Missing: anchor")
  expect_error(lay(layoutHintsMate(NA, "A")), "found NA in 'hints\\$mate'")
  expect_error(lay(layoutHintsMate("A", "A")),
               "same id as left and right in 'hints\\$mate': A")
  expect_error(lay(layoutHintsMate("A", "Q")), "not in 'ped': Q")
  ## A sire with no row of its own is not in 'ped'.
  dangling <- data.frame(id = c("A", "B", "C", "K"),
                         sire = c(NA, NA, "A", "S"),
                         dam = c(NA, NA, "B", "B"),
                         sex = c("M", "F", "M", "F"),
                         gen = c(0L, 0L, 1L, 1L),
                         stringsAsFactors = FALSE)
  expect_error(lay(layoutHintsMate("S", "B"), dangling), "not in 'ped': S")
  expect_error(lay(layoutHintsMate("A", "F")),
               "no offspring together in 'ped': A and F")
  expect_error(lay(layoutHintsMate(c("A", "B"), c("B", "A"))),
               "named more than once in 'hints\\$mate': B and A")
  expect_error(lay(layoutHintsMate("B", "A", "bogus")),
               "\"left\", \"right\" or \"either\". Found: bogus")
  expect_error(lay(layoutHintsMate("B", "A", NA)),
               "\"left\", \"right\" or \"either\". Found: NA")
  ## F, a founder (generation 0), cannot anchor its mating with D
  ## (generation 1); "either" and D are fine.
  expect_error(lay(layoutHintsMate("F", "D", "left")),
               "earlier generation.*F \\(generation 0\\) with D \\(generation 1\\)")
  expect_error(lay(layoutHintsMate("D", "F", "right")),
               "F \\(generation 0\\) with D \\(generation 1\\)")
  expect_identical(
    layoutHintsRowText(layoutHintsMated(pedM1,
                                        layoutHintsMate("F", "D", "right"))),
    "A B / C F D E / G H"
  )
  expect_error(makePedigreeMatingLayout(pedM1, hints = list(
    spouse = layoutHintsMate("B", "A")
  )), "does not know the 'hints' element\\(s\\): spouse. Known: order, mate.")
})

test_that("on 100 seeded random family pedigrees every hinted mate is drawn on
           its hinted side, an animal's families follow its mates, and an
           anchor flips wherever the partners share a generation", {
  skip_on_cran()
  sides <- logical(0L)
  follow <- logical(0L)
  anchors <- logical(0L)
  for (seed in 1L:100L) {
    ped <- layoutHintsFamilies(seed)
    base <- layoutHintsQuiet(ped, edgeStyle = "direct")
    drawn <- layoutHintsMatings(base)
    if (is.null(drawn)) next
    ## A fifth of the matings, hinted the other way round.
    pick <- withr::with_seed(2000L + seed, stats::runif(nrow(drawn)) < 1 / 5)
    if (any(pick)) {
      hint <- layoutHintsMate(drawn$right[pick], drawn$left[pick])
      lay <- layoutHintsMated(ped, hint, edgeStyle = "direct")
      got <- layoutHintsMatings(lay)
      got <- got[match(layoutHintsPairKey(hint$left, hint$right),
                       layoutHintsPairKey(got$left, got$right)), ]
      sides <- c(sides, got$left == hint$left)
      follow <- c(follow, layoutHintsFamiliesFollow(ped, lay))
    }
    ## Every mating whose partners share a generation: the other partner
    ## made the anchor, the sides as drawn.
    units <- .buildMatingUnitForest(
      ped[!ped$id %in% base$isolatedIds, , drop = FALSE]
    )$matingUnits
    gen <- stats::setNames(ped$gen, ped$id)
    units <- units[units$sire %in% ped$id & units$dam %in% ped$id &
                     gen[units$sire] == gen[units$dam], , drop = FALSE]
    if (nrow(units) == 0L) next
    asDrawn <- drawn[match(layoutHintsPairKey(units$sire, units$dam),
                           layoutHintsPairKey(drawn$left, drawn$right)), ]
    newAnchor <- units$nonAnchor
    hint <- layoutHintsMate(asDrawn$left, asDrawn$right,
                            ifelse(asDrawn$left == newAnchor, "left",
                                   "right"))
    lay <- layoutHintsMated(ped, hint, edgeStyle = "direct")
    got <- layoutHintsMatings(lay)
    got <- got[match(layoutHintsPairKey(hint$left, hint$right),
                     layoutHintsPairKey(got$left, got$right)), ]
    onLeft <- hint$anchor == "left"
    anchorNode <- ifelse(onLeft, got$leftNode, got$rightNode)
    otherNode <- ifelse(onLeft, got$rightNode, got$leftNode)
    other <- ifelse(onLeft, hint$right, hint$left)
    otherHasParents <- !is.na(ped$sire[match(other, ped$id)]) |
      !is.na(ped$dam[match(other, ped$id)])
    anchorY <- ifelse(onLeft, got$leftY, got$rightY)
    anchors <- c(anchors,
                 got$left == hint$left & anchorNode == newAnchor &
                   anchorY == got$dotY &
                   (!otherHasParents | grepl("^__dup_", otherNode)))
  }
  expect_gte(length(sides), 1090L)
  expect_true(all(sides))
  expect_gte(length(follow), 197L)
  expect_true(all(follow))
  expect_gte(length(anchors), 2525L)
  expect_true(all(anchors))
})

test_that("with the same mate hint, each row matches kinship2's
           align.pedigree() on the typed cases", {
  skip_if_not_installed("kinship2")
  same <- function(ped, hintMate, hintOrder = NULL) {
    hints <- list(mate = hintMate)
    if (!is.null(hintOrder)) hints$order <- hintOrder
    identical(
      layoutHintsRows(layoutHintsQuiet(ped, hints = hints)),
      layoutHintsKinship2MateRows(ped, hintMate, hintOrder)
    )
  }
  expect_true(same(pedM1, layoutHintsMate("B", "A")))
  expect_true(same(pedM1, layoutHintsMate("F", "D")))
  expect_true(same(pedM1, layoutHintsMate(c("B", "F"), c("A", "D"))))
  expect_true(same(pedM1, layoutHintsMate(c("B", "F"), c("A", "D")),
                   c(A = 1, B = 2, E = 3, D = 4, F = 5, C = 6, H = 7, G = 8)))
  twoDams <- list(
    layoutHintsMate("A", "B"), layoutHintsMate("B", "A"),
    layoutHintsMate("C", "A"), layoutHintsMate("A", "C"),
    layoutHintsMate(c("A", "A"), c("B", "C")),
    layoutHintsMate(c("A", "A"), c("C", "B")),
    layoutHintsMate(c("B", "C"), c("A", "A")),
    layoutHintsMate(c("C", "A"), c("A", "B"))
  )
  threeDams <- list(
    layoutHintsMate(c("A", "A", "A"), c("B", "C", "D")),
    layoutHintsMate(c("A", "A", "A"), c("D", "B", "C")),
    layoutHintsMate(c("B", "C", "D"), c("A", "A", "A")),
    layoutHintsMate(c("D", "B", "C"), c("A", "A", "A")),
    layoutHintsMate("A", "B"), layoutHintsMate("B", "A"),
    layoutHintsMate("D", "A"),
    layoutHintsMate(c("A", "A"), c("C", "B")),
    layoutHintsMate(c("C", "B"), c("A", "A")),
    layoutHintsMate(c("B", "A"), c("A", "C"))
  )
  compared <- 0L
  for (hintMate in twoDams) {
    expect_true(same(pedTwoDams, hintMate))
    compared <- compared + 1L
  }
  for (hintMate in threeDams) {
    expect_true(same(pedThreeDams, hintMate))
    compared <- compared + 1L
  }
  expect_identical(compared, 18L)
})
