## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr. It serves the
## browser tests of test_conditionLegendImage.R (S28, plan R81) and
## test_unknownAffected.R (S43, plan Phase G2), which read the colours vis.js
## draws in the diagram and in its legend after the legend's pictures load.
## S43's REFACTOR moved it here from test_conditionLegendImage.R, where S43's
## GREEN had a second copy.

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
