# G17a, S74: what the app must show on small typed pedigrees, sex codes other than
# M/F/H/U, and the sample pedigree's counts. Three scripts, each run on its own
# from the repository root with renv's library. Not package code.

## ---- part 1: typed cases ----
suppressMessages(pkgload::load_all(".", quiet = TRUE))
base <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"),
                   dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
cases <- list(clean = base,
  rowless = within(base, sire[4] <- "s9"),
  duplicate = rbind(base, base[4, ]),
  maleDam = within(base, sex[2] <- "M"),
  ownParent = within(base, sire[3] <- "o1"),
  cycle = data.frame(id = c("a", "b"), sire = c("b", "a"), dam = NA, sex = c("M", "M")),
  oneAnimal = base[1, ],
  allMissingSex = within(base, sex <- NA))
step <- function(expr) {
  w <- character(0)
  v <- withCallingHandlers(tryCatch(expr, error = function(e) structure(conditionMessage(e), class = "err")),
    warning = function(x) { w <<- c(w, conditionMessage(x)); invokeRestart("muffleWarning") })
  list(v = v, w = w)
}
for (n in names(cases)) {
  p <- cases[[n]]
  g <- step(findGeneration(p$id, p$sire, p$dam)); p$gen <- if (inherits(g$v, "err")) NA else g$v
  L <- step(makePedigreeMatingLayout(p))
  D <- if (inherits(L$v, "err")) list(v = structure("not run", class = "err"), w = character(0)) else step(drawPedigreeDiagram(L$v))
  ck <- checkPedigree(p)
  cat(sprintf("%-13s gen=%s | genWarn=%s | layout=%s%s | draw=%s nodes=%s | checks=%s\n", n,
      paste(p$gen, collapse = ","), substr(paste(g$w, collapse = ";"), 1, 70),
      if (inherits(L$v, "err")) paste("ERROR:", substr(L$v, 1, 110)) else "ok",
      if (length(L$w)) paste(" WARN:", substr(paste(L$w, collapse = ";"), 1, 60)) else "",
      if (inherits(D$v, "err")) paste("ERROR:", substr(D$v, 1, 60)) else "ok",
      if (inherits(D$v, "err")) NA else nrow(D$v$x$nodes),
      paste(unique(ck$check), collapse = ",")))
}

## ---- part 2: sex codes ----
suppressMessages(pkgload::load_all(".", quiet = TRUE))
for (sx in list(c("M", "F", "F", "M"), c("m", "f", "f", "m"), c("male", "female", "female", "male"), c("1", "2", "2", "1"))) {
  p <- data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"), dam = c(NA, NA, "d1", "d1"), sex = sx)
  p$gen <- findGeneration(p$id, p$sire, p$dam)
  r <- tryCatch({ L <- makePedigreeMatingLayout(p); w <- drawPedigreeDiagram(L)
    sh <- w$x$nodes$shape[match(p$id, w$x$nodes$id)]; paste("draws; shapes:", paste(sh, collapse = ","))
  }, warning = function(w) paste("WARNING:", conditionMessage(w)), error = function(e) paste("ERROR:", conditionMessage(e)))
  ck <- checkPedigree(p)
  cat(paste(sx, collapse = ","), "->", substr(r, 1, 150), "| checkPedigree rows:", nrow(ck), paste(unique(ck$check), collapse = ","), "\n")
}

## ---- part 3: the sample ----
suppressMessages(pkgload::load_all(".", quiet = TRUE))
f <- system.file("extdata", "obfuscated_rhesus_mhc_ped.csv", package = "pedkindraw")
r <- utils::read.csv(f, colClasses = "character", na.strings = c("", "NA"))
cat("columns:", names(r), " rows:", nrow(r), "\n"); print(table(r$sex, useNA = "ifany"))
p <- r[, c("id", "sire", "dam", "sex")]
notes <- character(0)
p$gen <- findGeneration(p$id, p$sire, p$dam)
cat("file gen identical to findGeneration:", identical(as.integer(r$gen), as.integer(p$gen)), "\n")
w <- withCallingHandlers(drawPedigreeDiagram(makePedigreeMatingLayout(p)),
  warning = function(x) { notes <<- c(notes, conditionMessage(x)); invokeRestart("muffleWarning") },
  message = function(x) { notes <<- c(notes, conditionMessage(x)); invokeRestart("muffleMessage") })
ids <- w$x$nodes$id
cat("nodes:", length(ids), " real animal nodes:", sum(!startsWith(ids, "__")), " distinct:", length(unique(ids[!startsWith(ids, "__")])), " prefixes:", paste(names(table(sub("^(__[a-z]+_).*", "\\1", ids[startsWith(ids, "__")]))), collapse = ","), "\n")
cat("notes:", length(notes), "\n"); cat(substr(notes, 1, 120), sep = "\n")
cat("checks:", nrow(checkPedigree(p)), "\n")
