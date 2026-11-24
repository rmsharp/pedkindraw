# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77); 17h DONE (S79-S84, R154-R158). **17i1 DONE in S85 (R159):** the speed vignette,
`vignettes/speed.Rmd` ("Speed and size limits", no code, 8 tables, 1,218 cells, a definition of each of the 38
computations), checked cell for cell, captions and prose numbers included, by `tools/checkSpeedTables.R` (with
`tools/timing/speedTables.R`, base R only), which `.github/workflows/speed-tables.yaml` runs on Linux; a NEWS
"Documentation" bullet. Installed 4,732 KB of 5,120; `R CMD check --as-cran` R16's NOTE only. No `R/` change.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`); S85's push changes
package files, so it ran (see the CHANGELOG's S85 push entry for what S85 did with it).
**Next, recommended: 17i2** (timing plan `:633`, the split note under it; R159 `docs/planning/standalone-pedigree-
package-plan.md:335`; backlog `:36`), strict TDD, docs tests first: the pointers to `vignette("speed")` from
`?pedkindraw`'s "Getting started" (`R/pedkindraw-package.R:52`), `vignettes/pedkindraw.Rmd:407` ("Where next"),
`vignettes/drawing.Rmd:794` ("How large a drawing can be", its S75 times kept) and `:808` ("Where next"); T5's sentence
in `?drawPedigreeDiagram` naming the measured size (R159: 1,000 animals 16 s, 2,000 past 120 s; readable up to 1,000
zoomed in) and the vignette; the contract's section 7 rows (`docs/planning/pedkindraw-api-contract.md:323`, a
"pedkindraw, measured" figure in each from the tables) and section 8's row (`:343`, then true); the site's third
article (pkgdown lists every vignette; check https://rmsharp.github.io/pedkindraw/articles/). Effort S-M, a guess.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17i2 (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (31 items,
each found at its line by `grep -n '^- \[ \]'` at S85's close-out; every item after `:36` moved 5 lines): READY, the
legend's labels in a narrow drawing (`:79`), the drawing vignette's measured trait (`:89`), a twins table with no rows
(`:95`), `savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:105`), the `smallPed` fixture (`:138`),
rewording `DIVERGENCE.md`'s older rows (`:61`), tests for full coverage (`:144`), `findPedigreeNumber()`'s speed
(`:300`), poppler in CI (`:316`), the label counts in `largeIds` (`:293`), and the eight "Ready, small" items (`:221` the
suite gate's time limit, `:233` the stale pedkindraw 0.0.1, `:240` the drift tool and copied constants, `:249` the
context-budget tool, `:259` CI notices, `:276` report a vacuous test, `:282` tell nprcgenekeepr's edition-3 conversion,
`:335` tell nprcgenekeepr its timing rows' `started` is each run's end); NEEDS DECISION, Pedixplorer's `avail`
(`:114`), long names at the edges (`:122`), a colony's ids under a point high (`:131`), `findGeneration(alignMates =
TRUE)`'s speed (`:306`), `HANDOFFS.md`'s growth past its trimmer (`:326`); "Waiting on Mark", the dashboard and
`methodology/BACKLOG.md` (`:184`), copying the colony overview (`:191`), the app's features left for later (`:198`), an
animal with two mates drawn once (`:210`). `:36` is 17i2 itself. BLOCKED, so not offered: `:70` (retire the drift
tools), `:178` (N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options,
so group them and name each in a preview).
**Session boundary:** one session (17i2), then close out.
**Priority:** HIGH (17i2, then 17j-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S85 changed no file under `R/`);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at `3e06730c5`, tree clean, through S85.
2. **S85's push** ran CI (package files changed; the close-out 2 commit has no `[skip ci]`): read `gh run list`
   against the CHANGELOG's S85 push entry, especially `speed-tables.yaml`'s first run and pkgdown's (the site's third
   article).
3. **17i2, if picked:** read the timing plan's 4.3 (`:310`), 4.4 (`:324`), the 17i section and its split and Done
   notes (`:633`), T5 (`:680`) and dragons 36-39 (`:792`); R159 (standalone plan `:335`). Measure before the RED gate
   (Learning 17): the words each pointer and the help sentence will say, and each docs test run against a scratch copy
   both ways (S85's way: `git archive HEAD | tar -x -C <scratch>`, drafts in, the test file run with renv's library).
   The help sentence edits roxygen in `R/drawPedigreeDiagram.R` (its `@return` is at `:178`; a new paragraph before
   it, a guess at the place), then `roxygen2::roxygenise()` writes `man/drawPedigreeDiagram.Rd`; a docs test reads it
   with `.docsText("man", "drawPedigreeDiagram.Rd")`.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **17i2's help sentence moves `R/`'s tree** from the timed `ac123b7` with no code change (R159): record it for 17n
  (timing plan's amendments, after 17i). The page's records table names the tree the records timed, not the current one.
- **Every number in `vignettes/speed.Rmd`'s prose is checked** (dragon 36): a new sentence there may quote only table
  numbers or `speedMethodNumbers()` (`tools/timing/speedTables.R:137`); run `Rscript tools/checkSpeedTables.R` after
  any edit to the page. The pointers and the help sentence are in other files: their docs tests hold their numbers.
- **A docs test of a file you create must fail, not skip, when it is missing** (dragon 37): `.docsText()` skips.
- **The page's failure words are "time", "memory", "error", "crash" and "not timed"** (S85, Mark's RED pick), not the
  old draft's "refused"; the plans' R157 still call Pedixplorer's alignment error a refusal.
- **`tools/checkSpeedTables.R` finds the project from its own path** (its `--root` defaults to the folder above
  `tools/`), so it runs from any folder; `--print=<name>` or `--print=all` gives a table as the page must hold it.
- **CRAN rebuilds vignettes** (dragon 6): `speed.Rmd` runs no code; a docs test checks it has no chunk.
- **A push that changes package files runs CI**, and the Windows job hangs (`:11`). GitHub runs no workflow when the
  pushed head commit's message says `[skip ci]`.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS`, `R_LIBS_USER` set to renv's library; the
  5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a
  `git archive` copy); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj`
  untracked, Mark's; `methodology/HANDOFFS.md` past its trimmer (backlog `:326`): keep the receipt short.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- The page and its check: `vignettes/speed.Rmd` (435 lines; markers `<!-- speed-table: <name> -->`),
  `tools/checkSpeedTables.R` (the command), `tools/timing/speedTables.R` (`:22` the 78 cases' names and functions,
  `:110` the 11 drawings', `:137` the method numbers, then the tables, the comparison and the prose check), the tests
  `tools/timing/tests/test_checkSpeedTables.R` and `tests/testthat/test_speedVignetteDocs.R`,
  `.github/workflows/speed-tables.yaml`.
- The pointers' places: `R/pedkindraw-package.R:52`, `vignettes/pedkindraw.Rmd:407`, `vignettes/drawing.Rmd:794` and
  `:808`; T5's: `R/drawPedigreeDiagram.R:178` (`@return`); the contract `docs/planning/pedkindraw-api-contract.md:323`
  (section 7), `:343` (section 8's drawing row); the docs-test helpers `tests/testthat/helper-docs.R:13`-`:44`.
- The plans: `docs/planning/pedkindraw-timing-plan.md` (`:310` 4.3, `:324` 4.4, `:633` 17i with its split and Done
  17i1, `:680` T5, `:684` dragons, `:792`-`:807` dragons 36-39); R159 at
  `docs/planning/standalone-pedigree-package-plan.md:335`; `docs/planning/cran-submission-plan.md:775` (17i).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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
**Not run:** the site's third article (17i2 checks it after the push's pkgdown run).

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

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the scope picker from measurements; R159 recorded in its session; every
  test run both ways in a scratch copy before RED (Learning 18), so RED and GREEN came out as predicted; four prose
  claims nothing measured taken out before RED (nprcgenekeepr's drawing "about as long", "no ids at the fitted view",
  placeholder parents in the computations, "every synthetic colony" for Pedixplorer's error); the prose check, on its
  first run, named four numbers I had not listed; the check repeated on the final commit; REFACTOR proven identical.
- **Slips:** GREEN's first commit carried an overstated sentence ("about twice as long", true of one save of three)
  and two unwrapped lines, so GREEN 2 and a second `R CMD check`; before RED, three test-draft errors (a row pattern
  matching two tables, `Pedixplorer::ancestors` passed to `lapply()`, the script's root defaulting to the working
  folder) and kinship2's X-chromosome label written "x", each caught by a run.

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

### What Session 83 Did
**Deliverable:** Phase 17h3, the drawing harness (`docs/planning/pedkindraw-timing-plan.md:564`), strict TDD: a copy of
nprcgenekeepr's drawing-timing files into `tools/timing/`. No `R/` change. DONE.
**Started:** 2026-11-23 23:26 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "17h3: drawing harness (Recommended)" (orient); R157's four in one picker ("3,600 x 1,500", "Default 10-inch
page", "As the study", "Only the 4 helpers"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR
(Recommended)". No correction and no tool use declined.
**Commits:** claim `95c75ff`; R157 `46d8a23`; RED `4ed5c8e`; GREEN `c7d6f89`, `701d4f4`; REFACTOR `7d57adc`; close-out 1
`2499b6e` (the plans, roadmap); close-out 2 (the backlog, these notes, the receipt, the ledger), pushed after it.
**Measured first:** the T2 probe (single calls from `PKD_LIB` on the 300 and 1,000 colonies and the sample: the page in
Chrome at 3,600 x 1,500 and 1,920 x 1,080, the SVG, PDF and PNG saves on each page); Pedixplorer's refusal of the 300
colony here; the label sizes `pedixplorerPlotData()` takes; then every RED test against a scratch draft of the code (40
of 40, 249 expectations) and without it (40 of 40 failing for the right reason).
**Found before RED:** the plan's copy list brings `drawingCapture.R`'s capture functions, whose test needs
`drawingTrace.R` and two data files, though the timing calls only its four Pedixplorer helpers (R157 copies those);
the plan's DONE ("every case ok at 300") cannot hold, Pedixplorer's alignment refusing the colony (R157 amends it).
**Verified:** RED 169 tests, the 40 new failing (35 on a missing function, 5 on the missing `drawOne.R`), 129 passing,
SKIP 0; GREEN and REFACTOR `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 1468 ]`, 169 tests; each copy's `diff` against its source
only the hunks its header names; the trial at 300 (17 min; 9 of 11 and 11 of 11; every DONE criterion checked by script,
the plan's Done note); REFACTOR's before-and-after record identical (two before-runs identical first); lint 0; no file
under `R/`, `DESCRIPTION` or `NAMESPACE` changed; quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results
534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s), so the package suite by hand
on a git archive of `2499b6e` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]` (1,146 tests, 596 s).
**Not run:** the drawing record (17h4).

#### Session 82 Handoff Evaluation (by Session 83)
**Score: 9/10.** ROI high: 17h3 ran from its notes, and the reading list put me on the right sections first time.
- **What helped:** What You Must Do 1's commands (drift 91/23/0, nprcgenekeepr's 4 commits, the harness log empty), each
  as stated; 3's reading list by line (17h3 `:562`, 4.1 `:275`, 5.1 `:353`, T2 `:606`, dragons 7, 9, 12) and "measure
  before the T2 picker", which became the probe whose counts Mark picked from; the `PKD_LIB` path and its build; "run
  the test folder alone"; "read the CSVs with R".
- **What was missing:** that 4.1's copy list overreaches (`drawingCapture.R`'s test needs `drawingTrace.R` and data
  files) and that 17h3's DONE cannot hold at 300: both S78's, carried forward, found only by reading the source and the
  study's `drawingTiming.csv`.
- **What was wrong:** nothing in S82's own claims.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; T2 measured by a 33-call probe before the picker, so Mark picked from
  counts; two plan gaps found from the source before RED and put to Mark, not decided alone; every RED test run against
  a scratch draft both ways before the RED gate (Learning 18), so RED and GREEN each came out as predicted first time;
  the copies proved by `diff`, the trial by a script over its files, the REFACTOR by a deterministic before-and-after
  record; a too-small figure (`pkd_data`'s 1 ms) checked outside the harness before it was written down.
- **Slips, none reaching a commit:** I edited draft files while the draft test run was reading them (failure mode #29;
  that run was set aside and rerun clean); I wrote "about 7 minutes" for the test folder before measuring and reworded it
  to what was measured before the commit; the first draft had 5 lints (`options()`, two joined expectations) and a test
  reading a git-ignored data file, each caught before RED; the GREEN gate's "30-50 minutes" trial guess was 17.
