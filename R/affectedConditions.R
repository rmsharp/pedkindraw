## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/affectedConditions.R at nprcgenekeepr commit
## baef1e12c (unchanged to 4375e2715), whole. Changes: pedkindraw S28 added
## .conditionLegendImage() after .conditionSectionsHandler() (plan R81; a
## DIVERGENCE.md row until nprcgenekeepr has it). pedkindraw S43 (plan Phase
## G2, R106; DIVERGENCE.md rows "at the switch") added .unknownColor after
## .conditionColors, and changed .affectedSectionsOf() (an unknown condition
## is "?", not "0") and .conditionSectionsHandler() (a "?" section is filled
## .unknownColor). pedkindraw S45 (plan Phase G4, R111; a DIVERGENCE.md row "at
## the switch") changed .diagramAfterDrawing(), which takes the colours it
## passes to .conditionSectionsHandler(). pedkindraw S55 (plan Phase G13,
## R133 and R135; the same row) gave it an argument carrier, which runs
## .carrierDotHandler() (pedkindraw's own, R/carrierMark.R) after the slash;
## pedkindraw S56 (R136; the same row) an argument arrows, which runs
## .probandArrowHandler() (pedkindraw's own, R/probandMark.R) after the dot;
## pedkindraw S57 (R137; the same row) an argument evaluated, which runs
## .evaluatedStarHandler() (pedkindraw's own, R/evaluatedMark.R) after the
## arrows; pedkindraw S58 (R138; the same row) an argument infertile, which
## runs .infertileBarsHandler() (pedkindraw's own, R/infertileMark.R) after
## the star; pedkindraw S59 (R139; the same row) an argument miscarriage,
## which runs .miscarriageHandler() (pedkindraw's own, R/miscarriageMark.R)
## last; pedkindraw S63 (plan Phase G14, R140; the same row) an argument
## lineWidth, which it passes to every handler, and
## .conditionSectionsHandler() its argument lineWidth, the width of its
## lines (a DIVERGENCE.md row).
## Phase 8 copied
## its lines 1-75, the four pieces the layout uses (.conditionColors,
## .conditionColumns(), .conditionLabels() and .affectedSectionsOf()); Phase
## 9 its lines 76-201, the three the drawing uses
## (.conditionSectionsHandler(), .diagramAfterDrawing() and .diagramHeight();
## plan R32).

# More than one affected condition on the Pedigree Browser's Diagram (S1029)

#' The colors of the affected conditions, in order
#'
#' S1029. Condition 1 keeps the pink a lone \code{affected} column has always
#' had (\code{.affectedColor()}); the other three are the colour-blind-safe
#' Okabe-Ito orange, sky blue and bluish green. kinship2 allows four
#' conditions, so the length of this vector is the most the Diagram draws.
#' pedkindraw S45 (plan Phase G4, R111): the default of the builders'
#' \code{conditionColors}, and the colours of the section painter after the
#' conditions a layout draws.
#' @noRd
.conditionColors <- c("#CC79A7", "#E69F00", "#56B4E9", "#009E73")

#' The fill of an unknown affected status
#'
#' pedkindraw S43 (plan Phase G2, R106). R's \dQuote{grey}, as Pedixplorer
#' fills an animal whose affected status is \code{NA}: the whole symbol with
#' one condition, the condition's section with two to four. Measured apart from
#' white and from the four \code{.conditionColors}, in greyscale and under
#' three simulated colour blindnesses.
#' @noRd
.unknownColor <- "#BEBEBE"

#' The pedigree columns that are affected conditions
#'
#' S1029 (owner ruling). Every column whose name starts with
#' \code{affected}, in the order the pedigree holds them. QC lower-cases a
#' header and drops its spaces, periods and underscores, so the test reads the
#' name as written: a raw data frame with \code{Affected2} has no such
#' column, as it never had \code{affected}.
#' @param ped data frame.
#' @return character vector of column names, \code{character(0)} for none.
#' @noRd
.conditionColumns <- function(ped) {
  grep("^affected", names(ped), value = TRUE)
}

#' What the legend and the tooltip call each condition
#'
#' S1029. \dQuote{Affected} for the column \code{affected}, \dQuote{Affected 2}
#' where the rest of the name is a number, and \dQuote{Affected (diabetes)}
#' for the rest of the name otherwise. A separator left at the front of the
#' rest (\code{affected_diabetes} in a raw data frame) is dropped.
#' @param columns character vector of condition column names.
#' @return character vector, as long as \code{columns}.
#' @noRd
.conditionLabels <- function(columns) {
  vapply(columns, function(column) {
    rest <- sub("^[._ -]+", "", sub("^affected", "", column))
    if (!nzchar(rest)) {
      "Affected"
    } else if (grepl("^[0-9]+$", rest)) {
      paste("Affected", rest)
    } else {
      sprintf("Affected (%s)", rest)
    }
  }, character(1L), USE.NAMES = FALSE)
}

#' The affectedSections string of each node
#'
#' S1029. One character per condition for an animal: \code{"1"} where it is
#' affected, \code{"0"} where it is unaffected, \code{"?"} where it is unknown
#' (pedkindraw S43, plan Phase G2; was \code{"0"}). A repeat-appearance
#' node reads as its real animal; a mating-union, drop, bar or waypoint node is
#' not an animal and gets \code{""}, never \code{NA}.
#' @param nodeIds ids of the layout's nodes.
#' @param conditionOf list with one logical vector per drawn condition, named
#'   by real id.
#' @param realIds ids of the animals, in the order of the vectors.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return character vector, as long as \code{nodeIds}.
#' @noRd
.affectedSectionsOf <- function(nodeIds, conditionOf, realIds, dupIds,
                                dupRealIds) {
  flags <- do.call(cbind, lapply(conditionOf, function(v) {
    flag <- ifelse(v, "1", "0")
    flag[is.na(v)] <- "?"
    flag
  }))
  sectionsOf <- stats::setNames(apply(flags, 1L, paste, collapse = ""),
                                realIds)
  animalOf <- ifelse(nodeIds %in% dupIds,
                     dupRealIds[match(nodeIds, dupIds)], nodeIds)
  ifelse(animalOf %in% realIds, unname(sectionsOf[animalOf]), "")
}

#' The afterDrawing handler that paints the sections of a symbol
#'
#' S1029. With two or more conditions the layout gives each animal's node an
#' \code{affectedSections} string, one character per condition: \code{"1"}
#' where the animal is affected, \code{"?"} where its status is unknown
#' (pedkindraw S43, plan Phase G2: filled \code{.unknownColor}). visNetwork has
#' no sectioned shape, so after
#' each draw this clips to the node's own outline (the same paths vis.js
#' draws: a circle, a square, a diamond, a triangle, a star) and fills the
#' affected sections, equal pie sections counter-clockwise from the top (the
#' first of two is the left half), then strokes the outline and the section
#' lines again so an open section still reads as one. The text uses single
#' quotes only: it travels inside a JSON string.
#' @param colors the fill of each condition, in order.
#' @param lineWidth the layout's line width (pedkindraw S63, plan Phase
#'   G14, R140): the outline and section lines are stroked that wide, 1
#'   at 1, as before.
#' @return A JavaScript function, as a character string.
#' @noRd
.conditionSectionsHandler <- function(colors = .conditionColors,
                                      lineWidth = 1.0) {
  paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var colors = [",
    paste0("'", colors, "'", collapse = ", "), "];\n",
    "  var unknown = '", .unknownColor, "';\n",
    "  var animals = net.body.data.nodes.get({filter: function(n) {",
    " return typeof n.affectedSections === 'string' &&",
    " n.affectedSections.length > 1; }});\n",
    "  if (animals.length === 0) { return; }\n",
    "  var trace = function(shape, x, y, s) {\n",
    "    ctx.beginPath();\n",
    "    if (shape === 'square') {\n",
    "      ctx.rect(x - s, y - s, 2 * s, 2 * s);\n",
    "    } else if (shape === 'diamond') {\n",
    "      ctx.moveTo(x, y + s); ctx.lineTo(x + s, y);\n",
    "      ctx.lineTo(x, y - s); ctx.lineTo(x - s, y);\n",
    "    } else if (shape === 'triangle') {\n",
    "      var r = s * 1.15, yy = y + 0.275 * r, o = 2 * r, h = o / 2;\n",
    "      var ir = Math.sqrt(3) / 6 * o, a = Math.sqrt(o * o - h * h);\n",
    "      ctx.moveTo(x, yy - (a - ir)); ctx.lineTo(x + h, yy + ir);\n",
    "      ctx.lineTo(x - h, yy + ir);\n",
    "    } else if (shape === 'star') {\n",
    "      var q = s * 0.82, yq = y + 0.1 * q;\n",
    "      for (var j = 0; j < 10; j++) {\n",
    "        var rr = (j % 2 === 0) ? 1.3 * q : 0.5 * q;\n",
    "        ctx.lineTo(x + rr * Math.sin(2 * j * Math.PI / 10),",
    " yq - rr * Math.cos(2 * j * Math.PI / 10));\n",
    "      }\n",
    "    } else {\n",
    "      ctx.arc(x, y, s, 0, 2 * Math.PI);\n",
    "    }\n",
    "    ctx.closePath();\n",
    "  };\n",
    "  ctx.save();\n",
    "  ctx.lineWidth = ", format(lineWidth, digits = 4L), ";\n",
    "  animals.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id), s = n.size || 25;\n",
    "    var k = n.affectedSections.length, d = 2 * Math.PI / k;\n",
    "    var border = (n.color && n.color.border) || '#2B7CE9';\n",
    "    ctx.save();\n",
    "    trace(n.shape, p.x, p.y, s);\n",
    "    ctx.clip();\n",
    "    for (var i = 0; i < k; i++) {\n",
    "      var from = -Math.PI / 2 - (i + 1) * d, to = -Math.PI / 2 - i * d;\n",
    "      var mark = n.affectedSections.charAt(i);\n",
    "      if (mark === '1' || mark === '?') {\n",
    "        ctx.beginPath();\n",
    "        ctx.moveTo(p.x, p.y);\n",
    "        ctx.arc(p.x, p.y, 3 * s, from, to, false);\n",
    "        ctx.closePath();\n",
    "        ctx.fillStyle = mark === '1' ? colors[i] : unknown;\n",
    "        ctx.fill();\n",
    "      }\n",
    "    }\n",
    "    ctx.strokeStyle = border;\n",
    "    for (var m = 0; m < k; m++) {\n",
    "      var edge = -Math.PI / 2 - m * d;\n",
    "      ctx.beginPath();\n",
    "      ctx.moveTo(p.x, p.y);\n",
    "      ctx.lineTo(p.x + 3 * s * Math.cos(edge),",
    " p.y + 3 * s * Math.sin(edge));\n",
    "      ctx.stroke();\n",
    "    }\n",
    "    ctx.restore();\n",
    "    ctx.strokeStyle = border;\n",
    "    trace(n.shape, p.x, p.y, s);\n",
    "    ctx.stroke();\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  )
}

#' The legend's picture of one condition's section
#'
#' pedkindraw S28 (plan R81). With two or more conditions the diagram cuts
#' every symbol into equal sections, one per condition
#' (\code{.conditionSectionsHandler()}), and draws the dividing lines on an
#' unaffected animal too. The legend is its own vis.Network and cannot run that
#' handler, so each condition's row is an inline SVG image, as the
#' \dQuote{Deceased} row is: that row's circle (radius 22 in a 50-pixel
#' square, white, outlined in the diagram's blue), the dividing lines at the
#' handler's angles, and the condition's own section filled. Section \code{i}
#' of \code{k} runs from -pi/2 - i * d to -pi/2 - (i - 1) * d, d = 2 * pi / k,
#' clockwise on the page, where the handler fills it: the first of two is the
#' left half.
#' @param section the condition's number, 1 to \code{nSections}.
#' @param nSections the number of conditions drawn, 2 to 4.
#' @param color the condition's fill.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.conditionLegendImage <- function(section, nSections, color) {
  step <- 2.0 * pi / nSections
  from <- -pi / 2.0 - section * step
  to <- -pi / 2.0 - (section - 1L) * step
  edges <- -pi / 2.0 - (seq_len(nSections) - 1L) * step
  svg <- paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<circle cx='25' cy='25' r='22' fill='white'/>",
    sprintf(paste0("<path d='M25 25 L%.1f %.1f A22 22 0 0 1 %.1f %.1f Z' ",
                   "fill='%s'/>"),
            25.0 + 22.0 * cos(from), 25.0 + 22.0 * sin(from),
            25.0 + 22.0 * cos(to), 25.0 + 22.0 * sin(to), color),
    paste(sprintf(paste0("<line x1='25' y1='25' x2='%.1f' y2='%.1f' ",
                         "stroke='#2B7CE9' stroke-width='2'/>"),
                  25.0 + 22.0 * cos(edges), 25.0 + 22.0 * sin(edges)),
          collapse = ""),
    "<circle cx='25' cy='25' r='22' fill='none' stroke='#2B7CE9' ",
    "stroke-width='2'/></svg>"
  )
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}

#' The one afterDrawing handler of the Diagram
#'
#' S1029. visNetwork takes one \code{afterDrawing} function, so this runs the
#' section painter first and the S1028 deceased slash after it, which puts the
#' slash on top of the sections. Each is called with the network as
#' \code{this}.
#' @param sections \code{TRUE} when the pedigree has two or more conditions,
#'   so some node carries \code{affectedSections}; the section painter is left
#'   out otherwise.
#' @param colors the fill of each condition's sections, passed to
#'   \code{.conditionSectionsHandler()} (pedkindraw S45, plan Phase G4:
#'   \code{drawPedigreeDiagram()} passes the layout's colours, the defaults
#'   after them).
#' @param carrier \code{TRUE} when some node is a carrier's (pedkindraw S55,
#'   plan Phase G13, R135): \code{.carrierDotHandler()} then runs after the
#'   slash, so the dot is on top; it is left out otherwise.
#' @param arrows \code{TRUE} when some node is a proband's or a consultand's
#'   (pedkindraw S56, plan Phase G13, R136): \code{.probandArrowHandler()}
#'   then runs after the dot; it is left out otherwise.
#' @param evaluated \code{TRUE} when some node is an evaluated animal's
#'   (pedkindraw S57, plan Phase G13, R137): \code{.evaluatedStarHandler()}
#'   then runs after the arrows; it is left out otherwise.
#' @param infertile \code{TRUE} when some node is an infertile animal's or
#'   one with no offspring by choice or for an unknown reason (pedkindraw
#'   S58, plan Phase G13, R138): \code{.infertileBarsHandler()} then runs
#'   after the star; it is left out otherwise.
#' @param miscarriage \code{TRUE} when some node is a termination's or an
#'   ectopic pregnancy's (pedkindraw S59, plan Phase G13, R139):
#'   \code{.miscarriageHandler()} then runs last; it is left out otherwise.
#' @param lineWidth the layout's line width (pedkindraw S63, plan Phase
#'   G14, R140), passed to every handler that strokes lines.
#' @return A JavaScript function, as a character string.
#' @noRd
.diagramAfterDrawing <- function(sections = FALSE,
                                 colors = .conditionColors,
                                 carrier = FALSE, arrows = FALSE,
                                 evaluated = FALSE, infertile = FALSE,
                                 miscarriage = FALSE, lineWidth = 1.0) {
  if (!sections && !carrier && !arrows && !evaluated && !infertile &&
        !miscarriage) {
    return(.deceasedSlashHandler(lineWidth = lineWidth))
  }
  paste0(
    "function(ctx) {\n",
    if (sections) {
      paste0("  (", .conditionSectionsHandler(colors, lineWidth),
             ").call(this, ctx);\n")
    },
    "  (", .deceasedSlashHandler(lineWidth = lineWidth),
    ").call(this, ctx);\n",
    if (carrier) {
      paste0("  (", .carrierDotHandler(), ").call(this, ctx);\n")
    },
    if (arrows) {
      paste0("  (", .probandArrowHandler(lineWidth = lineWidth),
             ").call(this, ctx);\n")
    },
    if (evaluated) {
      paste0("  (", .evaluatedStarHandler(lineWidth = lineWidth),
             ").call(this, ctx);\n")
    },
    if (infertile) {
      paste0("  (", .infertileBarsHandler(lineWidth = lineWidth),
             ").call(this, ctx);\n")
    },
    if (miscarriage) {
      paste0("  (", .miscarriageHandler(lineWidth = lineWidth),
             ").call(this, ctx);\n")
    },
    "}"
  )
}

#' The height of the Diagram's canvas, in pixels
#'
#' S1029. The legend shares the canvas, rescaling itself to fill it. At 500 px
#' its 11 rows read at 0.70 of full size (standalone widget, then the real
#' app); every legend row past the 11th adds 66 world units to the legend, so
#' the canvas grows 45 px (66 times 0.70, rounded) per extra row to keep the
#' text the same size. A pedigree with no condition draws the single
#' \dQuote{Affected} row, as does one with a single condition, so both keep
#' 500 px.
#' @param nConditions number of conditions drawn, 0 to 4.
#' @return integer pixels.
#' @noRd
.diagramHeight <- function(nConditions) {
  500L + 45L * max(as.integer(nConditions) - 1L, 0L)
}
