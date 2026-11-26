# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17l DONE (S33-S95); the gap
phases G1-G17 DONE (S42-S77); the crash item DONE (S89, R163); the Windows CI hang DONE (S91, R164). **17l DONE
(S95, R167):** US spelling throughout with `inst/WORDLIST` (the spelling check 0 words, gate
`spelling-words-zero`), `Depends: R (>= 4.5.0)`, the methods' DOI in `Description` with a package `.aspell` list,
and every test that calls a package a check without suggested packages hides guarded (that check passes in CRAN
mode and with the full suite, under a scratch R home); the suite gate's limit 1200 s (7/7 pass, measured).
**Next, by Mark's pick:** Phase 17m, the release text and the version (`docs/planning/cran-submission-plan.md:1016`;
Mark's pick at S95's close, "Phase 17m next (Recommended)", over the S4Vectors decision and the Chrome diagnostic).
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `39b5da9` (run
45760561429): Ubuntu release, macOS, Ubuntu oldrel-1 OK; Windows OK at its rerun (attempt 1 failed one SVG-legend
comparison, backlog `:206`); Ubuntu devel fails building S4Vectors (`:178`, a decision due before 17n); pkgdown OK.
Close-out pushed after it (documents only, no CI run).
**The orient picker:** "(Recommended)" on 17m (Mark's pick); beside it the S4Vectors decision `:178` and the Chrome
diagnostic `:192`; the rest grouped and named (33 items, `grep -n '^- \[ \]' methodology/BACKLOG.md`): READY `:11`,
`:29`, `:39`, `:45`, `:55`, `:88`, `:159`, `:168`, `:186`, `:225`, `:231`, `:245`, `:250`, `:262`, `:278`, `:297`;
NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:206`, `:220`, `:268`, `:288`; "Waiting on Mark" `:122`, `:129`, `:136`,
`:148`. Not offered: `:105` (a session Mark starts in nprcgenekeepr), `:20` and `:116` (BLOCKED). Name every item.
**Session boundary:** one session (17m), then close out.
**Priority:** HIGH (17m-17q).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S95 changed help text in 4 copied
   files, no code); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); nprcgenekeepr at
   `3e06730c5`, tree clean.
2. **17m** (`docs/planning/cran-submission-plan.md:1016`): read it, D8 (`:1076`: 0.1.0 or 1.0.0; the API contract's
   section 6, "0.x until the first CRAN release", and its deprecation rule after it; a pre-RED picker with what
   each version means for users), section 2.5 (`:282`; the version is `0.0.1` in `DESCRIPTION:4` and `NEWS.md:1`;
   `README.Rmd:42` says "not on CRAN yet"). Work: NEWS's heading `# pedkindraw 0.0.1 (development version)` becomes
   the release's, each NEWS item checked against the code as 17b-17l left it (NEWS.md has `## Requirements` and `##
   Documentation` sections since S95); the README's install section (no CRAN link before acceptance: a 404 the
   incoming check reports, dragon 10), rendered twice the same; `?pedkindraw` if it names the version. DONE:
   `R CMD check --as-cran` R16's NOTE only; `git grep` of the old version finds none outside history. Measure each
   choice before its picker (Learning 17); TDD where tests change (a version test, if any).
3. **CI on every push:** five jobs. Ubuntu devel fails building S4Vectors (`:178`). Known flakes: `:192` (a hung
   Chrome start, Ubuntu release), `:206` (a blank PDF, and S95's SVG-legend fault, Windows), `:220` (the app's click,
   macOS). Rerun a failed job once (`gh run rerun <run> --job <id>`, after the run ends), then list the rerun's jobs
   by attempt (`gh api repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`); read logs through the jobs
   API (`curl -sSL -H "Authorization: Bearer $(gh auth token)"
   https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`). S95 waited with a Monitor loop on
   `gh run view <run> --json status,jobs` (45 s) instead of checking by hand.
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **The README render needs pedkindraw installed, and none is** (S95 removed renv's stale 0.0.1, backlog item done):
  `README.Rmd:57` calls `library(pedkindraw)`. Install the tree into a scratch library (`R CMD INSTALL
  --library=<scratch> .`) and render with it first on `R_LIBS`; installing into renv's library brings back the
  stale-copy problem. `tools/makeReadmePicture.R` says the same for the picture.
- **The check without suggested packages** (17n repeats it): only under a scratch R home whose `library` holds R's
  29 standard packages (17l's DONE paragraph has the recipe; S95's is in the scratchpad, gone next session);
  `_R_CHECK_DEPENDS_ONLY_` alone hides nothing in this Mac's R library of 256 packages (dragon 6). testthat skips a
  missing package only on CRAN (dragon 38), so run it with `NOT_CRAN=true` too.
- **CRAN's DESCRIPTION spell check** (dragon 39) reads `.aspell/`, not `inst/WORDLIST`; a new word in `Description`
  needs `.aspell/pedkindraw.rds` too (`.aspell/defaults.R` says how). A version or NEWS change does not touch it.
- **zsh does not split an unquoted variable into words:** `perl script.pl $FILES` passed one long name (S95's first
  dry run converted nothing); pipe the list through `xargs`.
- **A CRAN check runs only 21 test files** (R165): a new test file runs on CRAN until listed in
  `tests/testthat/slowTestFiles.txt` (S95 listed `test_suggestsGuarded.R`); the 540 s is the email's check time
  (R85); 17o's reading still gates the submission (R86).
- **roxygen builds `?pedkindraw`'s description from `DESCRIPTION`:** a `Description` or version change needs
  `roxygen2::roxygenise()` and `man/pedkindraw-package.Rd` in the same commit (S95's GREEN 7 missed it; GREEN 8).
- **Carried:** on Windows, R CMD check waits for every process the tests start (dragon 35); Rscript started inside
  `tests/testthat/` does not load the project's renv (run from the root); `rm -rf "$VAR/..."` is refused (write
  `"${VAR:?}"`; S95 met it once); backslashes in `Rscript -e` (put such code in a file); one-off scripts as `Rscript
  --no-init-file` with `R_LIBS` and `R_LIBS_USER` set to renv's library; the 5-file cap splits commits;
  `testthat::test_file()` can leave `tests/testthat/_problems/` (never commit it); `CLAUDE.md` is over its budget
  (learnings go to the plans' dragons; the cran plan's section 9 now ends at 39); `methodology/HANDOFFS.md` about
  238 KB after S95, about 24 KB under the 262,144 B size where a default read returns nothing, about 9-12 more
  receipts (backlog `:288`, NEEDS DECISION): keep the receipt short; a push whose head commit's message holds the
  skip marker anywhere runs no workflow (write it in words); the full suite takes 10.6 min, the ratchet's run 11.7.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- 17m: `docs/planning/cran-submission-plan.md:1016` (17m), `:1076` (D8), `:282` (2.5, the version's places);
  `DESCRIPTION:4` (`Version`); `NEWS.md:1` (the heading), `NEWS.md` `## Requirements` and `## Documentation` (S95);
  `README.Rmd:40`-`:44` (Installation), `:57` (`library(pedkindraw)`); `R/pedkindraw-package.R:70` (`"_PACKAGE"`);
  `docs/planning/pedkindraw-api-contract.md:303` section 6 (versions and deprecation).
- 17l (DONE): `docs/planning/cran-submission-plan.md:981` (17l and its DONE paragraph), dragons 38-39 (`:1281`,
  `:1288`); R167 `docs/planning/standalone-pedigree-package-plan.md:349`; `tests/testthat/helper-suggestsGuarded.R`,
  `tests/testthat/test_suggestsGuarded.R`; `inst/WORDLIST`; `.aspell/defaults.R`; `methodology/.quality-gates.json`
  (gate `spelling-words-zero`; the suite gate's `timeout_seconds` 1200).
- CI: `.github/workflows/R-CMD-check.yaml:28`-`:33` (the matrix), `:40` (`actions/checkout@v5`), `:78`
  (setup-chrome's `install-dependencies`, backlog `:186`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 96 Did
**Deliverable:** Phase 17m (`docs/planning/cran-submission-plan.md:1016`): the release text and the version (D8)
(IN PROGRESS)
**Started:** 2026-11-26 09:15 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Phase 17m (Recommended)" (orient).
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

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

### What Session 93 Did
**Deliverable:** the backlog item "A CI job fails now and then while Chrome starts" (`methodology/BACKLOG.md:214`),
strict TDD. NOT DONE: the fix Mark picked (a 60 s start wait, R166) is in and tested, but CI then showed the
failures are hangs it does not cure; the item stays open, rewritten, READY for a diagnostic by Mark's pick.
**Started:** 2026-11-25 16:40 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Chrome start-up failures (Recommended)" (orient; the email could not have come: the upload was still in the
queue); "Wait 60 s for the start (Recommended)"; "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR";
after the REFACTOR push's Ubuntu job hung past 60 s, "Close out; measure on CI next (Recommended)".
**Commits:** claim `fc3dc5c`; RED `9fbfb3a`; GREEN `d79dbed` (pushed with RED: run 45721768010, its Windows job rerun
once); REFACTOR `b0b9556` (pushed: run 45737321097, its failed jobs rerun once); close-out 1 `3093e82` (R166, dragon
37, the picture plan's dragon 11, the roadmap); close-out 2 (the backlog, these notes, the receipt, the ledger),
pushed after it; close-out 2b (the push entry).
**Measured:** every R-CMD-check run (91 runs, 480 jobs by attempt) and every failed check step's log: 3 start
failures in the 80 jobs since S71, all at `.renderPicture()`'s start; a trace of the 21 Chrome-starting test files
here (109 starts: 61 the recording's, 27 the picture's, 18 the app's and legends', 3 helpers'; slowest 0.84 s);
chromote 0.5.1's start code; nprcgenekeepr's history of the same message (it pinned Chrome in CI, never waited
longer); a stand-in Chrome in scratch copies (HEAD: the CI error at either start, 10.2 s and 11.6 s, 11 processes
left until `gc()`; with a 60 s wait: saved in 12.6 s and 14.0 s; one that never opens its port: 10.2 s against 60.1
s); the drafts before RED (4-6 failed on HEAD, all passed on the prototype, 27.5 s) and the REFACTOR draft (lint 0,
235 expectations passed); chromote's vignette on `Page$navigate()`.
**Verified:** RED: the file 35 tests, 235 expectations, 5 failed, all in the two new tests, WARN 0, lint 0. GREEN: the
file 0 failed; the full suite (`NOT_CRAN=true`) 105 files, 1,204 tests, 17,268 expectations, 0 failed, 0 skipped,
WARN 0 (10.7 min); lint 0; roxygen unchanged; `R CMD check --as-cran` Status 1 NOTE (R16's), CRAN-mode tests
`[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2695 ]` 28.5 s, the check 116 s; CI run 45721768010: macOS OK `PASS 17043`,
Ubuntu release and oldrel-1 OK `PASS 17032` (S92's plus the new tests' 10), Windows failed once at
`test_savePedigreeDiagram.R:525` (a blank first PDF; backlog `:228`), rerun OK `PASS 17031`; Ubuntu devel
S4Vectors. REFACTOR: the same suite counts (10.5 min) and check (29.2 s, 116 s); CI run 45737321097: Windows OK
`PASS 17031`, oldrel-1 OK `PASS 17032`; Ubuntu release failed at `:366` and, rerun, at `:653`, "port not open after
60 seconds", each with a detritus NOTE; macOS failed at `test_pedigreeAppBrowser.R:103` both times (`:238`). Drift 91
/ 23 / 0 at Orient and close. quality_ratchet at close-out (the receipt).

#### Session 92 Handoff Evaluation (by Session 93)
**Score: 9/10.** ROI high: Orient and the item's research ran from its notes, and every cited line was where it said.
- **What helped:** the ACTIVE TASK's "ask Mark first whether the email has come" with What You Must Do 2's queue
  command, which answered it by measurement (the upload still first in the queue at 22:35 UTC); What You Must Do 1
  (91 / 23 / 0, the 4 commits, S92's copies, `3e06730c5`, each exact); 4's jobs-API and rerun commands, used four
  times; the backlog item's three failures with their runs and the S92 site, and its three choices, which framed the
  approach picker; the gotcha on the 21 CRAN-run files; the 32 items at their stated lines.
- **What was missing:** that S89's failure was at the same start as S92's (`R/savePedigreeDiagram.R:301` then, `:302`
  at S92): the item named the site for S92's only. Reading every failed log showed all three at one start.
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 5/10.**
+ Orient in full, the claim before any work; the whole CI history read and the starts traced before the approach
  picker; the CI error reproduced with a stand-in and each option measured; the drafts run in scratch copies before
  each gate, so each gate stated counts; RED, GREEN and REFACTOR each verified here (suite, lint, check) and on CI;
  GREEN's Windows failure read and kept out of scope (backlog `:228`, with chromote's own vignette); when CI disproved
  the fix, Mark had the facts and a picker at once, not a second fix.
- **The deliverable is not done, and the fix I recommended did not work.** My own counts (all three failures at one
  start, one of them a hang) pointed at a hang at that start, yet the approach picker recommended a longer wait that
  rested on "if Chrome was only slow", which no log could show; dragon 35 (read it on the runner) was already in
  this repository. A diagnostic push first would have cost one CI run, not two TDD cycles' CI.
- **Slips not reaching Mark:** the trace's first run lost 20 of 21 files to a line break in a command file (rerun);
  one command wrote a stray file outside the scratchpad (removed); a `gh run watch` returned before the rerun's job
  started (watched the job instead).
