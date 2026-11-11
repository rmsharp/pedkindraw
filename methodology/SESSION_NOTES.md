# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 5b — the R package skeleton, test-first (nprcgenekeepr plan Phase 5, ruling R15)
**Status:** READY. Phase 5a DONE in Session 1 (`26bd620` sync, `4ef233f` `CLAUDE.md`). No R file exists yet.
**Plan:** `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md:289-304` (Phase 5);
contract `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md:178-190` (section 5, dependencies)
**Priority:** HIGH

### What You Must Do
1. Orient (`CLAUDE.md:3-12`). Then ask Mark, by picker, the two things never asked: `LICENSE`'s `YEAR` line
   and the `Authors@R` list (plan:302-303). nprcgenekeepr's `LICENSE` reads `YEAR: 2017-2026`,
   `COPYRIGHT HOLDER: R. Mark Sharp`; its `Authors@R` starts at nprcgenekeepr `DESCRIPTION:5`.
2. Strict TDD (`CLAUDE.md:40-106`): a pre-RED scope picker, then the `TDD: PRE-RED→RED` gate (format at
   `CLAUDE.md:86`). What the RED test of an empty package asserts is yours to propose (e.g. the package
   loads and `DESCRIPTION` carries `License: MIT + file LICENSE`); nothing is ruled on it.
3. Build (plan:293-296): `DESCRIPTION` (version `0.x`, contract section 6; `Encoding: UTF-8`;
   `Roxygen: list(markdown = TRUE)` as nprcgenekeepr `DESCRIPTION:83,87`), `LICENSE`, `NAMESPACE` by roxygen2,
   testthat 3rd edition, `renv` on a dated Posit repository (nprcgenekeepr `renv.lock:4-7`,
   `renv/settings.json:13`), `.lintr` copied (nprcgenekeepr `.lintr`), `R-CMD-check` on Linux, macOS,
   Windows (nprcgenekeepr `.github/workflows/R-CMD-check.yaml:47-51`), `.Rbuildignore`, `.gitignore`.
   At most 5 files per commit.
4. DONE (plan:297): `R CMD check --as-cran` 0 errors, 0 warnings, 0 notes locally (`CLAUDE.md:109`), then
   push `master` once (R15), then `gh run list --limit 10` until all three OSes are green.

### Gotchas
- `.Rbuildignore` must exclude `^methodology$` and `^CLAUDE\.md$` (plus `^\.github$`, `^renv$`, `^renv\.lock$`,
  `^\.lintr$`), or the check lists non-standard top-level files. nprcgenekeepr: `.Rbuildignore:1-2,40,47,77,168`.
- No `.gitignore` exists. The orient tools write `methodology/dashboard.html`, `methodology/dashboard_history.jsonl`
  and `methodology/.context-budget-history.jsonl`; nprcgenekeepr ignores all three (`.gitignore:42-43,112`).
  Session 1 deleted its copies. Expect them untracked after your orient until 5b's `.gitignore` lands.
- The seeded `methodology/.context-budget.json` names bare paths (`SESSION_NOTES.md`, `LEARNINGS.md`,
  `SESSION_RUNNER.md`, `SAFEGUARDS.md`), so `python3 methodology/context_budget.py` reads them as missing:
  UNMEASURED, exit 1. `CLAUDE.md` measures ok (11,019 B, ceiling 28,000 B). nprcgenekeepr's config uses
  `methodology/` paths. A one-file fix, not made in Session 1 (set-up scope); whether 5b takes it is Mark's call.
- Expected from R's behaviour, not measured here: `--as-cran` on a package never on CRAN gives a
  "New submission" NOTE (CRAN incoming check), and a `.9000` version adds another. How these count against
  "0 notes" is Mark's call.
- The GitHub repository is empty: the first push of `master` makes `master` its default branch (plan:303 names `master`).
- Dashboard: health 41/100, one high risk, "No test infrastructure": expected until 5b adds tests.
- nprcgenekeepr was not touched. Its plan's status line (plan:8-9) still says Phase 5 is the next pickup;
  updating it is an nprcgenekeepr session's job (`CLAUDE.md:133-135`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*

### What Session 2 Did
**Deliverable:** Phase 5b, the R package skeleton test-first (nprcgenekeepr plan Phase 5, R15) (IN PROGRESS)
**Started:** 2026-11-10 18:05 CST · **Model:** Claude Opus 5.5
**Status:** Session claimed. Work beginning. Mark picked "Start Phase 5b" at the orient picker.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### What Session 1 Did
**Deliverable:** Phase 5a set-up: the methodology files under `methodology/` and `CLAUDE.md` (DONE)
**Started:** 2026-11-10 17:48 CST · **Model:** Claude Opus 5.5
**Commits:** `26bd620` sync (31 files, methodology `34067813`, v4.2-2724); `8e48839` claim; `4ef233f` `CLAUDE.md`;
the close-out commit (this file, `HANDOFFS.md`, `CHANGELOG.md`, `CLAUDE.md` Learning 1).
**What was done:** Read the plan's rulings and Phase 5, the API contract, the template, the runner. Dry run
(31 files, as S1150's), then `bin/sync --layout new`. `CLAUDE.md`: protocol paths under `methodology/`, Purpose
(protected), Tech Stack, nprcgenekeepr's contract (its `CLAUDE.md:41-106`, diff identical), Build/Test/Verify,
plan constraints (R8, copied-file headers, drift rule), TDD override, Learning 1.
Mark's picks: four commits; the contract word for word (its four repeated bullets kept).
**Verified:** contract diff identical; `methodology_dashboard.py` exit 0; `context_budget.py` `CLAUDE.md` ok
(seed paths unmeasured, see Gotchas). Runtime smoke n/a: docs only, `.quality-gates.json` declares 0 gates.
No R file, no test, no push.
**Self-assessment: 8/10.** + Read every governing file before proposing; dry run before writing; contract
taken by `sed` and diff-checked, not retyped; ran the orient tools the next session will run and found
the budget-path and `.gitignore` gaps. − The plan ended in a prose choice, not a picker: Mark had to ask
(Learning 1). − The budget-path gap is handed on, not fixed (kept to set-up scope).
**Ledger:** `CHANGELOG.md` S1 DONE entry.
