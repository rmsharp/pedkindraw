## A measuring prototype, not package code (pedkindraw S70, G16b's pre-RED measures,
## docs/planning/picture-files-plan.md section 12): a PNG of an SVG file's page at a
## dpi, a screenshot of the SVG document clipped to the page at scale = dpi / 96.
##   Rscript savePng.R in.svg out.png widthInches heightInches dpi
args <- commandArgs(TRUE)
svg <- args[[1]]; png <- args[[2]]; wi <- as.numeric(args[[3]]); hi <- as.numeric(args[[4]]); dpi <- as.numeric(args[[5]])
t0 <- Sys.time()
chrome <- chromote::Chromote$new(); on.exit(chrome$close()); chrome$default_timeout <- 60
s <- chromote::ChromoteSession$new(parent = chrome, width = as.integer(ceiling(wi * 96)) + 50L, height = as.integer(ceiling(hi * 96)) + 50L)
invisible(s$Page$enable())
invisible(s$Page$navigate(paste0("file://", normalizePath(svg))))
t1 <- Sys.time()
invisible(s$Runtime$evaluate("new Promise(function (r) { requestAnimationFrame(function () { requestAnimationFrame(r); }); })",
  awaitPromise = TRUE, timeout_ = 30))
t2 <- Sys.time()
r <- tryCatch(s$Page$captureScreenshot(format = "png", clip = list(x = 0, y = 0, width = wi * 96, height = hi * 96, scale = dpi / 96)),
  error = function(e) { cat("ERROR:", conditionMessage(e), "\n"); NULL })
if (!is.null(r)) {
  raw <- jsonlite::base64_dec(r$data); writeBin(raw, png)
  cat(sprintf("%s: %d bytes, load %.2fs, frames %.2fs, shot %.2fs\n", basename(png), length(raw),
    as.numeric(difftime(t1, t0, units = "secs")), as.numeric(difftime(t2, t1, units = "secs")),
    as.numeric(difftime(Sys.time(), t2, units = "secs"))))
}
