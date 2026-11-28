## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (H1, R175,
## pedkindraw S104). After its tree pass the layout centres each founder
## couple over its offspring, and that step can leave two animals of one row
## at one place. The sweep that then spaces each row put such a pair in the
## order of their ids, which could draw a couple on the far side of another
## couple from its offspring, so that their lines crossed, and could override
## an order hint: the hand test's finding 3, ED5PDV's drawing in "Getting
## started" (docs/planning/cran-submission-runbook.md, the record). Mark's
## pre-RED pick: a tie keeps the order the row had before the centring step.
## Every expected value was computed with a scratch prototype of that rule
## before this file was written (Learning 18). Helpers: helper-crossings.R
## (solidLineCrossings()) and helper-layoutHints.R (layoutHintsPed(),
## layoutHintsRowText(), layoutHintsX()).
library(testthat)

tieOrderQuiet <- function(ped, ...) {
  suppressMessages(makePedigreeMatingLayout(ped, ...))
}

## Q and Z have A; P and Y have B; B and A have C. Q's mating is placed by Q
## and P's by P (the partner whose id sorts first). The tree pass draws Q at
## 0 and P at 1; centring Q's couple over A moves Q right by half a place, and
## centring P's over B moves P left by half a place, so both reach 0.5, and P,
## whose id sorts first, was put left of Q, over Q's offspring A.
pedTie <- layoutHintsPed(
  id = c("Q", "Z", "P", "Y", "A", "B", "C"),
  sire = c(NA, NA, NA, NA, "Z", "P", "B"),
  dam = c(NA, NA, NA, NA, "Q", "Y", "A"),
  sex = c("F", "M", "M", "F", "F", "M", "M")
)

## ED5PDV and its 15 ancestors (vignette "pedkindraw", "Getting started";
## the fixture is the bundled file, byte for byte). Its three founder
## couples are named here by their dams.
pedED5PDV <- function() {
  ped <- read.csv(test_path("fixtures", "obfuscated_rhesus_mhc_ped.csv"),
                  stringsAsFactors = FALSE)
  getProbandPedigree(ped, "ED5PDV")
}
founderDams <- c("RKBTHH", "I8ABQE", "ZK6NM2")

test_that("solidLineCrossings() counts two solid lines that cross, and not
           two lines that meet at an end or a dashed line", {
  nodes <- data.frame(id = c("a", "b", "c", "d"), x = c(0, 2, 0, 2),
                      y = c(0, 2, 2, 0), stringsAsFactors = FALSE)
  crossed <- list(nodes = nodes, edges = data.frame(
    from = c("a", "c"), to = c("b", "d"), dashes = c(FALSE, FALSE),
    stringsAsFactors = FALSE
  ))
  expect_identical(solidLineCrossings(crossed), "a-b x c-d")
  joined <- list(nodes = nodes, edges = data.frame(
    from = c("a", "b"), to = c("b", "d"), dashes = c(FALSE, FALSE),
    stringsAsFactors = FALSE
  ))
  expect_identical(solidLineCrossings(joined), character(0L))
  dashed <- crossed
  dashed$edges$dashes <- c(FALSE, TRUE)
  expect_identical(solidLineCrossings(dashed), character(0L))
})

test_that("two founder couples centred to one place keep the tree pass's
           order: Q's couple over A, P's over B, no lines crossing", {
  layout <- tieOrderQuiet(pedTie)
  expect_identical(layoutHintsRowText(layout), "Z Q P Y / A B / C")
  expect_identical(solidLineCrossings(layout), character(0L))
})

test_that("an order hint is followed at that tie: Q = 1, Y = 2 draws Q's
           couple first, and Y = 1, Q = 2 draws P and Y's first", {
  qFirst <- tieOrderQuiet(pedTie, hints = list(order = c(Q = 1, Y = 2)))
  expect_identical(layoutHintsRowText(qFirst), "Z Q P Y / A B / C")
  expect_identical(solidLineCrossings(qFirst), character(0L))
  yFirst <- tieOrderQuiet(pedTie, hints = list(order = c(Y = 1, Q = 2)))
  expect_identical(layoutHintsRowText(yFirst), "P Y Z Q / B A / C")
  expect_identical(solidLineCrossings(yFirst), character(0L))
})

test_that("ED5PDV's drawing has no lines crossing (the hand test found 2)", {
  expect_identical(solidLineCrossings(tieOrderQuiet(pedED5PDV())),
                   character(0L))
})

test_that("each of the 6 orders of ED5PDV's three founder dams, given as an
           order hint, draws the dams in that order with no lines crossing", {
  ped <- pedED5PDV()
  orders <- list(c(1L, 2L, 3L), c(1L, 3L, 2L), c(2L, 1L, 3L),
                 c(2L, 3L, 1L), c(3L, 1L, 2L), c(3L, 2L, 1L))
  for (o in orders) {
    hinted <- founderDams[o]
    layout <- tieOrderQuiet(
      ped, hints = list(order = stats::setNames(seq_along(hinted), hinted))
    )
    x <- layoutHintsX(layout)
    expect_identical(founderDams[order(x[founderDams])], hinted,
                     info = toString(hinted))
    expect_identical(solidLineCrossings(layout), character(0L),
                     info = toString(hinted))
  }
})
