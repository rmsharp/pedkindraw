# G17d, S77: how large an id is in the file the app would save at
# savePedigreeDiagram()'s own page (no width, height or dpi given: 10 inches
# wide, the widget's height, a PNG at 300 dpi), for a small view and for the
# whole sample, measured before the pre-RED picker (Learning 17). The SVG
# writes each id's font size in user units (1 unit is 1 CSS pixel, 1/96 inch
# of the page); in a PNG at 300 dpi an id is that times 300 / 96 pixels high.
# Also the same for a page given as 20 by 10 inches. Not package code. Run
# from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17dSizes.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))

sample <- utils::read.csv(.appSamplePath(), colClasses = "character",
                          na.strings = c("", "NA"))[, c("id", "sire", "dam",
                                                        "sex")]
sample$gen <- findGeneration(sample$id, sample$sire, sample$dam)
families <- findPedigreeNumber(sample$id, sample$sire, sample$dam)
fontOf <- function(svg, ids) {
  found <- regmatches(svg, gregexpr("<text [^>]*>[^<]*</text>", svg))[[1L]]
  texts <- sub("^<text [^>]*>([^<]*)</text>$", "\\1", found)
  sizes <- as.numeric(sub('.* font-size="([0-9.]+)".*', "\\1", found))
  stats::median(sizes[texts %in% ids])
}
measure <- function(label, ped, width = NULL, height = NULL) {
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  widget <- drawPedigreeDiagram(suppressWarnings(
    makePedigreeMatingLayout(ped)))
  file <- tempfile(fileext = ".svg")
  savePedigreeDiagram(widget, file, width = width, height = height)
  svg <- paste(readLines(file, warn = FALSE), collapse = "\n")
  size <- fontOf(svg, ped$id)
  box <- as.numeric(strsplit(sub('.*viewBox="([^"]+)".*', "\\1",
                                 substr(svg, 1L, 2000L)), " ")[[1L]])
  cat(sprintf(paste0("%-32s page %4.1f x %4.1f in; an id %.2f units: ",
                     "%.1f pt, %.1f px in a PNG at 300 dpi\n"),
              label, box[[3L]] / 96, box[[4L]] / 96, size, size * 0.75,
              size * 300 / 96))
}
measure("the sample, 375 animals", sample)
for (f in c(1L, 4L)) {
  rows <- sample[families == f, ]
  measure(sprintf("family %d, %d animals", f, nrow(rows)), rows)
}
measure("the sample, 20 x 10 in", sample, width = 20, height = 10)
