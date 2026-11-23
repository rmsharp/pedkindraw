## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S72, plan
## Phase G16c, docs/planning/picture-files-plan.md section 7, G16c; Mark's pick,
## S72: "Guarded example, checks in tests"). The documents say how to save a
## drawing as a file and what the 375-animal colony's files hold: this file
## holds each statement's key words, and the numbers in them are the ones
## test_savePedigreeDiagramColony.R measures (545 id labels, 375 distinct,
## none over another; an id 2.8 pixels high at the default 300 dpi).
##
## The drawing vignette's example is guarded with eval = interactive(): a chunk
## that starts Chrome leaves two pipes open (the gaps plan's dragon 26), and
## the check that builds the vignettes runs where no browser is found.
##
## The documents are read from the source tree (README.Rmd, README.md,
## vignettes/, man/ and NEWS.md do not exist under an installed package) and the
## tests skip without it, as helpExampleCode() in helper-helpExample.R reads
## man/ only from the source. The four helpers that read them, .docsText(),
## .docsSection(), .docsAfter() and .docsSay(), written here in S72, are in
## helper-docs.R since S77's REFACTOR (G17d), which test_runPedigreeAppDocs.R
## uses too.

test_that("the README says a drawing can be saved as an SVG, a PDF or a PNG
           file, in the source and in the page made from it", {
  for (file in c("README.Rmd", "README.md")) {
    text <- .docsText(file)
    .docsSay(text, "savePedigreeDiagram(", file)
    .docsSay(.docsAfter(text, "savePedigreeDiagram(", 600L),
             c(".svg", ".pdf", ".png"), file)
  }
})

test_that("the drawing vignette's 'Saving a drawing' shows the three files in
           an example Chrome does not start in a build", {
  section <- .docsSection(.docsText("vignettes", "drawing.Rmd"),
                          "Saving a drawing")
  .docsSay(section, "savePedigreeDiagram(", "'Saving a drawing'")
  .docsSay(.docsAfter(section, "savePedigreeDiagram("),
           c(".svg", ".pdf", ".png", "dpi"), "'Saving a drawing'")
  ## A chunk whose header holds eval = interactive() and whose code calls the
  ## function.
  expect_match(section,
               "```\\{r[^}\n]*eval = interactive\\(\\)[^}\n]*\\}\n[^`]*savePedigreeDiagram\\(")
})

test_that("the drawing vignette's colony section says what the files hold: every
           id, none over another, and how small an id is", {
  section <- .docsSection(.docsText("vignettes", "drawing.Rmd"),
                          "A colony-size drawing")
  .docsSay(section, "savePedigreeDiagram(", "'A colony-size drawing'")
  .docsSay(.docsAfter(section, "savePedigreeDiagram("),
           c("545", "375", "overlap", "300 dpi", "pixels"),
           "'A colony-size drawing'")
})

test_that("the pedkindraw vignette says a drawing can be saved as a file", {
  .docsSay(.docsText("vignettes", "pedkindraw.Rmd"), "savePedigreeDiagram(",
           "vignettes/pedkindraw.Rmd")
})

test_that("the help of drawPedigreeDiagram() and of the package points to
           savePedigreeDiagram()", {
  .docsSay(.docsText("man", "drawPedigreeDiagram.Rd"),
           "\\link{savePedigreeDiagram}", "man/drawPedigreeDiagram.Rd")
  .docsSay(.docsText("man", "pedkindraw-package.Rd"), "savePedigreeDiagram",
           "man/pedkindraw-package.Rd")
})

test_that("NEWS says the colony's files fit one page, on letter paper too, with
           no id over another", {
  .docsSay(.docsText("NEWS.md"), c("letter paper", "overlap"), "NEWS.md")
})
