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

### 2026-11-10 · [ad hoc] S2 claim (in progress): Phase 5b of nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md` (R15): the R package skeleton test-first, one push of `master`, the GitHub checks. Mark picked "Start Phase 5b" at the orient picker.

### 2026-11-10 · [ad hoc] S1 DONE: Phase 5a set-up, methodology files and CLAUDE.md (nprcgenekeepr plan Phase 5, R15)
- **Change:** methodology v4.2-2724 (`34067813`) synced under `methodology/` (31 files); `CLAUDE.md` from the template with nprcgenekeepr's strict TDD contract word for word (diff identical), a Build/Test/Verify table for an R package, the plan's constraints (R8, copied-file headers, drift rule) and Learning 1 (decisions by picker). Mark's picks: four commits; contract word for word.
- **Commit/PR:** `26bd620` (sync), `8e48839` (claim), `4ef233f` (`CLAUDE.md`), close-out
- **Session:** S1 · **Verified:** `methodology_dashboard.py` exit 0; `context_budget.py` `CLAUDE.md` ok, seed paths unmeasured (handed to 5b). Docs only; no R file, no push.
- **Model:** Claude Opus 5.5

### 2026-11-10 · [ad hoc] S1 claim (in progress): Phase 5a set-up of nprcgenekeepr's `docs/planning/standalone-pedigree-package-plan.md` (ruling R15; Mark's picks: four commits, the TDD contract copied word for word). The methodology sync is committed (`26bd620`: `bin/sync --layout new`, methodology `34067813`, 31 files under `methodology/`); `CLAUDE.md` next. No R package files, no push (5b, a new session).
