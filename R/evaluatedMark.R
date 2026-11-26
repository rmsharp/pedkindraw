## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133 and R137,
## pedkindraw S57). The copied makePedigreeMatingLayout() reads a column
## evaluated with .readMarkColumn() and marks each node with .markedNodes()
## (R/markColumns.R); the copied .diagramAfterDrawing() runs
## .evaluatedStarHandler() last, and the copied drawPedigreeDiagram() adds
## the points of .evaluatedStarRoom() and an "Evaluated" legend row
## (.evaluatedLegendImage()) when an animal is evaluated (DIVERGENCE.md).
## S57's REFACTOR: .evaluatedStarRoom() builds its points with .markRoom()
## (R/markColumns.R), as .probandArrowRoom() does. S63 (plan Phase G14,
## R140): .evaluatedStarHandler() strokes the star 2 times the line width.
## S63's REFACTOR: written by .strokeWidthJs() (R/lineWidth.R).

#' Where the evaluated star is drawn
#'
#' Phase G13 (R137). An animal with a documented evaluation has a black
#' \dQuote{*} beside its symbol, drawn as three strokes through its center.
#' In units of the node's \code{size}, from the node's center (x to the
#' right, y down): the center of the \dQuote{*} (\code{x}, \code{y}), to the
#' right of the upper-right corner of the symbol's square, and its radius
#' \code{r}. Measured in headless Chrome in a 500-pixel drawing (S57): in 8
#' pedigrees it lies on no line, outline or deceased slash in the
#' rectilinear style, and 2 pixels on the direct style's line to a twin far
#' left of its mating; Pedixplorer's place, just outside the corner, lies 4
#' to 7 pixels on the end of every deceased square's slash.
#' @noRd
.evaluatedStar <- list(x = 1.6, y = -0.8, r = 0.28)

#' The afterDrawing handler that draws the evaluated star
#'
#' Phase G13 (R137). visNetwork has no mark beside a node, so after each draw
#' this strokes a black \dQuote{*}, three lines 2 pixels wide through one
#' center, beside every node whose \code{evaluated} field is \code{TRUE},
#' placed by \code{star} in units of the node's own \code{size}. The text
#' uses single quotes only: it travels inside a JSON string.
#' @param star see \code{.evaluatedStar}.
#' @param lineWidth the layout's line width (Phase G14, R140): the lines
#'   are stroked 2 times it, 2 at 1, as before.
#' @return A JavaScript function, as a character string.
#' @noRd
.evaluatedStarHandler <- function(star = .evaluatedStar, lineWidth = 1.0) {
  number <- function(x) format(x, digits = 4L)
  sprintf(paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var marked = net.body.data.nodes.get({filter: function(n) { ",
    "return n.evaluated === true; }});\n",
    "  if (marked.length === 0) { return; }\n",
    "  ctx.save();\n",
    "  ctx.strokeStyle = '#000000';\n",
    .strokeWidthJs(2.0, lineWidth),
    "  ctx.lineCap = 'round';\n",
    "  marked.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id);\n",
    "    var s = n.size || 25;\n",
    "    var cx = p.x + s * %s, cy = p.y + s * %s, r = s * %s;\n",
    "    for (var k = 0; k < 3; k++) {\n",
    "      var a = Math.PI / 2 + k * Math.PI / 3;\n",
    "      var dx = r * Math.cos(a), dy = r * Math.sin(a);\n",
    "      ctx.beginPath();\n",
    "      ctx.moveTo(cx - dx, cy - dy);\n",
    "      ctx.lineTo(cx + dx, cy + dy);\n",
    "      ctx.stroke();\n",
    "    }\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  ), number(star$x), number(star$y), number(star$r))
}

#' Invisible points that keep the evaluated stars inside the drawing
#'
#' Phase G13 (R137). vis.js fits its view to the nodes with a twentieth of
#' the range to spare on each side, so the \dQuote{*} of an animal at the
#' right edge could fall outside the canvas (2 pixels in a 500-pixel drawing
#' of six animals, measured S57). This adds one point per evaluated node, 2
#' units beyond the upper-right corner of the square that holds its
#' \dQuote{*}, invisible as the layout's routing points are (size 0, a
#' transparent fill and outline, no label), so vis.js's fit takes the stars
#' in. Each point's id is \code{"__eval_"} and its node's id, a prefix the
#' layout reserves (\code{.reservedIdPrefixes}). The points are built by
#' \code{.markRoom()} (S57's REFACTOR).
#' @param nodes the nodes to draw.
#' @param star see \code{.evaluatedStar}.
#' @return \code{nodes} with one more row per node whose \code{evaluated}
#'   field is \code{TRUE}; \code{nodes} itself when there is none.
#' @noRd
.evaluatedStarRoom <- function(nodes, star = .evaluatedStar) {
  .markRoom(nodes, .markField(nodes, "evaluated"), "__eval_",
            c(star$x + star$r, star$y - star$r), c(2.0, -2.0))
}

#' The legend's picture of an evaluated animal: the star
#'
#' Phase G13 (R137). The legend is its own vis.Network and cannot run the
#' diagram's handler, so its \dQuote{Evaluated} row is an inline SVG image,
#' as the \dQuote{Deceased} row is: the \dQuote{*} alone, three strokes 3
#' wide and 24 long through the center of a 50-pixel square. Measured S57 at
#' 500 pixels: 32 dark pixels, as many as the \dQuote{Deceased} picture's
#' 31; a small circle with the \dQuote{*} at its upper right showed 11.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.evaluatedLegendImage <- function() {
  strokes <- vapply(0L:2L, function(k) {
    a <- pi / 2.0 + k * pi / 3.0
    dx <- 12.0 * cos(a)
    dy <- 12.0 * sin(a)
    sprintf(paste0("<line x1='%.1f' y1='%.1f' x2='%.1f' y2='%.1f' ",
                   "stroke='black' stroke-width='3' ",
                   "stroke-linecap='round'/>"),
            25.0 - dx, 25.0 - dy, 25.0 + dx, 25.0 + dy)
  }, character(1L))
  svg <- paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    paste(strokes, collapse = ""), "</svg>"
  )
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}
