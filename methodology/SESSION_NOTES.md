# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77); 17h DONE: the computation harness and record (S79-S82, R154-R156, `14145a4`), the drawing
harness (S83, R157). **17h4 DONE in S84 (R158):** the drawing record, `a4b41da`: all 11 drawing cases at 300, 1,000,
2,000, 3,000 and the sample, 43 cells, 33 `ok`, 10 failed sizes, 1 h 36 min; pedkindraw's page drew 1,000 animals within
120 s (16.0 s), its direct-line page 2,000 (106 s); the SVG and PNG saves not timed at 3,000 (dragon 33); Mark judged
the pages readable up to 1,000 animals, zoomed in (T4). No package file changed.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Next, recommended: 17i, the speed vignette** (timing plan `:631`; `methodology/BACKLOG.md:36`, now READY): strict TDD
for the pointers and help; `vignettes/speed.Rmd` to section 5.8's outline (`:431`), its tables from
`tools/timing/results/`; `tools/checkSpeedTables.R` rewritten to read them (4.5 `:331`); the pointers (4.4 `:322`); the
contract's section 7 rows and section 8's claim (4.3 `:308`, T5 `:661`); a NEWS bullet; the site's third article.
Effort L (a guess); it may need splitting: put the scope to Mark before RED.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17i (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (31 items,
each found at its line by `grep -n '^- \[ \]'` at S84's close-out, the same lines as S83's): READY, the legend's labels
in a narrow drawing (`:74`), the drawing vignette's measured trait (`:84`), a twins table with no rows (`:90`),
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:100`), the `smallPed` fixture (`:133`), rewording
`DIVERGENCE.md`'s older rows (`:56`), tests for full coverage (`:139`), `findPedigreeNumber()`'s speed (`:295`), poppler
in CI (`:311`), the label counts in `largeIds` (`:288`), and the eight "Ready, small" items (`:216` the suite gate's
time limit, `:228` the stale pedkindraw 0.0.1, `:235` the drift tool and copied constants, `:244` the context-budget
tool, `:254` CI notices, `:271` report a vacuous test, `:277` tell nprcgenekeepr's edition-3 conversion, `:330` tell
nprcgenekeepr its timing rows' `started` is each run's end); NEEDS DECISION, Pedixplorer's `avail` (`:109`), long names
at the edges (`:117`), a colony's ids under a point high (`:126`), `findGeneration(alignMates = TRUE)`'s speed (`:301`),
`HANDOFFS.md`'s growth past its trimmer (`:321`); "Waiting on Mark", the dashboard and `methodology/BACKLOG.md`
(`:179`), copying the colony overview (`:186`), the app's features left for later (`:193`), an animal with two mates
drawn once (`:205`). `:36` is 17i itself. BLOCKED, so not offered: `:65` (retire the drift tools), `:173` (N3). Name
every item in the picker (memory "Picker sets: name items, include all"; at most 4 options, so group them and name each
in a preview).
**Session boundary:** one session (17i, or the part of it Mark picks), then close out.
**Priority:** HIGH (17i, then 17j-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S84 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); and the harness's, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R` (none through
   S84; nprcgenekeepr at `3e06730c5`, tree clean).
2. **S84's push** (every commit `[skip ci]`: no package file changed): no CI run to read. GitHub did not answer at S84's
   Orient (`gh run list`, TLS handshake timeout twice); see the CHANGELOG's push entry for whether the push went.
3. **17i, if picked** (timing plan `:631`): read 4.3-4.5 (`:308`-`:353`), 5.7-5.8 (`:422`-`:451`), the 17i section, T5
   (`:661`) and dragons 6, 14, 19, 29-35 (`:665` on). Measure before the pre-RED picker (Learning 17): the installed
   size first (R77: under 5,120 KB; 4,284 KB at S29, before G1-G17); what `git show 612eed9 --stat` brings (the draft
   on `draft/speed-vignette`, not merged: its design carries, its numbers do not, dragon 14); which help pages and
   vignettes state a time today (4.3). Then one picker on scope (all of 17i, or the check tool and vignette first and
   the pointers, contract and site after) and T5.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **The record's figures say different things** (timing plan section 5.1 `:356`): `pkd_page`/`pkd_page_direct` time
  the generations, layout, widget and page (R) plus Chrome's drawing; `pkd_svg`/`pkd_pdf`/`pkd_png` time only
  `savePedigreeDiagram()` on a widget built before the clock; `pkd_data` only `makePedigreeDiagramData()` (dragon 29).
  The page must say which is which.
- **Two saves at 3,000 were not timed** (R158, dragon 33): print them as not timed (the drawing before the save took
  over 300 s), never `summarizeDrawingTiming.R`'s "refused". Pedixplorer's two aligned cases at 300 are refusals (R157).
- **Saves can have one slow run of three** (dragon 34): quote medians; the spread table has 3 cells over 10%.
- **A change to `R/` in 17i changes `R/`'s tree** (the help pointers, `R/pedkindraw-package.R:52`): the records name
  `ac123b7`; 17n's amendment (timing plan, after 17i) asks each such change listed with whether it can change a time.
- **CRAN rebuilds vignettes** (dragon 6): `speed.Rmd` times nothing and reads no `tools/` file; it builds with kinship2
  and Pedixplorer absent.
- **A push that changes package files runs CI**, and the Windows job hangs (`:11`): cancel it at 40 minutes.
- **Read the result CSVs with R, not awk** (quoted commas). **zsh stops at a glob with no match**: use `bash -c`.
- **`methodology/HANDOFFS.md` was not archived** (its trimmer refuses, backlog `:321`): keep the receipt short.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS`, `R_LIBS_USER` set to renv's library; the
  5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, about 10 min, on a
  `git archive` copy); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj`
  untracked, Mark's; `PKD_LIB=/Users/Shared/pkdtiming/pkdlib` is needed only to re-time or to run `tools/timing/tests`.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84, Mark's correction).

### Key files
- The results: `tools/timing/results/drawingTiming.csv` (43 cells), `drawingTimingRuns.csv` (142 runs), `record.csv`
  (two rows: computation `7f13d98`, drawing `70d5021`, both `R/` tree `ac123b7`), `timing.csv`, `timingRuns.csv`; the
  summaries `Rscript tools/timing/summarizeTiming.R` and `summarizeDrawingTiming.R` (both take `--out=<dir>`). The
  pictures in the git-ignored `tools/timing/pictures/` (39 MB).
- The plan: `docs/planning/pedkindraw-timing-plan.md` (`:308` 4.3, `:322` 4.4, `:331` 4.5, `:356` 5.1, `:422` 5.7,
  `:431` 5.8, `:599` 17h4 and its S84 Done note, `:631` 17i, `:653` section 7, `:661` T5, `:665` dragons, `:758`-`:772`
  dragons 33-35); `docs/planning/cran-submission-plan.md:775` (17i); R158 at
  `docs/planning/standalone-pedigree-package-plan.md:333`; the contract's section 8 row,
  `docs/planning/pedkindraw-api-contract.md:343` ("Drawing past about 1,000 animals").
- The draft: branch `draft/speed-vignette` (`612eed9`): `vignettes/speed.Rmd`, `tools/checkSpeedTables.R`.

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
**Deliverable:** Phase 17i, the speed vignette (`docs/planning/pedkindraw-timing-plan.md:631`), strict TDD, or the part
of it Mark picks at the scope picker. (IN PROGRESS)
**Started:** 2026-11-24 12:13 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17i: speed vignette (Recommended)"
(orient picker).
**Status:** Session claimed. Work beginning: the plan's sections read, then the installed size, the draft `612eed9` and
the pages that state a time measured before the scope picker and T5.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest. Until
close-out, this line is the crash breadcrumb for the next session's reconcile.

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

### What Session 82 Did
**Deliverable:** Phase 17h2, the computation runs (`docs/planning/pedkindraw-timing-plan.md:526`): all 78 cases at
six sizes timed with `tools/timing/runTiming.R`, the results committed. No code. DONE.
**Started:** 2026-11-23 14:10 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "17h2: timing runs
(Recommended)" (orient); "/Users/Shared/pkdtiming (Recommended)" and "Start now; the load is recorded" (one picker);
"Keep running as it is" (when the record slowed). No correction and no tool use declined.
**Commits:** claim `7f13d98`; results `14145a4`; close-out 1 `3a9832c` (the plans, roadmap); close-out 2 (the backlog,
these notes, the receipt, the ledger), pushed after it.
**Did:** built and installed pedkindraw at `/Users/Shared/pkdtiming/pkdlib` (packaged 20:41:40 UTC, after `09e8f45`);
`savePedigrees.R` 8 of 8 identical to the study's; read the machine (62.5% idle, load 9.6, 51% memory free, vitest);
the record in the background 14:42:24-22:17:43, watched; `summarizeTiming.R` printed; three re-runs from a fresh shell.
**Verified (by an R script over the result files):** 78 of 78 cases, each with every size up to and including its
first failure; 416 `ok` cells, each the median of its 3 measured runs; 22 failed (11 `memory`, R's 29.8 GiB vector
limit; 9 `time`; 2 `error`); 1,686 runs, one under 50% idle after the full 10-minute wait; 852 pedkindraw runs from
`PKD_LIB`, the 6 others its failed warm-ups; no other package's run loaded pedkindraw; no private path in the three
files; 74 cells of 0.5 s or more, spread median 1.6%, largest 13.2% (Pedixplorer's `kinship()` at 10,000); re-runs
+7.7%, -2.6%, +2.1%; quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s); the package suite by
hand on a `git archive` of `3a9832c` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]` (1,146 tests, 589 s).
**Found:** a record on this Mac takes about three times its process time (dragon 26); kinship2's `findAvailNonInform()`
stops at 1,000 (dragon 27); `runTiming.R` rewrites its result files (dragon 28); pedkindraw's `findPedigreeNumber()`
12.4 s at 100,000 against about 0.6 s (backlog `:295`); `findGeneration(alignMates = TRUE)` 60.6 s at 10,000 (`:301`).
**Not run:** the drawing record (17h3-17h4); `R CMD check` (no package file changed).

#### Session 81 Handoff Evaluation (by Session 82)
**Score: 9/10.** ROI high: 17h2 ran from its notes with no rediscovery.
- **What helped:** What You Must Do 4's build commands under `bash -c` (each worked first time) and "ask Mark where"
  (`PKD_LIB`'s path became a picker); 3's machine read (dragon 25), which made the other work a picker before the
  start, not a surprise; the gotchas on `PKD_LIB`, the build check, and running nothing beside a record; drift
  91/23/0, nprcgenekeepr's 4 commits and the 31 backlog lines, all as stated.
- **What was missing:** that the idle share can sit at the 50% line while the load average is low, so the harness
  waits before most runs (not knowable until a long record ran; now dragon 26); that the result files are rewritten,
  not appended, which matters to any re-run (dragon 28).
- **What was wrong:** nothing found. Its "about 3.5-4 hours, a guess" was labelled a guess; the record took 7.6.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; both setup choices put to Mark before anything was built; the record's
  start checked (its row, the first runs) before leaving it; each failed size explained as it came; every DONE
  criterion checked by a script over the files, not by reading, which found and explained the one low-idle run and the
  six empty `pkdLib` rows; the privacy check before the commit; the re-runs; three new dragons.
- **Slips, none reaching a commit:** my first estimate of the time left (2.5 h at 16:43) was half the real 5.5 h: I
  scaled from cases that ran in lighter waits and did not model the idle share at the 50% line; I corrected it within
  30 minutes, with a picker, when the pace fell. No watch was armed for about 2.5 h while that picker was open. An awk
  tally misread the CSV's quoted commas. The backlog first named Pedixplorer's `make_famid()` as `makefamid()`, caught
  by checking the case before the commit.
