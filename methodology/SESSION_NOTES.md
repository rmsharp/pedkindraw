# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17m DONE (S33-S96); the gap
phases G1-G17 DONE (S42-S77); S97's and S98's items DONE (R169, R170). **Backlog `:178`, `asPedFrame()` on
Bioconductor 3.24's S4Vectors 0.52.0, DONE (S99, R171):** a Pedixplorer `Rel` extends S4Vectors' `Vector`, and a
plain `as.data.frame()` on it went through S4Vectors' S3 method for `Vector`, which stops on it from 0.52.0;
`.asPedFramePedixplorer()` now builds the relation table from Pedixplorer's accessors `id1()`, `id2()`, `code()`
(`R/asPedFrame.R:417`-`:421`), and a stand-in test copies 0.52.0's stop on the lock's 3.23
(`tests/testthat/test_asPedFrameS4Vectors.R`). On 3.24 the 29 test files naming Pedixplorer read 0 errors (21
before) and `R CMD build`/`check --as-cran` R16's NOTE. No NEWS line (Mark's pick: no released version stopped).
`renv.lock` stays at 3.23; **moving it to 3.24 is backlog `:178`** (the new item at the old one's place).
**Next:** Phase 17n, the full local gate (`docs/planning/cran-submission-plan.md:1052`), which freezes the tree;
the lock move, if Mark wants it before the submission, has to come before 17n (it changes `renv.lock`).
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `2456253` (close-out 1,
without the skip marker): R-CMD-check run 45946860858 5/5 Status OK, macOS at its rerun (`:236`'s flake); Ubuntu
devel on Bioconductor 3.24 built `drawing.Rmd` and passed, where S98's run stopped. Close-out 2 pushed after it
(the skip marker, no run).
**The orient picker:** "(Recommended)" on 17n (the plan's order; no pick of Mark's names a task before it); then the
lock move `:178` named on its own as the one item that must precede 17n if wanted; the rest grouped and named (34
items, `grep -n '^- \[ \]' methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:159`,
`:168`, `:190`, `:242`, `:249`, `:255`, `:269`, `:274`, `:286`, `:302`, `:321`; READY by Mark's pick `:196` (the
Chrome diagnostic); NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:218`, `:236`, `:292`, `:312`; "Waiting on Mark"
`:122`, `:129`, `:136`, `:148`. Not offered: `:105` (a session Mark starts in nprcgenekeepr, R101's exception),
`:20` and `:116` (BLOCKED). Name every item.
**Session boundary:** one session, then close out.
**Priority:** HIGH (17n-17q are the submission).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S99 changed no copied file:
   `R/asPedFrame.R` is pedkindraw's own); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log
   --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename
   | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`) and nprcgenekeepr at
   `3e06730c5`, unless Mark has run `:105` or `:242` there (then update `DIVERGENCE.md` as R101 says).
2. **17n** (if picked): read `docs/planning/cran-submission-plan.md:1052` in full first, and dragons 43 and 44
   (`:1343`, `:1353`): the local gate runs on renv's Bioconductor 3.23, so repeat S99's 3.24 check beside it
   (BACKLOG `:178`'s recipe; the 29 files naming Pedixplorer, then `R CMD build` and `check --as-cran` with the
   scratch library in front of renv's).
3. **`:178`, the lock move** (if picked, before 17n): read the item; Learning 3's traps in order (the dated CRAN
   repository set first, each package by name with `rebuild = TRUE`, `renv::snapshot(dev = TRUE)`, the
   `renv-lock-no-latest-repository` gate); renv's way of changing the Bioconductor release is unmeasured, so
   measure it in a scratch copy of the project before the picker (Learning 17).
4. **CI on every push:** five jobs, without renv (current CRAN; Bioconductor by pak). Known flakes: `:196` (a hung
   Chrome start), `:218` (a blank PDF), `:236` (the app's click, macOS). Rerun a failed job once (`gh run rerun
   <run> --job <id>`, after the run ends), then list the rerun's jobs by attempt (`gh api
   repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`); read logs through the jobs API (`curl -sSL -H
   "Authorization: Bearer $(gh auth token)" https://api.github.com/repos/rmsharp/pedkindraw/actions/jobs/<id>/logs`);
   a failing install's `Repo status` table names each package's repository (dragon 43). Watch a run with a Monitor
   loop on `gh run view <run> --json status,conclusion,jobs` (45 s).
5. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Local runs use renv's lock (Bioconductor 3.23); CI does not.** A local pass says nothing about 3.24: S99's
  scratch recipe (BACKLOG `:178`) took under 2 minutes. Start a scratch Rscript from the project's folder with
  `RENV_CONFIG_AUTOLOADER_ENABLED=false`, `RENV_PROJECT` unset and `R_LIBS`/`R_LIBS_USER` set, or `.Rprofile` takes
  over.
- **Bioconductor 3.22 cannot be built here:** S4Vectors 0.48.1 needs `Rf_findVar`, gone from R 4.6's API, and R
  4.5's framework launcher (`/Library/Frameworks/R.framework/Versions/4.5-arm64`) points `R_HOME_DIR` at the
  current R, so even a launcher copy with its own `R_HOME` compiled against 4.6's headers. CI's oldrel-1 is the
  only 3.22 check (dragon 44). Pedixplorer 1.6.0 does install on R 4.6.2 over the lock's S4Vectors 0.50.3.
- **`UseMethod()` finds a method in the generic's own namespace before the S3 table:** to wrap or stand in for a
  method of pedkindraw's, replace the namespace binding (`unlockBinding()`, `assign()`); `registerS3method()` alone
  caught 0 of 550 calls. For another package's method (S4Vectors' `as.data.frame.Vector`), the S3 table is what
  dispatch reads, so `registerS3method()` works (S99's stand-in).
- **R CMD check's URL check can read a transient 503 from GitHub** (S99, once, README's `DIVERGENCE.md` link; 200
  three times after): rerun before calling the NOTE new.
- **chromote prints "[warning] got non-close frame while closing"** and sometimes "Unhandled promise error: ...
  Browser.close" after a Chrome test; testthat counts no warning for either (WARN 0).
- **Carried:** write `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (S99 met it again: use an
  array, `"${FILES[@]}"`); a calling handler set outside `try()` never runs; the README render needs a scratch
  install; the skip marker (a push whose head commit holds it runs no workflow); a Chrome test can error under load,
  so run the full suite alone; the check without suggested packages needs a scratch R home; CRAN's DESCRIPTION
  spell check reads `.aspell/` (dragon 39); a CRAN check runs only 21 test files (list a new test file in
  `tests/testthat/slowTestFiles.txt`); Rscript inside `tests/testthat/` loads no renv; backslashes in `Rscript -e`
  go in a file; the 5-file cap splits commits; never commit `tests/testthat/_problems/`; `CLAUDE.md` is over its
  budget (learnings go to the cran plan's dragons, now 44); `methodology/HANDOFFS.md` 243,744 B after S99, about
  18 KB under the 262,144 B size where a default read returns nothing (backlog `:312`): keep the receipt short; the
  full suite takes about 10.2 min, the ratchet's run about 12.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- S99 (DONE): `R/asPedFrame.R:417`-`:421` (the table from the accessors, its comment at `:414`), `:477`
  (`.asPedFramePxTwins()`), `:485` (`.asPedFramePxMatings()`), `:385` (`.asPedFramePedixplorer()`);
  `tests/testthat/test_asPedFrameS4Vectors.R:21` (`.localStoppingVectorDataFrame()`), its tests `:48`, `:63`, `:84`,
  `:105`; `tests/testthat/slowTestFiles.txt:22`; R171 `docs/planning/standalone-pedigree-package-plan.md:356`;
  dragon 44 `docs/planning/cran-submission-plan.md:1353`.
- `:178`, the lock move: `methodology/BACKLOG.md:178`; `renv.lock` (its `Bioconductor` block, 3.23);
  `renv/settings.json` (`bioconductor.version: null`).
- 17n: `docs/planning/cran-submission-plan.md:1052`; CI `.github/workflows/R-CMD-check.yaml:27`-`:33` (the matrix),
  `:45` (renv off).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 100 Did
**Deliverable:** Phase 17n, the full local gate (`docs/planning/cran-submission-plan.md` section 17n), with S99's
Bioconductor 3.24 check beside it; after it the tree freezes (IN PROGRESS)
**Started:** 2026-11-27 10:23 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "17n: full local gate
(Recommended)" (orient).
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### What Session 99 Did
**Deliverable:** backlog `:178`, `asPedFrame()` stopping on every Pedixplorer object with Bioconductor 3.24's
S4Vectors 0.52.0, strict TDD. DONE (R171): the relation rows are read with Pedixplorer's accessors.
**Started:** 2026-11-26 22:09 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
":178 converter fix (Recommended)" (orient); "Pedixplorer's accessors", "Stand-in test; keep lock", "No NEWS line";
"Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR".
**Commits:** claim `5347bb3`; RED `80c620a`; GREEN `304eb3f`; REFACTOR `1f0a780`; close-out 1 `2456253` (pushed
without the skip marker: R-CMD-check run 45946860858, pkgdown run 45946860903); close-out 2 (these notes, the
receipt, the ledger), pushed after.
**Measured:** in scratch libraries on R 4.6.2 (3.24: BiocGenerics 0.60.0, S4Vectors 0.52.0, Pedixplorer 1.10.0; the
lock's 3.23; "3.22": Pedixplorer 1.6.0 and BiocGenerics 0.56.0 over S4Vectors 0.50.3, since 0.48.1 does not
compile): `Rel` extends `Vector` with the same slots in all three Pedixplorers; `as.data.frame.Vector` is registered
in all three and stops only on 0.52.0; the accessors, Pedixplorer's exported `as.data.frame()` and the slots each
gave today's rows on 5 objects on all three; on 3.24, HEAD's five converter files 69 tests, 21 errors, the accessor
prototype 0; the stand-in on the lock: HEAD fails, the prototype passes, `mcols()`'s read (`:395`) untouched.
**Verified:** RED: the new file 4 tests, 3 errors (each at `R/asPedFrame.R:412`), on 3.23 and 3.24; the six files on
3.24 24 errors; the right prototype 0 failing, 6 wrong ones 1-3 each (dragon 42). GREEN: the six files 73 tests,
2,568 expectations, 0 errors on all three sets; the 29 files naming Pedixplorer on 3.24 367 tests, 0 errors; full
suite (`NOT_CRAN=true`) 109 files, 1,232 tests, 17,353 expectations, 0 failed, 0 errors, 0 skipped, WARN 0 (611 s);
`R CMD build` and `check --as-cran` with 3.24 in front: `drawing.Rmd`'s Pedixplorer chunk built, the example ran,
Status 1 NOTE (R16's), CRAN-mode `PASS 2697`; on the lock the same at the second run (the first also listed a 503 for
a GitHub link); covr: the changed statements run 546 times; lint 0; roxygen unchanged; spelling 0. REFACTOR:
`asPedFrame()`'s output on the 550 Pedixplorer objects the 29 files build `identical()` before and after on 3.23 and
3.24 (and 3.23 against 3.24), the full suite again as above. CI: R-CMD-check run 45946860858: Ubuntu devel (R-devel
r90991, Bioconductor 3.24 alone: BiocGenerics 0.60.0, S4Vectors 0.52.0, Pedixplorer 1.10.0) built the vignettes and
read Status OK, `PASS 17088`, where S98's run stopped; oldrel-1 (R 4.5.3, Bioconductor 3.22: S4Vectors 0.48.1,
Pedixplorer 1.6.0) Status OK, `PASS 17088`; Ubuntu release `17088` and Windows `17087` (both 3.23) Status OK; macOS
failed `test_pedigreeAppBrowser.R:103` at attempt 1 (the click flake, `:236`) and read Status OK at its rerun (`PASS
17099`); pkgdown run 45946860903 success. quality_ratchet 7/7 at `2456253` (results `dd3bb45ce615`).

#### Session 98 Handoff Evaluation (by Session 99)
**Score: 9/10.** ROI high: Orient, the scratch library and the first measurement ran from its notes.
- **What helped:** Mark's pick under "Next"; What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each
  exact); the backlog item's recipe for 3.24 (three sources, BiocGenerics first, the four environment variables),
  which built the library first time; its counts (21 errors: 11, 4, 4, 1, 1 in five named files), reproduced
  exactly; the stop at `R/asPedFrame.R:412`; "measure each fix before the picker" and dragon 42's wrong prototypes;
  every key-file line exact.
- **What was missing:** that 3.22's S4Vectors 0.48.1 does not compile on R 4.6.2 (2 asked to "run both ... and on
  3.22's S4Vectors 0.48.1"; about 10 minutes went to trying R 4.5, which cannot build it here either); that the
  file's header holds R14's rule (written from the help pages, neither package's source read), which shaped the
  fix's measurement.
- **What was wrong:** "NEWS needs a line (a user on Bioconductor 3.24 meets it)": 1.0.0 is the first release and
  `asPedFrame()` new, so no released version stopped (Mark picked no line); the item's "`drawing.Rmd:593`'s chunk ...
  (not run)" read as if the chunk is never run, where it meant S98 did not run it.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every candidate measured on three Bioconductor sets before the picker,
  with the test counts the options quoted; the stand-in test drafted and run on HEAD, the right prototype and 6
  wrong ones before the RED gate; GREEN shown on the surface that failed (the build of `drawing.Rmd` with 3.24),
  plus the full suite, both checks and coverage; the REFACTOR proved by 550 `identical()` outputs on two sets.
- **The 3.22 attempt cost about 10 minutes** (two R 4.5 installs) for a set only CI can build; recorded as dragon 44.
- **Slips caught before commit:** zsh's unsplit variable, warned of in the handoff; a capture by `registerS3method()`
  alone caught 0 calls (the namespace binding wins); a wrong prototype that failed for an unrelated reason
  (IRanges missing), replaced by six that fail on the behaviour.

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
