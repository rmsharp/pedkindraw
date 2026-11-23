# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 DONE (S42-S77). **17g DONE in S78 (R153):** `docs/planning/pedkindraw-timing-plan.md`, the plan for
pedkindraw's own timing runs: 37 of the 38 exports timed (all but `runPedigreeApp()`) beside the kinship2 1.9.6.2 and
Pedixplorer 1.8.0 functions that do the same, timed again in the same runs; each run a fresh `Rscript`, started once
half the CPU is idle; on the November study's seed-1 colonies (pedkindraw rebuilds them byte for byte, 7 of 7) and the
375-animal sample; by a copy of nprcgenekeepr's `tools/pedigreeComparison/` harness in `tools/timing/`; results
committed under `tools/timing/results/`; the speed vignette (17i) shows pedkindraw's own runs only, to the plan's
section 5.8 outline. 17h is four sessions: 17h1 computation harness, 17h2 its runs, 17h3 drawing harness, 17h4 its runs.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row).
**Next: Phase 17h1, the computation harness** (`docs/planning/pedkindraw-timing-plan.md:406`), **strict TDD, a copy**:
RED, the harness's tests copied from nprcgenekeepr into `tools/timing/tests/` (changed as the plan's section 4.1,
`:230`, says) plus new tests (each of the 78 computation cases, section 5.1 `:306`, returns on the 300-animal colony and
the sample; each pairing gives pedkindraw's answer on typed cases or the difference is recorded, Learning 19; `PKD_LIB`
first on the child's path; a child that loads pedkindraw from another folder fails); GREEN, the files copied and
changed, and the `.gitignore` lines of section 4.2 (`:249`). Pre-RED picker T1 (section 7, `:482`): the inputs of
section 5.2 (`:324`). DONE: `testthat::test_dir("tools/timing/tests")` 0 failed, WARN 0, SKIP 0; `savePedigrees.R` 7
of 7 md5s; a trial `runTiming.R --sizes=300 --out=<scratch>` over all 78 cases, each `ok` (not committed); 
`lintr::lint_dir("tools/timing")` 0; no `R/` change.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17h1 (recommended), or the Windows item (`:11`) first. Also, from `methodology/BACKLOG.md` (30
items, each found at its line by `grep -n '^- \[ \]'` at S78's close-out): READY, the legend's labels in a narrow
drawing (`:73`), the drawing vignette's measured trait (`:83`), a twins table with no rows (`:89`),
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:99`), the `smallPed` fixture (`:132`), rewording
`DIVERGENCE.md`'s older rows (`:55`), tests for full coverage (`:138`), `findPedigreeNumber()`'s speed (`:294`), poppler
in CI (`:306`), the label counts in `largeIds` (`:287`), and the seven "Ready, small" items (`:215` the suite gate's
time limit, `:227` the stale pedkindraw 0.0.1, `:234` the drift tool and copied constants, `:243` the context-budget
tool, `:253` CI notices, `:270` report a vacuous test, `:276` tell nprcgenekeepr's edition-3 conversion); NEEDS
DECISION, Pedixplorer's `avail` (`:108`), long names at the edges (`:116`), a colony's ids under a point high (`:125`),
**new in S78, `findGeneration(alignMates = TRUE)`'s speed (`:298`) and `HANDOFFS.md`'s growth past its trimmer
(`:316`)**; "Waiting on Mark", the dashboard and
`methodology/BACKLOG.md` (`:178`), copying the colony overview (`:185`), the app's features left for later (`:192`),
an animal with two mates drawn once (`:204`). BLOCKED, so not offered: `:36` (the speed vignette, on 17h's runs),
`:64` (retire the drift tools), `:172` (N3). Name every item in the picker (memory "Picker sets: name items, include
all"; at most 4 options, so group them and name each in a preview).
**Session boundary:** one session (17h1), then close out.
**Priority:** HIGH (17h1-17h4, then 17i-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S78 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); **and the harness's log**, `git -C ../nprcgenekeepr log
   --oneline d75f07f6b..HEAD -- tools/pedigreeComparison tools/perf/harness.R tests/testthat/test_perfHarness.R`
   (none through S78; nprcgenekeepr at `3e06730c5`, tree clean). A change there is read before the copy.
2. **S78's push** (docs and methodology only, every commit `[skip ci]`): no CI run to read. If GitHub shows one, read it.
3. **17h1, if picked:** read first the timing plan's sections 3.1 (`:63`, the method and the harness's files), 3.3
   (`:118`, the pairings), 3.4 (`:160`, the three counterpart calls that stopped on the probe's inputs), 4.1 (`:230`,
   what changes in each copied file), 5.1-5.5 (`:306`-`:360`), 6's 17h1 (`:406`), 7 (T1) and 8 (the dragons); then
   nprcgenekeepr's `tools/pedigreeComparison/{timingHarness,timingCases,runTiming,timeOne,summarizeTiming,
   comparisonFormats,generateColonyPedigree,savePedigrees}.R`, `tools/pedigreeComparison/tests/`,
   `tools/perf/harness.R:24`-`:72` and `tests/testthat/test_perfHarness.R:79`-`:131`. Prove the copy by machine
   (Learning 13: `diff` each source and copy, every hunk a planned one). Measure each T1 input before the picker
   (Learning 17): build it on the 300-animal colony and call each paired function.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **The copied tests run on testthat edition 3** (plan dragon 1, Learning 10): `tools/timing/tests/` sits below
  pedkindraw's `DESCRIPTION`. Read WARN as well as FAIL; `expect_warning()` returns the condition.
- **A stale pedkindraw 0.0.1 in renv's library** (plan dragon 2, backlog `:227`): the version is 0.0.1 in both, so the
  harness must check the folder pedkindraw loads from.
- **zsh does not split an unquoted variable** (plan dragon 4): S78's `R="env ... Rscript"; $R x.R` exited at once ("no
  such file or directory"). Run multi-word commands under `bash -c`.
- **Three counterpart calls stopped on the probe's inputs** (plan section 3.4): kinship2 `findAvailNonInform()`
  ("argument is of length zero"), Pedixplorer `useful_inds()` (no `informative` argument), Pedixplorer `num_child()`
  (its columns already in the object). Build each case from its help page.
- **The study's tests source scripts by path from the root** (`helper-sourceScript.R`): run `test_dir()` from the
  repository root.
- **`methodology/HANDOFFS.md` was NOT archived:** its trimmer fired at S78's receipt (201,179 B) and then refused (SRF
  RED: the last archive, S60's, given back; its rule "do not archive again"; `--force` not used). Write a short receipt
  (S61-S78 averaged 5.6 KB; the 262,144 B hard refusal is about 11 sessions away); backlog `:316`. `CHANGELOG.md` is
  about 112 KB.
- **The fidelity tool needs renv active** (app plan dragon 28): `Rscript tools/compareResultsWithNprcgenekeepr.R
  ../nprcgenekeepr` from the root. The drift tool runs either way.
- **Carried:** run Rscript from the root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's library
  (not for the fidelity tool); never two Chrome-starting jobs at once, nor edit the tree while the suite runs (app plan
  dragons 8, 19); the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand,
  about 9.5 min); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked,
  Mark's; `NOT_CRAN=true` for the browser tests; scratch files in the scratchpad; the Windows hang (cancel at 40 min);
  count the full suite with `reporter = "check"`; a docs test's `.docsSection()` ends at a chunk's `## ` comment.

### Key files
- 17h1: `docs/planning/pedkindraw-timing-plan.md` (`:63` 3.1, `:118` 3.3, `:160` 3.4, `:230` 4.1, `:249` 4.2, `:306`
  5.1, `:324` 5.2, `:343` 5.4, `:351` 5.5, `:406` 17h1, `:482` T1-T5, `:494` dragons 1-15);
  `docs/planning/timing-plan-prototype/` (S78's `s78Colonies.R`, `s78ProbePedkindraw.R`, `s78ProbeOthers.R`: how the
  colonies and the inputs were built); nprcgenekeepr's `tools/pedigreeComparison/` (the source; read with `git show`).
- The plans: `docs/planning/cran-submission-plan.md` (`:740` 17g done, `:754` 17h, `:761` 17i, section 9 dragons);
  `docs/planning/standalone-pedigree-package-plan.md` (R153, `:322`; Phase 1 step 4, `:446`, the study's method).
- The draft for 17i: the branch `draft/speed-vignette` (`612eed9`: `vignettes/speed.Rmd`, `tools/checkSpeedTables.R`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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

### What Session 76 Did
**Deliverable:** Phase G17c, what the app draws (`docs/planning/pedigree-app-plan.md:355` at the start, `:766` section
13 now), strict TDD. DONE.
**Started:** 2026-11-22 19:18 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "G17c: what the app draws (Recommended)" (orient); R151's four in one picker ("Common words (Recommended)",
"Up to four, chosen (Recommended)", "By name, any case (Recommended)", "Common codes (Recommended)"); "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Yes, proceed to REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `104907b`; measuring scripts `1902472`; measures and R151 `6a4ef89`; RED `15efe75`; RED amendment
`c79c51f`; GREEN `7dd6aa8` (the code), `55ef40f` (help, NEWS, contract), `f7ef71a` (GREEN 3: two tests found by covr),
`cc78918` (GREEN 4: the cut-off symbols as escapes); REFACTOR `8ee85f0`; close-out 1b `d330a61` (roadmap, backlog);
close-out 1 `2b27681` (the plans, dragons 20-23); close-out 2 (these notes, the receipt, the ledger), pushed after it.
**Measured first** (plan section 13): on 14 pairs of values in each condition and mark column, read as the app reads a
file, a condition was drawn right only for TRUE/FALSE, true/false and T/F, **every other pair, 1/0 included, drawing all
animals grey "unknown" with no message**, and a yes-or-no mark stopping the whole drawing (its message saying "give 1 or
0"); a cut-off on a file's numbers always stopped; `status` marked only the exact `DECEASED`; a file's `Affected` column
was not read; the three ways offered drew 3, 4 and 6 of 9 pairs right; a view with half a twin pair stopped the layout
(the sample's UZ pair spans families 1 and 2); `checkTwinRelations()` stops at the first problem and reads only the three
exact codes; a twins table with no rows stops the layout (copied code); the layout's and the drawing's `edgeStyle` both
matter; a file set by DevTools reaches the app's file box (and showed the Y/N carrier stop in the real app).
**Built:** conditions chosen (up to four) with cut-offs, the marks found by name, the common words, lines, a twins file,
the sample's twins (`R/pedigreeApp.R`); 21 new tests and 1 changed (the app's files 64 tests, 419 expectations); help,
NEWS, the contract's section 4.7.
**Verified:** RED 19 failing for the right reason, the other 43 passing, SKIP 0, WARN 0; the full suite at `55ef40f` 90
files, 16,754 expectations, 0 failed, 0 warnings, 0 skipped (548 s), and at `8ee85f0` `[ FAIL 0 | WARN 0 | SKIP 0 |
PASS 16761 ]` (548 s); `R CMD check --as-cran` at `f7ef71a` 1 WARNING (non-ASCII), at `cc78918` 0 errors, 0 warnings, 1
NOTE (new submission; a transient GitHub 503 cleared on the same tarball), `PASS 16734` SKIP 6 (609 s); CRAN path 60 app
tests 8.44 s; coverage 392/392 after the REFACTOR (397/397 before) and 16/16; examples errors 0; lint 0; roxygen no
change; drift 91 / 23 / 0; fidelity 600 / 600; the gap case; the REFACTOR's 403 cases `identical()`; quality_ratchet:
5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb (the suite gate's 300 s limit; by hand
above); by hand in Chrome: the sample with its twins, a spreadsheet-like file uploaded (marks listed, a cut-off, a DZ
pair from "2", straight lines; two pictures looked at), a bad twins file named, a "maybe" named.
**Found:** a twins table with no rows stops the layout and an empty cell gets R's own words in `checkTwinRelations()`
(backlog `:117`; the same in nprcgenekeepr).
**Not run:** another browser, a real file dialog, a phone-width window, a hosted server.
**After close-out 2 (its push, run 45107545938, read in close-out 2b):** pkgdown `success`; Ubuntu release and oldrel-1 `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16707 ]`; macOS `[ FAIL 0 | WARN 0 | SKIP 9 | PASS 16718 ]`; Windows `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16716 ]`, `proc.time()` 955 s, and the hang a ninth time (cancelled at 41 minutes; two orphan `Rterm` processes and one `cmd`); Ubuntu R-devel red in "setup-r-dependencies" (S4Vectors, known). Each count is S75's plus G17c's 157 expectations, as predicted.

#### Session 75 Handoff Evaluation (by Session 76)
**Score: 9/10.** ROI high: "What You Must Do" 3 was the session's first hour, and its measure became the picker.
- **What helped:** "the app reads every column of a file as text ... measure what the layout and
  `drawPedigreeDiagram()` do with each such text column before the picker" was exactly the measure that found the silent
  grey conditions and the stopping marks, and its guess ("some will be refused or drawn as unknown") held; "F12 needs
  `edgeStyle` passed to both" held when measured; "G17c's choices go between `shown()` and `.appDraw()`" was where
  `prepared()` went; dragons 14 and 16 (every output computed; a `reactiveVal` for what the server also writes) shaped
  `chosenConditions`; drift 91/23/0, nprcgenekeepr's 4 commits at `3e06730c5` and the 28 backlog lines all held.
- **What was missing:** that the sample has a twins file in `inst/extdata` (found by listing the folder; it became an
  option in the picker); which reporter gives the suite's totals (the summary reporter does not; dragon 22).
- **What was wrong:** nothing; "F13 ... `checkTwinRelations()`'s problems on the page" is one problem at a time (it
  stops at the first), a wording, not a wrong claim.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; measured before the picker (14 value pairs in 8 columns, the three ways on
  9 pairs, twins, lines, an upload through DevTools probed in the real app), so the picker stated counts and Mark took
  all four recommended options at once; every RED value computed first; RED failed 19 for the right reason; `covr` read
  before calling GREEN done (two tests added); the REFACTOR proved over 403 cases; a by-hand run through the page's own
  controls with pictures.
- **The two slips that reached commits:** RED did not look for tests that read the sample, which R151 changed (the RED
  amendment `c79c51f`, dragon 21, the same class as S75's slip); and the Edit tool turned my `\u2265` escapes into
  characters, which `R CMD check` warned on (GREEN 4 and a second 10-minute check; dragon 20).
- Other slips, none reaching a commit: the gate announced 18 tests and RED wrote 19 (one split in two); the first
  failure-reason script printed `NA` (it matched squashed names); the first full suite used the summary reporter, so its
  count needed a script; a zsh array read from 0 gave a nonsense elapsed time.
