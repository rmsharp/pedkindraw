# G17c, S76: what the app does today with each value a CSV file can hold in a
# condition or mark column (plan section 7, G17c; Learning 17). The app reads
# every column as text (.readAppFile(), colClasses = "character"), so a value
# reaches makePedigreeMatingLayout() as text. For each column and each pair of
# values (the first for o1, the second for o2 and s1, an empty cell for d1),
# the file is written and read as the app reads it, and the layout is made
# as .appDraw() makes it; printed: where it stops, or what o1, o2 and d1 are
# drawn as. Then the same columns given as R values (runPedigreeApp(ped)
# keeps a data frame's types). Not package code. Run from the repository
# root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17cValues.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
base <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"),
                   dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
four <- c(id = "id", sire = "sire", dam = "dam", sex = "sex")
pairs <- list(c("TRUE", "FALSE"), c("true", "false"), c("T", "F"),
              c("1", "0"), c("Y", "N"), c("yes", "no"), c("2", "1"),
              c("affected", "unaffected"), c("2.5", "0.3"),
              c("DECEASED", "ALIVE"), c("deceased", "alive"),
              c("dead", "alive"), c("infertile", "fertile"),
              c("SAB", "no"))
## What each column's mark is in the layout's nodes.
readOut <- list(
  affected = function(n) n$color.background,
  genotyped = function(n) as.character(n$borderWidth),
  carrier = function(n) as.character(n$carrier),
  proband = function(n) as.character(n$proband),
  evaluated = function(n) as.character(n$evaluated),
  fertility = function(n) n$fertility,
  miscarriage = function(n) n$miscarriage,
  status = function(n) as.character(n$deceased)
)
asTheAppReads <- function(ped) {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path))
  utils::write.csv(ped, path, row.names = FALSE, na = "")
  .appAddParents(.appPedigree(.readAppFile(path)$data, four))$ped
}
layoutOf <- function(ped, thresholds = NULL) {
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  tryCatch(suppressWarnings(suppressMessages(
    makePedigreeMatingLayout(ped, conditionThresholds = thresholds))),
    error = function(e) e)
}
show <- function(column, layout) {
  if (inherits(layout, "error")) {
    return(paste("STOPS:", substr(gsub("\\s+", " ", conditionMessage(layout)),
                                  1L, 150L)))
  }
  n <- layout$nodes
  value <- readOut[[column]](n)
  paste(sprintf("%s=%s", c("o1", "o2", "d1"),
                value[match(c("o1", "o2", "d1"), n$id)]), collapse = " ")
}
cat("## From a CSV file, as the app reads it today\n")
for (column in names(readOut)) {
  cat(sprintf("== %s\n", column))
  for (p in pairs) {
    ped <- base
    ped[[column]] <- c(p[[2L]], NA, p[[1L]], p[[2L]])
    cat(sprintf("  %-22s %s\n", paste0(p[[1L]], "/", p[[2L]]),
                show(column, layoutOf(asTheAppReads(ped)))))
  }
}
cat("\n## affected 2.5/0.3 with conditionThresholds c(affected = \"> 1\")\n")
ped <- base
ped$affected <- c("0.3", NA, "2.5", "0.3")
cat("  from the CSV:   ", show("affected", layoutOf(asTheAppReads(ped),
                                                    c(affected = "> 1"))), "\n")
ped$affected <- c(0.3, NA, 2.5, 0.3)
cat("  as R numbers:   ", show("affected", layoutOf(ped, c(affected = "> 1"))),
    "\n")
cat("\n## Given as R values (runPedigreeApp(ped) keeps a data frame's types)\n")
rValues <- list(logical = c(FALSE, NA, TRUE, FALSE),
                numbers01 = c(0, NA, 1, 0), plink21 = c(1, NA, 2, 1))
for (column in setdiff(names(readOut), c("fertility", "miscarriage",
                                         "status"))) {
  for (kind in names(rValues)) {
    ped <- base
    ped[[column]] <- rValues[[kind]]
    cat(sprintf("  %-10s %-10s %s\n", column, kind,
                show(column, layoutOf(ped))))
  }
}
cat("\n## A column whose name is not lower case: is it read by name?\n")
for (column in c("Affected", "Genotyped", "affected_diabetes", "affected2",
                 "Status")) {
  ped <- base
  ped[[column]] <- c("FALSE", NA, "TRUE", "FALSE")
  layout <- layoutOf(asTheAppReads(ped))
  cat(sprintf("  %-18s conditions drawn: %s; a genotyped outline: %s\n",
              column, toString(layout$conditions$label),
              !is.null(layout$nodes$borderWidth)))
}
