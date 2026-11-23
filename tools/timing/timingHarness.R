## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/pedigreeComparison/timingHarness.R at
## nprcgenekeepr commit 3e06730c5 (docs/planning/pedkindraw-timing-plan.md
## sections 4.1 and 5.5, Phase 17h1). Changes: useTimingLibraries() puts
## pedkindraw's scratch library (PKD_LIB) first and the path found next, with
## no comparators' library (CMP_LIB: kinship2 and Pedixplorer are in renv's
## library); the TIMING line ends with the folder pedkindraw was loaded from
## (reportTimedCall(), parseTimingLine(), runLimited()); new
## checkPedkindrawFolder() and stopsRecord().
## The Phase 1 timing harness (docs/planning/standalone-pedigree-package-
## plan.md, Phase 1 steps 4-5). Each measurement is one fresh Rscript
## (timeOne.R) run under /usr/bin/time -l: the time limit counts from the
## child's "CALL START" line, so loading does not count; the memory limit is
## held twice, by R's own vector-heap cap (R_MAX_VSIZE, which refuses a too
## large matrix at once) and by a watchdog on the process's resident memory.
## The tests are in tests/test_timingHarness.R.

## ---- the scripts' arguments -------------------------------------------------

## The value of a script's "--<name>=<value>" argument in `args`, or
## `default` when there is none (the first one when repeated).
scriptOption <- function(args, name, default) {
  hit <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(hit) == 0L) default else sub("^[^=]*=", "", hit[1L])
}

## ---- the timing child's library path --------------------------------------

## pedkindraw installed from the commit timed (pkdLib, PKD_LIB) first, the
## path the process found next (renv's library, which holds kinship2 and
## Pedixplorer), then R's own library, where renv's sandbox hides some of
## their dependencies. Returns the old path, invisibly.
useTimingLibraries <- function(pkdLib = Sys.getenv("PKD_LIB")) {
  old <- .libPaths() # nolint: undesirable_function_linter.
  # nolint next: undesirable_function_linter.
  .libPaths(c(pkdLib, old, R.home("library")))
  invisible(old)
}

## Stops unless pedkindraw was loaded from `folder` = pkdLib, the scratch
## library PKD_LIB names: renv's library holds an older pedkindraw with the
## same version number (docs/planning/pedkindraw-timing-plan.md section 8,
## dragon 2), which would be timed with no error.
checkPedkindrawFolder <- function(folder, pkdLib) {
  same <- identical(
    normalizePath(folder, "/", mustWork = FALSE),
    normalizePath(pkdLib, "/", mustWork = FALSE)
  )
  if (!same) {
    stop("pedkindraw was loaded from ", folder, ", not from PKD_LIB (",
      pkdLib, ")",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

## ---- reading the reports --------------------------------------------------

## /usr/bin/time -l's report: the real seconds and the peak resident memory
## (bytes on macOS).
parseTimeOutput <- function(lines) {
  rss <- grep("maximum resident set size", lines, fixed = TRUE, value = TRUE)
  if (length(rss) == 0L) {
    stop("no 'maximum resident set size' line in time's report",
      call. = FALSE
    )
  }
  real <- grep("^\\s*[0-9.]+ real", lines, value = TRUE)
  list(
    realSeconds = if (length(real) > 0L) {
      as.numeric(sub("^\\s*([0-9.]+) real.*$", "\\1", real[1L]))
    } else {
      NA_real_
    },
    maxRssBytes = as.numeric(sub("^\\s*([0-9]+)\\s+maximum.*$", "\\1", rss[1L]))
  )
}

## The child's last "TIMING key=value ... pkdLib=<folder>" line, or NULL
## when there is none. The folder pedkindraw was loaded from is the rest of the
## line, so it may hold spaces; "" when the line has none.
parseTimingLine <- function(lines) {
  line <- grep("^TIMING ", lines, value = TRUE)
  if (length(line) == 0L) {
    return(NULL)
  }
  line <- line[length(line)]
  pkdLib <- if (grepl(" pkdLib=", line, fixed = TRUE)) {
    sub("^.*? pkdLib=", "", line, perl = TRUE)
  } else {
    ""
  }
  line <- sub(" pkdLib=.*$", "", line)
  fields <- strsplit(sub("^TIMING ", "", line), " ",
    fixed = TRUE
  )[[1L]]
  value <- sub("^[^=]*=", "", fields)
  names(value) <- sub("=.*$", "", fields)
  loaded <- value[["loaded"]]
  list(
    seconds = as.numeric(value[["seconds"]]),
    heapPeakMb = as.numeric(value[["heapPeakMb"]]),
    preRssMb = as.numeric(value[["preRssMb"]]),
    loaded = if (nzchar(loaded)) {
      strsplit(loaded, ",", fixed = TRUE)[[1L]]
    } else {
      character()
    },
    pkdLib = pkdLib
  )
}

## The 1-minute load average from uptime's line (GNU "load average: a, b, c"
## or macOS "load averages: a b c").
parseLoadAverage <- function(text) {
  m <- regmatches(text, regexpr("load averages?: *[0-9.]+", text))
  if (length(m) == 0L) stop("no load average in: ", text, call. = FALSE)
  as.numeric(sub("^.*: *", "", m))
}

## ---- the machine ----------------------------------------------------------

currentLoad <- function() parseLoadAverage(system("uptime", intern = TRUE))

## The idle share of CPU time (%), from the second of two top samples one
## second apart (the first covers the time since boot).
currentIdle <- function() {
  out <- system("top -l 2 -n 0 -s 1", intern = TRUE)
  line <- utils::tail(grep("^CPU usage", out, value = TRUE), 1L)
  as.numeric(sub("^.* ([0-9.]+)% idle.*$", "\\1", line))
}

## The free share of memory (%) from macOS's `memory_pressure -Q` report.
parseMemoryFree <- function(lines) {
  line <- grep("memory free percentage", lines, fixed = TRUE, value = TRUE)
  if (length(line) == 0L) {
    stop("no 'memory free percentage' line in memory_pressure's report",
      call. = FALSE
    )
  }
  as.numeric(sub("^.*: *([0-9.]+)%.*$", "\\1", line[1L]))
}

currentMemoryFree <- function() {
  parseMemoryFree(system("memory_pressure -Q", intern = TRUE))
}

## Wait until at least idleFloor % of the CPU is idle (Mark's ruling, S1123)
## and, when memFloor is above 0, at least memFloor % of memory is free
## (S1141), at most maxWait seconds. Returns whether the machine was quiet and
## the idle share, free memory (NA when not read) and load it started at. The
## readers and the pause are arguments so that the tests can stand them in.
waitForQuiet <- function(idleFloor = 50.0, maxWait = 600.0, memFloor = 0.0,
                         idleOf = currentIdle, memOf = currentMemoryFree,
                         loadOf = currentLoad,
                         pause = function() Sys.sleep(15.0)) {
  t0 <- proc.time()[["elapsed"]]
  repeat {
    idle <- idleOf()
    memFree <- if (memFloor > 0.0) memOf() else NA_real_
    quiet <- idle >= idleFloor && (memFloor <= 0.0 || memFree >= memFloor)
    if (quiet || proc.time()[["elapsed"]] - t0 > maxWait) {
      return(list(
        quiet = quiet, idle = idle, memFree = memFree, load = loadOf()
      ))
    }
    pause()
  }
}

## The busiest processes now, appended to `file` (started anew at "start").
machineNote <- function(label, file) {
  top <- system("ps -Ao pcpu,etime,comm -r", intern = TRUE)[1L:11L]
  cat(c(
    paste("##", label, format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
    system("uptime", intern = TRUE), paste("idle", currentIdle(), "%"),
    top, ""
  ), file = file, sep = "\n", append = !identical(label, "start"))
}

## ---- in the timing child ----------------------------------------------------

## The process's resident memory (MiB) before the call, then "CALL START",
## the timed `expr` (measure(), measure.R, sourced by the child) and the
## TIMING line parseTimingLine() reads, naming which of `watched` are loaded
## and the folder pedkindraw was loaded from ("" when it was not).
reportTimedCall <- function(expr, watched) {
  rss <- system(paste("ps -o rss= -p", Sys.getpid()), intern = TRUE)
  preRssMb <- as.numeric(rss) / 1024.0
  cat("CALL START\n")
  flush(stdout())
  m <- measure(expr) # nolint: object_usage_linter.
  pkdLib <- if ("pedkindraw" %in% loadedNamespaces()) {
    dirname(getNamespaceInfo("pedkindraw", "path"))
  } else {
    ""
  }
  cat(sprintf(
    "TIMING seconds=%.4f heapPeakMb=%.1f preRssMb=%.1f loaded=%s pkdLib=%s\n",
    m$seconds, m$peakMb, preRssMb,
    paste(intersect(watched, loadedNamespaces()), collapse = ","), pkdLib
  ))
  invisible(m)
}

## ---- one cell: three runs, and the size ladder ----------------------------

## The median of each figure over the measured runs; a failed run makes the
## whole cell fail with that run's status and message.
summarizeRuns <- function(runs) {
  status <- vapply(runs, `[[`, "", "status")
  bad <- which(status != "ok")
  if (length(bad) > 0L) {
    first <- runs[[bad[1L]]]
    return(list(
      status = first$status, message = first$message, seconds = NA_real_,
      heapPeakMb = NA_real_, preRssMb = NA_real_, maxRssBytes = NA_real_,
      runs = length(runs)
    ))
  }
  med <- function(field) stats::median(vapply(runs, `[[`, 0.0, field))
  list(
    status = "ok", message = "", seconds = med("seconds"),
    heapPeakMb = med("heapPeakMb"), preRssMb = med("preRssMb"),
    maxRssBytes = med("maxRssBytes"), runs = length(runs)
  )
}

## Capacity from a ladder of sizes (columns size, status, message): the
## largest size before the first failure, and how that next size failed.
capacityOf <- function(outcomes) {
  o <- outcomes[order(outcomes$size), , drop = FALSE]
  fail <- which(o$status != "ok")
  if (length(fail) == 0L) {
    return(list(
      capacity = max(o$size), failedAt = NA_integer_,
      failure = NA_character_, message = NA_character_
    ))
  }
  f <- fail[1L]
  list(
    capacity = if (f > 1L) o$size[f - 1L] else NA_integer_,
    failedAt = o$size[f], failure = o$status[f], message = o$message[f]
  )
}

## ---- the limited runner ---------------------------------------------------

## The resident memory (bytes) of every process under handle h.
childRss <- function(h) {
  kids <- tryCatch(ps::ps_children(h, recursive = TRUE),
    error = function(e) list()
  )
  rss <- vapply(kids, function(k) {
    tryCatch(ps::ps_memory_info(k)[["rss"]], error = function(e) 0.0)
  }, 0.0)
  sum(rss)
}

## The R error text in the child's standard error: everything before time's
## report, without R's closing "Execution halted".
childError <- function(err) {
  real <- grep("^\\s*[0-9.]+ real", err)
  if (length(real) > 0L) err <- err[seq_len(real[1L] - 1L)]
  err <- err[!grepl("^Execution halted|^Command terminated", err)]
  substr(trimws(paste(err, collapse = " ")), 1L, 300L)
}

## Run `Rscript script args` under /usr/bin/time -l in directory wd. Stop it
## as "time" when the call runs past timeLimit seconds after the child prints
## startMarker, as "memory" when its resident memory passes memLimit bytes
## (polled), and as "error" when it never starts within loadLimit seconds.
## heapCap (bytes, or NULL for none) becomes the child's R_MAX_VSIZE.
runLimited <- function(script, args = character(), timeLimit = 120.0,
                       memLimit = 32.0e9, heapCap = memLimit, wd = getwd(),
                       poll = 0.1, loadLimit = 300.0,
                       startMarker = "CALL START") {
  errFile <- tempfile(fileext = ".txt")
  on.exit(unlink(errFile))
  env <- "current"
  if (!is.null(heapCap)) {
    env <- c(env, R_MAX_VSIZE = format(heapCap, scientific = FALSE))
  }
  ## macOS's time: its -l report gives the peak resident memory in bytes.
  # nolint next: absolute_path_linter, nonportable_path_linter.
  p <- processx::process$new("/usr/bin/time",
    c("-l", file.path(R.home("bin"), "Rscript"), script, args),
    stdout = "|", stderr = errFile, wd = wd, env = env, cleanup_tree = TRUE
  )
  h <- p$as_ps_handle()
  out <- character()
  t0 <- proc.time()[["elapsed"]]
  started <- NA_real_
  stopped <- NA_character_
  while (p$is_alive()) {
    p$poll_io(as.integer(poll * 1000.0))
    out <- c(out, p$read_output_lines())
    now <- proc.time()[["elapsed"]]
    if (is.na(started) && startMarker %in% out) started <- now
    if (!is.na(started) && now - started > timeLimit) {
      stopped <- "time"
    } else if (is.na(started) && now - t0 > loadLimit) {
      stopped <- "load"
    } else if (childRss(h) > memLimit) {
      stopped <- "memory"
    }
    if (!is.na(stopped)) {
      ## Stop the R child only, so that time still writes its report.
      for (k in ps::ps_children(h, recursive = TRUE)) {
        try(ps::ps_kill(k), silent = TRUE)
      }
      break
    }
  }
  p$wait()
  out <- c(out, p$read_all_output_lines())
  err <- readLines(errFile, warn = FALSE)
  report <- tryCatch(parseTimeOutput(err), error = function(e) {
    list(realSeconds = NA_real_, maxRssBytes = NA_real_)
  })
  timing <- parseTimingLine(out)
  status <- "ok"
  message <- ""
  if (identical(stopped, "time")) {
    status <- "time"
    message <- sprintf("over %g s after the call started", timeLimit)
  } else if (identical(stopped, "memory")) {
    status <- "memory"
    message <- sprintf("resident memory over %g GB", memLimit / 1.0e9)
  } else if (identical(stopped, "load")) {
    status <- "error"
    message <- sprintf("no '%s' within %g s", startMarker, loadLimit)
  } else if (!identical(p$get_exit_status(), 0L)) {
    message <- childError(err)
    heapFull <- "vector memory limit|cannot allocate vector"
    status <- if (grepl(heapFull, message)) "memory" else "error"
  } else if (!is.na(report$maxRssBytes) && report$maxRssBytes > memLimit) {
    status <- "memory"
    message <- sprintf("peak resident memory over %g GB", memLimit / 1.0e9)
  } else if (is.null(timing)) {
    status <- "error"
    message <- "no TIMING line"
  }
  ok <- identical(status, "ok")
  list(
    status = status, message = message,
    seconds = if (ok) timing$seconds else NA_real_,
    heapPeakMb = if (ok) timing$heapPeakMb else NA_real_,
    preRssMb = if (ok) timing$preRssMb else NA_real_,
    loaded = if (ok) timing$loaded else character(),
    pkdLib = if (ok) timing$pkdLib else "",
    maxRssBytes = report$maxRssBytes, realSeconds = report$realSeconds
  )
}

## Whether a run's failure stops the whole record: pedkindraw missing from
## PKD_LIB, or loaded from elsewhere (timeOne.R), so no later run would time
## the commit the record names.
stopsRecord <- function(r) {
  identical(r$status, "error") && grepl("PKD_LIB", r$message, fixed = TRUE)
}
