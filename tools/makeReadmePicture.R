## Remakes man/figures/README-pedigree.png, the picture of the README's example
## drawing (plan Phase 16a; docs/planning/documentation-plan.md sections 3, M4,
## and 5.1).
##
## Run from the repository root with the current package installed:
##
##   Rscript tools/makeReadmePicture.R
##
## It runs README.Rmd's chunks "pedigree", "check" and "drawing", so the
## picture is the drawing the README's code makes; saves that widget as a web
## page; and photographs the page in headless Chrome through chromote. It needs
## pedkindraw, htmlwidgets and chromote installed, and Chrome or Chromium.
## An older pedkindraw installed in the library draws the older code: the
## library it used is printed, so install the current tree first.

chunkCode <- function(lines, label) {
  start <- grep(paste0("^```\\{r ", label, "[,}]"), lines)
  if (length(start) != 1L) {
    stop("README.Rmd has ", length(start), " chunks labelled ", label)
  }
  ends <- grep("^```[[:space:]]*$", lines)
  lines[(start + 1L):(min(ends[ends > start]) - 1L)]
}

makeReadmePicture <- function(readme = "README.Rmd",
                              out = file.path("man", "figures",
                                              "README-pedigree.png")) {
  lines <- readLines(readme)
  env <- new.env(parent = globalenv())
  for (label in c("pedigree", "check", "drawing")) {
    eval(parse(text = chunkCode(lines, label)), envir = env)
  }
  html <- tempfile(fileext = ".html")
  on.exit(unlink(html), add = TRUE)
  htmlwidgets::saveWidget(env$diagram, html, selfcontained = TRUE)
  browser <- chromote::ChromoteSession$new(width = 1000L, height = 700L)
  on.exit(browser$close(), add = TRUE)
  ## Two device pixels per page pixel, so vis.js draws its canvas at that
  ## density and the 2x capture below is sharp, not an enlarged 1x drawing.
  browser$Emulation$setDeviceMetricsOverride(
    width = 1000L, height = 700L, deviceScaleFactor = 2, mobile = FALSE
  )
  browser$go_to(paste0("file://", html), timeout_ = 30, delay = 2)
  dir.create(dirname(out), recursive = TRUE, showWarnings = FALSE)
  browser$screenshot(out, selector = "html", scale = 2, show = FALSE)
  cat("wrote", out, "(", file.size(out), "bytes ) with pedkindraw",
      format(utils::packageVersion("pedkindraw")), "from",
      dirname(find.package("pedkindraw")), "\n")
  invisible(out)
}

makeReadmePicture()
