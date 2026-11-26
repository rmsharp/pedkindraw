# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17m DONE (S33-S96); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **17m DONE
(S96, R168):** version `1.0.0`; NEWS readied for the release, each of its 54 items and its opening checked against
the code (12 statements corrected, 4 comparisons with behavior no release had reworded, the Documentation section
completed); the README's install section ("Install the development version from GitHub:") and its three
articles; `?removeAnimals` and the speed vignette's opening corrected with NEWS; `tests/testthat/test_releaseTextDocs.R`
holds the release text to the version; S2's version test now `>= "1.0.0"`.
**Next, by Mark's pick:** backlog `:186`, what 17m's check of NEWS found outside NEWS (Mark's pick at S96's close, "17m's
findings :186 (Recommended)", over the S4Vectors decision `:178`, the picture flake `:232` and another item);
then `:178`; then 17n, which freezes the tree.
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `b0eb2e7` (close-out 1,
without the skip marker): run 45888606992: Windows, macOS and Ubuntu oldrel-1 Status OK (`PASS 17044`, `17056`, `17045`); Ubuntu release failed `test_savePedigreeDiagram.R:184` at attempt 1 (the feature pedigree's legend 50.2% differing, bound 1%; backlog `:232`) and read Status OK at its rerun (`PASS 17045`); Ubuntu devel failed building S4Vectors (`:178`). pkgdown and speed-tables passed; the site's NEWS page shows 1.0.0 and its home page the new install text. Close-out 2 pushed after it (the skip marker, no run).
**The orient picker:** "(Recommended)" on Mark's pick above; the rest grouped and named (34 items, `grep -n '^- \[ \]'
methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:159`, `:168`, `:212`, `:255`, `:261`,
`:275`, `:280`, `:292`, `:308`, `:327`; NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:178` (S4Vectors, before 17n),
`:186` (17m's findings, before 17n), `:232`, `:250`, `:298`, `:318`; READY by Mark's pick `:218` (the Chrome
diagnostic); "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a session Mark starts in
nprcgenekeepr, R101's exception; S96 told Mark what it involves), `:20` and `:116` (BLOCKED). Name every item.
**Session boundary:** one session, then close out.
**Priority:** HIGH (17n-17q; `:178` and `:186` before 17n).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S96 changed no copied function);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`) and nprcgenekeepr at `3e06730c5`, unless Mark has run the
   `:105` port there (then update the three `DIVERGENCE.md` rows it touches, R101).
2. **`:186`, 17m's findings outside NEWS** (if picked): five sub-items; 1, 4 and 5 are Mark's decisions (a picker
   each, measured first), 2 must be drawn before any words change (Learning 18), 3 is a comment. A decision that
   changes behavior is strict TDD; a change to app words also changes `tests/testthat/test_pedigreeAppMarks.R:320`
   and NEWS (`NEWS.md:309`, "CSV or text").
3. **`:178`, S4Vectors** (if picked): read the devel job's log first (it failed again on S96's run); the two choices
   are in the item.
4. **17n** (`docs/planning/cran-submission-plan.md:1052`) only after `:178` and `:186`: it freezes the tree.
5. **CI on every push:** five jobs; Ubuntu devel fails building S4Vectors (`:178`). Known flakes: `:218` (a hung
   Chrome start, Ubuntu release), `:232` (a blank PDF on Windows; the SVG-legend comparison, Windows in S95 and Ubuntu release in S96), `:250` (the app's
   click, macOS). Rerun a failed job once (`gh run rerun <run> --job <id>`, after the run ends), then list the
   rerun's jobs by attempt (`gh api repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`); read logs through
   the jobs API (`curl -sSL -H "Authorization: Bearer $(gh auth token)"
   https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`). Watch a run with a Monitor loop on
   `gh run view <run> --json status,conclusion,jobs` (45 s), as S95 and S96 did.
6. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Read a search whole before a picker states its result (dragon 40):** S96's pre-RED search for a version test
  ended in `| head` and missed `tests/testthat/test_package.R:28`; the full suite found it after GREEN (RED 3).
- **Version tests:** `tests/testthat/test_package.R:25`-`:36` (`>= "1.0.0"`; no part of 1234 or more; no leading
  zero) and `tests/testthat/test_releaseTextDocs.R` (NEWS's first heading names the version, "(development
  version)" only for a `.9000` one). 17q's `1.0.0.9000` fails test_package's 1234 rule: change it then, test-first
  (17q's work line says so).
- **NEWS words other tests hold:** `test_makePedigreeMatingLayoutNoRowParentDocs.R`, `test_runPedigreeAppDocs.R`,
  `test_savePedigreeDiagramDocs.R` ("letter paper", "overlap"), `test_speedPointersDocs.R`,
  `test_speedVignetteDocs.R`, `test_releaseTextDocs.R` (the README item must begin "New: the README" or "The
  README"). Run all six after any NEWS edit.
- **The README render needs pedkindraw installed, and none is:** `R CMD INSTALL --library=<scratch> .`, then
  `Rscript --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to `<scratch>:<renv library>` and
  `rmarkdown::render("README.Rmd")`; S96's two renders were byte-identical.
- **The skip marker:** a push whose head commit's message holds it runs no workflow, and R-CMD-check has no manual
  trigger; S96 pushed close-out 1 without it to run CI and the site on the release text.
- **A Chrome test can error under load:** S96's second full run had 1 error in `test_savePedigreeDiagram.R`'s
  live-widget test at load average 9-10 (other processes on this Mac); the file alone passed 235 of 235. Its
  message was not kept (the suite script printed only names): print `conditionMessage()` of each error next time.
- **Carried:** the check without suggested packages needs a scratch R home (17l's DONE paragraph); CRAN's
  DESCRIPTION spell check reads `.aspell/` (dragon 39); zsh does not split an unquoted variable (pipe through
  `xargs`); a CRAN check runs only 21 test files, so list a new test file in `tests/testthat/slowTestFiles.txt`
  (S96 listed `test_releaseTextDocs.R`); roxygen builds `?pedkindraw` from `DESCRIPTION`; on Windows R CMD check
  waits for every process the tests start (dragon 35); Rscript inside `tests/testthat/` loads no renv (run from the
  root); write `"${VAR:?}"` in `rm -rf`; backslashes in `Rscript -e` go in a file; the 5-file cap splits commits;
  never commit `tests/testthat/_problems/`; `CLAUDE.md` is over its budget (learnings go to the cran plan's
  dragons, now 41); `methodology/HANDOFFS.md` about 238 KB after S96, about 24 KB under the 262,144 B size where a
  default read returns nothing (backlog `:318`): keep the receipt short; the full suite takes 10.4-10.9 min, the
  ratchet's run about 12.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17m (DONE): `docs/planning/cran-submission-plan.md:1020` (17m and its DONE paragraph), `:282` (2.5), `:1104`
  (D8), dragons 40-41 (`:1323`, `:1328`); R168 `docs/planning/standalone-pedigree-package-plan.md:351`; contract
  `docs/planning/pedkindraw-api-contract.md:323`; `DESCRIPTION:4`; `NEWS.md:1`, `## Documentation`;
  `README.Rmd:34`-`:43`; `tests/testthat/test_releaseTextDocs.R`, `tests/testthat/test_package.R:25`.
- `:186`'s places: `R/pedigreeApp.R:124` (`read.csv`), `:752`, `:755`, `:458` (`.appDeceased()`);
  `R/runPedigreeApp.R:19`; `R/makePedigreeDiagramData.R:2189`-`:2191`, `:3105`-`:3109`, `:3027`-`:3035`,
  `:3137`-`:3143`; `inst/js/recordCanvas.js:12`-`:14`; `R/savePedigreeDiagram.R:124`.
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
**Deliverable:** backlog `:186` (`methodology/BACKLOG.md`), what 17m's check of NEWS found outside NEWS: five
sub-items, strict TDD for any behavior change (IN PROGRESS)
**Started:** 2026-11-26 16:12 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** ":186 NEWS findings
(Recommended)" (orient).
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

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

### What Session 94 Did
**Deliverable:** finish Phase 17k (`docs/planning/cran-submission-plan.md:880`; R85, R86). DONE: win-builder
R-devel's second reading, of the package as at `23a6186` (R165's cut), read 321 s, 219 s under 540 s.
**Started:** 2026-11-25 21:35 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option where
one was):** the email "Yes, it came" (then pasted: `ZYsFyCy5GM5z`, installation 19 s, check 321 s, Status 1
NOTE); "S93's pick, by the email (Recommended)"; at the close, "Phase 17l next (Recommended)".
**Commits:** claim `5bd91b8`; the reading `d77c569` (the cran plan's 17k, section 2.1, dragon 36 and status line;
the standalone plan's status block and Next; the roadmap); close-out 2 (these notes, the receipt, the ledger),
pushed after it; close-out 2b (the push entry). No package code; no CI run (documents only, the skip marker).
**Measured:** the folder's logs, each in its own scratchpad folder: the check started 23:11:00 UTC (1 h 35 min after
the upload); incoming 10 s, R code 35 s, examples 17 s, tests 126 s, vignettes 30 s, PDF manual 29 s, the untimed
steps about 56 s; the tests' `proc.time()` 125.4 s elapsed for 124.2 s CPU; `[ FAIL 0 | WARN 0 | SKIP 25 | PASS
2694 ]` (here 24 and 2,695: `test_savePedigreeDiagram.R:499`, one expectation, skips on Windows). Against S92's check
of the same package here (100 s, tests 29.8 s): 3.2× and 4.2×; R165's estimate 312 s, 3% under. The cut took 663 s
off the tests; the rest of the check 196 s (192 s at the first reading). The margin: a check 1.68× this one reaches
540 s; nprcgenekeepr's slower day would read about 381-389 s. HEAD's package differs from `23a6186`'s by S93's 5
files (the changed files against `.Rbuildignore`); the list of 84 slow files unchanged. For 17l: `Suggests` 13
packages (the plan says 9), `mockery::` in 7 test files, `withr::` in 51, no `inst/WORDLIST`.
**Verified:** at HEAD, `test_slowTestFiles.R` 7 tests, 19 expectations and `test_slowTestFilesExports.R` 3 tests, 6
expectations, 0 failed; every number in the plan computed by a script; drift 91 / 23 / 0. quality_ratchet at
close-out (the receipt).

#### Session 93 Handoff Evaluation (by Session 94)
**Score: 9/10.** ROI high: Orient and the reading ran from its notes, and every cited line was where it said.
- **What helped:** "ask Mark first whether the email has come" with the pick under each answer (the orient picker
  followed it); What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); 3, the folder's files by
  name, the five plan lines (each exact at `f3f2009`), the guess at the counts (SKIP 25 exact), HEAD's CRAN-mode
  figures beside `23a6186`'s, and "540 s or less: 17k DONE"; the 34 items at their stated lines.
- **What was missing:** that S92 recorded the first reading in 17k but not in section 2.1, which the plan's "Left"
  asked for; and where S92's local check of `23a6186` was recorded (100 s, 29.8 s, load 6.6-5.5: in GREEN's commit
  message only). Each found in minutes.
- **What was wrong:** nothing; the guess PASS 2693 read 2694 (labelled a guess).
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; the reading fetched and recorded with every derived number computed
  by a script, beside both earlier readings; DONE's other two parts checked at HEAD by running them, not assumed;
  S92's missing section 2.1 record added; the inputs 17l rests on re-measured for the handoff (three stale counts);
  the next session's task put to Mark at the close (answered first try).
- **Slips caught before commit:** "HEAD differs only by S93's start wait" first named 3 of the 5 changed package
  files (`NEWS.md` and a helper missed by a `git diff` over named folders); and the first `.Rbuildignore` filter
  matched each file, not each folder, so it listed `docs/` and `methodology/` as shipped. Both corrected from a
  second listing before `d77c569`.
- The orient picker asked for the email in the notes box; the answer came without it and Mark pasted it separately.
