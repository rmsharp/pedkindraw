# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17m DONE (S33-S96); the gap
phases G1-G17 DONE (S42-S77); the findings 17m left outside NEWS DONE (S97, R169). **Backlog `:178`, Ubuntu devel's
S4Vectors failure, DONE (S98, R170):** not R-devel's fault but two Bioconductor releases in one install: the
project's `.Rprofile` started renv on the runner, renv added `renv.lock`'s repositories (CRAN of 2026-10-31,
Bioconductor 3.23) beside the release pak picks for the job's R version, and R-devel got S4Vectors 0.50.3 (3.23) with
BiocGenerics 0.60.0 (3.24), which do not build together (reproduced on R 4.6.2). Every CI job that installs packages
now sets `RENV_CONFIG_AUTOLOADER_ENABLED: "false"` (`.github/workflows/R-CMD-check.yaml:45`, `pkgdown.yaml:30`;
`tests/testthat/test_ciWorkflows.R`), so it installs current CRAN and one Bioconductor release, as CRAN does.
**Found while measuring, a CRAN blocker:** with Bioconductor 3.24's S4Vectors 0.52.0, `asPedFrame()` stops on every
Pedixplorer object (backlog **`:178`**, the new item at the old item's place): 21 test errors, `?asPedFrame`'s
example, and `vignettes/drawing.Rmd:593`'s chunk, which stopped CI's R-devel build at S98.
**Next, by Mark's pick** ("CI fix now; converter next (Recommended)"): backlog **`:178`**, the converter on S4Vectors
0.52.0 (strict TDD); then 17n, which freezes the tree.
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `19e8dea` (close-out 1,
without the skip marker): R-CMD-check run 45930893462: macOS, Windows, Ubuntu oldrel-1 Status OK (`PASS 17090`,
`17078`, `17079`); Ubuntu release failed `test_savePedigreeDiagram.R:575` at attempt 1 (a hung Chrome at the
recording's start, `:207`) and read Status OK at its rerun (`PASS 17079`); Ubuntu devel installed Bioconductor 3.24
alone, S4Vectors 0.52.0 built, and `R CMD build` stopped at `drawing.Rmd:593`-`:602` (the converter, `:178`); pkgdown
passed. Close-out 2 pushed after it (the skip marker, no run).
**The orient picker:** "(Recommended)" on `:178` (Mark's pick above); the rest grouped and named (34 items, `grep -n
'^- \[ \]' methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:159`, `:168`, `:201`, `:252`,
`:259`, `:265`, `:279`, `:284`, `:296`, `:312`, `:331`; READY by Mark's pick `:207` (the Chrome diagnostic); NEEDS
DECISION `:64`, `:72`, `:81`, `:94`, `:229`, `:247`, `:302`, `:322`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`.
Not offered: `:105` (a session Mark starts in nprcgenekeepr, R101's exception), `:20` and `:116` (BLOCKED). Name every
item.
**Session boundary:** one session, then close out.
**Priority:** HIGH (`:178` blocks 17n-17q: CRAN's machines install the current Bioconductor).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S98 changed no copied file);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`) and nprcgenekeepr at `3e06730c5`, unless Mark has run `:105`
   or `:252` there (then update `DIVERGENCE.md` as R101 says).
2. **`:178`, the converter** (if picked): read the item first (cause, counts, recipe). Build the scratch library of
   Bioconductor 3.24 (BiocGenerics 0.60.0, S4Vectors 0.52.0, Pedixplorer 1.10.0) by its recipe; the RED tests must
   fail there and pass on the lock's 3.23 set too (run both: the fix has to work on both releases, and on 3.22's
   S4Vectors 0.48.1 that CI's oldrel-1 installs). The stop is `as.data.frame(Pedixplorer::rel(x))` at
   `R/asPedFrame.R:412` (in `.asPedFramePedixplorer()`, `:383`). Measure each fix before the picker (Learning 17):
   Pedixplorer's own S4 method for `Rel` called directly, or the table built from `rel(x)`'s slots; and whether
   `renv.lock` moves to Bioconductor 3.24 (Learning 3's traps; a picker of its own). NEWS needs a line (a user on
   Bioconductor 3.24 meets it).
3. **17n** (`docs/planning/cran-submission-plan.md:1052`) only after `:178`: it freezes the tree.
4. **CI on every push:** five jobs, now without renv (current CRAN; Bioconductor by pak: R 4.6 had 3.23 at S98, R-devel
   3.24, oldrel-1 3.22). Known flakes: `:207` (a hung Chrome start; S98's at the recording's start, a first),
   `:229` (a blank PDF), `:247` (the app's click, macOS). Rerun a failed job once (`gh run rerun <run> --job <id>`,
   after the run ends), then list the rerun's jobs by attempt (`gh api
   repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`); read logs through the jobs API (`curl -sSL -H
   "Authorization: Bearer $(gh auth token)" https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`);
   a failing install's `Repo status` table and its `+ <pkg> <version>` lines say which repository gave each package
   (dragon 43). Watch a run with a Monitor loop on `gh run view <run> --json status,conclusion,jobs` (45 s).
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Local runs still use renv's lock (Bioconductor 3.23)**; CI no longer does. A local pass says nothing about
  Bioconductor 3.24 or current CRAN: test both (dragon 43). Start a scratch Rscript from the project's folder with
  `RENV_CONFIG_AUTOLOADER_ENABLED=false`, `RENV_PROJECT` unset and `R_LIBS`/`R_LIBS_USER` set, or `.Rprofile` takes over.
- **pak's Bioconductor map lags Bioconductor's:** pkgcache 2.2.5 (scratch install) reads R 4.6.2 as 3.24 and R 4.7.0
  as 3.25, but CI's pak gave 3.23 and 3.24 at S98. When CI's R 4.6 jobs move to 3.24, Windows, macOS and Ubuntu
  release meet the converter too, until `:178` is fixed.
- **Run each RED test against a deliberately wrong prototype too (dragon 42):** S98's workflow test was run against 4
  (one file only, a step's env, commented out, set to true); each failed.
- **chromote prints "[warning] got non-close frame while closing"** and sometimes "Unhandled promise error: ...
  Browser.close" to the console after a Chrome test; testthat counts no warning for either (WARN 0).
- **Carried:** write `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable; a calling handler set outside
  `try()` never runs (put `withCallingHandlers()` inside it); the README render needs a scratch install; the skip
  marker (a push whose head commit holds it runs no workflow); a Chrome test can error under load; the check without
  suggested packages needs a scratch R home; CRAN's DESCRIPTION spell check reads `.aspell/` (dragon 39); a CRAN check
  runs only 21 test files (list a new test file in `tests/testthat/slowTestFiles.txt`); Rscript inside
  `tests/testthat/` loads no renv; backslashes in `Rscript -e` go in a file (S98 met it once); the 5-file cap splits
  commits; never commit `tests/testthat/_problems/`; `CLAUDE.md` is over its budget (learnings go to the cran plan's
  dragons, now 43); `methodology/HANDOFFS.md` about 242 KB after S98, about 20 KB under the 262,144 B size where a
  default read returns nothing (backlog `:322`): keep the receipt short; the full suite takes 10.2-10.9 min, the
  ratchet's run about 12.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- S98 (DONE): `.github/workflows/R-CMD-check.yaml:38`-`:45` (the comment and the line), `pkgdown.yaml:28`-`:30`;
  `tests/testthat/test_ciWorkflows.R` (`.jobsStartingRenv()`); R170
  `docs/planning/standalone-pedigree-package-plan.md:355`; dragon 43 `docs/planning/cran-submission-plan.md:1343`.
- `:178`, the converter: `methodology/BACKLOG.md:178`; `R/asPedFrame.R:383` (`.asPedFramePedixplorer()`), `:412`
  (the `as.data.frame()` call), `:194` (the help example), `:232` (`asPedFrame.Pedigree()`);
  `vignettes/drawing.Rmd:593`-`:602`; the tests `tests/testthat/test_asPedFramePedixplorer.R`,
  `test_asPedFrameMatings.R`, `test_asPedFrameHints.R`, `test_infertileMark.R`, `test_miscarriageMark.R`.
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
### What Session 98 Did
**Deliverable:** backlog `:178`, Ubuntu devel's CI job failing to build S4Vectors, strict TDD. DONE (R170): the cause
was two Bioconductor releases in one install (renv's lock's 3.23 beside pak's 3.24); every CI job that installs
packages keeps renv off. Found while measuring: `asPedFrame()` stops on Bioconductor 3.24 (backlog `:178`, next).
**Started:** 2026-11-26 20:16 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option where
one was):** ":178 S4Vectors (Recommended)" (orient); "CI fix now; converter next (Recommended)"; "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Skip REFACTOR (Recommended)".
**Commits:** claim `542b47a`; RED `b28302b`; GREEN `b3d54c8`; close-out 1 `19e8dea` (pushed without the skip marker:
run 45930893462, its Ubuntu release job rerun once); close-out 2 (these notes, the receipt, the ledger), pushed after.
**Measured:** S97's devel log: pak's `Repo status` listed Bioconductor 3.23 (renv's, "cranlike") and 3.24 (pak's) for
R 4.7, and installed S4Vectors 0.50.3 and Pedixplorer 1.8.0 from 3.23 and BiocGenerics 0.60.0 from 3.24; R 4.6 jobs
got 3.23 from both, oldrel-1 3.22's S4Vectors 0.48.1 with 3.23's BiocGenerics 0.58.1 (a pair that builds). On R 4.6.2
in scratch libraries: BiocGenerics 0.60.0 + S4Vectors 0.50.3 stops with CI's error; 0.58.1 + 0.50.3 and 0.60.0 +
0.52.0 build (BiocGenerics 0.60.0 adds an S4 `transform()` generic). S4Vectors' `transform` code is the same in
0.50.3, 0.52.0 and 0.53.0; R-universe built 0.53.0 on R-devel r90959. Bioconductor's devel report ran R-devel r90887.
pkgcache 2.2.5 maps R 4.6.2 to 3.24 and R 4.7.0 to 3.25. 8 of the 69 CRAN packages DESCRIPTION reaches are newer on
current CRAN than the lock's snapshot (shiny 1.15.0 the only direct one). Pedixplorer 1.10.0 on S4Vectors 0.52.0: 28
test files, 363 tests, 0 failed, 21 errors (0 on the lock's set); Pedixplorer 1.8.0 on 0.52.0 stops too; the
`?asPedFrame` example stops on 3.24 and runs on 3.23. nprcgenekeepr's lock has no Bioconductor package.
**Verified:** RED: 3 tests, 13 expectations, 2 failed (both jobs), WARN 0; on scratch copies the right prototype 0
failed and 4 wrong ones 1, 2, 2, 2. GREEN: both workflows parsed by `yaml::read_yaml()`; the file 13 of 13; full
suite (`NOT_CRAN=true`) 108 files, 1,228 tests, 17,344 expectations, 0 failed, 0 errors, 0 skipped, WARN 0 (10.2
min); `R CMD check --as-cran` Status 1 NOTE (R16's), CRAN-mode `[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2697 ]`, 93 s;
lint 0; roxygen unchanged; quality_ratchet 7/7 at `19e8dea` (results `dd3bb45ce615`). CI: as in the Status line;
the devel job as predicted at the RED->GREEN gate (one release, S4Vectors built, then the converter), except that
it stopped earlier than the predicted example, at the vignette in `R CMD build`. No R code changed: no coverage run.

#### Session 97 Handoff Evaluation (by Session 98)
**Score: 9/10.** ROI high: Orient and the first finding ran from its notes.
- **What helped:** Mark's pick under "Next"; What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each
  exact); 2's "read S97's Ubuntu devel job log first (run 45921649070, job 140253524152)": the log's repository
  table showed the cause within minutes; the workflow lines `:31` and `:50`-`:53` exact; every backlog item at its
  stated line; the CI step (rerun once, logs through the jobs API, a Monitor loop) used as written.
- **What was missing:** that renv starts on the runner from `.Rprofile` (the documentation plan said so, "On the
  runner renv starts from `.Rprofile`", as at S97; no handoff did), which was the cause.
- **What was wrong:** the item's premise, carried since S49 and S95, that S4Vectors "does not build on R-devel"; 2's
  "find whether Bioconductor has an S4Vectors newer than 0.50.3 that builds on R-devel" followed it, and a newer one
  would not have helped while renv's 3.23 stayed in the install. Not S97's finding, but its handoff relayed it as fact.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the log read before any theory; the cause reproduced on R 4.6.2 with
  three version pairs before the picker; what each option would change measured (the CRAN delta, pak's map, the
  Pedixplorer tests on 3.24), which found the converter bug before the decision; RED run against 4 wrong prototypes
  (dragon 42); GREEN verified by the full suite and `R CMD check`; CI read as predicted at the gate.
- **A first theory cost time:** I read R-devel's NEWS for a `transform` change before comparing the installed
  versions, the comparison the log already offered.
- **Slips caught before commit:** dragon 43 said "S19" (S20, `c43b36a`, added Bioconductor 3.23) and "9 weeks" (8
  days since S49); a calling handler placed outside `try()` caught nothing; a backslash in `Rscript -e`, warned of.

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
