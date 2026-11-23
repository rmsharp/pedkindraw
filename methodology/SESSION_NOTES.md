# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 ran before 17g (R97) and **are all DONE** (S42-S77). **G17d DONE in S77 (R152):** the app saves the
drawing as an SVG, a PDF or a PNG file through `savePedigreeDiagram()` at its own page (buttons above the drawing,
greyed with a red sentence naming what is missing when chromote or Chrome is not found), and the rows the Animals tab
shows as a CSV file (`pedigree.csv`, every column of the file, which the app opens again to the same drawing); the
README, both vignettes, the help and NEWS name the app; the drawing vignette and the contract give pedkindraw's own
drawing times (backlog `:109`, folded in by R152, closed). App plan section 14 (`docs/planning/pedigree-app-plan.md`)
has the measures, 14.8 what was built and verified.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; ten runs in a row,
S77's push the tenth).
**Next: Phase 17g, the timing plan** (`docs/planning/cran-submission-plan.md:740`), **a planning session**: a plan of
its own under `docs/planning/` for pedkindraw's own timing runs (what is timed, on which pedigrees and sizes, how, where
results are committed, how the speed vignette and `tools/checkSpeedTables.R` read them; it sets 17h's session count).
DONE: the plan committed with each phase's DONE, commands and surface; nothing timed (`SESSION_RUNNER.md` "Planning
Sessions": deepest reasoning; failure mode #18, no code).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** 17g (recommended), or the Windows item (`:11`) first. Also, from `methodology/BACKLOG.md` (28
items, each found at its line by `grep -n '^- \[ \]'` at S77's close-out): READY, the legend's labels in a narrow
drawing (`:71`), the drawing vignette's measured trait (`:81`), a twins table with no rows (`:87`), **new in S77,
`savePedigreeDiagram()` and a `CHROMOTE_CHROME` naming no file (`:97`)**, the `smallPed` fixture (`:130`), rewording
`DIVERGENCE.md`'s older rows (`:53`), tests for full coverage (`:136`), `findPedigreeNumber()`'s speed (`:292`), poppler in
CI (`:296`), the label counts in `largeIds` (`:285`), and the seven "Ready, small" items (`:213` the suite gate's time
limit, `:225` the stale pedkindraw 0.0.1, `:232` the drift tool and copied constants, `:241` the context-budget tool,
`:251` CI notices, `:268` report a vacuous test, `:274` tell nprcgenekeepr's edition-3 conversion); NEEDS DECISION,
Pedixplorer's `avail` (`:106`), long names at the edges (`:114`), a colony's ids under a point high (`:123`); "Waiting on
Mark", the dashboard and `methodology/BACKLOG.md` (`:176`), copying the colony overview (`:183`), the app's features
left for later (`:190`, now with a page size for the saved pictures), an animal with two mates drawn once (`:202`).
BLOCKED, so not offered: `:36` (the speed vignette: 17g-17i are its way out), `:62` (retire the drift tools), `:170`
(N3). Name every item in the picker (memory "Picker sets: name items, include all"; at most 4 options, so group them
and name each in a preview).
**Session boundary:** one session (17g is a plan), then close out.
**Priority:** HIGH (17g, then 17h-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S77 changed no copied code, only a
   `@seealso` line in `drawPedigreeDiagram()`'s help); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr
   log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1
   basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr
   was at `3e06730c5`, tree clean, through S77.
2. **S77's push was read in S77, job by job** (run 45125145050): Ubuntu release and oldrel-1 `PASS 16767` SKIP 19,
   macOS `PASS 16778` SKIP 17, Windows `PASS 16776` SKIP 19 and the hang (cancelled at 41 minutes), all FAIL 0 WARN 0,
   each as predicted (S76's counts, G17d's 60 save expectations, the 8 docs tests skipped in a check's tree); pkgdown
   `success`; R-devel red at S4Vectors (known). Nothing is left to read. A planning session pushes no code.
3. **17g, if picked** (`docs/planning/cran-submission-plan.md:740`, R82, R84): read first the plan's section 6 rows
   17g-17i (`:740`-`:760`), section 2.1 (the machine's load measured under load 5-12, the trap 17h names), the
   standalone plan's section 6 (the timing method: fresh process, warm-up, median of 3, `uptime`), the contract's
   section 7 (the performance budget, `docs/planning/pedkindraw-api-contract.md:323`), backlog `:36` (the draft on the
   branch `draft/speed-vignette`, `612eed9`, with `vignettes/speed.Rmd` and `tools/checkSpeedTables.R`, not merged), and
   S75's `docs/planning/pedigree-app-prototype/g17bSize.R` (how pedkindraw's drawing times were measured, one size per
   process). The plan's evidence: grep for every function the speed vignette would time and every file that states a
   time (the drawing vignette's "How large a drawing can be", `vignettes/drawing.Rmd:794`; NEWS's G17b bullet; the
   contract's sections 7 and 8). Measure what a pick depends on before the picker (Learning 17).
4. A planning session writes no package code; a later code session runs TDD (declare the phase; each transition one
   `AskUserQuestion`, CLAUDE.md "Phase-gate format").

### Gotchas
- **Archive `methodology/HANDOFFS.md` at S78's close-out:** S77's trimmer run did nothing ("under budget": 191,452 B
  against 196,608 B); S77's receipt brings it near 195 KB. Run `python3 methodology/methodology_trim.py --file
  methodology/HANDOFFS.md --check`, then without `--check`. `CHANGELOG.md` is about 107 KB.
- **The fidelity tool needs renv active** (plan dragon 28): `Rscript tools/compareResultsWithNprcgenekeepr.R
  ../nprcgenekeepr` from the root (3.5 min), not with `--no-init-file` and `R_LIBS` (its second R process then loads
  pedkindraw's library in nprcgenekeepr's folder and stops). The drift tool runs either way.
- **`.docsSection()` ends at a `## ` comment line in a code chunk** (dragon 24, `tests/testthat/helper-docs.R`): a
  statement a docs test reads goes above such a chunk.
- **`chromote::find_chrome()` returns `CHROMOTE_CHROME` unchecked** (dragon 25; backlog `:97`).
- **The Edit tool turns a typed `\u2265` into the character** (dragon 20): `LC_ALL=C grep -n '[^ -~]' R/<file>` before
  a check; write escapes with Python.
- **Count the full suite with `reporter = "check"`** (dragon 22); a GitHub 503 in the check's URL NOTE (dragon 23).
- **An assignment inside `testServer()`'s code lands in the server's environment** (dragon 14), also in a measuring
  script: S77's first CSV probe passed the server's own `view` reactive as an input. Copy arguments to names the server
  does not use.
- **zsh:** a glob that matches nothing aborts the command (`test_*app*.R` did; the files are `test_pedigreeApp*.R`);
  arrays start at 1; an unquoted `$var` is not split (use `bash -c`); BSD `sed -i` needs an argument (use python).
- **Windows:** the check step hangs after the tests (nine runs); cancel at 40 minutes, read the log (`gh api
  --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`); its
  `proc.time()` line is the tests' time. Start a watcher's clock from `date -u +%s`.
- **Run the DONE check the way GitHub does** (for a code session): `bash tools/checkExamples.sh` and `R CMD check
  --as-cran` with `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder, `RENV_PROJECT`
  unset (S77: 639 s, 1 NOTE, `[ FAIL 0 | WARN 0 | SKIP 14 | PASS 16794 ]`); the app tests' CRAN time against the
  checked install with `NOT_CRAN` unset (S77: 67 tests, 11.12 s).
- **Carried:** run Rscript from the root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's library
  (but not for the fidelity tool, above); do not edit the tree while the full suite runs, nor run two Chrome-starting
  jobs at once (dragons 8, 19); the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite
  by hand, about 9.5 min; S77: 561 and 566 s); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the browser tests; scratch files go in the scratchpad;
  renv prints "The project is out-of-sync" on activation (pre-existing).

### Key files
- 17g: `docs/planning/cran-submission-plan.md` (`:740` 17g, `:749` 17h, `:753` 17i; section 2.1; section 9 its
  dragons); `docs/planning/standalone-pedigree-package-plan.md` (section 6, the timing method; R82, R84 in section 2);
  `docs/planning/pedkindraw-api-contract.md:323` (section 7, the performance budget, with S75's drawing times since
  S77); `methodology/BACKLOG.md:36` (the speed vignette and its draft branch).
- G17 (DONE): `docs/planning/pedigree-app-plan.md` (`:90` F1-F21; `:384` section 8, dragons 1-28; sections 11-14, each
  build session's measures; 14.8 G17d's record); `docs/planning/pedigree-app-prototype/` (`g17d*.R`, S77's measures).
- The app: `R/runPedigreeApp.R`; `R/pedigreeApp.R` (`.appPictureProblem()` and `.appPictureDownload()` after
  `.appDrawnCount()`; the page's `saves` and `saveRows`; the server's G17d outputs at its end); tests
  `tests/testthat/test_pedigreeAppSave.R` (10), `test_runPedigreeAppDocs.R` (8), `helper-docs.R`,
  `helper-pedigreeApp.R` (`.startPedigreeApp(childEnv = )`).

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
**Deliverable:** Phase 17g, the timing plan (`docs/planning/cran-submission-plan.md:740`): a plan of its own under
`docs/planning/` for pedkindraw's own timing runs (what is timed, on which pedigrees and sizes, how, where results are
committed, how the speed vignette and `tools/checkSpeedTables.R` read them; it sets 17h's session count). A planning
session: no code, nothing timed. (IN PROGRESS)
**Started:** 2026-11-23 04:50 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17g: the timing plan
(Recommended)" (orient picker).
**Status:** Session claimed. Work beginning: the reads S77's handoff names, then the evidence inventory.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest. Until
close-out, this line is the crash breadcrumb for the next session's reconcile.

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

### What Session 75 Did
**Deliverable:** Phase G17b, choosing the animals the app draws (`docs/planning/pedigree-app-plan.md:342`), strict TDD.
DONE.
**Started:** 2026-11-22 16:42 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all the recommended
option):** "G17b: choose the animals (Recommended)" (orient); R150's four in one picker ("Draw it, no ancestors", "It
replaces them", "Over 1,000, ask first", "Add them, and say so"); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
proceed to REFACTOR (Recommended)". No correction and no tool use declined.
**Commits:** claim `40c5472`; measuring scripts `100121d`; measures and R150 `7ab128a`; RED `5359ecd`; GREEN `809bee3`
(the app and its help), `bdb4e05` (NEWS, contract), `ee81dd4` (GREEN 3: a test of a pedigree that cannot be drawn, found
by covr); REFACTOR `1eec0e7`; close-out 1b `1de93b6` (roadmap, backlog); close-out 1 (the plans and dragons 15-19);
close-out 2 (these notes, the receipt, the ledger), pushed after it.
**Measured first** (plan section 12): the app's drawing in R 2.0 s at 375 and 501 animals, 9.1 s at 1,001, 23.5 s at
1,500, 50.5 s at 2,000 (Chrome adds under a second); F7's ancestors and descendants miss a descendant's other parent in
344 of the sample's 375 views, which the app could not draw; nprcgenekeepr's way draws them with that parent invisible;
F8 at distance 1 draws nothing for 182 of 375; `examplePedigree`'s 271 families, 255 of one animal; every view function
returned on S74's eight typed cases; the sample's drawing 375 animals, 170 repeats of 113, 915 routing points; a real
mouse click through DevTools reaches Shiny when aimed at the network's own canvas.
**Built:** the four ways of choosing, the family list, the focal box, "How close", the click, the size question, parents
added, the Animals tab the animals chosen (`R/pedigreeApp.R`); 17 new tests and 1 changed (the app's files 43 tests, 262
expectations); help, NEWS, the contract's section 4.7.
**Verified:** RED 17 failing for the right reason, G17a's other 26 passing, SKIP 0, WARN 0; GREEN's first run 1 error
(`.appFamilyChoices()` on a family list with no names), fixed; the full suite at `bdb4e05` (the GREEN 3 test read)
`[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16604 ]` (549 s) and at `1eec0e7` `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 16604 ]` (542 s); `R CMD check --as-cran` at `ee81dd4` 0
errors, 0 warnings, 1 NOTE (new submission), `PASS 16577` SKIP 6 (631 s); CRAN path 40 app tests 5.06 s; coverage 214/214
and 16/16; examples errors 0; lint 0; roxygen no change; drift 91 / 23 / 0; fidelity 600 / 600; the gap case; the
REFACTOR's 378 cases `identical()`; by hand in Chrome: each view on the sample, a click, a CSV with a sire with no row
uploaded through the page, "Draw anyway" at 1,001 animals (drawn 10.0 s after), two pictures looked at.
**Found:** the drawing vignette and the contract give nprcgenekeepr's November drawing times (backlog `:108`, for G17d).
**Not run:** another browser, a real file dialog, a phone-width window, a hosted server, a file of more than 1,000
animals uploaded through the page.

#### Session 74 Handoff Evaluation (by Session 75)
**Score: 9/10.** ROI high: the handoff's measure list became the picker, and its map of the server said where G17b goes.
- **What helped:** "What You Must Do" 3 named the three measures (drawing time at 500-2,000, a click adding or
  replacing, backlog `:201` in the picker): with the size question they were R150's four; the functions behind F6-F8 and
  the prototype's `shown()`; `onClick` on the `drawPedigreeDiagram()` call (`R/pedigreeApp.R:185`) and finding 4 (a
  click needs a browser test); the server's reactives by name with "G17b's animal choice goes between `pedigree()` and
  `drawing()`", exactly where it went; the helpers by line; dragons 13 and 14 (the check's flags; `testServer()`
  computes every output: the family list and the size question were designed around it); drift 91/23/0 and
  nprcgenekeepr's 4 commits at `3e06730c5` held; the orient picker's 28 backlog lines all held.
- **What was missing:** that the prototype's "ancestors and descendants" view cannot be drawn by the app for most
  animals (a descendant's other parent has no row in the view: 344 of 375); the plan's section 3.2 had drawn it once, on
  an animal that happened to work. That `examplePedigree`'s first animals by generation are all founders (my first size
  measure drew nothing). That no test anywhere clicks a node (the legend's canvas trap, dragon 15).
- **What was wrong:** nothing in the handoff. The plan's G17b "measure first" quoted the contract's "past 120 s at
  2,000", which no longer holds (50.5 s); a stale source, not the handoff's claim.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; measured before the picker (sizes, views over all 375 animals, the typed
  cases under a time limit, the click's targets, `addParents()`), which found F7's 344-of-375 failure before any design
  and let the picker state counts, so Mark took all four recommended options at once; probed the click mechanism before
  RED and found the legend-canvas trap there, not in GREEN; every RED value computed first; RED failed 17 for the right
  reason; the REFACTOR proved over 378 cases with a record checked to repeat; a by-hand run through the page's own
  controls with pictures.
- **The slip that cost the point:** RED changed G17a's sire-with-no-row test (R150) without asking what else that test
  was the only one to reach; `covr` at GREEN's DONE check found two statements with no test, and GREEN 3 added one. And I
  added that test while the full suite was running (failure mode #29); the count showed it was read, but the run's tree
  should have been fixed first.
- Other slips, none reaching a commit: the first size measure took founders only, the second a pool too narrow for 2,000
  (each found from its own output); `.appFocalIds(NULL)` returning `NULL`, caught before the run; `.appFamilyChoices()`'s
  empty case erroring on GREEN's first run; three lints; a forward reference to a "section 12.7" that did not exist; the
  vignette cited at `:789` for `:788` in two places (found by re-grepping, Learning 7); a by-hand script read a selectize
  list's options from the wrong place (dragon 18). The CRAN-path time of the app's tests is now 5.06 s, above R148's guess.
