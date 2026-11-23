# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17g DONE (S33-S78); the gap
phases G1-G17 DONE (S42-S77). **17h1 DONE in S79 (R154):** the computation timing harness, copied from nprcgenekeepr's
`tools/pedigreeComparison/` at `3e06730c5` into `tools/timing/` test-first: 9 harness files, 9 test files, 78 cases
(37 pedkindraw, 18 kinship2, 23 Pedixplorer) on R154's inputs, each pairing's answer checked against pedkindraw's or
its difference recorded; `test_dir("tools/timing/tests")` with `PKD_LIB` set `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 1143 ]`;
`savePedigrees.R` 8 of 8 files the study's; a trial at 300 animals 77 of 78 cases `ok` (Pedixplorer's `family_check()`
stops on the colonies, as R154 recorded). No package file changed.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Found at S79's close-out (backlog `:325`):** `runTiming.R` records each run's idle share and load but not its free
memory, which the timing plan's section 5.4 (`:388`) requires, and nothing writes `record.csv` (section 4.2, `:291`).
**Next, recommended: 17h1b** (backlog `:325`), **strict TDD, one short session:** a `memFree` column from
`currentMemoryFree()` (`tools/timing/timingHarness.R`) in each run's row of `runTiming.R`, and a writer for
`record.csv` (a function in `timingHarness.R`, tested in `tools/timing/tests/test_timingHarness.R`); then **17h2, the
computation runs** (timing plan `:484`, no code, about 3.5-4 hours of background runs, a guess).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17h1b (recommended), 17h2 without it (the record then lacks free memory; section 5.4 amended),
or the Windows item (`:11`). Also, from `methodology/BACKLOG.md` (31 items, each found at its line by `grep -n '^- \[ \]'`
at S79's close-out): READY, the legend's labels in a narrow drawing (`:73`), the drawing vignette's measured trait
(`:83`), a twins table with no rows (`:89`), `savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:99`),
the `smallPed` fixture (`:132`), rewording `DIVERGENCE.md`'s older rows (`:55`), tests for full coverage (`:138`),
`findPedigreeNumber()`'s speed (`:294`), poppler in CI (`:306`), the label counts in `largeIds` (`:287`), and the seven
"Ready, small" items (`:215` the suite gate's time limit, `:227` the stale pedkindraw 0.0.1, `:234` the drift tool and
copied constants, `:243` the context-budget tool, `:253` CI notices, `:270` report a vacuous test, `:276` tell
nprcgenekeepr's edition-3 conversion); NEEDS DECISION, Pedixplorer's `avail` (`:108`), long names at the edges
(`:116`), a colony's ids under a point high (`:125`), `findGeneration(alignMates = TRUE)`'s speed (`:298`),
`HANDOFFS.md`'s growth past its trimmer (`:316`); "Waiting on Mark", the dashboard and `methodology/BACKLOG.md`
(`:178`), copying the colony overview (`:185`), the app's features left for later (`:192`), an animal with two mates
drawn once (`:204`). BLOCKED, so not offered: `:36` (the speed vignette, on 17h's runs), `:64` (retire the drift
tools), `:172` (N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options,
so group them and name each in a preview).
**Session boundary:** one session (17h1b, or 17h2), then close out.
**Priority:** HIGH (17h1b, 17h2-17h4, then 17i-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S79 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); **and the harness's**, `git -C ../nprcgenekeepr log --oneline
   3e06730c5..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R` (none through
   S79; nprcgenekeepr at `3e06730c5`, tree clean). A change there is read before touching `tools/timing/`.
2. **S79's push** (every commit `[skip ci]`: `tools/` is build-ignored and no package file changed): no CI run to read.
3. **Build `PKD_LIB` first** (every harness test and run needs it; timing plan `:484`'s Work has the commands): from a
   scratch folder, `R CMD build --no-build-vignettes --no-manual <repo>`, then `R CMD INSTALL
   --library=<scratch>/pkdlib pedkindraw_*.tar.gz`, both with renv's library as `R_LIBS` and `R_LIBS_USER` and
   `RENV_PROJECT` unset; then `Rscript tools/timing/savePedigrees.R` (8 of 8; the data files are git-ignored).
4. **17h1b, if picked:** read `tools/timing/runTiming.R:77` (`runOnce()`, the row written), `timingHarness.R:135`-`:170`
   (`parseMemoryFree()`, `currentMemoryFree()`, `waitForQuiet()`), the plan's sections 4.2 (`:291`) and 5.4 (`:388`).
   Pre-RED: what `record.csv` holds and how Chrome's version is read without starting Chrome (17h4 needs it; measure
   first, Learning 17). RED in `test_timingHarness.R`; GREEN; the folder's tests (`PKD_LIB` set) 0 failed, 0 warnings,
   0 skipped; lint 0.
5. **17h2, if picked:** the plan's 17h2 (`:484`), 5.4-5.6 (`:388`-`:406`), dragons 5, 8, 11, 18-20 (`:559`); run
   `runTiming.R` in the background (all 78 cases, six sizes) with nothing else running, then `summarizeTiming.R`.
6. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **`PKD_LIB` must be set** or every case test skips (SKIP must read 0) and every pedkindraw run stops naming PKD_LIB
  (`stopsRecord()` ends a record on it). renv's library holds a stale pedkindraw 0.0.1 (backlog `:227`); the harness
  checks the folder pedkindraw loads from (`checkPedkindrawFolder()`, `timingHarness.R:45`).
- **The test folder takes about 3 minutes** (Pedixplorer's `shrink()` about 90 s on each of its two pedigrees): run
  it from the root, alone, never beside a record or the package suite (plan dragon 20).
- **Pedixplorer's `family_check()` stops on the colonies** ("'dimnames' applied to non-array"): its cell is `error`
  at 300 and its ladder ends there (R154). kinship2 chooses among ties at random; `timeOne.R` sets seed 1 (dragon 18).
- **`summarizeTiming.R` says "none up to 100,000"** for a case with no failure, whatever the sizes run (dragon 19).
- **The sample's file writes unknown parents as `NA`** (dragon 16); `savePedigrees.R` writes the comparison CSV.
- **`x[[name]] <- NULL` drops the element** (dragon 17): RED's first helper lost Pedixplorer's `NULL` and needed an
  amendment.
- **`methodology/HANDOFFS.md` was not archived** (its trimmer refuses, backlog `:316`): keep the receipt short.
- **Carried:** run Rscript from the root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's
  library for one-off scripts, but the harness's own commands (`test_dir`, `runTiming.R`, `savePedigrees.R`) as plain
  `Rscript` from the root, so renv activates and the children find kinship2 and Pedixplorer; zsh does not split an
  unquoted variable (run multi-word commands under `bash -c`); the 5-file cap splits commits; the ratchet's suite gate
  times out at 300 s (run the suite by hand, about 9.5 min, on a `git archive` copy so the tree can be edited);
  `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's;
  `NOT_CRAN=true` for the browser tests; scratch files in the scratchpad; the Windows hang (cancel at 40 min).

### Key files
- The harness: `tools/timing/timingHarness.R` (`:34` `useTimingLibraries()`, `:45` `checkPedkindrawFolder()`, `:155`
  `waitForQuiet()`, `:276` `runLimited()`, `:361` `stopsRecord()`), `timingCases.R` (`:35` `timingInputs()`, `:64`
  `familyNumbers()`, `:158` `studyCases()`, `:324` `pairedCases()`, `:555` `pedkindrawOnlyCases()`), `runTiming.R`
  (`:77` `runOnce()`), `timeOne.R`, `savePedigrees.R`, `summarizeTiming.R`, `measure.R`, `comparisonFormats.R`,
  `generateColonyPedigree.R`; tests in `tools/timing/tests/` (`helper-caseValues.R`, `test_timingPairings.R`: R154's
  differences); `tools/timing/results/pedigreeFiles.csv`.
- The plan: `docs/planning/pedkindraw-timing-plan.md` (`:226` 3.8 T1's measures, `:291` 4.2, `:348` 5.1, `:366` 5.2,
  `:388` 5.4, `:396` 5.5, `:451` 17h1 and its Done note, `:484` 17h2, `:503` 17h3, `:547` T1-T5, `:559` dragons 1-20);
  R154 in `docs/planning/standalone-pedigree-package-plan.md:324`; `docs/planning/cran-submission-plan.md:754` (17h).
- S79's measuring scripts: `docs/planning/timing-plan-prototype/s79T1Probe1.R`-`s79T1Probe3.R`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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

### What Session 77 Did
**Deliverable:** Phase G17d, saving and the documents (`docs/planning/pedigree-app-plan.md:367`, section 14), strict
TDD. DONE; with it G17 and every gap phase G1-G17.
**Started:** 2026-11-22 23:15 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "G17d: saving and docs (Recommended)" (orient); R152's four in one picker ("Animals tab rows (Recommended)",
"Grey buttons + a line (Recommended)", "The default page (Recommended)", "Fold it in (Recommended)"); "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `7bfbcb8`; measuring scripts `540a4aa`; measures and R152 `dbe4c8e`; RED `9581ea6`; GREEN `1d2fa87`
(the code), `6257a9d` (the app's help, NEWS), `09e8f45` (the help of `drawPedigreeDiagram()` and the package),
`b064df2` (README, vignettes, drawing times), `bd5df01` and `6512521` (the contract); REFACTOR `720b6e4`; close-out 1b
`4f421fa` (roadmap, backlog); close-out 1 `4f93a52` (the plans, dragons 24-28); close-out 2 (these notes, the receipt,
the ledger), pushed after it.
**Measured first** (plan section 14): a download's content runs in `testServer()` only when the output is read, which
gives the file's path; the app's SVG of the sample `identical()` to `savePedigreeDiagram()` called directly (545 id
texts, 375 distinct), SVG 1.59 s, PDF 2.69 s, PNG 2.46 s; a defined download button live before any pedigree, an
undefined one greyed; with Chrome hidden a picture download a server error and the page silent; `find_chrome()` returns
`CHROMOTE_CHROME` unchecked; both CSV choices reopened to the identical layout in 10 of 10 views; an id 0.5 pt in the
whole sample at the default page, 6.8-8.8 pt in a family of 11-13; a `renderUI`-drawn download button enabled when
defined, greyed when not (probed before RED).
**Built:** `.appPictureProblem()`, `.appPictureDownload()`, the server's `pictureProblem`, the outputs `saves`,
`saveSvg`, `savePdf`, `savePng`, `saveRows`, `saveCsv` (`R/pedigreeApp.R`); 18 new tests (`test_pedigreeAppSave.R`,
`test_runPedigreeAppDocs.R`), `helper-docs.R`, `.startPedigreeApp(childEnv)`; help, NEWS, README (both), both
vignettes (pedkindraw's own drawing times too), the package help, a `@seealso`, the contract's sections 4.7, 7 and 8.
**Verified:** RED 18 failing for the right reason, the other 70 passing, SKIP 0, WARN 0; the full suite at `6512521`
and at `720b6e4` `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16862 ]` (561 s, 566 s); `R CMD check --as-cran` at `6512521` 0
errors, 0 warnings, 1 NOTE (new submission), `[ FAIL 0 | WARN 0 | SKIP 14 | PASS 16794 ]` (639 s); CRAN path 67 app tests
11.12 s; coverage 417/417 and 16/16; examples errors 0; lint 0; roxygen no change; drift 91 / 23 / 0; fidelity 600 / 600;
the gap case; the REFACTOR's record `identical()`; quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results
534fea217641 · manifest f447be95addb (the suite gate's 300 s; by hand above); by hand in Chrome: each button clicked and
its file saved by Chrome (SVG 545 ids, PDF, PNG 3,000 x 1,534, CSV 375 rows), the CSV reopened through the page to 375
animals, the page without Chrome (three pictures looked at).
**Found:** `savePedigreeDiagram()` takes a `CHROMOTE_CHROME` naming no file for a Chrome found (backlog `:97`); the
contract's section 8 claimed a help page states the measured drawing limit, which none does (noted in `:36`).
**Not run:** another browser, a real file dialog or the user's Downloads folder, a phone-width window, a hosted server.
**After close-out 2 (its push, `9574fc5..ad5efbd`, run 45125145050, read in close-out 2b):** pkgdown `success`; Ubuntu release and oldrel-1 `[ FAIL 0 | WARN 0 | SKIP 19 | PASS 16767 ]`; macOS `[ FAIL 0 | WARN 0 | SKIP 17 | PASS 16778 ]`; Windows `[ FAIL 0 | WARN 0 | SKIP 19 | PASS 16776 ]`, `proc.time()` 954 s, and the hang a tenth time (cancelled at 41 minutes; two orphan `Rterm` processes, one `cmd`, one `conhost`); Ubuntu R-devel red in "setup-r-dependencies" (S4Vectors, known). Each count as predicted before the push.

#### Session 76 Handoff Evaluation (by Session 77)
**Score: 9/10.** ROI high: "What You Must Do" 3 was the session's first hour, and its four measures became the picker.
- **What helped:** the four measures named in What You Must Do 3 (a download in Chrome, what `testServer()` gives for
  a download, the page without Chrome, which drawing and rows) were sections 14.1-14.4 and three of R152's four
  questions, and the "(a guess)" on `testServer()` was honest; offering backlog `:109` for the picker became R152's
  fourth pick; the server's map by line (`drawing()` `:941`, `shown()`, `prepared()`) said exactly where the downloads
  read; dragons 14 and 20-22 (names in `testServer()`, the escapes, the check reporter) each applied; drift 91/23/0,
  nprcgenekeepr's 4 commits at `3e06730c5` and the 29 backlog lines all held; the ledger-size warning.
- **What was missing:** that README.md names `runPedigreeApp()` nowhere yet (found by grep; the docs list implied a
  sentence beside an existing one); that the fidelity tool must run with renv active (dragon 28: my first run failed);
  that `.docsSection()` stops at a chunk's `## ` comments (dragon 24) -- not knowable to S76.
- **What was wrong:** nothing. "Archive `HANDOFFS.md` at the next close-out" was a prediction: the trimmer did nothing
  at 191,452 B (under its 196,608 B threshold), so the archive moves to S78.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; measured before the picker (lazy downloads in `testServer()`, each
  picture in Chrome and its identity with the direct call, the page without Chrome, 10 CSV round trips per choice, the
  ids' sizes), so Mark took all four recommended options at once; the one unmeasured mechanism (a `renderUI`-drawn
  button's greying) probed in Chrome before RED; every RED value computed first; RED 18 for the right reason; the save
  tests passed on GREEN's first run; the full suite twice; coverage 417/417; a by-hand run that clicked the real buttons
  and saved real files; the REFACTOR proved by an `identical()` record.
- **The slips that reached commits:** the contract's section 8 row with the same stale time was found only by a grep
  after GREEN 5, so it needed its own commit (GREEN 5b); I should have grepped every planning document for the old
  times before writing any. And the docs test of "Clicks in a Shiny application" failed on GREEN's first docs run
  because I had not run `.docsSection()` on a section whose chunk holds `## ` comments (Learning 18: a prediction until
  run); the fix moved the sentence, not the test, inside GREEN 4.
- Other slips, none reaching a commit: the first fidelity run started without renv (dragon 28); a draft vignette sentence
  said the app redraws on a click, against R150, caught before commit; the first CSV probe passed a server reactive as an
  input (dragon 14); a timing command passed the library as an argument; a zsh glob; one 81-character test line.

