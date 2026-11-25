## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (pedkindraw S69, plan
## Phase G16a, gaps A1 and A2 of docs/research/pedkindraw-gaps-2026-11-18.md;
## rulings R142 and R143, docs/planning/picture-files-plan.md section 11; the
## .pdf and .png files and dpi: pedkindraw S71, Phase G16b, ruling R144,
## section 12; .closeChrome(): pedkindraw S91, backlog item "A Windows job
## that does not end after its tests finish").

#' Save a pedigree diagram as a picture file
#'
#' Writes the widget \code{\link{drawPedigreeDiagram}} returns as a picture
#' file, from a script: it is drawn in a browser by JavaScript, and nothing
#' else in R can turn it into a file. A headless Chrome (through the
#' \pkg{chromote} package) runs the very drawing the widget shows, a small
#' recording layer writes every line, shape and word it draws, and the result
#' is an SVG file: the same drawing, with every mark, colour and legend row,
#' and each id as text that a reader can select, search and zoom to.
#'
#' The ending of \code{file} chooses the kind of file: \code{.svg}, the
#' recorded drawing as it is; \code{.pdf}, that drawing printed as one page of
#' the picture's size, still vector, with each id as text (each dashed line is
#' written as a row of short strokes, because Chrome writes every dash of a
#' dashed line as an outline and a pedigree with many repeat animals would
#' otherwise be a PDF of several megabytes); or \code{.png}, a photograph of
#' the same drawing at \code{dpi} pixels per inch of the page.
#'
#' The widget on screen draws an id only when it would be 4 pixels tall, so a
#' large pedigree shows no ids until a reader zooms in. A file has no zoom, so
#' the function writes every id: it lowers that limit on a copy of the widget,
#' and the widget \code{diagram} itself is not changed.
#'
#' The picture is the widget's size in the browser, 10 inches (960 pixels)
#' wide, unless \code{width} or \code{height} say otherwise. The drawing and
#' its legend are drawn for that page, and the file's own size is the page, so
#' it prints at that size.
#'
#' The function starts its own headless Chrome for each call (two for a
#' \code{.pdf} or \code{.png}) and closes it, and stops if the drawing is not
#' done within 60 seconds (\code{options(pedkindraw.saveTimeout = seconds)}
#' changes that).
#'
#' @param diagram the widget \code{\link{drawPedigreeDiagram}} returns.
#' @param file the file to write, one file name. Its ending, in any case,
#'   chooses the kind of file: \code{.svg}, \code{.pdf} or \code{.png}. The
#'   folder must exist.
#' @param width,height the page, in inches: a positive number, or \code{NULL}
#'   (the default) for the size the widget has in the browser, 10 inches wide.
#'   The widget is drawn at \code{width * 96} by \code{height * 96} pixels, so
#'   the drawing fills the page, with its legend at the right.
#' @param dpi the pixels per inch of the page in a \code{.png} file, one
#'   positive number (the default is 300): a page of 7 by 5 inches is 2100 by
#'   1500 pixels. An \code{.svg} or \code{.pdf} file is vector and has no
#'   pixels, so the number does not change it; it is checked for every kind of
#'   file.
#' @return \code{file}, invisibly.
#' @section Requirements:
#'   The \pkg{chromote} package, and Google Chrome or Chromium on the computer
#'   (set \code{CHROMOTE_CHROME} to its path if \pkg{chromote} cannot find
#'   it). Both are checked before anything is drawn. A \code{.pdf} or
#'   \code{.png} file also needs \pkg{jsonlite}, which \pkg{chromote} needs
#'   too.
#' @seealso \code{\link{drawPedigreeDiagram}} for the widget, and
#'   \code{\link{makePedigreeMatingLayout}} for what it draws.
#' @examples
#' # It starts Chrome, so it runs when typed in R, and not in R CMD check.
#' if (interactive() &&
#'       requireNamespace("chromote", quietly = TRUE) &&
#'       !is.null(suppressMessages(chromote::find_chrome()))) {
#'   ped <- data.frame(
#'     id = c("A", "B", "C", "D"),
#'     sire = c(NA, NA, "A", "A"),
#'     dam = c(NA, NA, "B", "B"),
#'     sex = c("M", "F", "F", "M"),
#'     status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
#'     affected = c(FALSE, FALSE, TRUE, FALSE),
#'     stringsAsFactors = FALSE
#'   )
#'   ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
#'   diagram <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
#'   for (kind in c(".svg", ".pdf", ".png")) {
#'     file <- tempfile(fileext = kind)
#'     savePedigreeDiagram(diagram, file, width = 7, height = 5)
#'     print(file.exists(file))
#'     unlink(file)
#'   }
#' }
#' @export
savePedigreeDiagram <- function(diagram, file, width = NULL, height = NULL,
                                dpi = 300.0) {
  if (!inherits(diagram, "visNetwork")) {
    stop("savePedigreeDiagram() requires 'diagram' to be the widget ",
         "drawPedigreeDiagram() returns.")
  }
  if (!is.character(file) || length(file) != 1L || is.na(file)) {
    stop("savePedigreeDiagram() requires 'file' to be one file name, as a ",
         "character string.")
  }
  ending <- tolower(sub(".*\\.([^.]*)$", "\\1", basename(file)))
  if (!ending %in% c("svg", "pdf", "png")) {
    stop("savePedigreeDiagram() requires 'file' to end in .svg, .pdf or ",
         ".png.")
  }
  .checkInches(width, "width")
  .checkInches(height, "height")
  .checkDpi(dpi)
  if (!dir.exists(dirname(file))) {
    stop("savePedigreeDiagram(): the folder of 'file' does not exist.")
  }
  if (!requireNamespace("chromote", quietly = TRUE)) {
    stop("savePedigreeDiagram() needs the 'chromote' package; install it ",
         "with install.packages(\"chromote\").")
  }
  if (is.null(suppressMessages(chromote::find_chrome()))) {
    stop("savePedigreeDiagram() could not find Google Chrome or Chromium; ",
         "install one, or set CHROMOTE_CHROME to its path.")
  }
  # A copy: the widget is a list, so the caller's is not changed.
  copy <- visNetwork::visNodes(
    diagram, scaling = list(label = list(drawThreshold = 0.0))
  )
  copy$width <- if (is.null(width)) 960.0 else round(width * 96.0)
  if (!is.null(height)) copy$height <- sprintf("%dpx", round(height * 96.0))
  timeout <- getOption("pedkindraw.saveTimeout", 60.0)
  deadline <- Sys.time() + timeout
  recorded <- .recordDiagramSvg(copy, timeout = timeout, widthIn = width,
                                heightIn = height,
                                expandDashes = identical(ending, "pdf"))
  if (identical(ending, "svg")) {
    writeLines(recorded$svg, file, useBytes = TRUE)
  } else {
    .renderPicture(recorded, ending, file, width, height, dpi, deadline,
                   timeout)
  }
  invisible(file)
}

#' Record what a widget draws, in headless Chrome, as SVG
#'
#' Saves \code{diagram} to a folder of its own, opens it in a headless Chrome
#' of its own with the recording layer (\code{inst/js/recordCanvas.js}) in
#' place before the widget runs, waits until the drawing is done, and reads the
#' SVG the layer composes. The browser and the folder are gone on every way
#' out.
#'
#' @param diagram a \code{visNetwork} widget, as it is to be drawn.
#' @param timeout the seconds to wait, for the whole call; the option
#'   \code{pedkindraw.saveTimeout}, or 60.
#' @param scaleFactor the browser's device scale factor; the function always
#'   uses 1, a test uses 2.
#' @param widthIn,heightIn the page in inches for the SVG's own size, or
#'   \code{NULL} for the drawing's box over 96 pixels per inch.
#' @param expandDashes \code{TRUE} to have each dashed line written as short
#'   strokes (the recording layer's third argument), for a PDF.
#' @return A list: \code{svg}, the SVG text, and \code{x}, \code{y},
#'   \code{w}, \code{h}, the box of the widget's canvases, in CSS pixels.
#' @noRd
.recordDiagramSvg <- function(diagram,
                              timeout = getOption("pedkindraw.saveTimeout",
                                                  60.0),
                              scaleFactor = 1.0, widthIn = NULL,
                              heightIn = NULL, expandDashes = FALSE) {
  deadline <- Sys.time() + timeout
  stopTooSlow <- function() .stopTooSlow(timeout)
  folder <- tempfile("pedkindraw-save-")
  dir.create(folder)
  on.exit(unlink(folder, recursive = TRUE), add = TRUE)
  page <- file.path(folder, "diagram.html")
  htmlwidgets::saveWidget(diagram, page, selfcontained = FALSE)
  layer <- paste(readLines(system.file("js", "recordCanvas.js",
                                       package = "pedkindraw"),
                           warn = FALSE), collapse = "\n")

  chrome <- chromote::Chromote$new()
  # The browser closes first, then the folder it reads goes.
  on.exit(.closeChrome(chrome), add = TRUE, after = FALSE)
  # chromote's first launch can take longer than its 10 s default allows on a
  # slow machine (a fresh Chrome on a CI runner).
  chrome$default_timeout <- max(chrome$default_timeout, 60.0)
  # A window with room round the widget.
  windowWidth <- max(1200L, as.integer(.widgetPixels(diagram$width, 960.0)) +
                       200L)
  windowHeight <- max(1300L, as.integer(.widgetPixels(diagram$height, 500.0)) +
                        200L)
  session <- chromote::ChromoteSession$new(parent = chrome,
                                           width = windowWidth,
                                           height = windowHeight)
  session$Page$enable()
  session$Emulation$setDeviceMetricsOverride(
    width = windowWidth, height = windowHeight,
    deviceScaleFactor = scaleFactor, mobile = FALSE
  )
  session$Page$addScriptToEvaluateOnNewDocument(source = layer)
  session$Page$navigate(paste0("file://", page))

  .waitUntilDrawn(session, deadline, stopTooSlow)

  asNumber <- function(inches) {
    if (is.null(inches)) "null" else format(inches, digits = 15L)
  }
  answer <- tryCatch(
    session$Runtime$evaluate(
      sprintf("window.__svg(%s, %s, %s)", asNumber(widthIn),
              asNumber(heightIn), if (expandDashes) "true" else "false"),
      returnByValue = TRUE, timeout_ = max(.secondsLeft(deadline), 1.0)
    )$result$value,
    error = function(e) stopTooSlow()
  )
  firstLine <- regexpr("\n", answer, fixed = TRUE)
  box <- as.numeric(strsplit(substr(answer, 1L, firstLine - 1L), " ",
                             fixed = TRUE)[[1L]])
  list(svg = substr(answer, firstLine + 1L, nchar(answer)),
       x = box[[1L]], y = box[[2L]], w = box[[3L]], h = box[[4L]])
}

#' A widget's width or height in pixels
#'
#' @param size an htmlwidget's \code{width} or \code{height}: \code{NULL}, a
#'   number of pixels, or text such as \code{"945px"}.
#' @param default the pixels when \code{size} is not one of those.
#' @return A number.
#' @noRd
.widgetPixels <- function(size, default) {
  pixels <- suppressWarnings(as.numeric(sub("px$", "", size)))
  if (length(pixels) == 1L && !is.na(pixels)) pixels else default
}

#' Stop unless an argument of savePedigreeDiagram() is NULL or inches
#'
#' The check \code{savePedigreeDiagram()} makes of \code{width} and
#' \code{height}. The error carries the caller's call, as when the function
#' made the check itself.
#'
#' @param inches the argument.
#' @param name its name, for the message.
#' @return \code{NULL}, invisibly, when \code{inches} is acceptable.
#' @noRd
.checkInches <- function(inches, name) {
  if (!is.null(inches) && !(is.numeric(inches) && length(inches) == 1L &&
                              is.finite(inches) && inches > 0.0)) {
    stop(simpleError(
      paste0("savePedigreeDiagram() requires '", name, "' to be NULL or one ",
             "positive number of inches."),
      call = sys.call(-1L)
    ))
  }
  invisible(NULL)
}

#' Stop unless the dpi of savePedigreeDiagram() is one positive number
#'
#' The check \code{savePedigreeDiagram()} makes of \code{dpi}, as
#' \code{.checkInches()} makes of the page.
#'
#' @param dpi the argument.
#' @return \code{NULL}, invisibly, when \code{dpi} is acceptable.
#' @noRd
.checkDpi <- function(dpi) {
  if (!(is.numeric(dpi) && length(dpi) == 1L && is.finite(dpi) && dpi > 0.0)) {
    stop(simpleError(
      paste0("savePedigreeDiagram() requires 'dpi' to be one positive number ",
             "of pixels per inch."),
      call = sys.call(-1L)
    ))
  }
  invisible(NULL)
}

#' Print or photograph a recorded SVG as a PDF or PNG file
#'
#' Writes \code{recorded$svg} to a folder of its own, opens it in a headless
#' Chrome of its own (started with LCD text off, so that a PNG's text has no
#' coloured edges on Linux and Windows), waits until the page is painted (two
#' animation frames: a print right after the load event can come out without
#' the shapes and ids), and writes the page: \code{Page.printToPDF} with the
#' paper the page's size and no margins, or \code{Page.captureScreenshot}
#' clipped to the page at \code{dpi / 96} times its size. The browser and the
#' folder are gone on every way out, and the file is written only when the
#' browser has answered.
#'
#' @param recorded the list \code{.recordDiagramSvg()} returns.
#' @param ending \code{"pdf"} or \code{"png"}.
#' @param file the file to write.
#' @param widthIn,heightIn the page in inches, or \code{NULL} for the box
#'   (\code{recorded$w}, \code{recorded$h}) over 96 pixels per inch.
#' @param dpi the pixels per inch of a PNG.
#' @param deadline the time to give up, from \code{Sys.time()}.
#' @param timeout the seconds the deadline was, for the message.
#' @return \code{NULL}, invisibly.
#' @noRd
.renderPicture <- function(recorded, ending, file, widthIn, heightIn, dpi,
                           deadline, timeout) {
  stopTooSlow <- function() .stopTooSlow(timeout)
  pageWidth <- if (is.null(widthIn)) recorded$w / 96.0 else widthIn
  pageHeight <- if (is.null(heightIn)) recorded$h / 96.0 else heightIn
  folder <- tempfile("pedkindraw-save-")
  dir.create(folder)
  on.exit(unlink(folder, recursive = TRUE), add = TRUE)
  picture <- file.path(folder, "picture.svg")
  writeLines(recorded$svg, picture, useBytes = TRUE)

  chrome <- chromote::Chromote$new(browser = chromote::Chrome$new(
    args = unique(c(chromote::default_chrome_args(), "--disable-lcd-text"))
  ))
  on.exit(.closeChrome(chrome), add = TRUE, after = FALSE)
  chrome$default_timeout <- max(chrome$default_timeout, 60.0)
  session <- chromote::ChromoteSession$new(
    parent = chrome, width = as.integer(ceiling(pageWidth * 96.0)) + 50L,
    height = as.integer(ceiling(pageHeight * 96.0)) + 50L
  )
  session$Page$enable()
  left <- function() max(.secondsLeft(deadline), 0.5)
  answer <- tryCatch({
    session$Page$navigate(paste0("file://", picture), timeout_ = left())
    session$Runtime$evaluate(
      paste0("new Promise(function (done) { requestAnimationFrame(",
             "function () { requestAnimationFrame(done); }); })"),
      awaitPromise = TRUE, timeout_ = left()
    )
    if (identical(ending, "pdf")) {
      session$Page$printToPDF(
        paperWidth = pageWidth, paperHeight = pageHeight, marginTop = 0.0,
        marginBottom = 0.0, marginLeft = 0.0, marginRight = 0.0,
        printBackground = TRUE, pageRanges = "1", timeout_ = left()
      )
    } else {
      session$Page$captureScreenshot(
        format = "png",
        clip = list(x = 0.0, y = 0.0, width = pageWidth * 96.0,
                    height = pageHeight * 96.0, scale = dpi / 96.0),
        timeout_ = left()
      )
    }
  }, error = function(e) {
    if (.secondsLeft(deadline) < 0.5 ||
          grepl("timed out", conditionMessage(e), fixed = TRUE)) {
      stopTooSlow()
    }
    stop(e)
  })
  writeBin(jsonlite::base64_dec(answer$data), file)
  invisible(NULL)
}

#' Stop because the drawing was not finished in time
#'
#' The one message of every time limit \code{savePedigreeDiagram()} keeps: the
#' recording, the wait for the drawing, the print and the photograph.
#'
#' @param timeout the seconds the limit was.
#' @return Does not return: it stops, with no call in the message.
#' @noRd
.stopTooSlow <- function(timeout) {
  stop("savePedigreeDiagram() did not finish drawing within ",
       format(timeout), " seconds.", call. = FALSE)
}

#' Close a browser and end each of its processes the close leaves running
#'
#' On Windows the renderer of a page whose script never returns, and its
#' crash reporter, outlive their browser's close (pedkindraw S91: R CMD check
#' then waited for them until stopped). The browser's child processes are
#' listed while it runs, by their parent (processx's own marker reaches none
#' of Chrome's), and each one still running after the close is ended.
#'
#' @param chrome the \code{chromote::Chromote} that started the browser.
#' @return \code{NULL}, invisibly.
#' @noRd
.closeChrome <- function(chrome) {
  children <- tryCatch(
    ps::ps_children(ps::ps_handle(chrome$get_browser()$get_process()$get_pid()),
                    recursive = TRUE),
    error = function(e) list()
  )
  chrome$close()
  for (child in children) {
    if (ps::ps_is_running(child)) {
      try(ps::ps_kill(child), silent = TRUE)
      try(ps::ps_wait(child, timeout = 5000L), silent = TRUE)
    }
  }
  invisible(NULL)
}

#' The seconds left to a deadline
#'
#' @param deadline a time, from \code{Sys.time()}.
#' @return A number, negative once the deadline has passed.
#' @noRd
.secondsLeft <- function(deadline) {
  as.numeric(difftime(deadline, Sys.time(), units = "secs"))
}

#' Wait until a page the recording layer is in has drawn its widget
#'
#' Drawn: both canvases have drawn, no canvas call for 300 ms, and every
#' legend picture has loaded. A page that never returns from its JavaScript
#' never answers, and runs into the deadline.
#'
#' @param session the \code{ChromoteSession} that has the page.
#' @param deadline the time to give up, from \code{Sys.time()}.
#' @param stopTooSlow a function that stops with the message for a deadline
#'   passed.
#' @return \code{NULL}, invisibly, once drawn.
#' @noRd
.waitUntilDrawn <- function(session, deadline, stopTooSlow) {
  repeat {
    left <- .secondsLeft(deadline)
    if (left <= 0.0) stopTooSlow()
    state <- tryCatch(
      session$Runtime$evaluate("window.__ready ? window.__ready() : '0 0 0'",
                               returnByValue = TRUE,
                               timeout_ = left)$result$value,
      error = function(e) NULL
    )
    if (is.character(state)) {
      ready <- as.numeric(strsplit(state, " ", fixed = TRUE)[[1L]])
      if (ready[[1L]] >= 2L && ready[[2L]] > 300.0 && ready[[3L]] == 1L) {
        return(invisible(NULL))
      }
    }
    Sys.sleep(0.05)
  }
}
