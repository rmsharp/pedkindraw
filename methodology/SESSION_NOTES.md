# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a is DONE (S33:
win-builder R-devel 398 s, R16's NOTE only; R86: 17k opens with one more reading after 17j). Next: **Phase 17b, the
argument-name review, a decision session** (`docs/planning/cran-submission-plan.md:341`; inventory section 2.4,
`:165`; `methodology/BACKLOG.md:11`): one picker per item of section 2.4, Mark's picks become rulings, the
contract's sections 4 and 6 say what changed, and the plan records each change's inventory. No code changes (17c
makes them, test-first).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17b (recommended: the plan's order, R84); 17d or 17e,
the two drawing fixes (the plan puts them after 17c, since a rename would touch the same files, but they do not
depend on 17b if 17b keeps every name).
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 5 differ, all with rows); nprcgenekeepr's log on every copied file:
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R)` printed exactly 4 commits at S33 (`4283e3502`, `a85311021`, `392dd347e`, `471589138`, all
   already in the copy). Any other line is a change to a copied file: the plan's section 4.4 and R37.
2. Push S33's close-out 2 commit with the session's first push (methodology only: no run starts).
3. 17b, before any picker (Learning 17): re-run section 2.4's `git grep -w` inventory on today's tree (it was taken
   at `ba811e7`; `R/`, `tests/`, `vignettes/` are unchanged since `d00ebda`, so the counts should hold; the picker
   states them as measured). Read why `kinship()` says `fatherId`/`motherId` before offering to change it: ruling C13
   of nprcgenekeepr's clean-room plan (`docs/planning/pedkindraw-api-contract.md:102`, `:146`;
   `docs/planning/standalone-pedigree-package-plan.md:544`). Five items: the parent names (`fatherId`/`motherId`
   against `sire`/`dam`), the pedigree argument's name (`ped`, `pedSourceDf`, `uPed`), the argument order
   (`probands, ped`), exporting `addIdRecords()`, the export names shared with nprcgenekeepr, kinship2 and
   Pedixplorer. `AskUserQuestion` takes 4 questions per call, so 5 items need two calls (or one per item). Each
   change is a divergence from nprcgenekeepr (D2; a `DIVERGENCE.md` row in 17c, and the drift tool lists it).

### Gotchas
- **Read a win-builder reading's busyness before trusting its margin (S33, dragon 8):** the result folder has
  `examples_and_tests/tests/testthat.Rout`, whose `proc.time()` gives the tests' CPU beside their elapsed time.
  S33's 398 s ran its tests at 286.3 s elapsed for 286.4 s CPU (an idle machine); nprcgenekeepr's slow reading ran
  1.54 s elapsed per CPU second. `00check.log` prints a step's time only when it is 10 s or more, and the overall
  "Check time in seconds" is in the email, not in `00check.log`.
- **The win-builder upload, worked (S33):** `curl -sS -T pedkindraw_0.0.1.tar.gz
  ftp://win-builder.r-project.org/R-devel/` (anonymous, 3 s, reply 226); the email came to Mark about 15 minutes
  later, and the check itself took about 6 minutes on win-builder. Mark approves each upload in the session (17k, 17o).
- **The scratch build and check recipe** (S32, worked again in S33): in a new scratch folder, `L=$(Rscript -e
  'cat(renv::paths$library())')` from the repository, then `env -u RENV_PROJECT R_LIBS=$L R_LIBS_USER=$L
  RENV_CONFIG_AUTOLOADER_ENABLED=false R CMD build <repo>` and the same with `R CMD check --as-cran --timings`.
  Prove the tarball's contents: `tar -tzf` against `git ls-files` less `.Rbuildignore`'s patterns (S33: 170 kept,
  less `.Rbuildignore`, plus 7 built files; `.Rhistory` is git-ignored and left out by R CMD build's defaults).
- **This Mac is loaded by other projects:** S33's local check ran at load 10-13 (208 s; S32 181 s at 5-13). Record
  `uptime` beside every timing; compare timings only under similar load.
- **The copied `test_positionMatingUnitForest.R` prints three `message()` lines** into the check's test output
  (`:2078`, `:2178`, `:2530`, mentioning nprcgenekeepr's sessions and issue #166). The check does not flag them;
  noted in the plan's section 2.1 for 17l, not a backlog item.
- **The sire/dam words gate** (`user-facing-sire-dam-words` in `methodology/.quality-gates.json`) reads `R/`,
  `man/`, the README, NEWS and vignettes: any 17b ruling that renames parent arguments must keep to sire, dam,
  mate, mating in user-facing text.
- **Carried:** no English hunspell dictionary on this Mac (the spelling step runs on win-builder, which flagged
  nothing in `DESCRIPTION`); R's own library holds 7 of the 9 Suggests; count copied files by the header's
  capitalized "Copied from nprcgenekeepr" (79); counts taken in nprcgenekeepr go stale within a session (169 at
  `3c87a17a9`, S33); the suite gate's 300 s limit fails under load and counts warnings, not failures (tally "0
  failed" by hand); both workflows run on any push beyond `CLAUDE.md` and `methodology/**`; `CLAUDE.md` is over its
  28,000 B budget (30,795 B; S23-S33 added nothing, learnings go here); `pedkindraw.Rproj` untracked, left for Mark.
- **Times on this Mac:** `R CMD build` 18 s; `R CMD check --as-cran` 181-208 s under load; suite 4.3 min;
  `quality_ratchet.py --run` about 5 min; CI 15-19 min; the site workflow 3 min.

### Key files
- `docs/planning/cran-submission-plan.md:23` (summary), `:59` (2.1, the check time), `:96` (S33's win-builder
  record and the R86 decision), `:165` (2.4, names, the 17b inventory), `:207` (3, the open work), `:234` (4,
  nprcgenekeepr), `:324` (17a, with its Done line), `:341` (17b), `:352` (17c), `:422` (17k, rewritten by R86),
  `:464` (17o), `:493` (7, decisions; D2 at `:498`), `:510` (8, session map), `:538` (9, dragons; dragon 8 at `:554`).
- `docs/planning/standalone-pedigree-package-plan.md:53` (Next), `:202`-`:204` (R84-R86), `:544` (`kinship()`'s
  C13 names), `:862` (Phase 17), `:899` (Done 17a).
- `docs/planning/pedkindraw-api-contract.md:91` (4, interface catalogue), `:102` and `:146` (C13), `:271` (6,
  versioning), `:277` (the review is 17b).
- `methodology/BACKLOG.md:11` (17b), `:18` (speed vignette, 17g-17i), `:33` ("Select by id", 17d), `:43` (legend,
  17e), `:62` (gaps, 17f), `:73` (coverage, 17j), `:120` (the suite gate's limit, 17l).
- win-builder's result `https://win-builder.r-project.org/W1Ko4S0RDs2W/` (removed about 2026-11-20); its logs are
  copied in S33's scratchpad, not in the repository.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S32's entries were removed in S3-S33 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 32 Handoff Evaluation (by Session 33)
**Score: 9/10.**
- **What helped:** every step ran as written. The drift tool and nprcgenekeepr's log gave exactly the expected
  output (91/5/0; the same 4 commits). The push went first. The scratch build recipe worked unchanged. The D1
  facts were ready: the upload page, and devtools' FTP command, which worked as given. The "about 15-30 minutes"
  held (about 15). The rule to upload again near 540 s framed the decision. All 27 line citations in its steps and
  Key files were right at `a4e940e` (each checked by its text).
- **What was missing:** that a win-builder reading can come from an idle machine, and where to see it
  (`examples_and_tests/tests/testthat.Rout`'s `proc.time()`). Without that, 398 s reads as a 142 s margin. Also,
  that a local check of the same tarball gives the ratio the later phases will need. Neither cost a run.
- **What was wrong:** one small thing. Step 3 says the session reads `00check.log` for "Check time in seconds", but
  that line is in the email, not the log.
- **ROI:** high.

### What Session 33 Did
**Deliverable:** Phase 17a, the check time on win-builder R-devel: 398 s, `Status: 1 NOTE` (R16's); ruling R86
(17k decided by one more reading after 17j). A measurement; nothing in `R/`, `tests/`, `man/`, `vignettes/`,
`inst/` or `DESCRIPTION` changed.
**Started:** 2026-11-17 10:22 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 17a: win-builder time
(Recommended)" (orient); "I upload it via FTP (Recommended)" (D1); "Decide after 17j (Recommended)" (the 17k
decision, R86). Each was answered at the first asking.
**Commits:** claim `eaff4a7` (pushed with S32's close-out 2; no run); the record `8a27fcf` (both plans: section
2.1's win-builder table, 17a's Done line, 17k rewritten, the session map, dragon 8, R86, "Done 17a"); close-out 1
`b8ff56b` (ROADMAP, BACKLOG: 17a removed, 17b moved to Up Next), pushed (CI and site runs under Verified);
close-out 2 (these notes, the receipt, the ledger), not pushed.
**Measured:** the tarball from `eaff4a7` (1,382,525 B, SHA-256 `23386dc96ff7...`; package files identical to
`d00ebda`; contents proven against `git ls-files`). On this Mac at load 10-13: `R CMD check --as-cran --timings`
208 s, R16's NOTE only, tests 136 s (124.9 s CPU). Uploaded by FTP at 16:31 UTC. win-builder R-devel r90914
(`W1Ko4S0RDs2W`): 398 s, install 11 s, tests 286 s (286.4 s CPU), vignettes 18 s, R code 16 s, examples 13 s, PDF
manual 13 s; tests FAIL 0, WARN 0, SKIP 9 (the 8 `skip_on_cran()` and one Rblas skip), PASS 5,400. The spelling
step flagged nothing. The ratio to this Mac is 1.9 (2.3 for the tests' CPU), against S32's 3.4-3.8. A busy day
could read about 470-550 s; 17b-17j add a guessed 10-40 s.
**Verified:** drift tool 91, 5 differ, 0 without a row; nprcgenekeepr at `3c87a17a9`, the same 4 commits on the
copied files; every number in the record re-computed from the logs before the commit (`8a27fcf`);
`quality_ratchet.py --run` 5/5 pass, 0 unmeasured, results `5ddbb5b1aeb3` (load 4.6-14.8); site run `44153786342`
`success`; CI `44153786408` 5/5 `success` at the first attempt (20 min).
**Self-assessment: 8/10.**
+ Measured before each picker: the FTP server answered and the upload page returned 200 before D1; the local check
  of the same tarball passed before the upload. Read the tests' CPU against elapsed time instead of taking 398 s at
  face value, and checked what nprcgenekeepr's 284-617 s spread measured (the same tarball: 617 and 520 s) before
  framing the 17k picker. The tarball's contents were proven by machine. All three picks came at the first asking.
- The first replies of the session did not declare the TDD phase at the top, as `CLAUDE.md` requires of every
  response (corrected from the orientation report on). The additions (10-40 s) are a guess, not measured, and the
  record labels them so. The busy-day figure leans on nprcgenekeepr's one slow reading.
**Learnings:** no `CLAUDE.md` row (over its budget). In the plan's dragon 8: read the tests' `proc.time()` before
trusting a margin. In the Gotchas above: the FTP upload, worked; the email carries the check time; proving the
tarball's contents.
**Ledger:** `CHANGELOG.md` S33 entries (the session, push 1, the win-builder upload, push 2).
