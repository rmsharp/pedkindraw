## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S96, plan
## Phase 17m, docs/planning/cran-submission-plan.md): the release text agrees
## with DESCRIPTION's version. A release's version has three parts (1.0.0); a
## development version has a fourth, 9000 or more (1.0.0.9000), and only it is
## "(development version)" in NEWS.md. CRAN's page for the package shows the
## README and NEWS of the release it holds, so neither may say the package is
## not on CRAN. The documents are read from the source tree with
## helper-docs.R's helpers, and the tests skip without it (R CMD check runs
## them from a folder with no DESCRIPTION, NEWS.md or README).

# nolint start: object_usage_linter.
## DESCRIPTION's Version field, from the source tree.
.releaseVersion <- function() {
  file <- test_path("..", "..", "DESCRIPTION")
  if (!file.exists(file)) skip("DESCRIPTION is not in this tree")
  unname(read.dcf(file, fields = "Version")[1L, 1L])
}

## TRUE for a development version: a fourth part, 9000 or more.
.isDevelopmentVersion <- function(version) {
  parts <- strsplit(version, ".", fixed = TRUE)[[1L]]
  length(parts) == 4L && as.integer(parts[[4L]]) >= 9000L
}

## NEWS.md's first section: its first "# " heading and the lines to the next.
.firstNewsSection <- function() {
  lines <- strsplit(.docsText("NEWS.md"), "\n", fixed = TRUE)[[1L]]
  starts <- which(startsWith(lines, "# "))
  end <- if (length(starts) > 1L) starts[[2L]] - 1L else length(lines)
  lines[starts[[1L]]:end]
}
# nolint end

test_that("NEWS.md's first heading names DESCRIPTION's version, as a
  development version only when it is one", {
  version <- .releaseVersion()
  heading <- .firstNewsSection()[[1L]]
  expected <- paste("# pedkindraw", version)
  if (.isDevelopmentVersion(version)) {
    expected <- paste(expected, "(development version)")
  }
  expect_identical(heading, expected)
})

test_that("a release's NEWS and README do not say it is not on CRAN", {
  version <- .releaseVersion()
  release <- !.isDevelopmentVersion(version)
  notOnCran <- "not (yet )?on CRAN|not on CRAN yet"
  news <- .docsFlat(paste(.firstNewsSection(), collapse = "\n"))
  expect_false(release && grepl(notOnCran, news),
               label = "the release's NEWS says it is not on CRAN")
  for (readme in c("README.Rmd", "README.md")) {
    install <- .docsFlat(.docsSection(.docsText(readme), "Installation"))
    expect_false(release && grepl(notOnCran, install),
                 label = paste(readme, "'s Installation says not on CRAN"))
  }
})

## The README has an item of its own, one whose first words are "the README"
## after NEWS's "New: " or none: the US spelling item names the README among
## the documents it covers ("The help pages, vignettes, README and NEWS").
test_that("NEWS's Documentation section names the README, the vignettes and
  the website", {
  section <- .docsSection(paste(.firstNewsSection(), collapse = "\n"),
                          "Documentation")
  items <- grep("^\\* ", strsplit(section, "\n", fixed = TRUE)[[1L]],
                value = TRUE)
  expect_true(any(grepl("^\\* (New: )?[Tt]he README", items)),
              label = "NEWS.md has an item that begins with the README")
  .docsSay(.docsFlat(section), c("vignette(\"pedkindraw\"",
                                 "vignette(\"drawing\"", "vignette(\"speed\"",
                                 "https://rmsharp.github.io/pedkindraw/"),
           "NEWS.md")
})
