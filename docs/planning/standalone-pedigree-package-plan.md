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
change ported (pedkindraw S12, R37; `DIVERGENCE.md` has no row).
**Next:** Phase 10, shrink (`shrinkPedigree()`), the last copy slice.
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
| 10 | Shrink | copy nprcgenekeepr's clean-room `R/shrinkPedigree.R` and its helpers (C2) | -- |

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
| 11 | Export the rewrite's shrink helpers and `bitSize` (contract section 4.3) | R3, R11 |
| 12 | Write `familyCheck()` and `ibdMatrix()` from kinship2's documented behaviour, not its source (estimate: 2 sessions) | R3, R11; gap analysis rows 7, 12 |
| 13 | Short pedigree checker and short unrelated-set finder | R9; sized at Phase 1, specified at Phase 4 |
| 14 | Input converters from kinship2 `pedigree` and Pedixplorer `Pedigree` objects (picked S1126; what each reads and two test cases: comparison doc section 11.2) | R7 |
| 15 | User-suppliable layout hints: a design session first (engine-surface design), then the build | R3 |

### Phase 16 -- Documentation (new repository)

README, a getting-started vignette, a drawing vignette, pkgdown site, NEWS; the Phase 1-2 timing, memory and
capacity tables summarized with their dates and machine.

### Phase 17 -- CRAN submission (new repository; its own plan first)

Modeled on `docs/planning/cran-3.0.0-submission-plan.md`. The readers stay out (R13), so the linux-arm64 read problem
this project met (`readWithFinalNewline()`, S1093) does not apply.

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
