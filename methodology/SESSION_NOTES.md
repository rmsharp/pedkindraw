# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17h DONE (S33-S84); the gap
phases G1-G17 DONE (S42-S77); **17i DONE (S85-S86, R159-R160).** S86 did 17i2: `?pedkindraw`'s "Getting started",
the pedkindraw vignette's "Where next", the drawing vignette's "How large a drawing can be" and "Where next", and NEWS
point to `vignette("speed")`; `?drawPedigreeDiagram` has a section "How large a drawing can be" (1,000 animals 16 s,
2,000 more than 120 s, direct lines 2,000 in 106 s, readable up to 1,000 zoomed in), its numbers held by a test to the
speed page's tables; the contract's section 7 has a "pedkindraw, measured" column and section 8 holds. Installed
4,736 KB of 5,120; `R CMD check --as-cran` R16's NOTE only; the full suite 16,993 passing. **Open, not fixed:** the
Windows job whose check step does not end (`methodology/BACKLOG.md:11`).
**Next, recommended: 17j, tests for full coverage** (`docs/planning/cran-submission-plan.md:793`; backlog `:119`):
re-measure with `covr::package_coverage(type = "tests")` (last S24 on `bcdc1b0`: 97.96%, 43 of 2,501 missed, all in
copied files, listed by file and line at backlog `:119`; `R/` changed since in S28 and 17c-17i), then a test in
pedkindraw's own test files for each statement missed, working out what input reaches it before calling it unreachable
(Learning 11). One or two sessions (the plan's guess); split by file if one cannot take them all. DONE: every statement
reached, or shown unreachable with its reason recorded, and the new tests' CRAN-mode time recorded for 17k.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17j (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (30 items,
each found at its line by `grep -n '^- \[ \]'` at S86's close-out; S86 removed the speed vignette item, so every item
after `:36` moved up 25 lines): READY, rewording `DIVERGENCE.md`'s older rows (`:36`), the legend's labels in a narrow
drawing (`:54`), the drawing vignette's measured trait (`:64`), a twins table with no rows (`:70`),
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:80`), the `smallPed` fixture (`:113`),
`findPedigreeNumber()`'s speed (`:275`), poppler in CI (`:291`), the label counts in `largeIds` (`:268`), and the eight
"Ready, small" items (`:196` the suite gate's time limit, `:208` the stale pedkindraw 0.0.1, `:215` the drift tool and
copied constants, `:224` the context-budget tool, `:234` CI notices, `:251` report a vacuous test, `:257` tell
nprcgenekeepr's edition-3 conversion, `:310` tell nprcgenekeepr its timing rows' `started` is each run's end); NEEDS
DECISION, Pedixplorer's `avail` (`:89`), long names at the edges (`:97`), a colony's ids under a point high (`:106`),
`findGeneration(alignMates = TRUE)`'s speed (`:281`), `HANDOFFS.md`'s growth past its trimmer (`:301`); "Waiting on
Mark", the dashboard and `methodology/BACKLOG.md` (`:159`), copying the colony overview (`:166`), the app's features
left for later (`:173`), an animal with two mates drawn once (`:185`). `:119` is 17j itself. BLOCKED, so not offered:
`:45` (retire the drift tools), `:153` (N3). Name every item in the picker (memory "Picker sets: name items, include
all"; at most 4 options, so group them and name each in a preview).
**Session boundary:** one session (17j, or its first file group), then close out.
**Priority:** HIGH (17j, then 17k-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S86 changed help text in
   `R/drawPedigreeDiagram.R` and `R/pedkindraw-package.R`, the parsed code identical, and the tool read 91 / 23 / 0
   after it); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep
   -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at `3e06730c5`, tree clean, through S86.
2. **Read S86's push runs** (the CHANGELOG's S86 push entry, written at close-out 2b): R-CMD-check's first run on
   17i1's and 17i2's package changes, job by job; pkgdown's site (three articles; `?drawPedigreeDiagram`'s reference
   page with the new section).
3. **17j, if picked:** read the cran plan's 17j (`:793`) and 17k (`:803`) and backlog `:119` (S13-S24's lists by file
   and line). Measure before the pre-RED picker (Learning 17): `covr::package_coverage(type = "tests")` on a `git
   archive` copy with renv's library (its run time unknown here; the suite alone takes about 10 minutes, so a guess of
   15-30), the missed statements by file and line against S24's 43, and for each the input that reaches it, tried in
   a scratch run. New tests go in pedkindraw's own test files, not the copied ones (backlog `:119`); time them in CRAN
   mode (`NOT_CRAN` unset) for 17k.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **The help's drawing numbers are held to the speed page** (timing plan dragon 41): `test_speedPointersDocs.R`
  reads them from the page's `drawing-seconds` and `drawing-capacity` tables, so a change to those tables fails it
  until `?drawPedigreeDiagram`'s section "How large a drawing can be" says the same; the contract's 30 figures were
  checked by a script keyed on table, row and column (re-run it after a new record).
- **The docs-test helpers live in `tests/testthat/helper-docs.R`** (S86 REFACTOR): `.docsText()`, `.docsSection()`,
  `.docsRdSection()` (an Rd file's section), `.docsFlat()` (wrapped lines joined), `.docsAfter()`, `.docsSay()`; use
  them, do not write another copy.
- **Installed size 4,736 KB of 5,120** (dragon 42): `doc/` is 3,824 KB, the two drawing vignettes' JavaScript; a new
  vignette with a drawing would cost about 2 MB. The tarball's 1.6 MB is compressed and holds `tests/`, which is not
  installed: R77 counts the installed size.
- **17j's statements are in copied files** (backlog `:119`): their tests go in pedkindraw's own test files; a change
  to a copied file is a `DIVERGENCE.md` row (drift rule) or a pre-RED picker's ruling.
- **A push that changes package files runs CI**, and the Windows job hangs (`:11`): cancel it at 40 minutes. GitHub
  runs no workflow when the pushed head commit's message holds the skip marker anywhere (dragon 40): when the push
  should run CI, write "the skip marker" in words.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library
  (without them it stops at `pkgload`, and `tail -1` shows only "Execution halted"); the 5-file cap splits commits; the
  ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a `git archive` copy); `CLAUDE.md` is
  over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's;
  `methodology/HANDOFFS.md` past its trimmer (backlog `:301`): keep the receipt short.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17i2's: `R/drawPedigreeDiagram.R:170` (`@section How large a drawing can be:`), `R/pedkindraw-package.R:62`,
  `vignettes/pedkindraw.Rmd:413`, `vignettes/drawing.Rmd:807` and `:819`, `NEWS.md:470` (the speed bullet);
  `tests/testthat/test_speedPointersDocs.R` (`:22` `.speedTable()`, `:41` `.speedRow()`, `:86` the help's test);
  `tests/testthat/helper-docs.R:33` `.docsRdSection()`, `:43` `.docsFlat()`.
- The contract: `docs/planning/pedkindraw-api-contract.md:323` (section 7), `:335` (the last column's note), `:345`
  (section 8's drawing row).
- The plans: `docs/planning/cran-submission-plan.md:793` (17j), `:803` (17k); `docs/planning/pedkindraw-timing-plan.md`
  `:667` (Done 17i2), `:685` (17n's amendment: `R/`'s tree `3bab425`), `:831`-`:841` (dragons 41-42); R160 at
  `docs/planning/standalone-pedigree-package-plan.md:337`; backlog `:119` (17j's statements).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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
**Not run here:** R-CMD-check and pkgdown on GitHub until the push (close-out 2b records them).

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

### What Session 84 Did
**Deliverable:** Phase 17h4, the drawing record (`docs/planning/pedkindraw-timing-plan.md:599`): `runDrawingTiming.R`
over all 11 cases at 300, 1,000, 2,000, 3,000 and the sample, the results committed, the pages opened for Mark (T4).
No code. DONE.
**Started:** 2026-11-24 09:38 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "17h4: drawing
timings (Recommended)" (orient); "Up to 1,000 animals" and "Keep it, explained (Recommended)" (one picker, R158). One
correction: my "This one is a real result" implied other results were false (memory "Describe results by what they
measure"). No tool use declined.
**Commits:** claim `70d5021`; results `a4b41da`; R158 and the plans `2134e44`; close-out (the backlog, these notes, the
receipt, the ledger), pushed after it.
**Did:** read the machine (64% idle, three vitest workers at a full core each 13-21 h) and showed it in the orient
picker; the record in the background 09:38:53-11:14:27, its start checked (the `drawing` row, the first runs); each
cell read as it came; the 2,000 `time` of `pkd_page` set beside the study's `npg_widget` (15.46 s at 1,000, `time` at
2,000) before calling it expected; the 3,000 saves' `error` traced to `runLimited()`'s 300 s setup limit
(`timingHarness.R:287`) and put to Mark, not decided alone; the summary printed; two cells re-run from a fresh shell;
the pages opened in Chrome and the zoom-1 pictures in Preview only after the re-runs; R158; the plans, dragons 33-35.
**Verified (by a script over the files, `checkDrawingRecord.R` in the scratchpad, after it found 3 of 3 problems
planted in a changed copy):** 0 problems: every case a row per size up to and including its first failure, then the
sample; 33 `ok` cells, each the median of its 3 measured `ok` runs; idle 50.2-68.4% at each start, none under 50; 92
`ok` pedkindraw runs from `PKD_LIB`, no other run loaded it; each `started` plus `realSeconds` at or before the next;
40 of 40 page runs with browser seconds; no private path. Re-runs -0.4%, +1.1%, +1.7%, -6.3%. quality_ratchet 5/6
pass, 0 fail, 1 unmeasured (the suite gate's 300 s); the package suite by hand on a
`git archive` of `2134e44` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]` (1,146 tests, 593 s).
**Not run:** `R CMD check` (no package file changed).

#### Session 83 Handoff Evaluation (by Session 84)
**Score: 9/10.** ROI high: 17h4 ran from its notes.
- **What helped:** What You Must Do 1-3, each as stated (drift 91/23/0, the 4 commits, no harness change, the
  `PKD_LIB` path, the record's command, "check its start before leaving it", re-runs to `--out=<scratch>`, S83's trial
  check as the model for mine); the gotchas on the two Pedixplorer refusals, the plotly page's 30 s and `pkd_data`'s
  1 ms, which made three results expected rather than puzzles; "read the machine first and tell Mark".
- **What was missing:** that the save cases build their drawing before the clock inside `runLimited()`'s 300 s setup
  limit, so at 3,000 they would not reach their save (S83's trial ran 300 only, but `pkd_page`'s R time and the layout's
  growth hinted at it); that the cran plan guessed 17h4 at 1.2-1.5 h (`:758`) while dragon 26's 3.5-4.5 h was the only
  figure quoted (the record took 1.6 h).
- **What was wrong:** nothing found in S83's own claims.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the machine's load in the orient picker; the record's start checked;
  each failure explained from its row, the study's record or the harness's code before it was described; the 3,000
  saves put to Mark with the measured reason; the DONE checked by a script that was first shown to fail on planted
  problems; re-runs; nothing loaded the machine during the record or the re-runs; the moved citation (`:771` to
  `:775`) found and fixed before its commit (Learning 7).
- **Slips:** "This one is a real result" (Mark's correction; recorded in memory); I repeated dragon 26's 3.5-4.5 h
  guess without reading the cran plan's 1.2-1.5 h; a first `record.csv` query named a column that does not exist and
  printed nothing; a first draft of a dragon said "271.9 s a run" of a single warm-up, and the handoff a range ending
  at `:355`, both corrected before their commits.
