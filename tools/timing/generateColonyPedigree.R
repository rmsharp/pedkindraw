## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/generateColonyPedigree.R
## at nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 3.2 and 4.1, Phase 17h1). Changes: none; it rebuilds the study's
## seven seed-1 colonies byte for byte (tests/test_savePedigrees.R).
## A seeded synthetic primate colony for the Phase 1 comparison
## (docs/planning/standalone-pedigree-package-plan.md, Phase 1 step 3):
## overlapping generations, many half sibs, a share of animals of unknown
## parentage. Tests: tests/test_generateColonyPedigree.R.
##
## The colony is simulated a year at a time. Founders of breeding age start
## it. Each year an animal dies with probability 0.05 (always past 25), and
## breeders leave the breeding pool past 20. A female joins the pool at 4 and
## a male at 5 if there is room under the pool's cap, which grows with n;
## the rest never breed (sold). Each pool female gives birth with probability
## 0.7, to a sire drawn from the male pool by an uneven per-male weight, so a
## few males sire most offspring. Imports, importRate of each year's births,
## arrive at breeding age with unknown parents. Births fall in a 90-day
## season. Rows are in birth order of entry, so parents precede offspring.

generateColonyPedigree <- function(n, seed, importRate = 0.02) {
  if (!isSingleNumber(n) || n < 1.0 || n != floor(n)) {
    stop("n must be a single positive whole number", call. = FALSE)
  }
  if (!isSingleNumber(seed)) {
    stop("seed must be a single number", call. = FALSE)
  }
  if (!isSingleNumber(importRate) || importRate < 0.0 || importRate >= 1.0) {
    stop("importRate must be a single number in [0, 1)", call. = FALSE)
  }
  withColonySeed(seed, function() simulateColony(as.integer(n), importRate))
}

isSingleNumber <- function(x) {
  is.numeric(x) && length(x) == 1L && is.finite(x)
}

## Run f() from a fixed seed and give the caller back their random state.
withColonySeed <- function(seed, f) {
  env <- globalenv()
  had <- exists(".Random.seed", envir = env, inherits = FALSE)
  old <- if (had) get(".Random.seed", envir = env, inherits = FALSE)
  kind <- RNGkind()
  on.exit({
    if (had) {
      assign(".Random.seed", old, envir = env) # nolint: object_name_linter.
    } else {
      RNGkind(kind[1L], kind[2L], kind[3L])
      if (exists(".Random.seed", envir = env, inherits = FALSE)) {
        rm(".Random.seed", envir = env)
      }
    }
  })
  set.seed(seed,
    kind = "Mersenne-Twister", normal.kind = "Inversion",
    sample.kind = "Rejection"
  )
  f()
}

simulateColony <- function(n, importRate) {
  nFounders <- min(n, max(20L, as.integer(round(0.02 * n))))
  cap <- c(F = max(30L, as.integer(round(n / 20.0))))
  cap[["M"]] <- max(5L, as.integer(round(cap[["F"]] / 8.0)))
  minAge <- c(F = 4L, M = 5L)

  sex <- character(n)
  birthYear <- integer(n)
  birthDay <- integer(n)
  sireRow <- rep(NA_integer_, n)
  damRow <- rep(NA_integer_, n)
  alive <- logical(n)
  considered <- logical(n)
  inPool <- logical(n)
  weight <- numeric(n)

  k <- nFounders
  sex[seq_len(k)] <- sample(c("M", "F"), k, replace = TRUE)
  if (k >= 2L) sex[1L:2L] <- c("M", "F")
  birthYear[seq_len(k)] <- -sample(4L:12L, k, replace = TRUE)
  birthDay[seq_len(k)] <- sample(60L:150L, k, replace = TRUE)
  alive[seq_len(k)] <- TRUE
  weight[seq_len(k)] <- stats::rlnorm(k, 0.0, 1.5)

  year <- 0L
  while (k < n) {
    year <- year + 1L
    rows <- seq_len(k)
    age <- year - birthYear[rows]
    dies <- alive[rows] & (stats::runif(k) < 0.05 | age > 25L)
    alive[which(dies)] <- FALSE
    inPool[rows] <- inPool[rows] & alive[rows] & age <= 20L
    for (s in c("F", "M")) {
      cand <- which(alive[rows] & !considered[rows] & sex[rows] == s &
        age >= minAge[[s]] & age <= 20L)
      considered[cand] <- TRUE
      room <- cap[[s]] - sum(inPool[rows] & sex[rows] == s)
      if (room > 0L && length(cand) > 0L) {
        inPool[cand[sample.int(length(cand), min(room, length(cand)))]] <- TRUE
      }
    }
    dams <- which(inPool[rows] & sex[rows] == "F")
    sires <- which(inPool[rows] & sex[rows] == "M")
    mothers <- integer()
    fathers <- integer()
    if (length(dams) > 0L && length(sires) > 0L) {
      mothers <- dams[stats::runif(length(dams)) < 0.7]
      fathers <- sires[sample.int(length(sires), length(mothers),
        replace = TRUE, prob = weight[sires]
      )]
    }
    nBirths <- length(mothers)
    nImports <- stats::rbinom(1L, nBirths, importRate)
    missingSex <- c("M", "F")[c(length(sires) == 0L, length(dams) == 0L)]
    importSex <- c(
      missingSex,
      sample(c("M", "F"), nImports, replace = TRUE)
    )
    newSex <- c(sample(c("M", "F"), nBirths, replace = TRUE), importSex)
    newYear <- c(
      rep(year, nBirths),
      year - sample(4L:8L, length(importSex), replace = TRUE)
    )
    take <- seq_len(min(n - k, length(newSex)))
    if (length(take) == 0L) next
    at <- k + take
    sex[at] <- newSex[take]
    birthYear[at] <- newYear[take]
    birthDay[at] <- sample(60L:150L, length(take), replace = TRUE)
    sireRow[at] <- c(fathers, rep(NA_integer_, length(importSex)))[take]
    damRow[at] <- c(mothers, rep(NA_integer_, length(importSex)))[take]
    alive[at] <- TRUE
    weight[at] <- stats::rlnorm(length(take), 0.0, 1.5)
    k <- k + length(take)
  }

  id <- sprintf("S%06d", seq_len(n))
  data.frame(
    id = id,
    sire = id[sireRow],
    dam = id[damRow],
    sex = sex,
    birth = as.Date(sprintf("%d-01-01", 2000L + birthYear)) + birthDay,
    stringsAsFactors = FALSE
  )
}
