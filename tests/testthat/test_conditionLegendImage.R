## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S28, plan
## R81; the backlog item "The legend does not explain the sections of a
## multi-condition symbol", Mark's S26 find: "It has vertical lines in the
## symbols that are not explained in the legend. It looks like an error.").
## With two or more conditions drawPedigreeDiagram() cuts every animal's symbol
## into equal sections, one per condition, the first of two the left half
## (.conditionSectionsHandler(), R/affectedConditions.R), and draws the
## dividing lines on unaffected animals too; its legend drew each condition as
## a whole filled hexagon, so nothing said which section was which. Each
## condition's legend row is now a picture (.conditionLegendImage()): a circle
## cut into the same sections, that condition's own section filled in its
## colour. With no condition or one the legend is unchanged. Every expected
## point was computed in a scratch run before this file was written (Learning
## 18); the browser test was run on a prototype first (58 of 58 pixels right)
## and on the code before the change (20 wrong: the hexagons' colour in the
## other sections). nprcgenekeepr is to get the same change in a session of
## its own there (R81); DIVERGENCE.md records the difference until then.
library(testthat)

## The SVG text of a picture's data: URI.
.svgText <- function(uri) {
  utils::URLdecode(sub("^data:image/svg\\+xml;charset=utf-8,", "", uri))
}

## The elements of one tag (svg, circle, line, path) in an SVG text.
.svgElements <- function(svg, tag) {
  regmatches(svg, gregexpr(paste0("<", tag, "\\b[^>]*>"), svg))[[1L]]
}

## One attribute's value in an element; NA when the element has none.
.svgAttr <- function(element, name) {
  found <- regmatches(element, regexec(
    paste0("\\s", name, "=['\"]([^'\"]*)['\"]"), element
  ))[[1L]]
  if (length(found) == 0L) NA_character_ else found[[2L]]
}

## The numbers of a filled section's path, "M cx cy L x1 y1 A r r 0 large
## sweep x2 y2 Z": from the centre out to the section's first edge, then along
## the circle to its other edge.
.pathNumbers <- function(d) {
  as.numeric(regmatches(d, gregexpr("-?[0-9]+(\\.[0-9]+)?", d))[[1L]])
}

## Where each section's two edges meet the circle (radius 22 about (25, 25)),
## from .conditionSectionsHandler()'s angles: section i of k runs from
## -pi/2 - i * d to -pi/2 - (i - 1) * d, d = 2 * pi / k, clockwise on the page.
## Computed in a scratch run (S28). Each entry is c(x1, y1, x2, y2).
.sectionEnds <- list(
  `2` = list(c(25, 47, 25, 3), c(25, 3, 25, 47)),
  `3` = list(c(5.95, 36, 25, 3), c(44.05, 36, 5.95, 36),
             c(25, 3, 44.05, 36)),
  `4` = list(c(3, 25, 25, 3), c(25, 47, 3, 25), c(47, 25, 25, 47),
             c(25, 3, 47, 25))
)

## Where the diagram's k dividing lines meet the circle (the same run).
.dividerEnds <- list(
  `2` = rbind(c(25, 3), c(25, 47)),
  `3` = rbind(c(25, 3), c(5.95, 36), c(44.05, 36)),
  `4` = rbind(c(25, 3), c(3, 25), c(25, 47), c(47, 25))
)

## S (a male) and D (a female) are the parents of the daughters X1 to Xk; Xi
## has condition i alone, so the diagram fills one section of each daughter's
## circle. k = 0 gives no condition column.
.sectionPed <- function(k) {
  ## sprintf(), not paste0(): paste0("X", integer(0)) is "X", not empty.
  daughters <- sprintf("X%d", seq_len(k))
  ped <- data.frame(
    id = c("S", "D", daughters),
    sire = c(NA, NA, rep("S", k)),
    dam = c(NA, NA, rep("D", k)),
    sex = c("M", "F", rep("F", k)),
    stringsAsFactors = FALSE
  )
  for (i in seq_len(k)) {
    name <- if (i == 1L) "affected" else paste0("affected", i)
    ped[[name]] <- ped$id == daughters[[i]]
  }
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

.sectionLayout <- function(k) {
  suppressMessages(makePedigreeMatingLayout(.sectionPed(k)))
}

.sexLegendLabels <- c("Female", "Male", "Hermaphrodite", "Unknown",
                      "Other / Unrecorded") # nolint: nonportable_path_linter
.sexLegendShapes <- c("dot", "square", "star", "triangle", "diamond")

test_that(
  ".conditionLegendImage() returns one SVG picture, 50 by 50 pixels, as a
   data: URI (the form of the Deceased row's picture)", {
  uri <- .conditionLegendImage(1L, 2L, "#CC79A7")
  expect_type(uri, "character")
  expect_length(uri, 1L)
  expect_match(uri, "^data:image/svg\\+xml;charset=utf-8,")
  svg <- .svgText(uri)
  expect_match(svg, "^<svg ")
  expect_match(svg, "</svg>$")
  root <- .svgElements(svg, "svg")
  expect_length(root, 1L)
  expect_identical(.svgAttr(root, "width"), "50")
  expect_identical(.svgAttr(root, "height"), "50")
})

test_that(
  ".conditionLegendImage() draws the Deceased picture's circle, radius 22
   about the picture's centre, white inside and outlined in the diagram's
   blue", {
  svg <- .svgText(.conditionLegendImage(2L, 3L, "#E69F00"))
  circles <- .svgElements(svg, "circle")
  expect_gte(length(circles), 1L)
  attrOf <- function(name) {
    unname(vapply(circles, .svgAttr, character(1L), name))
  }
  expect_true(all(as.numeric(attrOf("r")) == 22))
  expect_true(all(as.numeric(attrOf("cx")) == 25))
  expect_true(all(as.numeric(attrOf("cy")) == 25))
  expect_true(any(toupper(attrOf("fill")) %in% c("WHITE", "#FFFFFF")))
  expect_true(any(attrOf("stroke") %in% "#2B7CE9"))
})

test_that(
  ".conditionLegendImage() fills one section, in the colour given, where the
   diagram's section painter fills that condition: the first of two the left
   half, the first of four the top-left quarter", {
  for (k in 2:4) {
    for (i in seq_len(k)) {
      info <- sprintf("section %d of %d", i, k)
      svg <- .svgText(.conditionLegendImage(i, k, "#123456"))
      paths <- .svgElements(svg, "path")
      expect_length(paths, 1L)
      expect_identical(.svgAttr(paths[[1L]], "fill"), "#123456", info = info)
      d <- .svgAttr(paths[[1L]], "d")
      expect_match(d, "^M[^A-Za-z]+L[^A-Za-z]+A[^A-Za-z]+Z$", info = info)
      n <- .pathNumbers(d)
      expect_length(n, 11L)
      ## From the centre, along the circle of radius 22, the short way (large
      ## arc 0) and clockwise on the page (sweep 1).
      expect_identical(n[c(1L, 2L, 5L, 6L, 7L, 8L, 9L)],
                       c(25, 25, 22, 22, 0, 0, 1), info = info)
      expect_lt(max(abs(n[c(3L, 4L, 10L, 11L)] -
                          .sectionEnds[[as.character(k)]][[i]])), 0.06,
                label = info)
    }
  }
})

test_that(
  ".conditionLegendImage() draws a line from the centre to the circle at each
   section's edge, in the diagram's blue, as the diagram does on every
   symbol", {
  for (k in 2:4) {
    svg <- .svgText(.conditionLegendImage(1L, k, "#CC79A7"))
    lines <- .svgElements(svg, "line")
    expect_length(lines, k)
    attrOf <- function(name) {
      as.numeric(unname(vapply(lines, .svgAttr, character(1L), name)))
    }
    expect_identical(attrOf("x1"), rep(25, k))
    expect_identical(attrOf("y1"), rep(25, k))
    ends <- cbind(attrOf("x2"), attrOf("y2"))
    want <- .dividerEnds[[as.character(k)]]
    ends <- ends[order(round(ends[, 1L]), round(ends[, 2L])), , drop = FALSE]
    want <- want[order(round(want[, 1L]), round(want[, 2L])), , drop = FALSE]
    expect_lt(max(abs(ends - want)), 0.06, label = paste(k, "sections"))
    expect_true(all(unname(vapply(lines, .svgAttr, character(1L),
                                  "stroke")) == "#2B7CE9"))
  }
})

test_that(
  "drawPedigreeDiagram() draws each condition's legend row as its section
   picture, with no fill of its own, for 2, 3 and 4 conditions; the other
   rows are unchanged", {
  skip_if_not_installed("visNetwork")

  edgesWithout <- drawPedigreeDiagram(.sectionLayout(0L))$x$legend$edges
  for (k in 2:4) {
    info <- paste(k, "conditions")
    layout <- .sectionLayout(k)
    expect_identical(nrow(layout$conditions), k)
    legend <- drawPedigreeDiagram(layout)$x$legend
    nodes <- legend$nodes
    expect_identical(nodes$label,
                     c(.sexLegendLabels, layout$conditions$label, "Deceased"),
                     info = info)
    expect_identical(nodes$shape, c(.sexLegendShapes, rep("image", k + 1L)),
                     info = info)
    expect_identical(nodes[["color.background"]],
                     c(rep(.affectedColor(FALSE), 5L),
                       rep(NA_character_, k + 1L)), info = info)
    pictures <- vapply(seq_len(k), function(i) {
      .conditionLegendImage(i, k, layout$conditions$color[[i]])
    }, character(1L))
    expect_identical(nodes$image,
                     c(rep(NA_character_, 5L), pictures,
                       .deceasedLegendImage()), info = info)
    expect_true(all(nodes$size == 14L), info = info)
    ## Each picture is filled in its own condition's colour.
    fills <- vapply(nodes$image[5L + seq_len(k)], function(uri) {
      .svgAttr(.svgElements(.svgText(uri), "path")[[1L]], "fill")
    }, character(1L), USE.NAMES = FALSE)
    expect_identical(fills, .conditionColors[seq_len(k)], info = info)
    expect_identical(legend$edges, edgesWithout, info = info)
  }
})

test_that(
  "drawPedigreeDiagram() with five condition columns draws the first four,
   each legend row a picture of four sections", {
  skip_if_not_installed("visNetwork")

  layout <- .sectionLayout(5L)
  expect_identical(nrow(layout$conditions), 4L)
  nodes <- drawPedigreeDiagram(layout)$x$legend$nodes
  expect_identical(nodes$shape[6:9], rep("image", 4L))
  expect_identical(nodes$image[6:9], vapply(1:4, function(i) {
    .conditionLegendImage(i, 4L, .conditionColors[[i]])
  }, character(1L)))
})

test_that(
  "drawPedigreeDiagram() with one condition keeps its single hexagon row,
   filled in the condition's colour: an animal's symbol has no sections to
   explain", {
  skip_if_not_installed("visNetwork")

  layout <- .sectionLayout(1L)
  expect_false("affectedSections" %in% names(layout$nodes))
  nodes <- drawPedigreeDiagram(layout)$x$legend$nodes
  expect_identical(nodes$label[[6L]], "Affected")
  expect_identical(nodes$shape[[6L]], "hexagon")
  expect_identical(nodes[["color.background"]][[6L]], .conditionColors[[1L]])
  expect_identical(nodes$image[[6L]], NA_character_)
})

## Waits until vis.js has loaded every picture of the legend (an image node's
## shape keeps its picture in imageObj, whose width is 0 until it loads), then
## redraws both networks. TRUE when loaded within `seconds`.
.waitForLegendPictures <- function(session, seconds = 10) {
  js <- paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = el && HTMLWidgets.find('#' + el.id); ",
    "if (!w || !w.legend || !w.network) { return false; } ",
    "const L = w.legend; const ready = L.body.nodeIndices.every(id => { ",
    "const n = L.body.nodes[id]; return n.options.shape !== 'image' || ",
    "(!!n.shape.imageObj && n.shape.imageObj.width > 0); }); ",
    "if (ready) { L.redraw(); w.network.redraw(); } return ready; })()"
  )
  deadline <- Sys.time() + seconds
  repeat {
    if (isTRUE(session$Runtime$evaluate(js)$result$value)) {
      return(TRUE)
    }
    if (Sys.time() > deadline) {
      return(FALSE)
    }
    Sys.sleep(0.2)
  }
}

## The colour, as "r,g,b", at the centre of each section j of condition i's
## legend picture and of daughter Xi's symbol in the diagram: halfway out
## along the middle of the section. The legend draws a picture 2 * size wide,
## so its circle's radius is size * 2 * 22 / 50; the diagram's circle has the
## node's size as its radius. Returns one "i;j;legend;diagram" line each.
.sectionPixelsJs <- function(k, labels) {
  paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = HTMLWidgets.find('#' + el.id); const L = w.legend; ",
    "const net = w.network; const k = ", k, "; const labels = [",
    paste0("'", labels, "'", collapse = ", "), "]; ",
    "const read = (nw, x, y) => { const cv = nw.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; ",
    "const p = nw.canvasToDOM({x: x, y: y}); ",
    "const d = cv.getContext('2d').getImageData(Math.round(p.x * r), ",
    "Math.round(p.y * r), 1, 1).data; return [d[0], d[1], d[2]].join(','); }; ",
    "const out = []; for (let i = 1; i <= k; i++) { ",
    "const lid = L.body.nodeIndices.find(id => ",
    "L.body.nodes[id].options.label === labels[i - 1]); ",
    "const ln = L.body.nodes[lid]; ",
    "const lr = ln.options.size * 2 * 22 / 50; ",
    "const p = net.getPosition('X' + i); ",
    "const dr = net.body.nodes['X' + i].options.size; ",
    "for (let j = 1; j <= k; j++) { ",
    "const a = -Math.PI / 2 - (j - 0.5) * 2 * Math.PI / k; ",
    "out.push([i, j, read(L, ln.x + 0.5 * lr * Math.cos(a), ",
    "ln.y + 0.5 * lr * Math.sin(a)), read(net, p.x + 0.5 * dr * Math.cos(a), ",
    "p.y + 0.5 * dr * Math.sin(a))].join(';')); } } ",
    "return out.join('|'); })()"
  )
}

test_that(
  "in a browser, each condition's legend picture is filled in the section
   where the diagram fills that condition, and white in the others, for 2, 3
   and 4 conditions", {
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
  session <- chromote::ChromoteSession$new()
  withr::defer(session$close())

  checked <- 0L
  for (k in 2:4) {
    layout <- .sectionLayout(k)
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(drawPedigreeDiagram(layout), html,
                            selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.waitForLegendPictures(session),
                label = paste(k, "conditions: the legend's pictures loaded"))
    cells <- strsplit(strsplit(session$Runtime$evaluate(
      .sectionPixelsJs(k, layout$conditions$label)
    )$result$value, "|", fixed = TRUE)[[1L]], ";", fixed = TRUE)
    expect_length(cells, k * k)
    for (cell in cells) {
      i <- as.integer(cell[[1L]])
      j <- as.integer(cell[[2L]])
      want <- if (i == j) {
        as.integer(grDevices::col2rgb(layout$conditions$color[[i]]))
      } else {
        c(255L, 255L, 255L)
      }
      for (side in 3:4) {
        got <- as.integer(strsplit(cell[[side]], ",", fixed = TRUE)[[1L]])
        expect_lte(max(abs(got - want)), 10L, label = sprintf(
          "%d conditions, condition %d, section %d, %s: %s (want %s)", k, i,
          j, c("legend", "diagram")[[side - 2L]], cell[[side]],
          paste(want, collapse = ",")
        ))
        checked <- checked + 1L
      }
    }
  }
  expect_identical(checked, 58L)
})
