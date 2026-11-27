# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17o DONE (S33-S102); the gap
phases G1-G17 DONE (S42-S77). **Phase 17o DONE (S102, R174):** `cran-comments.md`'s 7 marked lines filled from the
runs: win-builder R-devel (r90926), R-release (4.6.2) and R-oldrelease (4.5.3) `Status: 1 NOTE` each, the
new-submission NOTE alone (no misspelled words, no URL), tests `[ FAIL 0 | WARN 0 | SKIP 27 | PASS 2696 ]`, R-devel
207 s; R-hub run 46055056615 `Status: OK` x3; the macOS builder down (502 three times), its line dropped by Mark's
pick. **The tree is frozen since 17n (R172):** a change to any of the 11 shipped paths (runbook section 1) reopens 17n
(about 1.5 h) and needs a new tarball; CRAN then reviews a tarball that is not the tree.
**Next: Phase 17p, Mark's submission** (plan `:1166`; runbook section 8, `docs/planning/cran-submission-runbook.md:134`):
he uploads `pedkindraw_1.0.0.tar.gz` (SHA-256 `abb78758…22dcfe3c`) at <https://cran.r-project.org/submit.html> with
`cran-comments.md` pasted whole, then confirms by the link CRAN emails. **No session uploads.** Mark has not picked
S103's task.
**Status:** no work in progress. The tree is clean but `pedkindraw.Rproj` (Mark's); the tarball at the root is
git-ignored. Pushed through close-out 2 with the skip marker: no CI run since S100's (run 46043167677, 5/5 OK).
**The orient picker:** if Mark has submitted, "(Recommended)" on recording 17p (plan `:1166`: "A session records it in
the ledger"; read any CRAN email he pastes: the confirmation, the incoming pretest's result). If CRAN's pretest
reports a problem, the work returns to the phase that owns it (17p), a strict-TDD session if code. If he has not
submitted, say so and offer to close. The backlog, unchanged by S102 (36 items, `grep -n '^- \[ \]'
methodology/BACKLOG.md`), grouped and named: outside the shipped files READY `:11`, `:159`, `:168`, `:178`, `:193`,
`:246`, `:253`, `:259`, `:273`, `:278`, `:329`, `:348`; changing shipped files (wait for acceptance) `:29`, `:39`,
`:45`, `:55`, `:88`, `:313`, `:199` (Mark's pick; its file a guess); after acceptance `:290`, `:299`; NEEDS DECISION
`:64`, `:72`, `:81`, `:94`, `:221`, `:239`, `:319`, `:339`; "Waiting on Mark" `:122`, `:129`, `:136`, `:148`. Not
offered: `:105` (an nprcgenekeepr session, R101), `:20` and `:116` (BLOCKED on acceptance). Name every item.
**Session boundary:** one session, then close out. 17q (tag, release, `.9000`, README, CRAN's check page) only after
CRAN accepts.
**Priority:** HIGH (17p-17q are the release).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**); nprcgenekeepr's log on the copied files,
   `files=($(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#'));
   git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- "${files[@]}"`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`), nprcgenekeepr at `3e06730c5` (both read twice in S102).
2. If Mark submitted: a ledger entry for 17p (an action, FM #27) with the date, the tarball's SHA-256 and what CRAN
   said; the plan's status line (`:39`), a 17p paragraph under its heading (`:1166`), the standalone plan's Next
   (`:118`), ROADMAP (`:120`). Runbook section 1 first, to state the submitted tarball still matches the tree.
3. Any CRAN reply asking for a change: no edit in the same session that reads it; the fix is its own strict-TDD
   session, then 17n's gate again and a new tarball (runbook section 2).
4. **CI on every push:** five jobs, without renv. Known flakes `:199`, `:221`, `:239` (rerun a failed job once).

### Gotchas
- **`cran-comments.md` is pasted whole into CRAN's comment box (R173):** nothing for the record goes in it; the
  record is the runbook's last section (`:142`; S102's results `:153`) and 17o's paragraph (`:1145`).
- **Do not rebuild the tarball:** a rebuild stamps a new time and a new SHA-256; every check so far used
  `abb78758…22dcfe3c`, and 17p submits it. If it is lost, runbook section 2 says what then.
- **A "nothing changed" diff needs a control that can see a change** (dragon 47, `:1471`): `2456253^` is vacuous;
  `c=$(git log -1 --format=%h -- "${paths[@]}")` and diff from `"$c^"` (S102: `1f0a780`, 1 file).
- **R-hub's job logs:** `gh api --allow-escape-sequences repos/rmsharp/pedkindraw/actions/jobs/<id>/logs | sed -E
  's/\x1b\[[0-9;]*m//g'`; without the flag it prints one refusal line (dragon 47).
- **win-builder's result folders** (`lxX7xipRS4YJ`, `VGDuwIP07s13`, `yiYlDkG2174D`) are removed about 2026-11-30;
  everything they held that 17o needs is in the runbook's record.
- **A push with `.github/` or a root `.md` changed starts both workflows** unless the head commit has the skip
  marker (dragon 12).
- **No README change until CRAN accepts pedkindraw** (Mark, S101; backlog `:299`): the README ships in the tarball.
- **The rulings table's R172 and R173 rows have 2 of its 4 cells** (`docs/planning/standalone-pedigree-package-plan.md`
  `:357`-`:358`; no When or By), found S102 and left as they are; R174 (`:359`) has all 4.
- **Say why before running a check the plan does not list** (S100).
- **Carried:** `"${VAR:?}"` in `rm -rf`; zsh does not split an unquoted variable (use an array); local runs use
  renv's lock (Bioconductor 3.23), CI does not; a Chrome test can error under load, so run the full suite alone;
  backslashes in `Rscript -e` go in a file; the 5-file cap splits commits; `CLAUDE.md` is over its budget (learnings
  go to the cran plan's dragons, now 47); `methodology/HANDOFFS.md` about 248 KB after S102, under the 262,144 B
  size where a default read returns nothing (backlog `:339`): keep the receipt short; the ratchet's run takes about
  12 min.
- **Words:** describe each result by what it measured, never call one "real" (memory, S84).

### Key files
- `cran-comments.md`: S102's filled lines `:30` (the spelling check), `:43` (check times), `:60`-`:66` (win-builder
  x3, R-hub); nprcgenekeepr's paragraph `:9`-`:17`.
- `docs/planning/cran-submission-runbook.md`: header `:12` (already run), section 1 `:28`, section 8 (submission)
  `:134`, the record `:142` (S102's results `:153`, nprcgenekeepr at the fold-in `:164`).
- The CRAN plan `docs/planning/cran-submission-plan.md`: status `:39`; 17o's session-two paragraph `:1145`; 17p
  `:1166`; 17q `:1172`; D9 `:1196`, D10 `:1197`; dragon 47 `:1471`. R174
  `docs/planning/standalone-pedigree-package-plan.md:359`, its Next `:118`. `methodology/ROADMAP.md:120`.

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
**Deliverable:** Phase 17o's second session: the cross-platform results folded into `cran-comments.md` and the plan.
DONE, so 17o DONE (R174).
**Started:** 2026-11-27 14:06 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each the recommended option):**
"Fold in 17o results" (orient); "Drop its line" (the macOS builder). Mark pasted win-builder's three emails as they
came (R-release, R-devel, R-oldrelease) and asked whether Claude had seen the first: no, Claude cannot read his mail.
**Commits:** claim `f243562`; work `1aca927` (`cran-comments.md`); close-out 1 `f06b896` (CRAN plan, runbook,
standalone plan R174, roadmap); close-out 2 (these notes, the receipt, the ledger, dragon 47), pushed after.
**Measured:** the 11 shipped paths unchanged since `2456253` at HEAD and on GitHub (control from `5347bb3`: S99's 3
files); the tarball `abb78758…22dcfe3c`; each win-builder folder's `00check.log` (1 NOTE, the incoming check's
Maintainer line and "New submission" alone; the three logs the same but for timings) and
`examples_and_tests/tests/testthat.Rout` (`SKIP 27 | PASS 2696`, elapsed = CPU); R-hub's three job logs
(`Status: OK`; Ubuntu 26.04.1 and Intel macOS 15.7.9 on r90998, Windows on r90926); the macOS builder 502 at 20:07:45
UTC (`/v1/` 502, form page 200); `NeedsCompilation: no` in the tarball; drift 91 / 23 / 0 and nprcgenekeepr
`3e06730c5` with the same 4 commits at Orient and at 20:10 UTC. quality_ratchet: 7/7 pass · 0 fail · 0 unmeasured · results dd3bb45ce615 · manifest 4127d978ffc1 (at `f06b896`, 20:23 UTC)

#### Session 101 Handoff Evaluation (by Session 102)
**Score: 9/10.** ROI high: Orient, the orient picker and the whole fold-in ran from its notes.
- **What helped:** What You Must Do 1 (91 / 23 / 0, the 4 commits, `3e06730c5`, the zsh array), each exact; 2's
  reading list (runbook section 1 first; the spelling words and dragon 39; dragon 10's URL; `proc.time()` and dragon
  8; R-devel's 540; R-hub through the jobs API; the macOS builder picker with nprcgenekeepr's S1105 precedent); the 7
  marker lines and every plan line (`:39`, `:1111`, `:1116`, `:1146`, `:118`, `:120`) exact at `1ea0d0a`; the orient
  picker's 36 items each at its line; win-builder's queue `curl`, which showed all three checks had started.
- **What was missing:** that `gh api .../jobs/<id>/logs` needs `--allow-escape-sequences` for R-hub's logs (one
  retry); which commit gives runbook section 1 a control that can fail (S101 wrote "a control diff lists changes"
  without naming it; `2456253^` is vacuous, dragon 47).
- **What was wrong:** nothing found.
- **ROI:** high.

**Self-assessment: 9/10.**
+ Orient in full, the claim before any work; each folder read from its files, not from the emails' summaries, and the
  three logs compared by `diff`; R-hub's facts carried from S101's paragraph re-read in its job logs (Learning 8);
  the macOS picker stated the coverage left, the missing setup, `NeedsCompilation: no` and the precedent; every item
  of 17o's DONE list met and recorded; drift and nprcgenekeepr read twice.
- **Slips caught before recording:** the first control (`2456253^`) printed nothing and proved nothing (replaced,
  dragon 47); R-hub's log download printed one refusal line (retried with the flag).
- **Left as found:** the rulings table's R172 and R173 rows have 2 of 4 cells (Gotchas).

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
