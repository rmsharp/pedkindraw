## A measuring prototype, not package code (pedkindraw S70, G16b's pre-RED measures,
## docs/planning/picture-files-plan.md section 12): print an SVG file to a one-page
## PDF with headless Chrome, after two animation frames (a print straight after
## the load event can come out without the animals' shapes and ids, dragon 24).
##   Rscript printPdf.R in.svg out.pdf widthInches heightInches
args <- commandArgs(TRUE)
svg <- args[[1]]; pdf <- args[[2]]; wi <- as.numeric(args[[3]]); hi <- as.numeric(args[[4]])
t0 <- Sys.time()
chrome <- chromote::Chromote$new(); on.exit(chrome$close()); chrome$default_timeout <- 60
s <- chromote::ChromoteSession$new(parent = chrome, width = 1200L, height = 900L)
invisible(s$Page$enable())
invisible(s$Page$navigate(paste0("file://", normalizePath(svg))))
t1 <- Sys.time()
invisible(s$Runtime$evaluate("new Promise(function (r) { requestAnimationFrame(function () { requestAnimationFrame(r); }); })",
  awaitPromise = TRUE, timeout_ = 30))
t2 <- Sys.time()
r <- s$Page$printToPDF(paperWidth = wi, paperHeight = hi, marginTop = 0, marginBottom = 0,
  marginLeft = 0, marginRight = 0, printBackground = TRUE, pageRanges = "1")
raw <- jsonlite::base64_dec(r$data); writeBin(raw, pdf)
cat(sprintf("%s: %d bytes, load %.2fs, frames %.2fs, print %.2fs\n", basename(pdf), length(raw),
  as.numeric(difftime(t1, t0, units = "secs")), as.numeric(difftime(t2, t1, units = "secs")),
  as.numeric(difftime(Sys.time(), t2, units = "secs"))))
