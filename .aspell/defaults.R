## The word list R's spelling check of DESCRIPTION uses for this package
## (utils:::aspell_package_description(), which CRAN's incoming check calls),
## beside R's own en_stats list. pedkindraw.rds holds the words Description's
## reference uses that no English dictionary has: IBD and the authors' names
## (pedkindraw S95, CRAN plan Phase 17l; Mark's pick "Sentence + package word
## list"). Rebuild it with saveRDS(c(...), ".aspell/pedkindraw.rds",
## version = 2).
description <- list(dictionaries = c("en_stats", "pedkindraw"))
