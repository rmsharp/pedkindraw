## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/drawPedigreeDiagram.R at nprcgenekeepr commit
## 4283e3502 (S11 copied it at 471589138 for its .checkOnClick(), plan R34;
## S12 ported S1159's legend fill and its tidy-up, plan R37).
## Changes: pedkindraw S28's section pictures in the legend (plan R81: the
## block after conditionRows, and the help's paragraph on them), S38's
## "Select by id" filter, which also leaves out __jog_ ids and reads the
## prefixes from .reservedIdPattern (plan R94), and S39's legend lines drawn
## without arrowheads, their labels on white (plan R95: the two columns after
## legendEdges), and S43's grey "Affected status unknown" row and the 45 px it
## adds (plan Phase G2, R106-R107: unknownRow, before deceasedRow), and S45's
## section colours read from the layout's conditions table (plan Phase G4,
## R111: sectionColors, and the help's paragraph on the colours), and S54's
## "Genotyped" row and the 45 px it adds (plan Phase G13, R133-R134:
## genotypedRow, and the help's paragraph on it), and S55's "Carrier" row,
## the 45 px it adds and the dot's handler (plan Phase G13, R135: carrierRow,
## hasCarrier, and the help's paragraph on it), and S56's "Proband" and
## "Consultand" rows, the 45 px each adds, the arrows' handler and the
## points that keep the arrows inside the drawing (plan Phase G13, R136:
## probandRow, consultandRow, hasArrow, nodes, and the help's paragraph on
## them; S56's REFACTOR builds the three picture rows with .markLegendRow(),
## pedkindraw's own, R/markColumns.R), and S57's "Evaluated" row, the 45 px
## it adds, the star's handler and the points that keep the stars inside the
## drawing (plan Phase G13, R137: evaluatedRow, hasEvaluated, and the help's
## paragraph on it), and S58's "Infertile" and "No offspring" rows, the 45 px
## each adds, the bars' handler, the ids moved below the bars and the points
## that keep them inside the drawing (plan Phase G13, R138: infertileRow,
## noOffspringRow, hasInfertile, hasNoOffspring, and the help's paragraph on
## them), and S59's "Miscarriage", "Termination" and "Ectopic" rows, the 45
## px each adds, a miscarriage's small triangle and moved id, the points
## that keep the drawing's fit as for a full-size symbol, and the lines'
## handler (plan Phase G13, R139: sabRow, topRow, ectRow, hasMiscarriage, and
## the help's paragraph on them), and S60's points that keep a full-size
## symbol's room for smaller symbols (plan Phase G14, R140: nodes, and the
## help's paragraph on the symbols' size), and S61's points that keep
## larger text's room (plan Phase G14, R140: nodes, and the help's
## paragraph on the text's size), each a DIVERGENCE.md row until
## nprcgenekeepr has it;
## otherwise help text only.
## The help describes the
## function alone (plan R36): the title, the opening sentences, the
## paragraph on clicking and the onClick argument named nprcgenekeepr's
## Shiny application and its Pedigree Browser (the source's lines 7, 9-13,
## 25-26 and 34-35), and the example types its own pedigree instead of
## loading nprcgenekeepr (lines 40-41; plan R21). The comments name
## nprcgenekeepr's app, documents and sessions.

# The Pedigree Browser's Diagram, drawn by one function a script can call
# (S1030)

#' Draw an interactive pedigree diagram from a mating layout
#'
#' Returns an interactive pedigree diagram, as a \code{visNetwork} widget,
#' for a layout made by \code{\link{makePedigreeMatingLayout}}. The diagram
#' has the sex symbols at the layout's fixed positions, the legend (the
#' five sex symbols, one row per affected condition or a single
#' \dQuote{Affected} row, a grey \dQuote{Affected status unknown} row when an
#' animal's status is unknown, a \dQuote{Genotyped} row when an animal is
#' genotyped, a \dQuote{Carrier} row when an animal is a carrier,
#' \dQuote{Proband} and \dQuote{Consultand} rows when an animal is one,
#' an \dQuote{Evaluated} row when an animal is evaluated,
#' \dQuote{Infertile} and \dQuote{No offspring} rows when an animal is one,
#' \dQuote{Deceased}, and the dashed
#' repeat-appearance and twin lines), each multi-condition symbol split into
#' its colored sections, the slash through each deceased animal's symbol, a
#' canvas that grows with the number of legend rows, the
#' \strong{Export Diagram (PNG)}
#' button, a \dQuote{Select by id} box that lists the animals, and the
#' highlight on hover. The sections and the slash are painted by a drawing
#' script inside the widget, so they appear wherever the widget is shown: in the
#' RStudio viewer, in an R Markdown or Quarto document, or in a web page saved
#' with \code{htmlwidgets::saveWidget()}.
#'
#' With two or more conditions, every animal's symbol is cut into equal
#' sections, one per condition, counter-clockwise from the top (the first of
#' two is the left half), and each condition's legend row shows a circle cut
#' the same way with that condition's section filled in its color, so the
#' legend says which section is which.
#'
#' The colours of the conditions are set by
#' \code{\link{makePedigreeMatingLayout}}'s \code{conditionColors}: the layout
#' fills the symbols with them, and the drawing paints the sections and the
#' legend's rows from the layout's \code{conditions} table, so all three
#' agree.
#'
#' An animal whose affected status is unknown (\code{NA}) is filled grey,
#' with one condition, or has that condition's section grey, with two or more,
#' so it does not look unaffected; the legend's grey hexagon
#' \dQuote{Affected status unknown} then says what the grey is, and the
#' canvas is 45 pixels taller for that row.
#'
#' An animal whose \code{genotyped} column is \code{TRUE} (see
#' \code{\link{makePedigreeMatingLayout}}) is drawn with its outline 4 pixels
#' wide, where every other symbol's is 1; the legend's \dQuote{Genotyped} row,
#' a square with that outline, then says what the thick outline is, and the
#' canvas is 45 pixels taller for that row.
#'
#' An animal whose \code{carrier} column is \code{TRUE} (see
#' \code{\link{makePedigreeMatingLayout}}) is drawn with a black dot at the
#' centre of its symbol, on top of its fill, its sections and the slash; the
#' legend's \dQuote{Carrier} row, a circle with the dot, then says what the
#' dot is, and the canvas is 45 pixels taller for that row.
#'
#' An animal whose \code{proband} or \code{consultand} column is \code{TRUE}
#' (see \code{\link{makePedigreeMatingLayout}}) has a black arrow pointing at
#' its symbol from the lower left, a proband's with \dQuote{P} beside its
#' tail; the legend's \dQuote{Proband} and \dQuote{Consultand} rows, each
#' the arrow, then say what they are, and the canvas is 45 pixels taller for
#' each. The drawing takes in each arrow, so one at its left edge is not cut
#' off.
#'
#' An animal whose \code{evaluated} column is \code{TRUE} (see
#' \code{\link{makePedigreeMatingLayout}}) has a black `*` to the
#' right of the upper-right corner of its symbol; the legend's
#' \dQuote{Evaluated} row, the `*`, then says what it is, and the
#' canvas is 45 pixels taller for that row. The drawing takes in each
#' `*`, so one at its right edge is not cut off.
#'
#' An animal whose \code{fertility} column says it is infertile (see
#' \code{\link{makePedigreeMatingLayout}}) has a black line down from the
#' bottom of its symbol and two bars across it, and one with no offspring by
#' choice or for an unknown reason a line and one bar, as in Pedixplorer; its
#' id moves down below them. The legend's \dQuote{Infertile} and
#' \dQuote{No offspring} rows, each its mark, then say what they are, and
#' the canvas is 45 pixels taller for each. The drawing takes in each moved
#' id, so one in its bottom row is not cut off.
#'
#' An animal whose \code{miscarriage} column says it is one (see
#' \code{\link{makePedigreeMatingLayout}}) is drawn as a triangle 0.6 the
#' size of the other symbols, so smaller than the \dQuote{Unknown} sex's,
#' with no deceased slash. The triangle of a termination of pregnancy or of
#' an ectopic pregnancy has a black line across it from its lower-left to
#' its upper-right corner, and an ectopic pregnancy's has \dQuote{ECT}
#' under it, as in Pedixplorer. Its id moves down into the row of the other
#' ids. The
#' legend's \dQuote{Miscarriage}, \dQuote{Termination} and
#' \dQuote{Ectopic} rows, each its triangle, then say what they are, and
#' the canvas is 45 pixels taller for each. The drawing keeps the room a
#' full-size symbol would have, so a long id at its edge is not cut off.
#'
#' Each animal is drawn at the size \code{\link{makePedigreeMatingLayout}}'s
#' \code{symbolSize} gives it; an infertile animal's and a miscarriage's id
#' moves down in proportion, and with symbols smaller than full size the
#' drawing keeps the room a full-size symbol would have, so a long id at its
#' edge is not cut off.
#'
#' The ids and names are written at the size
#' \code{\link{makePedigreeMatingLayout}}'s \code{textSize} gives them; with
#' text larger than before, the drawing keeps room for the outermost labels,
#' so a long id at its edge is not cut off, and an infertile animal's and a
#' miscarriage's moved id keep their room below their marks.
#'
#' A click does nothing unless \code{onClick} is given: a Shiny application
#' can pass one to act on the clicked animal, which needs a live Shiny
#' session, so a script leaves \code{onClick} out.
#'
#' @param layout the list returned by \code{\link{makePedigreeMatingLayout}}.
#' @param edgeStyle the \code{edgeStyle} the layout was made with,
#'   \code{"rectilinear"} (the default) or \code{"direct"}. It sets how far
#'   the hover highlight reaches: 6 steps under \code{"rectilinear"}, whose
#'   invisible routing points count as steps, and 1 under \code{"direct"}.
#' @param onClick \code{NULL} (the default), or a JavaScript function, as a
#'   character string, that runs when the diagram is clicked. A Shiny
#'   application can pass one that sends the clicked animal to its server.
#' @return A \code{visNetwork} widget, 500 pixels tall, 45 more for each
#'   affected condition past the first (at most four are drawn), for the
#'   \dQuote{Affected status unknown} row, for the \dQuote{Genotyped} row,
#'   for the \dQuote{Carrier} row, for each of the \dQuote{Proband} and
#'   \dQuote{Consultand} rows, for the \dQuote{Evaluated} row, for
#'   each of the \dQuote{Infertile} and \dQuote{No offspring} rows, and
#'   for each of the \dQuote{Miscarriage}, \dQuote{Termination} and
#'   \dQuote{Ectopic} rows.
#' @seealso \code{\link{makePedigreeMatingLayout}}
#' @examples
#' ## Four animals: A and B are the parents of C and D; A has died, and C
#' ## is affected
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D"),
#'   sire = c(NA, NA, "A", "A"),
#'   dam = c(NA, NA, "B", "B"),
#'   sex = c("M", "F", "F", "M"),
#'   status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
#'   affected = c(FALSE, FALSE, TRUE, FALSE),
#'   stringsAsFactors = FALSE
#' )
#' ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
#' layout <- makePedigreeMatingLayout(ped)
#' diagram <- drawPedigreeDiagram(layout)
#' ## Print `diagram` in an interactive session to see it, or save it as a web
#' ## page with htmlwidgets::saveWidget(diagram, "pedigree.html").
#' @export
drawPedigreeDiagram <- function(layout, edgeStyle = c("rectilinear",
                                                      "direct"),
                                onClick = NULL) {
  if (!is.list(layout) || is.data.frame(layout) ||
        !is.data.frame(layout$nodes) || !is.data.frame(layout$edges)) {
    stop("drawPedigreeDiagram() requires 'layout' to be the list ",
         "makePedigreeMatingLayout() returns, with 'nodes' and 'edges' ",
         "data frames.")
  }
  edgeStyle <- match.arg(edgeStyle)
  .checkOnClick(onClick, "drawPedigreeDiagram")
  # [[ ]], not $: `layout$conditions` would partially match
  # `conditionsNotDrawn` in a layout that lacks `conditions`.
  conditions <- layout[["conditions"]]
  nConditions <- if (is.null(conditions)) 0L else nrow(conditions)
  # nolint start: commented_code_linter.
  # Issue #137 Slice 3: the twin-connector legend rows (label + dashes
  # list-column + color), built the same way .buildTwinConnectorEdges()
  # builds the real connector edges' own columns -- static, unrelated to
  # whether any twin data is actually loaded (like the sex-shape/
  # Affected addNodes rows above it).
  # nolint end
  # S1029: one legend row per condition, in place of the single
  # "Affected" row; the one row stays when the pedigree has no
  # condition column, as before.
  # pedkindraw Phase G4 (R111): the section painter fills each condition's
  # sections with the layout's colour for it, as the legend's rows below
  # take theirs; the defaults stay after them, so a drawing with the
  # default colours is unchanged.
  sectionColors <- .conditionColors
  if (nConditions > 0L) {
    sectionColors[seq_len(nConditions)] <- conditions$color
  }
  legendConditions <- if (nConditions > 0L) {
    conditions
  } else {
    data.frame(label = "Affected", color = .conditionColors[[1L]],
               stringsAsFactors = FALSE)
  }
  twinLegendEdges <- data.frame(
    label = c("MZ", "DZ", "?"),
    color = rep("#009E73", 3L),
    stringsAsFactors = FALSE
  )
  twinLegendEdges$dashes <- I(list(FALSE, c(4L, 4L), c(14L, 8L)))
  # S921: the dashed repeat-appearance link's legend row -- plain dashes
  # like dupEdges in R/makePedigreeDiagramData.R, color unset so it
  # follows the diagram's own edge color. It goes FIRST: the legend
  # rescales itself to fill its canvas and the Export button covers the
  # last row's right-hand end, so the last row has to stay the short "?"
  # one (confirmed hands-on, S921).
  legendEdges <- rbind(
    data.frame(label = "Same animal, again", color = NA_character_,
               dashes = I(list(TRUE)), stringsAsFactors = FALSE),
    twinLegendEdges
  )
  # pedkindraw S39 (plan R95): no arrowheads, as the diagram's own lines have
  # none. visLegend() gives a line with no `arrows` value an arrowhead at its
  # right end, over the end of the label: measured in headless Chrome, it
  # covered "Same animal, again" by 5.5 px in a 776 px drawing and 10.1 px in
  # a 700 px one. Each label on white, so the line stops at the label rather
  # than running through it (the comma read as a semicolon).
  legendEdges$arrows <- ""
  legendEdges$font.background <- "#FFFFFF"
  # The legend's symbol rows, as three tables so each row's label, shape,
  # fill and picture sit together (S1159). The fill alone, as the diagram's
  # animals get it: the 5 sex rows are open (white) like an unaffected
  # animal; left unset they took vis.js's default light-blue fill. A single
  # color string would also give an outline 20% darker (vis.js's
  # parseColor), so the outline stays vis.js's default blue, the diagram's
  # own.
  sexRows <- data.frame(
    label = c("Female", "Male", "Hermaphrodite", "Unknown",
              "Other / Unrecorded"), # nolint: nonportable_path_linter
    shape = c("dot", "square", "star", "triangle", "diamond"),
    color.background = .affectedColor(FALSE),
    image = NA_character_,
    stringsAsFactors = FALSE
  )
  # Issue #133 Slice 2 (D6), S1029: one row per condition drawn.
  # "hexagon" (not "box") -- confirmed hands-on that vis.js sizes "box" to
  # its label text (renders as a filled pill/badge), breaking the
  # fixed-size-icon-plus-separate-label style the sex rows share;
  # "hexagon" is a fixed-size icon none of them claim.
  conditionRows <- data.frame(
    label = legendConditions$label,
    shape = "hexagon",
    color.background = legendConditions$color,
    image = NA_character_,
    stringsAsFactors = FALSE
  )
  # pedkindraw S28 (plan R81): with two or more conditions every animal's
  # symbol is cut into sections, one per condition, so each condition's row
  # is a picture of those sections with its own filled
  # (.conditionLegendImage()); the colour is in the picture, not a fill.
  if (nConditions >= 2L) {
    conditionRows$shape <- "image"
    conditionRows$color.background <- NA_character_
    conditionRows$image <- vapply(seq_len(nConditions), function(i) {
      .conditionLegendImage(i, nConditions, legendConditions$color[[i]])
    }, character(1L))
  }
  # S1028: the "Deceased" row is a picture (a circle with the slash), after
  # the condition rows and before the edge rows, so the last legend row
  # stays the short "?" one (S921). Measured in the real app: a label
  # starts 11 world units under its symbol and is 14 tall, so a row takes
  # its symbol (2 * size) plus 25 of the row spacing (stepY). At the old
  # size 20 and stepY 54 every label overran the next symbol by 11; size 14
  # and stepY 60 leave 7 clear.
  deceasedRow <- data.frame(
    label = "Deceased", shape = "image", color.background = NA_character_,
    image = .deceasedLegendImage(), stringsAsFactors = FALSE
  )
  # pedkindraw Phase G2 (R106-R107): an animal whose status is unknown is
  # filled .unknownColor (one condition) or has a "?" section (two to four),
  # and then a grey hexagon after the condition rows says what the grey is.
  hasUnknown <- any(layout$nodes[["color.background"]] %in% .unknownColor) ||
    any(grepl("?", layout$nodes[["affectedSections"]], fixed = TRUE))
  unknownRow <- data.frame(
    label = "Affected status unknown", shape = "hexagon",
    color.background = .unknownColor, image = NA_character_,
    stringsAsFactors = FALSE
  )[hasUnknown, , drop = FALSE]
  # pedkindraw Phase G13 (R133-R134): a genotyped animal's node has a thick
  # outline, and then a "Genotyped" row, a square with that outline, comes
  # before "Deceased". The rows get a borderWidth only then, so a drawing with
  # no genotyped animal is as before.
  hasGenotyped <- any(layout$nodes[["borderWidth"]] %in% .genotypedBorderWidth)
  genotypedRow <- data.frame(
    label = "Genotyped", shape = "square",
    color.background = .affectedColor(FALSE), image = NA_character_,
    stringsAsFactors = FALSE
  )[hasGenotyped, , drop = FALSE]
  # pedkindraw Phase G13 (R133, R135): a carrier's symbol has a black dot at
  # its centre (.carrierDotHandler()), and then a "Carrier" row, a picture of
  # a circle with the dot, comes before "Deceased".
  hasCarrier <- isTRUE(any(layout$nodes[["carrier"]]))
  carrierRow <- .markLegendRow("Carrier", .carrierLegendImage(), hasCarrier)
  # pedkindraw Phase G13 (R133, R136): a proband's and a consultand's symbol
  # has an arrow at its lower left (.probandArrowHandler()), and then a
  # "Proband" and a "Consultand" row, each a picture of the arrow, come
  # before "Deceased"; invisible points keep each arrow inside the drawing
  # (.probandArrowRoom()).
  hasProband <- isTRUE(any(layout$nodes[["proband"]]))
  probandRow <- .markLegendRow("Proband", .probandLegendImage(TRUE),
                               hasProband)
  hasConsultand <- isTRUE(any(layout$nodes[["consultand"]]))
  consultandRow <- .markLegendRow("Consultand", .probandLegendImage(FALSE),
                                  hasConsultand)
  # pedkindraw Phase G13 (R133, R137): an evaluated animal's symbol has a
  # star at its upper right (.evaluatedStarHandler()), and then an
  # "Evaluated" row, a picture of the star, comes before "Deceased";
  # invisible points keep each star inside the drawing (.evaluatedStarRoom()).
  hasEvaluated <- isTRUE(any(layout$nodes[["evaluated"]]))
  evaluatedRow <- .markLegendRow("Evaluated", .evaluatedLegendImage(),
                                 hasEvaluated)
  # pedkindraw Phase G13 (R133, R138): an infertile animal's symbol has a
  # line and two bars under it, one with no offspring by choice or for an
  # unknown reason a line and one bar (.infertileBarsHandler()), its id moved
  # below them; then an "Infertile" and a "No offspring" row, each a picture
  # of its mark, come before "Deceased"; invisible points keep each moved id
  # inside the drawing (.infertileRoom()).
  hasInfertile <- isTRUE(any(layout$nodes[["fertility"]] == "infertile"))
  infertileRow <- .markLegendRow("Infertile", .infertileLegendImage(TRUE),
                                 hasInfertile)
  hasNoOffspring <- isTRUE(any(layout$nodes[["fertility"]] ==
                                 "infertile_choice_na"))
  noOffspringRow <- .markLegendRow("No offspring",
                                   .infertileLegendImage(FALSE),
                                   hasNoOffspring)
  # pedkindraw Phase G13 (R133, R139): a miscarriage is drawn as a small
  # triangle, a termination's and an ectopic pregnancy's with a line across
  # it and an ectopic pregnancy's with "ECT" under it
  # (.miscarriageHandler()), its id moved into its row; then a
  # "Miscarriage", a "Termination" and an "Ectopic" row, each a picture of
  # its triangle, come before "Deceased"; invisible points keep the
  # drawing's fit as for a full-size symbol (.miscarriageRoom()).
  kinds <- layout$nodes[["miscarriage"]]
  hasSab <- isTRUE(any(kinds == "SAB"))
  hasTop <- isTRUE(any(kinds == "TOP"))
  hasEct <- isTRUE(any(kinds == "ECT"))
  sabRow <- .markLegendRow("Miscarriage", .miscarriageLegendImage("SAB"),
                           hasSab)
  topRow <- .markLegendRow("Termination", .miscarriageLegendImage("TOP"),
                           hasTop)
  ectRow <- .markLegendRow("Ectopic", .miscarriageLegendImage("ECT"),
                           hasEct)
  hasArrow <- hasProband || hasConsultand
  # pedkindraw Phase G14 (R140): animals smaller than full size keep a
  # full-size symbol's room (.symbolSizeRoom()).
  nodes <- .symbolSizeRoom(layout$nodes)
  # pedkindraw Phase G14 (R140): text larger than vis.js's 14 pixels keeps
  # room for the outermost labels (.textSizeRoom()).
  nodes <- .textSizeRoom(nodes)
  if (hasArrow) nodes <- .probandArrowRoom(nodes)
  if (hasEvaluated) nodes <- .evaluatedStarRoom(nodes)
  hasBars <- hasInfertile || hasNoOffspring
  if (hasBars) nodes <- .infertileRoom(nodes)
  hasMiscarriage <- hasSab || hasTop || hasEct
  if (hasMiscarriage) nodes <- .miscarriageRoom(nodes)
  legendNodes <- rbind(sexRows, conditionRows, unknownRow, genotypedRow,
                       carrierRow, probandRow, consultandRow, evaluatedRow,
                       infertileRow, noOffspringRow, sabRow, topRow, ectRow,
                       deceasedRow)
  legendNodes$size <- 14L
  if (hasGenotyped) {
    legendNodes$borderWidth <- ifelse(legendNodes$label %in% genotypedRow$label,
                                      .genotypedBorderWidth, 1L)
  }
  # Option 2 Slice 3: fixed x/y coordinates (S457's proven Case C2
  # geometry) replace visHierarchicalLayout() entirely -- confirmed
  # hands-on (Learning 446) that manual coordinates and hierarchical
  # layout are mutually exclusive in vis.js. S1028/S1029: the height is
  # .diagramHeight()'s, which the Shiny application also gives its output.
  # pedkindraw Phase G2: the unknown row adds 45 px as one more condition row
  # does (with no condition column the legend still has its one row).
  rowsForHeight <- max(nConditions, 1L) + hasUnknown + hasGenotyped +
    hasCarrier + hasProband + hasConsultand + hasEvaluated + hasInfertile +
    hasNoOffspring + hasSab + hasTop + hasEct
  visNetwork::visNetwork(nodes, layout$edges,
                         height = sprintf("%dpx",
                                          .diagramHeight(rowsForHeight))) |>
    visNetwork::visPhysics(enabled = FALSE) |>
    visNetwork::visNodes(physics = FALSE) |>
    visNetwork::visEdges(smooth = FALSE) |>
    # visNetwork does not auto-bind node clicks to a Shiny input -- the
    # application wires it explicitly through onClick (confirmed hands-on,
    # issue #129 Slice 2 Pre-RED); a NULL onClick adds no click event.
    visNetwork::visEvents(
      click = onClick,
      # S1029: the sections of each multi-condition symbol, then
      # S1028's slash through each deceased animal's symbol on top.
      afterDrawing = .diagramAfterDrawing(nConditions >= 2L, sectionColors,
                                          hasCarrier, hasArrow, hasEvaluated,
                                          hasBars, hasTop || hasEct)
    ) |>
    # Image export (issue #131): visExport() bundles its own JS deps
    # (FileSaver/Blob/canvas-toBlob/html2canvas/jsPDF) as htmlwidget
    # dependencies -- no CDN calls, confirmed hands-on Pre-RED.
    visNetwork::visExport(
      type = "png", name = "pedigree_diagram",
      label = "Export Diagram (PNG)"
    ) |>
    # Shape-to-sex legend (issue #132): renders as its own, separate
    # vis.Network instance (confirmed in the visNetwork.js source,
    # Pre-RED) -- its clicks do not reach the click-to-navigate handler
    # bound above via visEvents().
    visNetwork::visLegend(
      # Issue #133 Slice 2 (D6): the condition rows share this SAME
      # addNodes data frame as the sex rows -- a second visLegend() call
      # would overwrite, not stack (confirmed S485).
      addNodes = legendNodes,
      # nolint start: commented_code_linter.
      # Issue #137 Slice 3 (D6/§2.8 trap #10): the twin-connector
      # legend rows, added via THIS SAME visLegend() call's addEdges
      # parameter -- confirmed by reading visLegend()'s own source
      # (Pre-RED) that addEdges passes straight through to
      # x$legend$edges with no validation, exactly like addNodes above,
      # so a second visLegend() call is not needed and would only
      # overwrite this one (same single-scalar-slot constraint the
      # #133 Affected-row comment above already established). Values
      # match .buildTwinConnectorEdges() (R/makePedigreeDiagramData.R)
      # exactly -- label + dashes + color (D10's #009E73 color pick,
      # found never wired at S494, fixed S506). S921: the same table
      # now also leads with the "Same animal, again" row for the dashed
      # repeat-appearance link (built above, where `legendEdges` is
      # made).
      # nolint end
      addEdges = legendEdges,
      useGroups = FALSE,
      position = "right",
      main = "Sex",
      # Default width (0.2) clips the longest label ("Other /
      # Unrecorded") against the legend canvas's own overflow:hidden
      # boundary (confirmed hands-on, Pre-RED) -- widened enough for it
      # to render in full.
      width = 0.28,
      # Default stepY (100) spaces 5 entries across 400 world-units,
      # which does not comfortably fit the widget's fixed 400px height
      # alongside the export button below it (confirmed hands-on,
      # Pre-RED) -- tightened so all 5 legend rows render without
      # crowding the button. Issue #133 Slice 2 (Dragon #4): the 6th
      # ("Affected") row's own label was confirmed hands-on to clip
      # against this same 400px boundary at stepY=65L (the icon itself
      # rendered, but "Affected" text below it did not) -- retuned to
      # 54L so 6 rows fit within the same envelope 5 rows previously
      # occupied. S1028: 11 rows now (the "Deceased" picture), in a 500px
      # canvas, at 60L (see the symbol size above).
      stepY = 60L
    ) |>
    # Search + highlight (issue #135): nodesIdSelection adds a
    # "Select by id" dropdown; highlightNearest dims non-connected
    # nodes. hover = TRUE (not visOptions()'s own click-based default)
    # so the highlight trigger is hover, not click -- click is already
    # bound above to click-to-navigate (issue #129 Slice 2), and the
    # two would otherwise both fire on the same click. NOTE: the list
    # key is "hover", not "hoverNearest" -- the latter is only the name
    # of the OUTPUT JSON field this produces (confirmed against
    # visNetwork:::visOptions()'s source, PROJECT_LEARNINGS.md
    # Learning 443).
    #
    # KNOWN TRADE-OFF (Learning 443, owner-accepted): nodesIdSelection
    # injects its own Shiny-bound <select> elements client-side,
    # outside this renderUI()-wrapped container's normal diff cycle.
    # From the SECOND reactive re-render onward (e.g. two consecutive
    # click-to-navigate actions), this can log one transient, benign
    # "[shiny] Duplicate input IDs were found" console warning -- the
    # DOM always ends with exactly one live element (no permanent
    # duplication) and all diagram interactivity keeps working
    # correctly afterward (verified hands-on via shinytest2/chromote).
    # Root cause is visNetwork's own client-side widget lifecycle, not
    # this package's code; a structural fix (e.g. visNetworkProxy()
    # incremental updates instead of a full renderVisNetwork()
    # re-render) was judged disproportionate to what the audit itself
    # scored "optional, low-priority... UI polish" and would risk the
    # three already-shipped Diagram-tab features above (click-to-
    # navigate, export, legend).
    #
    # Option 2 Slice 3 (D6): nodesIdSelection's own "values" option
    # (confirmed in visOptions()'s source) restricts the dropdown to an
    # explicit id list -- filtered here to real individuals only, so a
    # real individual appears once in the searchable list, not once per
    # mating-unit/duplicate occurrence.
    #
    # Issue #136 Slice 2 (D6): the useLabels dropdown option is pinned
    # to FALSE UNCONDITIONALLY (not toggle-dependent) -- without it,
    # the moment a real individual's label becomes a name (show-names
    # toggle on), visNetwork's own useLabels-defaults-TRUE behavior
    # (unset before this session) would silently switch the dropdown
    # to listing names while its caption still reads "Select by id"
    # (confirmed hands-on Pre-RED, design doc sec 2.5).
    #
    # pedkindraw S38 (plan R94): the filter leaves out every prefix of
    # .reservedIdPattern (R/makePedigreeDiagramData.R), __jog_ included, the
    # routing points .resolveEdgeNodeCollisions() adds.
    visNetwork::visOptions(
      nodesIdSelection = list(
        enabled = TRUE, useLabels = FALSE, values = layout$nodes$id[
          !grepl(.reservedIdPattern, layout$nodes$id)
        ]
      ),
      highlightNearest = list(
        enabled = TRUE, hover = TRUE,
        # Issue #142 D3 (live-confirmed regression, S468): under the
        # rectilinear style, a plain individual's nearest edge-graph
        # neighbor is often an invisible __bar_/__drop_/__proj_
        # waypoint rather than a visible union dot, so degree = 1L
        # (correct for the direct style, where degree 1 always
        # reaches a visible node) can highlight nothing visible at
        # all. Raising it restores visible feedback for the common
        # case confirmed live (measured hop distances up to 4).
        #
        # KNOWN LIMITATION (S909, owner-ruled: keep 6). The hover
        # counts every edge, invisible waypoints included, so it can
        # stop short of an animal's own parents' union dot. Measured
        # on the 375-animal rhesus pedigree: hovering never lights
        # nothing (0 of 375), and 373 of 375 animals light everything
        # the direct style's degree 1 lights; the other 2 are 7 hops
        # from that dot because their sibship connectors were
        # rerouted through __jog_ waypoints. A pair with 9 or more
        # full siblings reaches the same limit on its own (the widest
        # bundled pedigree has 4). Raising the degree was declined to
        # keep the hover simple: 7 would light about 5 more nodes on
        # a typical hover (median 14 -> 19) to fix those 2 animals,
        # and no fixed degree covers a wide family. The owner notes
        # that some baboon pedigrees have more siblings (none is
        # bundled, so not measured here); revisit only when a user
        # asks. Measurements and scripts:
        # docs/audits/HIGHLIGHT_NEAREST_REACH_2026-10-05.md.
        degree = if (edgeStyle == "rectilinear") 6L else 1L,
        algorithm = "all"
      )
    )
}

#' Stop unless onClick is NULL or one JavaScript function, as a string
#'
#' The check \code{drawPedigreeDiagram()} and \code{drawColonyOverview()}
#' share (S1153). The error names the function the user called and carries
#' that call, as when each function made the check itself.
#'
#' @param onClick the caller's \code{onClick} argument.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, invisibly, when \code{onClick} is acceptable.
#' @noRd
.checkOnClick <- function(onClick, caller) {
  if (!is.null(onClick) &&
        (!is.character(onClick) || length(onClick) != 1L || is.na(onClick))) {
    stop(simpleError(
      paste0(caller, "() requires 'onClick' to be NULL or one JavaScript ",
             "function, as a character string."),
      call = sys.call(-1L)
    ))
  }
  invisible(NULL)
}
