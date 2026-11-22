# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G16 DONE (S42-S72).
**G17 (gap A3, a ready-made app) PLANNED in S73 (R148):** `docs/planning/pedigree-app-plan.md`. Mark's four picks, each the
recommended one: the app does **16 of the 21** things Pedixplorer's app and nprcgenekeepr's Pedigree Browser do (F1, F3-F9,
F11-F13, F15-F18, F19 as a warning; the plan's section 2.3 defines F1-F21); **`shiny` in Suggests**; `testServer()` tests run
on CRAN, browser tests (`callr` + `chromote`) skip there; **one exported function**, its name at G17a's picker. Four build
sessions, G17a-G17d (a guess): G17a the app starts, opens a file and draws everyone; G17b choosing the animals; G17c what is
drawn; G17d saving and the documents (plan section 7, `:297`). Waiting in the backlog (`methodology/BACKLOG.md:191`): F2
Excel, F10 colours, F14 a matings file, F20 the colony overview, F21 the sizes.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; six runs in a row).
**Next: G17a** (`docs/planning/pedigree-app-plan.md:322`), strict TDD, one session; then G17b-G17d; then 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S73's commits are documents only,
each with `[skip ci]`; pushed at close (Mark's standing pick), so no workflow ran and nothing is left to read.
**The orient picker:** G17a (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from `methodology/BACKLOG.md`:
READY, the legend's labels in a narrow drawing (`:91`), the drawing vignette's measured trait (`:101`), the `smallPed`
fixture (`:131`), rewording `DIVERGENCE.md`'s older rows (`:73`), tests for full coverage (`:137`),
`findPedigreeNumber()`'s speed (`:290`), installing poppler in CI (`:294`), tracing the label counts in `largeIds`
(`:283`), and the seven "Ready, small" items (`:211` the suite gate's time limit, `:223` the stale pedkindraw 0.0.1 in renv,
`:230` the drift tool and copied constants, `:239` the context-budget tool, `:249` CI notices, `:266` report a vacuous
test to nprcgenekeepr, `:272` tell nprcgenekeepr's edition-3 conversion); NEEDS DECISION, a converted Pedixplorer object's
`avail` (`:107`), long names at the edges (`:115`), a colony's ids under a point high (`:124`); "Waiting on Mark", the
dashboard not seeing `methodology/BACKLOG.md` (`:177`), copying nprcgenekeepr's colony overview (`:184`), **the app's
features left for later (`:191`, new in S73)**, an animal with two or more mates drawn once (`:200`). BLOCKED, and so not
offered: `:36` (the speed vignette), `:82` (retire the drift tools), `:171` (nprcgenekeepr imports pedkindraw). Name every
item in the picker (memory "Picker sets: name items, include all"; max 4 options, so group them and name each in a
description). Each title was found at its line by `grep -n '^- \[ \]'` when S73 closed out (27 items, the G item at `:51`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S73 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S73.
2. **No push of S73's to read:** every commit is documents only with `[skip ci]`. The last pushes that ran CI were S72's
   (Windows `FAIL 0 WARN 0 SKIP 11 PASS 16297` and the hang). A guess for the next push that changes code or tests: S72's
   shape (`SKIP` 11 on Ubuntu and Windows, 9 on macOS, pkgdown `success`), plus G17a's new tests: its server tests run on
   every job (shiny is installed from Suggests by `setup-r-dependencies`), its browser tests skip on macOS.
3. **G17a, if picked** (plan section 7, `docs/planning/pedigree-app-plan.md:322`; section 5 `:230` is the interface proposal).
   **Measure first, before the pre-RED picker** (Learning 17): (a) how the test's second R process loads the code under
   test, under `testthat::test_local()` (source) and under `R CMD check` (installed), and never renv's stale pedkindraw
   0.0.1 (`BACKLOG.md:223`; plan dragon 1, `:384`); (b) the name: `runPedigreeApp()` that runs, or `pedigreeApp()` that
   returns the app object (Pedixplorer's `ped_shiny()` way), each tried on a scratch copy; (c) the server tests' time on
   CRAN's path (`NOT_CRAN` unset). The prototype (`docs/planning/pedigree-app-prototype/app.R`, 135 lines) is the starting
   shape; each piece is written by strict TDD, not copied blind. G17a also adds `shiny` and `callr` to Suggests (both
   already in `renv.lock`: no install; run the `renv-lock-no-latest-repository` gate if anything is snapshotted).
4. TDD for any code session: declare the phase at the top of every response; each transition (`PRE-RED->RED`,
   `RED->GREEN`, `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **The app's dragons are the plan's section 8 (`:382`), 12 of them; the ones that bite first:** the second process must
  load the code under test (1); a `callr::r_bg()` child inherits the parent's environment, `CHROMOTE_CHROME` too (10,
  measured); `testServer()` cannot see `update*Input()` or a click (3); the layout warns on the 375-animal sample ("72
  same-row edge-node collision(s)"), so a test that draws it must expect the warning (4; WARN 0 gate); `%||%` is base R
  only from 4.4.0 and pedkindraw depends on 4.1.0 (5); a fixed port collides (7); every `shiny` call is `shiny::` (6).
- **Running the prototype's scripts:** `Rscript --no-init-file -e 'source("renv/activate.R")' -e
  'source("docs/planning/pedigree-app-prototype/measureServer.R")' docs/planning/pedigree-app-prototype` (the folder last;
  an explicit `--args` reaches the script as its first argument). A `source()`d script's top-level `on.exit()` runs at
  once: it killed the first browser run's app (`measureBrowser.R` wraps its steps in `main()`).
- **`makePedigreeMatingLayout()` needs `gen`** (`findGeneration()`); conditions are any columns whose names start with
  `affected` (`.conditionColumns()`, `R/affectedConditions.R:69`); the deceased mark reads `status` ("DECEASED").
- **Windows:** the check step hangs after the tests (six runs, S69-S72); cancel at 40 minutes, read the log (`gh api
  --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`); its
  `proc.time()` line is the tests' time. S71's cancel found two orphan `Rterm` processes, and G17a's browser tests add a
  second R process: kill it at teardown and read the first push for a change in the hang (plan dragon 2). Start a
  watcher's clock from `date -u +%s` (this shell's `date` is GNU; BSD `date -j` misparses).
- **Do not run two Chrome-starting jobs at once** on the Mac (the suite, the ratchet, a check, a prototype run). The shared
  test Chrome's window is 1200 px wide (`captureBeyondViewport = TRUE` for a wider photograph).
- **Run the DONE check the way GitHub does:** `bash tools/checkExamples.sh` (gate `examples-no-open-connections`) and `R
  CMD check --as-cran` with `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder (S72's: 594 s,
  1 NOTE for the new submission, `[ FAIL 0 | WARN 0 | SKIP 6 | PASS 16306 ]`). An example that starts a browser or an app
  is guarded with `interactive()`. Also read the check's test line with `NOT_CRAN` unset for the server tests' CRAN time.
- **The Linux box:** `tools/linux/runTests.sh [filter]` (Docker Desktop; image `pedkindraw-linux`, Ubuntu 26.04 arm64, R
  4.6.1, Chrome 158); it prints counts, not an error's text; it has no kinship2 or Pedixplorer; whether it has shiny and
  callr for G17a's tests is not checked.
- **README.md is made from README.Rmd in a scratch copy** with the current package installed in a scratch library, not
  from renv's stale pedkindraw 0.0.1 (`BACKLOG.md:223`); diff it against the old README.md before copying.
- **G16's own gotchas** (PDF words by `pdftotext`, the PNG's ink, the recording layer) are the picture-files plan's dragons
  31-43 (`docs/planning/picture-files-plan.md`); `savePedigreeDiagram()` works inside the app (plan finding 3).
- **zsh does not split an unquoted `$var`** (use `bash -c '...'`); `rm -rf name*` with no match aborts a zsh `&&` chain;
  a `cd` into `methodology/` persists (run the ratchet in a subshell); BSD `sed -i` needs an argument (use python).
- **Carried:** run Rscript from the root and a scratch copy with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set
  to renv's library; guard every variable in a removal path; the 5-file cap splits commits; the ratchet's suite gate times
  out at 300 s (run the suite by hand, 7.5-9 min; S72: 536 s); `CLAUDE.md` is over its budget (learnings go to the plans'
  dragons); `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the browser tests; scratch files go in the
  scratchpad, never `/tmp`. renv prints "The project is out-of-sync" on activation (pre-existing; not S73's).
- **Ledger sizes** (S73's close-out): see the receipt; `CHANGELOG.md` is near its 196,608 B archive threshold: archive it
  with `methodology_trim.py` when it passes (`--check` first).
- **Times** (S73's, this Mac): the prototype's server walk 4.7 s (6.2 s with R's start); its browser walk 8.5 s; the
  375 animals drawn in the app 2.6 s; a view of a few animals 0.02-0.05 s; Pedixplorer's app answers in 1.82 s.

### Key files
- G17: `docs/planning/pedigree-app-plan.md` (`:88` section 2.3, F1-F21; `:123` section 3, the prototype's measures and
  `:173` its findings; `:197` section 4, R148; `:230` section 5, the interface; `:267` section 6, the inventory; `:297`
  section 7, `:322` G17a, `:341` G17b, `:354` G17c, `:365` G17d; `:382` section 8, dragons; `:417` out of scope);
  `docs/planning/pedigree-app-prototype/` (`app.R`, `measureServer.R`, `measureBrowser.R`, `countDependencies.R`);
  `docs/planning/standalone-pedigree-package-plan.md:312` (R148), `:97` (Next); `docs/planning/gaps-and-shared-code-plan.md:387`
  (G17's row), `:23` (Next); `methodology/BACKLOG.md:51` (G15-G17), `:191` (the app's features left for later), `:11`
  (Windows), `:223` (stale pedkindraw 0.0.1).
- What G17a touches (the plan's inventory): `DESCRIPTION:27`-`:36` (Suggests); `_pkgdown.yml:18`-`:23` (the "Drawing"
  group); `tools/gapCases.R:344`-`:354` (`cases$app`); `tests/testthat/helper-live-render-positions.R:136`
  (`ChromoteSession$new()`), `:190` (`skip_if_no_chrome()`); `inst/extdata/obfuscated_rhesus_mhc_ped.csv` (the sample:
  375 animals, 5 families, columns id, sire, dam, sex, gen, birth, exit, age); `R/drawPedigreeDiagram.R:166`-`:177` (the
  `onClick` help), `:513`-`:520` (the duplicate-ids note); `docs/planning/pedkindraw-api-contract.md:91` (section 4),
  `:261` (section 5, dependencies).
- nprcgenekeepr's app, read not run: `../nprcgenekeepr/R/modPedigree.R` (`:262` the server, `:907`-`:917` the click
  rules), `R/runGenekeepr.R:51`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 73 Did
**Deliverable:** G17's planning session, the plan for gap A3 (a ready-made app): `docs/planning/pedigree-app-plan.md`.
DONE. No package code (the prototype beside the plan is measured scratch code under `docs/`, which the build ignores).
**Started:** 2026-11-22 12:21 CST · **Model:** Claude Sonnet 5.5 for orientation and the claim, then Claude Opus 5.5 from the
first evidence reads on (the harness switched it; the claim commit `b1c317e` carries Sonnet's trailer, the rest Opus's) ·
**Mark's picks (each first time, all the recommended option):** "G17 planning session (Recommended)" (orient); R148's four,
in one picker: "Both apps' core", "Suggests", "Server tests on CRAN", "One function". No correction and no tool use declined.
**Commits:** claim `b1c317e`; the evidence draft `0bf0019` (sections 1-3 and 6, the prototype); the plan `61c62f2` (sections
4-5, 7-10 after the picks); close-out 1 `275037a` (R148 in the standalone plan, the gaps plan's G17 row, the Next lines);
1b `8e78475` (roadmap, backlog; the plan's backlog citations re-found); close-out 2 (these notes, the receipt, the ledger),
pushed after it.
**Measured** (scripts in `docs/planning/pedigree-app-prototype/`): `shiny` adds 11 packages to pedkindraw's 32 (`bslib`
with it), DT 3 more, readxl 14, shinytest2 6 new to renv's library; the prototype app (135 lines, pedkindraw's exports only)
under `testServer()`: 4.7 s for five drawings of the 375-animal sample, 0.02-0.05 s a small view, a second run within 0.03
s; in headless Chrome: answers 1.23 s, connects 1.57 s, draws the sample 2.61 s (1,460 nodes), and `savePedigreeDiagram()`
inside the app returns an 843,620-character SVG in 1.82 s; Pedixplorer's `ped_shiny()` answers in 1.82 s (102 inputs);
nprcgenekeepr's Pedigree Browser read (970 lines and 12 helpers pedkindraw lacks, about 970 lines; 9 testServer files with
171 tests, 4 shinytest2 files). **Found:** the layout needs `gen`; the layout's warnings reach only the app's console (72 on
the sample); `testServer()` cannot see `update*Input()`; `%||%` is R 4.4+; a `callr` child inherits the environment.
**Corrected before commit:** two feature counts (17 and 14 of 21, first written 15 and 11), the helper count (12, first
13), dragon 10 (I had written that a `callr` child inherits `CHROMOTE_CHROME` only if passed; measured, it inherits), the
prototype's run command (an explicit `--args` broke it), the `cases$app` range (`:354`, not `:352`).
**Verified:** no file under `R/`, `tests/`, `inst/`, `man/`, `vignettes/`, `DESCRIPTION`, `NAMESPACE`, README, NEWS,
`_pkgdown.yml` or `.github/` changed since S72's close (`git diff --name-only ab5dda0..HEAD`: 0); drift 91 / 23 / 0 at
orient; quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite at 8e78475 (NOT_CRAN=true), 85 files, 1,064 tests, 16,342 expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (530 s). **Not run:** `R CMD check` (no package file changed since S72's check).

#### Session 72 Handoff Evaluation (by Session 73)
**Score: 9/10.** ROI high: the planning session needed no discovery the notes could have saved.
- **What helped:** "What You Must Do" item 3 named every piece of G17's evidence and where it lives (the gap at `:144`,
  `runGeneKeepR()`, `ped_shiny()` 1.8.0 in renv, `cases$app`, the runner's planning rules, S68's plan as the precedent):
  the reading list was the session's first hour; drift 91/23/0 and nprcgenekeepr's 4 commits at `3e06730c5` held exactly;
  the orient picker's 26 backlog lines all held (checked against S72's tree); the stale pedkindraw 0.0.1 gotcha became the
  plan's dragon 1; "do not run two Chrome-starting jobs at once" shaped when I ran the ratchet.
- **What was missing:** that pedkindraw ships no `data/` (the sample an app needs is `inst/extdata`'s 375 animals); that the
  `app` case only reads Pedixplorer's arguments and starts nothing.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; measured before the picker (dependencies, the server and browser times, both
  references), so the picker stated counts and Mark took each recommended option at once; the scope picker named all 21
  items with an "all" option and the reasons against it (memory "Picker sets"); each phase has its DONE, commands, surface
  (and what no surface here enforces) and session boundary; the inventory is grep's; every cited line re-found after the
  last edit, including the backlog's shift.
- **Slips:** the scope option's preview headed "BUILDS (15)" over a list of 16 (recorded in the plan's section 4, R148);
  five wrong statements in my own draft, each caught by re-reading or by a measure before its commit (listed above), two
  of them claims I had not run (dragon 10 and the run command), which Learning 18 says to run first; two malformed picker
  calls cost two round trips; a measuring script's top-level `on.exit()` killed its own app on the first run.
- The session counts (1 + 4) and the CRAN time of the server tests (1-3 s) are guesses; the timings are this Mac's.

### What Session 72 Did
**Deliverable:** Phase G16c, the whole large pedigree on one page and the documents (the `largeIds` case,
`docs/planning/picture-files-plan.md` section 7, G16c), strict TDD. DONE.
**Started:** 2026-11-22 06:40 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16c (Recommended)" (orient); the three pre-RED picks in one picker (R147: "SVG in Chrome + pdftotext", "Pixel
floor + dpi advice", "Guarded example, checks in tests"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, proceed to
REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `8cada92`; measures and picks `ea1eeb0`; RED `3fd1caf`; GREEN `c1836a1` (help and NEWS; its message
amended once before any push: it said "6 fail" for 21), `61370be` (README and the two vignettes), `1187457` (the `largeIds`
probe); REFACTOR `6dcbf76`; close-out 1 `fc73f5b` (the plans), 1b `c145726` (roadmap, backlog); close-out 2 (these notes, the
receipt, the ledger), pushed after it; then, found by that push, the Windows test repair (Mark's pick, strict TDD, test files only):
RED `7e7d36d`, GREEN `3872a21`, REFACTOR `30d5555`, close-out 1c `383eb05`, the notes and the push entries after it.
**Measured first** (`docs/planning/picture-files-prototype/g16cMeasure1-3.R`; plan section 15.1): the 375 animals on 14 x 7
in, letter landscape, letter portrait and 7 x 5 in: every PDF 567 words, 545 id words, 375 distinct, 0 overlapping; an id's
box 0.75, 0.59, 0.45, 0.37 pt high; the SVG in Chrome 545 / 375 / 0 overlapping; the PNG at 300 dpi 4200 x 2100 with 347
ink pixels that are the ids (0 at 96 dpi); `pdftools` 3.9.1 counts the same but its boxes are whole numbers.
**Built** (no code under `R/` but two help sentences): RED `test_savePedigreeDiagramDocs.R` (6 tests, 27 expectations, 25
failed) and `test_savePedigreeDiagramColony.R` (3 Chrome tests, 22 expectations, passing: they lock G16b's function; each
failed on a throwaway copy with the ids dropped, 12 of 22, and with the ids 30 times larger, 9 of 22) and four helpers;
GREEN the help's `@seealso`, the package help, NEWS, the drawing vignette's "Saving a drawing" and colony section (guarded
example chunks, hidden checks for 170 repeat nodes and 545 ids written), `vignettes/pedkindraw.Rmd`, README.Rmd and README.md
(rendered in a scratch copy), the `largeIds` probe; REFACTOR `.saveTmp()` and `.skipUnlessBrowser(pdftotext)` moved into the
helper and `.savePdfWords()` read through `.savePdfBoxes()` (identical words on two PDFs, 26 and 567).
**Verified:** the full suite at `1187457` 85 files, 1,063 tests, 16,333 expectations, 0 failed, SKIP 0, WARN 0 (536 s);
`R CMD check --as-cran` (scratch folder, `NOT_CRAN=true`, connections check on): 0 errors, 0 warnings, 1 NOTE (the new
submission), `SKIP 6 PASS 16306` (594 s); `checkExamples.sh` OK; after the REFACTOR the three files 40 tests, 266 expectations,
0 failed on the Mac and in the Linux box; lint 0; roxygen no change; drift 91 / 23 / 0.
**Found:** the first PNG helper read 25,188 differing pixels on every copy, the code's or not (a 1344 px page in a 1200 px
window: dragon 38); 8 of the docs test's 27 expectations passed before any edit through a badge's `.svg` and a picture's
`.png` (dragon 40); `largeIds` prints kinship2 520 / Pedixplorer 473 labels, not the plan's 517 / 472 (backlog `:273`); the
plan's "PNG ids drawn at 6,200 px" is the live-widget route, not this function; each id is under a point high (dragon 41,
backlog `:123`).
**After close-out 2 (found by its push, run 45038005488, plan section 15.5):** pkgdown `success` (the site builds); Ubuntu release
and oldrel-1 `SKIP 11 PASS 16279`, macOS `SKIP 9 PASS 16290` (the handoff's guesses held); Ubuntu R-devel red in
"setup-r-dependencies" (S4Vectors, known); **Windows `FAIL 1 WARN 0 SKIP 11 PASS 16287`**: my PNG test's floor of 100 (the
drawing without its ids differs from the PNG in 27 pixels there, 347 on the Mac, 573 in the Linux box); the hang a fifth time,
R exiting with an error and the step still not ending (cancelled at 40 minutes). **The repair:** RED a no-browser test of the
rule `.pngHoldsIds(ink)` on typed counts (and the committed test failing on a Mac copy with the ids in `#6a6a6a`, 42 pixels, at
the same line), GREEN the rule (an id taken out, more differing pixels than the drawing as written) in the helper and the PNG
test calling it, REFACTOR the counts in one comment; the colony file 4 tests, 31 expectations, 0 failed on the Mac and on the
lighter-ids copy, 12 failed on the ids-dropped copy, the three files in the Linux box 41 tests, 275 expectations, 0 failed.
**Push 2 (the repair, run 45046213485):** pkgdown `success`; Ubuntu release and oldrel-1 `SKIP 11 PASS 16288`, macOS `SKIP 9
PASS 16299`, **Windows `FAIL 0 WARN 0 SKIP 11 PASS 16297`, `proc.time()` 1,153 s: the repair is shown on Windows**; the hang a sixth
time (cancelled at 38 minutes). **Not verified:** a larger `dpi`'s effect beyond 96 and 300.


**Quality gates:** see the receipt in `HANDOFFS.md` (S72).

#### Session 71 Handoff Evaluation (by Session 72)
**Score: 9/10.** ROI high: the handoff saved the orientation and the planning of G16c.
- **What helped:** the orient picker's 24 titles at their cited lines (24 of 24 held); drift 91/23/0 and nprcgenekeepr's 4
  commits at `3e06730c5` exactly; the plan's measure-before-picker list for G16c (the four measures were the picker's
  content); `.savePdfWords()` already counting 545 and 375, which made the pdftotext side a one-hour extension; "run each RED
  test on a throwaway reference first" (the idea behind this session's two mutant copies); the Windows gotchas ("a tool's
  existing is not its working", cancel at 40 minutes); the Linux box command and its image details; `NOT_CRAN=true`; the
  `captureBeyondViewport` and photograph-window notes (they named the fault behind the 25,188 pixels once I looked).
- **What was missing:** that G16c's tests would lock code that already exists, so RED has no failing code (the plan's
  "Measure before the pre-RED picker" did not say the colony tests pass at once); that the plan's "PNG ids at 6,200 px" is the
  other route; that `.saveTmp()` and `.skipUnlessBrowser()` are local to one test file (a new file cannot see them).
- **What was wrong:** nothing found in the notes. The plan's kinship2 517 and Pedixplorer 472 (section 7) are 520 and 473 in
  today's probe (not the handoff's claim; the handoff did not repeat them).
- **ROI:** high.

**Self-assessment: 7/10** (8 before the push; lowered by the Windows failure).
+ Measured before the picker, and the picker stated counts (545, 375, 0, the sizes, the pdftools comparison), so Mark's three
  picks were each the recommended one at once; said at the RED gate that the colony tests would pass and proved each able to fail
  on two broken copies; found the helper's blank-window fault from a constant and fixed it before RED's commit; tightened the
  docs test after the first run showed 8 of 27 passing for the wrong reason; every number in the plans was re-read from the run
  that made it; REFACTOR proved identical (`identical()` on the words of two PDFs); the check was run the way GitHub does.
- **The slip that cost the point:** the PNG test's floor of 100 was the Mac's number, and S71's own lesson (a platform differs) and
  the test file's own header (dragon 12: one machine's numbers, bounds) were in front of me; I ran the Mac and the Linux box and
  did not ask what text does on Windows. GitHub's Windows job failed it (27 pixels against 347 and 573); repaired in the session
  by Mark's pick in strict TDD, and the lesson is in the plan (dragons 42-43).
- Other slips, each caught before it cost anything: GREEN 1's message said "6 fail (was 25)" for 21 (amended before any push);
  section 15.3 first said the full suite ran at the REFACTOR's tree (it ran at GREEN 3; corrected on re-read); I wrote one
  scratch file to `/tmp` (removed at once); three long silent stretches in tool work drew the harness's "say what you are
  doing" reminder; my first CI watcher used BSD `date -j` on a GNU `date` (the notes warned of the trap) and ended at once.
- The documents' tests are text-presence tests: they hold a statement's key words, not its truth; the truth is the colony
  tests' and the hidden chunks'. That split was Mark's pick, and its weakness is named in the notes (dragon 40).
- Nothing left undone in the session: both pushes were read job by job.

### What Session 71 Did
**Deliverable:** Phase G16b, the PDF and the PNG file for `savePedigreeDiagram()` (gaps A1 and A2,
`docs/planning/picture-files-plan.md` section 7, G16b), strict TDD. DONE.
**Started:** 2026-11-22 00:47 CST · **Model:** Claude Sonnet 5.5 · **Mark's picks (each first time, all the recommended
option):** "G16b: PDF and PNG files (Recommended)" (orient); "Yes, proceed to RED"; "Cancel it and read its log" (S70's
Windows run, at 40 minutes); "Go on with G16b" (when that run was found to have hung again; I had said in the orient
picker that I would stop and ask); R146's decoder, "jsonlite in Suggests", with "Yes, proceed to GREEN" (one picker, two
questions); "Yes, proceed to REFACTOR"; then, after the push, "Fix it now (Recommended)" for the Windows word tests,
"Yes, proceed to GREEN" and "Yes, proceed to REFACTOR" again. No correction and no tool use declined.
**Commits:** claim `fd207de`; RED `3ed03b8`; GREEN `42e090b` (function, recording layer, `DESCRIPTION`), `fc8df0c` (help,
NEWS), `8cb2b8c` (contract row, the `files` case); REFACTOR `057a2e2`; close-out 1 `2bfd5b7`, `10da9bd`; close-out 2
`6cd865d` (pushed). Then, found by that push, the Windows word tests' repair: RED `bbb26b8`, GREEN `fd9c7e2`, REFACTOR
`048a100` (amended once: its message first claimed a clean Linux run it had not read), close-out 1c `1c0fbe8`, 1d
`a57246b` (pushed); close-out 2b (these notes, the receipt, the ledger), pushed last.
**Found:** S70's push (run 44994050682, `a150a49`): Ubuntu release `FAIL 0, WARN 0, SKIP 2, PASS 16201`, macOS `FAIL 0,
SKIP 0, PASS 16212`, Ubuntu oldrel-1 `success` (its counts not read), R-devel red in "setup-r-dependencies" (known); the
Windows job passed its tests (`FAIL 0, WARN 0, SKIP 1, PASS 16211`, `proc.time()` 936 s: S70's LCD repair reached
Windows) and the check step did not end: cancelled at 07:14 UTC, 24 minutes after the tests ended, two orphan `Rterm`
processes killed: the second run in a row; not fixed (Mark's pick), `BACKLOG.md:11` rewritten with the reading.
**Built:** `savePedigreeDiagram(..., dpi = 300.0)` writes `.pdf` and `.png` as well: the recording asks the layer to cut
each dashed line into short strokes (PDF only; a path it cannot cut safely keeps its dashes), a second Chrome (LCD text
off) opens the recorded SVG, waits two animation frames, then prints it (paper = the page) or photographs it clipped to
the page at `dpi / 96`; `jsonlite::base64_dec()` (Suggests) decodes the answer; one time limit covers the recording and the
render step. **Measured first, on a throwaway reference** (the prototypes in a `git archive` copy, not committed;
gaps plan dragon 89): every value the 30 tests state (PDF 504 x 360 pt for 7 x 5 in; the default page 720 x 369.12 pt;
PNG 672 x 480 / 1050 x 750 / 2100 x 1500 at 96 / 150 / 300 dpi and 3000 x 1534 by default; the PNG at 96 dpi against
the live widget 0.00% and 0.03% of ink differing for the four animals, 0.26% and 0.07% for the feature pedigree; the 375
animals on 14 x 7 in a one-page PDF of 1,025,352 B on the real code with 545 id words, 375 distinct, a 4200 x 2100 PNG),
and a pixel comparison of a PDF through `pdftoppm` that failed (960 x 493 for 960 x 491, 18% differing), so the tests
read a PDF's page and words, not its pixels (plan dragon 31). The reference passed on the Mac and in the Linux box (216
expectations); RED on the real tree read 140 expectations, 12 errors, SKIP 0, WARN 0 on both.
**Verified on the final tree:** the 30 tests (it was 19), 216 expectations, 0 failed, SKIP 0, WARN 0 on the Mac and in
the Linux box (98 s) after GREEN and again after REFACTOR; the full suite at `057a2e2` 83 files, 1,053 tests, 16,283
expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (528 s); `R CMD check --as-cran` with `NOT_CRAN=true` and
`_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` at `8cb2b8c`: 0 errors, 0 warnings, 1 NOTE (the new submission), `PASS 16283`
(581 s); `lint_package()` 0; `roxygenise()` no further change; drift 91 / 23 / 0 with no copied file changed; the REFACTOR's
time-limit paths byte-identical before and after (`cmp`, 870 bytes); the `files` case prints the three files.
**After close-out 2 (found by its push, run 45000649737):** Ubuntu release and oldrel-1 `FAIL 0 WARN 0 SKIP 4 PASS
16268`, macOS `SKIP 2 PASS 16279` (GitHub's Ubuntu and macOS have no `pdftotext`: the two word tests skip); R-devel red
in "setup-r-dependencies"; **Windows `FAIL 4 WARN 2`**: Git for Windows' `pdftotext` exists and exits 99 on a PDF, so my
`.skipUnlessPdftotext()` (existence only) let the two word tests run and fail; every other test passed there. Mark's pick:
repair it now. **The repair (test helper only, strict TDD):** RED a test with a stand-in `pdftotext` exiting 99 first on the
path expects a skip (failed on the old helper); GREEN the helper tries the tool on a PDF R writes and skips when it fails;
REFACTOR one function runs the command (the words of both PDFs and the probe's three outcomes byte-identical, `cmp`, 6,128
bytes). 31 tests, 217 expectations, 0 failed on the Mac; the full suite at the REFACTOR 83 files, 1,054 tests, 16,284
expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (518 s); lint 0; roxygen no change. **The repair's push (run
45011132429, `a57246b`):** Ubuntu `SKIP 4 PASS 16269`, macOS `SKIP 2 PASS 16280`, **Windows `FAIL 0 WARN 0 SKIP 4 PASS
16278`, `proc.time()` 1,041 s**, and the hang again with every test passing (cancelled at 40 minutes, 10:50 UTC): the
fourth run in a row, so it is probably at R's exit, not in a test (plan dragon 37). **One unexplained error:** the Linux
box read `214 expectations, 1 error` in 2 of 10 runs of the file (the others 217 and 0), through `runTests.sh`, which hides
the text; not on the Mac or GitHub's Ubuntu.
**Not verified:** an absurd `dpi`; the Linux box's intermittent error (cause unknown).
**Quality gates:** quality_ratchet: 5/6 pass · 0 fail · 1 unmeasured · results 534fea217641 · manifest f447be95addb; unmeasured: test-suite-warnings-zero (timeout 300 s) — by hand: the full suite on `048a100` (the repair's REFACTOR), 83 files, 1,054 tests, 16,284 expectations, 0 failed, 0 errors, SKIP 0, WARN 0 (518 s)

#### Session 70 Handoff Evaluation (by Session 71)
**Score: 9/10.** ROI high: the handoff saved the orientation, the plan reading and the CI reading, and its one wrong
figure was labelled a guess.
- **What helped:** the orient picker's 23 titles at their cited lines (23 of 23 held at orient); drift 91/23/0 and
  nprcgenekeepr's 4 commits at `3e06730c5` exactly; "G16b's picks are MADE: do not re-ask them" (saved a picker); the
  instruction to read S70's push job by job and what to do if Windows hung (it did; the cancel-and-read steps worked);
  the plan sections for G16b with line numbers (`:281`, `:566`, `:639`) and the three committed prototypes
  (`expandDashes.py`, `printPdf.R`, `savePng.R`), from which the throwaway reference was built in an hour; the Linux box
  (`tools/linux/runTests.sh`) worked first time and showed the reference passing on Ubuntu; the gotchas on
  `NOT_CRAN=true`, the 5-file cap, "run the suite by hand" (458 s then, 528 s now), the zsh trap; `.saveInkDiff()` and
  `.savePixelsJs` at their lines, which the PNG comparison extended.
- **What was missing:** that the Linux image already has `pdftotext` and `pdfinfo` (found by running); that `jsonlite`
  is not in `DESCRIPTION` and a PDF needs a base64 decoder (a pick of Mark's, R146); that the PDF cannot be compared
  with the live widget pixel by pixel; that a test helper that photographs needs a testthat context (`teardown_env()`),
  so a scratch script must run inside `test_file()`.
- **What was wrong:** the CI estimate "Ubuntu `PASS 16,188`" (the real run read 16,201: the guess forgot that the 13
  failing expectations of S69 now pass; it was labelled a guess); "a second session of the same Chrome" (12.3) was a
  plan, not a measurement: the build uses a second Chrome, so the recording stays replaceable in a test.
- **ROI:** high.

**Self-assessment: 7/10.**
+ Followed the handoff's order (read the push job by job, the picks not re-asked), kept the promise made in the orient
  picker (stopped and asked when Windows hung again, then asked before cancelling a run), ran every RED value on a
  throwaway reference on two platforms before committing (one idea, a PDF pixel comparison, failed there and was
  dropped with its helper before it reached a commit), GREEN passed on its first run on both surfaces, the REFACTOR was
  proved byte-identical, the check was run the way GitHub does, and every figure in the plans was re-measured on the
  real code (the 375 animals' PDF 1,025,352 B against the reference's 1,025,349) before the close-out committed it.
- **The slip that cost the score:** my two PDF word tests broke the Windows job. They skipped only where `pdftotext` is
  missing, and S70's own lesson (a photograph, a platform's text) pointed at the same class of fault: a tool can exist
  and not work. The tests had run only on the Mac and in the Linux box, both of which have a working one; I did not ask
  which tool GitHub's runners would find. Repaired in the session, by Mark's pick, in strict TDD. Also: the REFACTOR's
  commit message said the Linux box read 217 and 0 before I had read that run (it read 214 and an error): found, and the
  unpushed commit amended; a monitor's clock parsed with BSD `date -j` warned at once, falsely (nothing was cancelled on
  it); the gate said "218 expectations" (it is 217); the Linux box's intermittent error left unexplained because the
  script hides the text.
- Slips, none reaching a release: a placeholder anchor in one `Edit` call (it failed harmlessly); the first measuring
  script ran outside testthat and failed on `teardown_env()`; a helper (`.savePdfAsPng`) written and deleted unused; the
  CRAN plan said 11 of the 30 tests start a browser (it is 22; found by counting the file before the commit); the
  reference's PDF size entered a draft of the plan before the real code was measured (corrected before commit); the
  orient and close-out took long reading five plan sections that the handoff already summarised. The Windows hang is
  still unexplained and every push will probably show it again.
