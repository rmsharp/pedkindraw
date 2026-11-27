# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17m DONE (S33-S96); the gap
phases G1-G17 DONE (S42-S77); S97-S99's items DONE (R169-R171). **Phase 17n, the full local gate, DONE (S100,
R172):** every item of its list met on the package files as at `2456253` (17n's DONE paragraph,
`docs/planning/cran-submission-plan.md:1062`), Bioconductor 3.24 checked beside the lock's 3.23, the speed page's
times unmoved (A/B of every changed timed cell), and `R/savePedigreeDiagram.R:410`-`:411` (`.closeChrome()`'s kill
and wait, reached only on Windows) recorded as covr's 8th and 9th unrun statements by Mark's pick. **The tree is
frozen:** after 17n only 17o's results and 17q's version move change it; any change to `R/`, `tests/`, `vignettes/`,
`man/`, `inst/` or `DESCRIPTION` reopens 17n (its suite, checks and coverage again, about 1.5 h).
**Next:** Phase 17o, session one (`docs/planning/cran-submission-plan.md:1104`): write `cran-comments.md` (a new
submission; the R CMD check results; the test environments; no reverse dependencies; R16's NOTE explained; marked
lines for the runs' results) and the run list (win-builder R-devel, R-release, R-oldrelease; the macOS builder;
R-hub), then D9 (who runs them: Mark, or Claude with his approval) as a picker. Session two folds in the results.
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's). Pushed `93d7819` (close-out 1,
without the skip marker): R-CMD-check run 46043167677 5/5 Status OK, macOS at its rerun (`:239`'s flake,
two pushes in a row); pkgdown and the site's deployment success. Close-out 2 pushed after it (the skip marker, no
run).
**The orient picker:** "(Recommended)" on 17o (the plan's order; no pick of Mark's names a task before it). The
lock move `:178` no longer has to come first (`renv.lock` is outside the tarball), but it changes every local run
after the freeze: name it on its own. The rest grouped and named (34 items, `grep -n '^- \[ \]'
methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`, `:88`, `:159`, `:168`, `:193`, `:246`, `:253`,
`:259`, `:273`, `:278`, `:290`, `:306`, `:325`; READY by Mark's pick `:199` (the Chrome diagnostic); NEEDS DECISION
`:64`, `:72`, `:81`, `:94`, `:221`, `:239`, `:296`, `:316`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not
offered: `:105` (a session Mark starts in nprcgenekeepr, R101's exception), `:20` and `:116` (BLOCKED). Say that a
code item now reopens 17n. Name every item.
**Session boundary:** one session, then close out.
**Priority:** HIGH (17o-17q are the submission).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`) and nprcgenekeepr at `3e06730c5`, unless Mark has run `:105` or `:246` there (then
   `DIVERGENCE.md` as R101 says, and say whether it touches the frozen tree).
2. **17o** (if picked): read `docs/planning/cran-submission-plan.md:1104` (17o), 17n's DONE paragraph (`:1062`, the
   check results and environments `cran-comments.md` states), section 4.4 (the nprcgenekeepr notes "for the record,
   not for CRAN"), dragons 8, 10, 11 and 34-36 (win-builder's spread and queue; URLs; pkgdown skips
   `cran-comments.md`), and D9 in section 7. `.Rbuildignore` already lists `cran-comments.md` and `CRAN-SUBMISSION`
   (17l). Build the tarball to upload from a `git archive` of the frozen commit (17n's recipe), and give its SHA-256.
   nprcgenekeepr's `cran-comments.md` (3,328 B, in the clone) is a model, but it opens "This is an update from 2.0.0":
   pedkindraw's is a new submission.
3. **CI on every push:** five jobs, without renv (current CRAN; Bioconductor by pak). Known flakes: `:199` (a hung
   Chrome start), `:221` (a blank PDF), `:239` (the app's click, macOS). Rerun a failed job once (`gh run rerun <run>
   --job <id>`, after the run ends), list the rerun's jobs by attempt (`gh api
   repos/rmsharp/pedkindraw/actions/runs/<run>/attempts/2/jobs`), read logs through the jobs API; watch with a
   Monitor loop on `gh run view <run> --json status,conclusion,jobs` (45 s).
4. A code session runs TDD: declare the phase; each transition one `AskUserQuestion` (CLAUDE.md "Phase-gate format").

### Gotchas
- **Say why before running a check the plan does not list** (S100: Mark asked "Why are we testing on bioconductor?"
  mid-run). The 3.24 check's reason: Pedixplorer is a Bioconductor package in Suggests; CRAN's R 4.6 machines
  install Bioconductor's current release (3.24), the lock has 3.23, and no CI job pairs R 4.6 with 3.24.
- **The depends-only check needs a scratch R home** (dragons 6 and 45): inside renv `.Library` is renv's sandbox (29
  packages), while R's own library holds 257. Recipe (S100): symlinks to `R.home()`'s entries but `bin` and
  `library`; `bin/` links but a copy of `bin/R` with `R_HOME_DIR` set to the scratch home; `library/` links to the 29
  standard packages; run `<home>/bin/R CMD check` with `RHOME=<home>` (or a check's `Rscript` children start R's own
  home), `_R_CHECK_DEPENDS_ONLY_=true`, `R_LIBS`/`R_LIBS_USER` renv's library, `RENV_PROJECT` unset.
- **Local runs use renv's lock (Bioconductor 3.23); CI does not.** The 3.24 check (17n's DONE paragraph): the three
  tarballs from `https://bioconductor.org/packages/3.24/bioc/src/contrib/`, MD5 against its `PACKAGES`, `R CMD
  INSTALL -l <lib>` BiocGenerics first, then Rscript from the project's folder with `R_LIBS`/`R_LIBS_USER`
  `<lib>:<renv library>`, `RENV_CONFIG_AUTOLOADER_ENABLED=false`, `RENV_PROJECT` unset. About 10 minutes in all.
- **The timing harness's `timeOne.R` and `drawOne.R` time one cell of any build** (`PKD_LIB=<lib> Rscript
  tools/timing/timeOne.R <case> <pedigree>`); `runTiming.R`/`runDrawingTiming.R` refuse a build that is not the
  checked-out commit. S100's A/B script is in its scratchpad (gone with it); the timing plan's amendments say how.
- **covr's `tally_coverage(by = "expression")` has no `line` column** (`first_line`); `as.data.frame()` of a coverage
  object needs covr's namespace loaded.
- **R CMD check's URL check can read a transient 503 from GitHub** (S99): rerun before calling the NOTE new.
- **chromote prints "[warning] got non-close frame while closing"** after a Chrome test; testthat counts no warning.
- **Carried:** write `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (use an array); a calling
  handler set outside `try()` never runs; the README render needs a scratch install; the skip marker (a push whose
  head commit holds it runs no workflow); a Chrome test can error under load, so run the full suite alone; CRAN's
  DESCRIPTION spell check reads `.aspell/` (dragon 39); a CRAN check runs only 21 test files (list a new test file in
  `tests/testthat/slowTestFiles.txt`); Rscript inside `tests/testthat/` loads no renv; backslashes in `Rscript -e`
  go in a file; the 5-file cap splits commits; never commit `tests/testthat/_problems/`; `CLAUDE.md` is over its
  budget (learnings go to the cran plan's dragons, now 45); `methodology/HANDOFFS.md` 245,081 B after S100,
  about 17 KB under the 262,144 B size where a default read returns nothing (backlog `:316`): keep the
  receipt short; the full suite takes about 10 min, the ratchet's run about 12, covr about 13.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- S100 (DONE): 17n's DONE paragraph `docs/planning/cran-submission-plan.md:1062`; dragon 45 `:1403`; the timing
  plan's 17n list `docs/planning/pedkindraw-timing-plan.md:687`; R172
  `docs/planning/standalone-pedigree-package-plan.md:357`; the two Windows-only lines `R/savePedigreeDiagram.R:410`
  (in `.closeChrome()`, `:401`), their test `tests/testthat/test_savePedigreeDiagram.R:627`.
- 17o: `docs/planning/cran-submission-plan.md:1104`; D9 in section 7; dragon 11 `:1214` (pkgdown and
  `cran-comments.md`); `.Rbuildignore`.
- `:178`, the lock move: `methodology/BACKLOG.md:178`; `renv.lock` (its `Bioconductor` block, 3.23);
  `renv/settings.json` (`bioconductor.version: null`).

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
**Deliverable:** Phase 17n, the full local gate. DONE (R172): every item of its list met; the tree is frozen.
**Started:** 2026-11-27 10:23 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"17n: full local gate (Recommended)" (orient); "Record them; 17n done (Recommended)" (coverage). Mark asked mid-run
"Why are we testing on bioconductor?"; answered (Gotchas, first item), the run kept.
**Commits:** claim `fa799c5`; close-out 1 `93d7819` (pushed without the skip marker: R-CMD-check run 46043167677,
pkgdown run 46043167481); close-out 2 (these notes, the receipt, the ledger), pushed after.
**Measured (all on a `git archive` of `fa799c5`, the package files as at `2456253`):** `R CMD check --as-cran`
Status 1 NOTE (R16's), CRAN-mode `[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2697 ]` 27.9 s, the check 93 s, tarball SHA-256
`abb78758…22dcfe3c`; depends-only under a scratch R home, CRAN mode Status 1 NOTE (`SKIP 58`, `PASS 1343`) and
`NOT_CRAN=true` Status 1 NOTE (`SKIP 225`, `PASS 11807`); suite (`NOT_CRAN=true`) 109 files, 1,232 tests, 17,353
expectations, 0 failed, 0 errors, 0 skipped, WARN 0, 603 s; lint 0; roxygen unchanged; covr 9 of 3,802 never run
(17j's 7, now `R/makePedigreeDiagramData.R:821`, `:1241`, `:1548`, `:1600`, `:3014`, `R/orderRootSubtrees.R:118`,
`:131`; and `R/savePedigreeDiagram.R:410`-`:411`); drift 91 / 23 / 0 and nprcgenekeepr's 4 commits at Orient and
end; fidelity 600 of 600, kinship difference 0; Bioconductor 3.24 (scratch library): 29 Pedixplorer test files 367
tests 0 failed, `R CMD build` ran `drawing.Rmd`'s Pedixplorer chunk, check Status 1 NOTE, `PASS 2697`; the speed
page: 18 files changed since `14145a4`, sorted by parsing (12 help only, 2 code outside timed calls, 3 in timed
calls), the changed timed cells A/B at `7f13d98` and HEAD -2.6% to +3.0% for cells of 0.3 s or more, inside their
runs' spread, millisecond cells within 1 ms. Load average 2.0-14.8 across the runs. quality_ratchet 7/7 at `93d7819` (results `dd3bb45ce615`).
**CI:** R-CMD-check run 46043167677: Ubuntu release (Bioconductor 3.23) `PASS 17088`, Ubuntu devel (3.24) `17088`,
Ubuntu oldrel-1 (3.22) `17088`, Windows `17087`, each Status OK; macOS failed `test_pedigreeAppBrowser.R:103` at
attempt 1 (the click flake, `:239`) and read Status OK at its rerun (`PASS 17099`); pkgdown run 46043167481 and the
site's deployment 46043477801 success.

#### Session 99 Handoff Evaluation (by Session 100)
**Score: 9/10.** ROI high: Orient, the orient picker and the gate's plan ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); the orient picker's 34
  items, each at its stated line, and the "(Recommended)" on 17n; "read `:1052` in full first, and dragons 43 and
  44" (both lines exact); the 3.24 check named as the one thing 17n's list lacks; the gotcha on starting a scratch
  Rscript (`RENV_CONFIG_AUTOLOADER_ENABLED=false`, `RENV_PROJECT` unset), which worked first time; "the
  check without suggested packages needs a scratch R home".
- **What was missing:** where the scratch R home's recipe is (the cran plan's `:1001` gives it in one clause; the
  steps are in nprcgenekeepr's plan, its Phase 4); that `17h2's commit` is `14145a4` (found in the timing plan); why
  the 3.24 check runs, in words Mark could read (he asked).
- **What was wrong:** "BACKLOG `:178`'s recipe": S99's close-out 1 replaced that item, so `:178` holds no recipe; it
  was in `git show 2456253^:methodology/BACKLOG.md`, found in a minute.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; every 17n item measured, each run alone where Chrome or timing was
  involved; renv's sandbox caught before it made the depends-only check unfaithful, and `RHOME` added to the recipe
  (dragon 45); the speed page's "can a time change" answered by an A/B of every changed timed cell, not by reading;
  the coverage gap put to Mark with what was measured and what only inferred.
- **The 3.24 check ran without a word on why** until Mark asked; a gotcha now says to state it first.
- **Slips caught before commit:** covr's summary used a column that does not exist (the saved object listed the 9);
  the plan's first draft said load 2.0-8.8 for all runs (covr ended at 14.8) and left out `DESCRIPTION`'s changes.

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
