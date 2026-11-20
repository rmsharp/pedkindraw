## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133 and R135,
## pedkindraw S55). The copied makePedigreeMatingLayout() reads a column
## carrier with .readGenotyped() and marks each node with .carrierNodes();
## the copied .diagramAfterDrawing() runs .carrierDotHandler() after the
## deceased slash, and the copied drawPedigreeDiagram() adds a "Carrier"
## legend row, .carrierLegendImage(), when any animal is a carrier
## (DIVERGENCE.md).

#' The radius of a carrier's dot, as a fraction of its symbol's size
#'
#' Phase G13 (R135). A carrier's symbol has a black dot at its centre, its
#' radius this fraction of the node's \code{size} (6 of 25). Measured in
#' headless Chrome in a 500-pixel drawing (S55): 67 to 82 pixels change
#' around a carrier, the same in greyscale, on a white or a pink symbol,
#' where the sections of three conditions meet, and under the deceased
#' slash; a dot of Pedixplorer's size, 0.14, changes 22 to 29 and is nearly
#' hidden under the slash.
#' @noRd
.carrierDotRatio <- 0.24

#' Which nodes of a layout are a carrier's
#'
#' Phase G13 (R135). \code{TRUE} for the node of an animal whose
#' \code{carrier} value is \code{TRUE} and for each of its repeat-appearance
#' nodes; \code{FALSE} for every other node: an animal that is not a carrier
#' or not recorded, a mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param carrier what \code{.readGenotyped(ped, caller, "carrier")}
#'   returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return logical vector, as long as \code{nodeIds}, never \code{NA}.
#' @noRd
.carrierNodes <- function(nodeIds, carrier, dupIds, dupRealIds) {
  animalOf <- ifelse(nodeIds %in% dupIds, dupRealIds[match(nodeIds, dupIds)],
                     nodeIds)
  marked <- unname(carrier[animalOf])
  !is.na(marked) & marked
}

#' The afterDrawing handler that paints a carrier's dot
#'
#' Phase G13 (R135). visNetwork has no shape with a dot inside, so after
#' each draw this fills a black circle at the centre of every node whose
#' \code{carrier} field is \code{TRUE}, its radius \code{ratio} of the
#' node's own \code{size}. The text uses single quotes only: it travels
#' inside a JSON string.
#' @param ratio see \code{.carrierDotRatio}.
#' @return A JavaScript function, as a character string.
#' @noRd
.carrierDotHandler <- function(ratio = .carrierDotRatio) {
  sprintf(paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var ratio = %s;\n",
    "  var marked = net.body.data.nodes.get(",
    "{filter: function(n) { return n.carrier === true; }});\n",
    "  if (marked.length === 0) { return; }\n",
    "  ctx.save();\n",
    "  ctx.fillStyle = '#000000';\n",
    "  marked.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id);\n",
    "    ctx.beginPath();\n",
    "    ctx.arc(p.x, p.y, (n.size || 25) * ratio, 0, 2 * Math.PI);\n",
    "    ctx.fill();\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  ), format(ratio, digits = 4L))
}

#' The legend's picture of a carrier: a circle with the dot
#'
#' Phase G13 (R135). The legend is its own vis.Network and cannot run the
#' diagram's handler, so its \dQuote{Carrier} row is an inline SVG image, as
#' the \dQuote{Deceased} row is: that row's circle (radius 22 in a 50-pixel
#' square, white, outlined in the diagram's blue) with a black dot at its
#' centre, \code{ratio} of the radius.
#' @param ratio see \code{.carrierDotRatio}.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.carrierLegendImage <- function(ratio = .carrierDotRatio) {
  svg <- sprintf(paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    "<circle cx='25' cy='25' r='22' fill='white' stroke='#2B7CE9' ",
    "stroke-width='2'/>",
    "<circle cx='25' cy='25' r='%.1f' fill='black'/></svg>"
  ), 22.0 * ratio)
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}
