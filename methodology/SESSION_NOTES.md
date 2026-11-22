# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G16 DONE (S42-S72).
G17 (gap A3, a ready-made app) planned in S73 (R148, `docs/planning/pedigree-app-plan.md`): four build sessions.
**G17a DONE in S74 (R149):** `runPedigreeApp(ped = NULL, port = NULL, launch.browser = interactive())` starts the app,
which opens a CSV or text file, the 375-animal sample or a `ped` data frame; recognises the id, sire, dam and sex columns
(both apps' names, R149) and the common sex codes (m/f, male/female, 1/2...); adds `gen`; draws everyone with the
layout's warnings and messages shown; says when a file or a drawing fails; lists `checkPedigree()`'s problems (Checks
tab) and the animals (Animals tab). `shiny`, `callr` and `pkgload` in Suggests. Plan section 11 (`:453`) has every
measure; 11.6 (`:540`) what was built and verified.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`); S74's push is the
first since S72 to carry code (read it job by job: see "What You Must Do" 2).
**Next: G17b** (`docs/planning/pedigree-app-plan.md:341`): choosing the animals (F6 one family, F7 focal animals'
ancestors and descendants, F8 relatives within k steps, F15 a click, F19 a size warning); strict TDD, one session; then
G17c (`:354`), G17d (`:365`), then 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G17b (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from `methodology/BACKLOG.md`:
READY, the legend's labels in a narrow drawing (`:92`), the drawing vignette's measured trait (`:102`), the `smallPed`
fixture (`:132`), rewording `DIVERGENCE.md`'s older rows (`:74`), tests for full coverage (`:138`),
`findPedigreeNumber()`'s speed (`:299`), installing poppler in CI (`:303`), tracing the label counts in `largeIds`
(`:292`), and the seven "Ready, small" items (`:220` the suite gate's time limit, `:232` the stale pedkindraw 0.0.1 in renv,
`:239` the drift tool and copied constants, `:248` the context-budget tool, `:258` CI notices, `:275` report a vacuous
test to nprcgenekeepr, `:281` tell nprcgenekeepr's edition-3 conversion); NEEDS DECISION, a converted Pedixplorer object's
`avail` (`:108`), long names at the edges (`:116`), a colony's ids under a point high (`:125`); "Waiting on Mark", the
dashboard not seeing `methodology/BACKLOG.md` (`:178`), copying nprcgenekeepr's colony overview (`:185`), the app's
features left for later (`:192`), **the app: parents with no row of their own (`:201`, new in S74)**, an animal with two
or more mates drawn once (`:209`). BLOCKED, and so not offered: `:36` (the speed vignette), `:83` (retire the drift
tools), `:172` (nprcgenekeepr imports pedkindraw). Name every item in the picker (memory "Picker sets: name items,
include all"; max 4 options, so group them and name each in a description). Each title was found at its line by
`grep -n '^- \[ \]'` when S74 closed out (28 items, the G item at `:51`); a later edit to the Windows item shifts them.
**Session boundary:** one session, then close out.
**Priority:** HIGH (G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S74 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S74.
2. **S74's push** (the first with code since S72): read in S74 if the session's last CHANGELOG entry says so; otherwise
   read it job by job (`gh run list --limit 6`; Windows: cancel at 40 minutes and read the log). A guess from S72's
   push 2 plus G17a's 26 tests (128 expectations; the 2 browser tests skip on macOS, where the workflow sets up no
   Chrome): Ubuntu release and oldrel-1 `SKIP 11 PASS 16416`, macOS `SKIP 11 PASS 16419`, Windows `SKIP 11 PASS 16425`
   and the hang; pkgdown `success` (it must find `runPedigreeApp` in `_pkgdown.yml`). Watch on Windows for an orphan R
   process from the browser tests' second process (plan dragon 2).
3. **G17b, if picked** (plan section 7, `:341`). **Measure first, before the pre-RED picker** (Learning 17): the app's
   drawing time at about 500, 1,000 and 2,000 animals (F19's number and words; Pedixplorer warns at 300 and refuses at
   500; nprcgenekeepr 400 or 750); whether a click adds to the focal animals or replaces them (nprcgenekeepr replaces);
   and put the new backlog item `:201` (parents with no row) in the picker: add them with `addParents()`, offer a
   button, or leave. The functions behind F6-F8 are `findPedigreeNumber()`, `trimPedigree()` with
   `getDescendantPedigree()`, `getNearRelativePedigree()` (the prototype's `shown()` reactive, `docs/planning/
   pedigree-app-prototype/app.R`, is the starting shape). The click needs `onClick` on the app's
   `drawPedigreeDiagram()` call (`R/pedigreeApp.R:185`) and a browser test (finding 4: `testServer()` cannot see
   `update*Input()`).
4. TDD for any code session: declare the phase at the top of every response; each transition (`PRE-RED->RED`,
   `RED->GREEN`, `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **`R CMD check --as-cran` reads `tests/testthat/` for undeclared packages; without `--as-cran` it does not** (plan
  dragon 13). S74's scratch measure ran without it and concluded `pkgload` need not be declared; the real check warned.
  Any package a test names with `::` goes in Suggests. Measure a check with the DONE check's flags.
- **`testServer()` computes every output at each change, read or not** (dragon 14): a server test that sets the
  sample's four columns draws 375 animals (2.4 s). Server tests use typed pedigrees; the sample is drawn only in the
  Chrome test. **An assignment inside `testServer()`'s code lands in the server's environment**, not the caller's:
  keep results in an environment object (`box$res <- ...`).
- **The app's server** (`R/pedigreeApp.R:247`): `rawData()` (the rows read, or `ped`), `readProblem()`, `columnGuess()`,
  `chosen()` (the four inputs `idColumn`, `sireColumn`, `damColumn`, `sexColumn`; fewer than four until each is sent),
  `tableProblem()`/`columnProblem()` (pure rules at `:114`, `:134`), `ready()`, `pedigree()` (validates "different
  column", then `req(ready())`), `checks()`, `drawing()` (`.appDraw()`, `:175`: warnings and messages kept as notes, an
  error kept); outputs `columns`, `sexNote`, `problem`, `drawn`, `notes`, `diagram`, `checkSummary`, `checks`, `table`.
  G17b's animal choice goes between `pedigree()` and `drawing()`. Tests call `rawData()`, `columnGuess()`, `pedigree()`,
  `checks()` by name: renaming one breaks them.
- **The test helpers** (`tests/testthat/helper-pedigreeApp.R`): `.appTestServer()` (`:25`, hides shiny's "Loading
  required package" and detaches shiny it attached: `testServer()` and `runApp()` each call `require(shiny)`),
  `.appFour()`, `.appCsv()` (an upload's data frame), `.setAppColumns()`, `.appTimeLimit()` (a stubbed `runApp()` that
  did not take fails instead of hanging), `.startPedigreeApp()` (`:86`: the child loads pedkindraw from source when no
  `R/pedkindraw.rdb` is under the namespace path, installed otherwise; the port from shiny's "Listening on" line),
  `.appPage()` (`:142`, the shared Chrome), `.appJs()`, `.appWaitFor()`.
- **A file whose parent has no row cannot be drawn** (backlog `:201`); the layout's errors are written for a
  programmer, so the app says "could not be drawn" and points to the Checks tab. One animal alone draws 0 nodes with a
  `message()`, not a warning.
- **`launch.browser`** keeps shiny's name under a `# nolint` block (`R/runPedigreeApp.R:67`-`:70`; R149).
- **Windows:** the check step hangs after the tests (six runs, S69-S72); cancel at 40 minutes, read the log (`gh api
  --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`); its
  `proc.time()` line is the tests' time. The browser tests add a second R process (`callr`, `supervise = TRUE`, killed
  at each test's end). Start a watcher's clock from `date -u +%s` (this shell's `date` is GNU).
- **Do not run two Chrome-starting jobs at once** on the Mac (the suite, the ratchet, a check, a by-hand app run).
- **Run the DONE check the way GitHub does:** `bash tools/checkExamples.sh` and `R CMD check --as-cran` with
  `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder (S74: 598 s, 1 NOTE, `[ FAIL 0 | WARN 0
  | SKIP 6 | PASS 16443 ]`); the app tests' CRAN time against the checked install with `NOT_CRAN` unset (S74: 24 run,
  1.73 s). A GitHub URL in README answered 503 once (a NOTE); try again before acting on it.
- **zsh:** an unquoted `$var` is not split (use `bash -c '...'`); `rm -rf name*` with no match aborts a `&&` chain (S74
  hit it: run such lines under `bash -c`); BSD `sed -i` needs an argument (use python).
- **Carried:** run Rscript from the root and a scratch copy with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set
  to renv's library; guard every variable in a removal path; the 5-file cap splits commits; the ratchet's suite gate times
  out at 300 s (run the suite by hand, 9 min; S74: 535 s); `CLAUDE.md` is over its budget (learnings go to the plans'
  dragons); `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the browser tests; scratch files go in the
  scratchpad, never `/tmp`; renv prints "The project is out-of-sync" on activation (pre-existing).
- **Ledger sizes** (S74's close-out 2, before its push entries): `CHANGELOG.md` 194,829 B, `HANDOFFS.md` 177,367 B,
  both under their 196,608 B archive threshold; `CHANGELOG.md` has under 2 KB of room, less than one session's entries:
  run `python3 methodology/methodology_trim.py --file methodology/CHANGELOG.md --check` at S75's claim and archive when
  it fires.
- **Times** (S74's, this Mac): the app's server tests 1.43 s (CRAN path), runPedigreeApp's 0.17 s, the 2 browser tests 8.2
  s; the sample drawn in the app 2.68 s; the app process answers in 0.75-1.14 s; the full suite 535-544 s; the check 598 s.

### Key files
- G17: `docs/planning/pedigree-app-plan.md` (`:88` section 2.3, F1-F21; `:230` section 5, the interface; `:297` section 7,
  `:322` G17a, `:341` G17b, `:354` G17c, `:365` G17d; `:382` section 8, dragons 1-14; `:453` section 11, G17a's
  measures, `:498` 11.4 the typed cases, `:540` 11.6 what G17a built); `docs/planning/pedigree-app-prototype/` (`app.R`,
  the prototype; `g17aLoading.R`, `g17aServerTime.R`, `g17aCases.R`, S74's measures);
  `docs/planning/standalone-pedigree-package-plan.md:314` (R149), `:97` (G17a DONE), `:98` (Next).
- The app: `R/runPedigreeApp.R:68` (the export; help `:7`-`:66`); `R/pedigreeApp.R` (`:15` column names, `:25` sex
  codes, `:37` `.guessAppColumns()`, `:56` `.readSexCodes()`, `:70` `.sexCodeNote()`, `:95` `.readAppFile()`, `:114`
  and `:134` the two message rules, `:155` `.appPedigree()`, `:175` `.appDraw()`, `:207` the page, `:247` the server).
- Tests: `tests/testthat/test_runPedigreeApp.R` (9), `test_pedigreeAppServer.R` (15), `test_pedigreeAppBrowser.R` (2),
  `helper-pedigreeApp.R`.
- Also changed: `DESCRIPTION:27`-`:39` (Suggests), `_pkgdown.yml:23`, `R/pedkindraw-package.R:13`, `NEWS.md:298`,
  `docs/planning/pedkindraw-api-contract.md:259` (section 4.7) and section 5, `tools/gapCases.R` (`pedkindrawAppTitle()`
  and the `app` case).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 74 Did
**Deliverable:** Phase G17a, the app's first slice (`docs/planning/pedigree-app-plan.md:322`), strict TDD. DONE.
**Started:** 2026-11-22 14:13 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "G17a: the app's first slice (Recommended)" (orient); R149's four in one picker ("runPedigreeApp()", "Yes, a
ped argument", "Read the common codes", "Both apps' names"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
proceed to REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `f8bca6f`; measures and R149 `2274af3`; RED `feb21f1`; GREEN `7ecfab7` (the function and the app),
`da4aa11` (help index, `?pedkindraw`, NEWS), `83ecac5` (contract, `app` case), `81da303` (`pkgload` in Suggests);
REFACTOR `ffee08d`; close-out 1 `8b4e17c` (the plans), 1b `0655069` (roadmap, backlog); close-out 2 (these notes, the
receipt, the ledger), pushed after it.
**Measured first** (plan section 11): the app's second process loads the pedkindraw under test (source under
`load_all()`, 1.14 s; installed under `R CMD check`, 0.75 s; never renv's stale 0.0.1); `runApp(port = NULL)` names its
port on standard error; `testServer()` 0.52 s for the first test, 0.133 s after, and it computes every output; eight
typed cases (the layout stops on 4 with programmer's words; one animal gives a message); sex codes other than M/F/H/U
draw as unknown; the sample 375 animals, 1,460 nodes, one note.
**Built:** `runPedigreeApp()` and the app (`R/runPedigreeApp.R`, `R/pedigreeApp.R`), 26 tests (128 expectations), the
help, `_pkgdown.yml`, `?pedkindraw`, NEWS, the contract's section 4.7, the `app` case.
**Verified:** RED 26 of 26 failing on the missing functions, SKIP 0, WARN 0; GREEN first run 26 passing; the full suite at
`ffee08d` 88 files, 1,090 tests, 16,470 expectations, 0 failed, SKIP 0, WARN 0 (535 s); `R CMD check --as-cran` at
`81da303` 0 errors, 0 warnings, 1 NOTE (new submission), `PASS 16443` (598 s); CRAN path 24 app tests 1.73 s; coverage
117/117 and 16/16; examples errors 0; lint 0; roxygen no change; drift 91 / 23 / 0; fidelity 600 / 600; the REFACTOR's
30 cases `identical()`; by hand in Chrome: the sample, a CSV uploaded through the page's file input, its problem and the
Checks tab, the corrected file drawn (pictures were in the scratchpad, not kept).
**Found:** the first `--as-cran` check warned on an undeclared `pkgload` (my scratch measure had run without
`--as-cran`; section 11.1 corrected, GREEN 4); a file whose parent has no row cannot be drawn (backlog `:201`).
**Not run:** another browser, a real file dialog, a phone-width window, a hosted server.

#### Session 73 Handoff Evaluation (by Session 74)
**Score: 9/10.** ROI high: the handoff's three measures were the pre-RED session's whole plan.
- **What helped:** "What You Must Do" 3 named the three measures (a)-(c) and the prototype as the starting shape: each
  became a measured section of the plan and an option in R149's picker; drift 91/23/0 and nprcgenekeepr's 4 commits at
  `3e06730c5` held exactly; the orient picker's 27 backlog lines all held; the plan's dragons 1 (the stale 0.0.1, and
  `pkgload` in Suggests), 4 (warnings count), 5 (`%||%`), 7 (a fixed port: shiny's own free port, read from its output,
  avoided it) and 10 (the child inherits the environment); finding 4 (`testServer()` cannot see `update*Input()`).
- **What was missing:** that `testServer()` computes every output whether read or not (it decided how the sample is
  tested); that the layout also speaks through `message()` (one animal), not only warnings; that `--as-cran`, not a
  plain check, is what reads `tests/testthat/` (the plan's dragon 1 was right; nothing said how to measure it).
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every pick measured on a scratch copy first and every RED value computed
  before RED (the HTML forms included), so all five pickers were answered with the recommended option at once, RED failed
  26 of 26 for the right reason and GREEN passed on its first run; the REFACTOR proved over 30 cases; the by-hand run
  went through the page's own file input, which no test drives; the citations re-found after the backlog shifted.
- **The slip that cost the point:** measure (a)'s check ran without `--as-cran`, and I wrote into the plan (and
  committed, `2274af3`) that `pkgload` need not be declared, against the plan's own dragon 1. The DONE check caught it
  and section 11.1 is corrected, but it cost a GREEN commit and a second 10-minute check; the lesson is dragon 13.
- Other slips, none reaching a commit: a zsh `rm` glob aborted a chain (the notes warned of it); six lints at GREEN's
  first lint; the contract's section first renumbered 4.6 to 4.7, breaking a citation (moved before commit); the
  REFACTOR record's first run saved nothing (an assignment inside `testServer()`).

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
