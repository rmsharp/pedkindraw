# CLAUDE.md

## SESSION PROTOCOL — FOLLOW BEFORE DOING ANYTHING

Read and follow `methodology/SESSION_RUNNER.md` step by step. It is your operating procedure for every session. It tells you what to read, when to stop, and how to close out.

**Three rules you will be tempted to violate:**
1. **Orient first** — Read methodology/SAFEGUARDS.md → methodology/SESSION_NOTES.md → run `python3 methodology/methodology_dashboard.py` → git status → report findings → WAIT FOR THE USER TO SPEAK
2. **1 and done** — One deliverable per session. When it's complete, close out. Do not start the next thing.
3. **Auto-close** — When done: evaluate previous handoff, self-assess, document learnings, write handoff notes, commit, report, STOP.

`methodology/SESSION_RUNNER.md` documents known failure modes and their countermeasures. The protocol compensates for documented tendencies to skip orientation, skip close-out, and continue past the deliverable.

---

## Purpose

<!-- budget:protected -->
This is the **pedkindraw** project, an R package. In Mark's words (S742): "A standalone near-equivalent of kinship2 carrying nprcgenekeepr's enhanced features -- particularly the pedigree drawing, annotation ability, and interactivity; nprcgenekeepr may eventually consume it, but that is NOT the primary goal." It is a sibling product first (ruling R1). Its code starts as a **copy** of nprcgenekeepr's (R8), and nprcgenekeepr is not changed by this work. The primary deliverable is the package on CRAN (plan Phase 17): interactive `visNetwork` pedigree drawings, kinship, pedigree trimming and shrinking, a short pedigree checker and unrelated-set finder, and converters from kinship2 `pedigree` and Pedixplorer `Pedigree` objects.

**Governing documents** (they live in nprcgenekeepr, not here):
- Plan: `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md` — section 2 rulings (R1-R15, C2), section 4 phases (5-17, each with its DONE criteria), section 5 drift rule.
- API contract: `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md` — every export with its arguments, return, errors and phase.

Repository: https://github.com/rmsharp/pedkindraw (public). License: MIT, `LICENSE` naming R. Mark Sharp (R14).
<!-- /budget:protected -->

---

## Tech Stack

- R package; R 4.6.2 on this Mac.
- `testthat` 3rd edition; `roxygen2` writes `NAMESPACE` and `man/`; `lintr` with nprcgenekeepr's settings copied (Phase 5b).
- `renv`, its lock on a dated Posit Package Manager repository (nprcgenekeepr's S1111 ruling; see Build / Test / Verify).
- GitHub Actions `R-CMD-check` on Linux, macOS and Windows (Phase 5b).
- Imports, each arriving with the phase that first needs it (contract section 5): `data.table` (6), `Matrix` (7), `quadprog` (8), `visNetwork` (9), `stats`, `utils` (each only once a copied function uses it: none of Phase 6's does, and an unused import is a check NOTE). Suggests: `testthat`, `mockery` (the copied tests' stand-ins, 6), `kinship2` (fidelity tests, converters), `Pedixplorer` (converters), `chromote` (browser tests), and what the vignettes need (16). kinship2 and Pedixplorer are never required (R7).

---

## Development Process Contract

This project uses **Strict Test-Driven Development (TDD)**.
Deviation is a defect.

### TDD Rules:
- Write tests before implementation code
- Each feature branch should include tests
- Ensure both happy paths and all non-happy paths are tested
- Ensure potential edge cases are tested
- Maintain >80% code coverage for new code
- Run full test suite before merging
- Tests should be fast, isolated, and deterministic

### TDD Phases

#### RED
- Write tests only
- Tests must fail
- No implementation code
- No production logic
- No refactoring

#### GREEN
- Write the minimum implementation required to pass tests
- No new functionality
- No refactoring
- No optimization

#### REFACTOR
- Improve structure and readability
- No behavior changes
- All tests must remain passing

### Enforcement Rules

- The assistant MUST declare the current phase at the top of every response.
- The assistant MUST refuse requests that violate the current phase.
- The assistant MUST ask permission before transitioning between phases — via `AskUserQuestion`, per the **Phase-gate format** below.
- Skipping phases is forbidden.
- Writing implementation code during RED is a violation.
- Ensure potential edge cases are tested
- Maintain >80% code coverage for new code
- Run full test suite before merging
- Tests must be fast, isolated, and deterministic

### Phase-gate format

The "ask permission before transitioning" rule above is satisfied with **`AskUserQuestion`** (the structured prompt), **not** a prose question, at **every** phase transition — so the choice and the exact planned actions are explicit and logged. This is a followed project convention, **not** a `settings.json` hook: there is no "phase transition" harness event, and a hook cannot author options describing the specific next-phase actions.

Each gate is **one** `AskUserQuestion` with this shape (the harness auto-appends a free-text "Other"):

- **Header:** `TDD: <FROM>→<TO>` (e.g. `TDD: RED→GREEN`).
- **Option 1 — "Yes, proceed to <TO>":** spell out the *exact* actions the next phase will take — files, the concrete change, how the failing tests / completion criteria get satisfied — then the downstream verification (full suite, lint, the build-equivalent per "Build / Test / Verify", and any E2E/integration).
- **Option 2 — "Hold / <alternative>":** a concrete alternative — pause to review the RED tests / classification first, OR a narrower next-phase scope (e.g. "docs only; leave X as-is").

**Gated transitions:** `PRE-RED→RED`, `RED→GREEN`, `GREEN→REFACTOR`. A pre-RED **scope or approach** decision that is the author's to make (e.g. which functions are in scope) is a *separate* `AskUserQuestion`, posed before declaring RED. The declare-phase-at-top-of-response and refuse-on-violation rules are unchanged.

### Error Handling

If a response violates TDD:
1. The assistant must acknowledge the violation.
2. The assistant must correct itself.
3. The assistant must reissue a compliant response.

This file supersedes general coding instincts.

---

## Build / Test / Verify

The build-equivalent for this R package (`methodology/SAFEGUARDS.md` "Verify the Build Equivalent"). Phase 5b created the package (Session 2). Run each from the repository root.

| Purpose | Command | Pass criteria |
|---|---|---|
| Full package check (every phase's DONE gate) | `R CMD build . && R CMD check --as-cran pedkindraw_*.tar.gz` | 0 errors, 0 warnings, 0 notes. One exception until the package is on CRAN (Mark, S2): the NOTE from "checking CRAN incoming feasibility" may appear if its only content is the Maintainer line and "New submission". Any other NOTE fails. |
| Test suite | `Rscript -e 'testthat::test_local()'` | All tests pass |
| Documentation | `Rscript -e 'roxygen2::roxygenise()'`, then `git status` | `NAMESPACE` and `man/` unchanged |
| Lint | `Rscript -e 'suppressMessages(pkgload::load_all(".", quiet = TRUE)); lintr::lint_package()'` | No lints (gate `lint-package-zero`). Load the package first: Learning 4 |
| Coverage | `Rscript -e 'covr::package_coverage()'` | >80% for new code (TDD Rules) |
| CI (after a push) | `gh run list --limit 10` | Every run `completed success`, on Linux, macOS and Windows |
| Fidelity (Phases 6-10) | `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr` (each slice adds its functions to `runCases()`) | Exit 0: every result `identical()`; largest kinship difference 0. It refuses a clone whose copied files changed since the copy's commit |
| Drift (plan section 5) | `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr` | Exit 0: every copied function the same, or its difference has a `DIVERGENCE.md` row |

**Fast single-file test:** `Rscript -e 'Sys.setenv(NOT_CRAN = "true"); suppressMessages(pkgload::load_all(".", quiet=TRUE)); testthat::test_file("tests/testthat/test_X.R", reporter="summary")'`. Set `NOT_CRAN` first: without it, a file with a top-level `skip_on_cran()` silently skips instead of running (nprcgenekeepr Learning 417).

**`renv.lock` names a dated repository** (nprcgenekeepr's S1111 ruling, carried by plan Phase 5). A lock on `cran/latest` fails from an empty cache once a package moves; on a date it keeps serving ready-built packages. To set or move the date, run `options(repos = c(CRAN = "https://packagemanager.posit.co/cran/<date>"))` before snapshotting. If `renv/settings.json` sets `snapshot.type: "explicit"`, as nprcgenekeepr's does, always snapshot with `renv::snapshot(dev = TRUE)`: a plain snapshot drops every Suggests and dev-only package from the lock (nprcgenekeepr Learnings 473/476).

---

## Project-Specific Methodology Adaptations

*Additions and overrides to the base methodology at `methodology/SESSION_RUNNER.md` and `methodology/SAFEGUARDS.md` (synced from the methodology repository by `bin/sync --layout new`, not project-owned — as is the reference table in `methodology/FRAMEWORK_LEARNINGS.md`). The base files govern unless explicitly overridden here. Do not edit the synced files.*

### Plan constraints every session carries

- **nprcgenekeepr is not changed** by this work (R8, plan section 1.3). Sessions here write this repository's `methodology/SESSION_NOTES.md`, `methodology/HANDOFFS.md` and `methodology/CHANGELOG.md`; the plan's status line and its `BACKLOG.md` item in nprcgenekeepr are updated by sessions there.
- **Copied code (Phases 6-10):** each slice copies its tests first (RED: they fail because the functions are missing), then the code (GREEN). Each copied file's header names its nprcgenekeepr source path and the nprcgenekeepr commit it came from.
- **Drift rule (plan section 5), from Phase 6 on:** a change to a copied function in either repository is made in the other too (in a session of its own there) or recorded as a row in `DIVERGENCE.md` (function, both commits, why). `tools/compareWithNprcgenekeepr.R` lists every copied function whose arguments or code differ from nprcgenekeepr's, read from the local clone with git (nprcgenekeepr is installed nowhere here); every difference it lists must have a row.

### Development Process Contract override

This project runs **Strict Test-Driven Development** (see the "Development Process Contract" section above). This is a project-specific override of the base methodology's general development guidance: tests are written before implementation, every response declares its TDD phase (RED / GREEN / REFACTOR), and phase transitions require permission. It supersedes general coding instincts but operates *within* the `methodology/SESSION_RUNNER.md` protocol (orient → one deliverable → close out). Implementation and bug-fix sessions therefore follow the chosen workstream **and** the RED→GREEN→REFACTOR gates.

### Project-specific Learnings

<!-- This table is loaded every session and grows with no cap. When CLAUDE.md nears its
     size budget, extract these rows to a committed methodology/PROJECT_LEARNINGS.md beside
     methodology/FRAMEWORK_LEARNINGS.md and replace them with a one-line pointer (read on demand).
     See methodology/BOOTSTRAP.md Step 5. -->

| # | Lesson | From | When to apply |
|---|---|---|---|
| 1 | A plan that waits for Mark's go, or offers him a choice, ends in one `AskUserQuestion` picker (go / alternative / hold, each option naming the exact actions), never a question in the prose. Mark: "I cannot tell what you are asking; provide a picker." | Session 1 | Every plan, scope or approach decision, as for the TDD phase gates |
| 2 | Write picker questions and options in plain words: say what the thing is, why it matters and what each choice does. Don't use shorthand from your own notes ("CRAN incoming", "budget paths", "seed paths unmeasured"). Mark, on such a picker: "I do not understand your descriptions." The plain rewrite was answered at once. | Session 2 | Every `AskUserQuestion`, including the TDD gates |
| 3 | Set the dated repository before `renv::install()` as well as before `renv::snapshot()`. renv's default installs from Posit's "latest" (newer versions) and records "latest" as each package's source, and a re-snapshot keeps it. Fix: reinstall from the dated repository with `rebuild = TRUE`, then snapshot again. Gate: `renv-lock-no-latest-repository` in `methodology/.quality-gates.json`. S3: setting the date is not enough for a package already in renv's cache: renv links the cache copy, which keeps the source it was first installed from (`mockery` came back "latest"). Install a package new to this project with `rebuild = TRUE` from the start, and run the gate after every snapshot. | Sessions 2, 3 | Any renv install, snapshot or date change |
| 4 | Load the package before linting: `lintr::lint_package()` on a package that is not installed cannot find its namespace, so `object_usage_linter` reports every call to a function in another file as "no visible global function definition" (10 false lints in S3; 0 after `pkgload::load_all()`). nprcgenekeepr hides this because it is installed in its own renv library. Gate: `lint-package-zero`. | Session 3 | Every lint run |
| 5 | An R process started from inside this project's renv passes `RENV_PROJECT` and `R_LIBS_USER` to its children, so Rscript run in nprcgenekeepr's folder still loads pedkindraw's library. Start such a child with renv's saved `RENV_DEFAULT_*` values put back (the text `<NA>` means unset) and `RENV_PROJECT` unset; `env` takes every `-u` before the first `NAME=value`. Worked example: `renvFreeEnv()` in `tools/compareResultsWithNprcgenekeepr.R`. | Session 3 | Any script that runs R in another project's folder |

### Project-specific Failure Modes

(none — the base failure modes in `methodology/SESSION_RUNNER.md` apply.)
