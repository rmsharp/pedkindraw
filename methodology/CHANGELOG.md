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
