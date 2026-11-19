## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr. It serves the
## browser tests of test_conditionLegendImage.R (S28, plan R81),
## test_unknownAffected.R (S43, plan Phase G2) and test_conditionColors.R
## (S45, plan Phase G4), which read the colours vis.js draws in the diagram and
## in its legend after the legend's pictures load. S43's REFACTOR moved
## .waitForLegendPictures() here from test_conditionLegendImage.R, where S43's
## GREEN had a second copy; S45's REFACTOR moved .pixelReaderJs() here, the
## opening each of the three tests' readers had a copy of.

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

## A JavaScript expression, to evaluate in the page, that runs `body` with the
## drawing's network as `net`, its legend as `L`, and `read(nw, x, y)`, the
## colour as "r,g,b" that network `nw` (`net` or `L`) drew at the point x, y of
## its own coordinates. `body` ends by returning the result.
.pixelReaderJs <- function(body) {
  paste0(
    "(() => { const el = document.querySelector('.visNetwork'); ",
    "const w = HTMLWidgets.find('#' + el.id); const net = w.network; ",
    "const L = w.legend; ",
    "const read = (nw, x, y) => { const cv = nw.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; ",
    "const p = nw.canvasToDOM({x: x, y: y}); ",
    "const d = cv.getContext('2d').getImageData(Math.round(p.x * r), ",
    "Math.round(p.y * r), 1, 1).data; return [d[0], d[1], d[2]].join(','); }; ",
    body, " })()"
  )
}
