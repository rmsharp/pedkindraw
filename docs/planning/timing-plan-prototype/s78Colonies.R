# 17g, S78: can pedkindraw rebuild the November study's synthetic colonies
# byte for byte? Not package code. Reads nprcgenekeepr's generator and its
# writer from the clone with git show (the clone is only read), builds the
# seven colonies of seed 1 into <dir>, and compares each file's md5 with the
# study's results/pedigreeFiles.csv. Run from the repository root with renv's
# library and RENV_PROJECT unset (Learning 5):
#   Rscript --no-init-file docs/planning/timing-plan-prototype/s78Colonies.R \
#     <dir> [nprcgenekeepr clone] [commit]
# S78 (clone at 3e06730c5): 7 of 7 identical, 300 to 100,000 animals, the
# largest built in 0.7 s.
args <- commandArgs(trailingOnly = TRUE)
dir <- args[[1L]]
clone <- if (length(args) >= 2L) args[[2L]] else file.path("..", "nprcgenekeepr")
commit <- if (length(args) >= 3L) args[[3L]] else "HEAD"
dir.create(dir, showWarnings = FALSE, recursive = TRUE)
fromClone <- function(path) {
  out <- system2("git", c("-C", shQuote(clone), "show",
                          shQuote(paste0(commit, ":", path))), stdout = TRUE)
  file <- file.path(dir, basename(path))
  writeLines(out, file)
  file
}
here <- "tools/pedigreeComparison/"
source(fromClone(paste0(here, "comparisonFormats.R"))) # nolint
source(fromClone(paste0(here, "generateColonyPedigree.R"))) # nolint
recorded <- utils::read.csv(fromClone(paste0(here, "results/pedigreeFiles.csv")),
                            stringsAsFactors = FALSE)
same <- 0L
for (n in c(300L, 1000L, 2000L, 3000L, 10000L, 30000L, 100000L)) {
  f <- sprintf("synthetic_%d.csv", n)
  t0 <- proc.time()[["elapsed"]]
  md5 <- writeComparisonPedigree(generateColonyPedigree(n, 1L),
                                 file.path(dir, f))
  ok <- identical(md5, recorded$md5[recorded$file == f])
  same <- same + ok
  cat(sprintf("%-22s md5 %s  identical: %s  (%.1f s)\n", f, md5, ok,
              proc.time()[["elapsed"]] - t0))
}
cat(same, "of 7 identical to the study's pedigreeFiles.csv\n")
