## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S98,
## backlog :178): a CI job that installs R packages does not start renv. The
## project's .Rprofile starts renv, and renv adds renv.lock's Bioconductor
## release (3.23) to the repositories beside the release pak picks for the
## job's R version. On R-devel that installed S4Vectors 0.50.3 (Bioconductor
## 3.23) with BiocGenerics 0.60.0 (3.24), which do not build together (the
## same pair stops on R 4.6.2 with the same error). With
## RENV_CONFIG_AUTOLOADER_ENABLED false in a job's env, renv/activate.R starts
## nothing, and the job installs current CRAN packages and one Bioconductor
## release, as CRAN's check machines do. The workflow files are read from the
## source tree, and the tests skip without it (R CMD check runs them from a
## folder with no .github).

# nolint start: object_usage_linter.
## The jobs in a workflow's lines that run r-lib/actions/setup-r-dependencies
## without RENV_CONFIG_AUTOLOADER_ENABLED: false in the job's own env (a
## job's key is indented 2 spaces under `jobs:`, its `env:` 4, the env's
## entries 6; a step's env, deeper, does not count). Comments are ignored.
.jobsStartingRenv <- function(lines) {
  lines <- sub("(^|[[:space:]])#.*$", "", lines)
  jobsAt <- which(lines == "jobs:")
  if (length(jobsAt) == 0L) {
    return(character(0))
  }
  isJob <- seq_along(lines) > jobsAt[[1L]] &
    grepl("^  [^[:space:]][^:]*:[[:space:]]*$", lines)
  starts <- which(isJob)
  ends <- c(starts[-1L] - 1L, length(lines))
  starting <- character(0)
  for (i in seq_along(starts)) {
    job <- lines[starts[[i]]:ends[[i]]]
    if (!any(grepl("r-lib/actions/setup-r-dependencies", job, fixed = TRUE))) {
      next
    }
    envAt <- which(grepl("^    env:[[:space:]]*$", job))
    entries <- character(0)
    if (length(envAt) > 0L) {
      after <- job[-seq_len(envAt[[1L]])]
      ## The env's entries run to the first non-blank line indented 4 or less.
      stop <- which(nzchar(trimws(after)) & !grepl("^      ", after))
      entries <- if (length(stop) > 0L) after[seq_len(stop[[1L]] - 1L)] else after
    }
    off <- grepl(paste0("^      RENV_CONFIG_AUTOLOADER_ENABLED:",
                        "[[:space:]]*[\"']?false[\"']?[[:space:]]*$"), entries)
    if (!any(off)) {
      starting <- c(starting, trimws(sub(":.*$", "", lines[starts[[i]]])))
    }
  }
  starting
}

## The workflow files in the source tree, or a skip.
.workflowFiles <- function() {
  dir <- test_path("..", "..", ".github", "workflows")
  files <- list.files(dir, pattern = "\\.ya?ml$", full.names = TRUE)
  if (length(files) == 0L) skip(".github/workflows is not in this tree")
  files
}

## A workflow's lines for the reader's typed cases: one job, `check`, that
## installs packages, with `jobEnv` as its env's entries and `stepEnv` as the
## env of its install step.
.typedWorkflow <- function(jobEnv = character(0), stepEnv = character(0),
                           install = TRUE) {
  c("name: typed",
    "jobs:",
    "  check:",
    "    runs-on: ubuntu-latest",
    if (length(jobEnv) > 0L) c("    env:", paste0("      ", jobEnv)),
    "    steps:",
    "      - uses: r-lib/actions/setup-r@v2",
    if (install) "      - uses: r-lib/actions/setup-r-dependencies@v2",
    if (length(stepEnv) > 0L) c("        env:", paste0("          ", stepEnv)),
    "        with:",
    "          needs: check")
}
# nolint end

test_that("the reader finds a job that installs packages with renv on, and
  only such a job", {
  off <- "RENV_CONFIG_AUTOLOADER_ENABLED: false"
  expect_identical(.jobsStartingRenv(.typedWorkflow(jobEnv = off)),
                   character(0))
  expect_identical(.jobsStartingRenv(.typedWorkflow(
    jobEnv = c("GITHUB_PAT: x", "RENV_CONFIG_AUTOLOADER_ENABLED: 'false'"))),
    character(0))
  expect_identical(.jobsStartingRenv(.typedWorkflow(
    jobEnv = c(off, "R_KEEP_PKG_SOURCE: yes"))), character(0))
  ## renv on: no env, a step's env only, commented out, set to true.
  expect_identical(.jobsStartingRenv(.typedWorkflow()), "check")
  expect_identical(.jobsStartingRenv(.typedWorkflow(stepEnv = off)), "check")
  expect_identical(.jobsStartingRenv(.typedWorkflow(
    jobEnv = c("GITHUB_PAT: x", paste("#", off)))), "check")
  expect_identical(.jobsStartingRenv(.typedWorkflow(
    jobEnv = "RENV_CONFIG_AUTOLOADER_ENABLED: true")), "check")
  ## The line outside the env, at the depth of the job's own keys, is not
  ## the env's.
  expect_identical(.jobsStartingRenv(c(.typedWorkflow(jobEnv = "A: b"),
                                       paste0("    ", off))), "check")
  ## A job that installs no packages needs nothing.
  expect_identical(.jobsStartingRenv(.typedWorkflow(install = FALSE)),
                   character(0))
})

test_that("at least two workflows install R packages", {
  installing <- Filter(function(f) {
    any(grepl("r-lib/actions/setup-r-dependencies", readLines(f),
              fixed = TRUE))
  }, .workflowFiles())
  expect_gte(length(installing), 2L)
})

test_that("every CI job that installs R packages turns renv off, so it
  installs one Bioconductor release", {
  for (file in .workflowFiles()) {
    expect_identical(.jobsStartingRenv(readLines(file)), character(0),
                     info = basename(file))
  }
})
