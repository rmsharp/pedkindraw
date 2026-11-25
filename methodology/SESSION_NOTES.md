# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17i DONE (S33-S86); the gap
phases G1-G17 DONE (S42-S77). **17j is in two (R161): 17j1 DONE (S87).** covr (`type = "tests"`, `NOT_CRAN=true`)
read 40 of 3,772 statements never run at `a423bcf`; S87 took the 11 outside `R/makePedigreeDiagramData.R`: new tests
in pedkindraw's own files reach 9 (`R/positionTreeApportion.R`'s six argument checks, `R/shrinkPedigree.R:306`,
`R/comparePedigreeStructure.R:160`, `R/savePedigreeDiagram.R:338`), each shown to fail on a copy with its statement
broken (11 of 11), and `R/orderRootSubtrees.R:118` and `:131` are recorded unreachable and kept as copied. At
`af4f23b`: 31 of 3,772 left (99.18%). No `R/` file changed. **Open, not fixed:** the Windows job whose check step
does not end (`methodology/BACKLOG.md:11`).
**Next, recommended: 17j2, `R/makePedigreeDiagramData.R`'s 29** (backlog `:119` lists them by line and function;
the cran plan's Phase 17j, `:793`, its split note; dragons 29-30 at `:1040` and `:1046`). 20 are in
`.addRectilinearWaypoints()` (`:2911`). 16 of the 29 (`:1581`, `:2981`, the dogleg's `:3032`-`:3059` and
`:3116`-`:3120`) the code's comment at `:1517` or S87's reading calls unreachable from a drawing: not proved. A
direct call with a hand-built input (as R161 chose for `:160`) may reach the dogleg: put that to Mark in the
pre-RED picker, with counts. DONE: every statement reached or recorded unreachable with its reason; the new tests'
CRAN-mode time recorded for 17k. Then 17k (a win-builder reading; Mark approves the upload).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17j2 (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (30 items,
each found at its line by `grep -n '^- \[ \]'` at S87's close-out; S87 shortened the 17j item, so every item after
`:119` moved up 10 lines): READY, rewording `DIVERGENCE.md`'s older rows (`:36`), the legend's labels in a narrow
drawing (`:54`), the drawing vignette's measured trait (`:64`), a twins table with no rows (`:70`),
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:80`), the `smallPed` fixture (`:113`),
`findPedigreeNumber()`'s speed (`:265`), poppler in CI (`:281`), the label counts in `largeIds` (`:258`), and the eight
"Ready, small" items (`:186` the suite gate's time limit, `:198` the stale pedkindraw 0.0.1, `:205` the drift tool and
copied constants, `:214` the context-budget tool, `:224` CI notices, `:241` report a vacuous test, `:247` tell
nprcgenekeepr's edition-3 conversion, `:300` tell nprcgenekeepr its timing rows' `started` is each run's end); NEEDS
DECISION, Pedixplorer's `avail` (`:89`), long names at the edges (`:97`), a colony's ids under a point high (`:106`),
`findGeneration(alignMates = TRUE)`'s speed (`:271`), `HANDOFFS.md`'s growth past its trimmer (`:291`); "Waiting on
Mark", the dashboard and `methodology/BACKLOG.md` (`:149`), copying the colony overview (`:156`), the app's features
left for later (`:163`), an animal with two mates drawn once (`:175`). `:119` is 17j itself. BLOCKED, so not offered:
`:45` (retire the drift tools), `:143` (N3). Name every item in the picker (memory "Picker sets: name items, include
all"; at most 4 options, so group them and name each in a preview).
**Session boundary:** one session (17j2), then close out.
**Priority:** HIGH (17j2, then 17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S87 changed tests only, and `git diff
   af4f23b HEAD -- R/` is empty); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at
   `3e06730c5`, tree clean, through S87.
2. **Read S87's push** (the CHANGELOG's S87 push entry, written at close-out 2b): `tests/` changed, so CI ran;
   expect `FAIL 0 | WARN 0` on Linux and macOS (PASS about 33 more than S86's runs where the browser tests run) and
   Windows's hang (`:11`).
3. **17j2, if picked:** read backlog `:119`, the cran plan's 17j split note and dragons 29-30, and R161
   (`docs/planning/standalone-pedigree-package-plan.md:339`). No covr re-run is needed first while `R/` is unchanged
   since `af4f23b` (check with `git diff --stat af4f23b HEAD -- R/`). For each of the 29: read the comment beside it,
   find the input that reaches it (`makePedigreeMatingLayout()`, or a direct call; the copied tests build the
   internals' inputs with `.buildLayoutAndForest()`, `tests/testthat/test_addRectilinearWaypoints.R:36`), confirm
   with covr, and break the statement three ways in a throwaway copy (dragon 29). Measure before the pre-RED picker
   (Learning 17). S87's methods, in words (the scratch scripts are gone): covr on a `git archive` copy,
   `covr::package_coverage(pkg, type = "tests", quiet = TRUE)` with `NOT_CRAN=true` (12.7 min); a quick reach check,
   `covr::package_coverage(pkg, type = "none", code = c('Sys.setenv(NOT_CRAN = "true")', 'library(testthat)',
   'testthat::test_file("<absolute path>", package = "pedkindraw", load_package = "installed", reporter =
   "silent")'))` (about 2 min); a broken copy, `cp -R` the tree, `sed -i '' '<line>s/<old>/<new>/' R/<file>`, then
   `pkgload::load_all()` and `testthat::test_file()` on the test file.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").
   Under R161, tests of code already written pass at once: RED commits them with the broken-copy proof, GREEN writes
   no code and re-measures (an empty commit), REFACTOR if a concrete tidy-up exists.

### Gotchas
- **A test of code already written can pass for the wrong reason** (dragon 29): S87's first `:338` test passed with
  the error swallowed, since jsonlite stopped later. Break each statement replaced, swallowed and made another error.
- **Edition 3's `expect_error(regexp)` passes a non-matching error through**, so a broken copy reads "errors 1", not
  "failed 1": count both.
- **`testthat::test_file(desc = "...")` runs one test** by its whole description, the line break and indentation
  included (S87's `:338` proofs: 2 s, not the file's 140 s).
- **covr's saved result:** `library(covr)` before `as.data.frame()` of a `readRDS()`'d result, or it stops "cannot
  coerce class 'coverage'".
- **The browser tests print `got non-close frame while closing` on stderr** (chromote): HEAD's
  `test_savePedigreeDiagram.R` printed 9 in one run; not a test warning (WARN 0).
- **The browser tests skip on CRAN** (`.skipUnlessBrowser()`), so `:338` is reached only with `NOT_CRAN=true`; measure
  coverage that way.
- **A push that changes package files runs CI**, and the Windows job hangs (`:11`): cancel it at 40 minutes. GitHub
  runs no workflow when the pushed head commit's message holds the skip marker anywhere: when the push should run
  CI, write "the skip marker" in words.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the
  5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a
  `git archive` copy); `CLAUDE.md` is over its budget (learnings go to the plans' dragons; the cran plan's section 9
  now ends at 30); `pedkindraw.Rproj` untracked, Mark's; `methodology/HANDOFFS.md` past its trimmer (`:291`): keep
  the receipt short.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17j1's tests: `tests/testthat/test_positionTreeApportionChecks.R`, `tests/testthat/test_shrinkPedigreeLoop.R`,
  `tests/testthat/test_comparePedigreeStructureOneMate.R`, `tests/testthat/test_savePedigreeDiagram.R:606` (the
  refused page); `tests/testthat/helper-savePedigreeDiagram.R:64` (`.saveStubRecording()`, S87's REFACTOR).
- 17j2's code, `R/makePedigreeDiagramData.R`: `.buildMatingUnitForest()` `:656`, `.packComponents()` `:986`,
  `.positionMatingUnitForest()` `:1109` (the comment `:1515`-`:1521`), `.addRectilinearWaypoints()` `:2911` (the D2
  dogleg `:3017`-`:3062`), `.arcDiscHitCount()` `:3257`, `.resolveEdgeNodeCollisions()` `:3393`.
- The plans: `docs/planning/cran-submission-plan.md:793` (17j and its split note), `:827` (17k), `:1040`-`:1052`
  (dragons 29-30); R161 at `docs/planning/standalone-pedigree-package-plan.md:339`; backlog `:119`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 87 Did
**Deliverable:** Phase 17j1 (R161's split of 17j, `docs/planning/cran-submission-plan.md:793`), strict TDD: tests for
the statements no test ran outside `R/makePedigreeDiagramData.R`. DONE.
**Started:** 2026-11-24 15:52 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17j: coverage tests (Recommended)" (orient); "5 small files now (Recommended)" (scope); R161's
three in one picker ("Prove on broken copies", "Keep, record why", "Hand-edited layout test"); "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `a423bcf`; R161 `5bb45cb`; RED `af4f23b`; GREEN `b93f508` (empty: the measurements); REFACTOR
`d1414b9`; close-out 1 `0564a34` (the plans, roadmap, dragons 29-30); close-out 2 (the backlog, these notes, the
receipt, the ledger), pushed after it.
**Measured first:** covr on a `git archive` of `a423bcf` (40 of 3,772, 12.3 min); each of the 40 read and sorted;
for the 11 in scope, each input tried in a scratch copy, the reach confirmed by covr running only the drafts, and each
draft broken three ways where it mattered (`:338`'s first draft passed with the error swallowed, so it was tightened
before the gate); `:118` and `:131` proved unreachable by reading, by the suite's counts and, for `:131`, a scratch
call with a `childrenOf` that changes its answers (it reaches `:131`; an honest one does not). Then the pickers.
**Verified:** RED's four files 39 tests, 250 expectations, 0 failed, 0 skipped, WARN 0, and 11 of 11 broken copies of
the RED tree failing, each one line apart from it; covr on `af4f23b` 31 of 3,772 (99.18%), the 9 reached; the full
suite on a `git archive` of `af4f23b` (`NOT_CRAN=true`) 97 files, 1,169 tests, 17,026 expectations, 0 failed, 0
skipped, WARN 0 (594 s); `R CMD check --as-cran` on `af4f23b` Status 1 NOTE (R16's), tests 190 s in CRAN mode,
installed size OK; CRAN mode, the new tests about 0.2 s; REFACTOR's stubs `identical()` to the old ones, the file 32
tests and 222 expectations as at GREEN, the three `:338` copies still failing; lint 0; no saved expect condition;
drift and `R/` unchanged; quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand
above).

#### Session 86 Handoff Evaluation (by Session 87)
**Score: 9/10.** ROI high: 17j1 ran from its notes, and every cited line and count was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0, nprcgenekeepr's 4 commits and `3e06730c5`, each as stated);
  3's "re-measure first" with the command, "a guess of 15-30" min labelled as one (covr took 12.3), "new tests go in
  pedkindraw's own test files" and the gotcha "17j's statements are in copied files", which set the test files'
  place before any picker; the orient picker's 30 items, each at its line; the `Rscript --no-init-file` gotcha, used
  in every run.
- **What was missing:** whether S24 ran covr with `NOT_CRAN=true` (not recorded, so the 43 is compared, not matched);
  how RED applies when the tests reach code already written (found by search: dragon 39 of the picture plan); that
  the copied layout code labels its own branches "structurally unreachable" (`:1517`), which shaped the split.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; covr before the first picker, and the scope picker with counts; each
  input tried, each reach confirmed by covr and each test proved on broken copies before RED (Learnings 17-18, dragon
  39); R161 recorded in its session; GREEN's suite read 17,026 as predicted; the REFACTOR measured before its gate;
  the backlog item cut from 28 lines to 18 (FM #28).
- **Slips, none reaching a commit:** the first `:338` draft could not tell Chrome's error from a later one (caught by
  my own broken copy; dragon 29); a draft comment named Chrome 158 where this Mac has 157; the RED gate's preview
  said the headers name R161 when the drafts did not (fixed before the copy); a first layout trial left out the `gen`
  column; `as.data.frame()` of a saved covr result without `library(covr)`.

### What Session 86 Did
**Deliverable:** Phase 17i2 (`docs/planning/pedkindraw-timing-plan.md:633`, R159), strict TDD: the pointers to
`vignette("speed")`, T5's section in `?drawPedigreeDiagram`, the API contract's sections 7 and 8. DONE, so 17i DONE.
**Started:** 2026-11-24 14:30 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17i2: point to speed page (Recommended)" (orient); R160's four in one picker ("Own section",
"Keep it, add ours", "New last column", "Add one sentence"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
REFACTOR (Recommended)". No correction and no tool use declined. Mark asked mid-session why the installed size
(4,736 KB) differs from the tarball (1.6 MB): answered from measurements (dragon 42).
**Commits:** claim `88ce5b5`; R160 `271e10f`; RED `f8bdbe3`; GREEN `4940df9` (help), `6931e95` (vignettes, NEWS); the
contract `0c537c8`; REFACTOR `5ad8294`; close-out 1 `113572b` (the plans, roadmap, dragons 41-42); close-out 2 (the
backlog, these notes, the receipt, the ledger), pushed after it.
**Measured first:** every word drafted in a scratch copy (`git archive HEAD`), roxygen run there, the 6 new tests
run on `dfbd587`'s files (6 of 6 failing, 0 skipped) and on the drafts (6 of 6 passing), the 27 existing docs tests
passing, lint 0; then the pre-RED picker. The REFACTOR the same way before its gate.
**Verified:** RED 6 of 6 failing, 0 skipped, each on its missing words; GREEN 46 expectations passing; the full suite
on a `git archive` of `6931e95` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16993 ]` (597 s); `R CMD check
--as-cran` on `6931e95` Status 1 NOTE (R16's), installed 4,736 KB, the built `drawing.html` holding the pointer;
`drawPedigreeDiagram.R`'s parsed code identical to before; `tools::checkRd()` clean, the section rendered by
`Rd2txt()`; roxygen unchanged; lint 0; drift 91 / 23 / 0; `tools/checkSpeedTables.R` 0 problems; the contract's 30
figures each equal to its cell; REFACTOR's 33 docs tests identical per test (212 expectations); quality_ratchet 5/6
pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand above).
**CI (close-out 2b):** pushed `dfbd587..58aa09e`; pkgdown `success`, the site's three articles and every new word on
it; R-CMD-check Ubuntu release, oldrel-1 and macOS Status OK, `FAIL 0 | WARN 0` (SKIP 15 more than S77's run: the
speed docs tests, which skip without `vignettes/`); Windows's tests `FAIL 0` then the hang (cancelled at 40 min);
Ubuntu devel failed installing S4Vectors on R-devel, before pedkindraw (backlog `:234`, as since S48).

#### Session 85 Handoff Evaluation (by Session 86)
**Score: 9/10.** ROI high: 17i2 ran from its notes, and every cited line was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0 and nprcgenekeepr's 4 commits, each as stated); 3's reading
  list by line (4.3 `:310`, 4.4 `:324`, 17i `:633`, T5 `:683`, dragons `:795`) and the pointer places by line
  (`R/pedkindraw-package.R:52`, `vignettes/pedkindraw.Rmd:407`, `vignettes/drawing.Rmd:794` and `:808`, the contract
  `:323` and `:343`), all exact; "measure before the RED gate, S85's way", which became R160's picker; the gotchas
  "the help sentence moves `R/`'s tree" (17n's amendment) and the skip marker (applied at the push).
- **What was missing:** that `test_runPedigreeAppDocs.R` already holds the drawing vignette's "How large a drawing
  can be" and forbids "about 16 seconds" there (a pointer quoting the speed page's 16 s that way would fail it); that
  `.docsRdSection()` lived in a test file, not `helper-docs.R`; that the cran plan's status still read "Next: 17i".
  Each found by grep, none costly.
- **What was wrong:** nothing found ("a new paragraph before `@return`" was labelled a guess; a section before
  `@param` was chosen).
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every word and test drafted and run both ways in a scratch copy before
  the first picker (Learning 17), so RED, GREEN and REFACTOR each came out as predicted; R160 recorded in its
  session; the help's numbers held to the page by the test, not typed; the contract's figures proved cell by cell;
  the full suite and `R CMD check` on the GREEN commit; Mark's size question answered from measurements, not memory.
- **Slips, none reaching a commit:** a draft edit joined two roxygen lines into one of 119 columns (caught by a
  length check in the scratch copy); the first contract script asserted on a separator that is not unique (it wrote
  nothing; rerun); my failure-reason script stopped on passing tests; one `Rscript --no-init-file` run without renv's
  library; the first check of the contract's numbers (each anywhere in the tables) was too weak, replaced by a
  cell-keyed check before the commit; the REFACTOR's rename misaligned continuation lines (fixed in the scratch copy).

### What Session 85 Did
**Deliverable:** Phase 17i1 (R159's split of 17i, `docs/planning/pedkindraw-timing-plan.md:633`), strict TDD: the
speed vignette and its check script, its NEWS line and CI workflow. DONE.
**Started:** 2026-11-24 12:13 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, each the
recommended option):** "17i: speed vignette (Recommended)" (orient); R159's three in one picker ("Script and page
first", "Help sentence", "Small Linux-only workflow"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `3874d69`; R159 `3100482`; RED `2e40ecb`; GREEN `4a7cfe9`, GREEN 2 `8656768`; REFACTOR `2e7dda9`;
close-out 1 `a89868c` (the plans, roadmap, dragons 36-39); close-out 2 (the backlog, these notes, the receipt, the
ledger), pushed after it.
**Measured first:** the installed size from a fresh build (4,592 KB); the draft `612eed9` rendered (61 KB); both
summaries printed; the places that state a time (none in `man/`); then the script, the page and both test files
drafted in a scratch copy and the tests run both ways (27 of 27 failing for the right reason, 0 skipped; 27 of 27
passing), lint 0.
**Verified:** RED 18 of 18 and 9 of 9 failing, 0 skipped; GREEN both files passing (151 and 85 expectations), WARN 0;
the script on R's own library only, exit 0, "8 tables, 1218 cells equal to the records; 66 numbers in the prose; 0
problems"; the full suite on a `git archive` of `4a7cfe9` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16947 ]`
(1,155 tests, 592 s); `R CMD check --as-cran` Status 1 NOTE (R16's: Maintainer, New submission) on `4a7cfe9` (286 s)
and again on `2e7dda9` (272 s), installed 4,732 KB; the page rendered: 8 tables, 8 captions, no raw Markdown; lint_package
0; roxygen unchanged; REFACTOR's output byte-identical on the page, `--print=all` and a copy with four planted problems;
quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s; the suite by hand above).
**Not run:** `R-CMD-check.yaml` on GitHub: the push ran no workflow (close-out 2's message quoted the skip marker,
dragon 40); `speed-tables.yaml` (first run) and `pkgdown.yaml` were started by hand, both green; the site lists
three articles, `articles/speed.html` with 8 tables.

#### Session 84 Handoff Evaluation (by Session 85)
**Score: 9/10.** ROI high: 17i1 ran from its notes, and every cited line was where it said.
- **What helped:** What You Must Do 1 (drift 91/23/0 and nprcgenekeepr's 4 commits, each as stated); 3's reading list
  by line (4.3 `:308`, 4.4 `:322`, 4.5 `:331`, 5.7 `:422`, 5.8 `:431`, 17i `:631`, T5 `:661`, dragons `:665`) and
  "measure before the pre-RED picker: the installed size, `612eed9`, the pages that state a time", which became the
  scope picker's counts; the gotchas "print them as not timed, never refused" (built into the script and a test),
  "what each drawing figure times" and "one slow run" (both on the page), "an `R/` change moves `R/`'s tree" (T5's
  option text), "CRAN rebuilds vignettes".
- **What was missing:** that the summaries print "refused" for every `error`, so the page's failure word needed a
  choice; that section 4.6's `git grep -E '...\b'` finds nothing here (dragon 38); that the computation cases give no
  placeholder parents (dragon 39). Each found by reading the code, none costly.
- **What was wrong:** nothing found in S84's own claims.
- **ROI:** high.

**Self-assessment: 7/10** (8 at close-out 2; lowered at 2b for the skip-marker slip below).
+ Orient in full, the claim before any work; the scope picker from measurements; R159 recorded in its session; every
  test run both ways in a scratch copy before RED (Learning 18), so RED and GREEN came out as predicted; four prose
  claims nothing measured taken out before RED (nprcgenekeepr's drawing "about as long", "no ids at the fitted view",
  placeholder parents in the computations, "every synthetic colony" for Pedixplorer's error); the prose check, on its
  first run, named four numbers I had not listed; the check repeated on the final commit; REFACTOR proven identical.
- **Slips:** GREEN's first commit carried an overstated sentence ("about twice as long", true of one save of three)
  and two unwrapped lines, so GREEN 2 and a second `R CMD check`; before RED, three test-draft errors (a row pattern
  matching two tables, `Pedixplorer::ancestors` passed to `lapply()`, the script's root defaulting to the working
  folder) and kinship2's X-chromosome label written "x", each caught by a run.
  Close-out 2's commit message quoted the skip marker while listing the gotchas, so the push that carried 17i1's
  package changes started no workflow; two were started by hand, but R-CMD-check has no manual start and waits
  for 17i2's push: a DONE surface (GitHub Actions) not reached by S85.
