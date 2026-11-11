## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/helper-perfCampaign.R at
## nprcgenekeepr commit baef1e12c, its lines 132-150 only: outcome(), which
## test_kinshipMemoryEquivalence.R's C11 test uses. Changes: none to those
## lines. Their comment names nprcgenekeepr's equivalence tests and
## test_rareAlleleCounts.R, which pedkindraw does not have.

## The value, error message and warnings of one call, from a fixed seed (1 by
## default): the equivalence tests compare today's function and the new code on
## unusual inputs with it (test_rareAlleleCounts.R has its own one-argument
## outcome()).
outcome <- function(f, args, seed = 1L) {
  warnings <- character()
  withr::with_seed(seed, tryCatch(
    withCallingHandlers(
      list(value = do.call(f, args), warnings = warnings),
      warning = function(w) {
        warnings <<- c(warnings, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    ),
    error = function(e) {
      list(error = conditionMessage(e), warnings = warnings)
    }
  ))
}
