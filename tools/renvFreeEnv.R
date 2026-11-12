## renvFreeEnv(), for the tools that start R in nprcgenekeepr's folder
## (tools/compareResultsWithNprcgenekeepr.R, tools/makeComputedTestFixtures.R),
## which source this file from the pedkindraw root.
##
## This process's renv sets RENV_PROJECT and the library variables, and a
## child would inherit them and load this project's library. Undo them: put
## back the values renv saved as RENV_DEFAULT_* (the text "<NA>" where the
## variable was unset), so the child's own .Rprofile activates its own
## project. Returns the arguments for env(1), to go before the child's
## command; none outside renv.
renvFreeEnv <- function() {
  if (!nzchar(Sys.getenv("RENV_PROJECT"))) {
    return(character(0L))
  }
  vars <- c(
    "R_LIBS", "R_LIBS_USER", "R_LIBS_SITE", "R_PROFILE", "R_PROFILE_USER",
    "R_ENVIRON", "R_ENVIRON_USER"
  )
  unsets <- c("-u", "RENV_PROJECT")
  sets <- character(0L)
  for (v in vars) {
    default <- Sys.getenv(paste0("RENV_DEFAULT_", v), unset = NA)
    if (is.na(default) || identical(default, "<NA>")) {
      unsets <- c(unsets, "-u", v)
    } else {
      sets <- c(sets, paste0(v, "=", shQuote(default)))
    }
  }
  ## env reads its options only before the first NAME=value.
  c(unsets, sets)
}
