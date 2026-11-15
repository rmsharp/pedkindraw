## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 15a,
## rulings R60-R63, pedkindraw S22). makePedigreeMatingLayout(hints =
## list(order = )) draws siblings, separate families and founder couples in
## the order of a number given per animal (docs/planning/
## layout-hints-design.md, sections 7 and 9). Mark's picks at S22's pre-RED
## pickers: animals the order leaves out keep their rows; a founder couple is
## placed by its female's number; the founder-reordering step is skipped only
## in a family whose founders the order names; no twin rule; strict checks.
## Every expected value was computed with a scratch prototype before this
## file was written (Learning 18). Helpers: helper-layoutHints.R.
library(testthat)

layoutHintsQuiet <- function(ped, ...) {
  suppressMessages(makePedigreeMatingLayout(ped, ...))
}
layoutHintsOrdered <- function(ped, hintOrder, ...) {
  layoutHintsQuiet(ped, hints = list(order = hintOrder), ...)
}

## A x B have C, D, E; D x F have G, H (the design's M1).
pedM1 <- layoutHintsPed(
  id = c("A", "B", "C", "D", "E", "F", "G", "H"),
  sire = c(NA, NA, "A", "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", "B", NA, "F", "F"),
  sex = c("M", "F", "F", "M", "M", "F", "M", "F")
)
## Three founder couples whose offspring marry across families: A x B, X x Y,
## P x Q; C x Z have K1, U x W have K2.
pedCouples <- layoutHintsPed(
  id = c("A", "B", "X", "Y", "P", "Q", "C", "D", "Z", "U", "W", "K1", "K2"),
  sire = c(NA, NA, NA, NA, NA, NA, "A", "A", "X", "X", "P", "C", "U"),
  dam = c(NA, NA, NA, NA, NA, NA, "B", "B", "Y", "Y", "Q", "Z", "W"),
  sex = c("M", "F", "M", "F", "M", "F", "M", "F", "F", "M", "F", "M", "F")
)

test_that("an order hint draws siblings in its order (the design's M1)", {
  expect_identical(layoutHintsRowText(layoutHintsQuiet(pedM1)),
                   "A B / C D F E / G H")
  hinted <- layoutHintsOrdered(pedM1, c(E = 1, D = 2, C = 3, H = 4, G = 5))
  expect_identical(layoutHintsRowText(hinted), "A B / E D F C / H G")
  ## Only the numbers' order matters: integers draw the same.
  expect_identical(
    layoutHintsOrdered(pedM1, c(E = 1L, D = 2L, C = 3L, H = 4L, G = 5L)),
    hinted
  )
  expect_identical(
    layoutHintsOrdered(pedM1, c(E = -10, D = 0, C = 0.5, H = 7, G = 100)),
    hinted
  )
})

test_that("no hint, an empty list, order = NULL and an empty order all give
           the layout of no hint", {
  plain <- layoutHintsQuiet(pedM1)
  expect_identical(layoutHintsQuiet(pedM1, hints = NULL), plain)
  expect_identical(layoutHintsQuiet(pedM1, hints = list()), plain)
  expect_identical(layoutHintsQuiet(pedM1, hints = list(order = NULL)), plain)
  expect_identical(layoutHintsQuiet(pedM1, hints = list(order = numeric(0L))),
                   plain)
  expect_identical(
    layoutHintsQuiet(pedM1, hints = list(
      order = stats::setNames(numeric(0L), character(0L))
    )),
    plain
  )
})

test_that("animals the order leaves out keep their rows; the named ones
           trade places among their own rows", {
  ## A x B have C, D, E, I; only I and E are named.
  ped <- layoutHintsPed(
    id = c("A", "B", "C", "D", "E", "I", "F", "G", "H"),
    sire = c(NA, NA, "A", "A", "A", "A", NA, "D", "D"),
    dam = c(NA, NA, "B", "B", "B", "B", NA, "F", "F"),
    sex = c("M", "F", "F", "M", "M", "F", "F", "M", "F")
  )
  expect_identical(layoutHintsRowText(layoutHintsQuiet(ped)),
                   "A B / C D F E I / G H")
  expect_identical(layoutHintsRowText(layoutHintsOrdered(ped, c(I = 1, E = 2))),
                   "A B / C D F I E / G H")
})

test_that("equal numbers keep their row order", {
  ties <- c(A = 1, B = 2, C = 3, D = 3, E = 3, F = 5, G = 8, H = 8)
  expect_identical(layoutHintsRowText(layoutHintsOrdered(pedM1, ties)),
                   "A B / C D F E / G H")
})

test_that("separate families are drawn in hinted order, and an order naming
           one family's siblings leaves the families where they were", {
  ped <- layoutHintsPed(
    id = c("A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4",
           "C1", "C2", "C3", "C4"),
    sire = c(NA, NA, "A1", "A1", NA, NA, "B1", "B1", NA, NA, "C1", "C1"),
    dam = c(NA, NA, "A2", "A2", NA, NA, "B2", "B2", NA, NA, "C2", "C2"),
    sex = rep(c("M", "F"), 6L)
  )
  expect_identical(layoutHintsRowText(layoutHintsQuiet(ped)),
                   "A1 A2 B1 B2 C1 C2 / A3 A4 B3 B4 C3 C4")
  familiesCAB <- stats::setNames(seq_len(12L), c(
    "C1", "C2", "C3", "C4", "A1", "A2", "A3", "A4", "B1", "B2", "B3", "B4"
  ))
  expect_identical(layoutHintsRowText(layoutHintsOrdered(ped, familiesCAB)),
                   "C1 C2 A1 A2 B1 B2 / C3 C4 A3 A4 B3 B4")
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(ped, c(B4 = 1, B3 = 2))),
    "A1 A2 B1 B2 C1 C2 / A3 A4 B4 B3 C3 C4"
  )
})

test_that("founder couples are placed by the female's number, as kinship2 and
           Pedixplorer place them", {
  expect_identical(layoutHintsRowText(layoutHintsQuiet(pedCouples)),
                   "A B X Y P Q / C D Z U W / K1 K2")
  ## The females alone: Q < Y < B.
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(pedCouples, c(Q = 1, Y = 2, B = 3))),
    "P Q X Y A B / W Z U C D / K2 K1"
  )
  ## Males A < X < P and females Q < Y < B: the females' order wins.
  maleAndFemale <- stats::setNames(seq_len(13L), c(
    "A", "X", "P", "Q", "Y", "B", "C", "D", "Z", "U", "W", "K1", "K2"
  ))
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(pedCouples, maleAndFemale)),
    "P Q X Y A B / W Z U C D / K2 K1"
  )
  ## A male whose mate is not named is placed by his own number.
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(pedCouples, c(P = 1, X = 2, A = 3))),
    "P Q X Y A B / W Z U C D / K2 K1"
  )
})

test_that("the founder-reordering step is skipped in a family whose founders
           the order names, and runs as before where it names none", {
  ## Seed 38 of the design's generator: without a hint the step moves the
  ## line of I1 (mate of I4) left of the line of I2.
  ped <- layoutHintsPed(
    id = c("I1", "I15", "I12", "I3", "I20", "I19", "I17", "I9", "I8", "I2",
           "I10", "I6", "I14", "I18", "I16", "I11", "I4", "I5", "I7", "I13"),
    sire = c(NA, "I9", "I8", NA, NA, NA, "I9", NA, "I3", NA, NA, "I1", "I8",
             NA, "I9", "I8", NA, "I1", "I1", "I8"),
    dam = c(NA, "I10", "I7", NA, NA, NA, "I10", NA, "I2", NA, NA, NA, "I7",
            NA, "I10", "I7", NA, "I4", "I4", "I7"),
    sex = c("M", "F", "F", "M", "F", "M", "F", "M", "M", "F", "F", "F", "M",
            "M", "M", "F", "F", "F", "F", "M")
  )
  plain <- "I1 I4 I3 I2 I9 I10 / I6 I5 I7 I8 I15 I17 I16 / I12 I14 I11 I13"
  expect_identical(layoutHintsRowText(layoutHintsQuiet(ped)), plain)
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(ped, c(I2 = 1, I4 = 2))),
    "I3 I2 I1 I4 I9 I10 / I8 I6 I5 I7 I15 I17 I16 / I12 I14 I11 I13"
  )
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(ped, c(I4 = 1, I2 = 2))),
    plain
  )
  ## Only siblings named: the founders stay where the step puts them.
  expect_identical(
    layoutHintsRowText(layoutHintsOrdered(ped, c(I16 = 1, I17 = 2, I15 = 3))),
    "I1 I4 I3 I2 I9 I10 / I6 I5 I7 I8 I16 I17 I15 / I12 I14 I11 I13"
  )
})

test_that("an order that puts a sibling between twins is drawn as given, the
           twin line crossing", {
  ped <- layoutHintsPed(
    id = c("A", "B", "C", "D", "E", "F"),
    sire = c(NA, NA, "A", "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B", "B"),
    sex = c("M", "F", "F", "M", "F", "M")
  )
  twins <- data.frame(id1 = "C", id2 = "E", code = "MZ twin",
                      stringsAsFactors = FALSE)
  between <- c(C = 1, F = 2, E = 3, D = 4)
  direct <- layoutHintsOrdered(ped, between, edgeStyle = "direct",
                               twinRelations = twins)
  expect_identical(layoutHintsRowText(direct), "A B / C F E D")
  expect_true(any(direct$edges$from == "C" & direct$edges$to == "E" &
                    direct$edges$label %in% "MZ"))
  routed <- layoutHintsOrdered(ped, between, twinRelations = twins)
  expect_identical(layoutHintsRowText(routed), "A B / C F E D")
  twinEdges <- routed$edges[routed$edges$label %in% "MZ", , drop = FALSE]
  expect_true("C" %in% twinEdges$from)
  expect_true("E" %in% twinEdges$to)
})

test_that("an order may name an animal the drawing leaves out as isolated", {
  ped <- rbind(pedM1, data.frame(id = "Z", sire = NA, dam = NA, sex = "M",
                                 gen = 0L, stringsAsFactors = FALSE))
  hinted <- NULL
  expect_message(
    hinted <- makePedigreeMatingLayout(ped, hints = list(
      order = c(Z = 0, E = 1, D = 2, C = 3, H = 4, G = 5)
    )),
    "suppressed"
  )
  expect_identical(hinted$isolatedIds, "Z")
  expect_identical(layoutHintsRowText(hinted), "A B / E D F C / H G")
})

test_that("makePedigreeMatingLayout() stops on hints it cannot use", {
  lay <- function(hints) makePedigreeMatingLayout(pedM1, hints = hints)
  expect_error(lay("E"), "requires 'hints' to be NULL or a list")
  expect_error(lay(data.frame(order = 1)),
               "requires 'hints' to be NULL or a list")
  expect_error(lay(list(c(E = 1))),
               "requires every element of 'hints' to be named")
  expect_error(lay(list(order = c(E = 1), c(D = 2))),
               "requires every element of 'hints' to be named")
  expect_error(lay(list(order = c(E = 1), spouse = data.frame())),
               "does not know the 'hints' element\\(s\\): spouse")
  expect_error(lay(list(order = c(E = "1"))),
               "requires 'hints\\$order' to be a numeric vector")
  expect_error(lay(list(order = c(E = TRUE))),
               "requires 'hints\\$order' to be a numeric vector")
  expect_error(lay(list(order = c(1, 2))),
               "requires every number in 'hints\\$order' to be named")
  expect_error(lay(list(order = c(E = 1, 2))),
               "requires every number in 'hints\\$order' to be named")
  expect_error(lay(list(order = c(E = 1, D = 2, E = 3))),
               "named more than once in 'hints\\$order': E")
  expect_error(lay(list(order = c(E = 1, Q = 2, R = 3))),
               "not in 'ped': Q, R")
  expect_error(lay(list(order = c(E = 1, D = NA))),
               "NA in 'hints\\$order' for: D")
  expect_error(lay(list(order = c(E = NaN))),
               "NA in 'hints\\$order' for: E")
})

test_that("on 100 seeded random family pedigrees every sibship and every
           family's founder lines are drawn in hinted order", {
  skip_on_cran()
  sibships <- logical(0L)
  founderLines <- logical(0L)
  for (seed in 1L:100L) {
    ped <- layoutHintsFamilies(seed)
    hintOrder <- layoutHintsRandomOrder(ped, seed)
    lay <- suppressWarnings(layoutHintsOrdered(ped, hintOrder))
    sibships <- c(sibships, layoutHintsSibshipsInOrder(ped, lay, hintOrder))
    founderLines <- c(founderLines,
                      layoutHintsFounderLinesInOrder(ped, lay, hintOrder))
  }
  expect_gte(length(sibships), 4670L)
  expect_true(all(sibships))
  expect_gte(length(founderLines), 201L)
  expect_true(all(founderLines))
})

test_that("with the same order, each row matches kinship2's align.pedigree()
           on the typed cases", {
  skip_if_not_installed("kinship2")
  agree <- function(ped, hintOrder) {
    layoutHintsRowsAgree(
      layoutHintsRows(layoutHintsOrdered(ped, hintOrder)),
      layoutHintsKinship2Rows(ped, hintOrder)
    )
  }
  expect_identical(
    agree(pedM1, c(A = 1, B = 2, E = 3, D = 4, F = 5, C = 6, H = 7, G = 8)),
    c(TRUE, TRUE, TRUE)
  )
  expect_identical(
    agree(pedM1, c(A = 1, B = 2, C = 3, D = 3, E = 3, F = 5, G = 8, H = 8)),
    c(TRUE, TRUE, TRUE)
  )
  ## The founder couples, 24 seeded orders of the six founders: the top two
  ## rows match. The bottom row (K1, K2) is left out: kinship2 draws the two
  ## cross-family couples side by side and repeats a partner, with or without
  ## a hint, and pedkindraw does not (S22 measured it matching in 360 of the
  ## 720 founder orders).
  compared <- 0L
  for (seed in 1L:24L) {
    founders <- withr::with_seed(seed, sample(c("A", "B", "X", "Y", "P", "Q")))
    hintOrder <- stats::setNames(seq_len(13L), c(
      founders, "C", "D", "Z", "U", "W", "K1", "K2"
    ))
    rows <- agree(pedCouples, hintOrder)
    expect_identical(rows[1:2], c(TRUE, TRUE))
    compared <- compared + 1L
  }
  expect_identical(compared, 24L)
})
