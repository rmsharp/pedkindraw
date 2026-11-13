# Roadmap

What pedkindraw is working toward, what it can do today and how it got here. The plan, with each phase's DONE
criteria, is `docs/planning/standalone-pedigree-package-plan.md`; open work is `methodology/BACKLOG.md`; what each
session did is `methodology/CHANGELOG.md`.

## Current Milestone

**The copy slices, plan Phases 6-10.** pedkindraw starts as a copy of nprcgenekeepr's tested code (plan R8;
nprcgenekeepr is not changed). Each slice copies one group of functions, tests first, and its results must be
identical to nprcgenekeepr's on the Phase 1 pedigrees. Why: when the five slices are done, pedkindraw computes
kinship, trims and shrinks pedigrees and draws them interactively, and the drawing is what the comparison found is
left to offer next to kinship2, Pedixplorer and ggpedigree (`docs/research/pedigree-package-comparison-2026-11.md`
section 10). All five are done (S13). The new work of Phases 11-15 has begun: Phase 11 is done (S14), Phase 12
(S15-S16) and Phase 13's first half, `checkPedigree()` (S17; What's Built, below); next is its second half,
`findUnrelated()` (Planned, below).

| Phase | Slice | State |
|---|---|---|
| 6a | 10 relationship functions: generations, family ids, parents, offspring, founders, walking | DONE (pedkindraw S3) |
| 6b | 11 functions that repair and trim pedigrees, and the constant `sexCodes` (R25) | DONE (pedkindraw S7) |
| 7 | kinship and twins: `kinship()`, `checkTwinRelations()` (nprcgenekeepr's clean-room code, C2) | DONE (pedkindraw S8) |
| 8 | layout engine: `makePedigreeMatingLayout()`, `makePedigreeDiagramData()` (2 sessions, R30) | DONE (pedkindraw S9-S10) |
| 9 | renderer: `drawPedigreeDiagram()`, a `visNetwork` widget | DONE (pedkindraw S11) |
| 10 | shrink: `shrinkPedigree()` (clean-room code, C2) | DONE (pedkindraw S13) |

## Planned

Scoped in the plan (section 4) and the API contract (`docs/planning/pedkindraw-api-contract.md` section 4); one
session each unless marked. They follow the copy slices.

- **Phase 13, second session:** `findUnrelated()`, a short unrelated-set finder that gives the same answer every
  time (R9, R49; contract section 4.4). Next (`methodology/BACKLOG.md`). Its first session, `checkPedigree()`, is
  done (S17).
- **Phase 14:** `asPedFrame()`, converters from kinship2 `pedigree` and Pedixplorer `Pedigree` objects; both packages
  stay optional (R7; contract section 4.5).
- **Phase 15:** layout hints a user can supply: a design session first, then the build (R3).
- **Phase 16:** documentation: README, a getting-started and a drawing vignette, a pkgdown site, NEWS, the Phase 1-2
  timing tables.
- **Phase 17:** the CRAN submission, its own plan first. Before it, a review of argument names (contract section 6).
- **Later, optional:** nprcgenekeepr uses pedkindraw, only on Mark's decision (R8).

## What's Built

- **Pedigree checker (Phase 13, first session), 1 export:** `checkPedigree()` lists a pedigree's problems, one row
  per problem id (`check`, `id`, `detail`), and repairs nothing: ids missing or duplicated, an animal its own
  parent or its own ancestor, parents with no row, `"0"` or blank for an unknown parent, male dams, female sires,
  parents of unknown sex, one id used as sire and dam, and sex codes other than M, F, H, U (R49-R51). pedkindraw's
  own new code with internal helpers `.checkRows()`, `.checkSorted()`, `.checkListed()`, `.checkOffspring()`,
  `.checkCycles()` and `.checkSexRows()`. 23 tests; checked against a slow checker on 300 random pedigrees and,
  where installed, against what kinship2's `pedigree()` refuses and accepts. 0.14 s on 100,000 animals.
- **IBD matrix (Phase 12, second session), 1 export:** `ibdMatrix()` turns pairs of ids and their IBD values, as
  programs such as SOLAR write them, into kinship2's class, a symmetric sparse `dsCMatrix` with a row and a column
  per id, sorted (numbers by value, character ids in byte order), named from `idmap` when given (R46-R48).
  pedkindraw's own code with internal helpers `.ibdNames()`, `.ibdEntries()`, `.ibdSparse()` and `.ibdListed()`;
  written from kinship2's help page and measured results, not its source (R14). It gives kinship2's value for every
  pair wherever kinship2 returns, and stops with a plain message where kinship2 is silent, wrong or never returns
  (a missing diagonal value, unequal lengths, one pair given two values). 19 tests; checked against
  `kinship2::ibdMatrix()` where installed.
- **Family check (Phase 12, first session), 1 export:** `familyCheck()` compares the family ids animals are given
  with the family trees their parent links form: per family id, its animals, those related to no one, the trees it
  spans (`split`) and the other family ids sharing them (`join`), and a table of the joined ids by tree (R43-R45).
  pedkindraw's own code with two internal helpers, `.familyTrees()` (numbered as kinship2's `makefamid()`) and
  `.familyJoinTable()`; written from kinship2's help pages and measured results, not its source (R14). It gives
  kinship2's `familycheck()` answer wherever kinship2 returns, and answers where kinship2 stops (every join inside
  one tree, empty input). 16 tests; checked against `kinship2::familycheck()` and `makefamid()` where installed.
- **Shrink steps (Phase 11), 4 exports:** `bitSize()` (kinship2's list: `bitSize`, `nFounder`, `nNonFounder`),
  `findUnavailable()`, `findAvailNonInform()` and `findAvailAffected()`, each giving `shrinkPedigree()`'s answer for
  its step (R40-R42): the first trim's ids, the second trim's ids (the first run inside), and one third-trim removal
  returned with kinship2's `ped`, `idTrimmed`, `isTrimmed`, `bitSize`, so repeated calls walk the third trim.
  pedkindraw's own code, calling the copied internals of `R/shrinkPedigree.R` (unchanged) and one internal helper,
  `.parentPositions()`; written from kinship2's help pages, not its source (R11). 32 tests; checked against
  `kinship2::bitSize()` and the first two steps of `kinship2::pedigree.shrink()` where kinship2 is installed.
- **Shrink (Phase 10), 1 export:** `shrinkPedigree()` trims a pedigree to the animals that keep it informative within
  a genotyping budget (`maxBits`), in kinship2's three tiers (unavailable, non-informative, affected-priority); it
  stops with a plain message on malformed input (C15) and breaks ties by byte order, the same on every computer
  (C16); 4 internal helpers. nprcgenekeepr's clean-room code (C2) copied from `baef1e12c`, code unchanged; its 24
  tests pass as there, and its results are identical to nprcgenekeepr's.
- **Renderer (Phase 9), 1 export:** `drawPedigreeDiagram()` turns a layout into an interactive `visNetwork` widget:
  the symbols at the layout's positions, the legend, each deceased animal's slash and each multi-condition symbol's
  coloured sections (painted by a drawing script inside the widget), Export Diagram (PNG), Select by id and the hover
  highlight; 6 internal functions and 2 constants (`deceasedSlash.R`, `affectedConditions.R`'s drawing half). Copied
  from nprcgenekeepr `471589138` (R34) and `baef1e12c`, code unchanged, help rewritten (R36); its 12 tests and the
  3 Chrome tests pass as there, and its widgets are identical to nprcgenekeepr's. Imports `visNetwork`; CI sets up
  Chrome. nprcgenekeepr's later legend fill (S1159: the five sex symbols open, as the diagram draws an unaffected
  animal) was ported in S12 (R37), so the copy matches nprcgenekeepr `4283e3502`.
- **Layout engine (Phase 8), 2 exports:** `makePedigreeMatingLayout()` (each animal's position, symbol and hover
  text, union nodes for matings, lines routed `"rectilinear"` or `"direct"`, twins, consanguineous matings marked from
  `kinship()`, up to four affected conditions) and `makePedigreeDiagramData()` (plain nodes and edges for visNetwork);
  52 internal functions and 4 constants, among them nprcgenekeepr's clean-room solver (C2) and the four that compare a
  layout's structure with kinship2's (`comparePedigreeStructure.R`, used by the tests). Copied from nprcgenekeepr
  `baef1e12c`, code unchanged; its 333 tests pass as they do there (R29-R33), and its results are identical to
  nprcgenekeepr's. Imports `quadprog`, `utils`.
- **Kinship and twins (Phase 7), 2 exports:** `kinship()` (autosomal or X-chromosome kinship, dense or a `Matrix`
  sparse matrix, identical twins declared in a `twinRelations` table made identical) and `checkTwinRelations()`
  (validates that table by kinship2's rules); internal `mzTwinGroups()` and the constant `mzTwinIdsAbsentMessage`.
  nprcgenekeepr's clean-room code (C2) copied from `baef1e12c`; results identical to it. Imports `Matrix` (R27),
  `methods`, `stats`.
- **Pedigree repair and trimming (Phase 6b), 8 exports:** `trimPedigree()`, `removeUninformativeFounders()`,
  `addBackSecondParents()`, `getIdsWithOneParent()`, `hasBothParents()`, `addParents()`, `correctParentSex()`,
  `removeUnknownAnimals()`; internal `addIdRecords()` (exported in nprcgenekeepr; contract section 4.1),
  `isAddedRecord()`, `rbindFill()` and the constant `sexCodes`. Copied from nprcgenekeepr `baef1e12c`; results
  identical to it. Imports `data.table` (only `addIdRecords()` uses it).
- **Pedigree relationships (Phase 6a), 8 exports:** `findGeneration()`, `findPedigreeNumber()`, `getParents()`,
  `getOffspring()`, `getFounders()`, `isFounder()`, `getProbandPedigree()`, `getDescendantPedigree()`; internal
  `isEmpty()` and `walkPedigree()`. Copied from nprcgenekeepr `baef1e12c`; results identical to it.
- **Package skeleton (Phase 5):** `DESCRIPTION` 0.0.1, MIT `LICENSE` (R14, R17), roxygen2, testthat 3rd edition,
  `.lintr` with nprcgenekeepr's linters, renv on a dated Posit snapshot, GitHub Actions R-CMD-check on Linux (devel,
  release, oldrel-1), macOS and Windows.
- **Checks against nprcgenekeepr** (read from its local clone): `tools/compareWithNprcgenekeepr.R`, the drift check
  (plan section 5; `DIVERGENCE.md` records allowed differences: none since S12), and
  `tools/compareResultsWithNprcgenekeepr.R`, which compares every copied function's results, warnings and messages
  on the Phase 1 pedigrees (the layout and shrink on at most 400 animals of each, S10, S13), against the clone's working tree or, with
  a commit, its package at that commit read with `git archive` (S11, R37).
- **Test fixtures:** `tools/makeTestFixtures.R` saves nprcgenekeepr's sample pedigrees into
  `tests/testthat/fixtures/` (`lacy1989Ped`, `smallPed`; `pedSix`, `qcPed` from Phase 6b; `pedOne` from Phase 7;
  `examplePedigree`, `pedWithGenotype`, `rhesusPedigree` and three rhesus `.csv` files from Phase 8) instead of
  shipping them as datasets (R21). `tools/makeComputedTestFixtures.R` (S9) saves what nprcgenekeepr's own code builds
  for a copied test: the QC'd rhesus pedigree (until Phase 10 also `shrinkPedigree()`'s Track B results, for a
  stand-in deleted in S13, R39). Both it and the results tool start R in nprcgenekeepr's folder with `tools/renvFreeEnv.R`.
- **Quality gates** (`methodology/.quality-gates.json`): `renv-lock-no-latest-repository`, `lint-package-zero`,
  `test-suite-warnings-zero` (S8), `tests-no-saved-expect-condition` (S9).

## Completed Milestones

- **Phase 13's first session, `checkPedigree()` (pedkindraw S17, 2026-11-13).** New code written test-first
  (Mark's picks R49-R51: `findUnrelated()` next session; one row per problem id; two checks added to the contract's
  nine; `"0"`, `"NA"` and blank as unknown-parent codes; tests against a slow checker and kinship2's `pedigree()`);
  a prototype measured on 300 random pedigrees before the pickers, the apparent misses traced to injections that
  changed nothing; the new file fully covered; CI green on five jobs at the first attempt.
- **Phase 12's second session, `ibdMatrix()`, and with it Phase 12 (pedkindraw S16, 2026-11-13).** Written
  test-first from kinship2's help page and measured results (Mark's picks R46-R48: kinship2's class with the ids
  given, sorted; a stop naming ids that lack a diagonal value; plain stops where kinship2 is silent or wrong; tests
  against kinship2); kinship2 measured before the picker, one case per process under a time limit, which showed it
  hangs on some inputs and not others; a ruling's description corrected before GREEN; the new file fully covered;
  CI green on five jobs at the first attempt.
- **Phase 12's first session, `familyCheck()` (pedkindraw S15, 2026-11-13).** Written test-first from kinship2's help
  pages and measured results (Mark's picks R43-R45: `ibdMatrix()` next session, kinship2's `join` numbers, plain
  stops and answers where kinship2 fails, `newfam` kept, tests against kinship2); kinship2 measured before each
  picker, its `join` found to disagree with its own help page; the new file fully covered; CI green on five jobs at
  the first attempt.
- **Phase 11, the shrink steps, the first new code (pedkindraw S14, 2026-11-12).** `bitSize()`, `findUnavailable()`,
  `findAvailNonInform()` and `findAvailAffected()` written test-first (Mark's picks R40-R42: each gives
  `shrinkPedigree()`'s answer for its step, kinship2's return shapes, tests against `shrinkPedigree()` and kinship2);
  every expected value computed before RED, and one described kinship2 difference corrected by reproducing it; the
  new files fully covered; CI green on five jobs at the first attempt, twice.
- **Phase 10, shrink, and with it the copy slices (pedkindraw S13, 2026-11-12).** `shrinkPedigree()` copied test-first
  from nprcgenekeepr's clean-room code (Mark's picks R38-R39: its 3 nprcgenekeepr-only test files left out, the
  Phase 8 stand-in deleted in RED); 600 of 600 results identical, the cases reaching every statement of the file;
  CI green on five jobs at the first attempt. Phases 6-10 are complete.
- **nprcgenekeepr S1159's legend fill, ported (pedkindraw S12, 2026-11-12; R37).** The legend draws its five sex
  symbols open, as the diagram draws an unaffected animal, copied test-first in nprcgenekeepr's own three steps;
  `DIVERGENCE.md` has no row; 540 of 540 results identical against nprcgenekeepr `45e0d8bfe`; CI green on five jobs
  at the first attempt.
- **Phase 9, the renderer (pedkindraw S11, 2026-11-12).** `drawPedigreeDiagram()` and its drawing helpers copied
  test-first (Mark's picks R34-R37: the newer source commit, nprcgenekeepr's app and docs tests left out, the help
  rewritten, and nprcgenekeepr's mid-session legend change ported later); 540 of 540 results identical, whole
  widgets included; CI green on five jobs at the first attempt, the Chrome tests running on all five.
- **Comparison and design, in nprcgenekeepr (S1121-S1130, 2026-11-02 to 11-04).** The plan; a comparison with
  kinship2, Pedixplorer and ggpedigree of what each computes and draws, and how fast, in how much memory, for how many
  animals (Phases 1-2); data frames plus converters as the input style (Phase 3, R7); the API contract, the name and
  the public repository (Phase 4, R10-R13). nprcgenekeepr then rewrote its kinship2-derived code by a clean-room
  process that pedkindraw copies (C2, finished S1140), and Mark ruled the license MIT (S1149, R14).
- **Phase 5, the skeleton (pedkindraw S1-S2, 2026-11-10).** The methodology and `CLAUDE.md`, then the empty package
  built test-first: 0 errors, 0 warnings and the one allowed NOTE (R16); first push, CI green on five jobs.
- **Phase 8, the layout engine (pedkindraw S9-S10, 2026-11-11 to 11-12).** All the layout code and its tests copied
  test-first in S9 (Mark's picks R30-R33: the split, the Chrome tests and drawing helpers to Phase 9, edition 3's
  fixes), then the kinship2 comparison and the fidelity tool's layout cases in S10 (468 of 468 results identical,
  messages now compared); CI green on five jobs at the first run of the layout.
- **Phase 7 (pedkindraw S8, 2026-11-11).** Kinship and twins copied test-first from nprcgenekeepr's clean-room code
  (Mark's picks R26-R29: 34 tests, Matrix's two classes imported, kinship2 and withr for tests, testthat edition 3
  kept), results identical to nprcgenekeepr's (360 of 360; 132 kinship matrices, largest difference 0); CI green on
  five jobs.
- **Phase 6b (pedkindraw S7, 2026-11-11).** The 11 functions that repair and trim pedigrees and the constant
  `sexCodes` copied test-first (Mark's picks R24-R25), results identical to nprcgenekeepr's (264 of 264); CI green on
  five jobs. Plan Phase 6 is complete.
- **Phase 6a (pedkindraw S3, 2026-11-10).** The 10 relationship functions copied test-first, results identical to
  nprcgenekeepr's on 12 Phase 1 pedigrees; the drift and results checks; CI green.
- **The plan moved here (pedkindraw S4-S6, 2026-11-10 to 11-11).** The plan, the contract and three studies copied
  from nprcgenekeepr `3d262d628` and brought up to date (rulings R16-R23); this roadmap and `methodology/BACKLOG.md`
  started; nprcgenekeepr's copies frozen (R23).
