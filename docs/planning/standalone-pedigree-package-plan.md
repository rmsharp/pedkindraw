# Plan: a kinship2-like standalone pedigree package built from nprcgenekeepr's code

> **Copied into pedkindraw (pedkindraw S5, 2026-11-11).** Copied unchanged from nprcgenekeepr's
> `docs/planning/standalone-pedigree-package-plan.md` at nprcgenekeepr commit `3d262d628`,
> by step H1 of `docs/planning/planning-handover-plan.md`.
> From here on this copy is the live one: pedkindraw's sessions follow it and update it, and nprcgenekeepr's
> copy is frozen. Step H2 of the hand-over plan (pedkindraw S6) brought it up to date: the status block, §1.3,
> §2 (R16-R23), Phases 5-10 and §5.
> **Paths in this file name nprcgenekeepr's files** (`R/`, `tests/`, `BACKLOG.md`, `methodology/`,
> `tools/pedigreeComparison/` and so on), except these five, copied into pedkindraw at the same paths:
> `docs/planning/standalone-pedigree-package-plan.md`, `docs/planning/pedkindraw-api-contract.md`,
> `docs/research/pedigree-package-comparison-2026-11.md`,
> `docs/research/kinship2-feature-gap-analysis-2026-09-20.md` and
> `docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md`. Text added in pedkindraw (H2 on) says whose
> file a path names: "pedkindraw's", "nprcgenekeepr's" or `nprcgenekeepr:<path>`.
> A line number cited in one of these five is its line in nprcgenekeepr. In this copy the lines down to the status
> block sit lower by this note (17 lines, counting the blank line above); below it, H2's edits moved them
> further, so find a cited line by its words.

**Date:** 2026-11-02 · **Session:** S1121 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
§Planning Sessions; `methodology/workstreams/ARCHITECTURE_WORKSTREAM.md`). No package code was written or
changed. **Status:** plan approved in scope by Mark's rulings below. In nprcgenekeepr: Phase 1 DONE (S1122-S1123,
`docs/research/pedigree-package-comparison-2026-11.md`); Phase 2 DONE (S1124-S1125, the same doc's sections 8-10);
Phase 3 DONE (S1126, the same doc's section 11: R7 ruled); Phase 4 DONE (S1128: `docs/planning/pedkindraw-api-contract.md`,
rulings R10-R13, repository `rmsharp/pedkindraw`); the clean-room rewrite C2 relies on finished (S1140); License line
ruled S1149 (R14: MIT, as nprcgenekeepr). In pedkindraw's repository: Phase 5 DONE (pedkindraw S1-S2, R15); Phase 6a
DONE (pedkindraw S3: 10 of Phase 6's 21 functions, R19); the plan moved here (pedkindraw S4-S6, R23: steps H0-H2 of
pedkindraw's `docs/planning/planning-handover-plan.md`); Phase 6b DONE (pedkindraw S7: the other 11 and the constant
`sexCodes`, R24-R25); Phase 7 DONE (pedkindraw S8: `kinship()`, `checkTwinRelations()` and `mzTwinGroups()`,
R26-R29); Phase 8 DONE (pedkindraw S9-S10: the layout code, the kinship2 comparison and 333 tests, R30-R33); Phase 9
DONE (pedkindraw S11: `drawPedigreeDiagram()` and its helpers, 15 tests, R34-R37); nprcgenekeepr S1159's legend
change ported (pedkindraw S12, R37; `DIVERGENCE.md` has no row); Phase 10 DONE (pedkindraw S13: `shrinkPedigree()`
and its helpers, 24 tests, R38-R39), so the copy slices, Phases 6-10, are complete; Phase 11 DONE (pedkindraw S14:
`bitSize()`, `findUnavailable()`, `findAvailNonInform()`, `findAvailAffected()`, the first new code, 32 tests,
R40-R42); Phase 12 DONE (pedkindraw S15: `familyCheck()`, 16 tests, R43-R45; pedkindraw S16: `ibdMatrix()`, 19
tests, R46-R48); Phase 13 DONE (pedkindraw S17: `checkPedigree()`, 23 tests, R49-R51; pedkindraw S18:
`findUnrelated()`, 19 tests, R52-R54); Phase 14 DONE (pedkindraw S19: `asPedFrame()` for kinship2's `pedigree` and
`pedigreeList` objects, 15 tests, R55-R57; pedkindraw S20: Pedixplorer installed into renv and `asPedFrame()` for its
`Pedigree` objects, 14 tests, R58-R59); Phase 15's design DONE (pedkindraw S21:
`docs/planning/layout-hints-design.md`, R60-R63); Phase 15a DONE (pedkindraw S22: the `order` layout hint,
`R/layoutHints.R`, 12 tests, R64-R69); Phase 15b DONE (pedkindraw S23: the `mate` layout hint, R61's `spouse`
renamed, 9 tests, R70-R73); Phase 15c DONE (pedkindraw S24: `asPedFrame()` returns the object's layout hints, 12
tests, R74-R76), so Phase 15 is DONE; Phase 16's plan DONE (pedkindraw S25:
`docs/planning/documentation-plan.md`, R77-R80; five build sessions, 16a-16e); Phase 16a DONE (pedkindraw S26: the
README with its picture, NEWS and `?pedkindraw`); Phase 16b DONE (pedkindraw S27: the getting-started vignette and
the 375-animal example file); the backlog's legend item DONE (pedkindraw S28: each condition's legend row a section
picture when there are two or more, R81; to be ported to nprcgenekeepr); Phase 16c DONE (pedkindraw S29: the
drawing vignette); Phase 16d deferred (pedkindraw S30, R82: the speed vignette waits until pedkindraw times itself;
its draft on the branch `draft/speed-vignette`); Phase 16e DONE (pedkindraw S31: the website,
<https://rmsharp.github.io/pedkindraw/>), so Phase 16 is DONE; Phase 17's plan DONE (pedkindraw S32:
`docs/planning/cran-submission-plan.md`, R83-R85; phases 17a-17q); Phase 17a DONE (pedkindraw S33: win-builder
R-devel 398 s, R86); Phase 17b DONE (pedkindraw S34: six name rulings, 17c in three sessions, R87-R93); Phase
17c1 DONE (pedkindraw S35: `kinship(id, sire, dam, pdepth, ...)` and its `pdepth` check, R87, R91, R92); Phase
17c2 DONE (pedkindraw S36: the pedigree argument is `ped` in four more exports, R88); Phase 17c3 DONE (pedkindraw
S37: the pedigree first in four exports, R89), so Phase 17c is DONE; Phase 17d DONE (pedkindraw S38: "Select by
id" lists the animals only, and a real id starting `__jog_` is refused, R94); Phase 17e DONE (pedkindraw S39: the
legend's lines have no arrowheads and their labels sit on white, R95).
**Next:** Phase 17f (the gaps document; `docs/planning/cran-submission-plan.md` section 6).
This copy is the live one; nprcgenekeepr's is frozen at its `3d262d628`, and its one standing duty there is section
5's last line.
**Measured at:** `03591fa1d` (the S1121 claim; `R/` and `tests/` identical to `8c2926388`).

---

## 1. Context

### 1.1 Purpose (Mark's words, S742, recorded in `BACKLOG.md`)

"A standalone near-equivalent of kinship2 carrying nprcgenekeepr's enhanced features --
particularly the pedigree drawing, annotation ability, and interactivity; nprcgenekeepr may
eventually consume it, but that is NOT the primary goal." The package is a sibling product
first, not an extraction nprcgenekeepr must depend on.

### 1.2 What changed since the earlier analyses

The scoping doc (`docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md`, S667) and the
gap analysis (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`, S741) are dated records.
Since then:

| Change | Evidence | Effect on this plan |
|---|---|---|
| The drawing is one exported, script-callable function: `drawPedigreeDiagram(layout, edgeStyle, onClick)` | `R/drawPedigreeDiagram.R:46` (S1030); the module's render is one call to it (`R/modPedigree.R:736-744`); the 8 `visNetwork::` drawing calls live in `R/drawPedigreeDiagram.R:103-239` (`:206` is a comment), the module keeps only `visNetworkOutput`/`renderVisNetwork` (`R/modPedigree.R:691,740`) | S742's "lift the decorations into a script-callable renderer" -- the one substantive new-work item -- is **done**. The renderer is copied, not built. |
| Deceased slash and up to four affected conditions per animal | `R/deceasedSlash.R` (S1028), `R/affectedConditions.R` (S1029) | Gap analysis Finding #3's two "kinship2-only rendering details" are down to one (the dashed repeat-arc convention). |
| The layout solver hands constraints to `quadprog::solve.QP.compact()` | S1060, `R/makePedigreeDiagramData.R` | The layout core is no longer "base R + stats only" (scoping doc §2.2): it needs `quadprog` and `Matrix`. |
| nprcgenekeepr 3.0.0, which ships `visNetwork` and the Diagram tab, is on CRAN (2026-11-01) | `BACKLOG.md` CRAN item | Scoping doc revisit condition 2 is met. |
| Mark lifted the delay on this item | S1117, 2026-11-02 | Revisit conditions 1 and 3 no longer hold it. |
| The layout engine has gone quiet | `git log --since=2026-09-03 -- R/makePedigreeDiagramData.R R/positionTreeApportion.R`: 29 commits in 60 days, 7 in the last 30, last 2026-10-27 (`499280c15`) | A copy taken now is unlikely to be overtaken weekly, as it would have been in September. |
| **kinship2 has a maintained continuation on Bioconductor: Pedixplorer** | Bioconductor page read 2026-11-02: Pedixplorer 1.8.0 (Bioconductor 3.23), "Routines to handle family data with a Pedigree object" (kinship2's own CRAN description, nearly word for word), maintainer Louis Le Nezet, citation names Le Nezet, Jason Sinnwell, Terry Therneau; in Bioconductor since 3.19; Artistic-2.0; imports `shiny`, `plotly`, `htmlwidgets`, `ggplot2`, `igraph`, `S4Vectors`, `quadprog`, `Matrix` and others | The S667 claim "nothing offers an interactive kinship2-parity drawing" must be re-tested: Pedixplorer has its own Shiny app and plotly drawing. The comparison (Phase 1-2) covers it. That it is kinship2's continuation is an inference from the description and authors, not a statement found on the page. |
| ggpedigree 1.2.0 (CRAN, 2026-05-30) absorbed kinship2's layout helpers and draws with `ggplot2` and `plotly` | CRAN page read 2026-11-02 ("Due to the impending deprecation of kinship2 ..." is ggpedigree's own wording; kinship2's CRAN page carries no such notice: 1.9.6.2, published 2025-09-04) | Third comparator. |

### 1.3 Constraints

- **Methodology boundary.** Sessions that work in the new repository write that repository's
  `SESSION_NOTES.md`, `HANDOFFS.md`, `CHANGELOG.md` (`SESSION_RUNNER.md` §Phase 0, session-notes boundary).
  Phases 1-4 ran in nprcgenekeepr (S1121-S1128); Phases 5 onward run in the new repository, pedkindraw's, which
  carries this plan from 2026-11-11 (R23): its sessions keep this plan and pedkindraw's `methodology/ROADMAP.md` and
  `methodology/BACKLOG.md` up to date.
- **Strict TDD** (`CLAUDE.md`) carries into the new repository's `CLAUDE.md`.
- **Blast radius:** at most 5 files per commit (`SAFEGUARDS.md`). Copy phases move dozens of files, so
  each is a series of checkpoint commits, never one large commit.
- **nprcgenekeepr is not changed by this plan** (Mark's "copy" ruling, §2) beyond its docs and
  `BACKLOG.md`.
- **License.** nprcgenekeepr is MIT (`LICENSE`: 2017-2026, R. Mark Sharp). Code the new package would
  copy includes ports from kinship2, which is GPL (>= 2) on CRAN: `shrinkPedigree()` and its helpers
  are "internal port[s] of kinship2's" `findUnavailable`, `excludeUnavailFounders`, `findAvailNonInform`,
  `findAvailAffected` (`R/shrinkPedigree.R:218-332`), and `kinship()`'s `chrtype = "x"` branch and MZ-twin
  correction are "ported from kinship2" (`R/kinship.R:62,85,145`); `kinship()` itself credits Terry
  Therneau's original code (`R/kinship.R:17,74`; Therneau is an `aut` in `DESCRIPTION`). Which license
  the new package can carry is Mark's decision at Phase 4; this plan records the facts and gives no legal
  opinion.
  **S1128:** the contract's section 3 found more: `kinship()`'s base is copied from Therneau's 2003 `kinship.s` (CRAN
  package `kinship`, GPL (>= 2)), and the layout solver's terms 1-2 and `comparePedigreeStructure()`'s mate-pair step
  are re-expressed from kinship2. Mark ruled R11 (§2): those parts are rewritten from the published methods.
  **S1149:** the rewrite exists (S1140; C2), so Mark ruled R14 (§2): MIT, as nprcgenekeepr.

---

## 2. Rulings

| # | Ruling | When | By |
|---|---|---|---|
| R1 | The package WILL be built; sibling product first, nprcgenekeepr adoption optional and later | S742 | Mark |
| R2 | Drawing surface IN (now: copy `drawPedigreeDiagram()`, already built) | S742 | Mark |
| R3 | Parity closers IN: export the shrink helpers and `bitSize`; port `familycheck` and `ibdMatrix`; user-suppliable layout hints. OUT: block-sparse `makekinship` | S742 | Mark |
| R4 | The work starts with an in-depth comparison, building on the existing ones | S1121 | Mark |
| R5 | Comparators: kinship2, Pedixplorer, ggpedigree | S1121 | Mark |
| R6 | The comparison includes timing, memory footprint and capacity | S1121 | Mark |
| R7 | Input style: **data frames** as nprcgenekeepr takes them (pedigree and twins table), **plus converters** from kinship2 `pedigree` and Pedixplorer `Pedigree` objects; kinship2 and Pedixplorer optional (Suggests), never required. Chosen from four prototypes' measured costs (comparison doc section 11); S742 and S1121 had left it open until a prototype of each existed | S1121, S1126 | Mark |
| R8 | Code home: **copy**. The new package starts from a copy; nprcgenekeepr is unchanged until Mark later decides to have it use the new package. Two copies meanwhile, under the drift rule (§5) | S1121 | Mark |
| R9 | Heavy colony tools stay in nprcgenekeepr: `qcStudbook()` and `groupAddAssign()` are not copied; the new package gets a short pedigree checker and a short unrelated-set finder, sized by the comparison | S1121 | Mark |
| R10 | Name: **pedkindraw** (checked free on CRAN incl. archived names, Bioconductor, GitHub) | S1128 | Mark |
| R11 | The parts derived from kinship2 or Therneau's `kinship` package (contract section 3) are rewritten from the published methods, results still matching nprcgenekeepr's; fallback: copy under GPL (>= 2), or ask the authors first. The license is ruled once the rewrite exists | S1128 | Mark |
| R12 | Repository `rmsharp/pedkindraw`, public, created empty by Claude | S1128 | Mark |
| R13 | The file readers stay out (32 outside packages instead of 47) | S1128 | Mark |
| C2 | R11's rewrite is done once, in nprcgenekeepr, by the clean-room process of `docs/planning/cleanroom-rewrite-plan.md`; pedkindraw copies the results like any other nprcgenekeepr code: Phase 7 after that plan's Phase 8, Phase 8 after its Phases 5 and 14, Phase 10 after its Phase 11 (its section 4.8) | S1130 | Mark |
| R14 | License: **MIT**, as nprcgenekeepr: `License: MIT + file LICENSE`, the `LICENSE` file naming R. Mark Sharp as copyright holder. Basis: all of pedkindraw's code is copied from nprcgenekeepr (C2), whose S1140 sweep found no file matching kinship2, kinship or Therneau's 2003 code, so R11's condition (the rewrite exists) is met. Consequence: Phase 12 writes `familyCheck()` and `ibdMatrix()` from kinship2's documentation, never its source (as R11 says). The `YEAR` line was not asked (nprcgenekeepr's reads 2017-2026). Picked over GPL (>= 2) and over holding for an outside check; Claude's recommendation | S1149 | Mark |
| R15 | Phase 5 runs in a local clone, `/Users/rmsharp/Development/pedkindraw` (Claude cloned the empty repository S1150), as **two sessions** Mark starts there: 5a the methodology files and `CLAUDE.md`, then 5b the R skeleton, test-first. 5b may **push once** to `rmsharp/pedkindraw` after a clean local `R CMD check --as-cran`, then reads the GitHub checks. Reason for the split: Claude Code reads `CLAUDE.md` only when a session starts (methodology `BOOTSTRAP.md`, First Session Checklist) | S1150 | Mark |
| R16 | Until pedkindraw is on CRAN, `R CMD check --as-cran` may give one NOTE, from "checking CRAN incoming feasibility", when its only content is the Maintainer line and "New submission"; any other NOTE fails (pedkindraw `CLAUDE.md`, Build / Test / Verify). Source: pedkindraw `methodology/CHANGELOG.md`, the S2 DONE entry | pedkindraw S2 | Mark |
| R17 | `LICENSE`'s `YEAR` line reads 2017-2026, as nprcgenekeepr's; Mark is the only person in `Authors@R` (others join with their code). Answers the two questions R14 and Phase 5 left open. Source: as R16 | pedkindraw S2 | Mark |
| R18 | The fix to the context-budget tool's paths waits for a session of its own (pedkindraw's `methodology/.context-budget.json` names `SESSION_NOTES.md` at the root, where pedkindraw keeps it in `methodology/`, so its `methodology/context_budget.py --status` reports it "file does not exist"); it is an item in pedkindraw's `methodology/BACKLOG.md`. Source: as R16 | pedkindraw S2 | Mark |
| R19 | Phase 6 is split into two sessions: **6a**, the 10 relationship functions (DONE pedkindraw S3), and **6b**, the 11 that repair and trim pedigrees (Phase 6's rows below list both). Source: pedkindraw `methodology/CHANGELOG.md`, the S3 DONE entry | pedkindraw S3 | Mark |
| R20 | `toCharacter()` is not copied: R13 leaves it out with the readers, the only functions that reach it. Settles the conflict between R13 and the Phase 6 row, which listed it. Source: as R19 | pedkindraw S3 | Mark |
| R21 | The sample pedigrees the copied tests use are saved test fixtures (pedkindraw's `tools/makeTestFixtures.R` writes them to its `tests/testthat/fixtures/`; so far `lacy1989Ped`, `smallPed`), not package datasets; help-page examples type in their own small pedigree. Source: as R19 | pedkindraw S3 | Mark |
| R22 | Where a copied test calls `stringi`, it uses base R instead, with identical values (checked when copied), so pedkindraw does not need `stringi`; the test file's header names the change. Source: as R19 (which records the change), and pedkindraw S3's notes as committed at pedkindraw `82337ff` (`methodology/SESSION_NOTES.md`, "Mark's picks"), which record it as Mark's | pedkindraw S3 | Mark |
| R23 | This plan's home is pedkindraw's repository from 2026-11-11: its sessions follow it and update it there, and nprcgenekeepr's copies are frozen at its `3d262d628`. Five documents are copied (this plan, the contract and the three studies in `docs/research/`); open work goes in pedkindraw's `methodology/BACKLOG.md`, not GitHub issues. The move: pedkindraw's `docs/planning/planning-handover-plan.md`. Source: pedkindraw `methodology/CHANGELOG.md`, the S3 hand-off entry (Mark's direction, his words) and the S4 DONE entry | pedkindraw S3-S4 | Mark |
| R24 | The 10 tests in Phase 6b's test files that test nprcgenekeepr's studbook checks (`qcStudbook()`, `runQcStudbook()`, `convertDate()`, `removeDuplicates()`), which pedkindraw does not copy, are left out; each test file's header names the blocks left out and why. Source: pedkindraw `methodology/CHANGELOG.md`, the S7 DONE entry (Mark's pre-RED pick, "Leave out, list") | pedkindraw S7 | Mark |
| R25 | `sexCodes`, nprcgenekeepr's internal constant of the four sex letters (`R/sexCodes.R`), is copied in Phase 6b, which the 6b row did not list: `addParents()` and `correctParentSex()` read it (so do Phase 7's `kinship()` and Phase 8's `makePedigreeDiagramData.R`). Of `tests/testthat/test_sexCodes.R` only the test of the four values is copied; its four tests that scan `R/` for bare sex letters are left out (their allowlist names nprcgenekeepr files). Source: as R24 (Mark's pre-RED pick, "File + its value test") | pedkindraw S7 | Mark |
| R26 | Phase 7 copies 34 of the 102 tests in its 9 nprcgenekeepr test files: all of `test_checkTwinRelations.R` (10) and `test_kinship.R` (18), 5 of `test_kinshipHasBothParentsHelp.R` (3 X-chromosome kinship tests, 2 `hasBothParents()` tests, which make nprcgenekeepr's `pedOne` a fixture, R21) and the C11 test of `test_kinshipMemoryEquivalence.R` (with `outcome()` from its `helper-perfCampaign.R`). Left out, each file's header naming them: the 52 tests of five files that test only nprcgenekeepr functions (`test_kinshipForAnimals.R`, `test_kinshipForConsumers.R`, `test_kinshipMatricesToKValues.R`, `test_kinshipMatrixToKValues.R`, `test_kinshipOverrideDocs.R`), 5 help-wording tests, 3 that compare with nprcgenekeepr's saved `cleanroom/` data, and 8 of nprcgenekeepr-only functions. Source: pedkindraw `methodology/CHANGELOG.md`, the S8 DONE entry (Mark's pre-RED pick, "34 behavior tests") | pedkindraw S8 | Mark |
| R27 | Matrix is declared by `Imports: Matrix` and one roxygen line in `R/kinship.R`, `@importClassesFrom Matrix ddiMatrix dgCMatrix`. `kinship()` reaches Matrix only through `asNamespace("Matrix")`, which `R CMD check` does not count as a use (`tools:::.check_packages_used`), so the Imports line alone gives the NOTE "Namespace in Imports field not imported from" (nprcgenekeepr escapes it only through another file's `Matrix::colMeans`). Consequence: Matrix loads with pedkindraw. Phase 7 also imports `methods` and `stats`, their first uses. Source: as R26 (Mark's pre-RED pick, "Import the 2 classes") | pedkindraw S8 | Mark |
| R28 | `kinship2` and `withr` enter Suggests in Phase 7, for tests only: `kinship2` for the test that compares `kinship()`'s X-chromosome result with `kinship2::kinship()` (it skips without kinship2; the contract already listed it), `withr` for the C11 test's `with_seed()`. Source: as R26 (Mark's pre-RED pick, "Add kinship2 and withr", given after he asked why kinship2) | pedkindraw S8 | Mark |
| R29 | pedkindraw stays on testthat edition 3, and nprcgenekeepr will move to edition 3 too (Mark's words, S8: "consider using version 3 of testthat with the understanding that nprcgenekeepr is going to convert to use of v. 3 as well"). nprcgenekeepr's tests run on edition 2 today (its `DESCRIPTION` names no edition), so a copied test can behave differently here; such a test is changed the edition-3 way and the change named in its header. The first (S8): `hasBothParents()` warns twice for 3 IDs, and edition 3's `expect_warning()` catches one, so two `expect_warning()` calls expect both. Source: as R26 (Mark's RED pick, "Expect both warnings") | pedkindraw S8 | Mark |
| R30 | Phase 8's two sessions split its tests, not its code: `makePedigreeMatingLayout()` and `makePedigreeDiagramData()` reach 53 of the 65 objects in the row's seven files, all of `makePedigreeDiagramData.R` among them, so the layout code is copied in one session, and a test copied after its code would pass at once. The first session (pedkindraw S9) copies all the layout code and all its tests (13 files); the second copies `comparePedigreeStructure.R` and its tests (the kinship2 comparison, reached by no export, so its tests fail first too), adds the layout cases to the fidelity tool, pushes and reads CI. Source: pedkindraw `methodology/CHANGELOG.md`, the S9 entry (Mark's split pick, "All layout now", over the row's "engine then collisions/waypoints tests") | pedkindraw S9 | Mark |
| R31 | Of Phase 8's copied tests, the 3 in `test_positionMatingUnitForest.R` that draw the layout in Chrome (`getLiveRenderedPositions()`, `helper-live-render-positions.R`) are copied in Phase 9 with the drawing code; the 2 in `test_diagramSolverEquivalence.R` that read nprcgenekeepr's saved clean-room results (`cleanroom/spec/C`, not in its package) and the file `test_perfBudget_diagramSolver.R` (nprcgenekeepr's timing harness, `tools/perf/`, and its `BACKLOG.md`) stay in nprcgenekeepr, as R24 and R26 left out its other nprcgenekeepr-only tests. Source: as R30 (Mark's pre-RED pick, "Chrome 3 to Phase 9") | pedkindraw S9 | Mark |
| R32 | `deceasedSlash.R` and three functions of `affectedConditions.R` (`.conditionSectionsHandler()`, `.diagramAfterDrawing()`, `.diagramHeight()`) move from Phase 8 to Phase 9: only `drawPedigreeDiagram()` uses them, and their tests are in `test_drawPedigreeDiagram.R`. Phase 8 copies `affectedConditions.R`'s lines 1-75, the four pieces the layout uses; `DIVERGENCE.md` records the three deferred functions until Phase 9 copies them. Source: as R30 (Mark's pre-RED pick, "Move them to Phase 9") | pedkindraw S9 | Mark |
| R33 | A copied test that warns in nprcgenekeepr too handles the warning the way its own file already does, so the suite keeps WARN 0 (gate `test-suite-warnings-zero`). The first (S9): two tests in `test_makePedigreeMatingLayout.R` lay out the QC'd rhesus pedigree and let "same-row edge-node collision(s) could not be fully resolved" through (nprcgenekeepr's own run of the file at `baef1e12c` shows the same 2 warnings); they now use the `withCallingHandlers()` block of the file's source lines 820-826. Five tests in the same file were changed under R29 (the layout assigned inside `expect_message()`). Source: as R30 (Mark's GREEN pick, "Edition fix + file's pattern") | pedkindraw S9 | Mark |
| R34 | Phase 9 copies `R/drawPedigreeDiagram.R` from nprcgenekeepr `471589138`, not `baef1e12c`: that commit (its S1153) moved the `onClick` check into `.checkOnClick()`, shared with its `drawColonyOverview()`, with the same message and call (its own record of both functions' errors before and after), and the file is unchanged from there to `4375e2715`. `deceasedSlash.R` and `affectedConditions.R` still come from `baef1e12c` (unchanged since). Each file's header names its own commit, and both tools check each file against it, so the results tool runs against nprcgenekeepr's current checkout and `DIVERGENCE.md` needs no row (a copy at `baef1e12c` would need two, and the results tool would refuse the clone). Source: pedkindraw `methodology/CHANGELOG.md`, the S11 entry (Mark's pre-RED pick, "The newer version") | pedkindraw S11 | Mark |
| R35 | Phase 9 copies 12 of the 16 tests in `test_drawPedigreeDiagram.R` (its source lines 1-267). The other 4 (source lines 269-349) test nprcgenekeepr's Shiny module (`modPedigreeServer`, `diagramLayout()`, `.currentEdgeStyle()`, and a read of `R/modPedigree.R`), and `test_drawPedigreeDiagramDocs.R` (4 tests) checks nprcgenekeepr's tutorial, article and `_pkgdown.yml` text; pedkindraw has neither, so they stay in nprcgenekeepr, as R24, R26 and R31 left out its other nprcgenekeepr-only tests. The 4 are the tests' only `shiny::` calls, so `shiny` is not in Suggests; `htmlwidgets` is, beside the row's `chromote` (the live-render helper calls `htmlwidgets::saveWidget()`). Source: as R34 (Mark's pre-RED pick, "Leave them out") | pedkindraw S11 | Mark |
| R36 | `drawPedigreeDiagram()`'s help text describes the function alone: the sentences that name nprcgenekeepr's Shiny application or its Pedigree Browser's Diagram tab are rewritten, and the example types its own pedigree (R21). The code is unchanged; the file's header lists each changed sentence. Source: as R34 (Mark's pre-RED pick, "Rewrite those sentences") | pedkindraw S11 | Mark |
| R37 | A change nprcgenekeepr makes to a function while pedkindraw is copying it does not move the copy: the copy keeps its ruled commit and the change is ported later under the drift rule (section 5). The first (pedkindraw S11): nprcgenekeepr's S1159 began filling the five sex rows of `drawPedigreeDiagram()`'s legend white (`color.background`; its RED `392dd347e`, its code `a85311021`, both committed during S11). Phase 9 finishes on `471589138` (R34); porting S1159's change, its tests and code, is a backlog item for a pedkindraw session of its own, and `DIVERGENCE.md` records it until then (its row added in S11). `tools/compareResultsWithNprcgenekeepr.R` takes an optional commit and then loads nprcgenekeepr's package files at that commit from `git archive`, still in the clone's folder and renv, so another session's uncommitted edits there do not stop the check (the pedigrees still come from the clone's folder: its synthetic ones are files git ignores). Ported in pedkindraw S12 (Mark's orient pick, "Port the legend fix"), test-first in nprcgenekeepr's own three steps: RED `392dd347e`, GREEN `a85311021` and REFACTOR `4283e3502` (the legend built from three small tables, the widget unchanged; committed after S11's close-out); the copy is at `4283e3502` and the row is deleted. Source: as R34 (Mark's GREEN pick, "Finish on 471589138") | pedkindraw S11 | Mark |
| R38 | Phase 10 copies all 24 tests of `test_shrinkPedigree.R`. The 3 other nprcgenekeepr test files that name `shrinkPedigree()` test nprcgenekeepr's own records, not the function: `test_cleanroomProvenance.R` (its lines 30 and 33) checks the files of its clean-room `cleanroom/` folder, and `test_inventoryTutorialSections.R` (lines 10 and 137) and `test_snapshotTutorialSection.R` (line 11) check its tutorial. pedkindraw has neither, so they stay in nprcgenekeepr, as R35 left out its app and documentation tests. Source: pedkindraw `methodology/CHANGELOG.md`, the S13 entries (Mark's pre-RED pick, "Leave them out") | pedkindraw S13 | Mark |
| R39 | The stand-in for `shrinkPedigree()` (`tests/testthat/helper-shrinkPedigreeStandIn.R`, pedkindraw S9) is deleted in Phase 10's RED, with the copied tests, so they fail because the function is missing and not on the stand-in's own error; so do the 3 copied Phase 8 tests that shrink the 16-animal "Track B" pedigree (one each in `test_solveJointQP.R`, `test_orderRootSubtrees.R` and `test_positionMatingUnitForest.R`, measured S13), which then check the real function from GREEN on. The stand-in's saved answer, `tests/testthat/fixtures/trackBShrunk.rds`, and the code of `tools/makeComputedTestFixtures.R` that writes it are deleted too: the copied tests' last test checks the same pedigree's result, and the results tool checks every shrink case against nprcgenekeepr. Source: as R38 (Mark's pre-RED picks, "With the copied tests" and "Delete both") | pedkindraw S13 | Mark |
| R40 | Phase 11's four exports, `bitSize()`, `findUnavailable()`, `findAvailNonInform()` and `findAvailAffected()`, are pedkindraw's own code, one file each, calling the internals of the copied `R/shrinkPedigree.R` (`.checkShrinkInput()`, `.removalPass()`, `.isParent()`, `.bitSize()`), which stays as copied (no `DIVERGENCE.md` row). Each gives `shrinkPedigree()`'s answer for its step: `findUnavailable(ped, genotyped)` the ids its first trim removes (`$idList$unavail`); `findAvailNonInform(ped, genotyped, affected = NULL)` the ids its second trim removes (`$idList$noninform`), the first trim run inside, so the whole pedigree is passed, the cascade (parents left as leaves) included; `findAvailAffected(ped, genotyped, affected, affstatus)` one removal of its third trim, among the genotyped non-parents whose affected status is `affstatus`, on the pedigree passed; `bitSize(ped)` its first bit size. Written from kinship2's help pages and the copied clean-room helpers, kinship2's source not read (R11). Measured pre-RED in a scratch prototype: repeated `findAvailAffected()` calls from the result of `shrinkPedigree(maxBits = Inf)` reproduce its third trim (ids, bit sizes, final pedigree) in 24 of 24 cases (4 fixture pedigrees, 3 genotyped patterns, 2 budgets); kinship2's own `findAvailNonInform()`, one pass without the cascade, differs from the second trim in 19 of 24. Picked over kinship2's single steps. Source: pedkindraw `methodology/CHANGELOG.md`, the S14 entries (Mark's pre-RED pick, "Same as shrinkPedigree()") | pedkindraw S14 | Mark |
| R41 | Phase 11's return shapes and errors (contract section 4.3 updated): `bitSize()` a list `bitSize`, `nFounder`, `nNonFounder`, as kinship2's; `findUnavailable()` and `findAvailNonInform()` character ids in removal order, `character(0)` when none; `findAvailAffected()` always the list of kinship2's four names, `ped` (the pedigree after the removal, a promoted founder's `sire` and `dam` blanked as `shrinkPedigree()` does), `idTrimmed` (every id removed, the cascade included), `isTrimmed` (`FALSE` when no animal of that status can be removed: `ped` unchanged, `idTrimmed` empty) and `bitSize`, where the contract had `removed` and the other fields only when trimmed. Errors: `shrinkPedigree()`'s messages (`.checkShrinkInput()`; `bitSize()` its pedigree checks), plus one for an `affstatus` that is not `NA`, `FALSE` or `TRUE`. Source: as R40 (Mark's pre-RED pick, "kinship2's shapes") | pedkindraw S14 | Mark |
| R42 | Phase 11's DONE criteria (this plan stated none for Phases 11-15): new test files, one per function, testing every error; each function `identical()` to `shrinkPedigree()`'s answer for its step on the fixture pedigrees under several genotyped patterns; repeated `findAvailAffected()` calls reproducing its third trim; and, skipped without kinship2 (R7, R28), `bitSize()` equal to `kinship2::bitSize()` (measured equal on all 6 fixture pedigrees that have both parents or neither) and the first two trims' ids together equal to `kinship2::pedigree.shrink()`'s (24 of 24 measured; one trim at a time they differ in 2. Corrected pedkindraw S14, before RED: when the first trim removes an ungenotyped founder couple, its child becomes a founder, and `shrinkPedigree()`'s first trim removes in the same pass that child's own couple if it now qualifies and its child's row comes later; kinship2's `findUnavailable()` leaves that couple, and the founder it promotes, to its second trim. Reproduced on a 7-animal typed pedigree: 7 ids in `shrinkPedigree()`'s first trim, kinship2's first trim 4 and second 3; with the rows reordered `shrinkPedigree()` splits them as kinship2 does). Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new files; push; CI 5/5; contract 4.3 updated; "Done 11" here. The help pages name where kinship2 differs (no animal genotyped: kinship2 stops, these return every id; the trim difference above; ties by byte order, C16; one known parent allowed). Surface: this Mac and CI's five jobs; the kinship2 tests run wherever kinship2 is installed (CI installs Suggests). Source: as R40 (Mark's pre-RED pick, "shrinkPedigree + kinship2") | pedkindraw S14 | Mark |
| R43 | Phase 12 takes two sessions: `familyCheck()` first (pedkindraw S15), `ibdMatrix()` next (Mark's scope pick, "familyCheck() now"). `familyCheck(famid, id, sire, dam, newfam)` is pedkindraw's own code in `R/familyCheck.R`, with an internal helper that numbers the family trees: animals joined by a parent link whose parent has a row share a number, numbered 1, 2, ... in the order of their first row, and an animal with no such link gets 0 (kinship2's `makefamid()` convention, from its help page; the scratch prototype's numbers `identical()` to `makefamid()`'s on all 9 fixture pedigrees). Written from kinship2's help pages (`familycheck`, `makefamid`) and its measured results, its source not read (R11, R14). `join` counts another family once for each family tree the two share, which is what kinship2 returns (its help page's wording, "number of other families ... joined to this one", reads as once per family): the prototype matched `kinship2::familycheck()` in 274 of 274 cases where kinship2 returns (86 on the 9 fixture pedigrees with mislabelled family ids, 188 random families); counting each family once differs in 90 of the 274. Source: pedkindraw `methodology/CHANGELOG.md`, the S15 entries (Mark's pre-RED pick, "kinship2's numbers") | pedkindraw S15 | Mark |
| R44 | `familyCheck()`'s return shape and errors (contract section 4.3 updated): a data frame, one row per family id (sorted: character ids in byte order, C16; numbers by value), columns `famid` (the input's type, a factor's as character), `n`, `unrelated`, `split` and `join`, the counts integer; when any `join` is above 0, an attribute `join`, an integer matrix with a row per joined family id and a column per family tree their animals belong to, named by tree number (kinship2 leaves the columns unnamed), each entry the number of that family's animals in that tree. Unknown parents are `NA`; a parent id with no row links no one, as in kinship2 (measured), so kinship2's `0` or `""` codes give its answers. Stops on vectors of unequal length, an `NA` family id, an `NA` or duplicate id (kinship2 accepts duplicates), and a `newfam` of the wrong length or with an `NA`. `newfam` is kept so code written for kinship2 still runs: a tree number per animal, 0 for one related to no one, used as given (kinship2 checks only its length). It answers where kinship2 fails: when every join lies within one family tree (kinship2 stopped in all 227 such cases of 463 measured, and in none of the other 236), and on empty input (zero rows; kinship2 stops). An animal that is its own ancestor does not stop it (kinship2 stopped on `sample.ped`'s loop but not on a 3-animal one; Phase 13's `checkPedigree()` reports cycles). Source: as R43 (Mark's picks "Plain stops, no kinship2 failures" and "Keep it") | pedkindraw S15 | Mark |
| R45 | `familyCheck()`'s DONE criteria (this plan stated none for Phases 11-15): a new test file, `tests/testthat/test_familyCheck.R`, with typed pedigrees for each column, a split, joins, the join table, every error and each case kinship2 fails on; and, skipped without kinship2 (R7, R28), `familyCheck()` equal to `kinship2::familycheck()` (family ids compared as character, counts as integer, the join table without its column names) on the 9 fixture pedigrees with mislabelled family ids and on seeded random families, wherever kinship2 returns. Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new file; push; CI 5/5; contract 4.3 updated; a "Done 12 (`familyCheck()`)" record here. Surface: this Mac and CI's five jobs; the kinship2 tests run wherever kinship2 is installed (CI installs Suggests). Source: as R43 (Mark's pick "Tests + kinship2 check") | pedkindraw S15 | Mark |
| R46 | Phase 12's second session (pedkindraw S16) writes `ibdMatrix(id1, id2, x, idmap, diagonal)`, kinship2's arguments, as pedkindraw's own code in `R/ibdMatrix.R`, from kinship2's help page (`ibdMatrix`) and its measured results, its source not read (R11, R14); it completes Phase 12. It returns kinship2's class, a `dsCMatrix` (symmetric, the upper triangle stored, `uplo` `"U"` always), with one row and column per id in `id1` or `id2`: numbers sorted by value, character ids in byte order (C16), factor ids read as character, names the ids as character. `idmap`, as the help describes it (kinship2 refused it in every form tried): column 1 the ids as found in `id1` and `id2`, column 2 the names for the result; the rows then follow the internal ids' order (SOLAR numbers families together) and carry column 2's names; ids in `idmap` but not in the pairs add no row. A value of 0 is not stored; other values are kept as given (kinship2 keeps 1.5 and -0.5). Measured on kinship2 1.9.6.2 (scratch runs, one process per case under `timeout 15`, Learning 19): its order of the ids given differs from this one (numbers by value, byte order) in 66 of the 186 random cases where it returns (corrected pedkindraw S16, before GREEN: first written here as "the ids that share a pair first, then the ids with only a diagonal entry", a rule read from three cases that holds in 172 of the 186); for some number ids it gives a row for every number from 1 to the largest, empty for those not given (ids 1 and 3 give 3 x 3; 7 of 47 random small-number cases, rows 1 to the largest in all 7); it stores the lower triangle when only diagonal entries are stored. A scratch prototype's values equal kinship2's at every id in 186 of 186 random cases where kinship2 returns. Picked over kinship2's rows and over a `dgCMatrix` like `kinship()`'s. Source: pedkindraw `methodology/CHANGELOG.md`, the S16 entries (Mark's pre-RED pick, "Ids given, sorted") | pedkindraw S16 | Mark |
| R47 | `ibdMatrix()`'s errors (contract section 4.3 updated). It stops, naming the ids, when an id has no diagonal value and `diagonal` is not given: kinship2's help says the diagonal will be 1, and on 40 random such cases kinship2 returned a 0 diagonal in 33 and never returned in 7 (killed at 15 s). `diagonal` fills only the missing diagonal entries (a given one is kept, as kinship2 does). Plain stops, where kinship2 is silent or stops with an internal message, for: vectors of unequal length (kinship2 recycles them with only a warning); one pair, in either order, given two different values (kinship2 keeps the first silently; the same value twice is kept once, as kinship2 does); an `NA` id; a value that is `NA`, not finite or not a number (kinship2 returns a logical matrix for logical values); a table as `id1` (data frame or matrix) without 3 columns, or with `id2` or `x` also given; an `idmap` that is not a 2-column matrix or data frame, has an `NA`, lists an id twice, gives two ids one name, or lacks an id used in the pairs; a `diagonal` that is not one finite number. Empty input gives a 0 x 0 `dsCMatrix` (kinship2: a 1 x 1 matrix named `NA`, with warnings). Source: as R46 (Mark's picks "Stop, name the ids" and "Stop on each") | pedkindraw S16 | Mark |
| R48 | `ibdMatrix()`'s DONE criteria: a new test file, `tests/testthat/test_ibdMatrix.R`, with typed cases for each rule of R46 and every error of R47; and, skipped without kinship2 (R7, R28), `ibdMatrix()` equal to `kinship2::ibdMatrix()` at every id (as base matrices, rows and columns matched by name, the empty rows kinship2 adds dropped) on seeded random cases where every id has a diagonal value or `diagonal` is given, wherever kinship2 returns, with a floor on the cases compared (`expect_gte()`). kinship2 returned or stopped on all 160 such cases measured and hung on none; its 7 stops (an internal `Matrix` error, all with numeric ids) are skipped. Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new file; push; CI 5/5; contract 4.3 updated; a "Done 12" record here. Surface: this Mac and CI's five jobs; the kinship2 tests run wherever kinship2 is installed (CI installs Suggests). Source: as R46 (Mark's pick "Tests + kinship2 check") | pedkindraw S16 | Mark |
| R49 | Phase 13 takes two sessions: `checkPedigree()` first (pedkindraw S17), `findUnrelated()` next (Mark's scope pick, "checkPedigree() now"). `checkPedigree(ped)` is pedkindraw's own new code in `R/checkPedigree.R` (R9), derived from no other package: it lists a pedigree's problems and never repairs them (repair stays the user's step with `addParents()` and `correctParentSex()`, contract 4.4). Measured before the picker on a scratch prototype: on 300 seeded random pedigrees of 6 to 40 animals, each with none or one or two of 13 kinds of problem put in, its check and id rows, in order, equal those of a slow checker written from each check's definition (R50) in 300 of 300, every check of R50 present in at least 10 cases; 0 rows on the 42 cases with nothing put in and on 7 of the 9 fixture pedigrees (`pedOne`: a male dam and a female sire; `pedSix`: 4 parents with no row); on kinship2's `sample.ped` one row, `"0"` as the unknown parent of its founders; 0.17 s on 100,000 animals (the comparison's `synthetic_100000`), 0.21 s with 5 cycles put in near its top. kinship2 1.9.6.2's `pedigree()` on single-problem cases (15 per kind, each under a 10 s limit, all returned or stopped): it refuses duplicate ids, a wrong-sex parent, a parent of unknown sex (an `H` parent included), an id used as both sire and dam, a parent with no row, an `NA` or blank id, `"0"` as a parent code and one known parent; it accepts cycles, own parents and `""` as a parent code (its `missid`). Source: pedkindraw `methodology/CHANGELOG.md`, the S17 entries (Mark's scope pick) | pedkindraw S17 | Mark |
| R50 | `checkPedigree()`'s return shape and checks (contract 4.4 updated). A data frame of three character columns, `check`, `id` and `detail`, one row per problem id, zero rows when clean; the checks in the order below, and within a check the ids in byte order (C16) unless stated; an animal can appear under several checks. `id`, `sire`, `dam` and `sex` are read as character (a factor's labels, numbers as text). The eleven checks: `missingIds`, a row whose id is `NA`, empty or spaces only (one row per such input row, in row order, `id` as given, `detail` its row); `duplicateIds`, an id on more than one row (`detail` the rows); `ownParent`, an animal that is its own sire or dam; `cycle`, an animal that is its own ancestor through at least one other animal, parents followed only through ids that have a row (`detail` the other animals that are both its ancestors and its descendants); `rowlessParents`, a sire or dam value, not a code, that is no row's id; `missingParentCodes`, a sire or dam value that is `"0"`, `"NA"`, or empty or spaces only and is no row's id (a code value that has a row is a real parent), one row per code; `maleDams`, a dam with a row whose sex is `M`; `femaleSires`, a sire with a row whose sex is `F`; `unknownSexParents`, a sire or dam with a row whose sex is `U` or `NA` (an `H` parent is legal and not reported, as `correctParentSex()` keeps its sex); `sireAndDam`, one id, not a code, used both as a sire and as a dam; `sexCodes`, a row whose sex is not `NA`, `M`, `F`, `H` or `U` (such as `"male"`; one row per such input row, in row order). A parent's sex is its first row's. Without a `sex` column the four sex checks give no rows. For a parent, `detail` lists its offspring, ten at most and then a count ("sire of B, C; dam of D"). `missingIds` and `sexCodes` are added to the contract's nine (Mark's pick "Add two checks": kinship2 refused all 15 single cases of an `NA` or blank id; in 10 of 300 random cases a parent with a sex like `"male"` was reported by none of the nine). Legal and not reported: one known parent, unknown sex of an animal that is no parent, `H`, numeric ids. It stops only when `ped` is not a data frame or lacks `id`, `sire` or `dam` (naming the missing columns). Measured differences from kinship2: it reports cycles, own parents and `""` parent codes, which kinship2 accepts, and does not report one known parent or an `H` parent, which kinship2 refuses. Source: as R49 (Mark's picks "One row per problem id", "Add two checks" and "\"0\", blank and \"NA\"") | pedkindraw S17 | Mark |
| R51 | `checkPedigree()`'s DONE criteria: a new test file, `tests/testthat/test_checkPedigree.R`, and its helper `helper-checkPedigree.R`, with typed cases for each check of R50 and each error; the fixture pedigrees giving 0 rows (`pedOne` and `pedSix` their measured rows); after `addParents()` and `correctParentSex()`, no `rowlessParents`, `maleDams` or `femaleSires` rows; on 300 seeded random pedigrees, `check` and `id` equal to the slow checker's (300 of 300 measured); and, skipped without kinship2 (R7, R28), wherever kinship2's `pedigree()` refuses, `checkPedigree()` names that problem, and wherever kinship2 accepts, it names none of the problems kinship2 refuses (nor a code other than `""`), setting aside the cases where kinship2 stops on one known parent, a parent's sex is `H` or a sex is outside `M`, `F`, `H` and `U`: measured 224 of the 300 compared, 224 agreeing (154 refusals, 70 acceptances), with a floor of 220 compared (`expect_gte()`). Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new file; push; CI 5/5; contract 4.4 updated; a "Done 13 (`checkPedigree()`)" record here. Surface: this Mac and CI's five jobs; the kinship2 tests run wherever kinship2 is installed (CI installs Suggests). Source: as R49 (Mark's pick "Tests, slow version, kinship2") | pedkindraw S17 | Mark |
| R52 | Phase 13's second session (pedkindraw S18) writes `findUnrelated(ped, genotyped)` as pedkindraw's own new code in `R/findUnrelated.R` (R9), from kinship2's help page (`pedigree.unrelated`) and its measured results, its source not read (R11, R14); it completes Phase 13. Two animals are related when they share an ancestor or one descends from the other, found through founders (an animal with no known parent): every ancestor is a founder or has one above it, so two animals are related exactly when their founder ancestors meet ("Shared ancestors", picked over the copied `kinship()`). Measured before the picker on a scratch prototype: the related pairs equal `kinship()` above 0 in every pair of 350 cases (300 seeded random pedigrees of 6 to 200 animals, 10 to 100% genotyped; 5 seeded 30% draws on each of 10 fixture pedigrees, `examplePedigree`'s 3,694 animals and `smallPed`'s one-parent animals included) and on the comparison's `synthetic_1000` and `synthetic_10000`, 0 pairs differing. With 30% genotyped (the comparison's seed-42 draw) it took 0.5 s at 10,000 animals (`kinship()` alone 2.9 s and 800 MB; kinship2's `pedigree.unrelated()` 6.7-7.0 s here, 6.53 s in the comparison), 2.5 s at 30,000 and 10.7 s at 100,000 (8.5 GB peak), where kinship2 and Pedixplorer ran out of memory at 30,000 (comparison section 7). kinship2 1.9.6.2 on the comparison's three cases (`sample.ped`'s families 1 and 2 with their own `avail`; `rhesus375` with 30% available after `set.seed(42L)`, whose rows are those of pedkindraw's `obfuscated_rhesus_mhc_ped.csv` fixture in the same order), seeds 1-100 each under a 30 s limit: sizes 4, 2 and 44 on every seed, every set valid (unrelated, nothing addable, all available), 18, 6 and 91 different sets; an exact search finds no larger set on any of the three. Source: pedkindraw `methodology/CHANGELOG.md`, the S18 entries (Mark's pre-RED pick "Shared ancestors") | pedkindraw S18 | Mark |
| R53 | `findUnrelated()`'s rule, return and errors (contract 4.4 updated). It returns the chosen ids as character, in byte order (C16); no genotyped animal gives `character(0)`. The pick: among the genotyped animals still in play, take the one related to the fewest of them (itself counted; the counts kept up to date as animals leave play), ties to the first id in byte order; take it and every animal related to it out of play; repeat until none is left. Then a swap pass: while a chosen animal has two left-out genotyped animals that are each related to it and to no other chosen animal, and unrelated to each other, put the first such pair (by chosen animal, then pair, in byte order) in its place, add by the same pick any animal now related to none chosen, and start again; stop when no swap is left. So every two chosen animals are unrelated, no genotyped animal can be added, no chosen animal can be traded for two, and the row order does not change the answer ("Fewest relatives, then swaps", picked over the pick alone). Measured on 1,292 seeded random pedigrees against an exact search for the largest set: the pick alone fell one short in 6, with the swap pass in 2 (counting relatives once, not kept up to date, in 12); with the swap pass, 138 at 10,000 animals, where kinship2 gave 137 on seeds 1-3, and never smaller than kinship2's largest over seeds 1-5 on the 297 random cases where kinship2 returned; the pass adds 0.16 s at 10,000 animals, 1.2 s at 30,000 and 22 s at 100,000. It stops, naming the animals, when `checkPedigree()` reports `missingIds`, `duplicateIds`, `ownParent`, `cycle`, `rowlessParents` (pointing to `addParents()`) or `missingParentCodes`: relatedness cannot be read from such a pedigree (`kinship()` stops on each; on a cycle the founder rule calls two related animals unrelated). The sex checks are ignored, since sex does not change who is related, and no `sex` column is needed ("Stop, name the problems", picked over counting a parent with no row as a founder and over stopping on every check). One known parent is legal, as in `checkPedigree()`. It also stops when `ped` is not a data frame or lacks `id`, `sire` or `dam` (as `checkPedigree()`), and when `genotyped` is not logical, not one value per row, or has an `NA` (kinship2's 0/1 `avail` is given as `avail == 1`). Source: as R52 (Mark's picks "Fewest relatives, then swaps" and "Stop, name the problems") | pedkindraw S18 | Mark |
| R54 | `findUnrelated()`'s DONE criteria: a new test file, `tests/testthat/test_findUnrelated.R`, and its helper `helper-findUnrelated.R`, with typed cases for each rule of R53 and each error; the comparison's three cases at 4, 2 and 44 (`sample.ped`'s families from kinship2, skipped without it; the rhesus fixture after `set.seed(42L)`); the same set when the rows are shuffled; on 300 seeded random pedigrees, a slow check written from the definition with `kinship()`: every two chosen animals have kinship 0, no genotyped animal left out has kinship 0 with all of them, and no chosen animal can be traded for two; and, skipped without kinship2 (R7, R28), the set at least as large as `kinship2::pedigree.unrelated()`'s (one seed per case, under a time limit) on the random cases where kinship2 returns, with a floor on the cases compared (`expect_gte()`). Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new file; the time on the comparison's `synthetic_10000` with 30% genotyped measured at GREEN against kinship2's 6.5 s (the file is in nprcgenekeepr's clone, so not a test); push; CI 5/5; contract 4.4 updated; a "Done 13" record here (Phase 13 DONE). Surface: this Mac and CI's five jobs; the kinship2 tests run wherever kinship2 is installed (CI installs Suggests). Source: as R52 (Mark's pick "Tests, slow check, kinship2") | pedkindraw S18 | Mark |
| R55 | Phase 14 takes two sessions: the `asPedFrame()` generic and kinship2's methods first (pedkindraw S19), Pedixplorer's method and Pedixplorer's install next (Mark's scope pick, "kinship2 now, Pedixplorer next"). Measured before the pick: Pedixplorer 1.8.0 (Bioconductor 3.23, the release for R 4.6) installed into a scratch library from ready-built binaries in 9 s; installing it into pedkindraw's renv library adds 47 packages (75 to about 122), 3 only on Bioconductor (Pedixplorer, S4Vectors, BiocGenerics), plus BiocManager and BiocVersion; a snapshot of a scratch copy records a top-level `"Bioconductor": {"Version": "3.23"}` and those packages as `Source: Bioconductor`, no existing entry changed; with Pedixplorer in Suggests and not installed, `R CMD check --as-cran` stops with an ERROR at "checking package dependencies" (CRAN incoming feasibility does not object to a Bioconductor Suggests). `asPedFrame(x, ...)` is pedkindraw's own new code in `R/asPedFrame.R` (R7), written from kinship2's `pedigree` help page and measured objects, its source not read (R11, R14). A kinship2 object is a plain list (`id`, `findex`, `mindex`, `sex`, `affected`, `status`, `relation`; a `pedigreeList` also `famid`), and one saved to a file and read back keeps its class, so kinship2's methods read it without calling kinship2 and do not need it installed ("No, read it directly"); contract 4.5's stop when the object's package is not installed applies to Pedixplorer's method only. Source: pedkindraw `methodology/CHANGELOG.md`, the S19 entries | pedkindraw S19 | Mark |
| R56 | The kinship2 methods' return and errors (contract 4.5 updated). A list of `ped` and `twinRelations`. `ped` is a data frame, one row per animal in the object's order (the order given to `pedigree()`, measured), row names 1 to n, columns `id`, `sire`, `dam`, `sex`, then `famid` for a `pedigreeList`, then the conditions, then `status`. `id`, `sire` and `dam` are character, an unknown parent (index 0) `NA`, each parent read by its own index so an unknown parent never moves another (the comparison's first defect, section 11.2); whole numbers written in full (`"100000"`, where `as.character()` gives `"1e+05"`: ids are never renamed); a factor's labels. `sex` is `M`, `F` or `U`, from male, female, unknown and terminated (kinship2 has no hermaphrodite). Conditions: a single `affected` vector becomes `affected`; a matrix's columns `affected_<column name>`, or `affected_1`, `affected_2` and so on when it has none; values as kinship2 holds them (0, 1, `NA`; kinship2 refuses others). `status`: 1 `DECEASED`, 0 `ALIVE` ("ALIVE"; kinship2 refuses `NA`). No condition or `status` column when the object has none. `twinRelations`: `id1`, `id2`, `code` (character `MZ twin`, `DZ twin`, `UZ twin`) from relation codes 1-3, whether kinship2 stored the code as a factor (numbers given) or a whole number (text given); code 4, spouse, left out; `NULL` when no twin row is left. A `pedigreeList` is converted whole, with `famid` as text, when no id repeats across families, and refused otherwise naming the repeated ids, ten at most, in byte order (C16) ("Accept if ids unique"); one family, `x["2"]`, is a `pedigree`. Errors: any other class, naming it; a `pedigree` or `pedigreeList` that lacks a field it needs, naming the fields. Measured on a scratch prototype: kinship2's `sample.ped` (2 families, 55 animals) and `minnbreast` (426 families, 28,081 animals) converted whole, every sire and dam equal to the data's (their unknown parent `0` read as `NA`); 0.022 s for `minnbreast`, 0.042 s for 100,000 animals. Source: as R55 (Mark's picks "Accept if ids unique", "ALIVE"). Phase 15c (pedkindraw S24; R62, R74-R76): the list gains a third element, `hints` | pedkindraw S19 | Mark |
| R57 | DONE criteria for kinship2's half of Phase 14 (pedkindraw S19): a new test file, `tests/testthat/test_asPedFrame.R`, and its helper `helper-asPedFrame.R`, with typed cases for each rule of R56 and each error, the comparison's required case among them (an unknown parent listed before known ones); a round trip: a pedigree data frame through `kinship2::pedigree()` and `asPedFrame()` comes back identical column by column, on the 9 fixture pedigrees (prepared only as far as kinship2 demands: a row for each parent with none, a made-up second parent for one known parent, parents' sex set by role) in 8 variants each (no condition, one, two named, two unnamed; each with and without status; the rhesus fixture with its twins file) and on 300 seeded random pedigrees: measured 372 of 372 identical, and all 372 differing with the unknown-parent defect planted; and `sample.ped` and `minnbreast` converted as family lists. Tests that build kinship2 objects skip without kinship2 (R7, R28); kinship2's warning "More than 25% of the gender values are 'unknown'" is expected, not left as WARN (Learning 10). Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of the new file; push; CI 5/5; contract 4.5 updated; a "Done 14 (kinship2)" record here; Phase 14 is DONE after Pedixplorer's session. Surface: this Mac and CI's five jobs (CI installs Suggests, kinship2 included). Source: as R55 (Mark's pick "Typed cases, round trip") | pedkindraw S19 | Mark |
| R58 | The Pedixplorer method's return and errors (pedkindraw S20; contract 4.5 updated). `asPedFrame.Pedigree()` takes Pedixplorer's S4 `Pedigree` object and reads it through Pedixplorer's accessors (`ped()`, `mcols()`, `fill()`, `border()`, `rel()`), so it stops, naming Pedixplorer, when Pedixplorer is not installed (R55); an object of class `Pedigree` that is not an S4 object is refused as any other class is, naming it, and the default method's message names Pedixplorer's `Pedigree` beside kinship2's classes. `ped`: one row per animal in the object's order (founders listed after offspring stay there, measured), row names 1 to n. `id`, `sire`, `dam` character as Pedixplorer holds them, an unknown parent `NA`; with families each is `<famid>_<id>`, as the object holds it, and never refused ("Ids as Pedixplorer holds them"; Pedixplorer's ids are unique). `sex`: male `M`, female `F`, unknown `U` (Pedixplorer has no hermaphrodite; `H` given to it becomes unknown). `famid` as text when any animal has one. Conditions: each condition of `fill(x)`, in its order, whose `<name>_mods` column has a known value (0, 1, `NA`; Pedixplorer splits a number at its threshold), named `affected` for Pedixplorer's default `affection` (the name it gives a column `affected`), the name itself when it starts with `affected`, and `affected_<name>` otherwise ("'affection' -> 'affected'"); a condition with no known value is none (the comparison's required case: an object built with no condition holds an all-`NA` `affection`). `status` from `deceased`: `TRUE` `DECEASED`, `FALSE` `ALIVE`, `NA` `NA`, and no column when every value is unknown ("Unknown stays blank"). Then each of Pedixplorer's fields `fertility`, `miscarriage`, `avail`, `evaluated`, `consultand`, `proband`, `carrier`, `asymptomatic`, `adopted`, `dateofbirth`, `dateofdeath` under its own name and type when any value differs from what Pedixplorer fills in when none is given (`fertile`; `FALSE` for `miscarriage`, `evaluated`, `consultand`, `proband`, `adopted`; `NA` for the rest) ("Keep fields with data"; Pedixplorer moves `birth` and `dob` into `dateofbirth`, as text); then the object's extra columns from `mcols(x)`, types kept, less Pedixplorer's own (`error`, each condition's raw and `_mods` columns, `avail_mods`). A column name that would appear twice (an extra column named `sire`, say) stops, naming it: the prototype, before the rule, let it replace the parents silently. `twinRelations`: the `MZ twin`, `DZ twin` and `UZ twin` rows of `rel(x)`, ids as held, `Spouse` left out, `NULL` when none is left. Measured on a scratch prototype: 9 fixture pedigrees in 12 variants (108) and 300 seeded random pedigrees, through `Pedigree()` and back, all identical, so the fields rule held on all 408 objects; with the all-`NA` condition kept (the comparison's defect planted), all 136 cases built without a condition differ; 100,000 animals converted in 0.005 s (`Pedigree()` took 6.6 s); Pedixplorer refuses a twin pair with unknown parents (the rhesus fixture's `UZ twin` pair, as the comparison found) and an empty object carries an `mcols` column `X` of its own. Source: pedkindraw `methodology/CHANGELOG.md`, the S20 entries (Mark's picks "Keep fields with data", "'affection' -> 'affected'", "Ids as Pedixplorer holds them", "Unknown stays blank"). Phase 15c (pedkindraw S24; R62, R74-R76): the list gains a third element, `hints` | pedkindraw S20 | Mark |
| R59 | DONE criteria for Pedixplorer's half of Phase 14 (pedkindraw S20): a new test file, `tests/testthat/test_asPedFramePedixplorer.R`, and its helper `helper-asPedFramePedixplorer.R`, with typed cases for each rule of R58 and each error, the required all-`NA` case among them; the not-installed stop and the non-S4 refusal run without Pedixplorer; a round trip: a pedigree data frame through `Pedixplorer::Pedigree()` and `asPedFrame()` comes back identical column by column, on the 9 fixture pedigrees (prepared as for kinship2, R57) in 12 variants each (no condition, `affected`, two named conditions; each with and without status; each in a family or not; the rhesus fixture with the two twin pairs Pedixplorer accepts) and on 100 seeded random pedigrees (300 took about 18 s); the refusal test of `test_asPedFrame.R` changed to the new message. Every expected value computed with the prototype and the drafts run against it before RED (Learning 18), and the planted all-`NA` defect shown to fail them. Tests that build Pedixplorer objects skip without Pedixplorer (R7). Then suite 0 failed, WARN 0; lint 0; roxygen idempotent; drift tool 0 differ; `R CMD check --as-cran` R16's NOTE only; coverage of `R/asPedFrame.R`; push; CI 5/5 (its first install of a Bioconductor package); contract 4.5 updated; a "Done 14" record here; Phase 14 DONE. Surface: this Mac and CI's five jobs (CI installs Suggests). Source: as R58 (Mark approved the PRE-RED gate) | pedkindraw S20 | Mark |
| R60 | What layout hints change (Phase 15; `docs/planning/layout-hints-design.md`): everything kinship2's and Pedixplorer's hints change. An `order` (a number per animal) sets the left-to-right order of siblings, of separate families and of founder couples within a family, the engine's founder-reordering step (`.orderRootSubtrees()`) being skipped where the hint orders founders; a `spouse` hint sets which side a mate is drawn on and which partner anchors the mating (whose own place the children hang under). Without hints the layout is unchanged. Measured before the pick (the design's section 5): the copied engine places siblings, separate families and founders in the row order of `ped`, so rows sorted by a random hint drew every sibship in hinted order (190 of 190 on 8 fixture pedigrees; 9,840 of 9,840 on 200 seeded random family pedigrees of 9 to 1,776 animals, 7,241 with 3 or more children), and the same 8-animal case as kinship2 1.9.6.2 and Pedixplorer 1.8.0 with an order hint; the founder-reordering step changed the hinted founder order in 216 of the 243 families with 3 or more founder lines, and with it skipped 243 of 243 held; 8,183 of 11,449 random matings (71%) are drawn male-left by a fixed rule; a scratch prototype of the side hint (2 lines at each of the 2 places the side is set) drew 1,090 of 1,090 hinted matings on the hinted side, and one of the anchor hint (1 line) flipped 1,936 anchors with 0 layout errors. Mark's pick, "Order + mate placement (Recommended)", over order with founders kept (no mate placement) and order by sorting rows alone (no change to the copied code; founder order not kept) | pedkindraw S21 | Mark |
| R61 | How hints are given: a new argument `makePedigreeMatingLayout(..., hints = NULL)`, `hints` a list with `order` (a numeric vector named by animal id; only the order of the numbers matters) and `spouse` (a data frame with `left`, `right`, the ids of two animals with a child together, and `anchor`, `"left"`, `"right"` or `"either"`): kinship2's names, Pedixplorer's keying by id. `drawPedigreeDiagram()` (it draws a finished layout at fixed positions) and `makePedigreeDiagramData()` (it sets no x positions) take none. The copied functions the build changes (`makePedigreeMatingLayout()`, `.positionMatingUnitForest()`, `.buildMatingUnitForest()`) each get a `DIVERGENCE.md` row, not a mirror in nprcgenekeepr: this work does not change nprcgenekeepr (R8), pedkindraw is a sibling product first (R1), and nprcgenekeepr's Diagram tab takes no hints. The hint code lives in pedkindraw's own `R/layoutHints.R`; the copied functions gain call-site lines only. Mark's pick, "hints argument (Recommended)", over a separate row-sorting function (possible only without founder order and mate placement) | pedkindraw S21 | Mark |
| R62 | Converters pass hints on: `asPedFrame()` returns `list(ped, twinRelations, hints)`, `hints` in R61's form (kinship2's `order`, one number per subject in the object's order, and its `spouse` matrix of subject indices and anchor 1, 2, 0; Pedixplorer's `horder(x)` and `spouse(x)`; each turned into animal ids and `"left"`, `"right"`, `"either"`), or `NULL` when the object holds none. Measured: a `Pedixplorer::Pedigree()` built without hints holds an empty `horder` and no `spouse` rows; with a third element `hints = NULL`, 9 of the 29 converter tests (585 expectations) fail, each comparing the whole returned list, so they gain the element. R58's "a list of two" becomes three when 15c is built. Mark's pick, "Yes, a third element (Recommended)", over leaving the converters unchanged | pedkindraw S21 | Mark |
| R63 | Phase 15's build is three sessions, each strict TDD with its own pre-RED picker on the design's open details (its section 10, D1-D9): 15a the `order` hint (R/layoutHints.R; `DIVERGENCE.md` rows for `makePedigreeMatingLayout()` and `.positionMatingUnitForest()`), 15b the `spouse` hint (a row for `.buildMatingUnitForest()`; the help page's "It cannot be turned off" amended), 15c the converters (R62; contract 4.5). The DONE criteria are the design's section 9: typed cases (the 8-animal pedigree, the founder-couple case), 100 seeded random family pedigrees with a floor on what was checked, a comparison with kinship2 and Pedixplorer where they return, every error tested, and, each time, the suite 0 failed WARN 0, lint 0, roxygen idempotent, `R CMD check --as-cran` R16's NOTE only, every statement of `R/layoutHints.R` reached, the drift tool listing exactly the functions with rows, the fidelity tool exit 0 (no hint gives nprcgenekeepr's results), CI 5/5. Surface: this Mac and CI; order checked on the layout's x positions, which the widget draws unchanged. Mark's pick, "Approve 3 sessions (Recommended)", over folding the converters into 15b | pedkindraw S21 | Mark |
| R64 | An `order` hint that names only some animals (Phase 15a, the design's D1): the named animals trade places among their own rows of `ped`, in increasing order of their numbers; every animal it does not name keeps its row's place; equal numbers keep row order, as kinship2 and Pedixplorer keep it. Measured on 99 seeded random pedigrees with one sibship of 3 or more named: that sibship in hinted order 99 of 99 and the order of separate families changed 0 times; sorting the named animals first, which is kinship2's reading when the rest are `NA`, changed it 19 times. Pedixplorer ignores an order that leaves animals out; kinship2's and Pedixplorer's help pages ask for one number per subject | pedkindraw S22 | Mark |
| R65 | Which founder's number places a founder couple (D2): the female's, as kinship2's and Pedixplorer's help pages say ("the female founders are ordered as though they were sisters"); a male founder line by the smallest number among the female founders he anchors matings with, else his own. Measured on a 13-animal case with three founder couples over all 720 orders of the six founders: the top row equal to kinship2's 720 times (the anchor's number 120, the smaller of the two 348); 200 seeded random pedigrees, 501 of 501 families' founder lines in hinted order | pedkindraw S22 | Mark |
| R66 | When the founder-reordering step `.orderRootSubtrees()` is skipped (D3): only in a family whose founders the order names; elsewhere it runs as without hints. With one sibship named on 99 random pedigrees the founder order outside the hinted lines changed 11 times (the step choosing again after the siblings moved); skipping it whenever an order is given changed it 88 times | pedkindraw S22 | Mark |
| R67 | An order that puts a sibling between twins (D5): drawn as ordered, no twin rule; the twin line crosses the sibling (rectilinear edges route around it). kinship2 draws such an order as given, and keeps twins together only without an order; pedkindraw without hints already splits twins whose rows are apart | pedkindraw S22 | Mark |
| R68 | Checks on `hints` (D4), strict: stops when `hints` is neither `NULL` nor a list (a data frame too), an element is unnamed or not `order` (15b adds `spouse`), `order` is not numeric, a number has no name, a name is given twice or is not an id in `ped`, or a number is `NA`. `list()`, `order = NULL` and an empty `order` mean no hint, the layout unchanged. An isolated animal may be named. Pedixplorer ignores unknown names and keeps the first of a repeated one | pedkindraw S22 | Mark |
| R69 | 15a's kinship2 comparison (the design's DONE criterion 3) reads: every row on the 8-animal case and the ties case, and the top two rows of the 13-animal founder-couple case on 24 seeded founder orders. The bottom row of that case (cousins K1 and K2) matches in 360 of 720 orders: kinship2 draws the two cross-family couples side by side and repeats a partner, with or without a hint, and pedkindraw does not. On random pedigrees kinship2's rows differ from pedkindraw's without any hint (top row equal in 9 of 135), so the comparison stays on typed cases | pedkindraw S22 | Mark |
| R70 | Checks on `hints$mate` (Phase 15b, the design's D6), strict: stops when `mate` is not a data frame or lacks a column `left`, `right` or `anchor`; on `NA`, the same id as `left` and `right`, an id not in `ped` (which covers a sire or dam with no row of its own), a pair with no offspring together, a pair named twice in either order, and an `anchor` other than `"left"`, `"right"`, `"either"`. `NULL` and zero rows mean no hint. Measured on the 8-animal case: kinship2 1.9.6.2 ignores a pair with no offspring together and a repeated pair, and stops on the same id twice and on an unknown id; Pedixplorer 1.8.0 stops on a repeated pair, the same id twice and an unknown id, ignores the sire and dam A and F (no offspring together), and for the two dams F and B draws B a second time beside F; without checks pedkindraw ignored them, and a hint naming a sire with no row stopped on "pdepth must not be missing". Mark's pick, "Strict: stop (Recommended)", over skipping unusable rows | pedkindraw S23 | Mark |
| R71 | An anchor on the partner of the earlier generation (D7, D9): stops. The layout draws a mating on the row of its later partner, so such an anchor stays on its own row, away from the mating's dot. Measured on 100 seeded random pedigrees (the design's generator), each mating's anchor flipped, sides as drawn: partners with parents in one generation 1,464 of 1,464 held (the anchor's own node at the dot, on its row, its side kept, the other partner a repeat node, repeat-node counts unchanged); founder pairs 1,061 of 1,061; partners of different generations 2,916 (2,444 a founder anchoring a mate with parents), each anchor drawn rows above its mating's dot, 283 losing their side, while keeping the layout's anchor there held 2,916 of 2,916 sides. kinship2 and Pedixplorer fail on such an anchor (no solution to their quadratic program) or leave animals out. D9: the matings M7's rough test did not find beside their anchor (8 in M7; 13 in this run, its sides held as drawn) are all of this kind (seed 52: the anchor two rows above the dot, 1,221 units away). Mark's pick, "Stop (Recommended)", over keeping the layout's anchor and drawing as asked | pedkindraw S23 | Mark |
| R72 | An animal that anchors several matings is drawn as kinship2 draws its `spouse` hint: its families (offspring) follow its mates' hinted sides (left-hinted matings first, in the order of the hint's rows; then unhinted ones; then right-hinted ones, in the hint's order), mates hinted to one side are drawn left to right in the order of the hint's rows, and unhinted mates nearest the animal. Measured: a sire with two and with three dams, 18 hints: the mates' row and the offspring row both equal to kinship2's 18 of 18 (a hint moving only its own mating, the design's prototype: 8 and 7 of 18); 100 random pedigrees with a fifth of the matings hinted to the other side: 1,090 of 1,090 on the hinted side, 0 of 197 animals with crossing family lines (36 when a hint moves only its own mating). An "other mate to the free side" rule was measured redundant once families follow (the same on every case) and left out. A hint can change the side the layout gives a mating it does not name (74 in that run). Mark's pick, "kinship2's way (Recommended)", over "Only the named mating" | pedkindraw S23 | Mark |
| R73 | The hint element is named `mate`, not R61's `spouse` (R61's element name only is superseded): user-facing documentation and code use sire and dam (Mark, S23: "I want user facing documentation and code to use sire and dam"); its columns `left`, `right`, `anchor` are unchanged, and `spouse` is an unknown element (stops). Phase 15c's converters turn kinship2's `spouse` matrix and Pedixplorer's `spouse()` into it. Older committed text that says husband or wife may stay (Mark). Mark's pick, "Rename to hints$mate (Recommended)", over keeping kinship2's name | pedkindraw S23 | Mark |
| R74 | Mate rows of a converted object that `makePedigreeMatingLayout()` would refuse (Phase 15c; the design's sections 7.4 and 10): `asPedFrame()` fixes them, and one message names each change: a pair with no offspring together is left out (kinship2 and Pedixplorer ignore it), a pair named in an earlier row is left out, the first row kept (as kinship2 keeps it), and an anchor on the partner of the earlier generation (`findGeneration()`) becomes `"either"`, its side kept (R71: the layout draws a mating on the row of its later partner). Measured before the pick on 212 pedigrees (the design's M1, kinship2's `testped1` and `sample.ped`'s two families, 8 fixture pedigrees, 100 random family pedigrees from the design's generator and 100 random pedigrees, each prepared for kinship2): kinship2 1.9.6.2's `autohint()` returned on 143 (69 stopped, "autohint bug 3"), 40 of them holding rows the layout refuses (of 1,605 rows: 113 repeated pairs, often in the other order with the other side, 5 pairs with no offspring together, 35 earlier-generation anchors); Pedixplorer 1.8.0's `auto_hint()` returned on 119, 50 of them refused (of 1,522 rows: 2 pairs with no offspring together, 175 earlier-generation anchors; it refuses repeated pairs itself, and objects with more than one family); passed on as held, `makePedigreeMatingLayout(x$ped, hints = x$hints)` stopped on those 40 and 50; with the fixes all 262 converted, the 231 of 600 animals or fewer drew, and every hinted mating was drawn on its side (1,060 of 1,060; 898 of 898). Both packages warn "Unexpected result in autohint" on some pedigrees and still return hints. Mark's pick, "Fix them, say so (Recommended)", over fixing them silently, passing them on as held, and refusing the object | pedkindraw S24 | Mark |
| R75 | kinship2 hints that cannot be read as ids stop `asPedFrame()`, saying what is wrong: hints that are not a list, an `order` that is not numbers or not one number per animal, a `spouse` table that is not three columns of whole numbers with places 1 to the number of animals and an anchor 1, 2 or 0. kinship2's `align.pedigree()` stops on the same ("Wrong length for order component", "Invalid order component", "Invalid spouse value"). What kinship2 accepts is read: an `NA` in the order leaves that animal unnumbered (it keeps its row's place, R64); a `spouse` table with no `order` is converted (kinship2 refuses it, "Missing order component"; pedkindraw needs no order); a data frame reads as the matrix; other elements are ignored; an empty `spouse` is no mate hint. Pedixplorer checks its hints when the object is made (it refuses an `horder` leaving an animal out, an `NA` or an unknown id), so its method needs no such stop. Mark's pick, "Stop, naming it (Recommended)", over dropping the hints with a message | pedkindraw S24 | Mark |
| R76 | A `pedigreeList`'s hints (the design's D8) are read as a `pedigree`'s: `order` one number per animal of the whole list, `spouse` places in the whole list. kinship2 sets none in a `pedigreeList`: `autohint()` stops on one ("argument of length 0"), it has no plot method for one, and `pl["1"]` hands one family the whole list's hints unchanged (55 numbers for the 41 animals of `sample.ped`'s family 1). Pedixplorer's `horder()` names are its ids, family-prefixed (`F1_A`) as R58 keeps them. Mark's pick, "Read as for a pedigree (Recommended)", over always `NULL` | pedkindraw S24 | Mark |
| R77 | Phase 16's vignettes are three, built by knitr and rmarkdown (`html_vignette`) and shipped on CRAN: getting started with one live drawing, drawing with several, and speed and size limits with none (R79). The installed package stays under CRAN's 5 MB. Measured on a scratch build (S25): a page with drawings is 1.6-1.9 MB (each carries visNetwork's JavaScript; 375 more animals add 0.3 MB), the package without vignettes 0.47 MB, about 4.1 MB expected for the two pages with drawings; three such pages installed at 5.4 MB, which R 4.6.2's check reports as INFO (`_R_CHECK_LOG_USE_INFO_`, default TRUE) and as a NOTE where that is off. A later page with drawings goes on the website only. pedkindraw's `docs/planning/documentation-plan.md` (M1, M2). Mark's pick, "Live drawings in both (Recommended)", over a still picture in the getting-started vignette and over the drawing guide on the website only. Amended by R82 (pedkindraw S30): two vignettes ship, the speed vignette waiting until pedkindraw times itself | pedkindraw S25 | Mark |
| R78 | The pkgdown site is published on GitHub Pages, `https://rmsharp.github.io/pedkindraw/`, from a `gh-pages` branch that a GitHub Actions workflow rebuilds on each push to master, as nprcgenekeepr's is. It builds into `pkgdown_site/`, not pkgdown's default `docs/`, which holds this repository's plans; the root's `CLAUDE.md` and `DIVERGENCE.md` are left off (a trial build, pkgdown 2.2.1, published both as pages although `.Rbuildignore` lists them). Turning Pages on is a repository setting approved in the session that does it; the site's URL enters `DESCRIPTION` only once it answers (R16). pedkindraw's `docs/planning/documentation-plan.md` (M3). Mark's pick, "GitHub Pages (Recommended)", over a site built only locally until Phase 17 | pedkindraw S25 | Mark |
| R79 | The speed, memory and size-limit tables are summarized from the dated records, not re-measured: the comparison doc's sections 7 and 9 (nprcgenekeepr `70e0492eb` and `fd7c3d8ce`, 2026-11-02 and 2026-11-03) and nprcgenekeepr S1141's re-timing of the clean-room code (`d280dc8e8`, 2026-11-09; its 11 measured files identical to those pedkindraw copied at `baef1e12c`, `git diff` empty, S25). Each table names its date, machine, versions and the code it measured; a script, pedkindraw's `tools/checkSpeedTables.R`, checks every number against the committed result files; pedkindraw's new functions get the single-run times of this plan's Done records. A vignette of its own, no drawings. Mark's pick, "Summarize the records (Recommended)", over re-measuring pedkindraw with a timing tool of its own and over a README section only. Deferred by R82 (pedkindraw S30), and to be replaced by pedkindraw's own timing runs when the vignette returns | pedkindraw S25 | Mark |
| R80 | The vignettes' colony-size example is nprcgenekeepr's obfuscated 375-animal rhesus pedigree and its 3 twin pairs, shipped as files in `inst/extdata/` (`obfuscated_rhesus_mhc_ped.csv`, `obfuscated_rhesus_mhc_twin_relations.csv`, byte for byte from nprcgenekeepr's `inst/extdata/examples/` at `baef1e12c`, as the test fixtures already are) and read with `system.file()`: no export and no help page (R21 unchanged); small typed pedigrees show each feature. Measured (S25): `checkPedigree()` finds no problem, the twins pass `checkTwinRelations()`, 9 generations, 5 families, its layout 1.9 s. Mark's pick, "Ship one example file (Recommended)", over typed pedigrees only and over a documented dataset | pedkindraw S25 | Mark |
| R81 | With two or more conditions `drawPedigreeDiagram()`'s legend draws each condition's row as a section picture: a circle cut into the same sections as the animals' symbols (`.conditionSectionsHandler()`'s angles), that condition's section filled in its colour (`.conditionLegendImage()`, in `R/affectedConditions.R` beside the handler; shape `"image"`, no fill); with no condition or one the hexagon stays. Before the pick both candidates were drawn at 2, 3 and 4 conditions in headless Chrome; the other, one extra row with every section filled, would have grown the canvas 45 px. To be ported to nprcgenekeepr in a session of its own there; until then `DIVERGENCE.md` has rows for `drawPedigreeDiagram()` and `.conditionLegendImage()`, and `tools/compareResultsWithNprcgenekeepr.R` compares a drawing with two or more condition rows without those rows' shape, fill and picture (36 drawings in 24 of its 600 results; measured on a scratch prototype, those three fields were their only difference), all removed when the port lands. Source: the backlog's legend item (Mark's S26 find: the dividing lines "are not explained in the legend. It looks like an error."); Mark's picks "Section pictures (Recommended)", "Port later (Recommended)" and "Skip those fields (Recommended)" | pedkindraw S28 | Mark |
| R82 | Phase 16d, the speed and size-limits vignette, is deferred: "the comparison of pedkindraw with kinship2 and Pedixplorer" (Mark) waits until pedkindraw times itself, that is, until pedkindraw has timing runs of its own installed code, under a plan of its own that replaces R79's summary of nprcgenekeepr's records. Mark, after reading the draft built to R79: "Disambiguation between pedkindraw and nprcgenekeepr may need to wait until pedkindraw is completely separated. That is, this comparison may be premature." The draft (nine tables of nprcgenekeepr's November 2026 records, every cell and caption checked by `tools/checkSpeedTables.R` against the committed result files; a third of the page explaining why nprcgenekeepr's code stands for pedkindraw's) is kept on the branch `draft/speed-vignette` (`612eed9`), pushed and not merged. Until it returns: two vignettes ship (R77 amended); Phase 16 goes on to 16e, the site, with two articles; the drawing vignette's "How large a drawing can be" keeps the limit S29 stated from the records, with no pointer; the contract's section 7 shrink row carries the rewrite's time (16d's DONE item 3, done S30). Mark's picks "Defer it (Recommended)", over a short version without the explanation of nprcgenekeepr's code and over the draft as written, and "pedkindraw times itself", over full separation and over deciding later | pedkindraw S30 | Mark |
| R83 | Phase 17's plan is pedkindraw's `docs/planning/cran-submission-plan.md` (S32), written to Mark's direction: "It looks the a plan for a CRAN release should include, at least, consideration of the other options listed, examination of possible impact of recent and ongoing changes in nprcgenekeepr on pedkindraw, and the comparison of pedkindraw with kinship2 and Pedixplorer." Its outline: what was measured (the check time by step, scaled to win-builder; static checks; Suggests in the tests; export names; version places; CI), each open backlog item before or after the release, nprcgenekeepr's changes and what the release changes for the drift rule, the comparison with kinship2 and Pedixplorer, then phases 17a-17q (each with DONE, commands, surface and session boundary), the decisions left to each phase's picker (D1-D10), a session map and the dragons. Mark's pick, "This outline (Recommended)", over the same content with the phases first | pedkindraw S32 | Mark |
| R84 | Before the first CRAN release: the argument-name review (contract section 6; 17b, and 17c if it changes anything), the two drawing fixes ("Select by id" leaves out the `__jog_` routing points, 17d; the legend's "Same animal, again" label fits, 17e), the document of what kinship2 or Pedixplorer can do that pedkindraw cannot (17f), pedkindraw's own timing runs under a plan of their own and the speed vignette (R82's condition; 17g-17i), and tests for full coverage (17j). They come before the CRAN-mode test cut (17k) and the release steps (17l-17q), so the cut and the release measure the code that ships. A gap Mark chooses at 17f to close first becomes a phase of its own, before 17g. Mark's picks: all four offered ("Two drawing fixes (Recommended)", "Gaps document (Recommended)", "Timing runs + speed vignette", "Full test coverage") | pedkindraw S32 | Mark |
| R85 | The check time is measured where CRAN's 10-minute limit is enforced before any test is cut: Phase 17a uploads the tree to win-builder R-devel (Mark approves the upload; the result is emailed to the maintainer), and the target is 540 s or less, 10% under CRAN's 600 s, as nprcgenekeepr's D4. Measured S32 on this Mac under load: the check 181 s, its tests 118 s, which nprcgenekeepr's ratio of 3.4-3.8 puts at 615-688 s on win-builder. Mark's pick, "Measure on win-builder first (Recommended)", over a local estimate only | pedkindraw S32 | Mark |
| R86 | Whether CRAN-mode tests are cut (Phase 17k) is decided by one more win-builder R-devel reading of the tree after 17j, not by 17a's reading. Tests are skipped on CRAN only if that reading is over R85's 540 s; 17o's reading of 540 s or less still gates the submission. 17a's reading (S33, tarball from `eaff4a7`, `W1Ko4S0RDs2W`): 398 s, `Status: 1 NOTE` (R16's), its tests 286 s elapsed for 286 s of CPU, so on an idle machine; a busy day could read about 470-550 s, and 17b-17j add a guessed 10-40 s (`docs/planning/cran-submission-plan.md` section 2.1). Claude uploaded by FTP (D1: Mark's pick "I upload it via FTP (Recommended)"). Mark's pick, "Decide after 17j (Recommended)", over a small cut planned now or a second upload of the same tarball first | pedkindraw S33 | Mark |
| R87 | `kinship()`'s parent arguments become `sire` and `dam`, in the same positions: `kinship(id, sire, dam, pdepth, sparse = FALSE, twinRelations = NULL, chrtype = "autosome", sex = NULL)` (Phase 17c1). `fatherId` and `motherId` came from nprcgenekeepr's clean-room ruling C13, which only took the dots out of `father.id` and `mother.id`; every other export and the pedigree's own columns say sire and dam (Mark's S23 vocabulary ruling). Measured at `5525edd`: 43 calls to pedkindraw's `kinship()` in `R/`, the tests, `tools/`, the help examples, the README and the vignettes, 42 by position; the one by name is the copied C13 test (`tests/testthat/test_kinship.R:241`), so that test, the error message "fatherId, motherId and pdepth must each be as long as id" and its 3 expected copies change with the function and its help (the picker said 45 of 46 calls, counting kinship2's 3). A divergence from nprcgenekeepr: a `DIVERGENCE.md` row until nprcgenekeepr makes the same change in a session there. Mark's pick "Rename to sire, dam (Recommended)" over keeping the names | pedkindraw S34 | Mark |
| R88 | The pedigree argument is `ped` in the four exports that named it otherwise: `getParents(ped, ids)` and `getOffspring(ped, ids)` (were `pedSourceDf`), `getIdsWithOneParent(ped)`, and `addBackSecondParents(trimmedPed, ped)` (were `uPed`; `trimmedPed` is the trimmed pedigree, `ped` the full one) (Phase 17c2). Measured: none of the 24 calls (19 here, 5 in the fidelity tool) passes these arguments by name; 35 lines in 8 files change. Four `DIVERGENCE.md` rows. Mark's pick "Rename all four (Recommended)" over three (keeping `uPed`) or none | pedkindraw S34 | Mark |
| R89 | Every export that takes a pedigree takes it first: `getProbandPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`, `trimPedigree(ped, probands, removeUninformative = FALSE, addBackParents = FALSE)` and `hasBothParents(ped, id)` (Phase 17c3), so `ped |> trimPedigree("A")` works. Measured: of 65 calls, the 42 that name `probands =` or `ped =` keep working; the 23 that pass both by position are rewritten (2 in `R/`, 4 help examples, 8 in tests, 3 in the getting-started vignette, 6 in the fidelity tool, which then name their arguments so one call runs on both packages; listed in `docs/planning/cran-submission-plan.md` section 2.4). An old-order call stops with "$ operator is invalid for atomic vectors" in each of the four (a scratch run), never a wrong answer. Four `DIVERGENCE.md` rows (`addBackSecondParents()`'s call to `hasBothParents()` falls under R88's row). Mark's pick "Pedigree first, all four (Recommended)" over three (keeping `hasBothParents(id, ped)`) or none | pedkindraw S34 | Mark |
| R90 | `addIdRecords()` stays internal, as contract section 4.1 proposed: only `addBackSecondParents()` calls it, and an export can be added in a later release without breaking anyone, while removing one takes a deprecation release. nprcgenekeepr exports it. Mark's pick "Keep it internal (Recommended)" over exporting it | pedkindraw S34 | Mark |
| R91 | The export names shared with other packages stay: 22 of the 31 with nprcgenekeepr (240 exports at `366899961`), 6 with kinship2 1.9.6.2 (`bitSize`, `findAvailAffected`, `findAvailNonInform`, `findUnavailable`, `ibdMatrix`, `kinship`), 1 with Pedixplorer 1.8.0 (`kinship`). Phase 17c1 adds to `kinship()`'s help page and the README which names kinship2 and Pedixplorer share, and that their `kinship()` takes a pedigree object while pedkindraw's takes vectors (`asPedFrame()` converts one). Mark's pick "Keep, and say so in help (Recommended)" over keeping them with no note | pedkindraw S34 | Mark |
| R92 | `kinship()` stops with a plain message when a known parent's `pdepth` is not below its offspring's, and its help says the 4th argument is `pdepth`, not `sex` as in kinship2 (Phase 17c1, test-first; the same `DIVERGENCE.md` row as R87). Found in S34 while measuring R91: kinship2's own call form `kinship(id, dadid, momid, sex)`, sent to pedkindraw's `kinship()`, returns with no error or warning a matrix computed with the sex codes as generations, because `kinship()` fills each animal from its parents generation by generation in `pdepth`'s order. On kinship2's `minnbreast` (426 families, 28,081 animals, sex coded 1, 2, and 3 where missing) the values were wrong in 425 families; in `sample.ped`'s family 1, 414 of 1,681 values, by up to 0.25. The check stopped that call in all 426 families and in both `sample.ped` families, and passed `findGeneration()`'s numbers in all of them. Mark's pick "Add the check in 17c (Recommended)" over a help-page warning only or no change | pedkindraw S34 | Mark |
| R93 | Phase 17c is three sessions, each one strict-TDD cycle with its own check and CI run, in this order: 17c1 `kinship()` (R87, R91, R92; about 7 files), 17c2 the pedigree argument's name (R88; about 12 files, no callers), 17c3 the pedigree first (R89; about 16 files, the 23 calls). R84's one or two sessions assumed about ten files; the rulings touch about 31. Phase 17's guess becomes about 20 to 23 sessions. 17d and 17e need 17b only: none of the changed functions is in their file. Mark's pick "Three sessions (Recommended)" over two (the renames and the order together) | pedkindraw S34 | Mark |
| R94 | Phase 17d adds `__jog_`, the prefix of the routing points `.resolveEdgeNodeCollisions()` adds to step a line around an animal, to both lists of the prefixes the layout keeps for its own nodes: the "Select by id" box's filter (`R/drawPedigreeDiagram.R:292`), and `.buildMatingUnitForest()`'s input check (`R/makePedigreeDiagramData.R:452`), so a real id that starts with `__jog_` stops with the error the other five prefixes give. Measured S38 before the pick: smallPed with its animal B renamed `__jog_1_a` gives a layout with two nodes of that id and no error or warning, and with the filter alone that animal would also leave the box; the vignette's colony drawing's box, drawn in headless Chrome, 572 options (the placeholder, 375 animals, 196 `__jog_`) before and 376 with the fix; the whole suite on a draft of both changes, 705 blocks, 0 failed, WARN 0. Ported to nprcgenekeepr later, in a session of its own there that Mark starts (as R81): until then `DIVERGENCE.md`'s rows for `drawPedigreeDiagram()` and `.buildMatingUnitForest()` record it, and `tools/compareResultsWithNprcgenekeepr.R` takes `__jog_` entries out of nprcgenekeepr's boxes before comparing (measured on pedkindraw's own runs: 33 of the 600 results differ, only by 3,152 such entries, and all 600 are identical once they are taken out), all removed when the port lands. Mark's picks "Box and check (Recommended)" over the box alone, and "Port later (Recommended)" over keeping the difference | pedkindraw S38 | Mark |
| R95 | Phase 17e draws the legend's four lines ("Same animal, again", MZ, DZ, ?) without arrowheads and gives each line's label a white background: two columns of the legend's line table in `drawPedigreeDiagram()` (`R/drawPedigreeDiagram.R:120`), `arrows` `""` and `font.background` `"#FFFFFF"`. The label's words and the legend's width are unchanged. Measured S39 in headless Chrome before the pick: the label is not cut by the legend's edge but covered by the arrowhead visNetwork's `visLegend()` gives every legend line when it has no `arrows` value (`'to'`; vis.js draws it 18 units long at the line's right end), 5.5 px of the label at the website's 776 px widget (all 12 drawings on the live site, 11 in the drawing article and 1 in the getting-started one) and 10.1 px at 700 px, for 0, 1 and 4 conditions; the diagram's own lines have none; the dashed line through the comma made it read as a semicolon (S31's "Same animal; agai"). With no arrowheads the label is whole at 776, 700, 600 and 500 px; a shorter label ("Same animal") is covered again at 600 px (2.0 px) and 500 px (8.7 px), and a legend 35% wide is 1.5 px clear at 700 px and covered at 600 px. The whole suite on a draft, 705 blocks, 0 failed, WARN 0. Ported to nprcgenekeepr later, in a session of its own there that Mark starts (as R81 and R94): until then `DIVERGENCE.md`'s row for `drawPedigreeDiagram()` records it, and `tools/compareResultsWithNprcgenekeepr.R` takes the two columns out of pedkindraw's legends before comparing (measured on pedkindraw's own runs: 48 of the 600 results differ, every drawing case of the 12 pedigrees, and all 600 are identical once the two columns are taken out), all removed when the port lands. Mark's picks "No arrowheads, white label (Recommended)" over no arrowheads alone, a shorter label and a wider legend, and "Port later (Recommended)" over fixing nprcgenekeepr first | pedkindraw S39 | Mark |

The license, open under R11 until the rewrite existed, is ruled: R14 (S1149); `docs/planning/pedkindraw-api-contract.md`
section 10 item 1 records it.
Settled by C2 (S1130): the layout solver's terms 1-2 and the mate-pair step are rewritten too (that plan's batches D and A).
Session numbers: "pedkindraw S2" and the like are sessions in pedkindraw's repository (pedkindraw's
`methodology/HANDOFFS.md`); a bare S number is an nprcgenekeepr session.

---

## 3. Evidence inventory (measured this session)

Reproduce with the script in Appendix A (`codetools::findGlobals()` closure over the loaded package,
as in the scoping doc §8 cmd 1, extended to whole call graphs).

### 3.1 Dependency closure of each kinship2-matching group

Seeds are nprcgenekeepr's matches for kinship2 functions (gap analysis table). "Functions" is every
package function the seeds reach, transitively; "lines" sums those functions' bodies (roxygen excluded).

| Group (kinship2 match) | Seeds | Functions (exported) | Lines | Files | Outside packages |
|---|---|---:|---:|---:|---|
| drawing (`align.pedigree`, `plot.pedigree`, `legendPlot`, `pedigree.legend`) | `makePedigreeMatingLayout`, `makePedigreeDiagramData`, `drawPedigreeDiagram` | 57 (4) | 3,492 | 9 | Matrix, quadprog, stats, utils, visNetwork |
| kinship (`kinship`) | `kinship` | 5 (1) | 303 | 2 | Matrix |
| kindepth | `findGeneration` | 2 (1) | 42 | 2 | -- |
| makefamid | `findPedigreeNumber` | 2 (1) | 36 | 2 | -- |
| fixParents | `addParents`, `correctParentSex`, `addBackSecondParents`, `getIdsWithOneParent` | 9 (6) | 147 | 9 | data.table |
| pedigree.shrink | `shrinkPedigree` | 9 (2) | 217 | 2 | -- |
| pedigree.trim | `trimPedigree`, `removeUnknownAnimals`, `removeUninformativeFounders`, `getProbandPedigree`, `getDescendantPedigree` | 16 (13) | 149 | 16 | data.table |
| twins (`pedigree(relation =)`) | `readTwinRelations`, `checkTwinRelations` | 8 (3) | 135 | 6 | readxl, stats, stringi, utils |
| **Union of the above (the copy set)** | 18 seeds | **94 (25)** | **4,162** | **37** | data.table, Matrix, quadprog, readxl, stats, stringi, utils, visNetwork |
| *Excluded by R9:* `pedigree()`'s checks | `qcStudbook` | 47 (28) alone; union + it = 134 (49), 71 files | 1,067 alone | 41 alone | adds anytime, lifecycle, lubridate |
| *Excluded by R9:* `pedigree.unrelated` | `groupAddAssign` | 49 (15) alone; union + it = 142 (40), 66 files | 1,150 alone | 31 alone | adds lubridate |

### 3.2 The copy set: 37 files, by functions reached

`makePedigreeDiagramData.R` 23 · `positionTreeApportion.R` 13 · `shrinkPedigree.R` 8 ·
`affectedConditions.R` 6 · `penaltyCrossprod.R` 6 · `kinship.R` 4 · `readWithFinalNewline.R` 3 ·
`deceasedSlash.R` 2 · one each: `addBackSecondParents.R`, `addIdRecords.R`, `addParents.R`,
`checkTwinRelations.R`, `correctParentSex.R`, `drawPedigreeDiagram.R`, `findGeneration.R`,
`findPedigreeNumber.R`, `getDescendantPedigree.R`, `getFounders.R`, `getIdsWithOneParent.R`,
`getOffspring.R`, `getParents.R`, `getProbandPedigree.R`, `hasBothParents.R`, `isAddedRecord.R`,
`isEmpty.R`, `isFounder.R`, `muffleIncompleteFinalLine.R`, `mzTwinGroups.R`, `orderRootSubtrees.R`,
`rbindFill.R`, `readExcelPOSIXToCharacter.R`, `readTwinRelations.R`, `removeUninformativeFounders.R`,
`removeUnknownAnimals.R`, `toCharacter.R`, `trimPedigree.R`, `walkPedigree.R`.
Plus `R/comparePedigreeStructure.R` (378 lines, the fidelity checks against kinship2): no seed reaches it, but
its tests move (§3.3), so it moves with the engine in Phase 8.
File sizes of the largest (`wc -l`, with roxygen): `makePedigreeDiagramData.R` 3,209, `positionTreeApportion.R`
437, `kinship.R` 441, `shrinkPedigree.R` 368, `drawPedigreeDiagram.R` 278, `affectedConditions.R` 201.

The 25 exported functions reached (each has a `man/*.Rd`, all 25 checked present):
`addBackSecondParents`, `addIdRecords`, `addParents`, `checkTwinRelations`, `correctParentSex`,
`drawPedigreeDiagram`, `findGeneration`, `findPedigreeNumber`, `getDescendantPedigree`, `getFounders`,
`getIdsWithOneParent`, `getOffspring`, `getParents`, `getProbandPedigree`, `hasBothParents`, `isFounder`,
`kinship`, `makePedigreeDiagramData`, `makePedigreeMatingLayout`, `readTwinRelations`,
`removeUninformativeFounders`, `removeUnknownAnimals`, `shrinkPedigree`, `toCharacter`, `trimPedigree`.

Parity-closer internals (R3), present today: `.bitSizeOf` `R/shrinkPedigree.R:203`, `.findUnavailable`
`:226`, `.excludeUnavailFounders` `:257`, `.strayMarryinIds` `:302`, `.findAvailNonInform` `:313`,
`.findAvailAffected` `:339`.

### 3.3 Tests

- 123 of the test files call at least one copy-set function (46,107 of 107,924 test lines); most are app
  and genetics tests that only use `kinship()` on the way, and stay.
- **47 files (17,283 lines) have a copy-set function as their subject.** Of these, 4 are app tests of
  the Diagram tab and stay with the module: `test-e2e-pedigree-module.R` 1,532, `test-e2e-pedigree-tutorial.R`
  230, `test-e2e-pedigree-detailed.R` 135, `test-e2e-pedigree-canvas-drawing.R` 94. The other **43 files
  (15,292 lines)** move: largest `test_positionMatingUnitForest.R` 3,054, `test_makePedigreeMatingLayout.R`
  2,398, `test_resolveEdgeNodeCollisions.R` 1,408, `test_comparePedigreeStructure.R` 1,240,
  `test_addRectilinearWaypoints.R` 910, `test_solveJointQP.R` 582, `test_buildMatingUnitForest.R` 568,
  `test_makePedigreeDiagramData.R` 487, `test_diagramSolverEquivalence.R` 395, `test_orderRootSubtrees.R`
  379, `test_correctParentSex.R` 361, `test_drawPedigreeDiagram.R` 349, `test_shrinkPedigree.R` 347,
  `test_kinship.R` 235, plus helpers `helper-live-render-positions.R` 187, `helper-comparePedigreeStructure.R`
  131, `helper-walkPedigree.R` 92 and 26 smaller files (full list: Appendix A, `subject.R`).
- Fixture: the obfuscated rhesus pedigree, `inst/extdata/examples/obfuscated_rhesus_mhc_ped*.csv` (5 files:
  plain, `_affected`, `_name`, `_twins`, `_with_genotypes`), is named by 23 test files, 8 of them moving; most
  often `test_positionMatingUnitForest.R` (16 lines) and `test-e2e-pedigree-module.R` (14, stays).
- Package datasets the 43 moving files name: `lacy1989Ped` 8 files, `smallPed` 6, `pedOne` 5, `qcPed` 3,
  `pedWithGenotype` 2, `rhesusPedigree` 2, `examplePedigree` 1, `pedSix` 1. They also call non-copied
  functions to build fixtures: `qcStudbook()` 8 calls in 2 files, `getPedigree()` 3, `getGenotypes()` 3,
  `convertDate()`, `getFocalAnimalPed()`, `removeDuplicates()` 2 each, `create_wkbk()`, `modInputServer()`,
  `runQcStudbook()` 1 each; Phases 6-10 replace those with saved fixture files or copied datasets.
- Fidelity tests use `kinship2` (`Suggests:`); they move with the engine.

### 3.4 Documentation that names the copy set

Lines naming the three drawing functions, `shrinkPedigree()` or `kinship(`: `vignettes/a2interactive.Rmd` 33,
`vignettes/articles/kinship2-fidelity-validation.qmd` 25, `data-raw/kinship2FidelityValidation.R` 20,
`vignettes/articles/pedigree-diagram.qmd` 10;
`_pkgdown.yml:176,249,327,328,414`. These stay in nprcgenekeepr (R8); the new package writes its own (Phase 16).

### 3.5 Machine for every measurement in Phases 1-2

Apple M2 Max, 12 cores, 96 GiB (`sysctl hw.memsize` 103,079,215,104 B), R 4.6.2 (2026-10-29).

---

## 4. Phases

Every phase is **one session** unless marked otherwise; close out when its DONE criteria hold. Where a
phase is marked "estimate", the session count is a guess, not a measurement.

### Phase 1 -- Comparison A: computation, timing, memory, capacity (this repository)

**Goal:** for every pedigree computation kinship2, Pedixplorer and ggpedigree (with its computation
companion `BGmisc`, where it exports a match) offer, and nprcgenekeepr's 25 copy-set exports: what each
takes, returns and refuses, whether they agree on the same input, how fast, how much memory, and how large
a pedigree each can handle.

**Steps.**
1. Install kinship2 1.9.6.2, Pedixplorer 1.8.0 (Bioconductor 3.23) and ggpedigree 1.2.0 into a scratch
   library (`R_LIBS=<scratch>`), never into renv or the personal library; stop if the install lands
   anywhere else (memory: renv guard, S1111). Record exact versions.
2. Enumerate each package's exports live (`getNamespaceExports()`; Pedixplorer's S4 generics and methods
   too) and extend the 2026-09-20 table to one row per function across all four packages: arguments, input
   conventions (id type, missing-parent code, sex codes incl. hermaphrodite/unknown, affected and deceased
   coding, twins, partial parentage), return shape, errors on bad input.
3. **Same-input runs.** Test pedigrees, each saved once as CSV under `tools/pedigreeComparison/data/`:
   kinship2's `sample.ped`; `smallPed` (17); `lacy1989Ped`; the obfuscated rhesus pedigree (375);
   `examplePedigree` (3,694 rows); and synthetic pedigrees of 1,000, 10,000, 30,000 and 100,000 animals from
   one seeded generator written in this phase (primate-colony shape: overlapping generations, many half
   sibs, a share of unknown parents). Compare: kinship matrices (autosomal, X, MZ twins: max absolute
   difference), generation depth, family ids, trim and shrink results, unrelated sets.
4. **Timing and memory.** Each measurement in a fresh `Rscript` process: one unmeasured warm-up, then
   the median of 3; elapsed seconds, R heap peak (`gc(reset = TRUE)` then "max used", as
   `tools/perf/harness.R:45-49` does), and process peak resident memory (`/usr/bin/time -l`, "maximum
   resident set size"). Read `uptime` first and do not time under load; run nothing else meanwhile.
   (The heap peak alone cannot rank two designs; the process peak is the cross-package figure.)
5. **Capacity.** For each function and package, the largest synthetic size that finishes within 120 s
   and 32 GB process peak, and how the next size failed (error, time, memory). A dense kinship matrix of
   n animals is 8 n^2 bytes (100,000 animals = 80 GB), so expect every dense method to stop below that.

**DONE:** `docs/research/pedigree-package-comparison-2026-11.md` Part A (computation): the function table
with every row filled; an agreement table; a timing / memory / capacity table per function with versions
and the machine; the generator and run scripts under `tools/pedigreeComparison/` (build-ignored,
`.Rbuildignore:57`). No `R/` change.
**Verification:** each number in the doc is reproduced by a script named next to it; re-run one row of
each table from a fresh shell before close-out.
**Surface:** this Mac only (§3.5). It cannot show other platforms' speed or a smaller machine's memory
limit; capacity figures are this Mac's and the doc says so.
**Session boundary:** estimate 1-2 sessions. If the table and the timing runs do not both fit, close out
after the table and agreement checks and leave timing and capacity to a second session.
**Done (S1122-S1123):** two sessions, split as above. Mark's rulings in the second: synthetic sizes 300 and
3,000 added (shrinking already failed 120 s at 1,000 in two packages), and each run gated on at least half the
CPU idle instead of `uptime`'s load (macOS's own background work kept the load at 3-35 with most cores free).

### Phase 2 -- Comparison B: drawing, interactivity, drawing capacity (this repository)

**Goal:** the same pedigrees drawn by kinship2 (`plot.pedigree`), Pedixplorer (its static plot, its plotly
plot and its Shiny app), ggpedigree (ggplot2 and plotly) and nprcgenekeepr (`makePedigreeMatingLayout()` +
`drawPedigreeDiagram()`).

**Steps.** A feature matrix: sex symbols incl. unknown and hermaphrodite; affected status, several
conditions; deceased; MZ/DZ twins; consanguineous matings; repeat appearances (loops); legend; name labels;
hover text; search and select; click to re-center; export (PNG, SVG, PDF, stand-alone HTML); use from a
script vs only from an app. Side-by-side images for each pedigree, opened for Mark with `open`. Check each
drawing's edges against the pedigree programmatically for the 17- and 375-animal pedigrees (memory:
verify diagrams against ground truth). **Timing / memory / capacity for drawing:** layout time in R
(Phase 1 method); render time in Chrome (chromote: from load to the network's `stabilized` event or the
plot's equivalent); browser memory (`Performance.getMetrics`, `JSHeapUsedSize`); the largest pedigree each
draws within 120 s, and the largest that is still readable (Mark judges from the pictures). nprcgenekeepr's
app caps the Diagram at 750 animals, 400 with rectilinear edges (`R/modPedigree.R:454,466`); measure `drawPedigreeDiagram()` without
the cap.

**First session (S1124):** the pictures, the feature table and the line checks (comparison doc section 8;
`tools/pedigreeComparison/runDrawing.R`), split at Mark's pick. Mark ruled the pictures stay out of git: the
folder below is git-ignored and `runDrawing.R` remakes it in about a minute. Left for the second session: layout
time in R, render time and memory in Chrome, the largest drawable and the largest readable, and the closing
paragraph.

**DONE:** Part B of the comparison doc, images under `docs/research/pedigree-package-comparison-2026-11/`,
and a one-paragraph answer to "what would the new package offer that none of the three does", based on the
evidence. **Surface:** this Mac's Chrome via chromote; cannot show other browsers, Windows, or screen
readers. **Session boundary:** estimate 1-2 sessions.
**Done (S1124-S1125):** two sessions, split as above. Mark's rulings in the second: synthetic sizes 300, 1,000,
2,000 and 3,000 plus rhesus375; a drawing counts only when R and the browser together finish within 120 s; the
plotly versions timed in Chrome; Pedixplorer also timed with its parent alignment off, as it refuses the synthetic
colonies with it on. Found (doc section 9): no package draws 2,000 animals within 120 s, the best reach 1,000;
Mark judged only nprcgenekeepr's drawing readable, up to 1,000 animals zoomed in. The closing answer (doc section
10): what is left to offer is the drawing, not the computation, and the size limit stays near 1,000 animals.

### Phase 3 -- Input-style prototype and Mark's pick (this repository; decision session)

**Goal:** settle R7. Throwaway prototypes in the scratchpad, not in `R/`: (a) data frames as nprcgenekeepr
takes them; (b) a kinship2 `pedigree` object; (c) a Pedixplorer `Pedigree` S4 object; (d) data frames plus
one converter from (b) and (c). Each draws the same pedigree and computes its kinship. Measure what each
costs (lines of adapter code; extra dependencies, e.g. `S4Vectors` for (c)) and what each loses
(partial parentage, legal here and refused by kinship2's `pedigree()`; sex `H`; the twins sidecar).
Mark picks via `AskUserQuestion`, with a per-option table of measured costs.
**DONE:** the ruling recorded in the comparison doc and in this plan's §2 (R7 closed). **Surface:** local.
**Session boundary:** one session.
**Done S1126:** R7 ruled (data frames plus converters); comparison doc section 11 and findings 30-35.

### Phase 4 -- API contract, name, license, repository (this repository; design session)

**Goal:** an interface catalogue (`ARCHITECTURE_WORKSTREAM.md` §Interface Catalog): every export of the new
package with its arguments, return and errors, in the picked input style; the short checker and short
unrelated-set finder (R9) sized from Phase 1; whether the file readers come along (§2 open item).
Mark decides: the **name** (Claude first checks it is free on CRAN, Bioconductor and GitHub; taken
already: kinship2, Pedixplorer, ggpedigree, pedtools, visPedigree), the **license** (with §1.3's facts in
front of him), and who creates the **GitHub repository** (Mark, or Claude with `gh repo create` once Mark
approves; creating it is outward-facing).
**DONE:** `docs/planning/<name>-api-contract.md`; the repository exists, empty. **Session boundary:** one session.
**Done S1128:** `docs/planning/pedkindraw-api-contract.md`; R10-R13; https://github.com/rmsharp/pedkindraw created
empty. The license is open (R11).

### Phase 5 -- Skeleton (new repository; two sessions there, R15)

**License line:** ruled S1149 (R14): `License: MIT + file LICENSE`, `LICENSE` naming R. Mark Sharp as copyright holder
(the `YEAR` line: 2017-2026, R17).
Bootstrap the methodology from the methodology repository; `CLAUDE.md` carrying this project's strict TDD
contract and Build/Test/Verify table; `DESCRIPTION`, `LICENSE`, `NAMESPACE`; `testthat` 3rd edition; `renv`
on a dated repository (this project's `CLAUDE.md` S1111 ruling); `lintr` settings copied; GitHub Actions
`R-CMD-check` on Linux, macOS and Windows.
**DONE:** `R CMD check --as-cran` 0 errors, 0 warnings, 0 notes locally and on CI for the empty package.
**Surface:** this Mac and GitHub Actions. CRAN's own machines are not reached until Phase 17.
**Split (R15, S1150):** **5a**, set-up only: from the clone, `/Users/rmsharp/Development/methodology/bin/sync
/Users/rmsharp/Development/pedkindraw --layout new` (S1150's dry run: 31 files, all under `methodology/`), committed
as one commit; then `CLAUDE.md` from `methodology/CLAUDE_TEMPLATE.md` plus the contract and table above; commit, stop.
**5b**, a new session: the R skeleton test-first, one push, the GitHub checks. Mark decides `LICENSE`'s `YEAR` line
and the `Authors@R` list (R17). The clone's branch is `master`, git's default (no commits yet).
**Session boundary:** two sessions (R15).
**Done (pedkindraw S1-S2):** 5a in S1 (the methodology synced, 31 files under `methodology/`; `CLAUDE.md` with this
plan's strict TDD contract word for word). 5b in S2: `DESCRIPTION` 0.0.1, `LICENSE` (R17), `NAMESPACE` by roxygen2,
`.lintr` with nprcgenekeepr's linters, renv on Posit's 2026-10-31 snapshot, the R-CMD-check workflow (five jobs on
Linux, macOS and Windows); pushed once, CI run `42930770118` 5/5 `Status: OK`. The DONE line's "0 notes" became R16
(one allowed NOTE until CRAN).

### Phases 6-10 -- Copy slices (new repository; one slice per session)

Each slice copies a group's tests first (RED: they fail because the functions are missing), then the code
(GREEN), in commits of at most 5 files. Each copied file's header names its source path and the
nprcgenekeepr commit it came from. Fixtures built with non-copied functions (§3.3: `qcStudbook()` 8 calls in 2 files, 8 other functions
1-3 calls each) are replaced by saved fixture files. **DONE for each slice:** the copied tests pass with the same pinned values,
and the slice's functions give identical results to nprcgenekeepr at the source commit on the Phase 1
pedigrees (`identical()` for data frames, max absolute difference 0 for kinship), checked by a script;
`R CMD check --as-cran` 0 errors, 0 warnings, no NOTE but R16's; CI green.

| Phase | Slice | Files (from §3.2) | Outside packages |
|---|---|---|---|
| 6a | Pedigree basics, first half (R19; DONE pedkindraw S3): generations, family ids, parents/offspring/founders, walking | `findGeneration`, `findPedigreeNumber`, `getParents`, `getOffspring`, `getFounders`, `isFounder`, `getProbandPedigree`, `getDescendantPedigree`; internal `isEmpty`, `walkPedigree` | -- |
| 6b | Pedigree basics, second half (R19; DONE pedkindraw S7): trimming, parent repair | `hasBothParents`, `trimPedigree`, `removeUnknownAnimals`, `removeUninformativeFounders`, `addParents`, `correctParentSex`, `addBackSecondParents`, `getIdsWithOneParent`; internal `addIdRecords` (exported in nprcgenekeepr; contract section 4.1), `isAddedRecord`, `rbindFill`, and the constant `sexCodes` (R25). `toCharacter` is not copied (R20) | data.table, kept (contract section 5); only `addIdRecords()` uses it |
| 7 | Kinship and twins (DONE pedkindraw S8) | copy `checkTwinRelations.R` and nprcgenekeepr's clean-room `R/kinship.R` and `R/mzTwinGroups.R` (C2; with the constant `mzTwinIdsAbsentMessage`); no readers (R13) | Matrix (R27); also `methods`, `stats`; Suggests `kinship2`, `withr` (R28) |
| 8 | Layout engine (2 sessions, R30: all the layout code and its tests, then the kinship2 comparison, fidelity cases and CI; DONE pedkindraw S9-S10) | `makePedigreeDiagramData.R`, `positionTreeApportion.R`, `orderRootSubtrees.R`, `penaltyCrossprod.R`, `affectedConditions.R` (lines 1-75, R32), `comparePedigreeStructure.R`, with the clean-room `.solveJointQP()` and mate-pair step in them (C2); tests from §3.3 (less R31's) and the rhesus fixtures | quadprog, Matrix, utils; kinship2 in Suggests for the fidelity tests |
| 9 | Renderer (DONE pedkindraw S11; R34-R37) | `drawPedigreeDiagram.R` and its drawing script, `deceasedSlash.R` and the rest of `affectedConditions.R` (R32); `test_drawPedigreeDiagram.R`, the live-render helper and the 3 Chrome tests of `test_positionMatingUnitForest.R` (R31) | visNetwork; chromote in Suggests |
| 10 | Shrink (DONE pedkindraw S13; R38-R39) | copy nprcgenekeepr's clean-room `R/shrinkPedigree.R` and its helpers (C2) | -- |

**Done 6a (pedkindraw S3):** the 10 functions, their 9 test files (48 tests) and `helper-walkPedigree.R` copied from
nprcgenekeepr `baef1e12c`, code unchanged, help text rewritten (R21: examples type their own pedigree); fixtures
`lacy1989Ped` and `smallPed` (R21); `stringi` calls in the tests replaced (R22). Checks: pedkindraw's
`tools/compareResultsWithNprcgenekeepr.R`, 120 of 120 results `identical()` on 12 Phase 1 pedigrees; its
`tools/compareWithNprcgenekeepr.R` (the drift check, §5), 0 differences and its `DIVERGENCE.md` with no rows;
`R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE; CI run `42960032938` 5/5 `Status: OK`. None of 6a's or 6b's
functions uses `stats` or `utils` (pedkindraw S2-S3), so neither is imported yet.

**Done 6b (pedkindraw S7):** the 11 functions and the constant `sexCodes` (R25) copied from nprcgenekeepr `baef1e12c`,
code unchanged, help text rewritten (R21; `addIdRecords()` not exported, contract section 4.1); 9 test files, 47
tests (46 of the 56 in the 8 files the row's functions have, R24, and `sexCodes`'s value test, R25); fixtures `pedSix`
and `qcPed`; one test file's `stringi` calls replaced (R22); `Imports: data.table`. Checks: pedkindraw's results
tool, 264 of 264 results `identical()` on the 12 Phase 1 pedigrees (22 cases; made-up variants of the pedigrees reach
the branches they do not); the drift check, 21 copied functions the same and `DIVERGENCE.md` still without rows (it
does not compare constants: pedkindraw's `methodology/BACKLOG.md`); `R CMD check --as-cran` 0 errors, 0 warnings,
R16's NOTE; tests PASS 347; CI run `43052891573` 5/5 `Status: OK` (attempt 2: in attempt 1 the three Ubuntu jobs
could not reach Ubuntu's package servers while installing R, before any check ran).

**Done 7 (pedkindraw S8):** `kinship()` and `checkTwinRelations()` (exported) and `mzTwinGroups()` with the constant
`mzTwinIdsAbsentMessage` (internal) copied from nprcgenekeepr `baef1e12c`, code unchanged, help text rewritten (R21);
one roxygen line added, `@importClassesFrom Matrix ddiMatrix dgCMatrix` (R27). 34 tests in 4 files (R26), one of them
changed for testthat edition 3 (R29); fixture `pedOne`; `Imports: Matrix, methods, stats`, `Suggests: kinship2, withr`
(R28). Checks: the results tool, 360 of 360 results `identical()` on the 12 Phase 1 pedigrees (30 cases; kinship on the
whole pedigree up to 2,000 animals, else on 100 spread animals and their ancestors; made-up twins, founders-only and
one-parent variants reach the branches the pedigrees do not), 132 kinship matrices with largest absolute difference 0;
the drift check, 24 copied functions the same, `DIVERGENCE.md` still without rows; `R CMD check --as-cran` 0 errors,
0 warnings, R16's NOTE; tests PASS 446, WARN 0 (new gate `test-suite-warnings-zero`); CI run `43106941979` 5/5
`Status: OK`, first attempt.

**Phase 8, first session (pedkindraw S9; R30):** `makePedigreeDiagramData()` and `makePedigreeMatingLayout()`
(exported) and the internals they reach copied from nprcgenekeepr `baef1e12c`: `makePedigreeDiagramData.R`,
`positionTreeApportion.R`, `orderRootSubtrees.R` and `penaltyCrossprod.R` whole and `affectedConditions.R`'s lines 1-75
(R32), code unchanged, the two examples typing their own pedigree (R21). 295 tests in 13 files (R31 leaves out 5),
seven of them changed (R29, R33); fixtures: three datasets, three rhesus files, and two results of nprcgenekeepr's own
code saved by `tools/makeComputedTestFixtures.R` (the QC'd rhesus pedigree; `shrinkPedigree()`'s Track B, read by a
stand-in until Phase 10). `Imports: quadprog, utils`. Checks: tests 428, 0 failed, WARN 0; the 295 check as many
expectations each as nprcgenekeepr's own run of its 13 files; `R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE;
coverage of the new code 96.12%; the drift check, 77 copied functions, the 3 deferred by R32 recorded; the results tool
still 360 of 360 (no layout cases yet). Not pushed: CI has not run the layout.

**Done 8 (pedkindraw S9-S10; R30):** the first session above, then (S10) `comparePedigreeStructure.R`'s four internal
functions (the structural comparison with kinship2) copied from nprcgenekeepr `baef1e12c`, code unchanged, with their
38 tests and helper (15 `nprcgenekeepr:::` calls made plain, two rhesus reads from the fixtures). Checks: tests 466,
0 failed, WARN 0, the 38 checking as many expectations each as nprcgenekeepr's own run (132); the results tool, 468 of
468 results `identical()` on the 12 Phase 1 pedigrees, warnings (27) and now messages (60) compared too: 9 layout
cases on the whole pedigree up to 400 animals, else 20 spread animals and their ancestors (74 to 268), with made-up
status, name and condition columns, founders only and every dam unknown for the branches the pedigrees do not reach
(the cases miss 13 argument checks of internal functions, which only the tests reach, and 16 geometry cases only the
tests' own pedigrees make); 132 kinship matrices, largest absolute difference 0; the drift check, 81 copied functions,
the 3 deferred by R32 recorded; `R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 2010); coverage
96.84%, `comparePedigreeStructure.R` 99.30% (its one missed line a defensive return); CI run `43260600901` 5/5
`Status: OK`, first attempt, `FAIL 0 | WARN 0` on each (Ubuntu skips 2 and Windows 1 of `test_diagramSolverEquivalence.R`'s
tests, by their own guards for a math library other than R's).

**Done 9 (pedkindraw S11; R34-R37):** `drawPedigreeDiagram()` (exported) copied from nprcgenekeepr `471589138` with
its `.checkOnClick()` (R34), its help text describing the function alone and its example typing its own pedigree
(R36); `deceasedSlash.R` whole and `affectedConditions.R`'s lines 76-201 from `baef1e12c` (R32), code unchanged.
12 of `test_drawPedigreeDiagram.R`'s 16 tests (R35: its 4 Shiny-module tests and `test_drawPedigreeDiagramDocs.R` stay
in nprcgenekeepr), the live-render helper and the 3 Chrome tests R31 deferred; `Imports: visNetwork`, `Suggests:
chromote, htmlwidgets`, with 22 dependencies locked from the dated repository; the CI workflow gets nprcgenekeepr's
Chrome set-up steps. Checks: tests 481, 0 failed, WARN 0, the 12 checking nprcgenekeepr's 65 expectations test for
test and the forest file its 221; the results tool, 540 of 540 results `identical()` on the 12 Phase 1 pedigrees (6
drawing cases; whole widgets compare equal because both renv libraries link one cache entry of visNetwork), against
nprcgenekeepr `392dd347e` read with `git archive` (R37: its working copy was being edited); 132 kinship matrices,
largest absolute difference 0; the cases and the tests each reach all 38 statements of the three files; the drift
check, 85 copied functions, 1 recorded (S1159's legend change, `a85311021`, committed during the session, R37); `R CMD
check --as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 2075, SKIP 3: the Chrome tests skip on CRAN); coverage
97.10%; the help example drawn in headless Chrome (slash, sections, legend); CI run `43278560876` 5/5 `Status: OK`,
first attempt, `FAIL 0 | WARN 0` on each, the 3 Chrome tests run on all five (macOS PASS 2082; Windows 2081, SKIP 1;
Ubuntu 2071, SKIP 2: the math-library guards above).

**Done 10 (pedkindraw S13; R38-R39):** `shrinkPedigree()` (exported) and its four internal helpers
(`.checkShrinkInput()`, `.removalPass()`, `.isParent()`, `.bitSize()`) copied from nprcgenekeepr's clean-room
`R/shrinkPedigree.R` at `baef1e12c` (unchanged to `ec56cb02e`), code unchanged, its example typing its own pedigree
(R21). All 24 tests of `test_shrinkPedigree.R`, unchanged below the header (R38: the 3 nprcgenekeepr test files that
name it but check its clean-room records and tutorial stay there); the stand-in that served the 3 Track B tests since
Phase 8 deleted in RED, with its saved fixture and the code that wrote it (R39). No new package. Checks: tests 505,
0 failed, WARN 0, the 24 checking nprcgenekeepr's 79 expectations test for test; the results tool, 600 of 600
results `identical()` on the 12 Phase 1 pedigrees against nprcgenekeepr `ec56cb02e` read with `git archive` (5 shrink
cases on the layout's pedigree, at most 400 animals, because one call on examplePedigree's 3,694 took 130 s; a
made-up loop of two animals each the other's sire reaches the one statement nothing else does); the cases reach 127
of the file's 127 statements, the tests 125; 132 kinship matrices, largest absolute difference 0; the drift check,
90 copied functions in 33 files, 0 differ, `DIVERGENCE.md` without rows; `R CMD check --as-cran` 0 errors,
0 warnings, R16's NOTE (tests PASS 2158, SKIP 3); coverage 97.16%; CI run `43326408939` 5/5 `Status: OK`, first
attempt, `FAIL 0 | WARN 0` on each (macOS PASS 2165; Windows 2164, SKIP 1; Ubuntu 2154, SKIP 2). The copy slices,
Phases 6-10, are complete.

**C2 in Phases 7, 8 and 10** (`nprcgenekeepr:docs/planning/cleanroom-rewrite-plan.md` §4.8): each copies the
clean-room code like any other nprcgenekeepr code. The waits §4.8 set (Phase 7 on that plan's Phase 8, Phase 8 on its
Phases 5 and 14, Phase 10 on its Phase 11) are over: that plan finished S1140. R11's "write ... from the published
methods" is met by these copies and no longer applies to these three phases (it still governs Phase 12). The
rewritten functions differ from nprcgenekeepr 3.0.0's, and the copies carry the differences: `kinship()`'s parent
arguments are `fatherId` and `motherId` (that plan's C13, were `father.id` and `mother.id`), and it stops with a plain
message on malformed input (C11); `shrinkPedigree()` does too (C15) and breaks ties by byte order (C16).

**Surface:** this Mac and the new repository's CI. Browser tests run where Chrome is present and skip
elsewhere (this project's S1117 pattern); say so in each slice's handoff.

### Phases 11-15 -- New work (new repository; strict TDD, one session each)

| Phase | Work | Source |
|---|---|---|
| 11 | Export the rewrite's shrink helpers and `bitSize` (contract section 4.3). DONE (pedkindraw S14) | R3, R11, R40-R42 |
| 12 | Write `familyCheck()` and `ibdMatrix()` from kinship2's documented behaviour, not its source (estimate: 2 sessions). DONE: `familyCheck()` (pedkindraw S15), `ibdMatrix()` (pedkindraw S16) | R3, R11, R43-R48; gap analysis rows 7, 12 |
| 13 | Short pedigree checker and short unrelated-set finder (2 sessions, R49). DONE: `checkPedigree()` (pedkindraw S17), `findUnrelated()` (pedkindraw S18) | R9, R49-R54; sized at Phase 1, specified at Phase 4 |
| 14 | Input converters from kinship2 `pedigree` and Pedixplorer `Pedigree` objects (picked S1126; what each reads and two test cases: comparison doc section 11.2; 2 sessions, R55). DONE (pedkindraw S19-S20) | R7, R55-R59 |
| 15 | User-suppliable layout hints: a design session first (engine-surface design), then the build. Design DONE (pedkindraw S21, `docs/planning/layout-hints-design.md`); the build is three sessions, 15a `order`, 15b `spouse` (named `mate`, R73), 15c converters, DONE criteria in the design's section 9 (R63). 15a DONE (pedkindraw S22, R64-R69); 15b DONE (pedkindraw S23, R70-R73); 15c DONE (pedkindraw S24, R74-R76); Phase 15 DONE | R3, R60-R76 |

**Done 11 (pedkindraw S14; R40-R42):** `bitSize()`, `findUnavailable()`, `findAvailNonInform()` and
`findAvailAffected()` exported, pedkindraw's own code in a file each, calling the copied internals of
`R/shrinkPedigree.R` (unchanged; drift check 90 functions, 0 differ) and one internal helper, `.parentPositions()`
(REFACTOR). Written from kinship2's help pages, its source not read (R11). Measured before the picker: kinship2's
bit sizes equal on all 6 fixture pedigrees it accepts; its `pedigree.shrink()`'s first two steps remove the same ids
in 24 of 24 cases; a scratch prototype of the third-trim walk identical in 24 of 24. 32 tests in 4 new files and a
helper (`helper-shrinkSteps.R`), every expected value computed before RED; RED 32 errors, each first on the missing
function. Checks: tests 537, 0 failed, WARN 0, SKIP 0, 2453 expectations; each step `identical()` to
`shrinkPedigree()`'s on 7 fixtures under 5 genotyped patterns, the third trim walked on 4 pedigrees, 3 patterns, 2
budgets; kinship2's `bitSize()` and first two steps equal where installed; lint 0; roxygen idempotent; `R CMD check
--as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 2446, SKIP 3); coverage 97.32%, the 4 new files 61 of 61
statements; CI runs `43350752421` (GREEN) and `43352801040` (REFACTOR) 5/5 `Status: OK`, each at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 2453; Windows 2452, SKIP 1; Ubuntu 2442, SKIP 2). R42's account of the one-trim
difference from kinship2 was corrected before RED (`702d3b5`).

**Done 12 (`familyCheck()`; pedkindraw S15; R43-R45):** `familyCheck()` exported, pedkindraw's own code in
`R/familyCheck.R` with two internal helpers, `.familyTrees()` (kinship2's `makefamid()` numbering) and
`.familyJoinTable()` (REFACTOR). Written from kinship2's help pages and measured results, its source not read
(R14). Measured before the picker: a scratch prototype equal to `kinship2::familycheck()` in 86 of 86 fixture and
188 of 188 random cases where kinship2 returns, with `join` counted per shared tree (counted once per family, 90
differ); kinship2 stops in all 227 of 463 cases whose joins lie in one tree. 16 tests in a new file and a helper
(`helper-familyCheck.R`), every expected value computed before RED; RED 16 errors, each first on the missing
function. Checks: tests 553, 0 failed, WARN 0, SKIP 0, 2747 expectations; equal to kinship2 on at least 68 of 99
fixture cases and 97 of 200 random ones, and `makefamid()`'s numbers as `newfam` changing nothing (99 cases); lint
0; roxygen idempotent; drift tool 90 functions, 0 differ; `R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE
(tests PASS 2740, SKIP 3); coverage 97.38%, `R/familyCheck.R` 57 of 57 statements; CI run `43461775633` 5/5
`Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 2747; Windows 2746, SKIP 1; Ubuntu 2736,
SKIP 2). `ibdMatrix()` followed in S16 (below).

**Done 12 (`ibdMatrix()`; pedkindraw S16; R46-R48):** `ibdMatrix()` exported, pedkindraw's own code in
`R/ibdMatrix.R` with internal helpers `.ibdNames()`, `.ibdEntries()` and `.ibdSparse()` (REFACTOR) and
`.ibdListed()`. Written from kinship2's help page and measured results, its source not read (R14). Measured before
the picker, one process per case under `timeout 15`: kinship2 returned in 153 of 160 random cases with every
diagonal value or `diagonal` given (7 stops of its own, all with numeric ids), and without `diagonal` returned a 0
diagonal in 33 of 40 and never returned in 7; a scratch prototype equal to kinship2 at every id in 186 of 186 cases
where it returns. R46's account of kinship2's row order was corrected before GREEN (`ebab5b9`). 19 tests in a new
file and a helper (`helper-ibdMatrix.R`), the draft run against the prototype before RED; RED 19 errors, each first
on the missing function. Checks: tests 572, 0 failed, WARN 0, SKIP 0, 3120 expectations; equal to kinship2 on at
least 77 and 76 of 80 random cases each; lint 0; roxygen idempotent; drift tool 90 functions, 0 differ; `R CMD check
--as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 3113, SKIP 3); coverage 97.46%, `R/ibdMatrix.R` 77 of 77
statements; CI run `43480861654` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 3120;
Windows 3119, SKIP 1; Ubuntu 3109, SKIP 2). Phase 12 is DONE.

**Done 13 (`checkPedigree()`; pedkindraw S17; R49-R51):** `checkPedigree()` exported, pedkindraw's own new code in
`R/checkPedigree.R` with internal helpers `.checkRows()`, `.checkSorted()`, `.checkListed()`, `.checkOffspring()`,
`.checkCycles()` and `.checkSexRows()` and the names vector `.checkNames` (REFACTOR). Eleven checks (R50: the
contract's nine and `missingIds`, `sexCodes`). Measured before the pickers on a scratch prototype: equal to a slow
checker on 300 of 300 seeded random pedigrees; in agreement with kinship2 1.9.6.2's `pedigree()` on 224 of 224
cases compared (154 refusals, 70 acceptances); 0.17 s on 100,000 animals. 23 tests in a new file and a helper
(`helper-checkPedigree.R`, with the slow checker `checkPedigreeSlow()`), the draft run against the prototype before
RED (one hand-derived value corrected first); RED 23 errors, each first on the missing function. Checks: tests 595,
0 failed, WARN 0, SKIP 0, 3682 expectations; lint 0; roxygen idempotent; drift tool 90 functions, 0 differ; `R CMD
check --as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 3675, SKIP 3); coverage 97.57%, `R/checkPedigree.R`
83 of 83 statements; 0.14 s on 100,000 animals, 0.22 s with 5 cycles put in; CI run `43507284539` 5/5 `Status: OK`
at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 3682; Windows 3681, SKIP 1; Ubuntu 3671, SKIP 2).
Phase 13's second session, `findUnrelated()`, is next.

**Done 13 (`findUnrelated()`; pedkindraw S18; R52-R54):** `findUnrelated()` exported, pedkindraw's own new code in
`R/findUnrelated.R` with internal helpers `.founderAncestors()`, `.unrelatedNeighbours()`, `.unrelatedCount()`,
`.unrelatedPick()`, `.unrelatedSwap()` and `.unrelatedStopMessage()`, and `.checkPedFrame()`, which it shares with
`checkPedigree()` (REFACTOR). Relatedness from founder ancestors (R52); the fewest relatives first, ties in byte
order, then a swap pass (R53). Measured before the picker on a scratch prototype: kinship2 1.9.6.2 reproduced on the
comparison's three cases (4, 2 and 44 on 100 of 100 seeds); the related pairs equal to `kinship()` above 0 in every
pair of 350 cases; the largest possible set, by an exact search, in 1,290 of 1,292 random pedigrees. 19 tests in a
new file and a helper (`helper-findUnrelated.R`, with the slow check `findUnrelatedSlow()`), the draft run against
the prototype before RED (one hand-derived value corrected first); RED 19 of 19 failing, each first on the missing
function. Checks: tests 614, 0 failed, WARN 0, SKIP 0, 4332 expectations; lint 0; roxygen idempotent; drift tool 90
functions, 0 differ; `R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 4325, SKIP 3); coverage
97.69%, `R/findUnrelated.R` 88 of 88 statements; on `synthetic_10000` with 30% genotyped, 138 chosen in 0.57 s
(kinship2 137 in 6.5 s); CI run `43533292116` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each
(macOS PASS 4332; Windows 4331, SKIP 1; Ubuntu 4321, SKIP 2). Phase 13 is DONE; Phase 14, `asPedFrame()`, is next.

**Done 14 (kinship2; pedkindraw S19; R55-R57):** `asPedFrame()` exported, an S3 generic with a default method
refusing any other class and methods for kinship2's `pedigree` and `pedigreeList`, pedkindraw's own new code in
`R/asPedFrame.R` with internal helpers `.asPedFrameKinship2()`, `.asPedFrameConditions()` (REFACTOR),
`.asPedFrameText()` and `.asPedFrameTwins()`; the object read as a plain list, without kinship2 (R55); the columns,
twins and family-list rule of R56. Measured before the pickers: Pedixplorer's install in a scratch library, a
scratch lock file and a scratch `R CMD check` (R55); a prototype's round trip, a data frame through
`kinship2::pedigree()` and back, identical in 372 of 372 cases and differing in all 372 with the index-0 defect
planted; kinship2's `sample.ped` and `minnbreast` converted whole. 15 tests in a new file and a helper
(`helper-asPedFrame.R`, with the round trip `asPedFrameTrip()`), the draft run against the prototype before RED (one
hand-derived value corrected first; with the defect planted 8 of 15 fail); RED 15 of 15 failing, each first on the
missing function. Checks: tests 629, 0 failed, WARN 0, SKIP 0, 4750 expectations; lint 0; roxygen idempotent; drift
tool 90 functions, 0 differ; `R CMD check --as-cran` 0 errors, 0 warnings, R16's NOTE (tests PASS 4743, SKIP 3);
coverage 97.74%, `R/asPedFrame.R` 49 of 49 statements; 0.04 s for 100,000 animals; CI run `43626771667` 5/5
`Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 4750; Windows 4749, SKIP 1; Ubuntu 4739,
SKIP 2). Phase 14's second session, Pedixplorer's method, is next.

**Done 14 (Pedixplorer; pedkindraw S20; R58-R59):** Pedixplorer 1.8.0 (Bioconductor 3.23) installed into renv and
listed in `Suggests` (`c43b36a`: 49 packages as binaries; the lock 60 to 117 entries, no existing entry changed, a
top-level `"Bioconductor": {"Version": "3.23"}`; 8 dependencies already in renv's library from "latest" reinstalled
from the dated repository before the gate read 0). `asPedFrame()` gained the method `asPedFrame.Pedigree()`, which
refuses a non-S4 object as the default method does and stops when Pedixplorer is not installed, with internal
helpers `.asPedFrameHasPedixplorer()`, `.asPedFramePedixplorer()`, `.asPedFramePxConditions()`,
`.asPedFramePxStatus()`, `.asPedFramePxKeptFields()` (with `.asPedFramePxFields`) and `.asPedFramePxTwins()`, and
REFACTOR's `.asPedFrameTwinTable()`, shared with kinship2's twins; the columns, twins and stops of R58; the default
method's message names Pedixplorer's `Pedigree`. Measured before the pickers: Pedixplorer's help pages and objects;
a prototype's round trip, a data frame through `Pedixplorer::Pedigree()` and back, identical on 108 fixture cases
and 300 seeded random pedigrees, and differing in all 136 built without a condition with the comparison's all-`NA`
defect planted; a column-name clash the prototype let through silently (made a stop); 0.005 s for 100,000 animals.
14 tests in a new file and a helper (`helper-asPedFramePedixplorer.R`, with the round trip `asPedFramePxTrip()`),
the drafts run against the prototype before RED (two drafts wrong in the test and corrected; with the defect planted
6 of 14 fail); RED 15 failing (the 14 and the changed refusal test), each first on the missing method. Checks: tests
643, 0 failed, WARN 0, SKIP 0, 4991 expectations; lint 0; roxygen idempotent; drift tool 90 functions, 0 differ;
`R CMD check --as-cran` from a scratch folder 0 errors, 0 warnings, R16's NOTE (tests PASS 4984, SKIP 3); coverage
97.79%, `R/asPedFrame.R` 106 of 106 statements; CI run `43652270264` 5/5 `Status: OK` at the first attempt, pak
installing Pedixplorer on all five, `FAIL 0 | WARN 0` on each (macOS PASS 4991; Windows 4990, SKIP 1; Ubuntu 4980,
SKIP 2). Phase 14 is DONE; Phase 15's design session is next.

**Done 15a (pedkindraw S22; R64-R69):** `makePedigreeMatingLayout()` gained `hints = NULL`, `hints` a list whose
`order` (a numeric vector named by id) draws siblings, separate families and founder couples left to right in
increasing order (R60-R61). pedkindraw's own `R/layoutHints.R`: `.checkLayoutHints()` (R68's stops),
`.layoutHintRows()` (the named animals trade places among their own rows, R64), `.layoutHintKeepsRoots()` and
`.layoutHintRoots()` (a family whose founders the order names keeps their order, a founder couple placed by its
female's number, and the founder-reordering step skipped there, R65-R66), and REFACTOR's `.layoutHintPlaces()`. The
copied `R/makePedigreeDiagramData.R` changed by call-site lines only: `makePedigreeMatingLayout()` (the argument, its
help, the check, the row reorder, hints passed on) and `.positionMatingUnitForest()` (the argument, the per-family
call, the founder-step branch); `DIVERGENCE.md` rows for both (`a992463`), not mirrored (R8). Measured before the
pickers, on a scratch prototype against kinship2 1.9.6.2 and Pedixplorer 1.8.0: ties and partial orders in both;
one sibship hinted on 99 random pedigrees (family order changed 0 times with R64's rule, 19 with named-first; founder
order elsewhere 11 with R66's rule, 88 skipping always); all 720 founder orders of a 13-animal case (top row equal to
kinship2's 720 times with the female's number, 120 the anchor's, 348 the smaller); 200 random pedigrees completed
with a founder row for each missing parent (501 of 501 families' founder lines in hinted order; kinship2 returned
135 of 135, its top row equal to pedkindraw's in 17 hinted and 9 without hints); twins split by an order (kinship2
draws it as given, R67). 12 tests in `tests/testthat/test_layoutHintsOrder.R` and a helper
`helper-layoutHints.R` (the design's generator, checkers written apart from the code, kinship2's rows): drafts 12
of 12 passing on the prototype and 12 of 12 failing on unchanged HEAD before RED (`0ab1230`); GREEN `b598bcd`, its
code equal to the prototype's; REFACTOR `b9567bd`. Checks: suite 655 tests, 0 failed, WARN 0, SKIP 0, 5,066
expectations; lint 0; roxygen changed `man/makePedigreeMatingLayout.Rd` only; drift tool 2 differ, both with rows;
fidelity tool 600 of 600 identical without hints, kinship difference 0; coverage `R/layoutHints.R` 52 of 52, package
97.83%; `R CMD check --as-cran` from a scratch folder R16's NOTE only; a hinted layout drawn by
`drawPedigreeDiagram()` keeps its x; contract 4.1's row; CI run `43732712028` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS
5066; Windows 5065, SKIP 1; Ubuntu 5055, SKIP 2).

**Done 15b (pedkindraw S23; R70-R73):** `makePedigreeMatingLayout(..., hints = list(mate = ))`, `mate` a data frame
of `left`, `right` (a sire and dam with offspring together) and `anchor`, draws `left` left of `right` at their
mating and hangs the offspring under the anchor, the other partner a repeat node when it has parents (R60-R61; the
element renamed from `spouse`, R73). pedkindraw's own `R/layoutHints.R`: `.checkLayoutHints(hints, ped)` (the order
checks moved unchanged into `.checkLayoutHintOrder()`), `.checkLayoutHintMate()` (R70-R71's stops),
`.layoutHintMateRow()`, `.layoutHintAnchor()`, `.layoutHintSides()` (each hinted side, and a distance factor for
same-side mates, R72), `.layoutHintFamilies()` (an anchor's families following its mates, R72), and REFACTOR's
`.layoutHintMatingSides()`. The copied `R/makePedigreeDiagramData.R` changed by call-site lines only:
`.buildMatingUnitForest()` (the argument, 2 anchor lines), `.positionMatingUnitForest()` (1 line ordering an
anchor's families, 2 in the S666 pass, 3 in the seeding loop), `makePedigreeMatingLayout()` (the check takes `ped`,
rows sorted only for an order hint, `hints` to `.buildMatingUnitForest()`), the help (`hints$mate`; "It cannot be
turned off, unless a mate hint says otherwise"); `DIVERGENCE.md` rows for all three (`9c1e209`), not mirrored (R8).
Measured before the pickers on scratch prototypes against kinship2 1.9.6.2 and Pedixplorer 1.8.0: the design's M6
reproduced (`B A`, `C F D E`, as kinship2; Pedixplorer needs an `horder` with a spouse hint and fails on F left of D
unless D anchors); 1,090 of 1,090 hinted sides on 100 random pedigrees; anchors by generation (R71); a sire with
2 or 3 dams under three prototypes (R72); validation cases (R70). 9 tests in `tests/testthat/test_layoutHintsMate.R`
and six helpers added to `helper-layoutHints.R` (each mating's partners as drawn at its dot, families following
mates, kinship2's rows with a spouse hint): drafts 9 of 9 passing on the prototype and 9 of 9 failing on unchanged
HEAD before RED (`034ac3c`); GREEN `7889ec8`, its code equal to the prototype's (one helper's last `if`/`else`
braced for line length); REFACTOR `ffe042f`. Checks: suite 664 tests, 0 failed, WARN 0, SKIP 0, 5,144
expectations; lint 0; roxygen changed `man/makePedigreeMatingLayout.Rd` only; drift tool 3 differ, all with rows;
fidelity tool 600 of 600 identical without hints, kinship difference 0; coverage `R/layoutHints.R` 174 of 174 lines,
package 97.91%; `R CMD check --as-cran` from a scratch folder R16's NOTE only; an order and mate hinted layout drawn
by `drawPedigreeDiagram()` keeps its x (20 of 20 nodes); contract 4.1's row; CI run `43771237000` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS 5144; Windows 5143, SKIP 1; Ubuntu 5133, SKIP 2). Phase 15c, the
converters, is next.

**Done 15c (pedkindraw S24; R74-R76):** `asPedFrame()` returns `list(ped, twinRelations, hints)`, `hints` the
object's layout hints in `makePedigreeMatingLayout()`'s form (`order` named by id, `mate` rows of ids and
`"left"`, `"right"`, `"either"`, each only when held), or `NULL` (R62, R73). pedkindraw's own `R/asPedFrame.R`:
`.asPedFrameK2Hints()` and `.asPedFrameK2Mate()` (kinship2's `x$hints`, `order` by place and `spouse` rows of two
places and an anchor 1, 2, 0; R75's stops), `.asPedFramePxHints()` (Pedixplorer's `horder()` and `spouse()`),
`.asPedFrameHints()` (an `NA` in the order left out; `NULL` when nothing is left), `.asPedFrameUsableMate()` (R74's
fixes and message); a `pedigreeList` through the same code (R76); the help's "Layout hints" section and an
example. REFACTOR moved the mate check's pair, key and generation rules into three helpers in `R/layoutHints.R`
(`.layoutHintTogether()`, `.layoutHintPairKey()`, `.layoutHintAnchorGenerations()`) that the check and the
converter share. No copied function changed (drift tool 3 differ, all with rows). Measured before the picker on 212
pedigrees against kinship2 1.9.6.2 and Pedixplorer 1.8.0 (R74-R76's counts). 12 tests in
`tests/testthat/test_asPedFrameHints.R` (typed conversions, the fixes and their message, 9 unreadable forms, a
`pedigreeList`, Pedixplorer with families; 100 random family pedigrees each with `autohint()` and `auto_hint()`
hints, converted, checked against a row-by-row derivation and drawn, every hinted mating on its side; rows as
kinship2's `align.pedigree()` draws them on 42 typed cases and Pedixplorer's `align()` on 21, where each returns a
complete drawing) and the 9 whole-list tests (M8) expecting `hints = NULL`: drafts passing on the prototype (41
tests, 1,444 expectations) and the 21 failing on unchanged HEAD before RED (`9a0964a`); GREEN `593c9a8`, its code
equal to the prototype's (22 of 22 objects, lint fixes made in both); contract 4.5 `6887b8b`; REFACTOR `bcdc1b0`.
Checks: suite 676 tests, 5,929 expectations, 0 failed, WARN 0, SKIP 0; lint 0; roxygen changed
`man/asPedFrame.Rd` only; coverage `R/asPedFrame.R` 158 of 158 statements, `R/layoutHints.R` 149 of 149, package
97.96%; fidelity tool 600 of 600 identical, kinship difference 0; `R CMD check --as-cran` from a scratch folder
R16's NOTE only; a kinship2 object with hints converted and drawn by `drawPedigreeDiagram()` (8 of 8 nodes at the
layout's x); CI run `43781542125` 5/5 `Status: OK` at the first attempt, `FAIL 0 | WARN 0` on each (macOS PASS
5929; Windows 5928, SKIP 1; Ubuntu 5918, SKIP 2).

**Done 15 (pedkindraw S21-S24; R3, R60-R76):** layout hints a user supplies, `makePedigreeMatingLayout(...,
hints = list(order = , mate = ))`, and the same hints read from kinship2 and Pedixplorer objects by
`asPedFrame()`: the design (S21), 15a the order (S22), 15b the mate hint (S23), 15c the converters (S24), each
with its section 9 DONE criteria met. Without hints every result is nprcgenekeepr's. Phase 16 is next.

### Phase 16 -- Documentation (new repository)

README, a getting-started vignette, a drawing vignette, pkgdown site, NEWS; the Phase 1-2 timing, memory and
capacity tables summarized with their dates and machine (deferred by R82 until pedkindraw times itself).

Planned in pedkindraw's `docs/planning/documentation-plan.md` (pedkindraw S25; R77-R80): its section 6 gives each session's DONE
criteria, checks and surface, and its section 9 the details left to each session's picker.

| Session | Work | Source |
|---|---|---|
| 16a | `README.Rmd` and `README.md` with a still picture, `NEWS.md`, the package help page `?pedkindraw`; the words gate reads the README, NEWS and vignettes too | R77 |
| 16b | The getting-started vignette (`vignettes/pedkindraw.Rmd`, one live drawing); knitr and rmarkdown in Suggests; the 375-animal example in `inst/extdata/` | R77, R80 |
| 16c | The drawing vignette (`vignettes/drawing.Rmd`, several live drawings); the installed package under 5 MB | R77, R80 |
| 16d | DEFERRED (S30): the speed and size-limits vignette (`vignettes/speed.Rmd`, no drawings), every number checked by `tools/checkSpeedTables.R` against nprcgenekeepr's result files, waits until pedkindraw times itself; the draft on the branch `draft/speed-vignette`; the contract's section 7 shrink row done | R79, R82 |
| 16e | DONE (S31): the pkgdown site on GitHub Pages, built by a workflow into `pkgdown_site/`; then the site in `DESCRIPTION` and the README; Phase 16 DONE | R78, R82 |

**Done 16's plan (pedkindraw S25; R77-R80):** measured on scratch copies before the picker: a vignette page with
drawings is 1.6-1.9 MB (visNetwork's JavaScript on each page), the package without vignettes installs at 0.47 MB,
and three such pages installed at 5.4 MB, an INFO on R 4.6.2 that is a NOTE with `_R_CHECK_LOG_USE_INFO_` off;
`R CMD check --as-cran` otherwise R16's NOTE only; a pkgdown 2.2.1 trial site built in 34.5 s with the package
installed, stopped on the stale pedkindraw 0.0.1 in renv's library without it, and published the root's `CLAUDE.md`
and `DIVERGENCE.md`; a still picture by chromote in 8.7 s; a vignette rendered with kinship2 and Pedixplorer absent;
nprcgenekeepr S1141's re-timed files identical to those pedkindraw copied at `baef1e12c`. Mark picked the
recommended option on all four questions.

**Done 16a (pedkindraw S26):** `README.Rmd` knitted to `README.md` (two renders the same), its example run when
knitted and each statement its text makes held by a hidden `stopifnot()` chunk; the picture
`man/figures/README-pedigree.png`, made by `tools/makeReadmePicture.R` from the README's own chunks; `NEWS.md`;
`R/pedkindraw-package.R` for `?pedkindraw`; the words gate widened to the README, NEWS and vignettes. Mark's picks:
D1 pak; D2 a 12-animal pedigree with one condition, after the 13-animal one with two conditions showed every
symbol split into sections the legend does not explain (a backlog item). NEWS's heading names the version,
`# pedkindraw 0.0.1 (development version)`: without a number R finds no entries and `R CMD check` adds a NOTE.
Checks: all 31 exports named in `README.md`; suite 676 tests, 0 failed, WARN 0, 5,929 passed; lint 0; roxygen
added `man/pedkindraw-package.Rd` only; `R CMD check --as-cran` R16's NOTE only, installed 608 KB; drift tool 3
differ, all with rows; CI run `43805309511` 5/5; the README and its picture viewed on the repository's GitHub
page.

**Done 16b (pedkindraw S27):** `vignettes/pedkindraw.Rmd`, "Getting started with pedkindraw": R80's two files in
`inst/extdata/` (`cmp` equal to nprcgenekeepr's at `baef1e12c`), read with `system.file()`; checking and repairing,
generations and family trees, kinship, trimming, one drawing, shrinking, unrelated animals, and kinship2's
`sample.ped` through `asPedFrame()` (run only when kinship2 is installed). Each value its text states is held by a
hidden `stopifnot()` chunk, each shown stopping a render with one value changed. Mark's pick (D3): the drawing of
ED5PDV's 16 ancestors, whose sire and dam are half siblings, from three candidates drawn on trial pages at the
vignette's width; 36-37 animals drew their ids too small or not at all. A drawing chunk needs `out.width = "100%"`
(html_vignette's `fig.width = 3` drew it 288 px wide). knitr and rmarkdown in Suggests with `VignetteBuilder:
knitr` (the lock unchanged). `?pedkindraw` names the vignette. Checks: rendered with kinship2 and Pedixplorer
absent; on the built page in headless Chrome all 51 layout nodes inside the drawing's canvas (the check failing
when zoomed in); suite 676 tests, 0 failed, WARN 0, 5,929 passed; lint 0; roxygen idempotent; `R CMD check
--as-cran` R16's NOTE only, vignettes re-built OK, installed 2,236 KB; drift tool 3 differ, all with rows;
`quality_ratchet.py --run` 5/5; CI run `43810961086` 5/5, the vignette re-built on each.

**Done 16c (pedkindraw S29):** `vignettes/drawing.Rmd`, "Drawing pedigrees" (`7ab93a0`): section 5.4's topics in
11 drawings, each a small typed pedigree but the last (R80's 375 animals with its twins): rows and mating dots, the
five sex symbols, the deceased slash, the legend and hover text; one condition, three as sections with the legend's
pictures (R81), and `conditionsNotDrawn`; twins checked by `checkTwinRelations()`; an animal drawn twice; a mating of
full siblings; the two edge styles; `isolatedIds`; the order and mate hints; kinship2 and Pedixplorer objects with
hints set by hand through `asPedFrame()` (run only when each is installed; the same layout as the mate hint, and
`kinship2::autohint()` gives the same hints here); `saveWidget()` and the PNG button; `onClick` in Shiny (not run;
the ids a click passes measured in Chrome); the colony-size drawing. Mark's picks: the draft as drawn on a trial page
at the vignette's width; the colony layout's warning (72 same-row collisions) shown and explained; the size limit
stated from the November 2026 records (comparison doc section 9) until 16d's vignette, which then adds the pointer.
Each statement of where an animal is drawn or what a drawing shows is held by a hidden `stopifnot()` chunk, six
shown stopping a render with one value changed; two drafted checks were wrong (the turning points' rows, an integer
against a double) and stopped the trial render before the commit. `?pedkindraw` and the getting-started vignette's
"Where next" name it. Checks: rendered with kinship2 and Pedixplorer absent; on the built page in headless Chrome
every node of all 11 drawings inside its canvas (1,466 of 1,466 for the colony; the check failing when zoomed in),
the hover greying and tooltip as the text says; suite 684 tests, 0 failed, WARN 0, 6,109 passed; lint 0; roxygen
changed only `man/pedkindraw-package.Rd`; words gate 0; `R CMD check --as-cran` R16's NOTE only, vignettes re-built
OK, installed 4,284 KB (`doc/` 3,700 KB, the drawing page 2,041,640 B; under R77's 5,120 KB); drift tool 5 differ,
all with rows; `quality_ratchet.py --run` 4/5 pass, the suite gate unmeasured (its 300 s limit; the suite by hand
WARN 0; a backlog item); CI run `43937366764` 5/5, the vignettes re-built on each; Mark looked at the built page. Found:
`drawPedigreeDiagram()`'s "Select by id" box also lists the layout's `__jog_` routing points (196 in the colony
drawing), nprcgenekeepr's code the same (a backlog item).

**Deferred 16d (pedkindraw S30; R82):** the speed and size-limits vignette was drafted to R79 and not shipped.
`tools/checkSpeedTables.R ../nprcgenekeepr` was written first: it builds each of the nine tables, and its caption
(dates, nprcgenekeepr commits, versions, machine), from nprcgenekeepr's committed results (`git show` at
`2a1431f30`, `5970b1ce5`, `25ba45ecb`), this plan's Done 13 and 14 records and the ledger, and compares the
vignette cell for cell. Run before the tables were filled it failed (0 of 417 numbers); at the end 366 of 366 cells
holding a number and 621 of 621 cells matched, and a changed number, swapped rows, an unmarked table and a changed
Done record each failed it; a separate check against the studies' printed tables agreed on 298 cells. Mark asked
for a definition of each computation (added), then judged the comparison premature while pedkindraw still tracks
nprcgenekeepr: R82. The draft is on the branch `draft/speed-vignette` (`612eed9`), not merged; the contract's
section 7 shrink row gained the rewrite's 3.69 s at 1,000 animals and 92.0 s at 3,000; `?pedkindraw` and the two
vignettes name no speed vignette. The fidelity tool, run for the draft's statement that pedkindraw's layouts without
hints are nprcgenekeepr's: 600 of 600 identical. Phase 16e, the site, is next.

**Done 16e (pedkindraw S31; R78, R82):** the website, <https://rmsharp.github.io/pedkindraw/>: `_pkgdown.yml`
(`destination: pkgdown_site`, Bootstrap 5, the 32 help pages in `?pedkindraw`'s seven groups) and
`.github/workflows/pkgdown.yaml` (`4c389e7`), which on each push to master installs the package, deletes
`CLAUDE.md` and `DIVERGENCE.md` from its copy (pkgdown 2.2.1 publishes every root `.md` but README, NEWS and
LICENSE, and has no setting to exclude one), builds, and deploys to `gh-pages` with
`JamesIves/github-pages-deploy-action` v4.8.0 pinned at `d92aa23`; then the site in `DESCRIPTION`'s `URL`, the
README and `?pedkindraw`'s links (`d00ebda`). Mark's picks: the outline (menu, groups, what is left off) before the
file was written; pkgdown run locally from R's own library, the dated repository's version (D4: renv would lock it
only from `Suggests`); the action's version; turning on Pages once the first run had made `gh-pages`. Checks:
`check_pkgdown()` run on the incomplete index failed (28 topics missing), then "No problems found" (on a scratch
copy whose `DESCRIPTION` named the site, since pkgdown's URL check stops first; on the tree once it did); a local
build as the workflow runs it, exit 0, 45 pages, no `CLAUDE.html` or `DIVERGENCE.html`; the first run (`43979094493`)
3 min, `gh-pages` holding no project note; the site 200 within a minute of Pages turned on, `CLAUDE.html` and
`DIVERGENCE.html` 404; on the live articles in headless Chrome every node of all 12 drawings inside its canvas
(Getting started 51 of 51; the colony drawing 1,466 of 1,466; zoomed in 6x, some outside in all 12); every URL in
`README.md` and `DESCRIPTION` 200; `R CMD check --as-cran` R16's NOTE only, the incoming check reading the live
URLs, vignettes re-built OK, installed 4,284 KB; suite 684 tests, 0 failed, 0 skipped, WARN 0, 6,109 passed;
`quality_ratchet.py --run` 5/5; roxygen changed only `man/pedkindraw-package.Rd`, then nothing; drift tool 5 differ,
all with rows; CI runs `43979094656` and `43981525833` 5/5, and the second site build's sitrep "URLs ok". Found: the
legend cuts its "Same animal, again" row in the site's 776 px widgets (one window width measured; a backlog item).

**Done 16 (pedkindraw S25-S31; R77-R82):** the README, NEWS and `?pedkindraw` (16a), the getting-started vignette
with the 375-animal example file (16b), the drawing vignette (16c), and the website with both vignettes as articles
(16e), each with its section 6 DONE criteria met; 16d, the speed and size-limits vignette, deferred by R82 until
pedkindraw times itself. The package installs at 4,284 KB, under R77's 5,120 KB. Phase 17 is next.

### Phase 17 -- CRAN submission (new repository; its own plan first)

Modeled on `docs/planning/cran-3.0.0-submission-plan.md`. The readers stay out (R13), so the linux-arm64 read problem
this project met (`readWithFinalNewline()`, S1093) does not apply.

Planned in pedkindraw's `docs/planning/cran-submission-plan.md` (pedkindraw S32; R83-R85): its section 6 gives each
phase's DONE criteria, commands and surface, its section 7 the decisions left to each phase's picker, its section 8
the order and a guess of 17 to 22 sessions (about 20 to 23 since R93).

| Phase | Work | Source |
|---|---|---|
| 17a | The check time on win-builder R-devel, against 540 s | R85 |
| 17b | The argument-name review: a ruling per name (no code) | contract section 6, R84 |
| 17c1 | `kinship()`: `sire` and `dam`, the `pdepth` check, the shared-names note (strict TDD) | R87, R91, R92, R93 |
| 17c2 | The pedigree argument is `ped` in four more exports (strict TDD) | R88, R93 |
| 17c3 | The pedigree first in four exports (strict TDD) | R89, R93 |
| 17d | "Select by id" leaves out the `__jog_` routing points (strict TDD) | R84 |
| 17e | The legend's "Same animal, again" label fits (strict TDD) | R84 |
| 17f | What kinship2 or Pedixplorer can do that pedkindraw cannot (`docs/research/`) | R84 |
| 17g | The plan for pedkindraw's own timing runs (a planning session) | R82, R84 |
| 17h | The timing runs (sessions set by 17g) | R82, R84 |
| 17i | The speed vignette (Phase 16d returns) | R79, R82, R84 |
| 17j | Tests for full coverage | R84 |
| 17k | The CRAN-mode test time: a win-builder reading after 17j, a cut only if over 540 s | R85, R86 |
| 17l | Static hygiene and noSuggests | |
| 17m | NEWS, the README, the version number | |
| 17n | The full local gate; the tree freezes | |
| 17o | `cran-comments.md` and the cross-platform runs | |
| 17p | Submission (Mark's action) | |
| 17q | After acceptance | |

**Done 17's plan (pedkindraw S32; R83-R85):** measured on this Mac under load (load average 5.3-12.7): `R CMD check
--as-cran` 181 s with R16's NOTE only, its tests 118 s, examples 1.1 s; win-builder estimate 615-688 s against CRAN's
600 s; in CRAN mode 684 tests, 0 failed, 8 skipped, 103.6 s, eight files 81% of it; `mockery` and `withr` used in
tests without a guard, 7 of the 9 Suggests in R's own library; 49 words for the spelling check, 0 in `DESCRIPTION`;
22 of the 31 export names shared with nprcgenekeepr, 6 with kinship2, 1 with Pedixplorer; nprcgenekeepr 165 commits
after `baef1e12c` (to `363137511`), none to the 79 copied files' sources after their copy commits. Mark picked the
outline, all four open items before the release, and the win-builder measurement first.

**Done 17a (pedkindraw S33; R86):** win-builder R-devel (r90914) read 398 s for the tarball built from `eaff4a7`
(`W1Ko4S0RDs2W`), `Status: 1 NOTE` (R16's), the spelling step flagging nothing; tests 286 s, vignettes 18 s, R code
16 s, examples 13 s, PDF manual 13 s. The same tarball took 208 s on this Mac at load 10-13, a ratio of 1.9 (2.3 for
the tests' CPU time), so S32's 615-688 s estimate was high. The tests ran on an idle machine (elapsed equal to CPU),
so a busy day could read about 470-550 s. Mark picked "Decide after 17j": 17k opens with one more reading.

**Done 17b (pedkindraw S34; R87-R93):** seven rulings, each Mark's pick of Claude's recommendation: `kinship()` says
`sire` and `dam` (R87); the pedigree argument is `ped` in every export, `trimmedPed` beside it in
`addBackSecondParents()` (R88); the pedigree comes first in every export that takes one (R89); `addIdRecords()` stays
internal (R90); the shared export names stay, with a note (R91); `kinship()` refuses a `pdepth` that puts a parent
at or after its offspring (R92); 17c is three sessions (R93). Measured by parsing every call: 23 calls to rewrite for
R89, none for R87 (but the copied C13 test) or R88. No code changed.

**Done 17c1 (pedkindraw S35; R87, R91, R92):** `kinship(id, sire, dam, pdepth, ...)`; it stops, after its other
input checks, when a known parent's `pdepth` is not below its offspring's, naming the animal and saying the 4th
argument is `pdepth`, not `sex` (Mark's message pick); its help and the README name the shared exports and say that
kinship2's and Pedixplorer's `kinship()` take a pedigree object or the vectors `id`, `dadid`, `momid`, `sex`.
kinship2's call form is stopped in all 428 families of `sample.ped` and `minnbreast`. One copied test computes
`smallPed`'s `gen` (its stored one is wrong in 8 of 17 animals). A `DIVERGENCE.md` row; REFACTOR skipped (Mark's
pick). Fidelity tool 600 of 600 identical; `R CMD check --as-cran` R16's NOTE only.

**Done 17c2 (pedkindraw S36; R88):** `getParents(ped, ids)`, `getOffspring(ped, ids)`, `getIdsWithOneParent(ped)`
and `addBackSecondParents(trimmedPed, ped)`, in the old positions, so no caller changed; a call that names
`pedSourceDf` or `uPed` now stops ("unused argument"). Four `DIVERGENCE.md` rows; a NEWS bullet (Mark's pick);
`getIdsWithOneParent()` has a test file of its own (Mark's pick); REFACTOR skipped (Mark's pick). Fidelity tool 600
of 600 identical; `R CMD check --as-cran` R16's NOTE only.

**Done 17c3 (pedkindraw S37; R89):** `getProbandPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`,
`trimPedigree(ped, probands, removeUninformative, addBackParents)` and `hasBothParents(ped, id)`, with the 23 calls
that passed both by position rewritten (the fidelity tool's name both arguments, so one call runs on both
packages); a call in nprcgenekeepr's order now stops ("$ operator is invalid for atomic vectors"), tested. Four
`DIVERGENCE.md` rows; `getParents()`'s sentence on the order dropped and a NEWS bullet (Mark's picks);
`hasBothParents()` has a test file of its own (Mark's pick); REFACTOR skipped (Mark's pick). Fidelity tool 600 of 600
identical; `R CMD check --as-cran` R16's NOTE only.

**Done 17d (pedkindraw S38; R94):** the "Select by id" box leaves out `__jog_`, the routing points
`.resolveEdgeNodeCollisions()` adds (the drawing vignette's colony box, read in headless Chrome, 376 options for its
375 animals, was 572), and `.buildMatingUnitForest()` refuses a real id that starts with `__jog_` (Mark's pick: it
had collided silently with a routing point). The six reserved prefixes are written once, `.reservedIdPrefixes` and
`.reservedIdPattern` (REFACTOR, Mark's pick). Port later (Mark's pick): two `DIVERGENCE.md` rows and the fidelity
tool's `withoutJogSelections()` until nprcgenekeepr has it; two NEWS bullets. Fidelity tool 600 of 600 identical;
`R CMD check --as-cran` R16's NOTE only.

**Done 17e (pedkindraw S39; R95):** the legend's "Same animal, again" label was covered by the arrowhead
`visLegend()` gives every legend line by default (5.5 px at the website's 776 px widgets, 10.1 px at 700 px), not
cut by the legend's width. The legend's four lines now have no arrowheads, as the diagram's lines have none, and each
label sits on white, so the dashed line no longer turns its comma into a semicolon (Mark's picks). The fidelity
tool's three set-asides walk the results through one `eachDrawing()` (REFACTOR, Mark's pick). Port later (Mark's
pick): the `drawPedigreeDiagram()` row and the tool's `withoutLegendLineStyle()` until nprcgenekeepr has it; a NEWS
bullet. The shipped vignettes' 12 drawings in headless Chrome, 48 of 48 line labels whole; fidelity tool 600 of
600 identical; `R CMD check --as-cran` R16's NOTE only.

### Later, optional -- nprcgenekeepr uses the new package

Only on Mark's decision (R8). Its own plan; the scoping doc §7 steps 3-4 are the checklist.

---

## 5. Drift rule while two copies exist (R8)

From Phase 6 on, a change to a copied function in either repository is either made in the other repository
too (in a session of its own there) or recorded as a row in the new repository's `DIVERGENCE.md` (function,
both commits, why). The new repository carries `tools/compareWithNprcgenekeepr.R`, which lists every copied
function whose arguments or code differ from nprcgenekeepr's, read from the local clone with git (nprcgenekeepr is
installed nowhere there); every difference it lists must have a row.
In nprcgenekeepr, a fix to a copied function that is not yet mirrored gets a `BACKLOG.md` line naming it.

---

## 6. Risks

| Risk | Where it bites | Countermeasure |
|---|---|---|
| The comparison finds Pedixplorer already offers what the package was for | Phase 2 | Phase 2's DONE includes the "what is left to offer" paragraph; if little is left, Mark decides before Phase 3 whether to continue. |
| Copied tests depend on nprcgenekeepr datasets and `qcStudbook()` | Phases 6-10 | Saved fixture files; §3.3 lists the datasets. |
| License incompatibility of ported kinship2 code | Phase 4 | Facts in §1.3; Mark decides before any copy. |
| Two copies drift | Phase 6 onward | §5. |
| Timing figures distorted by machine load | Phases 1-2 | Fresh process, warm-up, median of 3, `uptime` first, nothing else running. |
| The copy is overtaken by engine changes during Phases 1-5 | Phases 6-10 | Each slice names its source commit; diff against the latest nprcgenekeepr before starting a slice. |

## 7. Alternatives considered

| Alternative | Why not |
|---|---|
| Move the code and have nprcgenekeepr import it (scoping doc Option C) | Mark ruled copy (R8): every diagram fix would span two repositories and nprcgenekeepr's next release would wait on the new package's CRAN acceptance. |
| Carry `qcStudbook()` / `groupAddAssign()` | R9: +40 / +48 functions of colony logic and three more dependencies for two kinship2 functions. |
| Decide the input style now | R7: a prototype was the S742 condition, and Pedixplorer's S4 object is a third candidate nobody had seen. |
| Compare with kinship2 only | R5: misses Pedixplorer, which would decide whether the package is still needed. |

## 8. Scope boundary

This plan does not: write or change package code; change nprcgenekeepr's `R/`, `tests/`, `DESCRIPTION` or
docs; pick the name, license or input style; create a repository; re-open any ruled pedigree-layout design
(`docs/planning/pedigree-diagram-*` stand as written).

---

## Appendix A -- Commands behind §3

Run from the project root. `S` is a scratch directory.

```r
# closure.R: dependency closure per seed group (abridged; the S1121 script also printed per-file counts)
Sys.setenv(NOT_CRAN = "true"); suppressMessages(pkgload::load_all(".", quiet = TRUE))
ns <- asNamespace("nprcgenekeepr"); imp <- parent.env(ns); all <- ls(ns, all.names = TRUE)
fns <- all[vapply(all, function(f) is.function(get(f, ns)), logical(1))]
G <- lapply(setNames(fns, fns), function(f) {
  x <- codetools::findGlobals(get(f, ns), merge = FALSE); unique(c(x$functions, x$variables)) })
closure <- function(seeds) { seen <- character(); todo <- seeds
  while (length(todo)) { f <- todo[1]; todo <- todo[-1]; if (f %in% seen) next
    seen <- c(seen, f); todo <- c(todo, setdiff(intersect(G[[f]], fns), seen)) }; seen }
lines <- function(f) { s <- attr(get(f, ns), "srcref"); if (is.null(s)) 0L else s[3] - s[1] + 1L }
file  <- function(f) basename(utils::getSrcFilename(attr(get(f, ns), "srcref"), TRUE))
# outside packages: `pkg::` in deparse(get(f, ns)) plus imports found in parent.env(ns)
cl <- closure(c("makePedigreeMatingLayout", "makePedigreeDiagramData", "drawPedigreeDiagram",
  "kinship", "findGeneration", "findPedigreeNumber", "addParents", "correctParentSex",
  "addBackSecondParents", "getIdsWithOneParent", "shrinkPedigree", "trimPedigree",
  "removeUnknownAnimals", "removeUninformativeFounders", "getProbandPedigree",
  "getDescendantPedigree", "readTwinRelations", "checkTwinRelations"))
length(cl); sum(cl %in% getNamespaceExports(ns)); sum(vapply(cl, lines, 1L))
length(unique(vapply(cl, file, "")))   # 94, 25, 4162, 37
```

- Subject tests (`subject.R`): test and helper files whose name (without `test_`, `test-`, `helper-`)
  equals a copy-set function or source file, or starts with `diagram`, `maleLeft`, `solveJointQP`,
  `perfBudget_diagram`, `live-render`, `comparePedigree`, `drawPedigree`, `pedigreeDiagram`, `e2e-pedigree`.
- Fixture readers: `git grep -c 'obfuscated_rhesus_mhc_ped' -- tests/testthat` (23 files).
- Churn: `git log --since=2026-09-03 --oneline -- R/makePedigreeDiagramData.R R/positionTreeApportion.R | wc -l`
  (29); `--since=2026-10-03` (7).
- Comparator versions: `https://cran.r-project.org/package=kinship2`, `https://cran.r-project.org/package=ggpedigree`,
  `https://bioconductor.org/packages/release/bioc/html/Pedixplorer.html`, read 2026-11-02.
