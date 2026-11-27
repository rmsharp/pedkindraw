# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17m DONE (S33-S96); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **Backlog
`:186`, the findings 17m left outside NEWS, DONE (S97, R169):** the app reads a file separated by commas, tabs or
semicolons (the one splitting the first line into the most columns, quotes honoured, commas on a tie), the twins file
too, and says "1 column"; its deceased mark reads nprcgenekeepr's status words without its numbers (died, D; alive,
A, shipped, sold, sale, S, unknown, U) and leaves out, naming them, a status column's other values;
`savePedigreeDiagram(width = NULL)` takes the widget's pixel width, else 10 in; `?makePedigreeMatingLayout` and two
comments no longer say a re-routed marked mate line falls back; `inst/js/recordCanvas.js`'s comment gives 0.26% and
0.07%.
**Next, by Mark's pick at S96's close** ("`:186`, then `:178`, then 17n"): backlog **`:178`**, Ubuntu devel's
S4Vectors failure, a decision; then 17n, which freezes the tree.
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `b464c80` (close-out 1, without the skip marker): run 45921649070: Windows, macOS and Ubuntu release Status OK (`PASS 17069`, `17081`, `17070`); Ubuntu oldrel-1 failed `test_savePedigreeDiagram.R:381` at attempt 1 (a hung Chrome start, backlog `:192`, its first on oldrel-1) and read Status OK at its rerun (`PASS 17070`); Ubuntu devel failed building S4Vectors (`:178`). pkgdown passed; speed-tables did not run (none of its files changed). Close-out 2 pushed after it (the skip marker, no run).
**The orient picker:** "(Recommended)" on `:178` (Mark's pick above); the rest grouped and named (34 items, `grep -n
'^- \[ \]' methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:159`, `:168`, `:186`, `:232`
(new, S97: tell nprcgenekeepr its mate-line help is stale), `:239`, `:245`, `:259`, `:264`, `:276`, `:292`, `:311`;
NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:178` (S4Vectors, before 17n), `:209`, `:227`, `:282`, `:302`; READY by
Mark's pick `:192` (the Chrome diagnostic); "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a
session Mark starts in nprcgenekeepr, R101's exception), `:20` and `:116` (BLOCKED). Name every item.
**Session boundary:** one session, then close out.
**Priority:** HIGH (17n-17q; `:178` before 17n).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S97 changed only the help and comments
   of a copied file, its parsed code `identical()`); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr
   log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1
   basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`) and
   nprcgenekeepr at `3e06730c5`, unless Mark has run `:105` or `:232` there (then update `DIVERGENCE.md` as R101 says).
2. **`:178`, S4Vectors** (if picked): read S97's Ubuntu devel job log first (run 45921649070, job 140253524152); find whether
   Bioconductor has an S4Vectors newer than 0.50.3 that builds on R-devel before the picker (Learning 17); the two
   choices are in the item; the devel entry is `.github/workflows/R-CMD-check.yaml:31`, the install step `:50`-`:53`.
   A change to the workflow is tested only by a push (dragon 37: a CI fix is a guess until CI has run it).
3. **17n** (`docs/planning/cran-submission-plan.md:1052`) only after `:178`: it freezes the tree.
4. **CI on every push:** five jobs. Known flakes: `:192` (a hung Chrome start, Ubuntu release), `:209` (a blank PDF;
   the SVG-legend comparison, Windows in S95, Ubuntu release in S96), `:227` (the app's click, macOS). Rerun a failed
   job once (`gh run rerun <run> --job <id>`, after the run ends), then list the rerun's jobs by attempt (`gh api
   repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`); read logs through the jobs API (`curl -sSL -H
   "Authorization: Bearer $(gh auth token)" https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`).
   Watch a run with a Monitor loop on `gh run view <run> --json status,conclusion,jobs` (45 s).
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Run each RED test against a deliberately wrong prototype too (dragon 42):** S97's quote-rule test passed a reader
  that ignored quotes (a tie went to commas); found after the RED gate, before GREEN code; RED 3 by Mark's pick.
- **The deceased mark's one gap, by the rule Mark picked:** 1 is a yes-word (kinship2's and Pedixplorer's dead), so a
  status column in nprcgenekeepr's numbers holding only 1s (all alive) is drawn all deceased with no note; any 2, 3 or
  4 in it leaves the column out, named (`.appReadDeceased()`, `R/pedigreeApp.R:498`).
- **The separator is read from the first line only** (`.appSeparator()`, `R/pedigreeApp.R:126`): a header of one
  column reads with commas.
- **Words tests now hold:** `test_runPedigreeAppDocs.R` ("commas, tabs or semicolons" after `\strong{Open}` and in
  NEWS's app item; died, shipped, unknown after "deceased reads" and in NEWS's marks item, and not "reads any other
  value as not deceased"); `test_savePedigreeDiagramDocs.R` ("the widget's own width", help and NEWS);
  `test_addRectilinearWaypointsDogleg.R` (`?makePedigreeMatingLayout` says "re-routed", not "falls back to the
  generic"). With S96's six NEWS-word files, run all after any NEWS or help edit.
- **chromote prints "[warning] got non-close frame while closing"** to the console after a Chrome test; testthat
  counts no warning for it (WARN 0 in every S97 run).
- **Carried:** write `"${VAR:?}"` in `rm -rf` (S97 was refused once); zsh does not split an unquoted variable (S97's
  `set -- $pair` failed once; use Python or `xargs`); the README render needs a scratch install (17m's gotcha); the
  skip marker (a push whose head commit holds it runs no workflow); a Chrome test can error under load (print
  `conditionMessage()`: `fullsuite.R` in S97's scratchpad did); the check without suggested packages needs a scratch
  R home; CRAN's DESCRIPTION spell check reads `.aspell/` (dragon 39); a CRAN check runs only 21 test files (list a new
  test file in `tests/testthat/slowTestFiles.txt`); Rscript inside `tests/testthat/` loads no renv; backslashes in
  `Rscript -e` go in a file; the 5-file cap splits commits; never commit `tests/testthat/_problems/`; `CLAUDE.md` is
  over its budget (learnings go to the cran plan's dragons, now 42); `methodology/HANDOFFS.md` about 240 KB after S97, about 22 KB under the 262,144 B size where a
  default read returns nothing
  (backlog `:302`): keep the receipt short; the full suite takes 10.2-10.9 min, the ratchet's run about 12.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- S97 (DONE): `R/pedigreeApp.R:126` (`.appSeparator()`), `:145` (`.readAppFile()`), `:164` (`.appTableProblem()`),
  `:481` (the deceased and living words), `:498` (`.appReadDeceased()`), `:651` (the status branch of
  `.appDrawnPedigree()`); `R/savePedigreeDiagram.R:129`; `R/makePedigreeDiagramData.R:2197` (the help) and its header;
  `inst/js/recordCanvas.js:12`-`:17`; the tests `tests/testthat/test_pedigreeAppServer.R:221`, `:233`,
  `test_pedigreeAppMarks.R:191`, `:307`, `:564`, `test_savePedigreeDiagram.R:135`; R169
  `docs/planning/standalone-pedigree-package-plan.md:353`; dragon 42 `docs/planning/cran-submission-plan.md:1337`.
- `:178`: `methodology/BACKLOG.md:178`; `.github/workflows/R-CMD-check.yaml:31`, `:50`-`:53`.
- 17n: `docs/planning/cran-submission-plan.md:1052`; CI `.github/workflows/R-CMD-check.yaml:28`-`:33` (the matrix).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 97 Did
**Deliverable:** backlog `:186`, what 17m's check of NEWS found outside NEWS (five findings), strict TDD. DONE (R169):
the app reads files separated by commas, tabs or semicolons; its deceased mark reads nprcgenekeepr's status words and
names any other value; `savePedigreeDiagram()` takes the widget's pixel width; a stale help sentence, two comments and
a JavaScript comment's figures corrected.
**Started:** 2026-11-26 16:12 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option where
one was):** ":186 NEWS findings (Recommended)" (orient); "Read all three", "More words; name the rest", "Use the
widget's width"; "Yes, proceed to RED"; "Yes, proceed to GREEN"; after the RED gate, before any GREEN code, "Back to
RED for it" (the quote rule's test passed on a tie); "Yes, REFACTOR".
**Commits:** claim `1a39485`; RED `019e9d4` (items 1, 4), `73290fb` (5, 2); RED 3 `7812fd0`; GREEN `3fb71fb` (1, 4),
`3433daf` (5), `4f2f571` (2, 3: help and comments only); REFACTOR `4684b76` (one status reader); close-out 1 `b464c80`
(pushed without the skip marker: run 45921649070, its oldrel-1 job rerun once); close-out 2 (these notes, the receipt, the ledger), pushed after it.
**Measured:** a tab- or semicolon-separated `.txt` or `.csv` read as 1 column; nprcgenekeepr's app asks for the
separator (Comma, Semicolon, Tab) and its `convertStatusCodes()` reads 1 as alive and 2 as deceased, which the app
read reversed, its D and A both living; a scratch reader that splits by the first line's most columns read the sample
written three ways `identical()`, the app's 5 test files passing on it (69 tests); in Chrome, a widget of 1400 px
saved 10 in and with the prototype 14.58 in; S88's dogleg tests (4, 18 expectations) and R162 answered item 2 without
a new drawing (a sire-daughter mating drew the sire twice, no dogleg); R's `count.fields()` and `scan()` honour a quote
mid-field; a reader ignoring quotes passed RED 1's quote test and failed RED 3's.
**Verified:** RED: 9 new tests failing (26 expectations and an error), the 90 already in their files passing, WARN 0;
RED 3 on this tree, the prototype and the quote-ignoring reader (fail, pass, fail). GREEN: full suite (`NOT_CRAN=true`)
107 files, 1,225 tests, 17,331 expectations, 0 failed, 0 errors, 0 skipped, WARN 0 (10.2 min); `R CMD check --as-cran`
Status 1 NOTE (R16's), CRAN-mode `[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2697 ]`, 95 s; the real app in Chrome (a scratch
test, 5 expectations): the sample tab-separated with a 1/2 status column, 375 drawn, 3 twin pairs from `twins.txt`,
the column left out naming '2', 0 deceased; semicolon-separated with died/alive, 37 of 37 deceased, no note; covr: 18
of 18 statements on the lines S97 changed run; lint 0; roxygen unchanged; spelling 0; drift 91 / 23 / 0, the copied
file's parsed code `identical()` to HEAD's. REFACTOR: outputs on 16 columns and 11 drawings `identical()` before and
after. quality_ratchet 7/7 at `b464c80` (results `dd3bb45ce615`).

#### Session 96 Handoff Evaluation (by Session 97)
**Score: 9/10.** ROI high: Orient, the item's reading and the first measurements ran from its notes.
- **What helped:** Mark's pick under "Next" (the orient picker followed it); What You Must Do 1 (91 / 23 / 0, the 4
  commits, `3e06730c5`, each exact) and 2's sorting of the five findings (1, 4 and 5 Mark's, 2 drawn first, 3 a
  comment, the test and NEWS lines a word change touches); every key-file line exact at `0201a46` (`R/pedigreeApp.R:124`,
  `:752`, `:755`, `:458`, `R/runPedigreeApp.R:19`, `R/savePedigreeDiagram.R:124`, `R/makePedigreeDiagramData.R:2189`,
  `:3105`, the "fixed S563" comments at `:3028` and `:3137`, `recordCanvas.js:12`-`:14`); the gotchas on `"${VAR:?}"`,
  zsh's word splitting and the six NEWS-word test files.
- **What was missing:** that S88's `test_addRectilinearWaypointsDogleg.R` and R162 already show item 2: a re-routed
  mate line keeps its marker, and no drawing re-routes one, so "draw one before changing the words" could not be done
  by drawing (my first drawing did not reach the dogleg). Found in minutes by searching the tests.
- **What was wrong:** nothing.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every picker measured first (nprcgenekeepr's app and status words, a
  scratch reader on the app's own tests, the widths in Chrome, the dogleg's tests); all 9 tests drafted and run on
  HEAD and on a prototype, the help and NEWS wording included, before the RED gate; the quote test's tie found before
  any GREEN code and put to Mark; GREEN verified by the full suite, `R CMD check`, the real app in Chrome and coverage
  of every changed line; the REFACTOR proved by `identical()` outputs.
- **RED 1's quote test checked less than its title said** (a tie): its draft was run against HEAD and the right
  prototype, not a wrong one (dragon 42); cost RED 3 and one picker.
- **Slips caught before commit:** an unguarded `rm -f` refused once and a zsh `set -- $pair` loop, both warned of in
  the handoff; a server draft placed where `.withAppGen()` is not defined; the JavaScript comment's first wording
  ("their legends") said more than the plan's line 550; two key-file citations off by 1 and 4, re-found.

### What Session 96 Did
**Deliverable:** Phase 17m (`docs/planning/cran-submission-plan.md:1020`), the release text and the version, strict
TDD where tests changed. DONE: version `1.0.0`, NEWS and the README readied, `R CMD check --as-cran` R16's NOTE
only, the README rendered twice the same, `git grep 0.0.1` only the 4 lines Mark chose to leave (R168).
**Started:** 2026-11-26 09:15 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Phase 17m (Recommended)" (orient); "1.0.0 (Recommended)", "Check; reword 4 (Recommended)", "GitHub install only
(Recommended)", "Add test; leave 4 (Recommended)"; "Yes, proceed to RED"; "Yes, GREEN + 2 twins (Recommended)";
after the full suite failed S2's version test, "Back to RED for it (Recommended)"; "Skip REFACTOR (Recommended)";
at the close, "17m's findings :186 (Recommended)". Mark also asked whether nprcgenekeepr could now resolve the
divergences: not before the switch (R98, R101); the one exception, a fix its users need before it (backlog `:105`,
a session Mark starts there, after this one and before 17n), was explained step by step.
**Commits:** claim `cd1369a`; RED `949842c`, `70ea1ec`; GREEN `d4e8637` (version, NEWS), `e4fc598` (README),
`f90ddac` (`?removeAnimals`, the speed vignette); RED 3 `87fae59` (S2's version test); close-out 1 `b0eb2e7`
(pushed without the skip marker: run 45888606992, its Ubuntu release job rerun once); close-out 2 (these notes, the
receipt, the ledger, CI in 17m's paragraph and backlog `:232`), pushed after it.
**Measured:** R's NEWS reader on both headings; nprcgenekeepr's first CRAN version (1.0, 2020-04-15); CRAN's
package page (visNetwork's: "Materials: README, NEWS"); the NEWS check: three read-only agents over its 54 items
(about 440 claims), 12 contradicted, each re-checked here by code, run or log (vis-network's `width = 2 * size`,
`conditionColors = 2`'s message, CI oldrel-1's R 4.5.3, `.layoutHintsUsedMate()`, `speedCheck()`); the copied
files' share of `R/` (49.7% of code lines); the site's three articles; each test drafted in scratch copies (HEAD 8
failed; a prototype GREEN and 17q's form 0; 17q's form without its words 1; RED 3 on `70ea1ec`'s tree 1, HEAD 0).
**Verified:** RED 3 tests, 12 expectations, 8 failed, WARN 0; GREEN the file 12 passed. Full suite (`NOT_CRAN=true`)
107 files, 1,216 tests: 17,293 expectations, 1 failed (S2's version test), then, after RED 3, 17,244, 0 failed, 1
error (a Chrome test under load; the file alone 235 of 235), WARN 0 both. Lint 0; roxygen unchanged but
`man/removeAnimals.Rd`; spelling 0; `tools/checkSpeedTables.R` 0 problems; `R CMD check --as-cran` Status 1 NOTE
(R16's), CRAN-mode `PASS 2695`, 112 s; `utils::news()` 9 sections, all 1.0.0; the README's two renders identical;
drift 91 / 23 / 0; quality_ratchet 7/7 at `b0eb2e7`. CI as in the Status line above.

#### Session 95 Handoff Evaluation (by Session 96)
**Score: 9/10.** ROI high: Orient, 17m's reading and the first pickers ran from its notes.
- **What helped:** Mark's pick under "Next"; What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each
  exact); 2's reading list with every line where it said (`:1016`, `:1076`, `:282`, `DESCRIPTION:4`, `NEWS.md:1`,
  `README.Rmd:42`, the contract's `:303`) and its warning against a CRAN link before acceptance; the gotchas on the
  README render needing an install (a scratch library, used), the skip marker (it shaped the push) and the 21
  CRAN-run files (the new test listed); the 33 items at their stated lines.
- **What was missing:** that S2's `tests/testthat/test_package.R:28` already held the version below 1.0.0 (2's "a
  version test, if any" left it open; my own truncated search missed it too); that the README's "two articles" had
  been stale since 17i.
- **What was wrong:** nothing in the notes. The cran plan's section 2.5, which they cited, said no other file
  names `0.0.1`; 4 lines do (S32's count).
- **ROI:** high.

**Self-assessment: 7/10.**
+ Orient in full, the claim before any work; every picker measured first (both headings parsed, CRAN's page,
  nprcgenekeepr's precedent, the drafts on HEAD, a prototype GREEN and 17q's form); the NEWS check delegated to three
  read-only reviews and every finding re-checked before it reached a gate, one (the app's "CSV or text") reversed
  on evidence before GREEN; DONE verified here, on CI and on the site; Mark's nprcgenekeepr question answered from
  the rulings, with counts and steps.
- **A truncated search missed S2's version test** (dragon 40): the full suite found it after GREEN, costing a RED 3,
  one more gate and a second 11-minute suite run.
- **RED 1's README check would have forced odd wording** ("The README" mid-sentence); fixed in RED 2 before GREEN.
- **Slips caught before commit:** the rewrap script dropped NEWS's blank line after the heading; "60 items" for 54;
  the suite script kept no error message, so the Chrome error's cause is not recorded.

### What Session 95 Did
**Deliverable:** Phase 17l (`docs/planning/cran-submission-plan.md:981`), strict TDD where tests changed. DONE: the
spelling check 0 words, the check without suggested packages passing in CRAN mode and with the full suite, the
suite gate measured (7/7), the stale renv copy gone, CI's four jobs that reach pedkindraw OK (R167).
**Started:** 2026-11-25 21:59 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Phase 17l (Recommended)" (orient); D7 and noSuggests: "US spelling throughout", "R 4.5.0, oldest tested", "Add the
sentence", "Guards plus a guard test"; "Yes, proceed to RED"; "Yes, proceed to GREEN"; mid-GREEN, after CRAN's
DESCRIPTION spell check was found to flag the sentence's 4 words, "Sentence + package word list"; "Yes, REFACTOR";
at the close, "Phase 17m next (Recommended)".
**Commits:** claim `4f35b4c`; RED `41e45a9`; GREEN `dd3a13f` (messages, guards), `c51b6eb`, `314a291`, `01f6b9f`,
`ee4d680`, `8194375` (US spelling, the word list), `1366d59` (`DESCRIPTION`, `.aspell/`, `.Rbuildignore`), `6a68b99`
(`?pedkindraw`); the suite gate's limit `84c8587`; checkout v5 `51b1361`; REFACTOR `39b5da9` (pushed: run
45760561429, its Windows job rerun once); close-out 1 `310b74a`; close-out 2 (these notes, the receipt, the ledger),
pushed after it. Not a commit: renv's stale pedkindraw 0.0.1 removed.
**Measured:** R 4.6.2's own check code (`tools:::setRlibs()`: a depends-only check keeps Depends, Imports, the
VignetteBuilder and testthat with their hard dependencies, and hides nothing in R's own library) and CRAN's README
for noSuggests; a scratch R home of R's 29 standard packages: CRAN mode passed at the claim (testthat skips a missing
package only on CRAN), the full suite failed 4 (mockery); the spelling check 97 words (13 British forms; en-GB 80);
the imports' R floors (Matrix 1.7-6 needs 4.4); the DOI by Crossref and doi.org's handle API; CRAN's DESCRIPTION
spell check emulated with hunspell (0 words, 4 with the sentence, 0 with `.aspell/`); drafts of RED and a
prototype GREEN in a scratch copy before each gate.
**Verified:** RED: the guard test 1 failure naming 12 blocks, `test_conditionColors.R` 3 errors, WARN 0. GREEN:
the full suite (`NOT_CRAN=true`) 106 files, 1,213 tests, 17,281 expectations, 0 failed, 0 skipped, WARN 0 (10.6
min); lint 0; roxygen unchanged; `R CMD check --as-cran` Status 1 NOTE (R16's), CRAN-mode `PASS 2695`, 98.5 s;
depends-only Status 1 NOTE, `[ FAIL 0 | WARN 0 | SKIP 57 | PASS 1343 ]` and, full suite, `[ FAIL 0 | WARN 0 | SKIP
211 | PASS 11780 ]`; spelling 0; drift 91 / 23 / 0. REFACTOR: `hiddenSuggests()` identical, the file 0 failed.
quality_ratchet 7/7 at `39b5da9`. CI: Ubuntu release `PASS 17045`, macOS `17056`, oldrel-1 `17045`, Windows `17044`
at its rerun (attempt 1 failed `test_savePedigreeDiagram.R:184`, one SVG legend); Ubuntu devel S4Vectors.

#### Session 94 Handoff Evaluation (by Session 95)
**Score: 9/10.** ROI high: Orient, 17l's reading and the first measurements ran from its notes.
- **What helped:** Mark's pick under the orient picker's "(Recommended)"; What You Must Do 1 (91 / 23 / 0, the 4
  commits, `3e06730c5`, each exact); 2's reading list with every line where it said (`:970`, `:1041`, `:192`, `:210`,
  `:1096`), its warning that sections 2.2 and 2.3 were S32's counts with the fresh ones (13 Suggests, mockery in 7
  files, withr in 51, no `inst/WORDLIST`), and "find what CRAN's no-Suggests check leaves out before the picker",
  which led to R's own `setRlibs()`; the gotchas on `"${VAR:?}"` and backslashes in `Rscript -e` (each met once).
- **What was missing:** that nprcgenekeepr had solved the same check (S1098: a scratch R home, not a scratch
  library); and that the `:197` item also held the only record of Ubuntu devel's S4Vectors failure, so removing it
  needed a new item. Each found in minutes.
- **What was wrong:** "the check needs a scratch library with only the Imports and their dependencies (dragon 6)":
  a library cannot hide R's own, which still holds 11 of the 13 Suggests; it takes a scratch R home.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every picker option measured first (R's check code, both checks
  without suggested packages, en-GB, the floors, the DOI), the drafts and a prototype GREEN run before each gate;
  the 12-versus-4 count told to Mark at the RED gate; the DOI sentence's spell-check cost found before it was
  committed and put to Mark with a measured fix; every DONE item verified here and on CI.
- **The DOI picker's recommended option did not say what the sentence costs in CRAN's spell check** (found mid-GREEN;
  one more picker); and the noSuggests picker said "4 guards" before the static count, which read 12.
- **Slips not reaching Mark:** an `rm -rf` on unguarded variables (refused by the safety check; the handoff warned);
  zsh's word splitting emptied the first conversion dry run; a backslash in `Rscript -e`; GREEN 7 left
  `man/pedkindraw-package.Rd` behind (caught by roxygen at verification, GREEN 8).
