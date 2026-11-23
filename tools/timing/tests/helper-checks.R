## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/tests/helper-checks.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## section 4.1, Phase 17h1). Changes: pkdLibReady() (pedkindraw installed in
## PKD_LIB) replaces libsReady() and npgLibReady() (CMP_LIB and NPG_LIB:
## kinship2 and Pedixplorer are in renv's library); chromeReady() and isPng(),
## the drawing tests' checks, wait for Phase 17h3.
## Loaded by testthat before each test file in this folder: the checks
## several test files share.

## pedkindraw installed from a commit into the scratch library PKD_LIB
## (docs/planning/pedkindraw-timing-plan.md section 5.5), which the timing
## children load.
pkdLibReady <- function() {
  lib <- Sys.getenv("PKD_LIB")
  nzchar(lib) && dir.exists(file.path(lib, "pedkindraw"))
}

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
