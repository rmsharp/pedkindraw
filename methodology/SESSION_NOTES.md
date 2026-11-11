# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 6, the first copy slice: pedigree basics (nprcgenekeepr plan Phases 6-10, row 6)
**Status:** READY. Phase 5 DONE: 5a in S1, 5b in S2 (local check 0/0/1, where the 1 is the allowed "New submission" NOTE; CI run `42930770118` all five jobs `Status: OK`).
**Plan:** `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md:306-326` (slice rules and DONE),
`:318` (the Phase 6 row), `:116` (§3.2 copy set), `:143` (§3.3 tests and fixtures), `:353` (§5 drift rule).
Contract `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md:88-116` (§4.1 copied exports; Phase 6 rows),
`:178-190` (§5 dependencies: `data.table` kept, `stats`, `utils`).
**Priority:** HIGH (next plan phase). One small item is waiting on Mark's call (see Gotchas: the context-budget paths).

### What You Must Do
1. Orient (`CLAUDE.md:3-12`). Pick nprcgenekeepr's **source commit** for the slice and record it. Its `R/`, `tests/` and
   `DESCRIPTION` are unchanged from `617420377` to `e96085bd4` (checked in S2). Docs-only nprcgenekeepr sessions were running then.
2. Pre-RED pickers, **in plain words** (`CLAUDE.md` Learning 2): the slice's scope. Phase 6 lists 22 functions, which is likely
   more than 5-file commits fit in one session (an estimate, not measured). Also whether `toCharacter` is in it (see Gotchas).
   Then the `TDD: PRE-RED→RED` gate (`CLAUDE.md:86`).
3. RED: copy the slice's nprcgenekeepr tests (plan:308-309). They fail because the functions are missing. Fixtures built with
   functions not copied (`qcStudbook()` and the others in §3.3) become saved fixture files. Each copied file's header names its
   nprcgenekeepr path and the source commit (`CLAUDE.md:136`).
4. GREEN: copy the code. `DESCRIPTION` gains `Imports: data.table, stats, utils`. Then `renv` with the dated repository set
   **before** installing and snapshotting (Learning 3; `options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2026-10-31"))`),
   `renv::snapshot(dev = TRUE)`, and `python3 methodology/quality_ratchet.py --run` must stay 1/1.
   The drift rule starts here: `tools/compareWithNprcgenekeepr.R` and `DIVERGENCE.md` (`CLAUDE.md:137`).
5. DONE (plan:310-313): the copied tests pass with the same pinned values; a script shows `identical()` results against
   nprcgenekeepr on the Phase 1 pedigrees; `R CMD check --as-cran` 0/0/0 under the S2 rule (`CLAUDE.md:115`); push; CI green.

### Gotchas
- **Two commits are not pushed:** `618b8a6` (quality gate and ignore fixes) and the S2 close-out. R15 allowed 5b one push
  (done at `32d525c`). Phase 6's push carries them. `git status` will say "ahead of 'origin/master' by 2 commits".
- **`toCharacter` conflict:** plan:318 lists it in Phase 6, but contract ruling R13 (contract:38) keeps it out because only
  the file readers use it. Ask Mark before copying it.
- **CI never shows the "New submission" NOTE:** r-lib's `check-r-package` sets `_R_CHECK_CRAN_INCOMING_=false`, so the CRAN
  incoming checks (title, spelling, version) run only in the local check. Read the local `Status:` line, not just CI's.
  CI also passes on NOTEs (it errors only on warnings). Grep the run log for `Status:`, as S2 did:
  `gh run view <id> --log | grep 'Status: '`.
- **Coverage:** `covr::package_coverage()` stops with an error on a package with no R code ("cannot open file .../R/pedkindraw").
  It works once `R/` exists, so Phase 6 is the first session that can measure coverage.
- **renv:** the project library is outside the repository
  (`~/Library/Caches/org.R-project.R/R/renv/library/pedkindraw-f12fe1bc/`). roxygen2, lintr and covr are installed
  there but not in `renv.lock` (an explicit snapshot records only `DESCRIPTION`'s packages, as in nprcgenekeepr), so a fresh
  clone's `renv::restore()` won't install them. `renv/settings.json` has `"snapshot.dev": false`, so a plain
  `renv::snapshot()` drops testthat. Always pass `dev = TRUE`.
- **`.Rbuildignore` additions for Phase 6:** `^tools$` and `^DIVERGENCE\.md$`, or the check lists them as non-standard
  top-level files. nprcgenekeepr's is at its `.Rbuildignore:57`.
- **`pedkindraw.Rproj` is untracked.** It appeared during S2 and S2 didn't make it (RStudio, probably). `.Rbuildignore`
  already excludes it. Commit it or gitignore it: Mark's call. S2 didn't touch it.
- **roxygen2** makes an empty `man/` folder; `R CMD build` removes it ("Removed empty directory"). It goes away once there are Rd files.
- **Context budget (waiting on Mark):** `methodology/.context-budget.json` names bare paths, so `context_budget.py` reads them
  as missing (UNMEASURED, exit 1). Mark ruled in S2 that it gets a short session of its own, not part of 5b.
- nprcgenekeepr was not touched. Its plan's status line (plan:8-9) still says Phase 5 is next. Updating it, and its
  BACKLOG item, is an nprcgenekeepr session's job (`CLAUDE.md:133-135`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1's entry was removed in S2 (FM #28): its durable record is the S1 receipt in `HANDOFFS.md` and the S1 entries in `CHANGELOG.md`.*

### What Session 3 Did
**Deliverable:** Phase 6, the first copy slice: pedigree basics (nprcgenekeepr plan Phase 6), scope by Mark's pre-RED picker (IN PROGRESS)
**Started:** 2026-11-10 19:15 CST · **Model:** Claude Opus 5.5
**Status:** Session claimed. Work beginning. Mark picked "Start Phase 6" at the orient picker.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 1 Handoff Evaluation (by Session 2)
**Score: 9/10.**
- **What helped:** every nprcgenekeepr pointer was exact (`DESCRIPTION:83,87`, `.Rbuildignore:1-2,40,47,77,168`,
  `.gitignore:42-43,112`, `R-CMD-check.yaml:47-51`, `renv.lock:4-7`; re-checked in S2). The `.Rbuildignore` list made the
  first check clean with no rework. Several predictions were right and labelled as predictions: the dashboard files would be
  untracked, a "New submission" NOTE would appear, the first push would make `master` the default branch.
  The two open questions for Mark (YEAR, `Authors@R`) were named.
- **What was missing:** the renv trap. `CLAUDE.md` says to set the dated repository before snapshotting, but not before
  installing; renv's default "latest" got into the lock (now Learning 3 and a gate). Also not mentioned: covr fails with
  no R code, and r-lib's CI action switches off the CRAN incoming check.
- **What was wrong:** nothing found.
- **ROI:** high. Reading took minutes and saved the research the pointers had already done.

### What Session 2 Did
**Deliverable:** Phase 5b, the R package skeleton test-first (nprcgenekeepr plan Phase 5, R15) (DONE)
**Started:** 2026-11-10 18:05 CST · **Model:** Claude Opus 5.5
**Mark's picks (all by picker):** start 5b; `LICENSE` YEAR 2017-2026; `Authors@R` Mark alone (others join with their code);
the "New submission" NOTE is allowed and no other; the context-budget fix waits for its own session; each TDD gate
"proceed" (REFACTOR with no changes).
**Commits:** `774c3c4` claim · `3c008b4` RED (`tests/testthat.R`, `tests/testthat/test_package.R`: 4 tests on DESCRIPTION
and LICENSE) · `652b984` GREEN 1 (`DESCRIPTION` 0.0.1, `LICENSE`, `NAMESPACE`) · `a21da76` GREEN 2 (`.Rbuildignore`,
`.gitignore`, `.lintr`) · `66b275f` GREEN 3 (renv, 25 packages, identical to nprcgenekeepr's lock) · `32d525c` GREEN 4
(`.github/workflows/R-CMD-check.yaml`, `CLAUDE.md:115` NOTE rule) · `618b8a6` quality gate · close-out commit.
Pushed `master` once at `32d525c` (it became GitHub's default branch). CI run `42930770118`: 5/5 success, each `Status: OK`.
**Verified:** RED failed for the right reason ("pedkindraw has no DESCRIPTION file", 4/4). GREEN: 13 expectations pass with
the package loaded and installed (`pedkindraw.Rcheck/tests/testthat.Rout`: FAIL 0 PASS 13). roxygen2 changes nothing.
lintr finds no lints. `R CMD check --as-cran`: 0 errors, 0 warnings, 1 NOTE (Maintainer plus "New submission"), with and
without renv. The tarball holds only `DESCRIPTION`, `LICENSE`, `NAMESPACE` and the tests. Coverage: n/a (no R code).
`quality_ratchet: 1/1 pass · 0 fail · 0 unmeasured · results d088b0dff568 · manifest eac7a277c6cd`. Dashboard 41 → 70, no high risk.
**Self-assessment: 8/10.**
+ Every gate and decision went through a picker. RED failed for the right reason before any package file existed.
+ The version test uses R's own rule (parts of 1234 or more; leading zeros), read from `tools:::.check_package_CRAN_incoming`.
+ Inspecting the lock found the renv "latest" trap; fixed until a re-snapshot was stable and identical to nprcgenekeepr's.
  Learning 3 plus a gate that was shown to fail on a bad lock.
+ Read the "New submission" status from CI's logs instead of trusting the green badge.
− The first decisions picker used shorthand. Mark: "I do not understand your descriptions." One rewrite (Learning 2).
− The first snapshot was taken without setting the dated repository, though `CLAUDE.md` says to. The inspection caught it,
  not the habit.
− The `.gitignore` line for the ratchet's results file guessed `methodology/`. The tool writes to the root; fixed in `618b8a6`.
**Ledger:** `CHANGELOG.md` S2 entries (DONE; push and CI).
