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
`runPedigreeApp()`). **G17b DONE in S75 (R150):** the app chooses the animals it draws (Everyone; One family, the
families of two or more listed largest first; focal animals with their ancestors and descendants, **each descendant's
other parent drawn too, without its own parents**; focal animals' near relatives, "How close" 3 by default); focal
animals typed, or an animal clicked (a repeat node is its animal; **the click replaces** the focal animals, written in the
box; the view does not change); **over 1,000 animals chosen the app asks first** ("Draw anyway"); **a parent with no row
of its own is added** with `addParents()` and named; the Animals tab shows the animals chosen. Plan section 12 (`:600`)
has every measure; 12.6 (`:694`) what was built and verified.
**Open, not fixed:** the Windows job whose check step does not end (`methodology/BACKLOG.md:11`; seven runs in a row).
**Next: G17c** (`docs/planning/pedigree-app-plan.md:355`): what is drawn: F9 (up to four condition columns, each a
true-or-false column or a number cut at a threshold, `conditionThresholds`; how a CSV's "1", "TRUE", "Y" or a number
becomes a condition is its picker), F11 (the file's marks and names passed through by name), F12 (rectilinear or direct
lines), F13 (a twins file, `checkTwinRelations()`, its problems shown); strict TDD, one session; then G17d (`:366`), 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G17c (recommended), or the Windows item (`BACKLOG.md:11`) first. Also, from `methodology/BACKLOG.md`:
READY, the legend's labels in a narrow drawing (`:92`), the drawing vignette's measured trait (`:102`), **the drawing
times in the vignette and the contract (`:108`, new in S75; G17d)**, the `smallPed` fixture (`:140`), rewording
`DIVERGENCE.md`'s older rows (`:74`), tests for full coverage (`:146`), `findPedigreeNumber()`'s speed (`:299`),
installing poppler in CI (`:303`), tracing the label counts in `largeIds` (`:292`), and the seven "Ready, small" items
(`:220` the suite gate's time limit, `:232` the stale pedkindraw 0.0.1 in renv, `:239` the drift tool and copied
constants, `:248` the context-budget tool, `:258` CI notices, `:275` report a vacuous test to nprcgenekeepr, `:281` tell
nprcgenekeepr's edition-3 conversion); NEEDS DECISION, a converted Pedixplorer object's `avail` (`:116`), long names at
the edges (`:124`), a colony's ids under a point high (`:133`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:186`), copying nprcgenekeepr's colony overview (`:193`), the app's features left for later
(`:200`), an animal with two or more mates drawn once (`:209`). BLOCKED, and so not offered: `:36` (the speed vignette),
`:83` (retire the drift tools), `:180` (nprcgenekeepr imports pedkindraw). Name every item in the picker (memory "Picker
sets: name items, include all"; max 4 options, so group them and name each in a description). Each title was found at
its line by `grep -n '^- \[ \]'` when S75 closed out (28 items, the G item at `:51`; S75 removed "parents with no row",
settled by R150, and added `:108`).
**Session boundary:** one session, then close out.
**Priority:** HIGH (G17c, G17d, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S75 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied
   from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr was at `3e06730c5`, tree clean, through S75.
2. **S75's push was read in S75, job by job** (run 45087949474): pkgdown `success`; Ubuntu release and oldrel-1 `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16550 ]`; macOS `[ FAIL 0 | WARN 0 | SKIP 9 | PASS 16561 ]`; Windows `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16559 ]`, `proc.time()` 925 s, and the hang an eighth time (cancelled at 41 minutes; two orphan `Rterm` processes, as before); Ubuntu R-devel red in "setup-r-dependencies" (S4Vectors, known). Each job's count is S74's plus G17b's 134 expectations, so the new Chrome test ran on Ubuntu, macOS and Windows. Nothing is left to read. The next push that
   changes code: expect these counts plus G17c's tests, and the Windows hang.
3. **G17c, if picked** (plan section 7, `:355`). **Measure first, before the pre-RED picker** (Learning 17): **the app
   reads every column of a file as text** (`.readAppFile()`, `R/pedigreeApp.R:96`, `colClasses = "character"`), so a
   CSV's `affected`, `genotyped`, `carrier` or `status` column reaches `makePedigreeMatingLayout()` as "TRUE", "1", "Y"
   or "DECEASED" text, not as `TRUE`; measure what the layout and `drawPedigreeDiagram()` do with each such text column
   (and with `ped` given as logical, which the app keeps as it is) before the picker says how a value becomes a
   condition or a mark (a guess, not measured: some will be refused or drawn as unknown). F12 needs `edgeStyle` passed to
   both `makePedigreeMatingLayout()` and `drawPedigreeDiagram()` in `.appDraw()` (`R/pedigreeApp.R:324`); F13 a second
   file input and `checkTwinRelations()`'s problems on the page. Pedixplorer's app picks one condition column with a
   threshold (plan section 2.1).
4. TDD for any code session: declare the phase at the top of every response; each transition (`PRE-RED->RED`,
   `RED->GREEN`, `GREEN->REFACTOR`) is one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **A click in a Chrome test aims at the network's own canvas** (plan dragon 15): the first canvas in the widget is the
  legend's. `.appClickNode(page, id)` (`tests/testthat/helper-pedigreeApp.R:167`) sends a real mouse press and release
  there through DevTools; S75's probe showed an animal, a repeat and a mating dot each reaching Shiny.
- **The server keeps the focal text in `focalText`, a `reactiveVal`** (`R/pedigreeApp.R:483`) set by the box and by a
  click, because `testServer()` cannot see `update*Input()` (dragon 16). A new input the server also writes needs the
  same.
- **The app's server** (`R/pedigreeApp.R:426`, `.pedigreeAppServer(ped = NULL, drawLimit = 1000L)`): `rawData()`,
  `readProblem()`, `columnGuess()`, `chosen()`, `tableProblem()`/`columnProblem()`, `ready()`, `pedigree()` (the file as
  read: Checks reads it), `checks()`, `completed()` (`:477`, `.appAddParents()`), `families()`, `focalText`,
  `focalIds()`, `view()` (`NULL` means "all", so G17a's tests that never set it draw everyone), `howClose()` (`NULL`
  means 3), `choice()` (`:493`, `.appChooseAnimals()`: `rows` and `problem`), `shown()`, `approved`, `tooLarge()`
  (`:506`), `drawing()` (`:511`, `NULL` when nothing to draw; `.appDraw(shown(), onClick = .appClickJs)`), the click
  observer (`:518`). Outputs: `columns`, `sexNote`, `problem`, `drawn`, `added`, `focalNote`, `familyChoice` (`:577`),
  `large` (`:585`), `notes`, `diagram`, `checkSummary`, `checks`, `table` (the animals chosen). Tests call `rawData()`,
  `columnGuess()`, `pedigree()`, `checks()`, `shown()`, `drawing()` by name. G17c's choices (conditions, marks, lines,
  twins) go between `shown()` and `.appDraw()`.
- **`testServer()` computes every output at each change** (dragon 14): the family list and the size question are
  computed in the server tests too; the 1,001-founder test costs about 0.5 s. On CRAN's path the app's 40 tests took 5.06
  s (R148 guessed 1-3 s); keep G17c's server tests on typed pedigrees.
- **The typed pedigree for views** (`.appViewsPed()`, `helper-pedigreeApp.R:48`): 14 animals, families 1 (10), 2 (3), 3
  (z1 alone); the whole drawing has repeats `__dup_s1_1` and `__dup_o1_1`.
- **Measure a drawing's time on pedigrees with structure**: the first n animals of `examplePedigree` in generation order
  are all founders (S75's first measure drew nothing); `g17bSize.R` takes ancestors of random animals with a parent.
- **Do not edit the tree while the full suite runs** (dragon 19; failure mode #29), and do not run two Chrome-starting
  jobs at once (the suite, the ratchet, a check, `checkExamples.sh`, a by-hand run).
- **Windows:** the check step hangs after the tests (seven runs); cancel at 40 minutes, read the log (`gh api
  --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed 's/\x1b\[[0-9;]*[A-Za-z]//g'`); its
  `proc.time()` line is the tests' time. Start a watcher's clock from `date -u +%s` (this shell's `date` is GNU).
- **Run the DONE check the way GitHub does:** `bash tools/checkExamples.sh` and `R CMD check --as-cran` with
  `NOT_CRAN=true` and `_R_CHECK_CONNECTIONS_LEFT_OPEN_=true` from a scratch folder (S75: 631 s, 1 NOTE, `[ FAIL 0 | WARN
  0 | SKIP 6 | PASS 16577 ]`); the app tests' CRAN time against the checked install with `NOT_CRAN` unset.
- **zsh:** an unquoted `$var` is not split (use `bash -c '...'`); `rm -rf name*` with no match aborts a `&&` chain;
  BSD `sed -i` needs an argument (use python).
- **Carried:** run Rscript from the root and a scratch copy with `Rscript --no-init-file` and `R_LIBS`, `R_LIBS_USER` set
  to renv's library; the 5-file cap splits commits; the ratchet's suite gate times out at 300 s (run the suite by hand, 9
  min; S75: 549 s); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked,
  Mark's; `NOT_CRAN=true` for the browser tests; scratch files go in the scratchpad; renv prints "The project is
  out-of-sync" on activation (pre-existing).
- **Ledger sizes** (S75's close-out 2): `HANDOFFS.md` 184,611 B, about 12 KB under its 196,608 B threshold (one or two
  more receipts: it will be archived soon); `CHANGELOG.md` about 100 KB. Run `python3 methodology/methodology_trim.py
  --file methodology/HANDOFFS.md --check` at each close-out.

### Key files
- G17: `docs/planning/pedigree-app-plan.md` (`:89` section 2.3, F1-F21; `:298` section 7, `:342` G17b, `:355` G17c,
  `:366` G17d; `:383` section 8, dragons 1-19; `:469` section 11, G17a's measures; `:600` section 12, G17b's: `:607`
  12.1 drawing times, `:627` 12.2 the views on the sample, `:663` 12.4 R150, `:694` 12.6 what was built);
  `docs/planning/pedigree-app-prototype/` (`app.R`, the prototype; `g17a*.R`, S74's measures; `g17bSize.R`,
  `g17bBrowser.R`, `g17bViews.R`, `g17bCases.R`, `g17bClickParents.R`, S75's);
  `docs/planning/standalone-pedigree-package-plan.md:316` (R150), `:98` (G17b DONE), `:99` (Next).
- The app: `R/runPedigreeApp.R` (the export, help); `R/pedigreeApp.R` (`:172` `.appAddParents()`, `:187`
  `.appFocalIds()`, `:198` `.appFamilyChoices()`, `:212` `.appAloneNote()`, `:232` `.appLineal()`, `:259`
  `.appChooseAnimals()`, `:292` `.appClickJs`, `:303` `.appClickedAnimals()`, `:324` `.appDraw()`, `:359` the page,
  `:426` the server).
- Tests: `tests/testthat/test_pedigreeAppViews.R` (15), `test_pedigreeAppServer.R` (16), `test_pedigreeAppBrowser.R` (3),
  `test_runPedigreeApp.R` (9), `helper-pedigreeApp.R`.
- Also changed: `NEWS.md` (G17b's bullet under Drawing), `docs/planning/pedkindraw-api-contract.md` section 4.7, `man/runPedigreeApp.Rd`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
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
