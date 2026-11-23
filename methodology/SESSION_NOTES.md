# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77); 17h1 DONE (S79, R154: the computation timing harness in `tools/timing/`). **17h1b DONE
in S80 (R155):** each run's row in `timingRuns.csv` holds `memFree` (`memory_pressure -Q`, read after the idle wait),
and `runTiming.R` appends one row to `<out>/record.csv` when a record starts (record, started, commit, `R/`'s tree,
packaged, R, kinship2, Pedixplorer, chromote, Chrome, model, chip, cores, memoryGb), first stopping the record unless
`R/`, `DESCRIPTION` and `NAMESPACE` are committed and `PKD_LIB`'s pedkindraw was packaged after their last commit.
`test_dir("tools/timing/tests")` with `PKD_LIB` `[ FAIL 0 | WARN 0 | SKIP 0 ]` 126 tests, 1,208 expectations. No
package file changed.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Found in S80 (backlog `:325`, DECISION NEEDED):** `timingRuns.csv`'s `started` is when each run *ended* (the row is
built after `runLimited()` returns; copied so; nprcgenekeepr shares it; timing plan dragon 24). 17h2 commits that file.
**Next, recommended: decide `:325` at the orient picker.** Claude's recommendation: **17h1c, a short TDD session** that
records each run's start (a time taken before the run, passed as `runRow(started = )`), then **17h2, the computation
runs** (timing plan `:506`, no code, about 3.5-4 hours of background runs, a guess). The other: 17h2 now, reading the
column as dragon 24 says.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17h1c (recommended), 17h2 now, or the Windows item (`:11`). Also, from `methodology/BACKLOG.md`
(31 items, each found at its line by `grep -n '^- \[ \]'` at S80's close-out): READY, the legend's labels in a narrow
drawing (`:73`), the drawing vignette's measured trait (`:83`), a twins table with no rows (`:89`),
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:99`), the `smallPed` fixture (`:132`), rewording
`DIVERGENCE.md`'s older rows (`:55`), tests for full coverage (`:138`), `findPedigreeNumber()`'s speed (`:294`),
poppler in CI (`:306`), the label counts in `largeIds` (`:287`), and the seven "Ready, small" items (`:215` the suite
gate's time limit, `:227` the stale pedkindraw 0.0.1, `:234` the drift tool and copied constants, `:243` the
context-budget tool, `:253` CI notices, `:270` report a vacuous test, `:276` tell nprcgenekeepr's edition-3
conversion); NEEDS DECISION, `started` (`:325`, above), Pedixplorer's `avail` (`:108`), long names at the edges
(`:116`), a colony's ids under a point high (`:125`), `findGeneration(alignMates = TRUE)`'s speed (`:298`),
`HANDOFFS.md`'s growth past its trimmer (`:316`); "Waiting on Mark", the dashboard and `methodology/BACKLOG.md`
(`:178`), copying the colony overview (`:185`), the app's features left for later (`:192`), an animal with two mates
drawn once (`:204`). BLOCKED, so not offered: `:36` (the speed vignette, on 17h's runs), `:64` (retire the drift
tools), `:172` (N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options,
so group them and name each in a preview).
**Session boundary:** one session (17h1c, or 17h2), then close out.
**Priority:** HIGH (17h2-17h4, then 17i-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S80 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); **and the harness's**, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R` (none through
   S80; nprcgenekeepr at `3e06730c5`, tree clean). A change there is read before touching `tools/timing/`.
2. **S80's push** (every commit `[skip ci]`: `tools/` is build-ignored and no package file changed): no CI run to read.
3. **Build `PKD_LIB` first** (S80's was in its own scratchpad; every harness test and run needs one), under `bash -c`:
   from a scratch folder, `R CMD build --no-build-vignettes --no-manual <repo>`, then `R CMD INSTALL
   --library=<folder>/pkdlib pedkindraw_*.tar.gz`, both with renv's library as `R_LIBS` and `R_LIBS_USER` and
   `RENV_PROJECT` unset. For 17h2 build it at a short path that names no person (dragon 23; outside the scratchpad, so
   ask Mark), after the last commit that changes `R/` (dragon 22: the record refuses an older install).
4. **17h1c, if picked:** read `tools/timing/runTiming.R:88` (`runOnce()`) and `timingHarness.R:380` (`runRow()`).
   Pre-RED: when "started" is (before the idle wait, or just before `runLimited()`), and how to test it: `runOnce()` is
   in the script, so either move it into `timingHarness.R` with its readers and runner as arguments (as
   `waitForQuiet()` takes them) or check it by a trial (each run's `started` plus its `realSeconds` at or before the
   next run's). Measure first (Learning 17). The copied file's header names the change.
5. **17h2, if picked:** the plan's 17h2 (`:506`), 5.4-5.6 (`:391`-`:411`), dragons 5, 8, 11, 18-24 (`:584`-`:644`);
   `Rscript tools/timing/savePedigrees.R` (8 of 8), then `runTiming.R` in the background (all 78 cases, six sizes) with
   nothing else running; it writes `results/record.csv`'s row itself; then `summarizeTiming.R`; commit the results.
6. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **`PKD_LIB` must be set** or every case test skips (SKIP must read 0) and `runTiming.R` stops before any run ("no
  pedkindraw in PKD_LIB"). **The record's build check** (dragon 22): uncommitted `R/`, `DESCRIPTION` or `NAMESPACE`, or
  an install packaged before their last commit, stops the record at once; rebuild after such a commit.
- **A scratch test run outside the root has no renv** (dragon 21): from `tools/timing/tests`, testthat's edition 3
  turned the missing `kinship2` into a SKIP part-way through a test, and S80's RED message reported that check as
  "18 of 18 pass". Run checks from the root and read SKIP.
- **`timingRuns.csv` records** `pkdLib`, the scratch library's full path (dragon 23), and `started`, each run's end
  (dragon 24, backlog `:325`); `record.csv` is appended once per `runTiming.R` call in `<out>` (a trial with
  `--out=<scratch>` leaves `results/` alone).
- **The test folder takes about 3 minutes** (Pedixplorer's `shrink()` about 90 s on each of its two pedigrees): run
  it from the root, alone, never beside a record or the package suite (plan dragon 20).
- **Pedixplorer's `family_check()` stops on the colonies** (R154); kinship2 chooses among ties at random (dragon 18);
  `summarizeTiming.R` says "none up to 100,000" whatever the sizes run (dragon 19).
- **zsh stops a command at a glob with no match** ("no matches found": S80's `rm -rf pkdlib pedkindraw_*.tar.gz` in
  an empty folder); run build commands under `bash -c`.
- **`methodology/HANDOFFS.md` was not archived** (its trimmer refuses, backlog `:316`): keep the receipt short.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS`, `R_LIBS_USER` set to renv's library, but the
  harness's own commands (`test_dir`, `runTiming.R`, `savePedigrees.R`) as plain `Rscript` from the root, so renv
  activates; zsh does not split an unquoted variable (`bash -c`); the 5-file cap splits commits; the ratchet's suite
  gate times out at 300 s (run the suite by hand, about 9.5 min, on a `git archive` copy); `CLAUDE.md` is over its
  budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the browser
  tests; scratch files in the scratchpad; the Windows hang (cancel at 40 min).

### Key files
- The harness: `tools/timing/timingHarness.R` (`:39` `useTimingLibraries()`, `:50` `checkPedkindrawFolder()`, `:151`
  `currentMemoryFree()`, `:160` `waitForQuiet()`, `:180` `timeStamp()`, `:285` `runLimited()`, `:370` `stopsRecord()`,
  `:380` `runRow()`, `:398` `parseMachine()`, `:424` `chromeVersion()`, `:440` `chromePath()`, `:451`
  `packageVersions()`, `:460` `packagedTime()`, `:484` `commitFacts()`, `:498` `checkBuild()`, `:523` `recordRow()`,
  `:552` `appendRecordRow()`); `runTiming.R` (`:65`-`:67` the record's row, `:88` `runOnce()`); the tests,
  `tools/timing/tests/test_timingHarness.R:593` (S80's 18); `timingCases.R`, `timeOne.R`, `savePedigrees.R`,
  `summarizeTiming.R`.
- The plan: `docs/planning/pedkindraw-timing-plan.md` (`:292` 4.2, `:391` 5.4, `:399` 5.5, `:426` 5.8, `:456` 17h1,
  `:489` 17h1b and its Done note, `:506` 17h2, `:528` 17h3, `:584` dragons 1-24); R155 in
  `docs/planning/standalone-pedigree-package-plan.md:326`; `docs/planning/cran-submission-plan.md:754` (17h).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 81 Did
**Deliverable:** Phase 17h1c (`methodology/BACKLOG.md:325`), strict TDD: each run's `started` in `timingRuns.csv` is
the time the run began, not the time it ended (timing plan dragon 24). No package code. (IN PROGRESS)
**Started:** 2026-11-23 12:28 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17h1c: fix 'started'
(Recommended)" (orient picker).
**Status:** Session claimed. Work beginning: `runOnce()` and `runRow()` read, then the pre-RED measures.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest. Until
close-out, this line is the crash breadcrumb for the next session's reconcile.

### What Session 80 Did
**Deliverable:** Phase 17h1b (the backlog item S79 added), strict TDD: each run's free memory and `record.csv`
(timing plan sections 4.2 and 5.4). DONE.
**Started:** 2026-11-23 11:37 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "17h1b: memory + record (Recommended)" (orient); R155's three in one picker ("At each record's start",
"Stop on a mismatch", "Read before each run"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR
(Recommended)". No correction and no tool use declined.
**Commits:** claim `b3e18f3`; R155 `298091c`; RED `a2def9e`; GREEN `c458ca4`; REFACTOR `5efec3d`; close-out 1 `2a9e4b1`
(the plans, roadmap); close-out 2 (the backlog, these notes, the receipt, the ledger), pushed after it.
**Measured first:** `sysctl` (Mac14,6, Apple M2 Max, 12, 103079215104 B), `memory_pressure -Q` (45%, under 0.01 s),
Chrome's version by `plutil` on its `Info.plist` (157.0.8103.51, not started), a typed plist and a fake library holding
only a DESCRIPTION read back, the scratch install's Packaged field (17:39:10 UTC, then "; <user>") against the last
commit to `R/` (`09e8f45`, 05:43 UTC); then every RED value against a scratch draft of the functions.
**Built:** `runRow()` and the record's functions in `tools/timing/timingHarness.R`, `runTiming.R` wired, 18 tests,
`timeStamp()`; R155; the plans' status, sections 4.2, 5.4, 5.5, a 17h1b entry, 17h2's Work, dragons 21-24.
**Verified:** RED 18 failing, each "could not find function", the old 108 passing (1,143 expectations), WARN 0, SKIP 0;
GREEN and after REFACTOR `[ FAIL 0 | WARN 0 | SKIP 0 ]` 126 tests, 1,208 expectations; trials: 8 runs with `memFree`
45-46 and one `record.csv` row (values in the plan's 17h1b Done note), an empty `PKD_LIB` stopping the record before it
wrote anything, REFACTOR's trial identical apart from `started` and `commit`; lint 0; no package file changed; the
package suite by hand on a `git archive` of `5efec3d` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]`
(1,146 tests, 597 s); quality_ratchet 5/6 pass, 0 fail, 1 unmeasured (the suite gate's 300 s).
**Found:** `timingRuns.csv`'s `started` is each run's end (backlog `:325`, dragon 24); its `pkdLib` names the scratch
path (dragon 23); the timing plan's cite of the cran plan's 17i heading was stale (`:761`, now `:764`).
**Not run:** a stop on this repository's own uncommitted `R/` (shown on temporary repositories only); any record.

#### Session 79 Handoff Evaluation (by Session 80)
**Score: 9/10.** ROI high: the ACTIVE TASK named 17h1b's two pieces and where each goes, which became the session.
- **What helped:** What You Must Do 3's `PKD_LIB` build commands, exact; 4's reads by line (`runTiming.R:77`,
  `timingHarness.R:135`-`:170`, sections 4.2 and 5.4), each where it said; "how Chrome's version is read without
  starting Chrome, measure first" became the `Info.plist` reading; the gotchas on `PKD_LIB`, the 3-minute folder (run
  alone), "keep the receipt short"; drift 91/23/0, nprcgenekeepr's 4 commits and the 31 backlog lines all held.
- **What was missing:** that `runTiming.R` has no test of its own (only a trial shows a row's columns), which shaped
  `runRow()`; that zsh stops at a glob with no match (my first build command); that `timingRuns.csv`'s `started` is
  each run's end and its `pkdLib` the scratch path, both committed by 17h2 (not knowable without reading closely).
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every option measured before the picker (the machine, Chrome, the
  install's Packaged field against the last `R/` commit), so Mark took all three recommended options; the privacy point
  (`system_profiler` prints the serial number; the Packaged field ends with the user name) caught before design; every
  RED value checked against a scratch draft; RED for the right reason with SKIP 0; trials of the real script, its stop
  path included; the REFACTOR proved by a trial; two findings recorded (backlog `:325`, dragon 23), and a stale cite
  fixed.
- **Slips that reached commits:** RED's message (`a2def9e`) says the edition-3 draft check passed "18 of 18": one test
  stopped part-way as a skip there, because that check ran outside the root without renv (dragon 21); the first
  check, from the root, had run all 65 expectations, its version comparisons too. RED's first message named the wrong
  build commit; amended before any push.
- Other slips, none reaching a commit: a zsh glob stopped the first build; four lints in RED and three in GREEN (a
  header line my edit made 94 characters long), each caught by lint before its commit.

### What Session 79 Did
**Deliverable:** Phase 17h1, the computation timing harness (`docs/planning/pedkindraw-timing-plan.md:451`), strict
TDD, a copy. DONE.
**Started:** 2026-11-23 08:34 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "17h1: timing harness (Recommended)" (orient); T1's three in one picker ("5.2 with four fixes", "Colonies as
they are", "Time them, note it"), R154; "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)".
No correction and no tool use declined.
**Commits:** claim `6281c07`; T1's probes and R154 `82ead90`; RED `8fc668b`, `df2e102`; RED amendments `5b42ca0` (a
case returning `NULL`), `d23cbbf` (a comment); GREEN `cd002dc`, `a8390fb`; REFACTOR `b9d5893`; close-out 1 `78d6070`
(the plans, roadmap, `pedigreeFiles.csv`); close-out 2 (the backlog item `:325`, these notes, the receipt, the ledger),
pushed after it.
**Measured first** (plan section 3.8): each section 5.2 input on the 300 colony and the sample (some at 1,000 and
3,000), each pairing's three calls compared; kinship2's `pedigree.trim()` stops on the probands, Pedixplorer's
`family_check()` on the colony's families, no colony has same-year full siblings, 5.2's IBD count was sires only; five
differences of answer; then every RED value from a scratch draft of `timingCases.R` (78 cases run on both pedigrees),
which found two more differences (`makekinship()`'s diagonal, `makefamid()`'s family 0) and Pedixplorer's 90 s
`shrink()`.
**Built:** `tools/timing/` (9 files) and `tools/timing/tests/` (9 files), `.gitignore`'s four lines, R154, plan
section 3.8, dragons 16-20.
**Verified:** RED 108 failing for the right reason, 0 passing, 0 skipped, 1 warning (`read.csv()` of the file the
missing script did not write); GREEN and after REFACTOR `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 1143 ]`; every copy `diff`ed
against its source, only planned hunks (`measure.R` byte for byte); `savePedigrees.R` 8 of 8; the trial 309 runs, 77 of
78 `ok`, 148 of 148 pedkindraw runs from `PKD_LIB`; REFACTOR 156 of 156 prepared inputs `identical()`; lint 0; no
package file changed; the package suite by hand (below, in the receipt).
**Found:** the record's free memory and `record.csv` have no code (backlog `:325`, 17h1's miss).
**Not run:** any timing record (17h2's work); `R CMD check` (no package file changed).

#### Session 78 Handoff Evaluation (by Session 79)
**Score: 9/10.** ROI high: "What You Must Do" 3 set the session's order exactly.
- **What helped:** every timing-plan section by line (`:63`, `:118`, `:160`, `:230`, `:306`-`:360`, `:406`, `:482`,
  `:494`), each where it said; "measure each T1 input before the picker" found the three unbuildable inputs; the three
  counterpart calls that stopped on S78's probe (each built from its help page here); the stale 0.0.1 dragon, which
  became `checkPedkindrawFolder()`; drift 91/23/0, nprcgenekeepr's 4 commits at `3e06730c5`, the harness unchanged
  since `d75f07f6b`, and the 30 backlog lines all held; "write a short receipt".
- **What was missing:** that the harness's tests skip without `PKD_LIB`, so the DONE's SKIP 0 needs a scratch install
  first (the plan gave no commands); that the sample's file writes `NA` for an unknown parent; that Pedixplorer's
  `shrink()` takes about 90 s at 300 (the study's `timing.csv` had it).
- **What was wrong:** the plan's section 5.2, carried by the handoff: its IBD count (196,160) counted sires only, its
  twins (full siblings born in one season) cannot be built, and two of its inputs stop a counterpart; and section 4.1
  left `runTiming.R`'s free memory and `record.csv` out (I missed it too, until close-out). The DONE's "every case
  `ok`" could not survive R154 (not knowable to S78).
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; T1 measured by three probes run as committed from an empty folder, so
  the picker stated counts and Mark took all three recommended options; every RED value computed first from a scratch
  draft, which found three more differences before any test was written; RED 108 for the right reason with SKIP 0;
  every copy proved by `diff`; the trial run; REFACTOR proved by an `identical()` record.
- **Slips that reached commits:** RED's helper dropped a `NULL` case value and its test read `NULL` as no value (RED
  amendment `5b42ca0`), and that amendment joined two comment lines (`d23cbbf`); GREEN 2's message quoted a test run
  made before two small edits (`3L`, comments), re-run after with the same counts; and 17h1 missed section 5.4's free
  memory and 4.2's `record.csv`, found only at close-out (backlog `:325`, a session before 17h2).
- Other slips, none reaching a commit: the probe read the sample with `""` only as unknown (every sire `"NA"`); R's
  `||` with text, an `ifelse()` recycling bug and a duplicate-index assignment in `familyNumbers()`, each caught in the
  scratchpad; a top-level colony build aborted RED's first run of a test file; a wrong line citation in a header.

### What Session 78 Did
**Deliverable:** Phase 17g, the timing plan (`docs/planning/cran-submission-plan.md:740`): a plan of its own,
`docs/planning/pedkindraw-timing-plan.md`. A planning session: no package code, nothing timed for the record. DONE.
**Started:** 2026-11-23 04:50 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "17g: the timing plan (Recommended)" (orient); R153's four in one picker ("All 37 (Recommended)", "Time
them again (Recommended)", "Half the CPU idle (Recommended)", "pedkindraw's own runs only (Recommended)"). No
correction and no tool use declined.
**Commits:** claim `dd2d1c2`; measuring scripts `66f1bf8`; the plan and R153 `b327133`; close-out 1 `03471dd` (the cran
plan's 17g-17i rows, 17n's amendment, D5, the session map; roadmap; backlog `:36` and the new `:298`); close-out 1c
`ad4ad82` (the plan's citations after close-out 1, Learning 7); close-out 2 (these
notes, the receipt, the ledger); close-out 2b (HANDOFFS.md's trimmer refused, backlog `:316`), pushed after it.
**Measured first** (plan section 3): the November study's method, harness files and three records (Part A 587 runs,
76.8 min of starts; Part B 84; the Rewrite 157 over 356 min under its 80%-idle and 50%-memory rule); the study's seven
seed-1 colonies rebuilt byte for byte under pedkindraw's R (7 of 7 md5s, twice); the 38 exports' kinship2 and
Pedixplorer functions (13 newer pairings, read from both namespaces and their arguments); one call of each function
at 10,000 and 100,000 animals, twice, within 5% (`findGeneration(alignMates = TRUE)` 56.5 and 54.8 s at 10,000;
`getNearRelativePedigree()` 6.2 s; three counterpart calls stopped on the probe's inputs); the machine (load 5.7, 85%
idle, 47% memory free); the cost (about 3.5-4 h of computation runs, 1.2-1.5 h of drawing runs, a guess).
**Wrote:** the plan (sections 1-10: R153; measures; the inventory of copied, written and time-stating files and the
pointers; the design, 78 computation and 11 drawing cases; phases 17h1-17h4 and 17i with DONE, commands, surface and
boundary; T1-T5; 15 dragons); R153 in the standalone plan; the cran plan, roadmap and backlog after 17g.
**Verified:** every count and line in the plan re-checked against its source before its commit (section 4.6's
searches); the three scripts re-run as committed from an empty folder; quality_ratchet 5/6 pass, 0 fail, 1 unmeasured
(the suite gate's 300 s); by hand the full suite at `ad4ad82` (`NOT_CRAN=true`) `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]`
(588 s); no file under `R/`, `tests/`, `man/`, `vignettes/`, `inst/`, `DESCRIPTION` or `NAMESPACE` changed (`git diff
--stat 8a1a549..HEAD`).
**Found:** `findGeneration(alignMates = TRUE)` takes about 56 s at 10,000 animals (backlog `:298`, pedkindraw's own).
**Not run:** any timing by the method (17h's work); `R CMD check` (no package file changed).

#### Session 77 Handoff Evaluation (by Session 78)
**Score: 9/10.** ROI high: "What You Must Do" 3 was the evidence inventory's spine.
- **What helped:** item 3 named every read with its line (the cran plan's 17g-17i rows and section 2.1, the contract's
  section 7 at `:323`, backlog `:36`, the draft at `612eed9`, S75's `g17bSize.R`, the drawing vignette at `:794`, NEWS's
  G17b bullet), each found where it said; "measure what a pick depends on before the picker" led to the colonies' md5
  check and the probes; drift 91/23/0, nprcgenekeepr's 4 commits at `3e06730c5` and the 28 backlog lines all held; the
  HANDOFFS.md archive warning (86 B under the threshold at Orient); the zsh gotcha (I still tripped it, my slip).
- **What was missing:** that the study's whole harness, with tests, is in nprcgenekeepr's `tools/pedigreeComparison/`
  and its colony generator is standalone (found from the study's section 7; it shaped the plan); that the study's load
  rule became "half the CPU idle" (S1123, the standalone plan's Phase 1 Done note `:465`), not `uptime`; that memory
  "Framing before filling" was written about this very vignette (S30), so the picker should carry the outline.
- **What was wrong:** "the standalone plan's section 6 (the timing method: fresh process, warm-up, median of 3,
  uptime)": section 6 is the Risks table, one row; the method is Phase 1 step 4 (`:446`), with S1123's idle rule. Minor.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every named source read; measured before the picker (the colonies byte
  for byte, every export's pairing by namespace and arguments, one call of each function twice, the machine, the
  records' durations), so the picker stated counts and Mark took all four recommended options at once; the picker named
  all 38 exports (memory "Picker sets") and put the vignette's outline in a preview (memory "Framing before filling");
  the scripts committed and re-run from an empty folder before the plan cited them; a real finding (`alignMates`)
  recorded; the plan ordered harness-then-runs per kind so each half works end to end (failure mode #25).
- **Slips, none reaching a commit:** a zsh unquoted variable made the first verification run exit at once (the
  handoff's own gotcha); the first draft said 79 cases (78: kinship2 has 10 newer pairings, not 11), "within 4%"
  (4.1%), `:24`-`:75` (`:72`), "under 0.05" (0.052) and "the study's re-run differed by 3%" (3% and 4%), each found by
  re-checking the number against its source (Learning 18); a `sed` rewrite of the probe headers turned apostrophes into
  dots (found by `grep`). The plan was drafted while the re-run was still going, so three figures changed after.
