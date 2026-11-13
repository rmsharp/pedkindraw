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

**Governing documents** (in this repository since S5, copied from nprcgenekeepr at its commit `3d262d628`; these copies are the live ones, nprcgenekeepr's are frozen):
- Plan: `docs/planning/standalone-pedigree-package-plan.md` — section 2 rulings (R1-R15, C2), section 4 phases (5-17, each with its DONE criteria), section 5 drift rule.
- API contract: `docs/planning/pedkindraw-api-contract.md` — every export with its arguments, return, errors and phase.
- Evidence they cite: `docs/research/` (the package comparison, the kinship2 gap analysis, the split scoping study), dated records, not edited.
- Paths inside these five documents name nprcgenekeepr's files, except the five themselves (each file's provenance note, under its title). The move: `docs/planning/planning-handover-plan.md`.

Repository: https://github.com/rmsharp/pedkindraw (public). License: MIT, `LICENSE` naming R. Mark Sharp (R14).
<!-- /budget:protected -->

---

## Tech Stack

- R package; R 4.6.2 on this Mac.
- `testthat` 3rd edition; `roxygen2` writes `NAMESPACE` and `man/`; `lintr` with nprcgenekeepr's settings copied (Phase 5b).
- `renv`, its lock on a dated Posit Package Manager repository (nprcgenekeepr's S1111 ruling; see Build / Test / Verify).
- GitHub Actions `R-CMD-check` on Linux, macOS and Windows (Phase 5b).
- Imports, each arriving with the phase that first needs it (contract section 5): `data.table` (6), `Matrix` (7; also `importClassesFrom(Matrix, ddiMatrix, dgCMatrix)`, plan R27), `methods` and `stats` (7), `quadprog` and `utils` (8: `quadprog::solve.QP.compact()`, `utils::head()`), `visNetwork` (9). An unused import is a check NOTE. Suggests: `testthat`, `mockery` (the copied tests' stand-ins, 6), `kinship2` (7: a fidelity test; later the converters), `withr` (7, a copied test's `with_seed()`; R28), `Pedixplorer` (converters), `chromote` (browser tests), and what the vignettes need (16). kinship2 and Pedixplorer are never required (R7).
- testthat **edition 3** (plan R29). nprcgenekeepr's tests run on edition 2 until it converts; a copied test that behaves differently here is changed the edition-3 way, the change named in its header (Learning 10).

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
| Test suite | `Rscript -e 'testthat::test_local()'` | All tests pass, WARN 0 (gate `test-suite-warnings-zero`, Learning 10) |
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

- **nprcgenekeepr is not changed** by this work (R8, plan section 1.3). Sessions here write this repository's `methodology/SESSION_NOTES.md`, `methodology/HANDOFFS.md` and `methodology/CHANGELOG.md`; they also update the plan's status block, `methodology/ROADMAP.md` and `methodology/BACKLOG.md` (created in H2) at close-out, and record a new ruling in the plan's section 2 in the session that makes it (`docs/planning/planning-handover-plan.md` section 5). nprcgenekeepr's copies of the plan and contract are frozen at its `3d262d628`; its one duty left is the drift watch in its `BACKLOG.md` (plan section 5, last line).
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
| 3 | Set the dated repository before `renv::install()` as well as before `renv::snapshot()`. renv's default installs from Posit's "latest" (newer versions) and records "latest" as each package's source, and a re-snapshot keeps it. Fix: reinstall from the dated repository with `rebuild = TRUE`, then snapshot again. Gate: `renv-lock-no-latest-repository` in `methodology/.quality-gates.json`. S3: setting the date is not enough for a package already in renv's cache: renv links the cache copy, which keeps the source it was first installed from (`mockery` came back "latest"). Install a package new to this project with `rebuild = TRUE` from the start, and run the gate after every snapshot. S8: `rebuild = TRUE` rebuilds only the packages named, not their dependencies: `renv::install("kinship2", rebuild = TRUE)` linked five cached dependencies, and the snapshot locked them "latest" (gate read 5). Reinstall each by name, `renv::install(c(...), rebuild = TRUE)`, then snapshot again. | Sessions 2, 3, 8 | Any renv install, snapshot or date change |
| 4 | Load the package before linting: `lintr::lint_package()` on a package that is not installed cannot find its namespace, so `object_usage_linter` reports every call to a function in another file as "no visible global function definition" (10 false lints in S3; 0 after `pkgload::load_all()`). nprcgenekeepr hides this because it is installed in its own renv library. Gate: `lint-package-zero`. S16: `.lintr` excludes `tests`, so linting a test file reports 0 whatever it holds (S15's RED "lint 0 on both files" measured nothing), and `lintr::lint()` on a file outside the project reads no `.lintr` and applies lintr's defaults. Report lint as `lint_package()`, which covers `R/`. | Sessions 3, 16 | Every lint run |
| 5 | An R process started from inside this project's renv passes `RENV_PROJECT` and `R_LIBS_USER` to its children, so Rscript run in nprcgenekeepr's folder still loads pedkindraw's library. Start such a child with renv's saved `RENV_DEFAULT_*` values put back (the text `<NA>` means unset) and `RENV_PROJECT` unset; `env` takes every `-u` before the first `NAME=value`. Worked example: `renvFreeEnv()` in `tools/compareResultsWithNprcgenekeepr.R`. | Session 3 | Any script that runs R in another project's folder |
| 6 | Search for what a plan depends on by its citations, not only by name. `git grep pedkindraw` in nprcgenekeepr found 33 files but missed the gap analysis and the split scoping study, written before the package had a name; the plan's own citations found them. List every path the governing documents cite (`docs/planning/planning-handover-plan.md` Appendix A). | Session 4 | Any inventory of documents to copy, move or update |
| 7 | A `file:line` citation goes stale through later edits to the cited file, your own included. S4's plan cited the standalone plan's `:88` for C2, measured before S4's own hand-over edit added 4 lines above it (S5 found it at `:92` there, `:108` in the copy); S5's 2 new lines in `CLAUDE.md` moved two citations in that same plan. After the last edit to a cited file, find each cited line again by its text (`grep -n`) and fix the number; quote a few words with the number so a reader can find a moved line. | Session 5 | Any plan, handoff or receipt that cites line numbers |
| 8 | A fact carried from one record into another is re-checked in its primary source: the tree, the commit, or the session's own notes as committed at its close-out (`git show <commit>:methodology/SESSION_NOTES.md`), and the whole source document, not only the section cited. S6 found S3's ledger "10 test files" was 9 and a helper; R22 recorded as Mark's pick only in S3's committed notes, not the ledger; and `kinship()`'s renamed arguments (C13) in section 2 of the clean-room plan, which the hand-over plan cited only for its section 4.8. | Session 6 | Writing the plan, contract, roadmap, backlog or a receipt from ledgers or another repository's documents |
| 9 | List what copied code reads as well as what it calls. S3 surveyed 6b with codetools for the functions it calls and missed `sexCodes`, a constant `addParents()` and `correctParentSex()` read: no plan, contract row or handoff named it, and S7 found it in the source. Run `codetools::findGlobals(fn, merge = FALSE)` on each copied function and read both `$functions` and `$variables` (S7's survey: `sys.source()` the files at the source commit into one environment, then subtract `ls(baseenv())`). Phase 7's `kinship()` reads `sexCodes` and `mzTwinIdsAbsentMessage` (S7). S8: codetools does not list `pkg::fn` calls, so S7's survey said `checkTwinRelations()` needs "nothing outside base" when it calls `stats::setNames()` (`Imports: stats`); grep each file for `::` as well. | Sessions 7, 8 | The inventory for each copy slice (Phases 7-10), before the pre-RED picker |
| 10 | nprcgenekeepr's tests run on testthat edition 2 (its `DESCRIPTION` names no edition) and pedkindraw's on edition 3, so a copied test can pass there and misbehave here. S8: `hasBothParents()` warns twice for 3 IDs; edition 2's `expect_warning()` swallowed both, edition 3's catches one and the other leaks as WARN. Two traps in finding it: the same file showed no warning when run from the scratchpad, because testthat reads the edition from the nearest `DESCRIPTION` and falls back to 2 without one (run a copied test from `tests/testthat/`); and an early grep's "edition: 3" was pedkindraw's own line, not nprcgenekeepr's (name the file in each grep). Mark (S8, R29): stay on edition 3; nprcgenekeepr will convert. Gate: `test-suite-warnings-zero`. S9, a second form: edition 3's `expect_message()` and `expect_warning()` return the condition, not the expression's value, so a copied `result <- expect_message(f())` leaves `result` the message (5 tests). RED cannot show it, because the missing function errors first; it appeared in GREEN. Assign inside, `expect_message(result <- f())`. Gate: `tests-no-saved-expect-condition`. | Sessions 8, 9 | RED of every copy slice: read the suite's WARN count, not only its FAIL count, and run the gates on the copied tests |
| 11 | Check that the fidelity cases reach the copied code's branches, not only that they compare equal. S8's first kinship cases were 336 of 336 identical, yet every sparse result was a `dgCMatrix`: no Phase 1 pedigree is founders only, the case that gives a `ddiMatrix` (found by summarizing the saved results). Then `covr` showed `R/kinship.R:181` (sire unknown, dam known) reached by neither the copied tests nor any case, and `:183` (dam unknown) only by smallPed's one such animal. Made-up variants of the pedigrees reach both (`kinshipFounders`, `kinshipOneParent` in `tools/compareResultsWithNprcgenekeepr.R`), as S7's did for 6b. Summarize the child's saved results per case (`--child . <data dir> <out.rds>`) and read `covr`'s uncovered lines. S10: run `covr::package_coverage()` twice, `type = "tests"` and `type = "none"` with `code =` running `runCases()` (parse the tool, eval its first expression), and merge the two per statement. The cases reach code only through the exports, so the argument checks of internal functions (13 in Phase 8) are the tests' job, not a gap; a made-up variant with every dam unknown reached the 9 statements a pedigree without matings takes. S13: a statement neither reaches is not defensive until you have worked out what input reaches it: `R/shrinkPedigree.R:278` (`if (length(pool) == 0L) break`) looked unreachable, since every leaf left is genotyped, but an animal that is its own ancestor, which the input checks allow, is never a leaf (`shrinkLoop`). Time the function on each Phase 1 pedigree before choosing what the cases run on: `shrinkPedigree()` took 130 s on examplePedigree's 3,694 animals, so its cases use the layout's pedigree (at most 400 animals). | Sessions 7, 8, 10, 13 | Every new `runCases()` case (Phases 8-10) |
| 12 | When a copied test misbehaves, run nprcgenekeepr's own file before changing pedkindraw's. `git archive <commit> DESCRIPTION NAMESPACE R data inst tests` into the scratchpad, start Rscript in the clone's folder (its renv; the clone is only read) and `test_file(..., package = "nprcgenekeepr", load_package = "none")` each source file after `pkgload::load_all()` of the archive; then compare each test's expectation count with pedkindraw's run. S9: the two "unexpected" warnings were nprcgenekeepr's own (R33), the 5 failures edition-only (R29), and 295 of 295 tests checked equal counts. | Session 9 | GREEN of every copy slice (Phases 8-10), before deciding what a failure means |
| 13 | Prove a copy and a saved fixture by machine, not by reading. S9's copy script collapsed every doubled blank line, not only those a dropped block left, and `diff source copy` showed two lost lines in `R/makePedigreeDiagramData.R` (list every hunk, expect only the planned ones). Three `shrinkPedigree()` sites had the same data-frame text, but one shrank before adding `gen`; the stand-in, which compares its whole call with `identical()` and stops otherwise, caught it in GREEN (`tests/testthat/helper-shrinkPedigreeStandIn.R`). | Session 9 | Every copy script and every stand-in for a function not yet copied |
| 14 | A copied test that begins with `skip_if_not_installed(pkg)` is skipped, not failed, while `pkg` is not installed, so a RED without it proves nothing. S10's handoff planned `Imports: visNetwork` for GREEN, and all 12 of `test_drawPedigreeDiagram.R`'s tests begin with that guard; S11 installed the slice's packages and listed them in `DESCRIPTION` in RED's first commit, and the 12 then failed on the missing function. Read RED's SKIP count beside its FAIL count. | Session 11 | RED of every copy slice that brings a new package |
| 15 | nprcgenekeepr changes while a slice is being copied: its own sessions run beside pedkindraw's. During S11 its S1159 committed a test change (`392dd347e`) and then a code change (`a85311021`) to `drawPedigreeDiagram()`, after S11's Orient had found the file unchanged; S11 saw it only because a check at GREEN 2 printed nothing. At each phase gate, run `git -C ../nprcgenekeepr log --oneline <copy commit>..HEAD -- <slice files>` and `git -C ../nprcgenekeepr status --short`. A change found mid-copy is ported later (R37: a `DIVERGENCE.md` row until then), and `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr <commit>` checks the copy against nprcgenekeepr at a commit, read with `git archive`, while the working copy is being edited (its synthetic pedigrees are git-ignored, so they are read from the clone's folder). S12: the same check at Orient found a third commit, S1159's REFACTOR `4283e3502`, made after S11's handoff had described the port as one code hunk; a handoff's account of nprcgenekeepr is a snapshot, so run the check before planning from it. | Sessions 11, 12 | Every copy slice (Phase 10), and any session that runs the two tools |
| 16 | Port a change nprcgenekeepr made to a copied file as its own diff, applied exactly: `git -C ../nprcgenekeepr diff <from> <to> -- <file> > x.patch`, then `patch -p1 -F0 --dry-run < x.patch`, then without `--dry-run`. `-F0` allows no fuzz, so a hunk applies only where the copy's lines are the source's; the copy's own header and help lines above the code only shift the offset. Port the source's commits one per phase (S12: nprcgenekeepr's RED, GREEN and REFACTOR became pedkindraw's), and prove each as Learning 13 says: the parsed code identical to the source's at that commit, and `diff` listing only the header and help hunks. | Session 12 | Every port under the drift rule (R37), and any later copy of a changed file |
| 17 | Measure what a pre-RED choice does before asking Mark to make it, so the picker states counts, not guesses. S13: whether RED or GREEN deletes the `shrinkPedigree()` stand-in was answered by deleting it in a scratch copy (`git archive HEAD | tar -x -C <scratch>`, the file removed, the affected test files run with `R_LIBS` and `R_LIBS_USER` set to the project's renv library): exactly 3 existing tests fail, one per Track B file. The same copy answers "does the help example still say what it claims" (lacy1989Ped's 7 animals, all genotyped, shrink to 0 rows). The tree stays clean, and the picker's option names the measured result. | Session 13 | Every pre-RED picker whose options change which tests fail or what a file says |
| 18 | In new code there is no source to copy, so every expected value and every claimed difference is a prediction until run. Compute each value a RED test states with the reference function in a scratch run, and reproduce a described difference on a small typed input before a ruling or help page states it. S14: 1 of the hand-derived values was wrong (an animal left with no offspring also goes), and R42's account of the one-trim difference from kinship2, written from reading ids in a 280-animal case, was disproved by a 7-animal reproduction and corrected before RED (`702d3b5`); the counts were right, the description was not. Help text says what the tests measure ("on every pedigree its tests compare"), not a general rule; GREEN 1's help needed a correcting commit (`3ef609d`). | Session 14 | RED of every new-code phase (11-15), and every help page or ruling that compares with kinship2 or Pedixplorer |
| 19 | Before a picker on a function kinship2 also has, run kinship2's version on many cases (typed ones, the fixture pedigrees, seeded random ones), each in `tryCatch()` and each under a time limit (`timeout 15 Rscript case.R <name>`, one process per case), and tally where it returns, where it stops and where it never returns. S15: kinship2 1.9.6.2's `familycheck()` stopped in 227 of 463 cases (every one with all joins inside one family tree); its `ibdMatrix()` refused every `idmap` and never returned when an id's diagonal was missing (the first scratch run stalled until killed). Its numbers can also differ from its help page's words: `familycheck()`'s `join` counts a family once per shared tree, where the help says "number of other families", found only by printing the famid-by-tree table of the smallest case where a prototype differed. Put both readings in the picker with their counts, and compare with kinship2 only where it returns, with a floor on how many cases were compared (`expect_gte()`). S16: a measured claim covers only the cases measured. S15's "`ibdMatrix()` never returns when a diagonal is missing" held for its cases, but on 40 random such inputs kinship2 returned a 0 diagonal in 33 and hung in 7. A rule read from three printed cases ("ids sharing a pair first") held in 172 of 186 saved cases, and R46 needed a correcting commit (`ebab5b9`). Check a rule on every saved case before a ruling or help page states it. `setTimeLimit(elapsed = 10, transient = TRUE)` stops kinship2's hang inside R, so a test that calls it can carry the guard (`tests/testthat/helper-ibdMatrix.R`). | Sessions 15, 16 | Every new-code phase that compares with kinship2 (Phases 12-14), and every ruling that describes its behaviour |

### Project-specific Failure Modes

(none — the base failure modes in `methodology/SESSION_RUNNER.md` apply.)
