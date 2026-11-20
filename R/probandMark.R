## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133 and R136,
## pedkindraw S56). The copied makePedigreeMatingLayout() reads the columns
## proband and consultand with .readMarkColumn(), stops on an animal marked
## both (.checkProbandConsultand()) and marks each node with .markedNodes()
## (R/markColumns.R); the copied .diagramAfterDrawing() runs
## .probandArrowHandler() after the carrier's dot, and the copied
## drawPedigreeDiagram() adds the points of .probandArrowRoom() and a
## "Proband" and a "Consultand" legend row (.probandLegendImage()) when an
## animal is marked (DIVERGENCE.md). S57's REFACTOR: .probandArrowRoom()
## builds its points with .markRoom() (R/markColumns.R), as
## .evaluatedStarRoom() does. S59's REFACTOR: .checkProbandConsultand()
## names the animals with .idsShown() (R/markColumns.R), as
## .checkMiscarriage() does.

#' Where the arrow of a proband or a consultand is drawn
#'
#' Phase G13 (R136). In units of the node's \code{size}, from its centre (x
#' to the right, y down): the arrow's tip (\code{tipX}, \code{tipY}), just
#' outside the lower-left corner of the symbol's square; the arrow rises
#' from its tail at the lower left at \code{angle} degrees above the
#' horizontal; \code{length} is from tail to tip and \code{head} the length
#' of the arrowhead. Measured in headless Chrome in a 500-pixel drawing
#' (S56): 46 to 92 pixels change around a marked animal, none of them over
#' the symbol's outline, the deceased slash, a line or an id label of 1 to
#' 10 characters; Pedixplorer's 45 degrees runs along the slash, touched its
#' end and ran into the label of a 10-character id.
#' @noRd
.probandArrow <- list(tipX = -1.1, tipY = 0.55, angle = 30.0, length = 0.96,
                      head = 0.3)

#' The tail of the arrow, from a node's centre
#'
#' Phase G13 (R136). In units of the node's \code{size}, as
#' \code{.probandArrow}'s tip.
#' @param arrow see \code{.probandArrow}.
#' @return A numeric vector, \code{x} and \code{y}.
#' @noRd
.probandArrowTail <- function(arrow = .probandArrow) {
  angle <- arrow$angle * pi / 180.0
  c(x = arrow$tipX - arrow$length * cos(angle),
    y = arrow$tipY + arrow$length * sin(angle))
}

#' The afterDrawing handler that draws the proband's and consultand's arrow
#'
#' Phase G13 (R136). visNetwork has no arrow on a node, so after each draw
#' this draws a black arrow at the lower left of every node whose
#' \code{proband} or \code{consultand} field is \code{TRUE}, placed by
#' \code{arrow} in units of the node's own \code{size}, and \dQuote{P}
#' (12 units, right-aligned 2 units left of the tail) beside a proband's.
#' The text uses single quotes only: it travels inside a JSON string.
#' @param arrow see \code{.probandArrow}.
#' @return A JavaScript function, as a character string.
#' @noRd
.probandArrowHandler <- function(arrow = .probandArrow) {
  number <- function(x) format(x, digits = 4L)
  sprintf(paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var marked = net.body.data.nodes.get({filter: function(n) { ",
    "return n.proband === true || n.consultand === true; }});\n",
    "  if (marked.length === 0) { return; }\n",
    "  var a = %s * Math.PI / 180;\n",
    "  var ux = Math.cos(a), uy = -Math.sin(a);\n",
    "  ctx.save();\n",
    "  ctx.strokeStyle = '#000000';\n",
    "  ctx.fillStyle = '#000000';\n",
    "  ctx.lineWidth = 2;\n",
    "  ctx.font = '12px arial';\n",
    "  ctx.textAlign = 'right';\n",
    "  ctx.textBaseline = 'middle';\n",
    "  marked.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id);\n",
    "    var s = n.size || 25;\n",
    "    var tx = p.x + s * %s, ty = p.y + s * %s;\n",
    "    var len = s * %s, h = s * %s;\n",
    "    var sx = tx - len * ux, sy = ty - len * uy;\n",
    "    var bx = tx - h * ux, by = ty - h * uy;\n",
    "    ctx.beginPath();\n",
    "    ctx.moveTo(sx, sy);\n",
    "    ctx.lineTo(bx, by);\n",
    "    ctx.stroke();\n",
    "    ctx.beginPath();\n",
    "    ctx.moveTo(tx, ty);\n",
    "    ctx.lineTo(bx - h * 0.5 * uy, by + h * 0.5 * ux);\n",
    "    ctx.lineTo(bx + h * 0.5 * uy, by - h * 0.5 * ux);\n",
    "    ctx.closePath();\n",
    "    ctx.fill();\n",
    "    if (n.proband === true) { ctx.fillText('P', sx - 2, sy); }\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  ), number(arrow$angle), number(arrow$tipX), number(arrow$tipY),
  number(arrow$length), number(arrow$head))
}

#' Invisible points that keep the arrows inside the drawing
#'
#' Phase G13 (R136). vis.js fits its view to the nodes with a twentieth of
#' the range to spare on each side, so the arrow and \dQuote{P} of an animal
#' at the left edge could fall outside the canvas (10 pixels in a 500-pixel
#' drawing of six animals, measured S56). This adds one point per marked
#' node, 12 units left of its arrow's tail (room for the \dQuote{P}) and
#' level with it, invisible as the layout's routing points are (size 0, a
#' transparent fill and outline, no label), so vis.js's fit takes the
#' arrows in. Each point's id is \code{"__mark_"} and its node's id, a prefix
#' the layout reserves (\code{.reservedIdPrefixes}). The points are built by
#' \code{.markRoom()} (S57's REFACTOR).
#' @param nodes the layout's nodes.
#' @param arrow see \code{.probandArrow}.
#' @return \code{nodes} with one more row per node whose \code{proband} or
#'   \code{consultand} field is \code{TRUE}; \code{nodes} itself when there
#'   is none.
#' @noRd
.probandArrowRoom <- function(nodes, arrow = .probandArrow) {
  marked <- .markField(nodes, "proband") | .markField(nodes, "consultand")
  .markRoom(nodes, marked, "__mark_", .probandArrowTail(arrow), c(-12.0, 0.0))
}

#' The legend's picture of a proband or a consultand: the arrow
#'
#' Phase G13 (R136). The legend is its own vis.Network and cannot run the
#' diagram's handler, so its \dQuote{Proband} and \dQuote{Consultand} rows
#' are inline SVG images, as the \dQuote{Deceased} row is: the arrow alone,
#' at \code{.probandArrow}'s angle, 32 long in a 50-pixel square, with
#' \dQuote{P} beside the proband's tail. Measured S56 at 500 pixels: 23 and
#' 16 dark pixels; a small circle with the arrow pointing at it showed 3
#' and 4.
#' @param proband \code{TRUE} for the proband's picture, \code{FALSE} for
#'   the consultand's.
#' @param arrow see \code{.probandArrow}.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.probandLegendImage <- function(proband = TRUE, arrow = .probandArrow) {
  angle <- arrow$angle * pi / 180.0
  ux <- cos(angle)
  uy <- -sin(angle)
  tipX <- if (proband) 46.0 else 40.0
  tipY <- 18.0
  tailX <- tipX - 32.0 * ux
  tailY <- tipY - 32.0 * uy
  baseX <- tipX - 10.0 * ux
  baseY <- tipY - 10.0 * uy
  svg <- paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    sprintf(paste0("<line x1='%.1f' y1='%.1f' x2='%.1f' y2='%.1f' ",
                   "stroke='black' stroke-width='3'/>"),
            tailX, tailY, baseX, baseY),
    sprintf("<polygon points='%.1f,%.1f %.1f,%.1f %.1f,%.1f' fill='black'/>",
            tipX, tipY, baseX - 5.0 * uy, baseY + 5.0 * ux,
            baseX + 5.0 * uy, baseY - 5.0 * ux),
    if (proband) {
      sprintf(paste0("<text x='%.1f' y='%.1f' font-family='arial' ",
                     "font-size='18' text-anchor='end' ",
                     "dominant-baseline='middle'>P</text>"),
              tailX - 2.0, tailY)
    },
    "</svg>"
  )
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}

#' Stop when an animal is marked both proband and consultand
#'
#' Phase G13 (R136). Pedixplorer refuses such a pedigree too (\dQuote{A is
#' consultand and proband}); an animal is drawn with one arrow, so it is
#' one or the other. \code{NA} is neither.
#' @param proband,consultand what \code{.readMarkColumn()} returns for each
#'   column, \code{NULL} when the pedigree has none.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, invisibly, when no animal is marked both.
#' @noRd
.checkProbandConsultand <- function(proband, consultand, caller) {
  if (is.null(proband) || is.null(consultand)) {
    return(invisible(NULL))
  }
  both <- names(proband)[!is.na(proband) & proband &
                           !is.na(consultand) & consultand]
  if (length(both) == 0L) {
    return(invisible(NULL))
  }
  stop(caller, "(): the columns 'proband' and 'consultand' are both TRUE ",
       "for ", .idsShown(both), ". Mark each animal as a proband or as a ",
       "consultand, not both.", call. = FALSE)
}
