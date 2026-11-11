## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_findPedigreeNumber.R at
## nprcgenekeepr commit baef1e12c. Changes: the data() call is dropped
## (helper-fixtures.R supplies lacy1989Ped), and stringi's stri_c() and
## stri_detect_fixed() become the base R suffix() below and grepl(fixed =
## TRUE), which give identical values here (checked in S3), so pedkindraw
## needs no stringi.
## stri_c() gives NA when its input is NA, where paste0() would give "NA2".
suffix <- function(x, s) ifelse(is.na(x), NA_character_, paste0(x, s))
ped <- lacy1989Ped
ped$gen <- NULL
ped$population <- NULL
ped2 <- ped
ped2$id <- suffix(ped$id, "2")
ped2$sire <- suffix(ped$sire, "2")
ped2$dam <- suffix(ped$dam, "2")
ped3 <- ped
ped3$id <- suffix(ped$id, "3")
ped3$sire <- suffix(ped$sire, "3")
ped3$dam <- suffix(ped$dam, "3")
ped <- rbind(ped, ped2)
ped <- rbind(ped, ped3)
test_that("findPedigreeNumber identifies separate pedigrees correctly", {
  ped$pedigree <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
  expect_true(all(ped$pedigree[grepl("1", ped$id, fixed = TRUE)] == 1L))
  expect_true(all(ped$pedigree[grepl("2", ped$id, fixed = TRUE)] == 2L))
  expect_true(all(ped$pedigree[grepl("3", ped$id, fixed = TRUE)] == 3L))
})
