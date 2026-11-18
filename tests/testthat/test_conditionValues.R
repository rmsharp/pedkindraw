## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G1,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings R102-R104,
## pedkindraw S42). A condition column read as true-or-false: TRUE, FALSE and
## NA, the numbers 0 and 1 (kinship2's codes, which asPedFrame() writes from
## kinship2 and Pedixplorer), and text as.logical() reads. Any other number
## stops (R102), naming the column and its numbers; only numbers are reported
## (R103); at all three reads (R104): makePedigreeMatingLayout()'s drawn
## conditions, makePedigreeDiagramData()'s affected column, and the input
## check shrinkPedigree(), findAvailNonInform() and findAvailAffected()
## share. Text as.logical() cannot read still reads as unknown with no
## message (nprcgenekeepr issue #133; the copied tests in
## test_makePedigreeDiagramData.R and test_makePedigreeMatingLayout.R).
library(testthat)

## A and B, founders, with offspring C (male) and D (female): the gaps
## document's case measuredTrait (tools/gapCases.R).
.g1Ped <- function(affected = NULL) {
  ped <- data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
                    dam = c(NA, NA, "B", "B"), sex = c("M", "F", "M", "F"),
                    stringsAsFactors = FALSE)
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  if (!is.null(affected)) ped$affected <- affected
  ped
}

.g1Advice <- paste(
  "Give TRUE or FALSE (or 1 or 0) for each animal; for a measured trait,",
  "compare it with a threshold first."
)

test_that("makePedigreeMatingLayout() stops on a condition column holding numbers other than 0 and 1 (case measuredTrait)", {
  expect_error(
    makePedigreeMatingLayout(.g1Ped(c(2.5, 0.0, 0.3, 9.0))),
    paste0("makePedigreeMatingLayout(): the condition column 'affected' ",
           "holds numbers other than 0 and 1 (2.5, 0.3, 9). ", .g1Advice),
    fixed = TRUE
  )
})

test_that("makePedigreeMatingLayout() names the condition column that holds the numbers", {
  ped <- .g1Ped(c(TRUE, FALSE, NA, TRUE))
  ped$affected2 <- c(0L, 2L, 1L, 0L)
  expect_error(
    makePedigreeMatingLayout(ped),
    paste0("makePedigreeMatingLayout(): the condition column 'affected2' ",
           "holds numbers other than 0 and 1 (2)."),
    fixed = TRUE
  )
})

test_that("makePedigreeMatingLayout() checks an animal it leaves out of the drawing", {
  ## E has no parent, mate or offspring, so the layout leaves it out; its
  ## number is reported all the same: the column is checked before the layout
  ## drops anyone.
  ped <- .g1Ped(c(1, 0, 0, 1))
  ped <- rbind(ped, data.frame(id = "E", sire = NA, dam = NA, sex = "F",
                               gen = 0L, affected = 3))
  expect_error(
    makePedigreeMatingLayout(ped),
    "the condition column 'affected' holds numbers other than 0 and 1 (3).",
    fixed = TRUE
  )
})

test_that("makePedigreeMatingLayout() does not check a fifth condition column, which it does not draw", {
  ped <- .g1Ped(c(TRUE, FALSE, NA, TRUE))
  for (column in c("affected2", "affected3", "affected4")) {
    ped[[column]] <- c(FALSE, TRUE, FALSE, NA)
  }
  ped$affected5 <- c(2.5, 0.0, 0.3, 9.0)
  layout <- makePedigreeMatingLayout(ped)
  expect_identical(layout$conditionsNotDrawn, "affected5")
})

test_that("makePedigreeDiagramData() stops on an affected column holding numbers other than 0 and 1", {
  expect_error(
    makePedigreeDiagramData(.g1Ped(c(2.5, 0.0, 0.3, 9.0))),
    paste0("makePedigreeDiagramData(): the condition column 'affected' ",
           "holds numbers other than 0 and 1 (2.5, 0.3, 9). ", .g1Advice),
    fixed = TRUE
  )
})

test_that("the message lists the first five numbers, then '...'", {
  ped <- data.frame(id = as.character(1:7), sire = NA_character_,
                    dam = NA_character_, sex = "F", gen = 0L,
                    affected = c(2, 3, 4, 5, 6, 7, 0))
  expect_error(makePedigreeDiagramData(ped),
               "holds numbers other than 0 and 1 (2, 3, 4, 5, 6, ...).",
               fixed = TRUE)
})

test_that("a negative number and Inf are reported; NaN reads as unknown", {
  expect_error(makePedigreeDiagramData(.g1Ped(c(-1, 0, Inf, NaN))),
               "holds numbers other than 0 and 1 (-1, Inf).", fixed = TRUE)
  diagram <- makePedigreeDiagramData(.g1Ped(c(1, 0, NaN, NA)))
  expect_identical(diagram, makePedigreeDiagramData(.g1Ped(c(TRUE, FALSE,
                                                              NA, NA))))
})

test_that("shrinkPedigree() stops on an affected column holding numbers other than 0 and 1", {
  expect_error(
    shrinkPedigree(.g1Ped(c(2.5, 0.0, 0.3, 9.0)), genotyped = rep(TRUE, 4L)),
    paste0("affected holds numbers other than 0 and 1 (2.5, 0.3, 9). ",
           .g1Advice),
    fixed = TRUE
  )
})

test_that("shrinkPedigree(), findAvailNonInform() and findAvailAffected() stop on such an affected argument", {
  ped <- .g1Ped()
  typed <- rep(TRUE, 4L)
  numbers <- c(0, 2, 1, 0)
  message <- "affected holds numbers other than 0 and 1 (2)."
  expect_error(shrinkPedigree(ped, typed, affected = numbers), message,
               fixed = TRUE)
  expect_error(findAvailNonInform(ped, typed, affected = numbers), message,
               fixed = TRUE)
  expect_error(findAvailAffected(ped, typed, affected = numbers,
                                 affstatus = TRUE),
               message, fixed = TRUE)
})

test_that("the numbers 0 and 1, double or integer, with NA, read as FALSE and TRUE at all three reads", {
  ## maxBits = 0 runs the affected-priority trim, which reads the status;
  ## the returned pedigree keeps the column as given, so it is left out.
  shrunk <- function(ped) {
    result <- shrinkPedigree(ped, rep(TRUE, 4L), maxBits = 0L)
    result$ped$affected <- NULL
    result
  }
  logical <- .g1Ped(c(TRUE, FALSE, NA, TRUE))
  for (numbers in list(c(1, 0, NA, 1), c(1L, 0L, NA, 1L))) {
    ped <- .g1Ped(numbers)
    expect_identical(makePedigreeMatingLayout(ped),
                     makePedigreeMatingLayout(logical))
    expect_identical(makePedigreeDiagramData(ped),
                     makePedigreeDiagramData(logical))
    expect_identical(shrunk(ped), shrunk(logical))
  }
})

test_that("a kinship2 pedigree converted by asPedFrame() draws as before (its 0 and 1)", {
  skip_if_not_installed("kinship2")
  k2 <- kinship2::pedigree(id = c("A", "B", "C", "D"),
                           dadid = c(NA, NA, "A", "A"),
                           momid = c(NA, NA, "B", "B"), sex = c(1, 2, 1, 2),
                           affected = c(TRUE, FALSE, NA, TRUE), missid = NA)
  ped <- asPedFrame(k2)$ped
  expect_identical(ped$affected, c(1, 0, NA, 1))
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  logical <- ped
  logical$affected <- c(TRUE, FALSE, NA, TRUE)
  expect_identical(makePedigreeMatingLayout(ped),
                   makePedigreeMatingLayout(logical))
})
