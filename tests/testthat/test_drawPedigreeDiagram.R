## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_drawPedigreeDiagram.R at
## nprcgenekeepr commit 392dd347e (unchanged to 45e0d8bfe), its lines 1-283:
## 12 of its 16 tests, unchanged. S11 copied them at baef1e12c; S12 ported
## 392dd347e's legend-colour checks and .legendFill() (plan R37). Left out
## (plan R35): its lines 285-365, the 4 tests of nprcgenekeepr's Shiny
## module, which pedkindraw does not have (three compare modPedigreeServer's
## Diagram widget with drawPedigreeDiagram()'s, one reads R/modPedigree.R).
## The comments below name nprcgenekeepr's app, documents and sessions; the
## "parity blocks" their last paragraph names are the tests left out.
##
## The S1029 BACKLOG item "Scripted Diagram rendering lacks the deceased slash
## and the condition sections" (owner ruling S1030, "One function draws it
## all"). The Diagram tab's picture was built inside modPedigreeServer, so a
## script that piped makePedigreeMatingLayout() into visNetwork::visNetwork(),
## as the a2interactive walkthrough does, drew a 5-row legend and neither the
## deceased slash (S1028) nor the condition sections (S1029), while the app
## drew 11 legend rows and both; the docs said the two match exactly.
## drawPedigreeDiagram(layout, edgeStyle, onClick) returns the finished widget
## and the app calls it, so the two cannot drift apart:
##
##  - the legend: the 5 sex rows, one row per condition drawn (the single
##    "Affected" row when there is none), "Deceased", and the 4 line rows;
##  - the afterDrawing handler that paints the sections, then the slash;
##  - the canvas height (.diagramHeight());
##  - the Export button, the "Select by id" box (real animals only) and the
##    hover highlight (reach 6 under "rectilinear", 1 under "direct");
##  - `onClick`, the app's click wiring, which a script leaves out.
##
## Like the module tests, the parity blocks compare the serialized widget text
## and do not parse it with jsonlite (not a dependency of this package).
##
## S1159 (BACKLOG item found S1158 by Mark): the legend drew the five sex
## symbols filled light blue, vis.js's default, while the diagram draws an
## unaffected animal open (white); and it drew each condition row with a
## darker outline of its own color, while the diagram's affected animals keep
## the blue outline. vis.js turns a single color into a fill plus an outline
## 20% darker, so the legend sets only the fill (`color.background`) and leaves
## the outline at vis.js's default, as the diagram's animals do. The colors
## vis.js draws are read in the browser by test-e2e-pedigree-module.R.
.legendFill <- function(conditionColors) {
  c(rep(.affectedColor(FALSE), 5L), conditionColors, NA_character_)
}

## Four animals: A (a male) and B (a female) are the parents of C (a female)
## and D (a male). A is DECEASED, B and C are ALIVE, D is SHIPPED.
## `nConditions` adds that many condition columns (affected, affected2, ...);
## `status = FALSE` leaves the status column out.
.drawPed <- function(nConditions = 0L, status = TRUE) {
  ped <- data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "F", "M"),
    gen = c(0L, 0L, 1L, 1L),
    stringsAsFactors = FALSE
  )
  if (status) ped$status <- c("DECEASED", "ALIVE", "ALIVE", "SHIPPED")
  for (i in seq_len(nConditions)) {
    name <- if (i == 1L) "affected" else paste0("affected", i)
    ped[[name]] <- c(TRUE, FALSE, i %% 2L == 0L, NA)
  }
  ped
}

.drawLayout <- function(nConditions = 0L, edgeStyle = "rectilinear") {
  suppressMessages(
    makePedigreeMatingLayout(.drawPed(nConditions), edgeStyle = edgeStyle)
  )
}

.sexLabels <- c("Female", "Male", "Hermaphrodite", "Unknown",
                "Other / Unrecorded") # nolint: nonportable_path_linter
.sexShapes <- c("dot", "square", "star", "triangle", "diamond")

test_that(
  "drawPedigreeDiagram() returns a visNetwork widget of the layout's own nodes
   and edges, at their fixed positions (physics off, straight edges)", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  widget <- drawPedigreeDiagram(layout)
  expect_s3_class(widget, "visNetwork")
  expect_s3_class(widget, "htmlwidget")
  expect_identical(widget$x$nodes$id, layout$nodes$id)
  expect_identical(widget$x$nodes$x, layout$nodes$x)
  expect_identical(nrow(widget$x$edges), nrow(layout$edges))
  expect_false(widget$x$options$physics$enabled)
  expect_false(widget$x$options$nodes$physics)
  expect_false(widget$x$options$edges$smooth)
})

test_that(
  "drawPedigreeDiagram()'s legend has the app's 11 rows for a pedigree with no
   condition column: 5 sex rows, 'Affected', 'Deceased' and 4 line rows", {
  skip_if_not_installed("visNetwork")

  legend <- drawPedigreeDiagram(.drawLayout())$x$legend
  expect_identical(legend$nodes$label, c(.sexLabels, "Affected", "Deceased"))
  expect_identical(legend$nodes$shape, c(.sexShapes, "hexagon", "image"))
  ## The fill alone (S1159): the sex rows open (white) like an unaffected
  ## animal, the condition row in its color, no single color and no outline.
  ## [[ ]], not $: `$color` would partially match `color.background`.
  expect_identical(legend$nodes[["color.background"]],
                   .legendFill(.conditionColors[[1L]]))
  expect_null(legend$nodes[["color"]])
  expect_null(legend$nodes[["color.border"]])
  expect_identical(legend$nodes$image,
                   c(rep(NA_character_, 6L), .deceasedLegendImage()))
  expect_true(all(legend$nodes$size == 14L))
  expect_identical(legend$edges$label,
                   c("Same animal, again", "MZ", "DZ", "?"))
  expect_identical(legend$edges$color,
                   c(NA_character_, rep("#009E73", 3L)))
  expect_equal(unclass(legend$edges$dashes),
               list(TRUE, FALSE, c(4L, 4L), c(14L, 8L)))
  expect_identical(legend$main$text, "Sex")
  expect_identical(legend$position, "right")
  expect_false(legend$useGroups)
  expect_equal(legend$width, 0.28)
  expect_equal(legend$stepY, 60)
})

test_that(
  "drawPedigreeDiagram()'s legend has one row per condition drawn, in file
   order and in its condition's color, in place of the single 'Affected' row", {
  skip_if_not_installed("visNetwork")

  legend <- drawPedigreeDiagram(.drawLayout(2L))$x$legend
  expect_identical(legend$nodes$label,
                   c(.sexLabels, "Affected", "Affected 2", "Deceased"))
  expect_identical(legend$nodes$shape,
                   c(.sexShapes, "hexagon", "hexagon", "image"))
  expect_identical(legend$nodes[["color.background"]],
                   .legendFill(.conditionColors[1:2]))
  expect_null(legend$nodes[["color"]])

  ## Five condition columns: the first four are drawn, so four rows.
  legend <- drawPedigreeDiagram(.drawLayout(5L))$x$legend
  expect_identical(legend$nodes$label,
                   c(.sexLabels, "Affected", "Affected 2", "Affected 3",
                     "Affected 4", "Deceased"))
  expect_identical(legend$nodes[["color.background"]],
                   .legendFill(.conditionColors))
  expect_null(legend$nodes[["color"]])
})

test_that(
  "drawPedigreeDiagram() carries the slash handler alone for zero or one
   condition, and the sections-then-slash handler for two or more", {
  skip_if_not_installed("visNetwork")

  handlerOf <- function(nConditions) {
    as.character(
      drawPedigreeDiagram(.drawLayout(nConditions))$x$events$afterDrawing
    )
  }
  expect_identical(handlerOf(0L), .diagramAfterDrawing(FALSE))
  expect_identical(handlerOf(1L), .diagramAfterDrawing(FALSE))
  expect_identical(handlerOf(2L), .diagramAfterDrawing(TRUE))
  expect_identical(handlerOf(4L), .diagramAfterDrawing(TRUE))
})

test_that(
  "drawPedigreeDiagram() sizes the canvas as the app does: 500 px, 45 px more
   for each condition row past the first, at most four conditions", {
  skip_if_not_installed("visNetwork")

  heightOf <- function(nConditions) {
    drawPedigreeDiagram(.drawLayout(nConditions))$height
  }
  expect_identical(heightOf(0L), "500px")
  expect_identical(heightOf(1L), "500px")
  expect_identical(heightOf(2L), "545px")
  expect_identical(heightOf(4L), "635px")
  expect_identical(heightOf(5L), "635px")
})

test_that(
  "drawPedigreeDiagram() gives the Export Diagram (PNG) button and a
   'Select by id' box that lists the real animals only, never a waypoint", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  ## The rectilinear layout carries waypoint and mating nodes ("__..." ids),
  ## which the box must leave out.
  expect_true(any(startsWith(layout$nodes$id, "__")))
  widget <- drawPedigreeDiagram(layout)
  expect_identical(widget$x$export$type, "png")
  ## visExport() stores the file name with its extension.
  expect_identical(widget$x$export$name, "pedigree_diagram.png")
  expect_identical(widget$x$export$label, "Export Diagram (PNG)")
  expect_true(widget$x$idselection$enabled)
  expect_false(widget$x$idselection$useLabels)
  expect_identical(sort(widget$x$idselection$values), c("A", "B", "C", "D"))
})

test_that(
  "drawPedigreeDiagram() highlights on hover with reach 6 under the
   rectilinear style (the default) and 1 under the direct style", {
  skip_if_not_installed("visNetwork")

  rect <- drawPedigreeDiagram(.drawLayout())$x$highlight
  expect_true(rect$enabled)
  expect_true(rect$hoverNearest)
  expect_identical(rect$algorithm, "all")
  expect_equal(rect$degree, 6)

  direct <- drawPedigreeDiagram(.drawLayout(edgeStyle = "direct"),
                                edgeStyle = "direct")$x$highlight
  expect_equal(direct$degree, 1)
})

test_that(
  "drawPedigreeDiagram() wires a click handler only when onClick is given", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  expect_null(drawPedigreeDiagram(layout)$x$events$click)
  handler <- "function(nodes) { console.log(nodes.nodes); }"
  expect_identical(
    as.character(drawPedigreeDiagram(layout, onClick = handler)$x$events$click),
    handler
  )
})

test_that(
  "drawPedigreeDiagram() draws a layout with no relationship (zero nodes)
   with its full legend and an empty 'Select by id' box", {
  skip_if_not_installed("visNetwork")

  ped <- data.frame(id = c("X", "Y"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  layout <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(layout$nodes), 0L)
  widget <- drawPedigreeDiagram(layout)
  expect_s3_class(widget, "visNetwork")
  expect_length(widget$x$idselection$values, 0L)
  expect_identical(widget$x$legend$nodes$label,
                   c(.sexLabels, "Affected", "Deceased"))
})

test_that(
  "drawPedigreeDiagram() draws a layout without a conditions element as one
   with no condition column", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  layout$conditions <- NULL
  widget <- drawPedigreeDiagram(layout)
  expect_identical(widget$x$legend$nodes$label,
                   c(.sexLabels, "Affected", "Deceased"))
  expect_identical(widget$height, "500px")
  expect_identical(as.character(widget$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that(
  "drawPedigreeDiagram() stops, naming makePedigreeMatingLayout(), on a layout
   that is not a list holding nodes and edges data frames", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  expect_error(drawPedigreeDiagram("layout"), "makePedigreeMatingLayout")
  expect_error(drawPedigreeDiagram(layout$nodes), "makePedigreeMatingLayout")
  expect_error(drawPedigreeDiagram(list(nodes = layout$nodes)),
               "makePedigreeMatingLayout")
  expect_error(drawPedigreeDiagram(list(nodes = "A", edges = layout$edges)),
               "makePedigreeMatingLayout")
  ## A data frame is not a layout, even one that carries data frames named
  ## nodes and edges as columns (S1030 mutation gap: with no data frame check
  ## it was drawn).
  frame <- data.frame(id = c("A", "B"))
  frame$nodes <- data.frame(id = c("A", "B"))
  frame$edges <- data.frame(from = c("A", "B"), to = c("B", "A"))
  expect_error(drawPedigreeDiagram(frame), "makePedigreeMatingLayout")
})

test_that(
  "drawPedigreeDiagram() stops on an unknown edgeStyle and on an onClick that
   is not one string", {
  skip_if_not_installed("visNetwork")

  layout <- .drawLayout()
  expect_error(drawPedigreeDiagram(layout, edgeStyle = "curved"),
               "should be one of")
  expect_error(drawPedigreeDiagram(layout, onClick = c("a", "b")), "onClick")
  expect_error(drawPedigreeDiagram(layout, onClick = 1), "onClick")
  expect_error(drawPedigreeDiagram(layout, onClick = NA_character_),
               "onClick")
})
