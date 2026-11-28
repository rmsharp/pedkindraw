## S103 (2026-11-27): the crossing counter behind the hand test's finding 3 (R175; the CRAN plan's H1).
## Counts crossings between solid lines of a layout (shared endpoints are joins), and
## tries the 6 row orders of the ED5PDV drawing's 3 founder couples. S103 ran it on the
## 1.0.0 tarball installed in a library of its own; with pkgload::load_all() in place of
## library() it runs on the working tree. Measured on the tarball: A 2 crossings; 3 of the
## 6 orders 0.
suppressPackageStartupMessages(library(pedkindraw))
## Solid lines only (the dashed duplicate connectors are drawn as arcs).
crossings <- function(layout) {
  n <- layout$nodes; e <- layout$edges
  e <- e[!vapply(e$dashes, isTRUE, logical(1L)), ]
  xy <- function(id) unlist(n[match(id, n$id), c("x", "y")])
  seg <- t(vapply(seq_len(nrow(e)), function(i) c(xy(e$from[i]), xy(e$to[i])), numeric(4)))
  ori <- function(a, b, c) sign((b[1]-a[1])*(c[2]-a[2]) - (b[2]-a[2])*(c[1]-a[1]))
  hits <- character(0)
  for (i in seq_len(nrow(seg) - 1L)) for (j in (i + 1L):nrow(seg)) {
    p1 <- seg[i, 1:2]; p2 <- seg[i, 3:4]; q1 <- seg[j, 1:2]; q2 <- seg[j, 3:4]
    ## shared endpoints are joins, not crossings
    if (any(abs(c(dist(rbind(p1, q1)), dist(rbind(p1, q2)), dist(rbind(p2, q1)), dist(rbind(p2, q2)))) < 1e-6)) next
    if (ori(p1, p2, q1) * ori(p1, p2, q2) < 0 && ori(q1, q2, p1) * ori(q1, q2, p2) < 0)
      hits <- c(hits, sprintf("%s-%s x %s-%s", e$from[i], e$to[i], e$from[j], e$to[j]))
  }
  hits
}
topRow <- function(layout) { n <- layout$nodes; r <- n[n$y == 0 & !startsWith(n$id, "__"), ]; paste(r$id[order(r$x)], collapse = " ") }
ped <- read.csv(system.file("extdata", "obfuscated_rhesus_mhc_ped.csv", package = "pedkindraw"), stringsAsFactors = FALSE)
small <- getProbandPedigree(ped, "ED5PDV")

cat("== A. as in the script (rows in the file's order)\n")
a <- makePedigreeMatingLayout(small); cat("top row:", topRow(a), "\n"); print(crossings(a))

cat("== B. WDBGPF's and RKBTHH's rows moved to the top\n")
b <- makePedigreeMatingLayout(small[c(match(c("WDBGPF", "RKBTHH"), small$id), which(!small$id %in% c("WDBGPF", "RKBTHH"))), ])
cat("top row:", topRow(b), "\n"); print(crossings(b))

cat("== C. every permutation of the 3 founder matings' rows: crossings each\n")
pairs <- list(c("5A6DFT", "I8ABQE"), c("WDBGPF", "RKBTHH"), c("MY1AEU", "ZK6NM2"))
perms <- list(1:3, c(1,3,2), c(2,1,3), c(2,3,1), c(3,1,2), c(3,2,1))
for (p in perms) {
  first <- unlist(pairs[p]); s <- small[c(match(first, small$id), which(!small$id %in% first)), ]
  l <- makePedigreeMatingLayout(s)
  cat(sprintf("%-40s %d crossing(s); top row: %s\n", paste(vapply(pairs[p], `[`, "", 1), collapse = ", "), length(crossings(l)), topRow(l)))
}
