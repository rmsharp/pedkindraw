## A measuring prototype, not package code (pedkindraw S72, G16c's pre-RED measures, docs/planning/picture-files-plan.md section 15): measure2. Run from the repository root with G16C_OUT set to an output folder (measure2.R also G16C_LIB, a library holding pdftools).
.libPaths(c(Sys.getenv("G16C_LIB"), .libPaths()))
suppressMessages(library(pdftools))
ped <- utils::read.csv("tests/testthat/fixtures/obfuscated_rhesus_mhc_ped.csv", stringsAsFactors = FALSE)
for (f in list.files(Sys.getenv("G16C_OUT"), "\\.pdf$", full.names = TRUE)) {
  t0 <- proc.time()[["elapsed"]]
  d <- pdftools::pdf_data(f)[[1]]
  t <- proc.time()[["elapsed"]] - t0
  ids <- d[d$text %in% ped$id, ]
  cat(sprintf("%-40s pdftools pages %d | words %d | id words %d distinct %d | id box height pt median %.2f | %.2fs\n",
              basename(f), length(pdftools::pdf_info(f)$pages), nrow(d), nrow(ids),
              length(unique(ids$text)), median(ids$height), t))
}
cat("pdftools", as.character(packageVersion("pdftools")), " poppler:", pdftools::poppler_config()$version, "\n")
