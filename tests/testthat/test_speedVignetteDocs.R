## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S85, plan
## Phase 17i1, docs/planning/pedkindraw-timing-plan.md sections 5.7, 5.8 and
## 6; R153, R158, R159). The speed vignette, vignettes/speed.Rmd, runs no
## code (CRAN rebuilds vignettes; tools/ is not in the package) and follows
## section 5.8's outline; its tables are checked cell for cell by
## tools/checkSpeedTables.R (tests in tools/timing/tests/), and these tests
## hold its words: the outline, the method, a definition of every computation
## the records time, what each drawing row times, the judgment of how large a
## drawing can be read, and what the numbers cannot tell.
##
## The documents are read from the source tree with helper-docs.R's helpers
## and the tests skip without it (R CMD check runs them from a folder with no
## vignettes/). In the source tree a missing page fails rather than skips.

## The page's text. testthat's functions and helper-docs.R's are not seen by
## lintr here.
# nolint start: object_usage_linter.
.speedPage <- function() {
  skip_if_not(dir.exists(test_path("..", "..", "vignettes")),
              "no vignettes folder in this tree")
  file <- test_path("..", "..", "vignettes", "speed.Rmd")
  expect_true(file.exists(file), label = "the speed vignette's file exists")
  if (!file.exists(file)) return("")
  .docsText("vignettes", "speed.Rmd")
}
# nolint end

test_that("the speed vignette is titled 'Speed and size limits', is built by
           knitr and runs no code", {
  text <- .speedPage()
  .docsSay(text, c("title: \"Speed and size limits\"",
                   "VignetteIndexEntry{Speed and size limits}",
                   "VignetteEngine{knitr::rmarkdown}",
                   "rmarkdown::html_vignette"), "the speed vignette")
  expect_false(grepl("```{r", text, fixed = TRUE))
  expect_false(grepl("`r ", text, fixed = TRUE))
})

test_that("its sections follow the plan's outline, in order", {
  text <- .speedPage()
  headings <- c("## The machine and the method", "## Computation",
                "## Drawing", "## What these numbers cannot tell you",
                "## Where next")
  at <- vapply(headings, function(h) {
    regexpr(paste0("\n", h, "\n"), text, fixed = TRUE)[[1L]]
  }, 0L)
  expect_true(all(at > 0L), label = toString(headings[at < 0L]))
  expect_false(is.unsorted(at))
})

test_that("the opening says what the page answers, from one machine, and that
           a script checks every number", {
  text <- .speedPage()
  opening <- substr(text, 1L, regexpr("\n## ", text, fixed = TRUE)[[1L]])
  script <- file.path("tools", "checkSpeedTables.R")
  .docsSay(.docsFlat(opening),
           c("how large a pedigree", "one machine", script, "runs no code"),
           "the speed vignette's opening")
})

test_that("the method states each run's limits, its start and the median", {
  section <- .docsFlat(.docsSection(.speedPage(), "The machine and the method"))
  .docsSay(section, c("fresh R process", "warm-up", "median", "120 seconds",
                      "32 GB", "half of the CPU", "before the clock"),
           "'The machine and the method'")
})

test_that("each computation the records time has a one-line definition", {
  section <- .docsFlat(.docsSection(.speedPage(), "Computation"))
  records <- utils::read.csv(
    text = .docsText("tools", "timing", "results", "timing.csv"),
    stringsAsFactors = FALSE
  )
  for (computation in unique(records$computation)) {
    .docsSay(section, paste0("- **", computation, "**: "), "'Computation'")
  }
})

test_that("the drawing section says what each drawing row times, the saves
           not timed at 3,000 and a save's slow run", {
  section <- .docsFlat(.docsSection(.speedPage(), "Drawing"))
  .docsSay(section, c("in Chrome", "built before the clock",
                      "`makePedigreeDiagramData()` alone", "not timed",
                      "one slow run", "median"), "'Drawing'")
})

test_that("the drawing section gives the judgment of how large a drawing can
           be read (R158) and says the drawing began as nprcgenekeepr's", {
  section <- .docsFlat(.docsSection(.speedPage(), "Drawing"))
  .docsSay(section, c("1,000 animals", "zoomed in", "copy of nprcgenekeepr's",
                      "`runPedigreeApp()`"), "'Drawing'")
})

test_that("'What these numbers cannot tell you' names another machine, less
           memory, another browser and another pedigree's shape", {
  section <- .docsFlat(.docsSection(.speedPage(),
                                    "What these numbers cannot tell you"))
  .docsSay(section, c("Another machine", "memory", "browser", "shape"),
           "'What these numbers cannot tell you'")
})

test_that("NEWS.md names the speed vignette", {
  .docsSay(.docsFlat(.docsText("NEWS.md")), "vignette(\"speed\"", "NEWS.md")
})
