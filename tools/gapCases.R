## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
##
## The typed cases of docs/research/pedkindraw-gaps-2026-11-18.md (plan Phase
## 17f, pedkindraw S40): what kinship2 or Pedixplorer can do that pedkindraw
## cannot. Each case types a small pedigree, runs kinship2 1.9.6.2 and
## Pedixplorer 1.8.0 (renv's library; both are Suggests) and pedkindraw (this
## working copy, through pkgload::load_all()), and prints one line per result:
## "case | what | value". A call that stops prints "stops: <message>", one that
## warns prints "warns: <message>" and goes on.
##
## Usage, from the repository's root:
##   Rscript tools/gapCases.R          every case, each in its own R process
##                                     under its time limit (CLAUDE.md Learning
##                                     19); then a table of exit codes, 124
##                                     meaning the limit was reached
##   Rscript tools/gapCases.R <case>   one case, in this process
## The runner needs GNU timeout (or gtimeout) on the path; without it the
## cases run with no limit and the runner says so. The largeIds case needs
## chromote and Chrome; blockKinship needs about 10 GB of memory.

caseLimits <- c(
  files = 60L, largeIds = 180L, app = 60L,
  matesNoOffspring = 60L, unknownAffected = 60L, markings = 60L,
  measuredTrait = 60L, style = 60L, labels = 60L, shrinkPicture = 60L,
  distanceSubset = 60L, alignedDepth = 60L, ownHints = 60L,
  inputCodes = 60L, lookups = 60L,
  blockKinship = 600L, removeAnimals = 60L, fiveConditions = 60L,
  plinkReader = 60L, datasets = 60L
)

scriptPath <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  normalizePath(sub("^--file=", "", arg[[1L]]))
}

## One result line. Values longer than one line are joined with " / ".
say <- function(case, what, value) {
  shown <- if (is.character(value)) value else format(value)
  text <- paste(shown, collapse = " / ")
  cat(case, " | ", what, " | ", gsub("\n", "\\n", text, fixed = TRUE), "\n",
      sep = "")
}

## Evaluate expr; print its value, or that it stopped, or that it warned.
probe <- function(case, what, expr) {
  value <- tryCatch(
    withCallingHandlers(expr, warning = function(w) {
      say(case, what, paste("warns:", conditionMessage(w)))
      invokeRestart("muffleWarning")
    }, message = function(m) invokeRestart("muffleMessage")),
    error = function(e) list(stopped = conditionMessage(e))
  )
  if (is.list(value) && identical(names(value), "stopped")) {
    say(case, what, paste("stops:", value$stopped))
  } else {
    say(case, what, value)
  }
  invisible(value)
}

## A and B, founders, with offspring C (male) and D (female).
fourAnimals <- function() {
  data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
             dam = c(NA, NA, "B", "B"), sex = c("M", "F", "M", "F"),
             stringsAsFactors = FALSE)
}

withGen <- function(ped) {
  ped$gen <- pedkindraw::findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

sexNumber <- function(sex) match(sex, c("M", "F"))

k2Pedigree <- function(ped, ...) {
  kinship2::pedigree(ped$id, ped$sire, ped$dam, sexNumber(ped$sex),
                     missid = NA, ...)
}

pxFrame <- function(ped) {
  data.frame(id = ped$id, dadid = ped$sire, momid = ped$dam,
             sex = sexNumber(ped$sex), stringsAsFactors = FALSE)
}

## Draw with kinship2's plot.pedigree() into a null device, recording the
## labels its text() calls write and the pch of its points() calls (it
## marks an unknown affected status with points(pch = "?")).
k2Drawn <- function(k, plotFun = kinship2::plot.pedigree, ...) {
  drawn <- new.env()
  drawn$text <- character(0L)
  drawn$points <- character(0L)
  drawn$border <- character(0L)
  recorders <- list(
    text = function(x, y = NULL, labels = seq_along(x), ...) {
      drawn$text <- c(drawn$text, as.character(labels))
      invisible(NULL)
    },
    points = function(x, y = NULL, pch = 1L, ...) {
      drawn$points <- c(drawn$points, as.character(pch))
      invisible(NULL)
    },
    polygon = function(x, y = NULL, density = NULL, angle = 45.0,
                       border = NULL, col = NA, ...) {
      drawn$border <- c(drawn$border, as.character(border))
      invisible(NULL)
    }
  )
  f <- plotFun
  environment(f) <- list2env(recorders, parent = environment(plotFun))
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off())
  f(k, ...)
  as.list(drawn)
}

pxPlotDf <- function(p, ...) Pedixplorer::ped_to_plotdf(p, ...)$df

## The arguments of one of Pedixplorer's S4 methods (its .local function's).
pxMethodArgs <- function(generic, signature) {
  m <- methods::getMethod(generic, signature,
                          where = asNamespace("Pedixplorer"))
  b <- body(m)
  local <- if (is.call(b) && length(b) > 1L) b[[2L]] else NULL
  if (is.call(local) && identical(local[[2L]], as.name(".local"))) {
    names(formals(eval(local[[3L]])))
  } else {
    names(formals(m))
  }
}

symbolRows <- function(df) df[grepl("^(square|circle|diamond)", df$type), ]

## Pages in a PDF file: count its page objects.
pdfPages <- function(file) {
  bytes <- readBin(file, "raw", file.size(file))
  bytes[bytes == as.raw(0L)] <- as.raw(32L)
  text <- rawToChar(bytes)
  Encoding(text) <- "bytes"
  # nolint next: nonportable_path_linter, absolute_path_linter.
  pageObject <- "/Type /Page[^s]"
  lengths(regmatches(text, gregexpr(pageObject, text,
                                    useBytes = TRUE)))
}

## The rhesus pedigree the vignettes use (R80).
rhesus <- function() {
  ped <- utils::read.csv(file.path("inst", "extdata",
                                   "obfuscated_rhesus_mhc_ped.csv"),
                         stringsAsFactors = FALSE, na.strings = c("", "NA"))
  ped[, c("id", "sire", "dam", "sex")]
}

## Family 1 of Pedixplorer's sampleped (41 animals).
sampleFamily <- function() {
  env <- new.env()
  utils::data("sampleped", package = "Pedixplorer", envir = env)
  sp <- env$sampleped[env$sampleped$famid == "1", ]
  sp$dadid[sp$dadid %in% c("", "0")] <- NA
  sp$momid[sp$momid %in% c("", "0")] <- NA
  sp
}

cases <- list()

## A1. Picture files from a script.
cases$files <- function(case = "files") {
  ped <- fourAnimals()
  k <- k2Pedigree(ped)
  p <- Pedixplorer::Pedigree(pxFrame(ped))
  out <- tempfile("gapFiles")
  dir.create(out)
  devices <- list(pdf = grDevices::pdf, svg = grDevices::svg,
                  png = grDevices::png)
  for (d in names(devices)) {
    probe(case, paste("kinship2 plot.pedigree() to", d, "bytes"), {
      f <- file.path(out, paste0("k2.", d))
      devices[[d]](f)
      kinship2::plot.pedigree(k)
      grDevices::dev.off()
      file.size(f)
    })
    probe(case, paste("Pedixplorer plot() to", d, "bytes"), {
      f <- file.path(out, paste0("px.", d))
      devices[[d]](f)
      Pedixplorer::plot(p)
      grDevices::dev.off()
      file.size(f)
    })
  }
  probe(case, "kinship2 pdf pages", pdfPages(file.path(out, "k2.pdf")))
  probe(case, "Pedixplorer pdf pages", pdfPages(file.path(out, "px.pdf")))
  probe(case, "Pedixplorer plot(ggplot_gen = TRUE) element ggplot class", {
    grDevices::pdf(NULL)
    g <- Pedixplorer::plot(p, ggplot_gen = TRUE)
    grDevices::dev.off()
    class(g$ggplot)[[1L]]
  })
  w <- pedkindraw::drawPedigreeDiagram(
    pedkindraw::makePedigreeMatingLayout(withGen(ped)))
  probe(case, "pedkindraw drawPedigreeDiagram() class", class(w))
  probe(case, "pedkindraw plot(widget) inside pdf()", {
    f <- file.path(out, "pk.pdf")
    grDevices::pdf(f)
    on.exit(grDevices::dev.off(), add = TRUE)
    plot(w)
  })
  probe(case, "pedkindraw pdf pages after plot(widget)",
        pdfPages(file.path(out, "pk.pdf")))
  probe(case, "S3 methods for a visNetwork or htmlwidget object",
        sort(unique(c(as.character(utils::methods(class = "htmlwidget")),
                      as.character(utils::methods(class = "visNetwork"))))))
  probe(case, "pedkindraw saveWidget() html bytes", {
    f <- file.path(out, "pk.html")
    htmlwidgets::saveWidget(w, f, selfcontained = FALSE)
    file.size(f)
  })
}

## A2. A whole large pedigree in one picture with every id written.
cases$largeIds <- function(case = "largeIds") {
  rh <- rhesus()
  probe(case, "rhesus animals", nrow(rh))
  k <- probe(case, "kinship2 pedigree() class",
             class(k2Pedigree(rh)))
  if (identical(unclass(k), "pedigree")) {
    probe(case, "kinship2 id labels written (repeat animals too); distinct", {
      drawn <- k2Drawn(k2Pedigree(rh))
      ids <- drawn$text[drawn$text %in% rh$id]
      c(length(ids), length(unique(ids)))
    })
  }
  p <- Pedixplorer::Pedigree(pxFrame(rh))
  for (cex in c(1.0, 0.5, 0.2)) {
    probe(case, paste0("Pedixplorer id labels written at cex ", cex,
                       " (repeat animals too); distinct"), {
      df <- pxPlotDf(p, cex = cex)
      ids <- df$label[df$type == "text" & df$label %in% rh$id]
      c(length(ids), length(unique(ids)))
    })
  }
  ped <- withGen(rh)
  lay <- suppressMessages(suppressWarnings(
    pedkindraw::makePedigreeMatingLayout(ped)))
  probe(case, "pedkindraw animals drawn", sum(lay$nodes$id %in% rh$id))
  w <- pedkindraw::drawPedigreeDiagram(lay)
  f <- file.path(tempfile("gapIds"), "w.html")
  dir.create(dirname(f))
  htmlwidgets::saveWidget(w, f, selfcontained = FALSE)
  b <- chromote::ChromoteSession$new(width = 776L, height = 700L)
  on.exit(b$parent$close(), add = TRUE)
  b$Page$navigate(paste0("file://", f), wait_ = FALSE)
  b$Page$loadEventFired(timeout_ = 60L)
  Sys.sleep(4L)
  js <- paste0(
    "(function(){var el=document.querySelector('.visNetwork');",
    "var net=document.getElementById('graph'+el.id).chart;",
    "var n=net.body.nodes[net.body.nodeIndices.filter(function(i){",
    "return net.body.nodes[i].options.label;})[0]];",
    "return JSON.stringify({scale:net.getScale(),",
    "width:net.canvas.frame.canvas.clientWidth,",
    "font:n.options.font.size,",
    "threshold:n.options.scaling.label.drawThreshold});})()")
  r <- jsonlite::fromJSON(b$Runtime$evaluate(js)$result$value)
  say(case, "pedkindraw fitted view at 776 px: canvas width px", r$width)
  say(case, "pedkindraw fitted view: zoom scale", signif(r$scale, 3L))
  say(case, "pedkindraw fitted view: label height on screen px",
      signif(r$font * r$scale, 3L))
  say(case, "vis.js draws a label only when that height is at least px",
      r$threshold - 1L)
  say(case, "pedkindraw zoom needed before ids show",
      signif((r$threshold - 1L) / (r$font * r$scale), 3L))
}

## A3. A ready-made app.
cases$app <- function(case = "app") {
  probe(case, "Pedixplorer ped_shiny() arguments",
        names(formals(Pedixplorer::ped_shiny)))
  probe(case, "Pedixplorer ped_ui() builds, class",
        class(Pedixplorer::ped_ui())[[1L]])
  probe(case, "pedkindraw exports naming an app, Shiny, server or UI",
        grep("app|shiny|server|ui$", getNamespaceExports("pedkindraw"),
             ignore.case = TRUE, value = TRUE))
  probe(case, "pedkindraw drawPedigreeDiagram() arguments",
        names(formals(pedkindraw::drawPedigreeDiagram)))
}

## B1. Two animals declared mates with no offspring together.
cases$matesNoOffspring <- function(case = "matesNoOffspring") {
  ped <- rbind(fourAnimals(),
               data.frame(id = c("E", "F"), sire = NA, dam = NA,
                          sex = c("M", "F")))
  probe(case, "kinship2 matings drawn (align.pedigree spouse marks)", {
    k <- k2Pedigree(ped, relation = data.frame(id1 = "E", id2 = "F",
                                               code = 4L))
    sum(kinship2::align.pedigree(k)$spouse > 0L)
  })
  probe(case, "Pedixplorer matings drawn (align() spouse marks)", {
    p <- Pedixplorer::Pedigree(pxFrame(ped), rel_df = data.frame(
      id1 = "E", id2 = "F", code = "Spouse"))
    sum(Pedixplorer::align(p)$spouse > 0L)
  })
  probe(case, "pedkindraw makePedigreeMatingLayout() runs",
               is.list(pedkindraw::makePedigreeMatingLayout(withGen(ped))))
  probe(case, "pedkindraw isolatedIds (left out of the drawing)",
        suppressMessages(
          pedkindraw::makePedigreeMatingLayout(withGen(ped))$isolatedIds))
  probe(case, "pedkindraw mate hint naming E and F",
        suppressMessages(pedkindraw::makePedigreeMatingLayout(
          withGen(ped), hints = list(mate = data.frame(
            left = "E", right = "F", anchor = "either")))))
  ## Plan Phase G15a (pedkindraw S65, R141): the pair declared in matings.
  mates <- data.frame(sire = "E", dam = "F")
  probe(case, "pedkindraw isolatedIds with matings, how many (G15a)",
        length(pedkindraw::makePedigreeMatingLayout(
          withGen(ped), matings = mates)$isolatedIds))
  probe(case, "pedkindraw E, its mating point and F on one row (G15a)", {
    nodes <- pedkindraw::makePedigreeMatingLayout(
      withGen(ped), matings = mates)$nodes
    dot <- nodes$id[which(nodes$title == "0 offspring")]
    length(unique(nodes$y[match(c("E", dot, "F"), nodes$id)])) == 1L
  })
  probe(case, "pedkindraw mate hint naming E and F, with matings (G15a)",
        is.list(pedkindraw::makePedigreeMatingLayout(
          withGen(ped), matings = mates, hints = list(mate = data.frame(
            left = "E", right = "F", anchor = "either")))))
  ## Plan Phase G15b (pedkindraw S66, R141): getMatings() lists the declared
  ## pair after the mating with offspring, as the drawing draws them, and
  ## its own result passed back adds nothing.
  probe(case, "pedkindraw getMatings(ped, matings): sire, dam, offspring", {
    m <- pedkindraw::getMatings(ped, matings = mates)
    paste(m$sire, m$dam, m$offspring)
  })
  probe(case, "pedkindraw getMatings(ped, getMatings(ped)) unchanged",
        identical(pedkindraw::getMatings(ped, pedkindraw::getMatings(ped)),
                  pedkindraw::getMatings(ped)))
}

## B2. An affected status recorded as unknown.
cases$unknownAffected <- function(case = "unknownAffected") {
  ped <- fourAnimals()
  probe(case, "kinship2 '?' marks drawn, B unknown",
        sum(k2Drawn(k2Pedigree(ped, affected = c(1L, NA, 0L, 1L)))$points
            == "?"))
  probe(case, "kinship2 '?' marks drawn, none unknown",
        sum(k2Drawn(k2Pedigree(ped, affected = c(1L, 0L, 0L, 1L)))$points
            == "?"))
  probe(case, "Pedixplorer fills A, B (unknown), C, D", {
    d <- pxFrame(ped)
    d$affection <- c(TRUE, NA, FALSE, TRUE)
    s <- symbolRows(pxPlotDf(Pedixplorer::Pedigree(d)))
    s$fill[order(s$x0, s$y0)][c(1L, 3L, 2L, 4L)]
  })
  ped$affected <- c(TRUE, NA, FALSE, TRUE)
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped))
  n <- lay$nodes[match(ped$id, lay$nodes$id), ]
  probe(case, "pedkindraw fills A, B (unknown), C, D", n$color.background)
  probe(case, "pedkindraw hover text for B mentions",
        regmatches(n$title[[2L]], regexpr("Affected:</b> [A-Za-z]+",
                                          n$title[[2L]])))
}

## B3. Pedixplorer's other marks on a symbol.
cases$markings <- function(case = "markings") {
  ped <- fourAnimals()
  base <- pxPlotDf(Pedixplorer::Pedigree(pxFrame(ped)))
  fields <- list(
    carrier = c(TRUE, FALSE, FALSE, FALSE),
    proband = c(FALSE, FALSE, TRUE, FALSE),
    consultand = c(FALSE, FALSE, FALSE, TRUE),
    evaluated = c(TRUE, FALSE, FALSE, FALSE),
    avail = c(TRUE, FALSE, TRUE, FALSE),
    fertility = c("fertile", "fertile", "infertile", "fertile"),
    miscarriage = c("FALSE", "FALSE", "SAB", "FALSE"),
    adopted = c(FALSE, FALSE, TRUE, FALSE),
    asymptomatic = c(TRUE, FALSE, FALSE, FALSE)
  )
  key <- function(df) paste(df$type, df$x0, df$y0, df$fill, df$border)
  lay0 <- pedkindraw::makePedigreeMatingLayout(withGen(ped))
  for (f in names(fields)) {
    probe(case, paste("Pedixplorer", f, ": picture elements added or changed"),
          {
            d <- pxFrame(ped)
            d[[f]] <- fields[[f]]
            df <- pxPlotDf(Pedixplorer::Pedigree(d))
            new <- df[!key(df) %in% key(base), ]
            if (nrow(new) == 0L) "none" else
              paste(table(sub("_.*", "", new$type)), names(table(
                sub("_.*", "", new$type))))
          })
    probe(case, paste("pedkindraw", f, ": layout identical without it"), {
      p <- ped
      p[[f]] <- fields[[f]]
      identical(pedkindraw::makePedigreeMatingLayout(withGen(p)), lay0)
    })
  }
  ## Phase G13 (pedkindraw S54, R133-R134): the genotyped mark, a column
  ## genotyped (Pedixplorer's avail), drawn as a 4 px outline.
  typed <- ped
  typed$genotyped <- fields$avail
  layTyped <- pedkindraw::makePedigreeMatingLayout(withGen(typed))
  probe(case, "pedkindraw genotyped : outline widths of A, B, C, D",
        layTyped$nodes$borderWidth[match(ped$id, layTyped$nodes$id)])
  probe(case, "pedkindraw genotyped : legend row and its outline width", {
    rows <- pedkindraw::drawPedigreeDiagram(layTyped)$x$legend$nodes
    at <- match("Genotyped", rows$label)
    paste(rows$label[[at]], rows$shape[[at]], rows$borderWidth[[at]])
  })
  ## Phase G13 (pedkindraw S55, R133 and R135): the carrier mark, a column
  ## carrier (Pedixplorer's name), drawn as a black dot at the symbol's centre.
  carried <- ped
  carried$carrier <- fields$carrier
  layCarried <- pedkindraw::makePedigreeMatingLayout(withGen(carried))
  probe(case, "pedkindraw carrier : carrier field of A, B, C, D",
        layCarried$nodes$carrier[match(ped$id, layCarried$nodes$id)])
  probe(case, "pedkindraw carrier : legend row and the dot's handler", {
    w <- pedkindraw::drawPedigreeDiagram(layCarried)
    rows <- w$x$legend$nodes
    at <- match("Carrier", rows$label)
    paste(rows$label[[at]], rows$shape[[at]],
          grepl("n.carrier === true", w$x$events$afterDrawing, fixed = TRUE))
  })
  ## Phase G13 (pedkindraw S56, R133 and R136): the proband and consultand
  ## marks, columns proband and consultand (Pedixplorer's names), drawn as a
  ## black arrow at the lower left of the symbol, "P" beside a proband's.
  pointed <- ped
  pointed$proband <- fields$proband
  pointed$consultand <- fields$consultand
  layPointed <- pedkindraw::makePedigreeMatingLayout(withGen(pointed))
  probe(case, "pedkindraw proband : proband field of A, B, C, D",
        layPointed$nodes$proband[match(ped$id, layPointed$nodes$id)])
  probe(case, "pedkindraw consultand : consultand field of A, B, C, D",
        layPointed$nodes$consultand[match(ped$id, layPointed$nodes$id)])
  probe(case, "pedkindraw proband : legend rows, the arrows' handler, points", {
    w <- pedkindraw::drawPedigreeDiagram(layPointed)
    rows <- w$x$legend$nodes
    paste(paste(intersect(c("Proband", "Consultand"), rows$label),
                collapse = " "),
          grepl("n.proband === true", w$x$events$afterDrawing, fixed = TRUE),
          paste(w$x$nodes$id[startsWith(w$x$nodes$id, "__mark_")],
                collapse = " "))
  })
  ## Phase G13 (pedkindraw S57, R133 and R137): the evaluated mark, a column
  ## evaluated (Pedixplorer's name), drawn as a black star to the right of
  ## the upper-right corner of the symbol.
  seen <- ped
  seen$evaluated <- fields$evaluated
  laySeen <- pedkindraw::makePedigreeMatingLayout(withGen(seen))
  probe(case, "pedkindraw evaluated : evaluated field of A, B, C, D",
        laySeen$nodes$evaluated[match(ped$id, laySeen$nodes$id)])
  probe(case, "pedkindraw evaluated : legend row, the star's handler, points", {
    w <- pedkindraw::drawPedigreeDiagram(laySeen)
    rows <- w$x$legend$nodes
    at <- match("Evaluated", rows$label)
    paste(rows$label[[at]], rows$shape[[at]],
          grepl("n.evaluated === true", w$x$events$afterDrawing, fixed = TRUE),
          paste(w$x$nodes$id[startsWith(w$x$nodes$id, "__eval_")],
                collapse = " "))
  })
  ## Phase G13 (pedkindraw S58, R133 and R138): the infertile mark, a column
  ## fertility (Pedixplorer's name and values), drawn as a line down from the
  ## symbol and two bars (one for no offspring by choice), the id moved below.
  barred <- ped
  barred$fertility <- fields$fertility
  layBarred <- pedkindraw::makePedigreeMatingLayout(withGen(barred))
  probe(case, "pedkindraw fertility : fertility field of A, B, C, D",
        layBarred$nodes$fertility[match(ped$id, layBarred$nodes$id)])
  probe(case, "pedkindraw fertility : legend row, the bars' handler, points", {
    w <- pedkindraw::drawPedigreeDiagram(layBarred)
    rows <- w$x$legend$nodes
    at <- match("Infertile", rows$label)
    paste(rows$label[[at]], rows$shape[[at]],
          grepl("n.fertility === 'infertile'", w$x$events$afterDrawing,
                fixed = TRUE),
          paste(w$x$nodes$id[startsWith(w$x$nodes$id, "__fert_")],
                collapse = " "))
  })
  ## Phase G13 (pedkindraw S59, R133 and R139): the miscarriage mark, a column
  ## miscarriage (Pedixplorer's name and values), drawn as a triangle 0.6 the
  ## symbol's size, a line across a termination's or an ectopic pregnancy's.
  lost <- ped
  lost$miscarriage <- fields$miscarriage
  layLost <- pedkindraw::makePedigreeMatingLayout(withGen(lost))
  probe(case, "pedkindraw miscarriage : miscarriage field of A, B, C, D",
        layLost$nodes$miscarriage[match(ped$id, layLost$nodes$id)])
  probe(case, "pedkindraw miscarriage : legend row, C's shape, size, points", {
    w <- pedkindraw::drawPedigreeDiagram(layLost)
    rows <- w$x$legend$nodes
    at <- match("Miscarriage", rows$label)
    c3 <- match("C", w$x$nodes$id)
    paste(rows$label[[at]], rows$shape[[at]], w$x$nodes$shape[[c3]],
          w$x$nodes$size[[c3]],
          paste(w$x$nodes$id[startsWith(w$x$nodes$id, "__misc_")],
                collapse = " "))
  })
  probe(case, "kinship2 pedigree() arguments",
        names(formals(kinship2::pedigree)))
}

## B4. A measured trait: affected above a threshold.
cases$measuredTrait <- function(case = "measuredTrait") {
  ped <- fourAnimals()
  value <- c(2.5, 0.0, 0.3, 9.0)
  probe(case, "Pedixplorer fills, affected above 5", {
    d <- pxFrame(ped)
    d$val <- value
    p <- Pedixplorer::Pedigree(d, col_aff = "val")
    p <- Pedixplorer::generate_colors(p, col_aff = "val", is_num = TRUE,
                                      threshold = 5.0, sup_thres_aff = TRUE,
                                      add_to_scale = FALSE)
    s <- symbolRows(pxPlotDf(p))
    s$fill[order(s$x0, s$y0)][c(1L, 3L, 2L, 4L)]
  })
  probe(case, "Pedixplorer legend labels", {
    d <- pxFrame(ped)
    d$val <- value
    p <- Pedixplorer::Pedigree(d, col_aff = "val")
    p <- Pedixplorer::generate_colors(p, col_aff = "val", is_num = TRUE,
                                      threshold = 5.0, sup_thres_aff = TRUE,
                                      add_to_scale = FALSE)
    Pedixplorer::fill(p)$labels
  })
  ped$affected <- value
  probe(case, "pedkindraw fills, affected = 2.5, 0, 0.3, 9", {
    lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped))
    lay$nodes$color.background[match(ped$id, lay$nodes$id)]
  })
  ## Phase G12 (pedkindraw S53, R131-R132): the cut-off conditionThresholds.
  probe(case, "pedkindraw fills, conditionThresholds affected > 5", {
    lay <- pedkindraw::makePedigreeMatingLayout(
      withGen(ped), conditionThresholds = c(affected = "> 5")
    )
    lay$nodes$color.background[match(ped$id, lay$nodes$id)]
  })
  probe(case, "pedkindraw legend label, conditionThresholds affected > 5", {
    lay <- pedkindraw::makePedigreeMatingLayout(
      withGen(ped), conditionThresholds = c(affected = "> 5")
    )
    labels <- pedkindraw::drawPedigreeDiagram(lay)$x$legend$nodes$label
    labels[startsWith(labels, "Affected")]
  })
}

## B5. Colours, hatching, sizes and spacing.
cases$style <- function(case = "style") {
  ped <- fourAnimals()
  probe(case, "kinship2 plot.pedigree() style arguments",
        intersect(names(formals(kinship2::plot.pedigree)),
                  c("col", "density", "angle", "cex", "symbolsize",
                    "branch", "packed", "align", "width")))
  probe(case, "kinship2 symbol borders with col = red, blue, black, black",
        k2Drawn(k2Pedigree(ped), col = c("red", "blue", "black",
                                         "black"))$border)
  probe(case, "Pedixplorer plot() style arguments",
        intersect(pxMethodArgs("plot", c("Pedigree", "missing")),
                  c("cex", "symbolsize", "branch", "packed", "align",
                    "width", "lwd", "label_cex", "leg_cex")))
  probe(case, "Pedixplorer fills with colors_aff = orange", {
    d <- pxFrame(ped)
    d$affection <- c(TRUE, FALSE, FALSE, TRUE)
    p <- Pedixplorer::generate_colors(Pedixplorer::Pedigree(d),
                                      col_aff = "affection",
                                      colors_aff = c("orange", "orange"),
                                      add_to_scale = FALSE)
    sort(unique(symbolRows(pxPlotDf(p))$fill))
  })
  probe(case, "pedkindraw drawPedigreeDiagram() arguments",
        names(formals(pedkindraw::drawPedigreeDiagram)))
  ## Colours edited in a layout, counted in the widget's data (legend
  ## pictures carry them URL-encoded, so the count leaves out the "#").
  ## The drawing script's own colour list is taken out before counting.
  widgetCount <- function(lay, colours) {
    json <- as.character(htmlwidgets:::toJSON(
      pedkindraw::drawPedigreeDiagram(lay)$x))
    json <- sub("var colors = \\[[^]]*\\]", "", json)
    vapply(colours, function(s) {
      lengths(regmatches(json, gregexpr(s, json, fixed = TRUE)))
    }, integer(1L))
  }
  one <- ped
  one$affected <- c(TRUE, FALSE, FALSE, TRUE)
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(one))
  lay$nodes$color.background[lay$nodes$color.background == "#CC79A7"] <-
    "#333333"
  probe(case, "pedkindraw, 1 condition, fill 333333: count outside script",
        widgetCount(lay, c("333333", "CC79A7")))
  two <- ped
  two$affected1 <- c(TRUE, FALSE, FALSE, TRUE)
  two$affected2 <- c(FALSE, TRUE, FALSE, TRUE)
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(two))
  lay$conditions$color <- c("#111111", "#222222")
  probe(case, "pedkindraw, 2 conditions, 111111 222222: count outside script",
        widgetCount(lay, c("111111", "222222", "CC79A7", "E69F00")))
  probe(case, "pedkindraw sections script colours (the drawing's own list)",
        {
          json <- as.character(htmlwidgets:::toJSON(
            pedkindraw::drawPedigreeDiagram(lay)$x))
          regmatches(json, regexpr("var colors = \\[[^]]*\\]", json))
        })
  ## Plan Phase G4 (pedkindraw S45, R111-R113): the colours chosen.
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(one),
                                              conditionColors = "orange")
  probe(case, "pedkindraw, 1 condition, conditionColors = orange: fills",
        unique(lay$nodes$color.background[match(one$id[one$affected],
                                                lay$nodes$id)]))
  probe(case, "pedkindraw, 1 condition, conditionColors = orange: legend", {
    legend <- pedkindraw::drawPedigreeDiagram(lay)$x$legend$nodes
    legend$color.background[legend$label == "Affected"]
  })
  lay <- pedkindraw::makePedigreeMatingLayout(
    withGen(two), conditionColors = c("#111111", "#222222")
  )
  probe(case, "pedkindraw, 2 conditions, conditionColors: sections script",
        {
          json <- as.character(htmlwidgets:::toJSON(
            pedkindraw::drawPedigreeDiagram(lay)$x))
          regmatches(json, regexpr("var colors = \\[[^]]*\\]", json))
        })
  ## Plan Phase G14 (pedkindraw S60, R140): the symbols' size, a multiple of
  ## each package's own: kinship2's symbol width at symbolsize 0.6, 1 and
  ## 1.6 (plot.pedigree()'s boxw, in its plot's units) and pedkindraw's
  ## animals' node size at symbolSize 0.6, 1 and 1.6.
  probe(case, "kinship2 boxw at symbolsize 0.6, 1, 1.6", {
    grDevices::pdf(NULL)
    on.exit(grDevices::dev.off())
    vapply(c(0.6, 1.0, 1.6), function(s) {
      round(kinship2::plot.pedigree(k2Pedigree(ped), symbolsize = s)$boxw, 3L)
    }, numeric(1L))
  })
  probe(case, "pedkindraw node size at symbolSize 0.6, 1, 1.6",
        vapply(c(0.6, 1.0, 1.6), function(s) {
          lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped),
                                                      symbolSize = s)
          unique(lay$nodes$size[match(ped$id, lay$nodes$id)])
        }, integer(1L)))
  ## Plan Phase G14 (pedkindraw S61, R140): the ids' size, a multiple of each
  ## package's own: kinship2's widest id as a fraction of the distance
  ## between two neighbours at cex 0.7, 1 and 1.4 (its symbol grows with cex
  ## too), and pedkindraw's ids' size in pixels at textSize 0.7, 1 and 1.4
  ## (no font.size column at 1: vis.js's own 14).
  probe(case, "kinship2 widest id per neighbour distance at cex 0.7, 1, 1.4", {
    grDevices::pdf(NULL)
    on.exit(grDevices::dev.off())
    vapply(c(0.7, 1.0, 1.4), function(cx) {
      drawn <- kinship2::plot.pedigree(k2Pedigree(ped), cex = cx)
      xs <- sort(unique(round(drawn$x[!is.na(drawn$x)], 6L)))
      round(max(graphics::strwidth(ped$id, cex = cx)) / min(diff(xs)), 3L)
    }, numeric(1L))
  })
  probe(case, "pedkindraw id text px at textSize 0.7, 1, 1.4",
        vapply(c(0.7, 1.0, 1.4), function(s) {
          lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped),
                                                      textSize = s)
          px <- lay$nodes$font.size
          if (is.null(px)) 14L else unique(px[match(ped$id, lay$nodes$id)])
        }, integer(1L)))
  ## Plan Phase G14 (pedkindraw S62, R140): the spacing. kinship2's distances
  ## follow its page: the distance between its rows as a multiple of the
  ## least distance between two neighbours in a row, on pages of 7 by 7, 14
  ## by 7 and 7 by 14 inches; pedkindraw's least distance between two
  ## neighbours and between rows, in units, at columnSpacing and rowSpacing
  ## 0.75, 1 and 1.4.
  probe(case, "kinship2 rows per column distance, 7x7, 14x7, 7x14 in pages",
        vapply(list(c(7.0, 7.0), c(14.0, 7.0), c(7.0, 14.0)), function(page) {
          grDevices::pdf(NULL, width = page[[1L]], height = page[[2L]])
          on.exit(grDevices::dev.off())
          drawn <- kinship2::plot.pedigree(k2Pedigree(ped))
          ok <- !is.na(drawn$x)
          xIn <- graphics::grconvertX(drawn$x[ok], "user", "inches")
          yIn <- graphics::grconvertY(drawn$y[ok], "user", "inches")
          rows <- split(xIn, drawn$y[ok])
          column <- min(unlist(lapply(rows, function(x) diff(sort(x)))))
          row <- min(diff(sort(unique(round(yIn, 6L)))))
          round(row / column, 2L)
        }, numeric(1L)))
  probe(case, "pedkindraw column and row units at spacing 0.75, 1, 1.4",
        vapply(c(0.75, 1.0, 1.4), function(s) {
          lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped),
                                                      columnSpacing = s,
                                                      rowSpacing = s)
          at <- lay$nodes[match(ped$id, lay$nodes$id), ]
          rows <- split(at$x, at$y)
          column <- min(unlist(lapply(rows, function(x) diff(sort(x)))))
          row <- min(diff(sort(unique(at$y))))
          paste(round(column), round(row))
        }, character(1L)))
  ## Plan Phase G14 (pedkindraw S63, R140): the line width. kinship2 passes
  ## plot()'s ... to par(), so lwd sets the width of every line it draws
  ## (read from its first recorded par() call, before it puts par back);
  ## Pedixplorer's lwd multiplies the lines of its drawing table (its rows
  ## whose lwd doubles at 2, of all rows); pedkindraw's line, related
  ## parents' mating line, outline and genotyped outline at lineWidth 0.5, 1
  ## and 3 (vis.js's 1 where none is set).
  probe(case, "kinship2 lwd its plot(lwd = 1, 2, 3) gives par()",
        vapply(c(1.0, 2.0, 3.0), function(w) {
          grDevices::pdf(NULL)
          on.exit(grDevices::dev.off())
          grDevices::dev.control("enable")
          kinship2::plot.pedigree(k2Pedigree(ped), lwd = w)
          shown <- grDevices::recordPlot()[[1L]]
          calls <- vapply(shown, function(x) x[[2L]][[1L]]$name,
                          character(1L))
          shown[calls == "C_par"][[1L]][[2L]][[2L]][["lwd"]]
        }, numeric(1L)))
  probe(case, "Pedixplorer rows whose lwd doubles at lwd 2, of all rows", {
    p <- Pedixplorer::Pedigree(pxFrame(ped))
    one <- pxPlotDf(p, lwd = 1.0)
    two <- pxPlotDf(p, lwd = 2.0)
    paste(sum(two$lwd == 2.0 * one$lwd, na.rm = TRUE), "of", nrow(one))
  })
  probe(case, "pedkindraw line, related, outline, genotyped at 0.5, 1, 3", {
    related <- data.frame(
      id = c("S", "D1", "D2", "A", "B", "C"),
      sire = c(NA, NA, NA, "S", "S", "A"), dam = c(NA, NA, NA, "D1", "D2", "B"),
      sex = c("M", "F", "F", "M", "F", "M"),
      genotyped = c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
      stringsAsFactors = FALSE
    )
    vapply(c(0.5, 1.0, 3.0), function(w) {
      lay <- pedkindraw::makePedigreeMatingLayout(withGen(related),
                                                  lineWidth = w)
      widths <- lay$edges$width
      widths[is.na(widths)] <- 1.0
      outline <- lay$nodes$borderWidth[match(c("A", "S"), lay$nodes$id)]
      paste(min(widths), max(widths), outline[[1L]], outline[[2L]])
    }, character(1L))
  })
}

## B6. Longer or several-line labels.
cases$labels <- function(case = "labels") {
  ped <- fourAnimals()
  text <- c("age 7\nMHC A01/B02 long text", "", "", "")
  probe(case, "kinship2 labels written, id = id plus text", {
    drawn <- k2Drawn(k2Pedigree(ped), id = paste0(ped$id, "\n", text))
    drawn$text
  })
  probe(case, "Pedixplorer extra label texts written", {
    d <- pxFrame(ped)
    d$lab <- text
    df <- pxPlotDf(Pedixplorer::Pedigree(d), label = "lab")
    df$label[df$type == "text" & !df$label %in% ped$id & !is.na(df$label)]
  })
  ped$name <- c("age 7\nMHC A01", "age 7\nMHC A01/B02 long text", NA, "")
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped))
  probe(case, "pedkindraw labels with a name column",
        lay$nodes$label[match(ped$id, lay$nodes$id)])
  ## Plan Phase G3 (pedkindraw S44, R108-R110): the limit lifted.
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped), maxNameChars = Inf)
  probe(case, "pedkindraw labels with maxNameChars = Inf",
        lay$nodes$label[match(ped$id, lay$nodes$id)])
}

## B7. A picture of what shrinking removed.
cases$shrinkPicture <- function(case = "shrinkPicture") {
  sp <- sampleFamily()
  k <- kinship2::pedigree(sp$id, sp$dadid, sp$momid, sp$sex, missid = NA,
                          affected = sp$affection)
  s <- kinship2::pedigree.shrink(k, avail = sp$avail, maxBits = 16L)
  probe(case, "kinship2 pedigree.shrink() class", class(s))
  probe(case, "kinship2 plot.pedigree.shrink() pdf pages", {
    f <- tempfile(fileext = ".pdf")
    grDevices::pdf(f)
    kinship2::plot.pedigree.shrink(s, bigped = FALSE)
    grDevices::dev.off()
    pdfPages(f)
  })
  ped <- data.frame(id = sp$id, sire = sp$dadid, dam = sp$momid,
                    sex = c("M", "F")[sp$sex], stringsAsFactors = FALSE)
  shrunk <- pedkindraw::shrinkPedigree(
    ped, genotyped = sp$avail == 1L,
    affected = !is.na(sp$affection) & sp$affection == 1L)
  probe(case, "pedkindraw shrinkPedigree() returns", names(shrunk))
  ## Plan Phase G9 (pedkindraw S50, R125): kinship2's plot.pedigree.shrink()
  ## draws the shrunk pedigree, the animals kept (its help: "the trimmed
  ## pedigree.shrink object"); ?shrinkPedigree's example draws the whole
  ## pedigree with the animals removed filled, from idTrimmed.
  probe(case, "kinship2 animals kept, the ones plot.pedigree.shrink() draws",
        length(s$pedObj$id))
  ped$affected_removed <- ped$id %in% shrunk$idTrimmed
  ## An animal with no parent, mate or offspring is not drawn (the layout's
  ## isolatedIds): 113 here, one of the animals removed.
  lay <- suppressMessages(pedkindraw::makePedigreeMatingLayout(withGen(ped)))
  drawn <- ped$id %in% lay$nodes$id
  fill <- lay$nodes$color.background[match(ped$id, lay$nodes$id)]
  filled <- drawn & !is.na(fill) & fill == "#CC79A7"
  probe(case, "pedkindraw animals drawn, filled, removed, kept",
        c(sum(drawn), sum(filled), length(shrunk$idTrimmed),
          nrow(shrunk$ped)))
  probe(case, "pedkindraw animals not drawn (isolatedIds)", lay$isolatedIds)
  probe(case, "pedkindraw filled animals are the removed ones drawn",
        setequal(ped$id[filled], intersect(shrunk$idTrimmed, ped$id[drawn])))
}

## C1. Keep the relatives within k steps of the informative animals.
cases$distanceSubset <- function(case = "distanceSubset") {
  sp <- sampleFamily()
  p <- Pedixplorer::Pedigree(sp)
  p <- Pedixplorer::is_informative(p, col_aff = "affection",
                                   informative = "AvAf")
  inf <- sub("^1_", "", Pedixplorer::id(Pedixplorer::ped(p))[
    Pedixplorer::isinf(Pedixplorer::ped(p))])
  probe(case, "animals; informative (available and affected)",
        c(nrow(sp), length(inf)))
  for (d in 1L:3L) {
    probe(case, paste("Pedixplorer useful_inds(max_dist =", d, ") keeps"),
          sum(Pedixplorer::useful(Pedixplorer::ped(
            Pedixplorer::useful_inds(p, max_dist = d)))))
  }
  ped <- data.frame(id = sp$id, sire = sp$dadid, dam = sp$momid,
                    sex = c("M", "F")[sp$sex], stringsAsFactors = FALSE)
  probe(case, "pedkindraw trimPedigree(ped, informative) keeps",
        nrow(pedkindraw::trimPedigree(ped, inf)))
  probe(case, "pedkindraw trimPedigree(..., removeUninformative) keeps",
        nrow(pedkindraw::trimPedigree(ped, inf, removeUninformative = TRUE)))
  probe(case, "pedkindraw trimPedigree() arguments",
        names(formals(pedkindraw::trimPedigree)))
  ## G11 (pedkindraw S52, R129-R130): the same animals as useful_inds().
  for (d in 1L:3L) {
    kept <- pedkindraw::getNearRelativePedigree(ped, inf, d)$id
    useful <- Pedixplorer::ped(Pedixplorer::useful_inds(p, max_dist = d))
    theirs <- sub("^1_", "",
                  Pedixplorer::id(useful)[Pedixplorer::useful(useful)])
    probe(case, paste("pedkindraw getNearRelativePedigree(ped, informative,",
                      d, ") keeps; the same animals as useful_inds()"),
          c(length(kept), setequal(kept, theirs)))
  }
}

## C2. Generation numbers aligned for drawing.
cases$alignedDepth <- function(case = "alignedDepth") {
  sp <- sampleFamily()
  k <- kinship2::pedigree(sp$id, sp$dadid, sp$momid, sp$sex, missid = NA)
  plain <- kinship2::kindepth(k)
  probe(case, "kinship2 kindepth(align = TRUE) differs from plain in",
        sum(kinship2::kindepth(k, align = TRUE) != plain))
  probe(case, "pedkindraw findGeneration() equals kinship2's plain in",
        sum(pedkindraw::findGeneration(sp$id, sp$dadid, sp$momid) == plain))
  probe(case, "pedkindraw findGeneration() arguments",
        names(formals(pedkindraw::findGeneration)))
  probe(case,
        "pedkindraw findGeneration(alignMates = TRUE) equals kinship2's in",
        sum(pedkindraw::findGeneration(sp$id, sp$dadid, sp$momid,
                                       alignMates = TRUE) ==
              kinship2::kindepth(k, align = TRUE)))
}

## C3. The package's own layout hints, to edit.
cases$ownHints <- function(case = "ownHints") {
  sp <- sampleFamily()
  k <- kinship2::pedigree(sp$id, sp$dadid, sp$momid, sp$sex, missid = NA)
  probe(case, "kinship2 autohint() elements",
             names(kinship2::autohint(k)))
  probe(case, "Pedixplorer auto_hint() class",
        class(Pedixplorer::auto_hint(Pedixplorer::Pedigree(sp)))[[1L]])
  probe(case, "Pedixplorer best_hint() class",
        class(Pedixplorer::best_hint(Pedixplorer::Pedigree(sp)))[[1L]])
  ped <- withGen(data.frame(id = sp$id, sire = sp$dadid, dam = sp$momid,
                            sex = c("M", "F")[sp$sex],
                            stringsAsFactors = FALSE))
  layout <- suppressMessages(pedkindraw::makePedigreeMatingLayout(ped))
  probe(case, "pedkindraw makePedigreeMatingLayout() returns", names(layout))
  ## Phase G10 (pedkindraw S51, R127-R128): the hints the layout used.
  probe(case, "pedkindraw layout$hints: order numbers, mate rows",
        c(length(layout$hints$order), NROW(layout$hints$mate)))
  probe(case, "pedkindraw layout$hints passed back: the same layout",
        identical(pedkindraw::makePedigreeMatingLayout(
          ped, hints = layout$hints
        ), layout))
  probe(case, "pedkindraw asPedFrame() of kinship2's autohint: order, mates",
        {
          k$hints <- kinship2::autohint(k)
          a <- pedkindraw::asPedFrame(k)
          c(length(a$hints$order), NROW(a$hints$mate))
        })
}

## C4. Missing parents written "0" or "", and sex written another way.
cases$inputCodes <- function(case = "inputCodes") {
  ped <- fourAnimals()
  zero <- ped
  zero$sire[is.na(zero$sire)] <- "0"
  zero$dam[is.na(zero$dam)] <- "0"
  probe(case, "kinship2 pedigree(missid = \"0\") animals", length(
    kinship2::pedigree(zero$id, zero$sire, zero$dam, sexNumber(zero$sex),
                       missid = "0")$id))
  probe(case, "Pedixplorer Pedigree() with \"0\" parents: founders", {
    p <- Pedixplorer::Pedigree(data.frame(
      id = zero$id, dadid = zero$sire, momid = zero$dam,
      sex = sexNumber(zero$sex)))
    sum(is.na(Pedixplorer::dadid(Pedixplorer::ped(p))))
  })
  probe(case, "pedkindraw checkPedigree() with \"0\" parents",
        paste(pedkindraw::checkPedigree(zero)$check,
              pedkindraw::checkPedigree(zero)$id))
  probe(case, "pedkindraw findGeneration() with \"0\" parents",
        pedkindraw::findGeneration(zero$id, zero$sire, zero$dam))
  recoded <- pedkindraw::recodePedigree(zero)
  probe(case, "pedkindraw recodePedigree() of \"0\" parents: checkPedigree()",
        nrow(pedkindraw::checkPedigree(recoded)))
  probe(case, "pedkindraw recodePedigree() of \"0\" parents: findGeneration()",
        pedkindraw::findGeneration(recoded$id, recoded$sire, recoded$dam))
  blank <- ped
  blank$sire[is.na(blank$sire)] <- ""
  blank$dam[is.na(blank$dam)] <- ""
  probe(case, "pedkindraw checkPedigree() with \"\" parents",
        paste(pedkindraw::checkPedigree(blank)$check,
              pedkindraw::checkPedigree(blank)$id))
  for (codes in list(1L:2L, c("1", "2"), c("male", "female"), c("m", "f"))) {
    s <- codes[sexNumber(ped$sex)]
    written <- if (is.numeric(codes)) "numbers 1/2" else
      paste0("text \"", paste(codes, collapse = "\"/\""), "\"")
    probe(case, paste("kinship2 pedigree() sex as", written, ": sex read"),
          as.character(kinship2::pedigree(ped$id, ped$sire, ped$dam, s,
                                          missid = NA)$sex))
    p <- ped
    p$sex <- s
    probe(case, paste("pedkindraw sex as", written, ": checkPedigree() rows"),
          nrow(pedkindraw::checkPedigree(p)))
    probe(case, paste("pedkindraw sex as", written, ": shapes drawn"), {
      lay <- pedkindraw::makePedigreeMatingLayout(withGen(p))
      lay$nodes$shape[match(p$id, lay$nodes$id)]
    })
    probe(case, paste("pedkindraw recodePedigree() of sex as", written,
                      ": sex, shapes drawn"), {
      r <- pedkindraw::recodePedigree(p)
      lay <- pedkindraw::makePedigreeMatingLayout(withGen(r))
      c(r$sex, lay$nodes$shape[match(r$id, lay$nodes$id)])
    })
  }
}

## C5. Small lookups: offspring counts and mates.
cases$lookups <- function(case = "lookups") {
  ped <- fourAnimals()
  probe(case, "Pedixplorer Pedigree() offspring counts A, B, C, D", {
    x <- as.data.frame(Pedixplorer::ped(Pedixplorer::Pedigree(pxFrame(ped))))
    x$num_child_tot
  })
  probe(case, "Pedixplorer lookup functions",
        intersect(getNamespaceExports("Pedixplorer"),
                  c("num_child", "parent_of", "is_parent", "descendants",
                    "ancestors", "is_founder", "spouse")))
  probe(case, "pedkindraw lookup exports",
        sort(grep("^(get|is|has)", getNamespaceExports("pedkindraw"),
                  value = TRUE)))
  probe(case, "pedkindraw getOffspring(ped, \"A\")",
        pedkindraw::getOffspring(ped, "A"))
  ## Phase G6 (pedkindraw S47, R117-R119): the count is Pedixplorer's
  ## num_child_dir, each animal's own offspring.
  probe(case, "Pedixplorer num_child() num_child_dir A, B, C, D",
        Pedixplorer::num_child(ped$id, ped$sire, ped$dam)$num_child_dir)
  probe(case, "pedkindraw countOffspring(ped)",
        pedkindraw::countOffspring(ped))
  probe(case, "pedkindraw getMatings(ped): sire, dam, offspring", {
    m <- pedkindraw::getMatings(ped)
    paste(m$sire, m$dam, m$offspring)
  })
}

## Ruled R3: block-sparse kinship over many families.
cases$blockKinship <- function(case = "blockKinship") {
  env <- new.env()
  utils::data("minnbreast", package = "kinship2", envir = env)
  mb <- env$minnbreast
  probe(case, "minnbreast people, families",
        c(nrow(mb), length(unique(mb$famid))))
  peak <- function(expr) {
    invisible(gc(reset = TRUE))
    t0 <- proc.time()[["elapsed"]]
    value <- expr
    used <- gc()
    list(value = value, seconds = proc.time()[["elapsed"]] - t0,
         mb = sum(used[, ncol(used)]))
  }
  k2 <- peak(kinship2::makekinship(mb$famid, mb$id, mb$fatherid,
                                   mb$motherid))
  say(case, "kinship2 makekinship(): seconds, R's peak memory MB",
      round(c(k2$seconds, k2$mb), 1L))
  say(case, "kinship2 makekinship(): class, values stored",
      c(class(k2$value), length(k2$value@x)))
  id <- as.character(mb$id)
  sire <- as.character(mb$fatherid)
  dam <- as.character(mb$motherid)
  sire[is.na(mb$fatherid) | sire == "0"] <- NA
  dam[is.na(mb$motherid) | dam == "0"] <- NA
  gen <- pedkindraw::findGeneration(id, sire, dam)
  pk <- peak(pedkindraw::kinship(id, sire, dam, gen, sparse = TRUE))
  say(case, "pedkindraw kinship(sparse = TRUE): seconds, R's peak memory MB",
      round(c(pk$seconds, pk$mb), 1L))
  say(case, "pedkindraw kinship(sparse = TRUE): class, values stored",
      c(class(pk$value), length(pk$value@x)))
  say(case, "same ids in the same order",
      identical(rownames(k2$value), rownames(pk$value)))
  same <- k2$value[rownames(pk$value), colnames(pk$value)]
  say(case, "largest difference between the two, matched by id",
      max(abs(Matrix::summary(methods::as(same, "generalMatrix") -
                                pk$value)$x)))
}

## C6. Removing listed animals, a parent among them.
cases$removeAnimals <- function(case = "removeAnimals") {
  ## A x B -> C, D; C x E -> F, G; D x H -> I.
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
    sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "D"),
    dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "H"),
    sex = c("M", "F", "M", "M", "F", "M", "F", "F", "F"),
    stringsAsFactors = FALSE)
  k <- k2Pedigree(ped)
  probe(case, "kinship2 pedigree.trim(\"C\") (C sires F and G)",
        length(kinship2::pedigree.trim("C", k)$id))
  probe(case, "kinship2 pedigree.trim(\"I\") (a leaf)",
        length(kinship2::pedigree.trim("I", k)$id))
  rest <- ped[ped$id != "C", ]
  probe(case, "pedkindraw checkPedigree() after dropping C's row",
        paste(pedkindraw::checkPedigree(rest)[, c("check", "id", "detail")]))
  probe(case, "pedkindraw kinship() after dropping C's row: K(F, G)", {
    k <- pedkindraw::kinship(rest$id, rest$sire, rest$dam,
                             pedkindraw::findGeneration(rest$id, rest$sire,
                                                        rest$dam))
    k["F", "G"]
  })
  probe(case, "pedkindraw addParents() after dropping C's row: rows, K(F, G)",
        {
          fixed <- pedkindraw::addParents(rest)
          k <- pedkindraw::kinship(fixed$id, fixed$sire, fixed$dam,
                                   pedkindraw::findGeneration(
                                     fixed$id, fixed$sire, fixed$dam))
          c(nrow(fixed), k["F", "G"])
        })
  probe(case, "pedkindraw C's offspring given an unknown sire by hand: K(F, G)",
        {
          hand <- rest
          hand$sire[!is.na(hand$sire) & hand$sire == "C"] <- NA
          k <- pedkindraw::kinship(hand$id, hand$sire, hand$dam,
                                   pedkindraw::findGeneration(
                                     hand$id, hand$sire, hand$dam))
          k["F", "G"]
        })
  probe(case, paste("pedkindraw removeAnimals(ped, \"C\") (G7): ids kept;",
                    "F's sire and dam; checkPedigree() rows; K(F, G)"), {
    kept <- pedkindraw::removeAnimals(ped, "C")
    k <- pedkindraw::kinship(kept$id, kept$sire, kept$dam,
                             pedkindraw::findGeneration(
                               kept$id, kept$sire, kept$dam))
    f <- kept$id == "F"
    c(paste(kept$id, collapse = ""), kept$sire[f], kept$dam[f],
      nrow(pedkindraw::checkPedigree(kept)), k["F", "G"])
  })
  p <- Pedixplorer::Pedigree(pxFrame(ped))
  for (dp in list(NULL, "one", "both")) {
    probe(case, paste0("Pedixplorer subset(all but C, del_parents = ",
                       if (is.null(dp)) "NULL" else dp,
                       "): ids kept; F's sire and dam"), {
      q <- Pedixplorer::ped(Pedixplorer::subset(
        p, setdiff(Pedixplorer::id(Pedixplorer::ped(p)), "C"),
        del_parents = dp))
      kept <- Pedixplorer::id(q)
      f <- kept == "F"
      c(paste(kept, collapse = ""), Pedixplorer::dadid(q)[f],
        Pedixplorer::momid(q)[f])
    })
  }
}

## Not a gap: five or more conditions.
cases$fiveConditions <- function(case = "fiveConditions") {
  ped <- fourAnimals()
  affected <- matrix(c(1L, 0L, 0L, 1L, 0L, 1L, 0L, 0L, 1L, 1L, 0L, 0L, 0L, 0L,
                       1L, 1L, 1L, 0L, 1L, 0L), 4L)
  probe(case, "kinship2 plot.pedigree() with 5 conditions", {
    k2Drawn(k2Pedigree(ped, affected = affected))
    "drawn"
  })
  for (i in 1L:5L) ped[[paste0("affected", i)]] <- affected[, i] == 1L
  lay <- pedkindraw::makePedigreeMatingLayout(withGen(ped))
  probe(case, "pedkindraw conditions drawn", lay$conditions$column)
  probe(case, "pedkindraw conditionsNotDrawn", lay$conditionsNotDrawn)
}

## Ruled R13: file readers.
cases$plinkReader <- function(case = "plinkReader") {
  f <- tempfile(fileext = ".fam")
  writeLines(c("1\tA\t0\t0\t1\t1", "1\tB\t0\t0\t2\t1",
               "1\tC\tA\tB\t1\t2", "1\tD\tA\tB\t2\t1"), f)
  probe(case, "Pedixplorer plink_to_pedigree() class",
        class(Pedixplorer::plink_to_pedigree(f))[[1L]])
  probe(case, "pedkindraw exports naming read, file or plink",
        grep("read|file|plink", getNamespaceExports("pedkindraw"),
             ignore.case = TRUE, value = TRUE))
}

## Ruled R21: datasets.
cases$datasets <- function(case = "datasets") {
  for (pkg in c("kinship2", "Pedixplorer", "pedkindraw")) {
    probe(case, paste(pkg, "datasets"),
          utils::data(package = pkg)$results[, "Item"])
  }
  probe(case, "pedkindraw files in its extdata folder",
        list.files(file.path("inst", "extdata")))
}

runOne <- function(name) {
  suppressMessages(pkgload::load_all(".", quiet = TRUE, export_all = FALSE))
  ## Pedixplorer measures text on the open graphics device, opening R's
  ## default one (a file, Rplots.pdf) when none is open: open one that
  ## writes nothing, the same 7 by 7 inches.
  grDevices::pdf(NULL)
  for (pkg in c("kinship2", "Pedixplorer")) {
    say(name, paste(pkg, "version"), as.character(utils::packageVersion(pkg)))
  }
  tryCatch(cases[[name]](), error = function(e) {
    say(name, "case stopped", conditionMessage(e))
  })
}

runAll <- function() {
  timeout <- Sys.which(c("timeout", "gtimeout"))
  timeout <- timeout[nzchar(timeout)]
  if (length(timeout) == 0L) cat("No timeout program: no time limits.\n")
  rscript <- file.path(R.home("bin"), "Rscript")
  status <- integer(0L)
  for (name in names(cases)) {
    start <- proc.time()[["elapsed"]]
    out <- if (length(timeout) > 0L) {
      suppressWarnings(system2(timeout[[1L]], c(caseLimits[[name]], rscript,
                                                scriptPath(), name),
                               stdout = TRUE, stderr = TRUE))
    } else {
      suppressWarnings(system2(rscript, c(scriptPath(), name),
                               stdout = TRUE, stderr = TRUE))
    }
    code <- attr(out, "status")
    status[[name]] <- if (is.null(code)) 0L else code
    cat(grep(" | ", out, value = TRUE, fixed = TRUE), sep = "\n")
    cat(sprintf("== %s: exit %d in %.0f s (limit %d s)\n", name,
                status[[name]], proc.time()[["elapsed"]] - start,
                caseLimits[[name]]))
  }
  cat("\nExit codes (124 = time limit reached):\n")
  print(status)
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0L) {
  runAll()
} else if (args[[1L]] %in% names(cases)) {
  runOne(args[[1L]])
} else {
  stop("Unknown case: ", args[[1L]], ". Cases: ",
       toString(names(cases)), call. = FALSE)
}
