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
