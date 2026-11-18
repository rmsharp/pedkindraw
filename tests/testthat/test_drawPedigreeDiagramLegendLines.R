## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S39, plan
## R95; the backlog item "The legend cuts its 'Same animal, again' label",
## seen S31 on the website: the row read "Same animal; agai"). The label was
## not cut by the legend's edge: visNetwork's visLegend() gives every legend
## line an arrowhead when it has no `arrows` value, and vis.js draws it over
## the right end of the line, where the label ends. Measured S39 in headless
## Chrome, it covered 5.5 px of the label at the website's 776 px widget and
## 10.1 px at the vignette's 700 px column; the diagram's own lines have no
## arrowheads. The dashed line also ran through the label, so the comma read
## as a semicolon. drawPedigreeDiagram() now draws the legend's four lines
## without arrowheads and each line's label on a white background. The
## browser test was run on the code before the change (both widths covered)
## and on a draft of the change (whole) before this file was committed
## (Learning 18). nprcgenekeepr is to get the same change in a session of its
## own there (R95); DIVERGENCE.md records the difference until then.
library(testthat)

## A sire and a dam with two daughters; `k` condition columns (0 to 4), the
## first daughter affected by each. The legend's lines do not depend on the
## pedigree, only on the canvas, which grows 45 px for each condition past
## the first.
.legendLinesLayout <- function(k) {
  ped <- data.frame(
    id = c("S", "D", "X1", "X2"),
    sire = c(NA, NA, "S", "S"),
    dam = c(NA, NA, "D", "D"),
    sex = c("M", "F", "F", "F"),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(k)) {
    name <- if (i == 1L) "affected" else paste0("affected", i)
    ped[[name]] <- ped$id == "X1"
  }
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  suppressMessages(makePedigreeMatingLayout(ped))
}

.legendLineLabels <- c("Same animal, again", "MZ", "DZ", "?")

test_that(
  "drawPedigreeDiagram()'s legend draws its four lines without arrowheads, as
   the diagram draws its lines, each label on a white background", {
  skip_if_not_installed("visNetwork")

  widget <- drawPedigreeDiagram(.legendLinesLayout(0L))
  edges <- widget$x$legend$edges
  expect_identical(edges$label, .legendLineLabels)
  ## vis.js reads "" as no arrowhead at either end; visLegend() gives a line
  ## with no value its 'to' arrowhead.
  expect_identical(edges$arrows, rep("", 4L))
  expect_identical(edges[["font.background"]], rep("#FFFFFF", 4L))
  ## The diagram's own lines carry no arrowheads: no column, no option.
  expect_null(widget$x$edges$arrows)
  expect_null(widget$x$options$edges$arrows)
})

## For each line of the legend: its label, whether vis.js draws an arrowhead
## at its right end, where that arrowhead starts, the label's left and right
## ends (each in the legend canvas's pixels), the canvas's width, and the
## label's background. vis.js draws an arrowhead 15 * scaleFactor + 3 * width
## units long, ending at the line's right end (getArrowData() in
## vis-network.min.js); a label is centred on its line, and its box
## (labelModule.size) is set when the legend is drawn, so the legend is
## redrawn first. Returns one "label;arrow;arrowStart;left;right;canvas;
## background" line each, joined by "|"; "" until the legend exists.
.legendLinesJs <- paste0(
  "(() => { const el = document.querySelector('.visNetwork'); ",
  "const w = el && HTMLWidgets.find('#' + el.id); ",
  "if (!w || !w.legend) { return ''; } const L = w.legend; L.redraw(); ",
  "const cv = L.canvas.frame.canvas; ",
  "const X = x => L.canvasToDOM({x: x, y: 0}).x; ",
  "return L.body.edgeIndices.map(id => { const e = L.body.edges[id]; ",
  "const s = e.labelModule.size; const to = e.options.arrows.to; ",
  "const len = to.enabled ? 15 * to.scaleFactor + 3 * e.options.width : 0; ",
  "return [e.options.label, to.enabled ? 1 : 0, X(e.to.x - len), ",
  "X(s.left), X(s.left + s.width), cv.clientWidth, ",
  "e.options.font.background || 'none'].join(';'); }).join('|'); })()"
)

test_that(
  "in a browser at 776 and 700 px, no arrowhead covers a legend line's label,
   each label is on white and inside the legend, with no condition and with
   four", {
  skip_on_cran()
  skip_if_not_installed("visNetwork")
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_no_chrome()

  ## As getLiveRenderedPositions() (helper-live-render-positions.R): a 60 s
  ## timeout on chromote's shared parent before the first session, for a
  ## slow first launch on CI, and one graceful close of it after the suite.
  chromeParent <- chromote::default_chromote_object()
  if (chromeParent$default_timeout < 60) {
    chromeParent$default_timeout <- 60
  }
  if (!isTRUE(.chromoteParentTeardownRegistered$done)) {
    withr::defer(chromeParent$close(), envir = testthat::teardown_env())
    .chromoteParentTeardownRegistered$done <- TRUE
  }
  session <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
  withr::defer(session$close())

  checked <- 0L
  for (k in c(0L, 4L)) {
    ## 776 px is each drawing's width on the website, 700 px the vignette's
    ## column.
    for (width in c(776L, 700L)) {
      widget <- drawPedigreeDiagram(.legendLinesLayout(k))
      widget$width <- width
      html <- withr::local_tempfile(fileext = ".html")
      htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
      session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
      deadline <- Sys.time() + 10
      repeat {
        read <- session$Runtime$evaluate(.legendLinesJs)$result$value
        if (nzchar(read) || Sys.time() > deadline) {
          break
        }
        Sys.sleep(0.2)
      }
      rows <- strsplit(strsplit(read, "|", fixed = TRUE)[[1L]], ";",
                       fixed = TRUE)
      expect_identical(vapply(rows, `[[`, "", 1L), .legendLineLabels)
      for (row in rows) {
        at <- sprintf("%d conditions, %d px, '%s'", k, width, row[[1L]])
        arrow <- row[[2L]] == "1"
        arrowStart <- as.numeric(row[[3L]])
        left <- as.numeric(row[[4L]])
        right <- as.numeric(row[[5L]])
        canvas <- as.numeric(row[[6L]])
        expect_false(arrow && right > arrowStart, label = sprintf(
          "%s: an arrowhead covers the label's last %.1f px", at,
          right - arrowStart
        ))
        expect_identical(row[[7L]], "#FFFFFF", label = paste0(
          at, ": the label's background"
        ))
        expect_gte(left, 0, label = paste0(at, ": the label's left end"))
        expect_lte(right, canvas, label = paste0(
          at, ": the label's right end"
        ))
        checked <- checked + 1L
      }
    }
  }
  expect_identical(checked, 16L)
})
