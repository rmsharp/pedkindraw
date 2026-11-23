# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G16 DONE (S42-S72).
G17 (gap A3, a ready-made app) planned in S73 (R148, `docs/planning/pedigree-app-plan.md`); G17a DONE in S74 (R149,
`runPedigreeApp()`); G17b DONE in S75 (R150, choosing the animals). **G17c DONE in S76 (R151):** the app draws up to
four conditions chosen from the file's columns (guessed from names beginning "affected" in any case; a column of numbers
drawn once it has a cut-off, which the legend states); the marks found by name in any case (and Pedixplorer's `avail`
and `deceased`), listed on the page; lines at right angles or straight; a twins file (kinship2's code numbers read;
checked with `checkTwinRelations()`; a pair drawn when both its animals are); **a file's yes-or-no values read with the
common words** (TRUE, T, yes, Y, 1 / FALSE, F, no, N, 0, any case; before, a condition written 1/0 drew every animal
unknown with no message and a mark written so stopped the drawing); a column with any other value left out and named;
**the sample opens with its twins file** (3 pairs). Plan section 13 (`:766`) has every measure; 13.6 (`:880`) what was
built and verified.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; eight runs in a row).
**Next: G17d** (`docs/planning/pedigree-app-plan.md:366`), the last G17 session: F16 (SVG, PDF and PNG downloads through
`savePedigreeDiagram()`; without Chrome the buttons say so), F17 (the animals drawn as CSV), and the documents (README.Rmd
and README.md rendered from a scratch install, `vignettes/pedkindraw.Rmd:167`, `vignettes/drawing.Rmd:675` "Clicks in a
Shiny application", `R/pedkindraw-package.R:61`, a `@seealso` on the copied `drawPedigreeDiagram()`, NEWS; the backlog
item for F2, F10, F14, F20, F21, `:211`, re-read); strict TDD, one session; then 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G17d (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from `methodology/BACKLOG.md`:
READY, the legend's labels in a narrow drawing (`:93`), the drawing vignette's measured trait (`:103`), the drawing
times in the vignette and the contract (`:109`; G17d edits that vignette: ask whether G17d takes it), **a twins table
with no rows stops the layout (`:117`, new in S76; copied code, nprcgenekeepr shares it)**, the `smallPed` fixture
(`:151`), rewording `DIVERGENCE.md`'s older rows (`:75`), tests for full coverage (`:157`), `findPedigreeNumber()`'s speed
(`:310`), installing poppler in CI (`:314`), tracing the label counts in `largeIds` (`:303`), and the seven "Ready,
small" items (`:231` the suite gate's time limit, `:243` the stale pedkindraw 0.0.1 in renv, `:250` the drift tool and
copied constants, `:259` the context-budget tool, `:269` CI notices, `:286` report a vacuous test to nprcgenekeepr,
`:292` tell nprcgenekeepr's edition-3 conversion); NEEDS DECISION, a converted Pedixplorer object's `avail` (`:127`),
long names at the edges (`:135`), a colony's ids under a point high (`:144`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:197`), copying nprcgenekeepr's colony overview (`:204`), the app's features left for later
(`:211`), an animal with two or more mates drawn once (`:220`). BLOCKED, and so not offered: `:36` (the speed vignette),
`:84` (retire the drift tools), `:191` (nprcgenekeepr imports pedkindraw). Name every item in the picker (memory
"Picker sets: name items, include all"; max 4 options, so group them and name each in a preview). Each title was found
at its line by `grep -n '^- \[ \]'` when S76 closed out (29 items, the G item at `:51`; S76 added `:117`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G17d, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S76 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S76.
2. **S76's push:** see "What Session 76 Did" below for what close-out read of it. A prediction, not measured: each job
   reads S75's count plus G17c's new expectations (156 in `test_pedigreeAppMarks.R`, 7 of them in its Chrome test, and 1
   more in the sample's Chrome test), where Chrome runs (Ubuntu and Windows set it up; macOS found it in S74); and the
   Windows hang.
3. **G17d, if picked** (plan section 7, `:366`). **Measure first, before the pre-RED picker** (Learning 17): a download
   from the app in Chrome (`shiny::downloadHandler()` calling `savePedigreeDiagram()`, `R/savePedigreeDiagram.R:88`;
   S73 measured an SVG in 1.82 s inside the prototype, section 3.3); what `testServer()` gives for a download output
   (a file path it can read, or nothing; a guess); what the page should say when Chrome is missing
   (`savePedigreeDiagram()` stops naming chromote, R143); which drawing is saved (the one shown, with the conditions,
   marks, lines and twins G17c added; `drawing()$widget`, `R/pedigreeApp.R:941`) and the animals' CSV (the rows shown,
   `shown()`, or the drawing's data frame, `prepared()$ped`). The documents' statements are tested beside their calls,
   `tests/testthat/test_savePedigreeDiagramDocs.R`'s way (S72). The picker may also offer folding backlog `:109` (the
   drawing times, `vignettes/drawing.Rmd:788`) into G17d.
4. TDD for any code session: declare the phase at the top of every response; each transition (`PRE-RED->RED`,
   `RED->GREEN`, `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Grep the tests for every input a ruling changes, in RED** (plan dragon 21): R151 made the sample open its twins file,
  and G17a's Chrome test of the sample saw 1,466 nodes, not 1,460; S76 found it only in GREEN (`c79c51f`). G17d's saves
  read the same drawing: any test that counts a saved file's ids of the sample counts the twins' edges too.
- **The Edit tool turns a typed `\u2265` into the character** (dragon 20): R code must hold the escape or `R CMD check
  --as-cran` warns (non-ASCII). Before the check, `LC_ALL=C grep -n '[^ -~]' R/<file>`; write escapes with Python.
- **Count the full suite with `reporter = "check"`** (dragon 22): the summary reporter prints no totals.
- **A 503 from GitHub in the check's URL NOTE** (dragon 23): fetch the link again and re-run the check on the same
  tarball with `--no-tests --no-examples --ignore-vignettes --no-manual` to read the NOTE.
- **The server after G17c** (`R/pedigreeApp.R:785`): `chosenConditions` (`:793`, a `reactiveVal`, set to the guess when a
  file opens and by `input$conditions`, `ignoreNULL = FALSE`, `ignoreInit = TRUE`), `twinsRead` (a `reactiveVal`,
  `list(read, source)`; "sample" twins dropped when another pedigree file opens), `otherColumns()` (`:864`, the file's
  columns but the four), `conditionColumns()`, `cutoffValues()` (inputs `cutOp<k>`, `cutValue<k>`, k the column's place
  in the file), `markColumns()`, `lineStyle()`, `twinsChecked()` (`:886`), `prepared()` (`:937`, `.appDrawnPedigree()`:
  the drawing's own data frame), `drawing()` (`:941`, draws `prepared()$ped`, not `shown()`). The Animals tab still
  shows `shown()`, the rows as read. Outputs added: `conditionChoice` (`:965`), `cutoffs` (`:973`), `marks`,
  `columnNotes`, `twinsNote` (`:1007`), `twinsProblem`.
- **An assignment inside `testServer()`'s code lands in the server's environment** (dragon 14): a local named like a
  server object replaces it; S76's tests name theirs `expected`, `expectedTwins`, `fresh`, `script`, `withGen`.
- **A file in a Chrome test** goes through `.appSetFile(page, id, path)` (`tests/testthat/helper-pedigreeApp.R`, DevTools'
  `DOM.setFileInputFiles`); the page shows the file's base name, so write it as `twins.csv` in a temporary folder.
- **zsh:** arrays start at 1 (`t=($(cat f)); t[0]` is empty: S76's first elapsed time was nonsense; use awk); an
  unquoted `$var` is not split (use `bash -c '...'`); `rm -rf name*` with no match aborts a `&&` chain; BSD `sed -i`
  needs an argument (use python).
- **Windows:** the check step hangs after the tests (eight runs); cancel at 40 minutes, read the log (`gh api
  --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`); its
  `proc.time()` line is the tests' time. Start a watcher's clock from `date -u +%s`.
- **Run the DONE check the way GitHub does:** `bash tools/checkExamples.sh` and `R CMD check --as-cran` with
  `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder, `RENV_PROJECT` unset (S76: 609 s, 1
  NOTE, `[ FAIL 0 | WARN 0 | SKIP 6 | PASS 16734 ]`); the app tests' CRAN time against the checked install with
  `NOT_CRAN` unset (S76: 60 tests, 8.44 s).
- **Carried:** run Rscript from the root with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set to renv's library;
  do not edit the tree while the full suite runs, nor run two Chrome-starting jobs at once (dragon 19); the 5-file cap
  splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, 9 min; S76: 548 s); `CLAUDE.md` is
  over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; `NOT_CRAN=true` for the
  browser tests; scratch files go in the scratchpad; renv prints "The project is out-of-sync" on activation
  (pre-existing).
- **Ledger sizes** (S76's close-out 2): `HANDOFFS.md` 190,888 B, about 5.7 KB under its 196,608 B
  threshold: **archive it at the next close-out** (`python3 methodology/methodology_trim.py --file
  methodology/HANDOFFS.md --check`, then without `--check`); `CHANGELOG.md` about 104 KB.

### Key files
- G17: `docs/planning/pedigree-app-plan.md` (`:89` section 2.3, F1-F21; `:298` section 7, `:366` G17d; `:383` section 8,
  dragons 1-23; `:766` section 13, G17c's measures: `:773` 13.1 the values, `:809` 13.2 twins and lines, `:832` 13.4
  R151, `:880` 13.6 what was built); `docs/planning/pedigree-app-prototype/` (`g17cValues.R`, `g17cOptions.R`,
  `g17cTwins.R`, `g17cBrowser.R`, S76's measures); `docs/planning/standalone-pedigree-package-plan.md:318` (R151).
- The app: `R/runPedigreeApp.R` (the export, help); `R/pedigreeApp.R` (`:41` `.appNameKey()`, `:56` `.guessAppColumns()`,
  `:317`-`:620` G17c's helpers: `:332` `.appReadValues()`, `:361` `.appNeedsCutoff()`, `:373` `.appCutoff()`, `:386`
  `.guessAppConditions()`, `:399` `.appConditionNames()`, `:430` `.appFindMarks()`, `:441` `.appMarkNote()`, `:457`
  `.appDeceased()`, `:470` `.appUnreadWords()`, `:496` `.appReadTwins()`, `:536` `.appTwinsInView()`, `:561`
  `.appDrawnPedigree()`; `:661` `.appDraw()`, `:702` the page, `:785` the server); `R/savePedigreeDiagram.R:88`.
- Tests: `tests/testthat/test_pedigreeAppMarks.R` (21), `test_pedigreeAppViews.R` (15), `test_pedigreeAppServer.R` (16),
  `test_pedigreeAppBrowser.R` (3), `test_runPedigreeApp.R` (9), `helper-pedigreeApp.R` (`.appSetFile()`);
  `test_savePedigreeDiagramDocs.R` (S72's documents' statements, the model for G17d's).
- Also changed: `NEWS.md` (G17c's bullet under Drawing), `docs/planning/pedkindraw-api-contract.md` section 4.7,
  `man/runPedigreeApp.Rd`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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
**After close-out 2 (its push):** pushed after close-out 2; close-out 2b reads its run job by job and records the reading here and in the plan's section 13.6. If no 2b commit follows, nothing was read: the next session reads the run.

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
**After close-out 2 (its push, run 45073310658):** pkgdown `success`; Ubuntu release and oldrel-1 `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16416 ]`; macOS `SKIP 9 PASS 16427` (the 2 browser tests ran and passed there: Chrome is found on GitHub's macOS too, so the plan's "browser tests skip on macOS" does not hold for them); Windows `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16425 ]`, `proc.time()` 1,110 s, and the hang a seventh time (cancelled at 41 minutes; two orphan `Rterm` processes, as before G17a); Ubuntu R-devel red in "setup-r-dependencies" (S4Vectors, known).

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
