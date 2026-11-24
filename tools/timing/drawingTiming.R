## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/drawingTiming.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.1, Phase 17h3). Changes: zoomedVisScreenshot()'s
## comment names pedkindraw's page; new pedigreeSize() (the copied
## runDrawingTiming.R's sizeOf()) and drawingRunRow(), each run's row with
## the free memory read before it (R155), the folder pedkindraw was loaded
## from, and, as its started, the clock time runLimited() launched the R
## part (R156).
## The Phase 2 drawing timing (docs/planning/standalone-pedigree-package-
## plan.md, Phase 2, second session; Mark's rulings S1125). A drawing that
## opens in a browser is timed twice: its R part in a fresh process
## (drawOne.R under runLimited(), timingHarness.R), then its page in a fresh
## Chrome tab by timeBrowserDraw(): from navigation to the first painted frame
## after the widget's own draw event (vis.js "afterDrawing", plotly
## "plotly_afterplot"), read by the hook savePage() adds, with the page's
## JavaScript heap. A drawing counts as drawn only when both parts together
## finish within the limit, as combineDrawRun() decides. Tests:
## tests/test_drawingTiming.R, beside the other comparison tests.

## ---- the page and its timing hook -----------------------------------------

## Runs once the widget is rendered: records in window.__drawTiming the time
## (ms since navigation) of the first painted frame after rendering
## ("painted") and after the library's draw event ("drawn"; plotly's last).
drawTimingHook <- paste(
  "function(el, x) {",
  "  var marks = window.__drawTiming = window.__drawTiming || {};",
  "  var afterPaint = function(name) {",
  "    requestAnimationFrame(function() {",
  "      setTimeout(function() { marks[name] = performance.now(); }, 0);",
  "    });",
  "  };",
  "  marks.rendered = performance.now();",
  "  afterPaint('painted');",
  "  if (this.network && this.network.once) {",
  "    this.network.once('afterDrawing', function() { afterPaint('drawn'); });",
  "  }",
  "  if (el.on) {",
  "    el.on('plotly_afterplot', function() { afterPaint('drawn'); });",
  "  }",
  "}",
  sep = "\n"
)

addDrawTimingHook <- function(widget) {
  htmlwidgets::onRender(widget, drawTimingHook)
}

## The widget at the canvas size, with the hook, as <stem>.html; its scripts
## go to lib/ beside it, shared by every page in the folder.
savePage <- function(widget, stem, width, height) {
  file <- paste0(stem, ".html")
  widget$width <- width
  widget$height <- height
  htmlwidgets::saveWidget(addDrawTimingHook(widget), file,
    selfcontained = FALSE, libdir = "lib"
  )
  file
}

## ---- the browser part ------------------------------------------------------

## The page's marks, or NULL while it has none (or is too busy to answer).
readDrawMarks <- function(session, timeout) {
  value <- tryCatch(
    session$Runtime$evaluate("JSON.stringify(window.__drawTiming || null)",
      timeout_ = timeout
    )$result$value,
    error = function(e) NULL
  )
  if (is.null(value) || identical(value, "null")) {
    return(NULL)
  }
  jsonlite::fromJSON(value)
}

## The "drawn" mark (ms) once it has stayed the same for `settle` seconds,
## or NA when none came within timeLimit seconds of `started`.
waitForDrawn <- function(session, started, timeLimit, settle, poll) {
  last <- NA_real_
  seenAt <- NA_real_
  repeat {
    left <- timeLimit - (proc.time()[["elapsed"]] - started)
    if (left <= 0.0) {
      return(last)
    }
    drawn <- readDrawMarks(session, max(left, 1.0))$drawn
    now <- proc.time()[["elapsed"]]
    if (!is.null(drawn)) {
      if (is.na(last) || drawn != last) {
        last <- drawn
        seenAt <- now
      } else if (now - seenAt >= settle) {
        return(last)
      }
    }
    Sys.sleep(poll)
  }
}

openPage <- function(page, width, height) {
  session <- chromote::ChromoteSession$new(width = width, height = height)
  session$Performance$enable()
  started <- proc.time()[["elapsed"]]
  session$Page$navigate(paste0("file://", normalizePath(page)), wait_ = FALSE)
  list(session = session, started = started)
}

## Time one page in a fresh Chrome tab: status ("ok", "time", "error"),
## message, seconds from navigation to the drawn frame, and the JavaScript
## heap in use then (MiB). `screenshot`, a file, photographs the drawn page.
timeBrowserDraw <- function(page, width = 3600L, height = 1500L,
                            timeLimit = 120.0, settle = 1.0, poll = 0.05,
                            screenshot = NULL) {
  failed <- function(status, message) {
    list(
      status = status, message = message, seconds = NA_real_,
      jsHeapMb = NA_real_
    )
  }
  if (!file.exists(page)) {
    return(failed("error", paste("no page:", page)))
  }
  open <- openPage(page, width, height)
  on.exit(open$session$close(), add = TRUE)
  drawn <- waitForDrawn(open$session, open$started, timeLimit, settle, poll)
  if (is.na(drawn) || drawn / 1000.0 > timeLimit) {
    return(failed("time", sprintf("no drawing within %g s", timeLimit)))
  }
  metrics <- open$session$Performance$getMetrics()$metrics
  heap <- Filter(function(m) identical(m$name, "JSHeapUsedSize"), metrics)
  if (!is.null(screenshot)) {
    open$session$screenshot(screenshot, selector = "html", show = FALSE)
  }
  list(
    status = "ok", message = "", seconds = drawn / 1000.0,
    jsHeapMb = heap[[1L]]$value / 1048576.0
  )
}

## pedkindraw's drawn page photographed at vis.js zoom `scale` around the
## fitted view's centre (at 1, labels at their full 14 pixels).
zoomedVisScreenshot <- function(page, file, width = 3600L, height = 1500L,
                                scale = 1.0, timeLimit = 120.0) {
  open <- openPage(page, width, height)
  on.exit(open$session$close(), add = TRUE)
  drawn <- waitForDrawn(open$session, open$started, timeLimit, 0.5, 0.05)
  if (is.na(drawn)) stop("the page did not draw within ", timeLimit, " s")
  zoomed <- open$session$Runtime$evaluate(sprintf(paste(
    "(function() { var el = document.querySelector('.visNetwork');",
    "if (!el) return false;",
    "HTMLWidgets.find('#' + el.id).network.moveTo({scale: %g});",
    "return true; })()"
  ), scale))$result$value
  if (!isTRUE(zoomed)) stop("no visNetwork widget on the page: ", page)
  Sys.sleep(0.5)
  ## The viewport as it is: chromote's screenshot() resizes the window to
  ## the page, and visNetwork fits the diagram again on a resize.
  shot <- open$session$Page$captureScreenshot(format = "png")
  writeBin(jsonlite::base64_dec(shot$data), file)
  invisible(file)
}

## ---- one run and one cell ---------------------------------------------------

## One run from its R part `r` (runLimited()) and browser part `b`
## (timeBrowserDraw(), or NULL for a picture): ok only when both are and
## their total is within timeLimit seconds.
combineDrawRun <- function(r, b, timeLimit = 120.0) {
  out <- list(
    status = r$status, message = r$message, rSeconds = NA_real_,
    browserSeconds = NA_real_, totalSeconds = NA_real_,
    heapPeakMb = r$heapPeakMb, preRssMb = r$preRssMb,
    maxRssBytes = r$maxRssBytes, jsHeapMb = NA_real_
  )
  if (!identical(r$status, "ok")) {
    return(out)
  }
  out$rSeconds <- r$seconds
  if (!is.null(b)) {
    if (!identical(b$status, "ok")) {
      out$status <- b$status
      out$message <- paste("browser:", b$message)
      return(out)
    }
    out$browserSeconds <- b$seconds
    out$jsHeapMb <- b$jsHeapMb
  }
  out$totalSeconds <- out$rSeconds + if (is.null(b)) 0.0 else b$seconds
  if (out$totalSeconds > timeLimit) {
    out$status <- "time"
    out$message <- if (is.null(b)) {
      sprintf("R %.1f s, over %g s", out$rSeconds, timeLimit)
    } else {
      sprintf(
        "R %.1f s + browser %.1f s, over %g s", out$rSeconds,
        out$browserSeconds, timeLimit
      )
    }
  }
  out
}

drawRunFields <- c(
  "rSeconds", "browserSeconds", "totalSeconds", "heapPeakMb", "preRssMb",
  "maxRssBytes", "jsHeapMb"
)

## The median of each figure over the measured runs; a failed run makes the
## whole cell fail with that run's status and message.
summarizeDrawingRuns <- function(runs) {
  status <- vapply(runs, `[[`, "", "status")
  bad <- which(status != "ok")
  if (length(bad) > 0L) {
    first <- runs[[bad[1L]]]
    figures <- stats::setNames(
      as.list(rep(NA_real_, length(drawRunFields))), drawRunFields
    )
    return(c(
      list(status = first$status, message = first$message), figures,
      list(runs = length(runs))
    ))
  }
  med <- function(field) {
    stats::median(vapply(runs, function(r) as.numeric(r[[field]]), 0.0))
  }
  c(
    list(status = "ok", message = ""),
    stats::setNames(lapply(drawRunFields, med), drawRunFields),
    list(runs = length(runs))
  )
}

## ---- each run's row (R155, R156) -------------------------------------------

## The number of animals in a drawing pedigree: the sample's 375, or the
## colony's size in its name (synthetic_<n>).
pedigreeSize <- function(ped) {
  if (identical(ped, "rhesus375")) 375L else as.integer(sub(".*_", "", ped))
}

## The row runDrawingTiming.R writes for one run of case k on pedigree `ped`:
## the idle share and load waitForQuiet() returned (`quiet`), the free memory
## read just before the run (`memFree`, %), the R part's figures from
## runLimited() (`r`) and the run's from combineDrawRun() (`d`), started when
## runLimited() launched the R part (R156).
drawingRunRow <- function(k, ped, kind, quiet, memFree, r, d) {
  data.frame(
    case = k$id, package = k$package, form = k$kind, pedigree = ped,
    size = pedigreeSize(ped), kind = kind, idle = quiet$idle,
    load = quiet$load, memFree = memFree, status = d$status,
    message = d$message, rSeconds = d$rSeconds,
    browserSeconds = d$browserSeconds, totalSeconds = d$totalSeconds,
    heapPeakMb = d$heapPeakMb, preRssMb = d$preRssMb,
    maxRssMb = d$maxRssBytes / 1048576.0, jsHeapMb = d$jsHeapMb,
    realSeconds = r$realSeconds, loaded = paste(r$loaded, collapse = ","),
    pkdLib = r$pkdLib,
    started = timeStamp(r$launched) # nolint: object_usage_linter.
  )
}
