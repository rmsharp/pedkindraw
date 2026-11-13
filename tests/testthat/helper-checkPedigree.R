## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 13,
## rulings R49-R51, pedkindraw S17). It serves test_checkPedigree.R: seeded
## random pedigrees with problems put in, a slow checker written straight from
## each check's definition, and kinship2's pedigree() on the same data (run only
## where kinship2 is installed, R7, R28).

## A pedigree without problems: n animals, the first 30 percent founders, each
## later animal with a sire and a dam drawn from the animals before it.
checkPedigreeClean <- function(n) {
  nFounders <- max(2L, round(n * 0.3))
  id <- paste0("A", seq_len(n))
  sex <- c(rep(c("M", "F"), length.out = nFounders),
           sample(c("M", "F"), n - nFounders, replace = TRUE))
  sire <- rep(NA_character_, n)
  dam <- rep(NA_character_, n)
  for (i in seq_len(n)[-seq_len(nFounders)]) {
    before <- seq_len(i - 1L)
    males <- before[sex[before] == "M"]
    females <- before[sex[before] == "F"]
    if (length(males) > 0L && length(females) > 0L) {
      sire[i] <- id[males[sample.int(length(males), 1L)]]
      dam[i] <- id[females[sample.int(length(females), 1L)]]
    }
  }
  data.frame(id = id, sire = sire, dam = dam, sex = sex,
             stringsAsFactors = FALSE)
}

## One of x at random, NA when x is empty.
checkPedigreePick <- function(x) {
  if (length(x) == 0L) {
    return(NA)
  }
  x[sample.int(length(x), 1L)]
}

## Every ancestor of the animals in front, following parents with a row.
checkPedigreeAncestors <- function(p, front) {
  found <- character(0L)
  repeat {
    rows <- p$id %in% front
    nxt <- setdiff(unique(c(p$sire[rows], p$dam[rows])), c(found, NA))
    if (length(nxt) == 0L) {
      return(found)
    }
    found <- c(found, nxt)
    front <- nxt
  }
}

## Put one problem of the given kind into p (some draws change nothing: a
## cycle needs an animal with a descendant).
checkPedigreeInject <- function(p, kind) {
  pick <- checkPedigreePick
  kids <- which(!is.na(p$sire) & !is.na(p$dam))
  founders <- which(is.na(p$sire) & is.na(p$dam))
  sires <- unique(p$sire[!is.na(p$sire)])
  dams <- unique(p$dam[!is.na(p$dam)])
  switch(kind,
    duplicateIds = {
      i <- sample.int(nrow(p), 2L)
      p$id[max(i)] <- p$id[min(i)]
    },
    ownParent = {
      x <- pick(kids)
      if (!is.na(x)) {
        if (p$sex[x] == "M") p$sire[x] <- p$id[x] else p$dam[x] <- p$id[x]
      }
    },
    cycle = {
      x <- pick(kids)
      if (!is.na(x)) {
        below <- vapply(p$id, function(y) {
          p$id[x] %in% checkPedigreeAncestors(p, y)
        }, logical(1L))
        d <- pick(p$id[below])
        if (!is.na(d)) {
          if (p$sex[p$id == d][1L] == "M") p$sire[x] <- d else p$dam[x] <- d
        }
      }
    },
    rowlessParents = {
      x <- pick(kids)
      if (!is.na(x)) p$sire[x] <- "Z99"
    },
    missingParentCodes = {
      f <- pick(founders)
      code <- pick(c("0", "", "NA", " "))
      p$sire[f] <- code
      p$dam[f] <- code
    },
    maleDams = p$sex[p$id == pick(dams)] <- "M",
    femaleSires = p$sex[p$id == pick(sires)] <- "F",
    unknownSexParents = p$sex[p$id == pick(c(sires, dams))] <- pick(c("U", NA)),
    hermaphroditeParent = p$sex[p$id == pick(c(sires, dams))] <- "H",
    sireAndDam = {
      s <- pick(sires)
      x <- pick(kids)
      if (!is.na(x) && p$id[x] != s) p$dam[x] <- s
    },
    oneParent = {
      x <- pick(kids)
      if (!is.na(x)) p$dam[x] <- NA
    },
    missingIds = p$id[sample.int(nrow(p), 1L)] <- pick(c(NA, "", " ")),
    sexCodes = p$sex[sample.int(nrow(p), 1L)] <- "male"
  )
  p
}

checkPedigreeKinds <- c(
  "duplicateIds", "ownParent", "cycle", "rowlessParents",
  "missingParentCodes", "maleDams", "femaleSires", "unknownSexParents",
  "hermaphroditeParent", "sireAndDam", "oneParent", "missingIds", "sexCodes"
)

## A seeded random pedigree of 6 to 40 animals with one or two problems put
## in; every seventh seed has none.
checkPedigreeRandomCase <- function(seed) {
  withr::with_seed(seed, {
    p <- checkPedigreeClean(sample(6L:40L, 1L))
    kinds <- if (seed %% 7L == 0L) {
      character(0L)
    } else {
      sample(checkPedigreeKinds, sample(1L:2L, 1L))
    }
    for (kind in kinds) {
      p <- checkPedigreeInject(p, kind)
    }
    list(ped = p, kinds = kinds)
  })
}

## The slow checker: each check from its definition (R50), one animal or value
## at a time. Returns the check and id of every row checkPedigree() should
## give, sorted the same way, without the detail.
checkPedigreeSlow <- function(ped) {
  id <- as.character(ped$id)
  sire <- as.character(ped$sire)
  dam <- as.character(ped$dam)
  sex <- if ("sex" %in% names(ped)) as.character(ped$sex) else NULL
  blank <- function(x) !is.na(x) && trimws(x) == ""
  missingId <- function(x) is.na(x) || blank(x)
  ids <- unique(id[!vapply(id, missingId, logical(1L))])
  isCode <- function(x) {
    !is.na(x) && !(x %in% ids) && (blank(x) || x %in% c("0", "NA"))
  }
  parentsOf <- function(x) {
    rows <- which(id == x)
    p <- c(sire[rows], dam[rows])
    p[!is.na(p) & p %in% ids & p != x]
  }
  ownAncestor <- function(x) {
    seen <- character(0L)
    front <- parentsOf(x)
    while (length(front) > 0L) {
      if (x %in% front) {
        return(TRUE)
      }
      seen <- c(seen, front)
      front <- setdiff(unique(unlist(lapply(front, parentsOf))), seen)
    }
    FALSE
  }
  sortIds <- function(x) sort(unique(x), method = "radix")
  sires <- unique(sire[!is.na(sire)])
  dams <- unique(dam[!is.na(dam)])
  parents <- unique(c(sires, dams))
  sexOf <- function(x) sex[match(x, id)]
  hasRow <- function(x) x %in% ids
  found <- list(
    missingIds = id[vapply(id, missingId, logical(1L))],
    duplicateIds = sortIds(ids[vapply(ids, function(x) {
      sum(id == x, na.rm = TRUE) > 1L
    }, logical(1L))]),
    ownParent = sortIds(ids[vapply(ids, function(x) {
      rows <- which(id == x)
      any(sire[rows] %in% x | dam[rows] %in% x)
    }, logical(1L))]),
    cycle = sortIds(ids[vapply(ids, ownAncestor, logical(1L))]),
    rowlessParents = sortIds(parents[!hasRow(parents) &
      !vapply(parents, isCode, logical(1L))]),
    missingParentCodes = sortIds(parents[vapply(parents, isCode,
                                                logical(1L))])
  )
  if (!is.null(sex)) {
    rowParents <- function(x) x[hasRow(x)]
    found$maleDams <- sortIds(Filter(function(x) {
      identical(sexOf(x), "M")
    }, rowParents(dams)))
    found$femaleSires <- sortIds(Filter(function(x) {
      identical(sexOf(x), "F")
    }, rowParents(sires)))
    found$unknownSexParents <- sortIds(Filter(function(x) {
      is.na(sexOf(x)) || sexOf(x) == "U"
    }, rowParents(parents)))
  }
  notCodes <- function(x) x[!vapply(x, isCode, logical(1L))]
  found$sireAndDam <- sortIds(intersect(notCodes(sires), notCodes(dams)))
  if (!is.null(sex)) {
    found$sexCodes <- id[!is.na(sex) & !(sex %in% c("M", "F", "H", "U"))]
  }
  data.frame(
    check = rep(names(found), lengths(found)),
    id = unlist(found, use.names = FALSE),
    stringsAsFactors = FALSE
  )
}

## kinship2's pedigree() on the same data (sex M 1, F 2, anything else 3),
## under a 10 s time limit: "accepted", or which problem it stopped on.
kinship2CheckAnswer <- function(ped) {
  sexCode <- ifelse(ped$sex %in% "M", 1L, ifelse(ped$sex %in% "F", 2L, 3L))
  setTimeLimit(elapsed = 10, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf))
  message <- tryCatch({
    suppressWarnings(kinship2::pedigree(
      id = ped$id, dadid = ped$sire, momid = ped$dam, sex = sexCode
    ))
    "accepted"
  }, error = function(e) conditionMessage(e))
  if (identical(message, "accepted")) {
    return(message)
  }
  patterns <- c(
    duplicateIds = "^Duplicate subject id",
    notFemale = "^Id not female, but is a mother",
    notMale = "^Id not male, but is a father",
    notFound = "^Value of '(dadid|momid)' not found",
    missingIds = "^(Missing value for the id|A blank or empty string)",
    oneParent = "^Subjects must have both a father and mother"
  )
  hit <- names(patterns)[vapply(patterns, grepl, logical(1L), x = message)]
  if (length(hit) == 0L) paste("other:", message) else hit[1L]
}
