## A measuring prototype, not package code (pedkindraw S72, G16c's pre-RED measures, docs/planning/picture-files-plan.md section 15): measure3. Run from the repository root with G16C_OUT set to an output folder (measure2.R also G16C_LIB, a library holding pdftools).
suppressMessages(library(chromote))
out <- Sys.getenv("G16C_OUT")
ped <- utils::read.csv("tests/testthat/fixtures/obfuscated_rhesus_mhc_ped.csv", stringsAsFactors = FALSE)
parent <- Chromote$new(browser = Chrome$new(args = unique(c(default_chrome_args(), "--disable-lcd-text"))))
parent$default_timeout <- 60
on.exit(parent$close(), add = TRUE)
s <- ChromoteSession$new(parent = parent, width = 1500L, height = 900L)
ev <- function(js, await = FALSE) {
  r <- s$Runtime$evaluate(js, returnByValue = TRUE, awaitPromise = await)
  if (!is.null(r$exceptionDetails)) stop(r$exceptionDetails$exception$description)
  r$result$value
}
svg <- file.path(out, "rhesus.svg")
s$Page$enable()
s$go_to(paste0("file://", svg), timeout_ = 30, delay = 0.5)
js <- "(() => { const ids = new Set(%s); const out = [];
  document.querySelectorAll('text').forEach(t => {
    if (t.getAttribute('fill') !== 'none' && ids.has(t.textContent)) {
      const r = t.getBoundingClientRect();
      out.push([t.textContent, r.left, r.top, r.right, r.bottom]); } });
  return out; })()"
boxes <- ev(sprintf(js, jsonlite::toJSON(ped$id)))
b <- data.frame(text = vapply(boxes, `[[`, "", 1L), x0 = vapply(boxes, function(z) as.numeric(z[[2]]), 0),
                y0 = vapply(boxes, function(z) as.numeric(z[[3]]), 0), x1 = vapply(boxes, function(z) as.numeric(z[[4]]), 0),
                y1 = vapply(boxes, function(z) as.numeric(z[[5]]), 0))
n <- nrow(b); hit <- logical(n)
for (i in seq_len(n - 1L)) { j <- (i + 1L):n
  w <- pmin(b$x1[i], b$x1[j]) - pmax(b$x0[i], b$x0[j]); h <- pmin(b$y1[i], b$y1[j]) - pmax(b$y0[i], b$y0[j])
  bad <- w > 0 & h > 0; if (any(bad)) { hit[i] <- TRUE; hit[j[bad]] <- TRUE } }
cat(sprintf("SVG in Chrome: id texts %d, distinct %d, id box height px median %.2f, width median %.2f; overlapping another id box: %d\n",
            n, length(unique(b$text)), median(b$y1 - b$y0), median(b$x1 - b$x0), sum(hit)))
## the ids in the 300 dpi PNG: the PNG against the same SVG with the 545 ids (and halos) removed
txt <- paste(readLines(svg, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
stripped <- gsub('<text [^>]*font-size="0\\.893"[^>]*>[^<]*</text>\n?', "", txt)
cat("text elements before/after strip:", lengths(regmatches(txt, gregexpr("<text ", txt))),
    lengths(regmatches(stripped, gregexpr("<text ", stripped))), "\n")
f2 <- file.path(out, "rhesus-noids.svg"); writeLines(stripped, f2, useBytes = TRUE)
s$go_to(paste0("file://", f2), timeout_ = 30, delay = 0.5)
shot <- function(scale) s$Page$captureScreenshot(format = "png",
  clip = list(x = 0, y = 0, width = 1344, height = 672, scale = scale))$data
for (dpi in c(96, 300)) {
  a <- shot(dpi / 96)
  s$go_to(paste0("file://", svg), timeout_ = 30, delay = 0.5)
  b2 <- shot(dpi / 96)
  s$go_to("about:blank", timeout_ = 30)
  px <- paste0("const load = s => new Promise((ok, no) => { const i = new Image(); i.onload = () => ok(i); i.onerror = no; i.src = 'data:image/png;base64,' + s; });",
    "const pixels = i => { const c = document.createElement('canvas'); c.width = i.width; c.height = i.height; const x = c.getContext('2d'); x.drawImage(i, 0, 0); return x.getImageData(0, 0, c.width, c.height); };")
  r <- ev(paste0("(async () => { ", px, "const a = pixels(await load('", a, "')); const b = pixels(await load('", b2, "'));",
    "let ink = 0, differ = 0; for (let k = 0; k < a.data.length; k += 4) { const sa = a.data[k]+a.data[k+1]+a.data[k+2], sb = b.data[k]+b.data[k+1]+b.data[k+2];",
    "if (sa < 740 || sb < 740) { ink++; if (Math.abs(a.data[k]-b.data[k]) > 100 || Math.abs(a.data[k+1]-b.data[k+1]) > 100 || Math.abs(a.data[k+2]-b.data[k+2]) > 100) differ++; } }",
    "return {w: a.width, h: a.height, ink: ink, differ: differ}; })()"), TRUE)
  cat(sprintf("at %d dpi (%d x %d px): ink pixels %d, differing between the drawing with and without its ids: %d; an id's font height = %.2f px\n",
              dpi, r$w, r$h, r$ink, r$differ, 0.893 * dpi / 96))
  s$go_to(paste0("file://", f2), timeout_ = 30, delay = 0.5)
}
