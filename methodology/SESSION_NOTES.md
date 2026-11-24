# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77); 17h1-17h1c DONE (S79-S81, R154-R156, the computation harness); 17h2 DONE (S82, the
computation record, `14145a4`). **17h3 DONE in S83 (R157):** the drawing harness in `tools/timing/`, copied test-first
from nprcgenekeepr's `tools/pedigreeComparison/` at `3e06730c5`: 11 drawing cases (`drawingTimingCases.R`), one
drawing per fresh R process (`drawOne.R`), the browser timer (`drawingTiming.R`), the record's runner
(`runDrawingTiming.R`) and its summary (`summarizeDrawingTiming.R --out=`); 169 tests passing; a trial at 300 animals
drew 9 of 11 cases and 11 of 11 on the sample (Pedixplorer's alignment refuses the colony, as R157 records). No package
file changed.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Next, recommended: 17h4, the drawing record** (timing plan `:598`; no code): `runDrawingTiming.R` over all 11 cases at
300, 1,000, 2,000 and 3,000 animals and the sample, at a commit whose `R/` tree is still `ac123b7`; the pictures opened
for Mark, who judges how large a drawing can still be read (T4, section 7 `:637`). Then 17i, the speed vignette.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17h4 (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (31 items,
each found at its line by `grep -n '^- \[ \]'` at S83's close-out, the same lines as S82's): READY, the legend's labels
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
drawn once (`:205`). BLOCKED, so not offered: `:36` (the speed vignette, now on 17h4's record alone), `:65` (retire the
drift tools), `:173` (N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4
options, so group them and name each in a preview).
**Session boundary:** one session (17h4), then close out.
**Priority:** HIGH (17h4, then 17i-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S83 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); and the harness's, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R` (none through
   S83; nprcgenekeepr at `3e06730c5`, tree clean).
2. **S83's push** (every commit `[skip ci]`: `tools/` is build-ignored and no package file changed): no CI run to read.
3. **17h4, if picked** (timing plan `:598`; as 17h2 for drawing, section 6 `:528`-`:563`): `git rev-parse HEAD:R` must
   still read `ac123b7...`; read `top -l 2 -n 0 -s 1` and `ps -Ao pcpu,etime,comm -r` (dragon 25: vitest workers ran
   through S82 and S83) and tell Mark before starting; then from the root, in the background,
   `PKD_LIB=/Users/Shared/pkdtiming/pkdlib Rscript tools/timing/runDrawingTiming.R` (all 11 cases; writes
   `tools/timing/results/drawingTiming.csv`, `drawingTimingRuns.csv`, a `drawing` row in `record.csv`, the pictures in
   the git-ignored `tools/timing/pictures/`). Check its start (the `record.csv` row, the first cells) before leaving
   it. After: `Rscript tools/timing/summarizeDrawingTiming.R`; one cell re-run from a fresh shell with
   `--out=<scratch>` (never into `results/`, dragon 28); the DONE checked by script over the files (S83's trial check
   is the model: each `ok` cell the median of its 3 runs, every pedkindraw run from `PKD_LIB`, each `started` plus
   `realSeconds` at or before the next); then open the zoom-1 pictures for Mark (T4, `:637`). How long it takes is a
   guess: the trial's two smallest pedigrees took 17 minutes; the study's drawing record 2.5 hours of starts; the plan's
   dragon 26 guesses 3.5-4.5 h on this Mac as used.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").
   17h4 writes no code: if a run shows a harness bug, stop and put it to Mark as its own session.

### Gotchas
- **`PKD_LIB=/Users/Shared/pkdtiming/pkdlib`** (Mark's pick, S82): set it or every drawing test skips (SKIP must read
  0) and the runner stops ("no pedkindraw in PKD_LIB"). It holds `7f13d98`'s build (`R/` tree `ac123b7`); rebuild only
  after a commit to `R/`, `DESCRIPTION` or `NAMESPACE` (dragon 22), which 17h4 must not make.
- **Two of the 11 cases refuse the 300 colony** (R157): `pdx_picture` and `pdx_plotly` ("subscript out of bounds",
  Pedixplorer's alignment); the runner records `error` at 300 and goes on to the sample. Expected, not a failure.
- **`runDrawingTiming.R` rewrites its two result files** unless `--append` (dragon 28): re-runs go to `--out=<scratch>`.
- **Pedixplorer's plotly page takes about 30 s in R at 300** (dragon 30): its runs are the record's longest; "time" at
  1,000 is the study's result too.
- **`pkd_data` is 1 ms** (dragon 29): `makePedigreeDiagramData()` alone; the layout is the cost.
- **The summary's "none up to 3,000"** is true of a full record only (dragon 31).
- **"got non-close frame while closing"** on the console is Chrome's websocket closing (dragon 32), harmless.
- **The test folder takes about 7 minutes now** (an estimate: 169 tests, the drawing files 229 s of it): run it alone,
  never beside a record or the package suite, and with `NOT_CRAN=true` and `PKD_LIB`.
- **A record on this Mac takes about three times its process time** (dragon 26); read the machine first (dragon 25).
- **Background tasks:** the task's own exit notice is the end signal; a watch (Monitor) lasts 30 minutes. Never edit a
  file a running test or record reads (S83 did, once, and threw that run away).
- **Read the result CSVs with R, not awk** (quoted commas). **zsh stops at a glob with no match**: use `bash -c`.
- **`methodology/HANDOFFS.md` was not archived** (its trimmer refuses, backlog `:321`): keep the receipt short.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS`, `R_LIBS_USER` set to renv's library (S83's
  scratch copy: no `.Rprofile`, those two set), but the harness's own commands as plain `Rscript` from the root, so
  renv activates; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand,
  about 10 min, on a `git archive` copy); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; the Windows hang (cancel at 40 min).

### Key files
- The drawing harness: `tools/timing/runDrawingTiming.R` (`:74` the record's row, `:114` `runOnce()`, `:147`
  `cellFor()`, `:174` the loop), `tools/timing/drawingTimingCases.R` (`:92` `pedkindrawDiagram()`, `:102`
  `pedkindrawPage()`, `:116` `pedkindrawSave()`, `:131` `drawingCases()`), `tools/timing/drawingTiming.R` (`:114`
  `timeBrowserDraw()`, `:145` `zoomedVisScreenshot()`, `:171` `combineDrawRun()`, `:249` `drawingRunRow()`),
  `tools/timing/drawOne.R`, `tools/timing/drawingCapture.R`, `tools/timing/summarizeDrawingTiming.R`; tests
  `tools/timing/tests/test_drawingTiming.R`, `test_drawingCapture.R`, `helper-caseValues.R` (`colonyFile()`).
- The computation record: `tools/timing/results/record.csv`, `timing.csv`, `timingRuns.csv`.
- The plan: `docs/planning/pedkindraw-timing-plan.md` (`:277` 4.1, `:355` 5.1, `:395` 5.4, `:564` 17h3 and its S83
  Done note, `:598` 17h4, `:608` 17i, `:630` section 7 (T3, T4 `:637`), `:642` dragons, `:709` dragon 26, `:724`
  dragons 29-32); `docs/planning/cran-submission-plan.md:754` (17h), `:771` (17i); R157 in
  `docs/planning/standalone-pedigree-package-plan.md` section 2.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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

### What Session 81 Did
**Deliverable:** Phase 17h1c (the backlog item S80 added), strict TDD: each run's `started` in `timingRuns.csv` is when
the run launched, not when it ended (timing plan dragon 24). DONE.
**Started:** 2026-11-23 12:28 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "17h1c: fix 'started' (Recommended)" (orient); "When the run launches (Recommended)" (R156); "Yes, proceed
to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `e516629`; R156 `96a7f39`; RED `7c6e8e7`; GREEN `c7cff5d`; REFACTOR `df6dbca`; close-out 1 `19a5b43`
(the plans, roadmap); close-out 2 (the backlog, these notes, the receipt, the ledger), pushed after it.
**Measured first:** the copied behaviour on three ~3.3 s children (each row's `started` 2.6-3.1 s after the moment
before `runLimited()`, the run's length cut to the second); one `waitForQuiet()` pass, 2.66 s with no floor; then the
drafted RED tests against the committed harness (4 failing, each on R156's change) and a scratch draft of GREEN (22 of
22 expectations).
**Built:** `launched` in `runLimited()`, `runRow()` writing it (no `started` argument), `callStarted`; 3 new tests and
the row test changed; R156; the plans' status, a 17h1c entry, dragons 24 (fixed) and 25 (the machine's load); the
backlog's `:325` replaced by a note for nprcgenekeepr.
**Verified:** RED 129 tests, 4 failing for the right reason, 125 passing, WARN 0, SKIP 0; GREEN and after REFACTOR
`[ FAIL 0 | WARN 0 | SKIP 0 ]` 129 tests, 1,219 expectations; REFACTOR 31 of 32 functions deparse identical to GREEN's
and `runLimited()` identical with the old name put back; the trial of the real `runTiming.R` (`pkd_gen`, `k2_kin` at
300): 8 runs `ok`, each row's `started` plus `realSeconds` before the next row's `started`, the last run's end
12:57:12.1 against the end note's 12:57:12; lint 0; no package file changed; the package suite by hand on a `git archive` of `df6dbca` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]` (1,146 tests, 600 s); quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s).
**Found:** other work on this Mac (a virtual machine, vitest, Playwright; 0% idle, load 43 at 12:35) holds a record
back (dragon 25); the timing plan's cite of the cran plan's 17i heading moved with close-out 1's own edit (`:766`).
**Not run:** a full-size record (17h2's work).

#### Session 80 Handoff Evaluation (by Session 81)
**Score: 9/10.** ROI high: the ACTIVE TASK framed the decision, and What You Must Do 4 named both files at their lines.
- **What helped:** `runTiming.R:88` (`runOnce()`) and `timingHarness.R:380` (`runRow()`), each where it said; "measure
  first (Learning 17)" and the testing question (move `runOnce()` or check by a trial), which led to a third place,
  inside `runLimited()`, needing neither; the `PKD_LIB` build commands under `bash -c`, exact; the gotchas on SKIP, the
  folder run alone and the build check; drift 91/23/0, nprcgenekeepr's 4 commits and the 31 backlog lines all held.
- **What was missing:** that the machine might be busy with other work (not knowable at S80's close-out; my first trial
  waited 5 minutes without a run, now dragon 25).
- **What was wrong:** nothing found. Its suggested fix ("a time taken before the run, passed as `runRow(started = )`")
  was one design, offered as such.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the bug reproduced on real children before the picker, which stated
  counts; every RED test run against the committed harness and a scratch draft before RED (Learning 18); RED for the
  right reason with SKIP 0; a trial of the real script, not only the tests; the REFACTOR proved by machine; a stale
  cite my own edit made, found and fixed before its commit (Learning 7).
- **Slips, none reaching a commit:** I started the first trial without reading the machine's load (5 minutes lost,
  stopped); GREEN first put the new clock line under the comment that describes the next line (moved before the
  commit); the backlog's new item said "the two items above" for items 50 lines up (named by line before the commit); a
  picker preview said "runtiming.R". Two of RED's four failing tests also stop with an error after their first
  failure, because a later comparison reads the missing time: correct, but noisier than a failure alone.
