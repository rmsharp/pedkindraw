## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Loaded by testthat before the test files in this folder (Phase 17h1,
## docs/planning/pedkindraw-timing-plan.md section 6): the two pedigrees every
## case is tried on, and each case's value on them, computed once per run of
## this folder's tests (Pedixplorer's shrink() alone takes about 90 s on the
## colony). The functions they call come from the harness's scripts, which
## each test file sources first. Phase 17h3: colonyFile(), the colony where
## timeOne.R and drawOne.R read it, from test_timingHarness.R.

## The seed-1 colony of 300 animals and the 375-animal sample, as the
## harness reads them: written by writeComparisonPedigree(), as
## savePedigrees.R writes them, and read back by readComparisonPedigree(), as
## timeOne.R reads them.
timingPedigree <- function(name) {
  ped <- if (identical(name, "colony")) {
    generateColonyPedigree(300L, 1L) # nolint: object_usage_linter.
  } else {
    sample <- utils::read.csv(file.path(
      projectRoot, "inst", "extdata", "obfuscated_rhesus_mhc_ped.csv" # nolint
    ), stringsAsFactors = FALSE)
    sample <- sample[, c("id", "sire", "dam", "sex", "birth")]
    sample$birth <- as.Date(sample$birth)
    sample
  }
  file <- tempfile(fileext = ".csv")
  writeComparisonPedigree(ped, file) # nolint: object_usage_linter.
  readComparisonPedigree(file) # nolint: object_usage_linter.
}

## Each case's value on pedigree `name` ("colony" or "sample"), by case id:
## prepare(), then the call after set.seed(1L), as timeOne.R makes it, with
## pedkindraw loaded from PKD_LIB (useTimingLibraries()); a call that stops
## gives its error condition, and a call that returns NULL keeps its place.
## Stops when pedkindraw was loaded from another folder (the plan's section 8,
## dragon 2).
caseValues <- local({
  cache <- list()
  function(name) {
    if (is.null(cache[[name]])) {
      # nolint start: object_usage_linter.
      old <- useTimingLibraries()
      on.exit(.libPaths(old)) # nolint: undesirable_function_linter.
      p <- timingPedigree(name)
      values <- list()
      for (k in timingCases()) {
        x <- k$prepare(p)
        set.seed(1L)
        values[k$id] <- list(tryCatch(
          suppressWarnings(suppressMessages(k$call(x))),
          error = function(e) e
        ))
      }
      checkPedkindrawFolder(
        dirname(getNamespaceInfo("pedkindraw", "path")),
        Sys.getenv("PKD_LIB")
      )
      # nolint end
      cache[[name]] <<- values
    }
    cache[[name]]
  }
})

## The 300-animal colony where timeOne.R and drawOne.R read it
## (tools/timing/data, which git ignores; savePedigrees.R writes the same
## file, and a clone has none until then).
colonyFile <- function() {
  file <- file.path("..", "data", "synthetic_300.csv")
  if (!file.exists(file)) {
    dir.create(dirname(file), showWarnings = FALSE)
    # nolint next: object_usage_linter.
    writeComparisonPedigree(generateColonyPedigree(300L, 1L), file)
  }
  invisible(file)
}
