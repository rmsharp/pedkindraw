## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/tests/helper-checks.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: pkdLibReady() (pedkindraw installed in
## PKD_LIB) replaces libsReady() and npgLibReady() (CMP_LIB and NPG_LIB:
## kinship2 and Pedixplorer are in renv's library); and, in Phase 17h3,
## chromeReady() and isPng(), the drawing tests' checks, as copied, and new
## isSvg() and isPdf() for the files savePedigreeDiagram() writes.
## Loaded by testthat before each test file in this folder: the checks
## several test files share.

## pedkindraw installed from a commit into the scratch library PKD_LIB
## (docs/planning/pedkindraw-timing-plan.md section 5.5), which the timing
## children load.
pkdLibReady <- function() {
  lib <- Sys.getenv("PKD_LIB")
  nzchar(lib) && dir.exists(file.path(lib, "pedkindraw"))
}

chromeReady <- function() {
  !is.null(tryCatch(chromote::find_chrome(), error = function(e) NULL))
}

## A file that starts with the PNG signature.
isPng <- function(file) {
  signature <- as.raw(c(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a))
  file.exists(file) && identical(readBin(file, "raw", 8L), signature)
}

## A file whose text starts with `start`.
startsWithText <- function(file, start) {
  file.exists(file) &&
    identical(rawToChar(readBin(file, "raw", nchar(start))), start)
}
## An SVG file as savePedigreeDiagram() writes it, and a PDF file.
isSvg <- function(file) startsWithText(file, "<svg ")
isPdf <- function(file) startsWithText(file, "%PDF-")

## The packages a function's code names with `::`.
packagesNamed <- function(f) {
  code <- deparse1(f, collapse = "\n")
  m <- regmatches(code, gregexpr("[A-Za-z][A-Za-z0-9.]*(?=::)", code,
    perl = TRUE
  ))[[1L]]
  unique(m)
}

## The project root, seen from this folder.
projectRoot <- normalizePath(file.path("..", "..", ".."))
