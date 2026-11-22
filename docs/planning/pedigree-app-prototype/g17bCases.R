# G17b, S75: each way of choosing the animals on S74's eight typed cases
# (plan section 11.4): what it returns, where it stops and whether it
# returns at all (Learning 19), each call under a 10 s limit. Not package
# code. Run from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17bCases.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
base <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"),
                   dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
cases <- list(clean = base,
  rowless = within(base, sire[4] <- "s9"),
  duplicate = rbind(base, base[4, ]),
  maleDam = within(base, sex[2] <- "M"),
  ownParent = within(base, sire[3] <- "o1"),
  cycle = data.frame(id = c("a", "b"), sire = c("b", "a"), dam = NA,
                     sex = c("M", "M")),
  oneAnimal = base[1, ],
  allMissingSex = within(base, sex <- NA))
limited <- function(expr) {
  setTimeLimit(elapsed = 10, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  r <- tryCatch(suppressWarnings(suppressMessages(expr)),
                error = function(e) {
                  m <- conditionMessage(e)
                  if (grepl("elapsed time limit", m)) "NEVER RETURNED (10 s)"
                  else paste("STOPS:", substr(m, 1L, 90L))
                })
  if (is.data.frame(r)) paste0(nrow(r), " rows: ", paste(r$id, collapse = ","))
  else if (is.character(r) && length(r) == 1L) r
  else paste(format(r), collapse = ",")
}
for (n in names(cases)) {
  p <- cases[[n]]
  cat(sprintf("== %s\n  F6 findPedigreeNumber: %s\n", n,
              limited(findPedigreeNumber(p$id, p$sire, p$dam))))
  focal <- p$id[[length(p$id)]]
  cat(sprintf("  F7 ancestors of %s: %s\n", focal,
              limited(trimPedigree(p, focal))))
  cat(sprintf("  F7 descendants of %s: %s\n", p$id[[1L]],
              limited(getDescendantPedigree(p, p$id[[1L]]))))
  cat(sprintf("  F8 near %s, k = 2: %s\n", focal,
              limited(getNearRelativePedigree(p, focal, 2))))
}
