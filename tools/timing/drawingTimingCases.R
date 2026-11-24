## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/drawingTimingCases.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.1, Phase 17h3; R157). Changes: rewritten for section
## 5.1's 11 cases. pedkindraw's six take nprcgenekeepr's npg_widget's place:
## its page with rectilinear lines (pkd_page, the default) and with direct
## lines (pkd_page_direct); its SVG, PDF and PNG files, savePedigreeDiagram()
## of a widget built before the clock, on the function's own page (R157),
## with its time limit set above the harness's (pkd_svg, pkd_pdf, pkd_png);
## and makePedigreeDiagramData() alone (pkd_data, a new kind, "data", which
## writes no file). The kinship2 and Pedixplorer cases are renamed
## (k2_static, pdx_static and pdx_static_unaligned become k2_picture,
## pdx_picture and pdx_picture_unaligned) and ordered as section 5.1 lists
## them; ggpedigree's two cases are dropped (R82, R153). withCanvas(),
## pedixplorerAppCall(), pedixplorerAppCex(), pedixplorerPicture() and
## pedixplorerPage() are as copied.
## The drawing-timing cases: one per package and drawing form, from a
## comparison pedigree to a picture (PNG, SVG or PDF), to a web page a
## browser draws (HTML), or to pedkindraw's diagram data.
## prepare(p, width, height) builds the package's input and is not timed;
## call(x, stem, width, height) is the timed drawing: it writes <stem>.png,
## <stem>.svg, <stem>.pdf or <stem>.html and returns that file (pkd_data
## writes none and returns the data). A step a user must run first (building
## kinship2's or Pedixplorer's pedigree object, pedkindraw's findGeneration())
## is inside the timed call; converting the pedigree to each package's codes
## (comparisonFormats.R) is not. `loads` names the packages drawOne.R loads
## before the clock besides `package`, so that no timed call includes loading
## one. kinship2 and Pedixplorer get a placeholder for the missing parent of
## an animal with one known parent (completeParentage()); pedkindraw gets the
## pedigree as it is. Needs comparisonFormats.R, drawingCapture.R and
## drawingTiming.R sourced first; the tests are in tests/test_drawingTiming.R.

drawingCase <- function(id, package, kind, loads, prepare, call) {
  list(
    id = id, package = package, kind = kind, loads = loads,
    prepare = prepare, call = call
  )
}

## The helpers come from the files sourced first, which lintr cannot see.
# nolint start: object_usage_linter.

## Pedixplorer checks its labels' room against the open device, so both its
## cases draw on a device of the canvas size.
withCanvas <- function(width, height, code) {
  grDevices::png(tempfile(fileext = ".png"), width, height)
  on.exit(grDevices::dev.off())
  code
}

## Pedixplorer's app call at the first label size it accepts.
## `...` goes to that call (align_parents).
pedixplorerAppCall <- function(pp, cex, ...) {
  appPlot <- get("app_plot_fct", asNamespace("Pedixplorer"))
  suppressWarnings(appPlot(pp, cex = cex, interactive = TRUE, ...))
}
pedixplorerAppCex <- function(pp) {
  for (cex in c(1.0, 0.5, 0.25, 0.125)) {
    w <- tryCatch(pedixplorerAppCall(pp, cex), error = function(e) e)
    if (!inherits(w, "error")) {
      return(cex)
    }
    if (!grepl("reduce cex", conditionMessage(w), fixed = TRUE)) stop(w)
  }
  stop(w)
}

## Pedixplorer's picture of `input` as <stem>.png; `...` goes to
## ped_to_plotdf() (cex and force, or align_parents).
pedixplorerPicture <- function(input, stem, width, height, ...) {
  pp <- suppressWarnings(Pedixplorer::Pedigree(input))
  file <- paste0(stem, ".png")
  grDevices::png(file, width, height)
  on.exit(grDevices::dev.off())
  plotPedixplorerData(suppressWarnings(Pedixplorer::ped_to_plotdf(pp, ...)))
  file
}

## Pedixplorer's plotly page of `input` as <stem>.html, drawn on a device of
## the canvas size; `...` goes to its app's call (align_parents).
pedixplorerPage <- function(input, stem, width, height, cex, ...) {
  widget <- withCanvas(width, height, {
    pp <- suppressWarnings(Pedixplorer::Pedigree(input))
    pedixplorerAppCall(pp, cex, ...)
  })
  savePage(widget, stem, width, height)
}

## pedkindraw's diagram of `p` as a user draws it: the generations, the
## layout and the widget, with lines of `edgeStyle`.
pedkindrawDiagram <- function(p, edgeStyle) {
  p$gen <- pedkindraw::findGeneration(p$id, p$sire, p$dam)
  layout <- suppressMessages(suppressWarnings(
    pedkindraw::makePedigreeMatingLayout(p, edgeStyle = edgeStyle)
  ))
  pedkindraw::drawPedigreeDiagram(layout, edgeStyle = edgeStyle)
}

## A savePedigreeDiagram() case: the widget is built before the clock, and
## the file is written on the function's own page (R157), with its time
## limit (60 s by default) set above the harness's 120 s, so that the
## harness, not the function, decides a failure (the plan's section 8,
## dragon 7).
pedkindrawSave <- function(id, ending) {
  drawingCase(id, "pedkindraw", "static",
    c("visNetwork", "htmlwidgets", "chromote", "withr"),
    prepare = function(p, width, height) {
      pedkindrawDiagram(p, "rectilinear")
    },
    call = function(x, stem, width, height) {
      withr::local_options(pedkindraw.saveTimeout = 600.0)
      file <- paste0(stem, ending)
      pedkindraw::savePedigreeDiagram(x, file)
      file
    }
  )
}

drawingCases <- function() {
  list(
    drawingCase("pkd_page", "pedkindraw", "browser",
      c("visNetwork", "htmlwidgets"),
      prepare = function(p, width, height) p,
      call = function(x, stem, width, height) {
        savePage(pedkindrawDiagram(x, "rectilinear"), stem, width, height)
      }
    ),
    drawingCase("pkd_page_direct", "pedkindraw", "browser",
      c("visNetwork", "htmlwidgets"),
      prepare = function(p, width, height) p,
      call = function(x, stem, width, height) {
        savePage(pedkindrawDiagram(x, "direct"), stem, width, height)
      }
    ),
    pedkindrawSave("pkd_svg", ".svg"),
    pedkindrawSave("pkd_pdf", ".pdf"),
    pedkindrawSave("pkd_png", ".png"),
    drawingCase("pkd_data", "pedkindraw", "data", character(),
      prepare = function(p, width, height) {
        p$gen <- pedkindraw::findGeneration(p$id, p$sire, p$dam)
        p
      },
      call = function(x, stem, width, height) {
        suppressMessages(pedkindraw::makePedigreeDiagramData(x))
      }
    ),
    drawingCase("k2_picture", "kinship2", "static", character(),
      prepare = function(p, width, height) toKinship2(completeParentage(p)),
      call = function(x, stem, width, height) {
        po <- kinship2::pedigree(x$id, x$dadid, x$momid, x$sex)
        file <- paste0(stem, ".png")
        grDevices::png(file, width, height)
        on.exit(grDevices::dev.off())
        graphics::plot(po)
        file
      }
    ),
    drawingCase("pdx_picture", "Pedixplorer", "static", character(),
      prepare = function(p, width, height) {
        x <- pedixplorerFrame(completeParentage(p))
        settings <- withCanvas(width, height, {
          pp <- suppressWarnings(Pedixplorer::Pedigree(x))
          pedixplorerPlotData(pp)
        })
        list(input = x, cex = settings$cex, force = settings$force)
      },
      call = function(x, stem, width, height) {
        pedixplorerPicture(x$input, stem, width, height,
          cex = x$cex, force = x$force
        )
      }
    ),
    ## Mark's ruling (S1125): Pedixplorer's parent alignment refuses the
    ## synthetic colonies and its warning suggests align_parents = FALSE, so
    ## these two draw with it off, at the default label size (a label-size
    ## trial before the clock would outlast drawOne.R's start limit at 2,000).
    drawingCase("pdx_picture_unaligned", "Pedixplorer", "static",
      character(),
      prepare = function(p, width, height) {
        pedixplorerFrame(completeParentage(p))
      },
      call = function(x, stem, width, height) {
        pedixplorerPicture(x, stem, width, height, align_parents = FALSE)
      }
    ),
    drawingCase("pdx_plotly", "Pedixplorer", "browser",
      c("plotly", "htmlwidgets"),
      prepare = function(p, width, height) {
        x <- pedixplorerFrame(completeParentage(p))
        cex <- withCanvas(width, height, {
          pedixplorerAppCex(suppressWarnings(Pedixplorer::Pedigree(x)))
        })
        list(input = x, cex = cex)
      },
      call = function(x, stem, width, height) {
        pedixplorerPage(x$input, stem, width, height, x$cex)
      }
    ),
    drawingCase("pdx_plotly_unaligned", "Pedixplorer", "browser",
      c("plotly", "htmlwidgets"),
      prepare = function(p, width, height) {
        pedixplorerFrame(completeParentage(p))
      },
      call = function(x, stem, width, height) {
        pedixplorerPage(x, stem, width, height, 1.0, align_parents = FALSE)
      }
    )
  )
}
# nolint end
