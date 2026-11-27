# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17n DONE (S33-S100); the gap
phases G1-G17 DONE (S42-S77). **The tree is frozen since 17n (R172):** a change to any path the tarball ships
(`docs/planning/cran-submission-runbook.md` section 1 lists the 11) reopens 17n (about 1.5 h) and needs a new
tarball. **Phase 17o's first session DONE (S101, R173):** `cran-comments.md` (a new submission; nprcgenekeepr named
up front; 7 lines "to be run before submission", one per line), the run list `docs/planning/cran-submission-runbook.md`
(the record, R173, is there, not in `cran-comments.md`), `.github/workflows/rhub.yaml` (R-hub's file, renv off), and
the runs started by Claude on Mark's D9 pick: win-builder R-devel, R-release and R-oldrelease by FTP at
19:11:52-19:12:05 UTC 2026-11-27 (reply 226 each; R-devel's queue held 2 before it); R-hub run 46055056615
(linux, windows, macos on `1d04ba0`): `Status: OK` on all three (linux and macos `[ FAIL 0 | WARN 0 | SKIP 26 |
PASS 2697 ]`, windows `SKIP 27 | PASS 2696`), renv off in each; the macOS builder answered 502 to both uploads
(19:12:25 and 19:58:51 UTC): not started.
**Next:** Phase 17o's second session, the results folded in (runbook section 7; plan 17o's DONE list,
`docs/planning/cran-submission-plan.md:1111`). It needs Mark's three win-builder emails, pasted or forwarded: each
holds its result folder's link, which win-builder removes about 72 hours after the check (by about 2026-11-30).
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's); `pedkindraw_1.0.0.tar.gz` at
the root is git-ignored (17n's checked tarball, SHA-256 `abb78758…22dcfe3c`). Pushed through close-out 2 with the
skip marker each time: no R-CMD-check or pkgdown run since S100's (run 46043167677, 5/5 Status OK).
**The orient picker:** "(Recommended)" on "fold in the 17o results" when Mark has the emails (no other task of his
comes first: 17p, the submission, waits on it). If no email has come, say so and offer to wait (close). The rest
grouped and named (36 items, `grep -n '^- \[ \]' methodology/BACKLOG.md`): READY `:11`, `:29`, `:39`, `:45`, `:55`,
`:88`, `:159`, `:168`, `:178` (the lock move, outside the tarball), `:193`, `:246`, `:253`, `:259`, `:273`, `:278`,
`:313`, `:329`, `:348`; READY by Mark's pick `:199`; READY after the release `:290` (the R-hub guard) and `:299`
(README badges: Mark, S101, "hold off" until CRAN accepts); NEEDS DECISION `:64`, `:72`, `:81`, `:94`, `:221`, `:239`,
`:319`, `:339`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not offered: `:105` (an nprcgenekeepr session,
R101), `:20` and `:116` (BLOCKED). A code item reopens 17n and the uploads already made. Name every item.
**Session boundary:** one session, then close out. **HARD STOP before 17p** (Mark submits).
**Priority:** HIGH (17o-17q are the submission).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`), nprcgenekeepr at `3e06730c5`. Both are 17o's DONE items: record them in its paragraph.
2. **Fold in** (runbook sections 6-7). Runbook section 1 first (the shipped paths unchanged since `2456253`; use an
   array in zsh). For each win-builder email: open its link; read `00check.log`, the NOTE's text (spelling words IBD,
   Schaid, Sinnwell, Therneau mean CRAN did not read `.aspell/`, dragon 39; a URL, dragon 10) and
   `examples_and_tests/tests/testthat.Rout`'s `proc.time()` (elapsed against CPU, dragon 8); R-devel's "Check time in
   seconds" (540 or less, R85; 17k read 321). R-hub: `gh run view 46055056615 --json jobs`, each job's log through the
   jobs API (`Status:`, the tests' line). The macOS builder (not started: 502 twice at S101): runbook section 4 again;
   if it still answers 502, a picker: drop its line (nprcgenekeepr's S1105 precedent) or keep trying. R-hub's results
   are already in 17o's paragraph (`:1116`): copy them into `cran-comments.md:63`. Fill the 7 lines (`grep -c 'to be
   run before submission' cran-comments.md` prints 0), keep every marker's replacement on its own lines, correct the
   NOTE list to what win-builder printed; 17o's DONE paragraph (after S101's, `:1116`, before 17p's heading `:1146`),
   the status line (`:39`), the standalone plan's Next (`:118`), ROADMAP (`:120`).
3. Any ERROR, WARNING or other NOTE: stop, no submission; a fix is a strict-TDD session that reopens 17n.
4. **CI on every push:** five jobs, without renv. Known flakes `:199`, `:221`, `:239` (rerun a failed job once, `gh
   run rerun <run> --job <id>` after the run ends; list the rerun's jobs by attempt through the jobs API).

### Gotchas
- **`cran-comments.md` is pasted whole into CRAN's comment box (R173):** nothing for the record goes in it; the
  record is the runbook's last section and 17o's paragraph.
- **Do not rebuild the tarball:** a rebuild stamps a new time and a new SHA-256; every upload so far, and 17p, use
  `pedkindraw_1.0.0.tar.gz` (`abb78758…22dcfe3c`). If it is lost, the runbook's section 2 says what then.
- **win-builder gives no receipt:** never upload again because no email has come (runbook section 3); `curl -sS
  ftp://win-builder.r-project.org/R-devel/` lists what still waits (UTC+1).
- **R-hub runs in CRAN mode:** R-hub's `setup-r` sets `NOT_CRAN` false, so 21 test files; its check step
  (`check-r-package`) turns the incoming check off, so `Status: OK`, not R16's NOTE (read S101 in r-hub/actions and
  r-lib/actions).
- **A guard that greps workflow text cannot see inside a composite action** (dragon 46; backlog `:290`, after the
  release).
- **A push with `.github/` or a root `.md` changed starts both workflows** unless the head commit has the skip
  marker (dragon 12); pkgdown's current source skips `cran-comments.md` (its `no_render` list), as dragon 11 says.
- **No README change until CRAN accepts pedkindraw** (Mark, S101; backlog `:299`): the README ships in the tarball.
- **R-hub's Intel macOS job takes about 45 min** (pak builds 116 of 119 packages from source); Linux and Windows
  about 4. The macOS builder answered 502 all through S101 (19:12-19:59 UTC), its form page 200.
- **Say why before running a check the plan does not list** (S100).
- **Carried:** `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (S101 got a vacuous empty `git
  diff` from it); the depends-only check's scratch R home needs `RHOME` (dragon 45); local runs use renv's lock
  (Bioconductor 3.23), CI does not; a Chrome test can error under load, so run the full suite alone; backslashes in
  `Rscript -e` go in a file; the 5-file cap splits commits; `CLAUDE.md` is over its budget (learnings go to the cran
  plan's dragons, now 46); `methodology/HANDOFFS.md` 246,687 B after S101, under the 262,144 B size where a default
  read returns nothing (backlog `:339`): keep the receipt short; the ratchet's run takes about 12 min.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- `cran-comments.md`: the 7 markers `:31` (win-builder's spelling step), `:42` (the R-devel check time), `:58`-`:61`
  (win-builder x3, the macOS builder), `:63` (R-hub); nprcgenekeepr's paragraph `:9`-`:17`.
- `docs/planning/cran-submission-runbook.md`: sections 1-8 and the record (the tarball's proof; nprcgenekeepr's state).
- `.github/workflows/rhub.yaml:68`, `:96` (renv off; header `:1`-`:9`).
- The CRAN plan: 17o `docs/planning/cran-submission-plan.md:1105`, its DONE list `:1111`, S101's paragraph `:1116`;
  section 4.4 `:381`; D9 `:1176`; D10 `:1177` (points to backlog `:299`); dragon 46 `:1441`. R173
  `docs/planning/standalone-pedigree-package-plan.md:358`. Backlog `:290` (R-hub guard), `:299` (README badges).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 102 Did
**Deliverable:** Phase 17o, session two (`docs/planning/cran-submission-plan.md` section 17o; runbook sections 6-7):
the cross-platform results folded into `cran-comments.md` and the plan (IN PROGRESS)
**Started:** 2026-11-27 14:06 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Fold in 17o results
(Recommended)" (orient). Mark pasted win-builder's R-release email (folder `VGDuwIP07s13`, 1 NOTE, 219 s).
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### What Session 101 Did
**Deliverable:** Phase 17o's first session: `cran-comments.md`, the run list, R-hub's workflow, and D9. DONE
(R173); the runs started by Claude on Mark's D9 pick (the macOS builder answered 502 and has not run).
**Started:** 2026-11-27 12:51 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"17o: CRAN notes and run list" (orient); "Say it up front", "In the runbook and plan", "Add the file, renv off"
(framing); "Claude starts them now" (D9). **Mark's requests:** a backlog item to copy nprcgenekeepr's README badges
that fit (`:299`), then "hold off making changes until after acceptance by CRAN" added to it. He asked whether R-hub's
macOS job taking about 10 times as long was unusual: answered from the logs (Intel macOS builds 116 of 119 packages
from source; nprcgenekeepr's macOS job was its slowest too, 34 min).
**Commits:** claim `47c5f86`; work `1d04ba0` (pushed mid-session, the skip marker, so R-hub's workflow was on GitHub;
no CI run); close-out 1 (plans, runbook, roadmap, backlog); close-out 2 (these notes, the receipt, the ledger),
pushed after.
**Measured:** 17n's tarball (`abb78758…22dcfe3c`) against HEAD: the 276 tracked files the build keeps all in it, 275
byte-identical, `DESCRIPTION` equal field by field, plus 10 built; the 11 shipped paths unchanged since `2456253` (a
control diff lists changes); 22 of the 38 exports share nprcgenekeepr's names (both `NAMESPACE`s); the CI guard
flags 0 jobs in R-hub's published file (its `setup-deps` calls r-lib's `setup-r-dependencies`); pkgdown's source
skips `cran-comments.md`; the macOS builder's form offers R-devel only. **Runs:** win-builder x3 by FTP, reply 226,
19:11:52-19:12:05 UTC; R-hub run 46055056615 `Status: OK` x3, renv off in each (the install step's no-renv branch);
the macOS builder 502 at 19:12:25 and 19:58:51 UTC. quality_ratchet 7/7 at `1d04ba0` (results `dd3bb45ce615`), 11
min, load 2.0-11.1.

#### Session 100 Handoff Evaluation (by Session 101)
**Score: 9/10.** ROI high: Orient, the orient picker and 17o's reading ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, each exact); the orient picker's 34
  items, each at its line; 2's reading list: 17o `:1104`, 17n's DONE paragraph `:1062` (the results
  `cran-comments.md` states), section 4.4, dragons 8, 10, 11 and 34-36 (34's queue warning made D9's "start them
  now" the recommendation), D9; nprcgenekeepr's `cran-comments.md` with "an update, not new"; "build the tarball from
  a `git archive`" pointed at 17n's recipe, and so at 17n's own tarball, still in S100's scratchpad.
- **What was missing:** that pedkindraw has no R-hub workflow and that R-hub's install step would start renv (S98's
  failure), found by reading R-hub's actions; nprcgenekeepr's Phase 8 runbook
  (`docs/planning/cran-3.0.0-phase8-runbook.md`), the closest model for the run list; that section 4.4's "for the
  record (not for CRAN)" conflicts with sending the whole file to CRAN (R173's second ruling).
- **What was wrong:** nothing found; every cited line was exact at `e2c63e4`.
- **ROI:** high.

**Self-assessment: 8/10.**
+ Orient in full, the claim before any work; a framing picker before filling, its options stating measured facts
  (22 shared exports, the guard's 0, the tarball proved by machine); R-hub's renv trap found by reading the actions at
  their pinned refs before any run, and R-hub's run then showed renv off in all three jobs; the runs started early
  (dragon 34) on Mark's D9 pick, each recorded with its time and reply.
- **Slips caught before commit:** the 3.24 line first said "the same tarball" (17n built that one separately); two
  markers wrapped across lines (`grep -c` read 6 of 7); a zsh unsplit variable gave an empty `git diff` that proved
  nothing (redone with an array and a control); dragon 46 first gave an inferred count, and "would start renv" read
  as measured (reworded as read).
- **Not reached:** the macOS builder (502 throughout).

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
