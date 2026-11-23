## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr
## tools/pedigreeComparison/tests/test_comparisonFormats.R at nprcgenekeepr
## commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md section 4.1, Phase
## 17h1). Changes: toBGmisc()'s test is dropped with BGmisc (R82, R153), and
## BGmisc's name with it from the opening comment; the path in the comment on
## how to run it.
## Tests for the Phase 1 comparison formats: one CSV per test pedigree,
## read the same way for every package, and the converters that hand it to
## kinship2 and Pedixplorer in each one's own coding
## (docs/planning/standalone-pedigree-package-plan.md, Phase 1 step 3).
## They live beside the comparison scripts, not in the package suite (Mark's
## ruling, S1122), and need no comparator package installed. Run from the
## project root:
##   Rscript -e 'testthat::test_file(
##     "tools/timing/tests/test_comparisonFormats.R")'

library(testthat) # nolint: undesirable_function_linter.

sourceComparisonScript("comparisonFormats.R")

## D has a sire only and E a dam only; C is of unknown sex, D hermaphrodite.
ped <- data.frame(
  id = c("A", "B", "C", "D", "E"),
  sire = c(NA, NA, "A", "A", NA),
  dam = c(NA, NA, "B", NA, "B"),
  sex = c("M", "F", "U", "H", "F"),
  birth = as.Date(c(
    "2000-01-01", "2000-02-01", "2005-03-01", "2005-04-01",
    "2006-05-01"
  )),
  stringsAsFactors = FALSE
)
csvFile <- function(lines) {
  f <- tempfile(fileext = ".csv")
  writeLines(lines, f)
  f
}

test_that("a pedigree written and read back is unchanged", {
  f <- tempfile(fileext = ".csv")
  writeComparisonPedigree(ped, f)
  expect_identical(readComparisonPedigree(f), ped)
})

test_that("writing returns the file's md5 checksum", {
  f <- tempfile(fileext = ".csv")
  sum <- writeComparisonPedigree(ped, f)
  expect_identical(sum, unname(tools::md5sum(f)))
})

test_that("an unknown parent is written as an empty cell", {
  f <- tempfile(fileext = ".csv")
  writeComparisonPedigree(ped, f)
  lines <- readLines(f)
  expect_false(any(grepl("NA", lines, fixed = TRUE)))
  expect_identical(lines[2L], "A,,,M,2000-01-01")
})

test_that("ids, sires and dams are read as text, even if they look numeric", {
  got <- readComparisonPedigree(csvFile(c(
    "id,sire,dam,sex", "007,,,M", "8,,,F", "9,007,8,F"
  )))
  expect_identical(got$id, c("007", "8", "9"))
  expect_identical(got$sire, c(NA, NA, "007"))
  expect_identical(got$dam, c(NA, NA, "8"))
})

test_that("an empty cell is read as an unknown parent", {
  got <- readComparisonPedigree(csvFile(c("id,sire,dam,sex", "A,,,M")))
  expect_true(is.na(got$sire))
  expect_true(is.na(got$dam))
})

test_that("the birth column is optional", {
  got <- readComparisonPedigree(csvFile(c("id,sire,dam,sex", "A,,,M")))
  expect_named(got, c("id", "sire", "dam", "sex"))
})

test_that("a file without a required column is refused, naming the column", {
  expect_error(
    readComparisonPedigree(csvFile(c("id,sire,sex", "A,,M"))),
    "dam"
  )
  expect_error(
    readComparisonPedigree(csvFile(c("id,sire,dam", "A,,"))),
    "sex"
  )
})

test_that("toKinship2() codes sex 1 male, 2 female, 3 unknown", {
  k <- toKinship2(ped)
  expect_named(k, c("id", "dadid", "momid", "sex"))
  expect_identical(k$id, ped$id)
  expect_identical(k$dadid, ped$sire)
  expect_identical(k$momid, ped$dam)
  expect_identical(k$sex, c(1L, 2L, 3L, 3L, 2L))
})

test_that("toKinship2() refuses a sex code it does not know", {
  bad <- ped
  bad$sex[1L] <- "X"
  expect_error(toKinship2(bad), "sex")
})

test_that("toPedixplorer() spells sex out and renames the parent columns", {
  p <- toPedixplorer(ped)
  expect_named(p, c("id", "dadid", "momid", "sex"))
  expect_identical(p$dadid, ped$sire)
  expect_identical(p$momid, ped$dam)
  expect_identical(
    p$sex,
    c("male", "female", "unknown", "unknown", "female")
  )
})

test_that("toPedixplorer() refuses a sex code it does not know", {
  bad <- ped
  bad$sex[2L] <- "X"
  expect_error(toPedixplorer(bad), "sex")
})

test_that("completeParentage() adds a placeholder for each missing parent", {
  full <- completeParentage(ped)
  expect_identical(nrow(full), nrow(ped) + 2L)
  expect_false(any(xor(is.na(full$sire), is.na(full$dam))))
  added <- full[-seq_len(nrow(ped)), ]
  expect_false(any(added$id %in% ped$id))
  expect_false(anyDuplicated(full$id) > 0L)
  expect_true(all(is.na(added$sire) & is.na(added$dam)))
  expect_identical(full$sex[match(full$dam[4L], full$id)], "F")
  expect_identical(full$sex[match(full$sire[5L], full$id)], "M")
})

test_that("completeParentage() keeps original animals first, parents kept", {
  full <- completeParentage(ped)
  expect_identical(full$id[seq_len(nrow(ped))], ped$id)
  expect_identical(full$sire[4L], "A")
  expect_identical(full$dam[5L], "B")
  expect_identical(full[1L:3L, ], ped[1L:3L, ])
})

test_that("completeParentage() leaves full parentage unchanged", {
  complete <- ped[1L:3L, ]
  expect_identical(completeParentage(complete), complete)
})

test_that("completeParentage() picks placeholder ids no animal already has", {
  first <- completeParentage(ped)
  taken <- first$id[-seq_len(nrow(ped))]
  clash <- rbind(ped, data.frame(
    id = taken, sire = NA, dam = NA, sex = c("F", "M"),
    birth = as.Date("1990-01-01"), stringsAsFactors = FALSE
  ))
  full <- completeParentage(clash)
  expect_false(anyDuplicated(full$id) > 0L)
  expect_identical(nrow(full), nrow(clash) + 2L)
})

test_that("deriveSex() makes sires M, dams F and everyone else U", {
  noSex <- ped[, c("id", "sire", "dam")]
  noSex$dam[4L] <- "E"
  got <- deriveSex(noSex)
  expect_named(got, c("id", "sire", "dam", "sex"))
  expect_identical(got$sex, c("M", "F", "U", "U", "F"))
})

test_that("deriveSex() refuses an animal that is both a sire and a dam", {
  both <- data.frame(
    id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "B"),
    dam = c(NA, NA, "B", "A"), stringsAsFactors = FALSE
  )
  expect_error(deriveSex(both), "both")
})
