## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr
## tools/pedigreeComparison/tests/helper-sourceScript.R at nprcgenekeepr commit
## 3e06730c5 (docs/planning/pedkindraw-timing-plan.md section 4.1, Phase 17h1).
## Changes: none.
## Loaded by testthat before each test file in this folder. Sources a
## comparison script from the folder above when it exists, so that before
## the script is written (RED) each test fails on its own rather than the
## whole file failing to load.
sourceComparisonScript <- function(name) {
  script <- file.path("..", name)
  if (file.exists(script)) source(script) # nolint: undesirable_function_linter.
}
