# G17c, S76: a twins file in the app (F13) and the line style (F12), measured
# before the pre-RED picker (Learning 17). Twins: checkTwinRelations() on the
# sample's own twins file (inst/extdata) and on typed problem files; what the
# layout does when a view leaves out one or both animals of a pair; which of
# the sample's families hold each pair; kinship2's and Pedixplorer's codes.
# Lines: whether the layout's edgeStyle and the drawing's must agree. Not
# package code. Run from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17cTwins.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
four <- c(id = "id", sire = "sire", dam = "dam", sex = "sex")
said <- function(expr) {
  r <- tryCatch(suppressWarnings(suppressMessages(expr)),
                error = function(e) e)
  if (inherits(r, "error")) {
    paste("STOPS:", substr(gsub("\\s+", " ", conditionMessage(r)), 1L, 140L))
  } else {
    "returns"
  }
}
withGen <- function(ped) {
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}
sample <- .appAddParents(.appPedigree(
  .readAppFile(.appSamplePath())$data, four))$ped
twins <- .readAppFile(system.file("extdata",
                                  "obfuscated_rhesus_mhc_twin_relations.csv",
                                  package = "pedkindraw"))$data
cat("## The sample's twins file, read as the app reads a file\n")
print(twins)
cat("checkTwinRelations(sample, twins):", said(checkTwinRelations(sample,
                                                                  twins)), "\n")
start <- proc.time()[["elapsed"]]
whole <- suppressWarnings(suppressMessages(
  makePedigreeMatingLayout(withGen(sample), twinRelations = twins)))
cat(sprintf("the whole sample's layout with twins: %.1f s, %d twin edges\n",
            proc.time()[["elapsed"]] - start,
            sum(!is.na(whole$edges$label) & nzchar(whole$edges$label))))
families <- findPedigreeNumber(sample$id, sample$sire, sample$dam)
cat("each pair's families:\n")
for (i in seq_len(nrow(twins))) {
  cat(sprintf("  %s (%s) and %s (%s), %s\n", twins$id1[[i]],
              families[match(twins$id1[[i]], sample$id)], twins$id2[[i]],
              families[match(twins$id2[[i]], sample$id)], twins$code[[i]]))
}
cat("\n## A view that leaves out animals of a pair: the layout with every pair\n")
for (f in sort(unique(families[match(c(twins$id1, twins$id2), sample$id)]))) {
  view <- sample[families == f, ]
  inView <- (twins$id1 %in% view$id) + (twins$id2 %in% view$id)
  cat(sprintf("  family %s (%d animals; pairs with both, one, none: %d, %d, %d): %s\n",
              f, nrow(view), sum(inView == 2L), sum(inView == 1L),
              sum(inView == 0L),
              said(makePedigreeMatingLayout(withGen(view),
                                            twinRelations = twins))))
  kept <- twins[inView == 2L, ]
  cat(sprintf("    with only the pairs both of whose animals are drawn: %s\n",
              said(makePedigreeMatingLayout(withGen(view), twinRelations =
                                              if (nrow(kept)) kept else NULL))))
}
cat("\n## Typed twins files: what checkTwinRelations() says\n")
ped <- data.frame(id = c("s1", "d1", "o1", "o2", "o3"),
                  sire = c(NA, NA, "s1", "s1", "s1"),
                  dam = c(NA, NA, "d1", "d1", "d1"),
                  sex = c("M", "F", "F", "F", "M"))
files <- list(
  good = data.frame(id1 = "o1", id2 = "o2", code = "MZ twin"),
  codeMZ = data.frame(id1 = "o1", id2 = "o2", code = "MZ"),
  codeLower = data.frame(id1 = "o1", id2 = "o2", code = "mz twin"),
  kinship2Number = data.frame(id1 = "o1", id2 = "o2", code = "1"),
  missingColumn = data.frame(id1 = "o1", id2 = "o2"),
  otherNames = data.frame(ego1 = "o1", ego2 = "o2", code = "MZ twin"),
  unknownId = data.frame(id1 = "o1", id2 = "x9", code = "DZ twin"),
  samePair = data.frame(id1 = "o1", id2 = "o1", code = "DZ twin"),
  mzSexDiffers = data.frame(id1 = "o1", id2 = "o3", code = "MZ twin"),
  dzNoParents = data.frame(id1 = "s1", id2 = "d1", code = "DZ twin"),
  twoProblems = data.frame(id1 = c("o1", "o1"), id2 = c("x9", "o3"),
                           code = c("DZ twin", "MZ twin")),
  noRows = data.frame(id1 = character(), id2 = character(),
                      code = character()),
  emptyCell = data.frame(id1 = "o1", id2 = NA, code = "DZ twin")
)
for (n in names(files)) {
  path <- tempfile(fileext = ".csv")
  utils::write.csv(files[[n]], path, row.names = FALSE, na = "")
  read <- .readAppFile(path)
  unlink(path)
  cat(sprintf("  %-15s check: %s\n", n,
              said(checkTwinRelations(ped, read$data))))
  if (n %in% c("good", "noRows")) {
    cat(sprintf("  %-15s layout: %s\n", "",
                said(makePedigreeMatingLayout(withGen(ped),
                                              twinRelations = read$data))))
  }
}
cat("\n## Lines (F12): layout and drawing styles, on .appFour() plus a mate\n")
lines <- withGen(data.frame(
  id = c("s1", "d1", "d2", "o1", "o2", "o3"),
  sire = c(NA, NA, NA, "s1", "s1", "s1"), dam = c(NA, NA, NA, "d1", "d1", "d2"),
  sex = c("M", "F", "F", "F", "M", "M")))
rect <- makePedigreeMatingLayout(lines, edgeStyle = "rectilinear")
direct <- makePedigreeMatingLayout(lines, edgeStyle = "direct")
cat("  layouts identical:", identical(rect, direct), "; nodes:",
    nrow(rect$nodes), "and", nrow(direct$nodes), "; edges:",
    nrow(rect$edges), "and", nrow(direct$edges), "\n")
for (ls in c("rectilinear", "direct")) {
  for (ds in c("rectilinear", "direct")) {
    w <- drawPedigreeDiagram(if (ls == "direct") direct else rect,
                             edgeStyle = ds)
    cat(sprintf("  layout %-11s drawing %-11s: %d nodes, %d edges, %s\n", ls,
                ds, nrow(w$x$nodes), nrow(w$x$edges),
                substr(digest::digest(w$x), 1L, 8L)))
  }
}
