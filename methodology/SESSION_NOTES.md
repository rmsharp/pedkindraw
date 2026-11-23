# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77); 17h1 DONE (S79, R154: the computation timing harness in `tools/timing/`); 17h1b DONE (S80,
R155: each run's `memFree`, and `record.csv`). **17h1c DONE in S81 (R156):** each run's `started` in `timingRuns.csv`
is the time `runLimited()` launched the child (returned as `launched` with every outcome; `runRow()` writes it with
`timeStamp()` and has no `started` argument), so `started` plus `realSeconds` is the run's end; the copied code wrote
the run's end. `runLimited()`'s own time of the child's "CALL START" is now `callStarted` (was `started`).
`test_dir("tools/timing/tests")` with `PKD_LIB` `[ FAIL 0 | WARN 0 | SKIP 0 ]` 129 tests, 1,219 expectations. No
package file changed.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Next, recommended: 17h2, the computation runs** (timing plan `:526`; no code; all 78 cases at six sizes in the
background, about 3.5-4 hours, a guess). It needs a quiet Mac (dragon 25: at 12:35 on 2026-11-23 it was 0% idle, load
43, from a virtual machine, vitest and Playwright, none of this project's, and the harness waits up to 10 minutes before
each run while under half idle) and `PKD_LIB` built at a short path that names no person, outside the scratchpad
(dragon 23; ask Mark where).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17h2 (recommended) or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (31 items,
each found at its line by `grep -n '^- \[ \]'` at S81's close-out): READY, the legend's labels in a narrow drawing
(`:73`), the drawing vignette's measured trait (`:83`), a twins table with no rows (`:89`), `savePedigreeDiagram()` and a
`CHROMOTE_CHROME` naming no file (`:99`), the `smallPed` fixture (`:132`), rewording `DIVERGENCE.md`'s older rows
(`:55`), tests for full coverage (`:138`), `findPedigreeNumber()`'s speed (`:294`), poppler in CI (`:306`), the label
counts in `largeIds` (`:287`), and the eight "Ready, small" items (`:215` the suite gate's time limit, `:227` the stale
pedkindraw 0.0.1, `:234` the drift tool and copied constants, `:243` the context-budget tool, `:253` CI notices, `:270`
report a vacuous test, `:276` tell nprcgenekeepr's edition-3 conversion, `:325` tell nprcgenekeepr its timing rows'
`started` is each run's end, new in S81); NEEDS DECISION, Pedixplorer's `avail` (`:108`), long names at the edges
(`:116`), a colony's ids under a point high (`:125`), `findGeneration(alignMates = TRUE)`'s speed (`:298`),
`HANDOFFS.md`'s growth past its trimmer (`:316`); "Waiting on Mark", the dashboard and `methodology/BACKLOG.md`
(`:178`), copying the colony overview (`:185`), the app's features left for later (`:192`), an animal with two mates
drawn once (`:204`). BLOCKED, so not offered: `:36` (the speed vignette, on 17h's runs), `:64` (retire the drift
tools), `:172` (N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options,
so group them and name each in a preview).
**Session boundary:** one session (17h2; if the runs cannot finish in it, commit the rows, close out, and 17h2b runs
the rest at the same commit), then close out.
**Priority:** HIGH (17h2-17h4, then 17i-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S81 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); **and the harness's**, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R` (none through
   S81; nprcgenekeepr at `3e06730c5`, tree clean). A change there is read before touching `tools/timing/`.
2. **S81's push** (every commit `[skip ci]`: `tools/` is build-ignored and no package file changed): no CI run to read.
3. **Read the machine first** (dragon 25): `top -l 2 -n 0 -s 1 | grep 'CPU usage' | tail -1`, `uptime` and `ps -Ao
   pcpu,etime,comm -r | head`. Under half idle, `runTiming.R` waits up to 10 minutes before every run; tell Mark what is
   running before starting a record.
4. **17h2, if picked:** the plan's 17h2 (`:526`), 5.4-5.6 (`:393`-`:418`), dragons 5, 8, 11, 18-25 (`:604`-`:670`).
   Build `PKD_LIB` (under `bash -c`, from a folder Mark names, short and naming no person, dragon 23): `R CMD build
   --no-build-vignettes --no-manual <repo>`, then `R CMD INSTALL --library=<folder>/pkdlib pedkindraw_*.tar.gz`, both
   with renv's library as `R_LIBS` and `R_LIBS_USER` and `RENV_PROJECT` unset (the record refuses an install packaged
   before the last commit to `R/`, `DESCRIPTION` or `NAMESPACE`, dragon 22; that is still S77's `09e8f45`). Then
   `Rscript tools/timing/savePedigrees.R` (8 of 8), `runTiming.R` in the background with nothing else running (it
   writes `results/record.csv`'s row itself), `summarizeTiming.R`, one cell of each kind re-run, the results committed.
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **`PKD_LIB` must be set** or every case test skips (SKIP must read 0) and `runTiming.R` stops before any run ("no
  pedkindraw in PKD_LIB"). **The record's build check** (dragon 22): uncommitted `R/`, `DESCRIPTION` or `NAMESPACE`, or
  an install packaged before their last commit, stops the record at once; rebuild after such a commit.
- **The machine's load** (dragon 25): S81's first trial (8 runs at 300) waited 5 minutes without running one, the Mac 0%
  idle from other work; at 50-74% idle the same 8 runs took 9 minutes. A record started on a busy Mac takes hours more.
- **`timingRuns.csv`'s `pkdLib` is `PKD_LIB`'s full path** (dragon 23), committed by 17h2: build it at a neutral path.
  Its `started` is now each run's launch (dragon 24, fixed); `record.csv` is appended once per `runTiming.R` call in
  `<out>` (a trial with `--out=<scratch>` leaves `results/` alone).
- **A scratch test run outside the root has no renv** (dragon 21): run checks from the root and read SKIP.
- **The test folder takes about 3 minutes** (129 tests; Pedixplorer's `shrink()` about 90 s on each of its two
  pedigrees): run it from the root, alone, never beside a record or the package suite (plan dragon 20).
- **Pedixplorer's `family_check()` stops on the colonies** (R154); kinship2 chooses among ties at random (dragon 18);
  `summarizeTiming.R` says "none up to 100,000" whatever the sizes run (dragon 19).
- **zsh stops a command at a glob with no match**; run build commands under `bash -c`.
- **`methodology/HANDOFFS.md` was not archived** (its trimmer refuses, backlog `:316`): keep the receipt short.
- **Carried:** one-off scripts as `Rscript --no-init-file` with `R_LIBS`, `R_LIBS_USER` set to renv's library, but the
  harness's own commands (`test_dir`, `runTiming.R`, `savePedigrees.R`) as plain `Rscript` from the root, so renv
  activates; zsh does not split an unquoted variable (`bash -c`); the 5-file cap splits commits; the ratchet's suite
  gate times out at 300 s (run the suite by hand, about 10 min, on a `git archive` copy); `CLAUDE.md` is over its
  budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the browser
  tests; scratch files in the scratchpad; the Windows hang (cancel at 40 min).

### Key files
- The harness: `tools/timing/timingHarness.R` (`:43` `useTimingLibraries()`, `:54` `checkPedkindrawFolder()`, `:155`
  `currentMemoryFree()`, `:164` `waitForQuiet()`, `:184` `timeStamp()`, `:291` `runLimited()` (`launched`,
  `callStarted`), `:378` `stopsRecord()`, `:389` `runRow()`, `:406` `parseMachine()`, `:432` `chromeVersion()`, `:448`
  `chromePath()`, `:459` `packageVersions()`, `:468` `packagedTime()`, `:492` `commitFacts()`, `:506` `checkBuild()`,
  `:531` `recordRow()`, `:560` `appendRecordRow()`); `runTiming.R` (`:67`-`:69` the record's row, `:90` `runOnce()`);
  the tests, `tools/timing/tests/test_timingHarness.R:352` and `:368` (S81's `launched` tests), `:642` (the row),
  `:663` (`runRow()`'s arguments); `timingCases.R`, `timeOne.R`, `savePedigrees.R`, `summarizeTiming.R`.
- The plan: `docs/planning/pedkindraw-timing-plan.md` (`:294` 4.2, `:393` 5.4, `:401` 5.5, `:428` 5.8, `:458` 17h1,
  `:491` 17h1b, `:508` 17h1c, `:526` 17h2, `:548` 17h3, `:604` dragons 1-25); R156 in
  `docs/planning/standalone-pedigree-package-plan.md:328`; `docs/planning/cran-submission-plan.md:754` (17h).

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
