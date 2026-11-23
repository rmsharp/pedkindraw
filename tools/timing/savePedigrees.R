## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/savePedigrees.R at
## nprcgenekeepr commit 3e06730c5 and rewritten for pedkindraw's timing runs
## (docs/planning/pedkindraw-timing-plan.md sections 3.2 and 4.1, Phase
## 17h1). Changes: it writes the seven seed-1 colonies and the 375-animal
## sample from this package's inst/extdata, the files the timing cases read,
## and drops nprcgenekeepr's datasets, kinship2's sample.ped and the twins
## file (no computation case reads them); it needs no comparators' library
## (setupComparison.R); it checks each file's md5 against the study's and
## stops when one differs; --data= and --results= name other folders; the
## "committed" column goes (every file here is rebuilt, and git ignores it).
## Writes the timing runs' pedigree files, each read the same way by every
## package (comparisonFormats.R), byte for byte the files nprcgenekeepr's
## November study timed, and <results>/pedigreeFiles.csv (each file's rows,
## md5 and source). Run from the project root:
##   Rscript tools/timing/savePedigrees.R [--data=<dir>] [--results=<dir>]
## The defaults are data/ and results/ beside this script.
## The tests are in tests/test_savePedigrees.R.
# nolint start: undesirable_function_linter.
source(file.path("tools", "timing", "comparisonFormats.R"))
source(file.path("tools", "timing", "generateColonyPedigree.R"))
source(file.path("tools", "timing", "timingHarness.R"))
# nolint end
## The helpers come from the files sourced above, which lintr cannot see.
# nolint start: object_usage_linter.
here <- file.path("tools", "timing")
args <- commandArgs(trailingOnly = TRUE)
dataDir <- scriptOption(args, "data", file.path(here, "data"))
resultsDir <- scriptOption(args, "results", file.path(here, "results"))
dir.create(dataDir, showWarnings = FALSE, recursive = TRUE)

## The study's files, from nprcgenekeepr's
## tools/pedigreeComparison/results/pedigreeFiles.csv at 3e06730c5.
studyMd5 <- c(
  rhesus375.csv = "d045f56bf35c6b7d3fe260a356ac1058",
  synthetic_300.csv = "60816f400baaa21ab244b35e98783a7f",
  synthetic_1000.csv = "cc654ad1ef6ad476c0a91567250bb779",
  synthetic_2000.csv = "d4886a70f7eed9e3b3d3e21efadbf5a6",
  synthetic_3000.csv = "8c00af86e82d4b22327ff0c8b0048b28",
  synthetic_10000.csv = "1799ecd0995eac3e2f0c403764d45a2a",
  synthetic_30000.csv = "36944e72a100747344d9b96e5033ae20",
  synthetic_100000.csv = "b1d45f936d17b99e20a681608a45d3e6"
)

sampleFile <- file.path("inst", "extdata", "obfuscated_rhesus_mhc_ped.csv")
sample <- utils::read.csv(sampleFile, stringsAsFactors = FALSE)
sample <- sample[, c("id", "sire", "dam", "sex", "birth")]
sample$birth <- as.Date(sample$birth)
f <- file.path(dataDir, "rhesus375.csv")
files <- list(data.frame(
  file = basename(f), rows = nrow(sample),
  md5 = writeComparisonPedigree(sample, f), source = sampleFile
))
for (n in c(300L, 1000L, 2000L, 3000L, 10000L, 30000L, 100000L)) {
  f <- file.path(dataDir, sprintf("synthetic_%d.csv", n))
  files[[length(files) + 1L]] <- data.frame(
    file = basename(f), rows = n,
    md5 = writeComparisonPedigree(generateColonyPedigree(n, 1L), f),
    source = "generateColonyPedigree(n, seed = 1)"
  )
}
out <- do.call(rbind, files)
rownames(out) <- NULL
dir.create(resultsDir, showWarnings = FALSE, recursive = TRUE)
utils::write.csv(out, file.path(resultsDir, "pedigreeFiles.csv"),
  row.names = FALSE
)
print(out)
same <- out$md5 == studyMd5[out$file]
cat(sum(same), "of", nrow(out), "files identical to the study's\n")
if (!all(same)) {
  stop("not the study's file: ", toString(out$file[!same]), call. = FALSE)
}
# nolint end
