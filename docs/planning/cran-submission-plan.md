# CRAN submission plan: pedkindraw's first release (plan Phase 17)

**Date:** 2026-11-16 · **Session:** pedkindraw S32 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; `methodology/workstreams/ARCHITECTURE_WORKSTREAM.md`). Nothing under `R/`, `tests/`, `man/`,
`vignettes/`, `inst/` or `DESCRIPTION` changed.
**Status:** written; no phase started. Next: Phase 17a.
**Mark's direction (S32):** "It looks the a plan for a CRAN release should include, at least, consideration of the
other options listed, examination of possible impact of recent and ongoing changes in nprcgenekeepr on pedkindraw,
and the comparison of pedkindraw with kinship2 and Pedixplorer." The options listed were the orient picker's:
Phase 17's plan, the argument-name review, the "Select by id" and legend-label fixes, the gaps document and full
test coverage. Mark's picks: this outline; all four open items before the release; the check time measured on
win-builder first (rulings R83-R85 in `docs/planning/standalone-pedigree-package-plan.md`).
**Builds on:** nprcgenekeepr's `docs/planning/cran-3.0.0-submission-plan.md` (read from the clone at
`363137511`; its S1091, COMPLETE S1144): its phase shape (cut the test time, static hygiene, Suggests used
conditionally, NEWS, version, full gate, cover note and cross-platform runs, submission, after acceptance), its
decisions D1-D5 and its "Here be dragons". This plan repeats what applies here and adds what is pedkindraw's own.
**Measured at:** pedkindraw `ba811e7` (S32's claim; `R/`, `tests/`, `vignettes/` as at `aeaed75`), nprcgenekeepr
`363137511`, on this Mac (Apple M2 Max, R 4.6.2). Each phase below is its own session; strict TDD (`CLAUDE.md`)
applies wherever code or tests change, with the three gates put to Mark.

---

## 1. Summary

**Where things stand.** Phases 5-16 are DONE (Phase 16d, the speed vignette, deferred by R82). The package has 31
exports, 53 test files (684 tests), two vignettes and a website (<https://rmsharp.github.io/pedkindraw/>). It reads
version 0.0.1 and is not on CRAN. `R CMD check --as-cran` gives R16's NOTE only (Maintainer, "New submission");
CI passes on five jobs.

**What stands between this tree and a submission, riskiest first:**

1. **The check time** (section 2.1). CRAN's incoming check rejects a package whose check takes more than 10
   minutes on its machines (nprcgenekeepr's first 2.0.0 upload was rejected for "Overall checktime 12 min > 10
   min"). The whole check took 181 s here, 118 s of it tests. nprcgenekeepr measured win-builder at 3.4-3.8 times
   this machine, which gives 615-688 s, at or over the 600 s limit; nprcgenekeepr's own readings for nearly the
   same code spread from 284 to 617 s. Unsettled until measured where the limit applies: Phase 17a (R85).
2. **Five pieces of work Mark put before the release** (R84; section 3): the argument-name review (17b-17c), two
   drawing fixes in copied code (17d-17e), the gaps document (17f), pedkindraw's own timing runs and the speed
   vignette (17g-17i), and tests for full coverage (17j). Each adds code, tests or pages, so the test-time cut
   (17k) and the release steps come after them.
3. **Suggests packages used in tests without a guard** (section 2.3): `mockery` and `withr`. CRAN's "noSuggests"
   check, run after publication, would fail on them. → 17l.
4. **Release housekeeping**: spelling and the `Language` field, the version number, NEWS, the README's install
   line, `cran-comments.md`, the cross-platform runs. → 17l-17o.

**nprcgenekeepr** (section 4): none of its 165 commits since the copy commit `baef1e12c` changes a copied file but
the legend change S12 already ported; its work in progress touches no copied function. It needs watching, not
work, unless it changes a copied function before the submission.

**How many sessions:** about 17 to 22 (a guess; section 8): 17a-17o and 17q are sessions, 17h may be several,
17k may be none, and 17p is Mark's action. The release follows the last of them.

---

## 2. Measured this session

### 2.1 The check time (this Mac, load average 5.3-12.7)

`R CMD build` then `R CMD check --as-cran --timings` on the tarball, from a scratch folder with renv's library
(`CLAUDE.md`, Build / Test / Verify), with `_R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_` and
`_R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_` at 2.5 (no NOTE: the tests run on one core, 118 s CPU in 118 s):

| Step | This Mac | win-builder estimate (×3.4-3.8) |
|---|---:|---:|
| build (vignettes built) | 16 s | not counted by CRAN |
| tests (`Running 'testthat.R'`) | 118 s | 401-448 s |
| examples (all 31 pages; `asPedFrame` 1.07 s) | 1.1 s | 4 s |
| vignettes re-built, PDF and HTML manual, the rest | 62 s | 211-236 s |
| **check total** | **181 s** | **615-688 s** |

`Status: 1 NOTE`, R16's. The machine was busy (another R process, two test runners and Spotlight; load average
5.28 at the start, 12.70 during), so these times are high, by an unmeasured amount. The ×3.4-3.8 ratio is
nprcgenekeepr's (its 2.0.0 cover note: examples 22 s against 80 s, tests 59 s against 200 s, vignettes 17 s
against 65 s), and its 3.0.0 readings on win-builder R-devel spread from 284 to 617 s for nearly the same code. The
estimate cannot say which side of 600 s the check falls: R85 measures it (17a).

**The tests in CRAN mode, file by file** (`testthat::test_dir()` on the installed check copy, `NOT_CRAN` unset):
684 tests, 0 failed, 8 skipped, 103.6 s summed. Eight files take 81% of it:

| File | Seconds | Cumulative share |
|---|---:|---:|
| `test_positionMatingUnitForest.R` | 16.5 | 16% |
| `test_asPedFramePedixplorer.R` | 15.8 | 31% |
| `test_makePedigreeMatingLayout.R` | 12.9 | 44% |
| `test_resolveEdgeNodeCollisions.R` | 12.5 | 56% |
| `test_asPedFrameHints.R` | 7.7 | 63% |
| `test_addRectilinearWaypoints.R` | 6.6 | 70% |
| `test_findUnrelated.R` | 6.2 | 76% |
| `test_comparePedigreeStructure.R` | 5.5 | 81% |

Six files already call `skip_on_cran()` in some tests. The Pedixplorer file runs on CRAN wherever Pedixplorer is
installed (CRAN's machines carry Bioconductor packages for Suggests).

### 2.2 Static checks

- Every help page but the package's has `\value`; no page uses `\dontrun` or `\donttest`; all 31 export pages have
  examples (32 pages, `?pedkindraw` without).
- `R/` has no `options()`, `par()`, `setwd()` or `Sys.setenv()` call, no `cat()` or `print()` to the console (only
  inside `utils::capture.output()`, `R/comparePedigreeStructure.R`), no `:::` call, no `library()` or `require()`,
  and writes no file (`saveWidget()` appears in help text only).
- `inst/extdata` is 24 KB; the tarball 1,382,519 B; installed 4,284 KB of R77's 5,120 KB.
- **Spelling.** `R CMD check` here printed "No suitable spell-checker program found" when asked to spell-check
  (`_R_CHECK_CRAN_INCOMING_USE_ASPELL_=TRUE`): hunspell is installed without an English dictionary, so the
  incoming check's spelling step never runs on this Mac. `spelling::spell_check_package()` (spelling 2.3.2, R's own
  library) finds 49 words: 0 in `DESCRIPTION` (CRAN's incoming check reads only that), 12 of them in the vignettes
  or README, the others in help pages or NEWS. Among them British spellings ("colour", "grey", "labelled") under
  `Language: en-US`, and "vermillion".
- `DESCRIPTION` cites no reference; the methods' paper (Sinnwell, Therneau and Schaid 2014) is in eight help pages'
  `@references`.
- `Depends: R (>= 4.1.0)`; the oldest R that CI checks is oldrel-1 (4.5).

### 2.3 Suggests packages in the tests

The 9 Suggests are `chromote`, `htmlwidgets`, `kinship2`, `knitr`, `mockery`, `Pedixplorer`, `rmarkdown`,
`testthat`, `withr`. kinship2 and Pedixplorer are guarded inside the test blocks read (`skip_if_not_installed()`,
`test_bitSize.R:82`), and
the vignettes run their chunks only when each is installed (`eval = requireNamespace(...)`). Not guarded:
`mockery` in 4 files (`test_isAddedRecord.R` calls `mockery::mock()` with no skip) and `withr` in up to 19 files
(`test_shrinkPedigree.R:346` calls `withr::local_collate()`), counted by `grep`; which blocks fail without them is
17l's measurement. **R's own library holds 7 of the 9** (all but kinship2 and Pedixplorer; 242 non-base packages in
`.Library`), so `_R_CHECK_DEPENDS_ONLY_=true` on this Mac would hide only kinship2 and Pedixplorer (nprcgenekeepr's
dragon 9): 17l needs a library without them.

### 2.4 Names (for 17b)

- **Arguments that name the same thing differently:** `kinship(id, fatherId, motherId, ...)` beside
  `findGeneration(id, sire, dam)`, `findPedigreeNumber(id, sire, dam)`, `correctParentSex(id, sire, dam, ...)` and
  `familyCheck(famid, id, sire, dam, newfam)`; the pedigree is `ped` in 20 exports, `pedSourceDf` in
  `getOffspring()` and `getParents()`, `uPed` in `addBackSecondParents()` and `getIdsWithOneParent()`.
- **Argument order:** the pedigree comes first in most exports but after the ids in `getProbandPedigree(probands,
  ped)`, `getDescendantPedigree(probands, ped)`, `trimPedigree(probands, ped, ...)` and `hasBothParents(id, ped)`.
- **`addIdRecords()`** is copied and not exported (contract 4.1); the contract asks whether to export it.
- **Export names shared** with nprcgenekeepr 3.0.0.9000 (240 exports): 22 of pedkindraw's 31 (all but
  `asPedFrame`, `bitSize`, `checkPedigree`, `familyCheck`, `findAvailAffected`, `findAvailNonInform`,
  `findUnavailable`, `findUnrelated`, `ibdMatrix`); with kinship2 1.9.6.2: `bitSize`, `findAvailAffected`,
  `findAvailNonInform`, `findUnavailable`, `ibdMatrix`, `kinship`; with Pedixplorer 1.8.0: `kinship`. Loading
  pedkindraw with one of them masks these names (the shared kinship2 names are R3's parity by design).
- **Inventory by search** (`git grep -w` in `R/`, `tests/`, `vignettes/`, `README.Rmd`, `tools/`, `man/`):
  `fatherId` and `motherId` 14 lines each in 4 files (`R/kinship.R`, `man/kinship.Rd`, `test_kinship.R`,
  `test_kinshipMemoryEquivalence.R`); `pedSourceDf` 15 lines in 4 files (`R/getOffspring.R`, `R/getParents.R` and
  their pages); `uPed` 20 lines in 4 files (`R/addBackSecondParents.R`, `R/getIdsWithOneParent.R` and their pages);
  `addIdRecords` 12 lines in 4 files (`R/addBackSecondParents.R`, `R/addIdRecords.R`, `test_addIdRecords.R`,
  `tools/compareResultsWithNprcgenekeepr.R`). Calls by position, which an order change breaks:
  `getProbandPedigree(` 24 lines in 8 files, `getDescendantPedigree(` 20 in 7, `trimPedigree(` 8 in 8,
  `hasBothParents(` 6 in 5, `getOffspring(` 6 in 7, `getParents(` 6 in 6, `addBackSecondParents(` 5 in 6,
  `getIdsWithOneParent(` 2 in 4, `kinship(` 74 in 14 (the README and both vignettes among them). 17b repeats the
  search for each change it decides, and `tools/compareResultsWithNprcgenekeepr.R`'s `runCases()` is among the
  callers.

### 2.5 Version, CI and the website

- The version lives in `DESCRIPTION:4` (`0.0.1`) and `NEWS.md:1` (`# pedkindraw 0.0.1 (development version)`);
  `README.Rmd:42` says "pedkindraw is not on CRAN yet". No other file outside `renv.lock`, `methodology/` and
  `docs/` names `0.0.1`.
- CI (`.github/workflows/R-CMD-check.yaml`): five jobs, macOS release, Windows release, Ubuntu devel, release and
  oldrel-1; `r-lib/actions/check-r-package@v2` with `--no-manual`; `actions/checkout@v4` (the Node 20 notice,
  a backlog item). None is win-builder, macOS on R-devel, or CRAN's incoming check.
- The site (`.github/workflows/pkgdown.yaml`) rebuilds on each push to master that touches more than `CLAUDE.md`
  and `methodology/**`, and by hand; not on a release or tag. `.Rbuildignore` has no line for `cran-comments.md`
  or `CRAN-SUBMISSION`.
- Release tools: `devtools`, `rhub`, `rcmdcheck`, `urlchecker` and `usethis` are installed neither in renv nor in R's
  own library; `spelling` and `pkgdown` are in R's own library.

---

## 3. The open work: before or after the release

Mark's picks (R84) put the first five before the release; the rest is ruled here by its effect on the release.

| Backlog item (`methodology/BACKLOG.md`) | When | Phase | Why |
|---|---|---|---|
| Review argument names | before | 17b-17c | contract section 6: after the first release a rename needs a `.Deprecated()` cycle |
| "Select by id" lists invisible routing points | before | 17d | R84; shows in the drawing vignette's colony drawing (196 of 571 entries) |
| The legend cuts its "Same animal, again" label | before | 17e | R84; shows on the website's drawings |
| What kinship2 or Pedixplorer can do that pedkindraw cannot | before | 17f | R84; Mark can then decide whether a gap is closed first |
| The speed and size-limits vignette, once pedkindraw times itself | before | 17g-17i | R84, R82's condition |
| Tests for full coverage | before | 17j | R84 |
| The suite gate's time limit is below the suite's time | before | 17l | the full gate (17n) needs the gate measured, not unmeasured |
| A stale pedkindraw 0.0.1 in renv's library | before | 17l | anything that loads pedkindraw without installing runs the stale copy |
| CI notices: `actions/checkout@v5` and Ubuntu 26 | before, if still shown | 17l | the release's CI must stay green |
| After nprcgenekeepr has the legend's section pictures (R81) | after | none | waits on nprcgenekeepr; `DIVERGENCE.md` records it until then |
| The drift tool does not watch copied constants | after | none | the release does not depend on it; both constants unchanged in nprcgenekeepr (section 4.1) |
| `findPedigreeNumber()`'s speed | after | none | new work; contract section 10 item 5 |
| Point the context-budget tool at `methodology/`; the dashboard and `BACKLOG.md` | after | none | methodology, not the package |
| Report a vacuous test; tell nprcgenekeepr's edition-3 conversion | not here | none | nprcgenekeepr sessions, which Mark starts (R8) |
| Whether pedkindraw copies nprcgenekeepr's colony overview | after | none | DECISION NEEDED later; would need a ruling and a plan change |

If 17f leads Mark to close a gap before the release, that work becomes a phase of its own by ruling, placed before
17g so the timing runs and the coverage measure the code that ships.

---

## 4. nprcgenekeepr

### 4.1 Its changes since the copy (measured)

- The 79 files whose header says "Copied from nprcgenekeepr" (34 in `R/`, 45 in `tests/testthat/`) name their
  source commit: `baef1e12c` for 77, `4283e3502` for `R/drawPedigreeDiagram.R`, `392dd347e`
  for its test file. nprcgenekeepr has 165 commits after `baef1e12c` (to `363137511`); **0 change any of those
  source files after the commit each was copied at** (`git log <commit>..HEAD -- <source>` per file). The only
  earlier change to a copied file, S1159's legend, was ported in pedkindraw S12 (R37).
- `tools/compareWithNprcgenekeepr.R`: 91 copied functions in 33 files, 5 differ, 0 without a `DIVERGENCE.md` row
  (the 5 are pedkindraw's own changes: Phase 15's hints, R81's legend pictures).
- Its changes since then are elsewhere: the colony overview (#138, S1153-S1155: `makeColonyOverview()`,
  `drawColonyOverview()`, `getMaternalLinePedigree()`, three new exports, and `.checkOnClick()`, which pedkindraw
  copied with `drawPedigreeDiagram()`), the Shiny "data ready" signals (S1170-S1177), `rankCombined()`, tutorial and
  vignette tests, and S1178 in progress (living-offspring counts in `offspringCounts()` and `reportGV()`). None of
  these functions is copied.

### 4.2 What is pending between the two

- **R81, from pedkindraw to nprcgenekeepr:** the legend's section pictures, to be ported there in a session Mark
  starts (backlog item BLOCKED). Two `DIVERGENCE.md` rows until then; not a release blocker.
- **The two drawing fixes (17d, 17e):** nprcgenekeepr's `R/drawPedigreeDiagram.R` has the same `__jog_` filter and
  the same legend label, so each fix is a drift-rule choice at its pre-RED picker (D3).
- **nprcgenekeepr's `BACKLOG.md` "Not yet mirrored (S1159)" line is stale:** pedkindraw S12 ported that change. For
  an nprcgenekeepr session to remove (R8: pedkindraw's sessions leave nprcgenekeepr unchanged).
- **nprcgenekeepr's edition-3 conversion** (R29) has not started (its `DESCRIPTION` names no edition).

### 4.3 What the release changes

- **The API freezes.** After the first CRAN release an export or argument is removed only after one release with
  a `.Deprecated()` warning (contract section 6). A later port of an nprcgenekeepr change that alters a copied
  function's arguments then needs that cycle, or stays a `DIVERGENCE.md` row.
- **A port reaches users only with a pedkindraw release**, and nprcgenekeepr's next CRAN release (with the colony
  overview) does not wait for pedkindraw's, nor pedkindraw's for it (R8).
- **Two packages with the same function names on CRAN** (section 2.4): a user who loads both gets masking
  messages. The "Later, optional" step of the standalone plan (nprcgenekeepr uses pedkindraw) would end the
  duplication; it is Mark's decision and not part of this plan.
- **NEWS names the copy:** "a copy of nprcgenekeepr's at nprcgenekeepr's commit `baef1e12c`" (`NEWS.md`), and
  points to `DIVERGENCE.md`, which `.Rbuildignore` leaves out of the package: 17m words it as a file in the
  repository, as it does now.

### 4.4 The guard

Every phase's Orient runs the drift tool and `git -C ../nprcgenekeepr log --oneline <copy commit>..HEAD --` the
copied files (Learning 15), as S12-S32 did. A change found to a copied function during Phase 17 is handled by R37:
ported in a session of its own (a phase added by ruling) or recorded in `DIVERGENCE.md`; whether it holds the
release is Mark's call at that Orient. 17n and 17o repeat both checks as DONE items, so the submitted tarball's
state against nprcgenekeepr is known and written in `cran-comments.md`'s notes for the record (not for CRAN).

---

## 5. The comparison with kinship2 and Pedixplorer

**What exists.** The comparison study (`docs/research/pedigree-package-comparison-2026-11.md`, nprcgenekeepr
S1122-S1126): agreement of results (section 5), timing, memory and capacity (7, 9), drawing (8), and what is left to
offer (10: the drawing, not the computation; missing beside the others, SVG and PDF export and a fitted view of a
large pedigree that shows ids). The kinship2 gap analysis (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`,
kinship2's 25 exports, written for nprcgenekeepr before pedkindraw existed). In the suite, the new exports are
compared with kinship2 where it returns (`bitSize()`, `findUnavailable()`, `findAvailNonInform()`,
`findAvailAffected()`, `familyCheck()`, `ibdMatrix()`, `findUnrelated()`, `kinship()`'s X chromosome, the
converters), skipped without it; `tools/compareResultsWithNprcgenekeepr.R` holds the copied code to nprcgenekeepr's
results (600 of 600 identical, S30).

**What is pending, both before the release (R84):**

- **The gaps document (17f):** each thing kinship2 1.9.6.2 or Pedixplorer 1.8.0 (both in renv) can do that
  pedkindraw cannot, shown on a typed case (Learnings 18-19), under `docs/research/`. Deciding which gaps to close
  is Mark's, afterwards.
- **The speed and size comparison (17g-17i):** R82: "the comparison of pedkindraw with kinship2 and Pedixplorer"
  waits until pedkindraw has timing runs of its own installed code, under a plan of its own that replaces R79's
  summary of nprcgenekeepr's records. Mark at S30: "Disambiguation between pedkindraw and nprcgenekeepr may need to
  wait until pedkindraw is completely separated. That is, this comparison may be premature." He then picked
  "pedkindraw times itself" over full separation. The draft built to R79 is on the branch `draft/speed-vignette`
  (`612eed9`: `vignettes/speed.Rmd`, 372 lines, nine tables; `tools/checkSpeedTables.R`, 709 lines, which checks
  every cell against committed result files). Its design carries over; its numbers do not.

**What the release needs from them:** nothing CRAN checks. The vignette adds a third page to the installed package
(R77 measured each page with drawings at 1.6-1.9 MB, the visNetwork JavaScript it carries; a page without
drawings carries none, and 17i measures its size; 836 KB are left under 5,120 KB) and must not time anything while
it builds: CRAN rebuilds vignettes inside the 10-minute check, so its tables read committed results, as the
draft's do.

---

## 6. Phases

Each phase is one session unless it says otherwise; close out when its DONE is met. Every session runs the checks
in `CLAUDE.md`'s Build / Test / Verify table that its changes touch, and at Orient the drift tool and Learning 15's
log (section 4.4). "Surface" names where DONE is shown and what that place cannot show.

### Phase 17a. The check time on win-builder (R85)

- **Work:** build today's tarball as section 2.1 did; upload it to win-builder R-devel (D1 decides who); read the
  emailed log: "Check time in seconds", each step's time, the NOTEs (the spelling step runs there). Record the
  numbers in this plan (section 2.1) and the ledger.
- **DONE:** the R-devel reading is in this plan, with the tarball's commit; the decision whether 17k is needed
  is stated against the 540 s target (R85), counting what 17b-17j will add.
- **Commands:** `R CMD build` from scratch (section 2.1); `uptime` beside any local timing.
- **Surface:** win-builder R-devel, the class of machine CRAN's limit is enforced on; not CRAN's incoming pretest
  itself, which only a submission reaches. One reading (nprcgenekeepr saw 284-617 s for nearly the same code), so a
  reading near 540 s is uploaded again before it decides anything.
- **Outward action:** an upload sends the package to win-builder and an email to the maintainer; Mark approves it
  in the session.

### Phase 17b. The argument-name review (a decision session)

- **Work:** for each item of section 2.4 (argument names, argument order, `addIdRecords()`, the shared export
  names), a picker states what changes, the call sites by search, what it breaks (callers by position, the copied
  tests, `runCases()`, the README and vignettes) and the drift cost (each change a `DIVERGENCE.md` row; the drift
  tool then lists the function). Mark picks; the picks become rulings; the contract's sections 4 and 6 say what
  changed.
- **DONE:** a ruling per item (change or keep), the contract updated, the inventory of each change in this plan.
  No code changed.
- **Surface:** documents only.

### Phase 17c. The renames (strict TDD; only if 17b changes anything)

- **Work:** RED: tests call the new names and fail; GREEN: the functions, their help, every caller from 17b's
  inventory, `DIVERGENCE.md` rows, the copied files' headers; REFACTOR at Mark's gate. One session, two if 17b's
  changes touch more than about ten files (a guess).
- **DONE:** suite 0 failed, WARN 0; lint 0; roxygen idempotent; `R CMD check --as-cran` R16's NOTE only; the drift
  tool lists each renamed function with its row; the fidelity tool's cases run under the new names, all identical;
  `git grep` of each old name finds only history and headers; CI 5/5.
- **Surface:** this Mac and GitHub Actions.

### Phase 17d. "Select by id" leaves out the routing points (strict TDD)

- **Work:** the backlog item: `R/drawPedigreeDiagram.R:292`'s filter gains `__jog_`; a test reads
  `drawPedigreeDiagram(layout)$x$idselection$values` on a layout with jogs. The drift choice first (D3).
- **DONE:** the colony drawing's box lists its 375 animals only; the checks as 17c; the drawing vignette's
  colony drawing checked in headless Chrome.
- **Surface:** this Mac, headless Chrome, GitHub Actions.

### Phase 17e. The legend's "Same animal, again" label fits (strict TDD)

- **Work:** the backlog item: measure first whether a shorter label (`R/drawPedigreeDiagram.R:119`) or a wider
  legend column fixes it at both widths (the website's 776 px widget, the vignette's 700 px column); the drift
  choice (D3).
- **DONE:** the label whole at both widths in headless Chrome, by a check that fails on the cut label; the
  checks as 17c.
- **Surface:** headless Chrome at two widths; it cannot show every reader's font.

### Phase 17f. The gaps document

- **Work:** the backlog item: `docs/research/` gains a dated document listing each gap with its evidence,
  re-checking the gap analysis's rows against pedkindraw's exports (as 17b-17e leave them) and Pedixplorer's
  exports and help. Mark then decides, by picker, whether any gap is closed before the release (D4).
- **DONE:** each gap shown on a typed case, run with kinship2 and Pedixplorer from renv, each case in
  `tryCatch()` with a time limit (Learning 19); D4 answered.
- **Surface:** this Mac; the claims cover the cases run (Learning 19).

### Phase 17g. The timing plan (a planning session; R82)

- **Work:** a plan of its own under `docs/planning/`: what is timed (pedkindraw's exports, kinship2's and
  Pedixplorer's where they compute the same), on which pedigrees and sizes, how (fresh process, warm-up, median of
  3, `uptime`, as the standalone plan's section 6 says), where results are committed, and how the speed vignette
  and `tools/checkSpeedTables.R` read them. It sets 17h's session count.
- **DONE:** the plan committed with each phase's DONE, commands and surface. Nothing timed.
- **Surface:** documents only.

### Phase 17h. The timing runs (sessions set by 17g)

- **DONE, commands and surface:** 17g's. The machine's load is the trap (section 2.1 measured under load 5-12).

### Phase 17i. The speed vignette (Phase 16d returns)

- **Work:** `vignettes/speed.Rmd` from the draft on `draft/speed-vignette`, its tables from 17h's results,
  checked cell for cell by `tools/checkSpeedTables.R`; the pointers R82 left out (`?pedkindraw`'s "Getting
  started", the getting-started vignette's "Where next", the drawing vignette's "How large a drawing can be" at
  `vignettes/drawing.Rmd:681`); the website's third article.
- **DONE:** the check tool passes and fails on a changed cell; the vignette builds with kinship2 and Pedixplorer
  absent; nothing timed during the build; installed size under 5,120 KB; `R CMD check --as-cran` R16's NOTE only;
  the site shows three articles.
- **Surface:** this Mac, GitHub Actions, the website.

### Phase 17j. Tests for full coverage (one or two sessions)

- **Work:** the backlog item: re-measure (`covr::package_coverage(type = "tests")`; last measured S24 on `bcdc1b0`,
  97.96%, 43 of 2,501 statements missed, all in copied files; S28 and 17c-17i changed `R/` since), then tests in
  pedkindraw's own files for each statement, working out what input reaches each before calling it unreachable
  (Learning 11). Split by file if one session cannot take them all.
- **DONE:** every statement in `R/` reached by the tests, or one shown unreachable with its reason recorded; the
  new tests' CRAN-mode time recorded for 17k.
- **Surface:** this Mac (covr).

### Phase 17k. The CRAN-mode test time (only if 17a and the additions require it)

- **Work:** the files of section 2.1's table, re-measured after 17c-17j, are skipped on CRAN (D6) until the
  estimate meets R85's 540 s with a margin; CI and local runs still run every test (`NOT_CRAN=true`). Every export
  keeps at least one test that runs on CRAN.
- **DONE:** a win-builder R-devel reading of 540 s or less (an upload, Mark's approval); the list of skipped files
  and why; each export called by a test that runs in CRAN mode (a check that fails otherwise).
- **Surface:** win-builder R-devel; one reading again.

### Phase 17l. Static hygiene and noSuggests

- **Work:** spelling (`inst/WORDLIST` for names, ids and terms; British spellings to `Language`'s en-US or the field
  changed, D7); the `mockery` and `withr` uses guarded or replaced, measured by a depends-only check in a library
  without them (section 2.3); `Depends: R` checked or raised (D7); optionally the methods' reference with its DOI
  in `Description` (D7); `.Rbuildignore` lines for `cran-comments.md` and `CRAN-SUBMISSION`; the three small
  backlog items of section 3 (suite gate limit, stale renv copy, CI notices). Strict TDD where tests change.
- **DONE:** `spelling::spell_check_package()` 0 words; the depends-only check `Status: OK` with kinship2,
  Pedixplorer, `mockery` and `withr` absent; `quality_ratchet.py --run` 5/5 with the suite gate measured; the
  stale copy gone; CI 5/5 without the notices or with them explained.
- **Surface:** this Mac in a scratch library; CRAN's own noSuggests check runs only after publication.

### Phase 17m. The release text and the version

- **Work:** NEWS: the development heading becomes the release's (D8), each item checked against the code as 17b-17l
  left it, and a section on the documentation (the README, the vignettes, the website), which NEWS lacks (S31); the README's install section (CRAN first only after acceptance: a CRAN link before then is a 404 the
  incoming check reports), re-rendered; the version in `DESCRIPTION`; `?pedkindraw` if it names the version.
- **DONE:** `R CMD check --as-cran` R16's NOTE only, its NEWS step reading the release's entries; `git grep` of the
  old version finds none outside history; the README rendered twice the same.
- **Surface:** this Mac; the site after the push.

### Phase 17n. The full local gate (the tree freezes)

- **Work and DONE:** from a clean scratch copy: `R CMD check --as-cran` `Status: 1 NOTE` (R16's), its log ending in
  a `Status:` line; the CRAN-mode test time; the depends-only check; suite 0 failed, WARN 0, tallied by hand
  (the gate counts warnings only); lint 0; roxygen idempotent; coverage as 17j left it; the drift tool and the
  fidelity tool (section 4.4), nprcgenekeepr's log on the copied files; CI 5/5 and the site's run; `uptime`
  recorded. After this, only 17o's results and 17q's version move change the tree.
- **Surface:** this Mac and GitHub Actions.

### Phase 17o. `cran-comments.md` and the cross-platform runs (two sessions and Mark's runs)

- **Work:** session one writes `cran-comments.md` (a new submission; R CMD check results; test environments; no
  reverse dependencies; R16's NOTE explained; marked lines for the runs' results) and the run list: win-builder
  R-devel, R-release and R-oldrelease, the macOS builder, R-hub (its GitHub workflow, Mark's token). Mark runs them
  or approves Claude running them (D9). Session two folds in the results.
- **DONE:** every marked line filled (`grep` 0); every run 0 errors, 0 warnings and only the new-submission NOTE,
  or each other NOTE explained; win-builder R-devel at 540 s or less; the drift tool and nprcgenekeepr's log again.
  **HARD STOP before the upload.**
- **Surface:** win-builder, the macOS builder, R-hub; the macOS builder was down for a day in nprcgenekeepr's
  S1105, which dropped its line by Mark's ruling.

### Phase 17p. Submission (Mark's action)

- Mark uploads the tarball through CRAN's submission page and confirms by the link CRAN emails to the maintainer.
  A session records it in the ledger; no session uploads. If the incoming pretest fails, the work returns to the
  phase that owns the failure.

### Phase 17q. After acceptance

- **Work:** tag the release at the submitted commit and publish a GitHub release from NEWS; the development
  version (`.9000`) and a heading-only NEWS block; the README's install section with CRAN first and the badges
  (D10), re-rendered; `methodology/ROADMAP.md`; a push, which rebuilds the site (it does not build on a tag). A
  few days later, read CRAN's check page: every flavor and the additional checks, noSuggests among them.
- **DONE:** the tag and release exist; the site shows the release; the check page read and recorded.
- **Surface:** CRAN's check page, the only place its flavors and noSuggests are seen.

---

## 7. Decisions left for each phase's picker

| # | Question | Phase | What is known now |
|---|---|---|---|
| D1 | Who uploads to win-builder: Mark, or Claude with Mark's approval in the session | 17a | the result goes to the maintainer's email either way; nprcgenekeepr's D5 ruled the owner, and once let the agent |
| D2 | Each name change of section 2.4: change or keep | 17b | the inventory above; each change is a divergence from nprcgenekeepr |
| D3 | Each drawing fix: also fixed in nprcgenekeepr (a session there, Mark starts it) or a `DIVERGENCE.md` row | 17d, 17e | nprcgenekeepr has the same filter and label |
| D4 | Which gaps, if any, are closed before the release | 17f | each would be a phase of its own, before 17g |
| D5 | The timing plan's scope | 17g | R82; the draft's nine tables |
| D6 | How tests are kept off CRAN: `skip_on_cran()` per file or block, or a list of slow files as nprcgenekeepr's `slowTestFiles.txt` | 17k | eight files take 81% (section 2.1) |
| D7 | `Language` and spelling; the `Depends: R` floor; a DOI reference in `Description` | 17l | British spellings under en-US; R 4.1.0 claimed, 4.5 tested |
| D8 | The version number: 0.1.0 or 1.0.0 | 17m | contract section 6: "0.x until the first CRAN release" and the deprecation rule after it |
| D9 | Who runs the cross-platform checks | 17o | R-hub needs Mark's GitHub token; the emails go to Mark |
| D10 | Which badges the README shows | 17q | none before acceptance (section 6, 17m) |

---

## 8. Session map

| Phase | Work | Needs first | Sessions (a guess) |
|---|---|---|---|
| 17a | check time on win-builder | Mark approves an upload | 1 |
| 17b | name review, decisions | 17a | 1 |
| 17c | renames | 17b changes something | 1-2 |
| 17d | "Select by id" | 17c | 1 |
| 17e | legend label | 17c | 1 |
| 17f | gaps document | 17c-17e | 1 |
| 17g | timing plan | 17f (and any gap closed) | 1 |
| 17h | timing runs | 17g | set by 17g |
| 17i | speed vignette | 17h | 1 |
| 17j | full coverage | the code final (17c-17i) | 1-2 |
| 17k | CRAN-mode test time | 17j | 0-2 |
| 17l | hygiene, noSuggests | 17k | 1 |
| 17m | NEWS, README, version | 17l | 1 |
| 17n | full local gate | 17m | 1 |
| 17o | cover note, cross-platform runs | 17n | 2 and Mark's runs |
| 17p | submission | 17o | Mark |
| 17q | after acceptance | CRAN's email | 1 |

The order puts the code and tests that change (17b-17j) before the cut (17k), and the cut before the release text,
the version and the frozen gate, as nprcgenekeepr's plan did. 17d and 17e may swap; 17f comes after them so the gaps
it lists are the shipped package's.

---

## 9. Here be dragons

From nprcgenekeepr's plan (its section 8), as they apply here:

1. **A halted check reads as clean.** From the repository root, renv's dated repository stops `R CMD check` at
   the incoming-feasibility step (S20). Run it from a scratch folder (`CLAUDE.md`), and count a check only if
   `00check.log` ends with a `Status:` line.
2. **`devtools::check()` sets `NOT_CRAN=true`.** A CRAN-mode timing needs it unset; section 2.1 ran `R CMD check`
   and `test_dir()` with it unset.
3. **Local timings carry the machine's load.** Record `uptime` with every timing; compare two timings only under
   similar load. Section 2.1's were taken at load 5-12.
4. **A source-tree timing is not the check's timing.** Time in the installed layout, as section 2.1 did.
5. **`skip_on_cran()` hides a test from CRAN, not from CI**, which sets `NOT_CRAN=true`; keep every export tested
   on CRAN (17k).
6. **`_R_CHECK_DEPENDS_ONLY_` cannot hide R's own library:** 7 of the 9 Suggests are there (section 2.3).
7. **A copied tree runs its `.Rprofile`:** set `RENV_CONFIG_AUTOLOADER_ENABLED=false` (S31's gotcha too).
8. **win-builder's reading spreads:** 284-617 s for nearly the same code in nprcgenekeepr; upload again before
   acting on one reading near the target.

pedkindraw's own:

9. **No spelling dictionary on this Mac**, so local checks never run the incoming spelling step (section 2.2); use
   the `spelling` package.
10. **A URL in the package that does not answer grows R16's NOTE**: the website must answer at every check and at
    submission, and CRAN's own page for pedkindraw is a 404 until acceptance, so no CRAN link or badge before 17q.
11. **pkgdown publishes every root `.md` but README, NEWS and LICENSE** (S31); `cran-comments.md` is the
    exception it skips. Any other new root `.md` needs the site workflow's delete line (`.github/workflows/pkgdown.yaml`).
12. **A push beyond `CLAUDE.md` and `methodology/**` starts both workflows** (15-18 min and 3 min).
13. **The suite gate counts warnings, not failures** (`methodology/.quality-gates.json`): tally "0 failed" by hand.
14. **nprcgenekeepr moves during a session** (Learning 15): its S1178 committed six times during S32.
15. **A rename is a divergence**: the drift tool lists every renamed copied function until its row exists (17c).

---

## 10. Out of scope

- Any change to nprcgenekeepr (R8): the R81 port, removing its stale S1159 line, its edition-3 conversion and the
  vacuous test are for sessions Mark starts there.
- Copying the colony overview; `findPedigreeNumber()`'s speed; the drift tool's constants; the methodology tools'
  items (section 3).
- New features, unless 17f's D4 adds a gap's closing by ruling.
- Reverse dependencies: none (a new package).
- nprcgenekeepr using pedkindraw (the standalone plan's "Later, optional").

## 11. Sources

- pedkindraw: `docs/planning/standalone-pedigree-package-plan.md` (R16, R37, R77, R79, R81, R82, Phase 16's
  records), `docs/planning/pedkindraw-api-contract.md` (sections 4, 6, 10), `docs/planning/documentation-plan.md`
  (section 7), `methodology/BACKLOG.md` (as at `ba811e7`), `DIVERGENCE.md`, `CLAUDE.md` (Build / Test / Verify,
  Learnings 11, 15, 18, 19).
- nprcgenekeepr at `363137511`: `docs/planning/cran-3.0.0-submission-plan.md` (sections 1, 3.2, 5 Phases 8-10, 6,
  7, 8), `BACKLOG.md` (the drift-watch item), `methodology/ROADMAP.md`, `NAMESPACE`, `git log baef1e12c..HEAD`.
- Measured this session, scratch only (not committed): the check log and `pedkindraw-Ex.timings` (section 2.1), the
  per-file test times, the spelling run, the name and call-site counts, the copied files' commit counts.
