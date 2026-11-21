## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133 and R138,
## pedkindraw S58). The copied makePedigreeMatingLayout() reads a column
## fertility with .readFertility() and marks each node with
## .fertilityNodes(); the copied .diagramAfterDrawing() runs
## .infertileBarsHandler() last, and the copied drawPedigreeDiagram() moves
## each marked animal's id down and adds the points of .infertileRoom(), and
## an "Infertile" and a "No offspring" legend row (.infertileLegendImage()),
## when an animal is marked (DIVERGENCE.md). S58's REFACTOR: the reader's
## message and the node lookup use .oddValuesShown() and .nodeAnimals()
## (R/markColumns.R), as the true/false mark columns do. S59's REFACTOR:
## .readFertility() reads the column with .readWordColumn()
## (R/markColumns.R), as .readMiscarriage() does. S60 (plan Phase G14,
## R140): .infertileRoom() moves the id in proportion to the node's size.
## S60's REFACTOR: the move by .sizedIdDown() (R/symbolSize.R), the point
## moved with it by .markRoom()'s down. S61 (plan Phase G14, R140): the
## room below the moved id is .idLabelDepth() of the node's text size
## (R/textSize.R), 25 units at vis.js's 14. S63 (plan Phase G14, R140):
## .infertileBarsHandler() strokes the line and bars 2 times the line
## width. S63's REFACTOR: written by
## .strokeWidthJs() (R/lineWidth.R).

#' The fertility values read, and what each means
#'
#' Phase G13 (R138). Pedixplorer's words and values, from its help for
#' \code{fertility_to_factor()}: \code{"fertile"} (also \code{TRUE} and 1),
#' \code{"infertile"} (also \code{"steril"}, \code{FALSE} and 0), and
#' \code{"infertile_choice_na"}, no offspring by choice or for an unknown
#' reason (also \code{"infertile_choice"} and \code{"infertile_na"}). Text is
#' read in any case, as Pedixplorer reads it.
#' @noRd
.fertilityWords <- c(
  fertile = "fertile", true = "fertile", "1" = "fertile",
  infertile = "infertile", steril = "infertile", false = "infertile",
  "0" = "infertile",
  infertile_choice_na = "infertile_choice_na",
  infertile_choice = "infertile_choice_na",
  infertile_na = "infertile_choice_na"
)

#' Read the fertility column of a pedigree
#'
#' Phase G13 (R138). \code{NULL} when \code{ped} has no column
#' \code{fertility}. Otherwise each animal's fertility, \code{"fertile"},
#' \code{"infertile"}, \code{"infertile_choice_na"} or \code{NA} (not
#' recorded, as \code{NA} and \code{NaN} are), named by id; the column may
#' be logical, numbers, text or a factor (\code{asPedFrame()} returns
#' Pedixplorer's as a factor). Anything else stops, naming the caller, the
#' column and up to five of its other values; Pedixplorer reads them as
#' fertile without a word. S59's REFACTOR: read by \code{.readWordColumn()},
#' each value's key its text in lower case.
#' @param ped data frame with an \code{id} column.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, or a character vector named by \code{ped$id}.
#' @noRd
.readFertility <- function(ped, caller) {
  .readWordColumn(ped, "fertility", .fertilityWords, tolower, caller, paste0(
    "Give \"fertile\", \"infertile\" or \"infertile_choice_na\" for each ",
    "animal (TRUE or 1 for fertile, FALSE or 0 for infertile, as ",
    "Pedixplorer reads them), NA where it is not recorded."
  ))
}

#' Each node's fertility mark
#'
#' Phase G13 (R138). \code{"infertile"} or \code{"infertile_choice_na"} for
#' the node of such an animal and each of its repeat-appearance nodes;
#' \code{""} for every other node: an animal fertile or not recorded, a
#' mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param fertility what \code{.readFertility()} returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return character vector, as long as \code{nodeIds}, never \code{NA}.
#' @noRd
.fertilityNodes <- function(nodeIds, fertility, dupIds, dupRealIds) {
  kind <- unname(fertility[.nodeAnimals(nodeIds, dupIds, dupRealIds)])
  ifelse(kind %in% c("infertile", "infertile_choice_na"), kind, "")
}

#' The hover text's word for each fertility
#'
#' Phase G13 (R138).
#' @param fertility \code{"fertile"}, \code{"infertile"},
#'   \code{"infertile_choice_na"} or \code{NA} for each animal.
#' @return character vector: \dQuote{Fertile}, \dQuote{Infertile},
#'   \dQuote{No offspring by choice or for an unknown reason} or
#'   \dQuote{Unknown}.
#' @noRd
.fertilityLabel <- function(fertility) {
  shown <- c(fertile = "Fertile", infertile = "Infertile",
             infertile_choice_na = paste("No offspring by choice or for an",
                                         "unknown reason"))[fertility]
  shown[is.na(shown)] <- "Unknown"
  unname(shown)
}

#' The infertile mark's shape
#'
#' Phase G13 (R138). Pedixplorer's picture, the standard one: a line down
#' from the bottom of the symbol and a bar across its end, and for an
#' infertile animal a second, wider bar below it; an animal with no
#' offspring by choice or for an unknown reason has the first bar only. In
#' units of the node's \code{size}: the line's length (\code{line}), the
#' half-width of each bar (\code{bar1}, \code{bar2}) and the second bar's
#' distance below the first (\code{gap}); and how far the animal's id moves
#' down, in units at a full-size symbol (\code{idDown}, in proportion to
#' the node's size otherwise, Phase G14), so it sits below the bars.
#' Measured in headless Chrome in a 500-pixel drawing (S58): in 7
#' pedigrees, in both edge styles, the mark lies on nothing else for an
#' animal without offspring, 2 to 6 pixels from its own id.
#' @noRd
.infertileMark <- list(line = 0.58, bar1 = 0.8, bar2 = 1.0, gap = 0.2,
                       idDown = 14L)

#' The afterDrawing handler that draws the infertile marks
#'
#' Phase G13 (R138). visNetwork has no mark under a node, so after each draw
#' this strokes, 2 pixels wide and black, a line down from the bottom of
#' every node whose \code{fertility} field is \code{"infertile"} or
#' \code{"infertile_choice_na"} and a bar across its end, and a second bar
#' below that for \code{"infertile"}, placed by \code{mark} in units of the
#' node's own \code{size}. The text uses single quotes only: it travels
#' inside a JSON string.
#' @param mark see \code{.infertileMark}.
#' @param lineWidth the layout's line width (Phase G14, R140): the lines
#'   are stroked 2 times it, 2 at 1, as before.
#' @return A JavaScript function, as a character string.
#' @noRd
.infertileBarsHandler <- function(mark = .infertileMark, lineWidth = 1.0) {
  number <- function(x) format(x, digits = 4L)
  sprintf(paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var marked = net.body.data.nodes.get({filter: function(n) { ",
    "return n.fertility === 'infertile' || ",
    "n.fertility === 'infertile_choice_na'; }});\n",
    "  if (marked.length === 0) { return; }\n",
    "  ctx.save();\n",
    "  ctx.strokeStyle = '#000000';\n",
    .strokeWidthJs(2.0, lineWidth),
    "  marked.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id);\n",
    "    var s = n.size || 25;\n",
    "    var top = p.y + s, end = top + s * %s;\n",
    "    var bars = [[end, s * %s]];\n",
    "    if (n.fertility === 'infertile') { ",
    "bars.push([end + s * %s, s * %s]); }\n",
    "    ctx.beginPath();\n",
    "    ctx.moveTo(p.x, top);\n",
    "    ctx.lineTo(p.x, end);\n",
    "    bars.forEach(function(b) {\n",
    "      ctx.moveTo(p.x - b[1], b[0]);\n",
    "      ctx.lineTo(p.x + b[1], b[0]);\n",
    "    });\n",
    "    ctx.stroke();\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  ), number(mark$line), number(mark$bar1), number(mark$gap),
  number(mark$bar2))
}

#' Move each marked animal's id below its mark, and keep it in the drawing
#'
#' Phase G13 (R138). The id is written under the symbol, where the mark
#' goes, so each node whose \code{fertility} field is \code{"infertile"} or
#' \code{"infertile_choice_na"} has its label moved down \code{idDown} units
#' at a full-size symbol and in proportion to its size otherwise, rounded to
#' a whole unit (Phase G14, R140; measured S60: at symbolSize 1.6 the fixed
#' 14 units left the id 0.3 units below its bar)
#' (vis.js's \code{font.vadjust}; every other node's 0). vis.js fits its view
#' to the nodes without the move, so a moved id in the bottom row was cut
#' off (S58: 0.6 pixels to spare in a four-generation drawing at 500
#' pixels); one invisible point per marked node, 2 units below the moved
#' id's box (which ends \code{.idLabelDepth()} of the node's text size below
#' the symbol before the move, 25 units at vis.js's 14; Phase G14, S61),
#' makes the fit take it in (23 pixels to spare). The points are built by
#' \code{.markRoom()}; each point's id is \code{"__fert_"} and its node's
#' id, a prefix the layout reserves (\code{.reservedIdPrefixes}), and its
#' \code{fertility} is \code{""} (\code{.markRoom()} empties it), so the
#' handler draws nothing there.
#' @param nodes the nodes to draw.
#' @param mark see \code{.infertileMark}.
#' @return \code{nodes} with a \code{font.vadjust} field and one more row
#'   per marked node.
#' @noRd
.infertileRoom <- function(nodes, mark = .infertileMark) {
  marked <- nodes[["fertility"]] %in% c("infertile", "infertile_choice_na")
  idDown <- .sizedIdDown(mark$idDown, nodes$size)
  nodes$font.vadjust <- ifelse(marked, idDown, 0L)
  .markRoom(nodes, marked, "__fert_", c(0.0, 1.0), c(0.0, 2.0),
            idDown + .idLabelDepth(.nodeTextPixels(nodes)))
}

#' The legend's picture of an infertile mark
#'
#' Phase G13 (R138). The legend is its own vis.Network and cannot run the
#' diagram's handler, so its \dQuote{Infertile} and \dQuote{No offspring}
#' rows are inline SVG images, as the \dQuote{Deceased} row is: the mark
#' alone, a line and one or two bars, 3 wide, in a 50-pixel square.
#' Measured S58 at 500 pixels: 34 dark pixels with two bars and 19 with
#' one; a small circle with the mark under it showed 16 and 10.
#' @param twoBars \code{TRUE} for \dQuote{Infertile}, \code{FALSE} for
#'   \dQuote{No offspring}.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.infertileLegendImage <- function(twoBars) {
  stroke <- "stroke='black' stroke-width='3'/>"
  svg <- paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<line x1='25' y1='8' x2='25' y2='26' ", stroke,
    "<line x1='9' y1='26' x2='41' y2='26' ", stroke,
    if (twoBars) paste0("<line x1='5' y1='33' x2='45' y2='33' ", stroke),
    "</svg>"
  )
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}
