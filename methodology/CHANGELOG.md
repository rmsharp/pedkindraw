# Changelog — Authoritative Action Ledger

The cumulative, append-only record of **actions taken** in this repository — across backlog
items, repository issues, and ad-hoc work. It is the authoritative answer to *"what was done
here, ever?"* Every session records its actions here at close-out (`SESSION_RUNNER.md`
Phase 3F); Phase 0 reconciles it against `git log` and backfills anything a crashed or
out-of-band session missed. Taking an action — any commit, or any non-commit action — and
not recording it is failure mode #27. Old entries may be archived, never deleted.

**The rules** — how to add an entry, source tags, reading and archiving — are in
`FRAMEWORK_APPARATUS.md` §The Action Ledger, which `bin/sync`
keeps current. ledger-format: 2 — keep this marker; `bin/status` reads it.

---

<!-- Entries go below, newest on top. Delete the seed-sentinel line near the top when you add the first one. -->

### 2026-11-11 · [ad hoc] S7 push: `master` to GitHub once at `c71b74a` (29 commits, S3's close-out through S7's REFACTOR), CI green on five jobs after re-running the three Ubuntu jobs
- **Change:** `git push origin master` (`b332309..c71b74a`); CI run `43052891573` attempt 1 failed on all three Ubuntu jobs while installing R (the Ubuntu 26.04 runners could not resolve Ubuntu's package servers; no check ran), macOS and Windows `Status: OK`; `gh run rerun 43052891573 --failed`, attempt 2: 5/5 `Status: OK`, `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 347 ]` each.
- **Commit/PR:** none (push and CI re-run); the close-out commits after it are not pushed
- **Session:** S7 · **Verified:** `gh run view 43052891573` conclusion success, attempt 2; each job's `Status: OK` line read from its log.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] S7 DONE: plan Phase 6b, the 11 functions that repair and trim pedigrees and the constant sexCodes copied test-first
- **Change:** from nprcgenekeepr `baef1e12c`, code unchanged: `addParents`, `correctParentSex`, `removeUnknownAnimals`, `hasBothParents`, `getIdsWithOneParent`, `addBackSecondParents`, `removeUninformativeFounders`, `trimPedigree` (exported), `addIdRecords` (not exported, contract section 4.1), `isAddedRecord`, `rbindFill` and the constant `sexCodes` (internal), with help text rewritten (R21); 9 test files, 47 tests; fixtures `pedSix`, `qcPed`; `Imports: data.table`; the results tool's `runCases()` gets the 12 (22 cases, with made-up variants that reach the branches the Phase 1 pedigrees do not). Mark's picks recorded as rulings: R24 (the 10 tests of nprcgenekeepr-only functions left out and listed), R25 (`sexCodes` copied with its value test only). REFACTOR: `R/getProbandPedigree.R` inherits `ped` from `trimPedigree()` again (help page byte-identical). Close-out: the plan (status block, R24-R25, 6b row, Done 6b), `methodology/ROADMAP.md`, `methodology/BACKLOG.md` (6b removed; Phase 7 next; the drift tool misses constants), `CLAUDE.md` Learning 9 (list what copied code reads, not only what it calls).
- **Commit/PR:** `38cf048` (claim), RED `52c6eb6`, `0d675f1`, `4ac1889`, GREEN `5fedd14`, `e312c29`, `59e9778`, `5cc50f0`, `f0b4a66`, `a9257b1`, `d8ef65e`, REFACTOR `c71b74a`, close-out `3da6981`, close-out 2
- **Session:** S7 · **Verified:** tests PASS 347 (99 tests); lint 0; roxygen unchanged; `R CMD check --as-cran` 1 NOTE, the allowed one; results tool 264 of 264 `identical()`; drift tool 21 same; coverage 99.05%; CI run `43052891573` 5/5 `Status: OK`; `quality_ratchet: 2/2 pass`.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] S7 claim (in progress): plan Phase 6b, copy the 11 functions that repair and trim pedigrees, tests first. Mark picked "Start Phase 6b" at the orient picker. Phase 0 reconcile: nothing to backfill (frontier `6501ef7` is HEAD; S6's receipt complete, its gate citation matches the results file).

### 2026-11-11 · [ad hoc] S6 DONE: plan step H2, the copied plan and contract brought up to date, the roadmap filled and the backlog opened
- **Change:** the plan (`docs/planning/standalone-pedigree-package-plan.md`): status block, §1.3, rulings R16-R23 (Mark's S2-S4 picks, each with session and source; Mark confirmed all eight by picker), Phase 5 and 6a Done records, Phase 6 split into 6a/6b rows, C2 written into Phases 7, 8 and 10, §5's drift tool. The contract: §5, §9 rows 5/7/8/10, §10 item 2 closed by C2, and `kinship()`'s `fatherId`/`motherId` (C13) with the clean-room differences. `methodology/ROADMAP.md` filled; `methodology/BACKLOG.md` created (10 items); the pre-repository pointer entry below. Close-out: the hand-over plan marks H2 DONE (the move is complete); `CLAUDE.md` Learning 8 (re-check a carried fact in its primary source). Not pushed.
- **Commit/PR:** `ccd6e6c` (claim), `abb8548`, `86b4126`, `96f9e4b`, `9dc150f` (close-out 1), close-out 2
- **Session:** S6 · **Verified:** `docs/research` unchanged since H1; `R CMD check --as-cran` 1 NOTE, the allowed one; tests PASS 122; tarball 0 `docs/` entries; `quality_ratchet: 2/2 pass`; dashboard runs.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] Backfilled (pointer): pedkindraw's history before this repository existed, in nprcgenekeepr S667-S1150
- **Change:** none here; a pointer. The work that led to pedkindraw ran in nprcgenekeepr's sessions: S667 (the split scoping study), S741 (the kinship2 gap analysis), S742 (Mark's rulings R1-R3: the package will be built), S1117 (Mark lifted the delay), S1121 (the plan), S1122-S1125 (the comparison, plan Phases 1-2), S1126 (input style, R7), S1128 (the contract, name and repository, R10-R13, plan Phase 4), S1129 (nprcgenekeepr's license scoping), S1130 (the clean-room plan and C2), S1140 (the clean-room rewrite finished), S1149 (pedkindraw's license, R14), S1150 (R15; the empty repository cloned). Their records: nprcgenekeepr's `methodology/CHANGELOG.md` and `methodology/HANDOFFS.md`, and its `methodology/archive/` for S667-S742. The plan's status block and section 2 summarize them.
- **Commit/PR:** nprcgenekeepr's commits; none here
- **Session:** S6 (hand-over plan step H2) · **Verified:** each session found in nprcgenekeepr at `3d262d628` (its `CHANGELOG.md`, its `HANDOFFS.md` or `git grep` in its `methodology/archive/`); S1127 in the hand-over plan's range was nprcgenekeepr's own CRAN check, not pedkindraw work, so it is left out.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] S6 claim (in progress): plan step H2, bring the copied plan and contract up to date, fill `methodology/ROADMAP.md`, create `methodology/BACKLOG.md`, add the pre-repository pointer entry. Mark picked "Do step H2" at the orient picker. Phase 0 reconcile: nothing to backfill.

### 2026-11-11 · [ad hoc] S5 DONE: plan step H1, the five planning documents copied from nprcgenekeepr and this repository pointed at them
- **Change:** `docs/planning/standalone-pedigree-package-plan.md`, `docs/planning/pedkindraw-api-contract.md` and the three studies in `docs/research/` copied byte for byte from nprcgenekeepr `3d262d628` (2,228 lines), each with a provenance note under its title (copied unchanged; the plan and contract are now the live copies, the studies dated records not edited; paths name nprcgenekeepr's files except the five; the line shift each note adds). `CLAUDE.md` governing documents and plan-constraints line, `DIVERGENCE.md:4` and the two tools' header comments point at the copies. Close-out: the hand-over plan marks H1 DONE and three of its H2 citations are corrected; `CLAUDE.md` Learning 7 (citations go stale through later edits). Mark's pick: "H1 only". Not pushed.
- **Commit/PR:** `b8b72f7` (claim), `f2249d0`, `ec910a6`, `38633f1`, `3e192e9`, close-out
- **Session:** S5 · **Verified:** `cmp` silent for all five; after the notes, `diff` shows added lines only; drift tool exit 0 (10 same); results tool exit 0 (120 of 120 identical); tests PASS 122; `R CMD check --as-cran` 1 NOTE, the allowed one; tarball 0 `/docs/` entries; `quality_ratchet: 2/2 pass`.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] S5 claim (in progress): plan step H1, copy the five planning documents from nprcgenekeepr `3d262d628` and point this repository at them. Mark picked "H1 only" at the orient picker. Phase 0 reconcile: nothing to backfill.

### 2026-11-11 · [ad hoc] S4 commit in nprcgenekeepr: the hand-over note (plan step H0b), `3d262d628`, not pushed
- **Change:** nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md` status block records Phase 5 DONE (S1-S2) and Phase 6a DONE (S3) and freezes that copy ("not updated here again"); its `BACKLOG.md` item shrinks from 24 lines to 11, tagged RECURRING: the drift watch (plan section 5) is the one duty left there; its own `methodology/CHANGELOG.md` entry (760 B) records it and says the later items moved up 13 lines.
- **Commit/PR:** nprcgenekeepr `3d262d628`
- **Session:** S4 · **Verified:** nprcgenekeepr idle (S1153 closed at `71217b296`, clean tree); its readers `test_docsAuditLooseEnds.R`, `test_docsAuditSixRulings.R`, `test_archivePointersResolve.R`, `test_contextBudgetLedgers.R`, `test_handoffsReceiptPlacement.R`: 37 blocks, 0 failed; `tools/changelog_entry_limit.py` 0 over; its context-budget pre-commit hook passed.
- **Model:** Claude Opus 5.5

### 2026-11-11 · [ad hoc] S4 DONE: plan to move pedkindraw's planning from nprcgenekeepr into this repository; step H0 done
- **Change:** `docs/planning/planning-handover-plan.md`: Mark's direction; pedkindraw's repository carries its own plan from now on, nprcgenekeepr's copies frozen; five documents copied at the same paths (plan, contract, comparison study, gap analysis, split scoping study; 2,228 lines), tools and history left in nprcgenekeepr; an inventory by search (33 files) and by citation; steps H1 (copy and re-point) and H2 (bring up to date, `methodology/ROADMAP.md`, a new `methodology/BACKLOG.md`), each with DONE, surface and session boundary, before Phase 6b. `^docs$` in `.Rbuildignore`. `CLAUDE.md` Learning 6 (search by citation, not only by name). Mark's picks: plan, then note; `BACKLOG.md`; five documents.
- **Commit/PR:** `a262439` (claim), `0283214` (plan, `.Rbuildignore`), close-out
- **Session:** S4 · **Verified:** `R CMD build` leaves `docs/` out, file list identical to S3's checked tarball; H1's copy and `cmp` commands dry-run, five files byte-identical at nprcgenekeepr `3d262d628`; `quality_ratchet: 2/2 pass`.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S4 claim (in progress): plan moving pedkindraw's planning from nprcgenekeepr into this repository (`docs/planning/`), then the hand-over note in nprcgenekeepr. Mark picked "Plan, then note" at the orient picker. Phase 0 reconcile: nothing to backfill.

### 2026-11-10 · [ad hoc] S3 hand-off changed by Mark's direction: the next session plans moving pedkindraw's planning from nprcgenekeepr into this repository; Phase 6b follows
- **Change:** Mark, after the close-out: "next session make a plan to copy information held within nprcgenekeepr into this repository into standard methodology ledgers and other files. Update nprcgenekeepr that this repository will work going forward following the original plan but updating it if needed." Recorded as the ACTIVE TASK in `methodology/SESSION_NOTES.md` (Phase 6b moved below it) and in the S3 receipt's `next_steps`. Nothing written in nprcgenekeepr: its session S1153 was in progress.
- **Commit/PR:** this commit
- **Session:** S3 · **Verified:** S3 read the plan for a hand-over point and found none (§1.3, Phase 17, §5).
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S3 push: `master` to GitHub at `b332309` (carrying S2's `618b8a6` and close-out), CI green on five jobs
- **Change:** pushed `32d525c..b332309`. R-CMD-check run `42960032938`: macOS release, Windows release, Linux devel, release and oldrel-1 all `Status: OK`, each `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 122 ]`. Notices only: Node 20 deprecated under `actions/checkout@v4`; `ubuntu-latest` moving to Ubuntu 26. The S3 close-out commit is not pushed; Phase 6b's push carries it.
- **Commit/PR:** push of `618b8a6`..`b332309`
- **Session:** S3 · **Verified:** `gh run view 42960032938 --log | grep 'Status: '` gave 5 × `Status: OK`.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S3 DONE: Phase 6a, the 10 relationship functions copied test-first (nprcgenekeepr plan Phase 6, first half)
- **Change:** Mark split Phase 6 (picker): 6a = `findGeneration`, `findPedigreeNumber`, `getParents`, `getOffspring`, `getFounders`, `isFounder`, `getProbandPedigree`, `getDescendantPedigree` (exported) and `isEmpty`, `walkPedigree` (internal), all copied from nprcgenekeepr `baef1e12c`; 6b (11 repair and trim functions) next. `toCharacter` stays out; sample pedigrees are test fixtures, not package datasets (both Mark's picks). RED: fixtures `lacy1989Ped`, `smallPed` (`tools/makeTestFixtures.R`), 10 test files (48 tests; `stringi` replaced by base R with identical values; `mockery` in Suggests). GREEN: the 10 R files with code unchanged and help text rewritten (examples type their own pedigree); `NAMESPACE` and 8 help pages; `tools/compareWithNprcgenekeepr.R` (drift), `tools/compareResultsWithNprcgenekeepr.R` (results), `DIVERGENCE.md` (no rows). REFACTOR: no changes. Close-out: `CLAUDE.md` Learnings 4 (lint needs the package loaded) and 5 (child R processes inherit renv), Learning 3 widened (cached packages), lint command and tool rows; gate `lint-package-zero`.
- **Commit/PR:** `1274024` (claim), `1017c25`, `518cba5`, `7c22e4b`, `430effe` (RED), `844542d`, `7357272`, `8d76336`, `0565f7f`, `b332309` (GREEN), close-out
- **Session:** S3 · **Verified:** 52 tests, 122 expectations, 0 skipped, the copied files' counts equal nprcgenekeepr's; results tool 120/120 `identical()` on 12 Phase 1 pedigrees and drift tool 0 differ, each with a negative control that failed; roxygen2 changes nothing; 0 lints; coverage 100%; `R CMD check --as-cran` 0 errors, 0 warnings, 1 allowed NOTE; `quality_ratchet: 2/2 pass`.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S3 claim (in progress): Phase 6 of nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md`, the first copy slice (pedigree basics), test-first; scope by Mark's pre-RED picker. Mark picked "Start Phase 6" at the orient picker. Phase 0 reconcile: nothing to backfill.

### 2026-11-10 · [ad hoc] S2 push: `master` to GitHub once at `32d525c` (R15), CI green on five jobs
- **Change:** the first push to the empty `rmsharp/pedkindraw`, which made `master` its default branch. R-CMD-check run `42930770118`: macOS release, Windows release, Linux devel, release and oldrel-1 all `Status: OK` (0/0/0; r-lib's action turns off the CRAN incoming check). `618b8a6` and the close-out commit are not pushed; Phase 6's push carries them.
- **Commit/PR:** push of `774c3c4`..`32d525c`
- **Session:** S2 · **Verified:** `gh run view 42930770118 --log | grep 'Status: '` gave 5 × `Status: OK`; the tests ran in all five.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S2 DONE: Phase 5b, the R package skeleton test-first (nprcgenekeepr plan Phase 5, R15)
- **Change:** the empty package, built by strict TDD. RED: 4 tests on `DESCRIPTION` and `LICENSE`. GREEN: `DESCRIPTION` 0.0.1 (Mark alone in `Authors@R`), `LICENSE` YEAR 2017-2026 (MIT, R14), `NAMESPACE` by roxygen2; `.Rbuildignore`, `.gitignore`, `.lintr` (nprcgenekeepr's linters); renv on Posit 2026-10-31, 25 packages identical to nprcgenekeepr's lock; the R-CMD-check workflow (five jobs). REFACTOR: no changes. `CLAUDE.md`: the allowed-NOTE rule (Mark), Learnings 2 (plain-words pickers) and 3 (dated repository before renv installs). Quality gate `renv-lock-no-latest-repository`. Mark's picks: YEAR 2017-2026; Mark alone; only the "New submission" NOTE allowed; the context-budget fix waits for its own session.
- **Commit/PR:** `774c3c4` (claim), `3c008b4` (RED), `652b984`, `a21da76`, `66b275f`, `32d525c` (GREEN 1-4), `618b8a6` (gate), close-out
- **Session:** S2 · **Verified:** 13 expectations pass with the package loaded and installed; roxygen2 changes nothing; no lints; `R CMD check --as-cran` 0 errors, 0 warnings, 1 NOTE (Maintainer plus "New submission" only); `quality_ratchet: 1/1 pass`. Coverage n/a (no R code yet).
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S2 claim (in progress): Phase 5b of nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md` (R15): the R package skeleton test-first, one push of `master`, the GitHub checks. Mark picked "Start Phase 5b" at the orient picker.

### 2026-11-10 · [ad hoc] S1 DONE: Phase 5a set-up, methodology files and CLAUDE.md (nprcgenekeepr plan Phase 5, R15)
- **Change:** methodology v4.2-2724 (`34067813`) synced under `methodology/` (31 files); `CLAUDE.md` from the template with nprcgenekeepr's strict TDD contract word for word (diff identical), a Build/Test/Verify table for an R package, the plan's constraints (R8, copied-file headers, drift rule) and Learning 1 (decisions by picker). Mark's picks: four commits; contract word for word.
- **Commit/PR:** `26bd620` (sync), `8e48839` (claim), `4ef233f` (`CLAUDE.md`), close-out
- **Session:** S1 · **Verified:** `methodology_dashboard.py` exit 0; `context_budget.py` `CLAUDE.md` ok, seed paths unmeasured (handed to 5b). Docs only; no R file, no push.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S1 claim (in progress): Phase 5a set-up of nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md` (ruling R15; Mark's picks: four commits, the TDD contract copied word for word). The methodology sync is committed (`26bd620`: `bin/sync --layout new`, methodology `34067813`, 31 files under `methodology/`); `CLAUDE.md` next. No R package files, no push (5b, a new session).
