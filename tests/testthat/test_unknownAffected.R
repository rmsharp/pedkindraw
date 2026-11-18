## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S43, plan
## Phase G2, gap B2 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R106-R107). An animal whose affected status is unknown (NA) was filled
## white, as an unaffected one is, so the drawing could not tell the two apart;
## only the hover text said "Unknown". kinship2 draws a "?" in such a symbol and
## Pedixplorer fills it grey. Mark's picks (S43): a light grey fill, #BEBEBE
## (R's "grey", Pedixplorer's), for the whole symbol with one condition and for
## the condition's section with two to four, and a legend row "Affected status
## unknown" (a grey hexagon) after the condition rows when a drawn animal has
## an unknown status. The extra legend row makes the drawing 45 px taller, as
## every legend row past the 11th does (.diagramHeight()). Every expected value
## was computed on a prototype of the change before this file was written
## (Learning 18), and the browser test read 190,190,190 in each unknown symbol,
## section and legend row there. nprcgenekeepr draws an unknown status white;
## DIVERGENCE.md records the difference "at the switch" (R98).
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's unknownAffected case. Each named
## argument adds a column.
.unknownPed <- function(...) {
  ped <- data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "M", "F"),
    gen = c(0L, 0L, 1L, 1L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## The fill of each of `ids`' own nodes in a layout or diagram data.
.fillOf <- function(result, ids) {
  result$nodes[["color.background"]][match(ids, result$nodes$id)]
}

.unknownGrey <- "#BEBEBE"
.unknownLabel <- "Affected status unknown"
.unknownSexLabels <- c("Female", "Male", "Hermaphrodite", "Unknown",
                       "Other / Unrecorded") # nolint: nonportable_path_linter

test_that(
  ".unknownColor is R's grey, #BEBEBE, apart from the open white and from
   the four condition colours", {
  expect_identical(.unknownColor, .unknownGrey)
  expect_identical(
    grDevices::rgb(t(grDevices::col2rgb("grey")), maxColorValue = 255),
    .unknownGrey
  )
  expect_false(.unknownColor %in% c(.affectedColor(FALSE), .conditionColors))
})

test_that(
  "makePedigreeMatingLayout fills an animal whose one condition is unknown
   grey, apart from the unaffected (white) and affected (pink) animals, for
   a bare or a named condition column, in both edge styles", {
  for (column in c("affected", "affected_diabetes")) {
    args <- list(c(TRUE, NA, FALSE, TRUE))
    names(args) <- column
    ped <- do.call(.unknownPed, args)
    for (edgeStyle in c("rectilinear", "direct")) {
      info <- paste(column, edgeStyle)
      result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
      expect_identical(.fillOf(result, ped$id),
                       c("#CC79A7", .unknownGrey, "#FFFFFF", "#CC79A7"),
                       info = info)
      expect_false("affectedSections" %in% names(result$nodes), info = info)
    }
  }
})

test_that(
  "makePedigreeMatingLayout fills every repeat appearance of an animal whose
   status is unknown grey, as its own node, and leaves the mating-union and
   routing nodes their own fills", {
  loopPed <- data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    affected = c(TRUE, FALSE, FALSE, FALSE, NA, FALSE, FALSE, FALSE),
    stringsAsFactors = FALSE
  )
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(loopPed, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.fillOf(result, c("8LKBV9", dupIds)),
                     rep(.unknownGrey, 1L + length(dupIds)), info = edgeStyle)
    expect_identical(.fillOf(result, loopPed$id),
                     c("#CC79A7", rep("#FFFFFF", 3L), .unknownGrey,
                       rep("#FFFFFF", 3L)), info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(loopPed$id, names(result$duplicateToReal))), ]
    expect_false(any(others[["color.background"]] %in% .unknownGrey),
                 info = edgeStyle)
    unions <- startsWith(others$id, "__union_")
    expect_true(any(unions), info = edgeStyle)
    expect_true(all(is.na(others[["color.background"]][unions])),
                info = edgeStyle)
  }
})

test_that(
  "makePedigreeMatingLayout marks an unknown condition '?' in an animal's
   affectedSections with two or more conditions, and leaves every animal's
   fill white", {
  ped <- .unknownPed(
    affected = c(TRUE, NA, FALSE, TRUE),
    affected2 = c(NA, NA, FALSE, TRUE)
  )
  nodes <- makePedigreeMatingLayout(ped)$nodes
  expect_identical(nodes$affectedSections[match(ped$id, nodes$id)],
                   c("1?", "??", "00", "11"))
  expect_identical(.fillOf(list(nodes = nodes), ped$id), rep("#FFFFFF", 4L))

  ## Three conditions, the named one first in the file.
  ped <- data.frame(
    id = c("P1", "P2", "C1", "C2", "C3"),
    sire = c(NA, NA, "P1", "P1", "P1"),
    dam = c(NA, NA, "P2", "P2", "P2"),
    sex = c("M", "F", "F", "M", "F"),
    gen = c(0L, 0L, 1L, 1L, 1L),
    affecteddiabetes = c(TRUE, FALSE, NA, TRUE, FALSE),
    affected = c(FALSE, FALSE, TRUE, TRUE, NA),
    affected2 = c(TRUE, TRUE, FALSE, NA, FALSE),
    stringsAsFactors = FALSE
  )
  nodes <- makePedigreeMatingLayout(ped)$nodes
  expect_identical(nodes$affectedSections[match(ped$id, nodes$id)],
                   c("101", "001", "?10", "11?", "0?0"))
  expect_identical(.fillOf(list(nodes = nodes), ped$id), rep("#FFFFFF", 5L))
})

test_that(
  "makePedigreeDiagramData fills an animal whose affected status is unknown
   grey when the column is there, and every animal white without it", {
  ped <- .unknownPed(affected = c(TRUE, NA, FALSE, TRUE))
  expect_identical(.fillOf(makePedigreeDiagramData(ped), ped$id),
                   c("#CC79A7", .unknownGrey, "#FFFFFF", "#CC79A7"))
  ped$affected <- NULL
  expect_identical(.fillOf(makePedigreeDiagramData(ped), ped$id),
                   rep("#FFFFFF", 4L))
})

test_that(
  "drawPedigreeDiagram's legend has a grey 'Affected status unknown' hexagon
   after the one condition's row when an animal's status is unknown, and no
   such row when none is", {
  skip_if_not_installed("visNetwork")

  layout <- makePedigreeMatingLayout(
    .unknownPed(affected = c(TRUE, NA, FALSE, TRUE))
  )
  nodes <- drawPedigreeDiagram(layout)$x$legend$nodes
  expect_identical(nodes$label, c(.unknownSexLabels, "Affected",
                                  .unknownLabel, "Deceased"))
  expect_identical(nodes$shape[6:8], c("hexagon", "hexagon", "image"))
  expect_identical(nodes[["color.background"]][6:8],
                   c("#CC79A7", .unknownGrey, NA_character_))
  expect_identical(nodes$image[[7L]], NA_character_)
  expect_true(all(nodes$size == 14L))

  layout <- makePedigreeMatingLayout(
    .unknownPed(affected = c(TRUE, FALSE, FALSE, TRUE))
  )
  expect_identical(drawPedigreeDiagram(layout)$x$legend$nodes$label,
                   c(.unknownSexLabels, "Affected", "Deceased"))
  expect_identical(
    drawPedigreeDiagram(makePedigreeMatingLayout(.unknownPed()))$x$legend$
      nodes$label,
    c(.unknownSexLabels, "Affected", "Deceased")
  )
})

test_that(
  "drawPedigreeDiagram's legend puts the grey 'Affected status unknown'
   hexagon after the section pictures with two and with four conditions", {
  skip_if_not_installed("visNetwork")

  for (k in c(2L, 4L)) {
    columns <- c("affected", paste0("affected", 2:4))[seq_len(k)]
    args <- rep(list(c(TRUE, FALSE, FALSE, TRUE)), k)
    names(args) <- columns
    args[[k]] <- c(TRUE, FALSE, NA, TRUE)
    layout <- makePedigreeMatingLayout(do.call(.unknownPed, args))
    nodes <- drawPedigreeDiagram(layout)$x$legend$nodes
    info <- paste(k, "conditions")
    expect_identical(nodes$label, c(.unknownSexLabels,
                                    layout$conditions$label, .unknownLabel,
                                    "Deceased"), info = info)
    expect_identical(nodes$shape[5L + seq_len(k + 2L)],
                     c(rep("image", k), "hexagon", "image"), info = info)
    expect_identical(nodes[["color.background"]][[6L + k]], .unknownGrey,
                     info = info)
  }
})

test_that(
  "drawPedigreeDiagram adds no unknown row when the only unknown status is in
   a fifth condition, which is not drawn, or on an animal the layout leaves
   out", {
  skip_if_not_installed("visNetwork")

  known <- c(TRUE, FALSE, TRUE, FALSE)
  ped <- .unknownPed(affected = known, affected2 = known, affected3 = known,
                     affected4 = known, affected5 = NA)
  layout <- makePedigreeMatingLayout(ped)
  expect_identical(layout$conditionsNotDrawn, "affected5")
  expect_false(.unknownLabel %in% drawPedigreeDiagram(layout)$x$legend$
                 nodes$label)

  ## E has no parent, mate or offspring, so the layout leaves it out.
  ped <- rbind(.unknownPed(affected = known),
               data.frame(id = "E", sire = NA, dam = NA, sex = "F", gen = 0L,
                          affected = NA, stringsAsFactors = FALSE))
  layout <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(layout$isolatedIds, "E")
  expect_false(.unknownLabel %in% drawPedigreeDiagram(layout)$x$legend$
                 nodes$label)
})

test_that(
  "drawPedigreeDiagram's canvas grows 45 px for the unknown row, as for every
   legend row past the 11th: 545, 590 and 680 px with one, two and four
   conditions, and 500 and 635 px without an unknown status", {
  skip_if_not_installed("visNetwork")

  heightOf <- function(k, unknown) {
    columns <- c("affected", paste0("affected", 2:4))[seq_len(k)]
    args <- rep(list(c(TRUE, FALSE, FALSE, TRUE)), k)
    names(args) <- columns
    if (unknown) args[[1L]] <- c(TRUE, NA, FALSE, TRUE)
    drawPedigreeDiagram(
      makePedigreeMatingLayout(do.call(.unknownPed, args))
    )$height
  }
  expect_identical(heightOf(1L, TRUE), "545px")
  expect_identical(heightOf(2L, TRUE), "590px")
  expect_identical(heightOf(4L, TRUE), "680px")
  expect_identical(heightOf(1L, FALSE), "500px")
  expect_identical(heightOf(4L, FALSE), "635px")
})

## Waits until vis.js has loaded every picture of the legend, then redraws both
## networks (as test_conditionLegendImage.R's helper). TRUE when loaded within
## `seconds`.
.unknownWaitForLegend <- function(session, seconds = 10) {
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

## The colour, as "r,g,b", vis.js drew at the middle of each section j of k of
## each animal in `ids` (halfway out from the centre; with one condition, the
## centre), and at the centre of the legend row labelled `label`. Returns one
## "id;j;r,g,b" line per section and one "legend;0;r,g,b" line ("legend;0;none"
## when the legend has no such row).
.unknownPixelsJs <- function(ids, k, label) {
  paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = HTMLWidgets.find('#' + el.id); const net = w.network; ",
    "const L = w.legend; const k = ", k, "; ",
    "const read = (nw, x, y) => { const cv = nw.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; ",
    "const p = nw.canvasToDOM({x: x, y: y}); ",
    "const d = cv.getContext('2d').getImageData(Math.round(p.x * r), ",
    "Math.round(p.y * r), 1, 1).data; return [d[0], d[1], d[2]].join(','); }; ",
    "const out = []; [", paste0("'", ids, "'", collapse = ", "), "].forEach(",
    "id => { const p = net.getPosition(id); ",
    "const s = net.body.nodes[id].options.size; ",
    "for (let j = 1; j <= k; j++) { ",
    "const a = -Math.PI / 2 - (j - 0.5) * 2 * Math.PI / k; ",
    "const f = k === 1 ? 0 : 0.5 * s; ",
    "out.push([id, j, read(net, p.x + f * Math.cos(a), ",
    "p.y + f * Math.sin(a))].join(';')); } }); ",
    "const lid = L.body.nodeIndices.find(id => ",
    "L.body.nodes[id].options.label === '", label, "'); ",
    "const ln = lid === undefined ? null : L.body.nodes[lid]; ",
    "out.push(['legend', 0, ln ? read(L, ln.x, ln.y) : 'none'].join(';')); ",
    "return out.join('|'); })()"
  )
}

test_that(
  "in a browser, vis.js draws an unknown animal, an unknown section and the
   legend's unknown row grey, an affected one in its condition's colour and
   an unaffected one white, with one, three and four conditions", {
  skip_on_cran()
  skip_if_not_installed("visNetwork")
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_no_chrome()

  ## As getLiveRenderedPositions() (helper-live-render-positions.R): a 60 s
  ## timeout on chromote's shared parent before the first session, and one
  ## graceful close of it after the suite.
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

  ## Each case: its columns, and each animal's sections as the layout writes
  ## them ("1" affected, "0" unaffected, "?" unknown).
  cases <- list(
    list(columns = list(affected = c(TRUE, NA, FALSE, TRUE)),
         sections = c("1", "?", "0", "1")),
    list(columns = list(affected_x = c(TRUE, NA, FALSE, TRUE),
                        affected_y = c(NA, NA, FALSE, TRUE),
                        affected_z = c(FALSE, NA, FALSE, NA)),
         sections = c("1?0", "???", "000", "11?")),
    list(columns = list(affected_w = c(TRUE, NA, FALSE, TRUE),
                        affected_x = c(NA, NA, FALSE, TRUE),
                        affected_y = c(FALSE, NA, FALSE, NA),
                        affected_z = c(NA, TRUE, NA, FALSE)),
         sections = c("1?0?", "???1", "000?", "11?0"))
  )
  grey <- as.integer(grDevices::col2rgb(.unknownGrey))
  checked <- 0L
  for (case in cases) {
    ped <- do.call(.unknownPed, case$columns)
    k <- length(case$columns)
    layout <- makePedigreeMatingLayout(ped)
    html <- withr::local_tempfile(fileext = ".html")
    htmlwidgets::saveWidget(drawPedigreeDiagram(layout), html,
                            selfcontained = TRUE)
    session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
    expect_true(.unknownWaitForLegend(session),
                label = paste(k, "conditions: the legend's pictures loaded"))
    cells <- strsplit(strsplit(session$Runtime$evaluate(
      .unknownPixelsJs(ped$id, k, .unknownLabel)
    )$result$value, "|", fixed = TRUE)[[1L]], ";", fixed = TRUE)
    expect_length(cells, 4L * k + 1L)
    for (cell in cells) {
      if (identical(cell[[3L]], "none")) {
        fail(sprintf("%d conditions: the legend has no '%s' row", k,
                     .unknownLabel))
        next
      }
      j <- as.integer(cell[[2L]])
      want <- if (cell[[1L]] == "legend") {
        grey
      } else {
        mark <- substr(case$sections[[match(cell[[1L]], ped$id)]], j, j)
        switch(mark,
               "1" = as.integer(grDevices::col2rgb(.conditionColors[[j]])),
               "?" = grey,
               "0" = c(255L, 255L, 255L))
      }
      got <- as.integer(strsplit(cell[[3L]], ",", fixed = TRUE)[[1L]])
      expect_lte(max(abs(got - want)), 10L, label = sprintf(
        "%d conditions, %s, section %d: %s (want %s)", k, cell[[1L]], j,
        cell[[3L]], paste(want, collapse = ",")
      ))
      checked <- checked + 1L
    }
  }
  expect_identical(checked, 35L)
})
