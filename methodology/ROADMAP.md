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
section 10). All five are done (S13). The new work of Phases 11-15 has begun: Phases 11 (S14), 12 (S15-S16) and 13
(S17-S18: `checkPedigree()` and `findUnrelated()`; What's Built, below) and 14 (S19-S20: `asPedFrame()` for
kinship2 and Pedixplorer objects) are done; Phase 15, layout hints, is done: designed (S21), then 15a the order
hint, 15b the mate hint and 15c the converters passing hints on (S22-S24). Phase 16, documentation, is planned
(S25: `docs/planning/documentation-plan.md`, R77-R80); its first session, 16a, the README, NEWS and `?pedkindraw`,
is done (S26), and 16b is next (Planned, below).

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

- **Phase 16 (16b next, `methodology/BACKLOG.md`):** documentation, five sessions (`docs/planning/documentation-plan.md`
  section 6): 16a README, NEWS and `?pedkindraw` (done, S26); 16b a getting-started vignette and a 375-animal example file; 16c a
  drawing vignette; 16d a speed and size-limits vignette from the dated timing records; 16e the pkgdown site on
  GitHub Pages. The three vignettes ship on CRAN, the package under 5 MB installed (R77-R80).
- **Phase 17:** the CRAN submission, its own plan first. Before it, a review of argument names (contract section 6).
- **Later, optional:** nprcgenekeepr uses pedkindraw, only on Mark's decision (R8).

## What's Built

- **Documentation, a start (Phase 16a):** `README.md` (made from `README.Rmd`) says what the package does, how to
  install it from GitHub, and runs a 12-animal example: checked, kinship, laid out and drawn, with a picture of the
  drawing (`man/figures/README-pedigree.png`, remade by `tools/makeReadmePicture.R`) and every export named in six
  groups; `NEWS.md`; the package help page `?pedkindraw`. No vignettes or site yet (16b-16e).
- **Layout hints from kinship2 and Pedixplorer objects (Phase 15c), no new export:** `asPedFrame()` returns a third
  element, `hints`, the object's layout hints in `makePedigreeMatingLayout()`'s form (`order` named by id, `mate`
  rows of ids and anchor words), or `NULL`, so `makePedigreeMatingLayout(x$ped, hints = x$hints)` draws with them
  (R62, R73-R76): kinship2's `x$hints` (`order`, `spouse` by place) and Pedixplorer's `horder()` and `spouse()`;
  mate rows the layout would refuse fixed, one message naming each change (a pair with no offspring together or
  named before left out, an earlier-generation anchor set to `"either"`); unreadable kinship2 hints stop; a
  `pedigreeList`'s read as a `pedigree`'s. Three helpers in `R/layoutHints.R` (`.layoutHintTogether()`,
  `.layoutHintPairKey()`, `.layoutHintAnchorGenerations()`) give the converter and the layout's check one set of
  rules. 12 tests; 100 random pedigrees each with kinship2's `autohint()` and Pedixplorer's `auto_hint()` hints
  converted and drawn, every hinted mating on its side; rows as kinship2 (42 typed cases) and Pedixplorer (21)
  draw them where they return.
- **Layout hints, the mate (Phase 15b), no new export:** `makePedigreeMatingLayout(..., hints = list(mate = ))`,
  a data frame of `left`, `right` (a sire and dam with offspring together) and `anchor`, draws `left` left of
  `right` at their mating and hangs the offspring under the anchor, the other partner a repeat node when it has
  parents (R60-R61, R70-R73): strict checks, no anchor on the earlier-generation partner, an animal with several
  mates drawn as kinship2 draws it (its families follow its mates, same-side mates in the hint's row order).
  `R/layoutHints.R` gains `.checkLayoutHintOrder()`, `.checkLayoutHintMate()`, `.layoutHintMateRow()`,
  `.layoutHintAnchor()`, `.layoutHintMatingSides()`, `.layoutHintSides()`, `.layoutHintFamilies()`, called from a
  few lines in three copied functions (`DIVERGENCE.md`). 9 tests; on 100 seeded random pedigrees 1,090 of 1,090
  hinted sides, 197 of 197 animals' families following their mates, 2,525 of 2,525 anchor flips; kinship2's rows
  on 22 typed cases. Without hints the layout is nprcgenekeepr's (600 of 600 results identical).
- **Layout hints, the order (Phase 15a), no new export:** `makePedigreeMatingLayout(..., hints = list(order = ))`,
  a number per animal named by id, draws siblings, separate families and founder couples left to right in the
  order of the numbers (R60-R61, R64-R68): animals it does not name keep their rows, equal numbers keep row order,
  a founder couple is placed by its female's number, the founder-reordering step is skipped in a family whose
  founders it names, twins are drawn as ordered; strict checks. pedkindraw's own `R/layoutHints.R`
  (`.checkLayoutHints()`, `.layoutHintRows()`, `.layoutHintKeepsRoots()`, `.layoutHintRoots()`,
  `.layoutHintPlaces()`), called from a few lines in two copied functions (`DIVERGENCE.md`). 12 tests; on 100 seeded
  random pedigrees 4,670 of 4,670 sibships and 201 of 201 families' founder lines in hinted order; kinship2's rows
  on the typed cases (R69). Without hints the layout is nprcgenekeepr's (600 of 600 results identical).
- **Converters from kinship2 and Pedixplorer objects (Phase 14), 1 export:** `asPedFrame()` turns a kinship2
  `pedigree` or `pedigreeList` object back into the package's pedigree data frame and twins table (R55-R57): each
  parent read by its own index, ids as text with whole numbers in full, sex M, F or U, conditions as `affected` or
  `affected_<name>`, status `DECEASED` or `ALIVE`, twins from relation codes 1-3; a family list converted whole when
  no id repeats, with a `famid` column. It reads the object without kinship2 and refuses any other class. An S3
  generic with internal helpers `.asPedFrameKinship2()`, `.asPedFrameConditions()`, `.asPedFrameText()` and
  `.asPedFrameTwins()`. 15 tests; a data frame through `kinship2::pedigree()` and back comes out identical on 9
  fixtures in 8 variants and 300 random pedigrees. 0.04 s for 100,000 animals. S20 added Pedixplorer's `Pedigree`
  (R58-R59): ids as the object holds them (`F1_A` with families, and a `famid` column), sex M, F or U, each
  condition with a known value (`affection` as `affected`, others `affected_<name>`), status `DECEASED`, `ALIVE` or
  `NA`, Pedixplorer's fields that hold data, then the object's own extra columns; twins from `rel(x)`; it stops
  when Pedixplorer is not installed or a column name would repeat. Internal helpers `.asPedFramePedixplorer()`,
  `.asPedFramePxConditions()`, `.asPedFramePxStatus()`, `.asPedFramePxKeptFields()`, `.asPedFramePxTwins()` and the
  shared `.asPedFrameTwinTable()`. 14 tests; a data frame through `Pedixplorer::Pedigree()` and back comes out
  identical on 9 fixtures in 12 variants and 100 random pedigrees. 0.005 s for 100,000 animals. Pedixplorer
  (Bioconductor 3.23) is in `Suggests` and renv, never required (R7).
- **Unrelated-set finder (Phase 13, second session), 1 export:** `findUnrelated()` chooses genotyped animals of
  which no two share an ancestor (kinship 0), to which none can be added and in which no chosen animal can be
  traded for two, the same set every time (R52-R54): the animal with the fewest relatives first, ties in byte order,
  then a swap pass. It refuses a pedigree from which relatedness cannot be read (`checkPedigree()`'s missing or
  duplicate ids, own parents, cycles, parents with no row, `"0"` codes) and does not read sex. pedkindraw's own new
  code with internal helpers `.founderAncestors()`, `.unrelatedPick()`, `.unrelatedSwap()` and three others. 19
  tests; checked against a slow check from the definition on 300 random pedigrees and, where installed, against
  kinship2's set sizes. 138 animals in 0.57 s on 10,000 animals with 30% genotyped, where kinship2 takes 6.5 s.
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
  `baef1e12c`, code unchanged but for the order hint's call-site lines in two functions (S22, `DIVERGENCE.md`);
  its 333 tests pass as they do there (R29-R33), and its results without hints are identical to nprcgenekeepr's. Imports `quadprog`, `utils`.
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
  `test-suite-warnings-zero` (S8), `tests-no-saved-expect-condition` (S9), `user-facing-sire-dam-words` (S23; S26
  widened it from `R/` and `man/` to the README, NEWS and vignettes).

## Completed Milestones

- **Phase 16a, the README, NEWS and `?pedkindraw` (pedkindraw S26, 2026-11-15).** The README's example runs when
  the README is built, and a hidden check stops the build if a statement its text makes stops holding; its picture
  is made from the README's own code. Mark picked the install line (pak) and the picture's pedigree from three
  drawn candidates, dropping one whose two-condition symbols show divider lines the legend does not explain (a
  backlog item). `R CMD check` showed the plan's NEWS heading needs a version number.
- **Phase 16 planned (pedkindraw S25, 2026-11-15).** Measured on scratch copies before the picker: a vignette page
  with drawings is 1.6-1.9 MB and the package without vignettes 0.47 MB, so two such pages fit CRAN's 5 MB and three
  do not; a trial pkgdown site built in 34.5 s once the package was installed (a stale installed copy stopped it
  otherwise) and published the root's `CLAUDE.md` and `DIVERGENCE.md`; nprcgenekeepr's re-timing of its rewrite
  measured the very files pedkindraw copied. Mark's picks R77-R80, each the recommended option: three CRAN vignettes,
  two with live drawings; the site on GitHub Pages; the timing tables summarized from the records and checked by a
  script; the 375-animal rhesus pedigree as an example file. Five build sessions, 16a-16e.
- **Phase 15c, the converters pass hints on; Phase 15 DONE (pedkindraw S24, 2026-11-15).** Written test-first after
  measuring what kinship2 1.9.6.2 and Pedixplorer 1.8.0 objects hold in their hints, set by a user and by
  `autohint()` and `auto_hint()`, on 212 pedigrees (Mark's picks R74-R76, each the recommended option: mate rows the
  layout refuses fixed with a message, 40 of 143 kinship2 and 50 of 119 Pedixplorer automatic hints holding such
  rows; unreadable kinship2 hints stop; a `pedigreeList` read as a `pedigree`). 12 tests and 9 whole-list tests
  updated; the contract's row; fidelity 600 of 600 identical.
- **Phase 15b, the mate layout hint (pedkindraw S23, 2026-11-15).** Written test-first after measuring the design's
  open details D6, D7 and D9 on scratch prototypes against kinship2 and Pedixplorer (Mark's picks R70-R73, each the
  recommended option: strict checks; no anchor on the earlier-generation partner, which drew 2,916 random matings'
  anchors rows away from their dot; several mates as kinship2 draws them, 18 of 18 typed rows equal and 0 of 197
  crossed families; the element renamed `mate`, user-facing words being sire and dam). 9 tests, three
  `DIVERGENCE.md` rows, the contract's row; fidelity 600 of 600 identical without hints.
- **Phase 15a, the order layout hint (pedkindraw S22, 2026-11-15).** Written test-first after measuring the design's
  open details D1-D5 on a scratch prototype against kinship2 and Pedixplorer (Mark's picks R64-R69, each the
  recommended option: unnamed animals keep their rows, family order changed 0 times in 99; a founder couple by its
  female's number, kinship2's top row 720 of 720; the founder step skipped only where founders are named; twins
  drawn as ordered; strict checks; kinship2 compared on typed cases, where its rows agree). 12 tests, two
  `DIVERGENCE.md` rows, the contract's row; fidelity 600 of 600 identical without hints.
- **Phase 15's design, user-suppliable layout hints (pedkindraw S21, 2026-11-14).** A design document, no code:
  what kinship2's and Pedixplorer's hints do, read from their help pages; where the copied engine sets left-to-right
  order (the rows of `ped`, a founder-reordering step, fixed rules for anchors and mate sides); eight measurements
  before Mark's picks (sorting rows by a hint ordered 9,840 of 9,840 random sibships; scratch prototypes of the
  spouse hints worked on 1,090 and 1,936 matings); rulings R60-R63 (order and mate placement, a `hints` argument,
  converters pass hints on, three build sessions with their DONE criteria).
- **Phase 14's second session, `asPedFrame()` for Pedixplorer objects, and with it Phase 14 (pedkindraw S20,
  2026-11-14).** Pedixplorer (Bioconductor 3.23) installed into renv, the 8 dependencies the lock took from
  "latest" reinstalled from the dated repository; new code written test-first (Mark's picks R58-R59: Pedixplorer's
  fields kept when they hold data; `affection` as `affected`; ids as the object holds them; unknown death left
  blank); the round trip shown able to fail by planting the comparison's all-`NA` defect (136 of 136 caught); a
  silent column clash found by measuring before RED and made a stop; the new code fully covered; CI green on five
  jobs at the first attempt, its first install of a Bioconductor package.
- **Phase 14's first session, `asPedFrame()` for kinship2 objects (pedkindraw S19, 2026-11-14).** New code written
  test-first (Mark's picks R55-R57: kinship2 now and Pedixplorer, with its 47-package install, in a session of its
  own; family lists accepted when no id repeats; status 0 as `ALIVE`; the object read without kinship2; typed cases
  and a round trip); Pedixplorer's install measured in a scratch library and a scratch lock file before the scope
  picker; the round trip shown able to fail by planting the comparison's unknown-parent defect (372 of 372 caught);
  the new file fully covered; CI green on five jobs at the first attempt.
- **Phase 13's second session, `findUnrelated()`, and with it Phase 13 (pedkindraw S18, 2026-11-13).** New code
  written test-first (Mark's picks R52-R54: relatedness from shared ancestors; the fewest relatives first, then a
  swap pass; a stop naming the animals where relatedness cannot be read; tests against a slow check and kinship2);
  kinship2 reproduced on the comparison's three cases first, and the rule measured against an exact search before
  the picker; the typed swap case found by shrinking a random one; the new file fully covered; CI green on five jobs
  at the first attempt.
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
