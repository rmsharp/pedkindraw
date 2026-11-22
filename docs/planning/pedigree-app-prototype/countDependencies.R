# Hard dependencies (Depends, Imports, LinkingTo), recursive, base packages left out,
# read from the installed packages (the comparison study's section 11 method).
ip <- installed.packages()
base <- rownames(ip)[ip[, "Priority"] %in% "base"]
hard <- function(pkgs) {
  out <- tools::package_dependencies(pkgs, db = ip, which = c("Depends", "Imports", "LinkingTo"),
                                     recursive = TRUE)
  setdiff(unique(c(pkgs, unlist(out))), c(base, "R"))
}
imports <- c("data.table", "htmlwidgets", "Matrix", "quadprog", "visNetwork")
now <- hard(imports)
cat("pedkindraw today, outside packages:", length(now), "\n")
for (extra in list("shiny", c("shiny", "DT"), c("shiny", "bslib"), "DT", "readxl", "shinytest2", "chromote")) {
  if (!all(extra %in% rownames(ip))) { cat(paste(extra, collapse = "+"), ": not installed\n"); next }
  add <- setdiff(hard(c(imports, extra)), now)
  cat(sprintf("+ %-14s adds %2d: %s\n", paste(extra, collapse = "+"), length(add), paste(sort(add), collapse = " ")))
}
for (p in c("shiny", "DT", "bslib", "readxl", "shinytest2", "chromote", "visNetwork", "htmlwidgets")) {
  v <- if (p %in% rownames(ip)) ip[p, "Version"] else "absent"
  cat(p, v, "\n")
}

# shinytest2 is not installed: count what it would add from the dated repository's metadata.
ap <- available.packages(repos = "https://packagemanager.posit.co/cran/2026-10-31")
have <- union(rownames(ip), base)
st <- tools::package_dependencies("shinytest2", db = ap, which = c("Depends", "Imports", "LinkingTo"), recursive = TRUE)[[1]]
st <- setdiff(c("shinytest2", st), c(base, "R"))
cat("shinytest2", ap["shinytest2", "Version"], "hard deps (incl. itself):", length(st), "\n")
cat("  not in renv's library now:", paste(sort(setdiff(st, rownames(ip))), collapse = " "), "\n")
cat("  beyond pedkindraw's 32 + shiny's 11 + chromote's:", paste(sort(setdiff(st, union(hard(c(imports, "shiny", "chromote")), character()))), collapse = " "), "\n")
cat("callr installed:", "callr" %in% rownames(ip), " processx:", "processx" %in% rownames(ip), "\n")
