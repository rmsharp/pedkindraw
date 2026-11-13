# pedkindraw: API contract (standalone pedigree package, plan Phase 4)

> **Copied into pedkindraw (pedkindraw S5, 2026-11-11).** Copied unchanged from nprcgenekeepr's
> `docs/planning/pedkindraw-api-contract.md` at nprcgenekeepr commit `3d262d628`,
> by step H1 of `docs/planning/planning-handover-plan.md`.
> From here on this copy is the live one: pedkindraw's sessions update it, and nprcgenekeepr's copy is frozen.
> Step H2 of the hand-over plan (pedkindraw S6) brought it up to date: sections 3 (one line), 4, 5, 9 and 10.
> **Paths in this file name nprcgenekeepr's files** (`R/`, `tests/`, `BACKLOG.md`, `methodology/`,
> `tools/pedigreeComparison/` and so on), except these five, copied into pedkindraw at the same paths:
> `docs/planning/standalone-pedigree-package-plan.md`, `docs/planning/pedkindraw-api-contract.md`,
> `docs/research/pedigree-package-comparison-2026-11.md`,
> `docs/research/kinship2-feature-gap-analysis-2026-09-20.md` and
> `docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md`. Text added in pedkindraw (H2 on) says whose
> file a path names: "pedkindraw's", "nprcgenekeepr's" or `nprcgenekeepr:<path>`.
> A line number cited in one of these five is its line in nprcgenekeepr. In this copy the lines down to the end of
> section 3 sit lower by this note (16 lines, counting the blank line above); below that, H2's edits moved
> them further, so find a cited line by its words.

**Date:** 2026-11-03 · **Session:** S1128 · **Type:** design session
(`methodology/workstreams/ARCHITECTURE_WORKSTREAM.md` §Interface Catalog). No package code was written or changed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md` (rulings R1-R9; this session adds R10-R13).
**Evidence:** `docs/research/pedigree-package-comparison-2026-11.md` (findings 1-35).
**Measured at:** `8c7805f63` (the S1128 claim; `R/` identical to `39e82eaaa`). kinship2 source read from its CRAN
tarball `kinship2_1.9.6.2.tar.gz`; Terry Therneau's older package from `kinship_1.1.3.tar.gz` (CRAN archive).
**Repository:** https://github.com/rmsharp/pedkindraw, public, created empty by Claude this session (R12).
**Status:** DONE for Phase 4, with the license open by Mark's ruling R11 (section 2) until S1149 (plan R14: MIT).
Section 10 lists what is still open.

---

## 1. Context

**What the package is for** (R1, Mark, S742): a standalone near-equivalent of kinship2 that carries this
package's drawing, annotation and interactivity. nprcgenekeepr may use it later; that is not the primary goal.
The comparison found what is left to offer is the drawing, not the computation (doc section 10).

**Who calls it.** (1) A user with a pedigree CSV and, optionally, a twins CSV: reads them with `read.csv()` and
hands in the data frames (R7). (2) A user holding a kinship2 `pedigree` or a Pedixplorer `Pedigree` object:
converts it first (R7, section 4.5). (3) nprcgenekeepr, only if Mark later decides it should (R8).

**Hard constraints carried from the plan.** Copy, not move (R8): nprcgenekeepr is unchanged. Strict TDD in the new
repository. At most 5 files per commit. `qcStudbook()` and `groupAddAssign()` stay in nprcgenekeepr (R9). The
drift rule while two copies exist (plan section 5).

---

## 2. Rulings made this session

| # | Ruling | By |
|---|---|---|
| R10 | Name: **pedkindraw**. Checked free this session: CRAN (current and archived names, any case), Bioconductor (release and devel, software and experiment data), GitHub (any owner). | Mark (his own name; Claude had offered pedkeepr, pedkin, pedigreeDraw) |
| R11 | The parts derived from kinship2 or from Therneau's `kinship` package (section 3) are **rewritten from the published methods**, not copied; their results must still match nprcgenekeepr's. Fallback: copy them under **GPL (>= 2)**, or **ask the original authors** (Terry Therneau; Jason Sinnwell, kinship2's maintainer) first. The license is ruled once the rewrite exists. Mark's reason: kinship2's code under an MIT license is not appropriate. Claude gave no legal opinion. | Mark |
| R12 | Repository `rmsharp/pedkindraw`, **public**, created empty by Claude with `gh repo create` (no README, description or license). | Mark |
| R13 | The file readers stay out: `readTwinRelations()` and its chain (`readDelimitedFile`, `readWithFinalNewline`, `lacksFinalNewline`, `muffleIncompleteFinalLine`, `readExcelPOSIXToCharacter`) and `toCharacter()`, which only the readers reach. The copied code then needs 32 outside packages instead of 47 (installed dependencies, base left out; the readers add `readxl`, `stringi` and 13 they pull in). | Mark |

---

## 3. Code that derives from kinship2 or Therneau's `kinship` package (input to R11)

Found by reading this repository's files against both tarballs, and by searching all 37 copy-set files for port,
credit and license wording. Both source packages' `DESCRIPTION` files say `License: GPL (>= 2)`. "Copied" means the
text matches, line for line or nearly; "re-expressed" means the same algorithm, structure or names in new
statements. Whether either counts as derived for license purposes is not answered here.

| Where (nprcgenekeepr) | From | How | Evidence |
|---|---|---|---|
| `kinship()` base: `R/kinship.R:107-248` (dense path), `:313-441` (`kinshipGeneral()`, the fallback) | Therneau's `kinship.s` v1.5, 2003, in the CRAN package `kinship` (last version 1.1.3, 2012; "Terry Therneau ... for all other functions") | Copied, then changed | Our `:91` quotes its `$Id:` line. Same arguments `id, father.id, mother.id`; the error "All id values must be unique"; the n + 1 stand-in for an unknown parent; the depth loop with `mom`/`dad` and its two update lines; five comment lines word for word, "guarranteed" included (`:186-190`, `:403-407`). `kinshipGeneral()` is that function nearly line for line plus additions; the S1059 dense path swapped the n + 1 row for a vector and kept the rest. None of those comments are in kinship2 1.9.6.2. |
| `kinship()`, X chromosome: `R/kinship.R:127-140`, `:198-214`, `:327-342`, `:413-420` | kinship2 1.9.6.2 `kinship.default()` | Copied, then changed (2026-08-13, `7bbc62733`) | Founder value `(3 - sex)/2`; a male takes his mother's row with self-kinship 1; unknown sex gives NA; the error "invalid sex vector"; `match.arg(casefold(chrtype), c("autosome", "x"))`. |
| `kinship()`, MZ twins: `R/kinship.R:155-179`, `:238-240`, `:367-401`, `:430-434`; `R/mzTwinGroups.R` | kinship2 1.9.6.2 `kinship.pedigree()` | Copied (2026-08-13, `4a9140370`); the grouping loop moved into `mzTwinGroups()` (S1063) | The two `tapply()` blocks match character for character, names `mzmat`, `mzgrp`, `mzindex`, `havemz` included; `kmat[mzindex] <- (diag(kmat))[mzindex[, 1]]`. |
| `shrinkPedigree()` and its helpers: `R/shrinkPedigree.R:98-368` | kinship2 `pedigree.shrink()`, `bitSize()`, `findUnavailable()`, `excludeUnavailFounders()`, `excludeStrayMarryin()`, `findAvailNonInform()`, `findAvailAffected()` | Re-expressed (2026-08-14, `f68a24ffc`); comments call the helpers "internal port[s]" | Same tiers in the same order and the same bit-size formula; `shrinkPedigree()` follows `pedigree.shrink()`'s control flow and names (`idTrimmed`, `idList` with `unavail`/`noninform`/`affected`, `bitSizeOriginal`, the `nChange`/`nNew`/`nOld` loop, `isTrimmed`, `affstatus`); one error nearly word for word ("NA values not allowed in genotyped vector." against "... in avail vector."). The statements are new: ids in a data frame instead of renumbered row indices; ties broken by sorting instead of `runif()`. |
| Layout solver `.solveJointQP()`: `R/makePedigreeDiagramData.R:1414` on, terms 1-2 and the anchoring row | kinship2 1.9.6.2 `alignped4()` | Re-expressed (S675) | Spousal pull `sqrt(w) * (x_a - x_b)`, child centering `sqrt(k^-1.5)` against the parents' midpoint, defaults 2 and 1.5 ("kinship2's own default, ported directly", `:1396`), one anti-degeneracy row, `t(pmat) %*% pmat`. Terms 3-4 (union centering, duplicate proximity) are new. |
| `comparePedigreeStructure()` mate pairs: `R/comparePedigreeStructure.R:21` | kinship2 `align.pedigree()`'s unexported `spouselist` step | Re-expressed, "verbatim" by its own comment | One condition (`findex > 0 & mindex > 0`) and removing duplicate pairs. Test support; moves with the engine (plan Phase 8). |

Not kinship2: `R/positionTreeApportion.R` was cross-checked against d3-hierarchy (ISC license; its own note at `:18-24`
calls the check "GPL-avoiding"). The plan's R3 "port `familycheck` and `ibdMatrix`" is new work and, under R11, is
written from those functions' documented behaviour, not from kinship2's source.

**What R11's rewrite means here.** Each derived part is written again in pedkindraw from the published method:
kinship by K. Lange, *Mathematical and Statistical Methods for Genetic Analysis* (1997), pp. 71-72; X-chromosome
kinship and shrinking by Sinnwell, Therneau and Schaid (2014), *Human Heredity* 78(2):91-93, and its supplement
(`inst/extdata/reference/NIHMS593658-supplement-supplement_1.pdf` in this repository); an MZ pair's kinship equal
to either twin's self-kinship. Its tests are nprcgenekeepr's own and are copied as usual; its results are checked
against nprcgenekeepr at the source commit (`identical()` for data frames, largest kinship difference 0).
**One fact for the license ruling:** Claude, which will write the rewrite, has read both the kinship2 code and
nprcgenekeepr's in this session, so the rewrite is not independent of them.
**Superseded by C2** (plan section 2, S1130): the rewrite was done once, by nprcgenekeepr's clean-room process
(finished S1140), and pedkindraw copies its results (plan Phases 7, 8 and 10).

---

## 4. Interface catalogue

**Conventions for every function.** A pedigree is a data frame with `id`, `sire`, `dam` (character; an unknown
parent is `NA`), and optionally `sex` (`M`, `F`, `H`, `U`), condition columns (`affected`, or `affected_<name>`, up to
four drawn), `status` (`DECEASED` draws the slash), and any other column (kept, shown in hover text where named,
e.g. `name`). A twins table has `id1`, `id2`, `code` (`"MZ twin"`, `"DZ twin"`, `"UZ twin"`). An animal may have one
known parent. Errors are `stop()` calls whose message names the function or the argument; nothing returns a
problem table except `checkPedigree()`.

**Names and arguments of copied functions stay exactly as in nprcgenekeepr** (`kinship(id, fatherId, motherId)`
beside `findGeneration(id, sire, dam)` included; `fatherId` and `motherId` were `father.id` and `mother.id` until
nprcgenekeepr's clean-room ruling C13). Reason: the plan's checks compare each copied function with
nprcgenekeepr's (Phases 6-10), and the drift tool compares bodies (plan section 5); renaming now would make every
function a divergence from the first day. Making the names consistent is a review step before the first CRAN
release (section 6), the last point at which it costs users nothing.

### 4.1 Copied exports (20)

| Interface | Input | Output | Error | Phase |
|---|---|---|---|---|
| `findGeneration(id, sire, dam)` | vectors | integer generation per id, founders 0; NA plus a warning naming the ids it cannot place (cycle, parent without a row) | none of its own | 6 |
| `findPedigreeNumber(id, sire, dam)` | vectors | integer family per id, from 1; NA for an id not reachable from a founder | none | 6 |
| `getParents(pedSourceDf, ids)` | pedigree, ids | character parent ids | none | 6 |
| `getOffspring(pedSourceDf, ids)` | pedigree, ids | character offspring ids, no duplicates | none | 6 |
| `getFounders(ped)` | pedigree | founder ids, in pedigree order, same type as `ped$id` | none | 6 |
| `isFounder(ped)` | pedigree | logical per row, never NA | none | 6 |
| `hasBothParents(id, ped)` | one id, pedigree | `TRUE`/`FALSE`; `logical(0)` when the id is absent | none | 6 |
| `getIdsWithOneParent(uPed)` | pedigree | character ids with exactly one known parent | none | 6 |
| `addParents(ped)` | pedigree | pedigree with a row added for each parent that has none; `recordStatus` `"original"`/`"added"` | none | 6 |
| `addBackSecondParents(uPed, ped)` | trimmed pedigree, full pedigree | trimmed pedigree with second parents added back; a `data.table` once a row is added, else a data frame (as today) | none | 6 |
| `correctParentSex(id, sire, dam, sex, recordStatus, reportErrors = FALSE)` | vectors | corrected sex codes; or, with `reportErrors = TRUE`, a list `sireAndDam`, `femaleSires`, `maleDams` | stops when an id is both sire and dam | 6 |
| `trimPedigree(probands, ped, removeUninformative = FALSE, addBackParents = FALSE)` | ids, pedigree | probands and their ancestors | none | 6 |
| `getProbandPedigree(probands, ped)` | ids, pedigree | probands and their ancestors | none | 6 |
| `getDescendantPedigree(probands, ped)` | ids, pedigree | probands and their descendants | none | 6 |
| `removeUnknownAnimals(ped)` | pedigree | pedigree without rows whose `recordStatus` is `"added"` | none | 6 |
| `removeUninformativeFounders(ped)` | pedigree | reduced pedigree | stops naming missing columns | 6 |
| `checkTwinRelations(ped, twinRelations)` | pedigree, twins table | the twins table, ids as character | stops on missing columns, a pair naming one id twice, an id not in `ped`, a bad code, an MZ or DZ pair without the same sire and dam, an MZ pair of different sex | 7 |
| `makePedigreeDiagramData(ped, twinRelations = NULL)` | pedigree, optional twins | list `nodes`, `edges` for visNetwork | stops when `ped` is not a data frame or lacks columns | 8 |
| `makePedigreeMatingLayout(ped, edgeStyle = c("rectilinear", "direct"), twinRelations = NULL, kinshipMatrix = NULL)` | pedigree, options | list `nodes` (positions, symbols, hover text, `deceased`, condition sections) and `edges` | stops on a non-data-frame `ped`, missing columns, a bad `kinshipMatrix`; warns when same-row line-symbol collisions cannot all be resolved | 8 |
| `drawPedigreeDiagram(layout, edgeStyle = c("rectilinear", "direct"), onClick = NULL)` | a layout from the function above | a `visNetwork` widget, 500 px tall plus 45 px per condition past the first | stops on a layout of the wrong shape or a bad `onClick` | 9 |

`addIdRecords()` (called only by `addBackSecondParents()`) is copied but **not exported**: it is plumbing, and an
export can be added later without breaking anyone, while removing one cannot (Claude's proposal; nprcgenekeepr
exports it).

### 4.2 Rewritten exports (R11, C2): copied from nprcgenekeepr's clean-room rewrite

| Interface | Input | Output | Error | Phase |
|---|---|---|---|---|
| `kinship(id, fatherId, motherId, pdepth, sparse = FALSE, twinRelations = NULL, chrtype = "autosome", sex = NULL)` | vectors; `pdepth` from `findGeneration()`; optional twins; `chrtype = "x"` needs `sex` | square kinship matrix named by `id`; a `Matrix` sparse matrix when `sparse = TRUE` | stops on duplicate ids, a bad `sex` vector, an MZ id not in `id` | 7 |
| `shrinkPedigree(ped, genotyped, affected = NULL, maxBits = 16L)` | pedigree, logical per row | list `ped`, `idTrimmed`, `idList` (`unavail`, `noninform`, `affected`), `bitSize`, `genotyped`, `pedSizeOriginal`, `pedSizeIntermed`, `pedSizeFinal` | stops on missing columns, wrong lengths, NA in `genotyped` | 10 |

Unchanged behaviour is the contract: an animal with one known parent is legal (X chromosome included), and
`shrinkPedigree()` breaks ties the same way every time.
The clean-room functions pedkindraw copies (C2) differ from nprcgenekeepr 3.0.0's, and the copies carry the
differences (`nprcgenekeepr:docs/planning/cleanroom-rewrite-plan.md` section 2): the parent argument names above (C13);
a plain error for each kind of malformed input to `kinship()` (C11) and to `shrinkPedigree()` (C15), beyond the
errors listed; `shrinkPedigree()`'s ties go to the first id in byte order, whatever the locale (C16).

### 4.3 New exports, parity with kinship2 (R3)

| Interface | Input | Output | Error | Phase |
|---|---|---|---|---|
| `bitSize(ped)` | pedigree | list `bitSize` (`2 * non-founders - founders`), `nFounder`, `nNonFounder`, as kinship2's (plan R41) | `shrinkPedigree()`'s pedigree checks, naming missing columns first | 11 |
| `findUnavailable(ped, genotyped)` | pedigree, logical per row | character ids `shrinkPedigree()`'s first trim removes, in removal order: not genotyped with no genotyped descendant, plus unavailable founder couples and stray marry-ins (plan R40) | as `shrinkPedigree()` | 11 |
| `findAvailNonInform(ped, genotyped, affected = NULL)` | as above | character ids its second trim removes, the first run inside: genotyped but uninformative (non-parents, not affected, both parents genotyped), with the cascade (plan R40) | as above | 11 |
| `findAvailAffected(ped, genotyped, affected, affstatus)` | as above, `affstatus` `NA`, `FALSE` or `TRUE` | list `ped`, `idTrimmed`, `isTrimmed`, `bitSize` (kinship2's names, always all four) for the one removal among genotyped non-parents of that status that leaves the smallest bit size, ties to the first id in byte order; `isTrimmed` `FALSE`, `ped` unchanged, when none can go (plan R41) | as above, and an `affstatus` other than `NA`, `FALSE`, `TRUE` | 11 |
| `familyCheck(famid, id, sire, dam, newfam)` | family ids to check, pedigree vectors (unknown parents `NA`), optional family-tree numbers (0 for an animal related to no one), as kinship2's `makefamid()` gives | data frame, a row per family id in sorted order (byte order for character, C16): `famid`, `n`, `unrelated`, `split`, `join` (kinship2's columns; `join` counts another family once per family tree the two share, as kinship2 returns); when any `join` is above 0, an attribute `join`: an integer matrix, joined family ids by tree number (plan R43, R44) | stops on vectors of unequal length, an `NA` family id, an `NA` or duplicate id, a `newfam` of the wrong length or with an `NA`; not on an animal that is its own ancestor (plan R44) | 12 |
| `ibdMatrix(id1, id2, x, idmap, diagonal)` | pairs of ids and their IBD values from outside software (SOLAR's form), or one three-column table as `id1`; optional `idmap` (2 columns: the ids as in `id1` and `id2`, the names for the result) and `diagonal` (one number for the missing diagonal entries) | a `dsCMatrix` (kinship2's class, the upper triangle stored), one row and column per id given: numbers by value, character ids in byte order (C16), or with `idmap` the internal ids' order and `idmap`'s names; 0 values not stored; empty input a 0 x 0 matrix (plan R46) | stops, naming the ids, on an id with no diagonal value when `diagonal` is not given; on vectors of unequal length; one pair given two different values; an `NA` id; a value `NA`, not finite or not a number; a table without 3 columns, or with `id2` or `x` also given; an `idmap` not of 2 columns, with an `NA`, listing an id twice, giving two ids one name or lacking an id used; a `diagonal` not one finite number (plan R47) | 12 |

The helpers take ids in a data frame, not kinship2 objects, and are written under R11 (section 3). Their exact
return shapes, and the errors of every new function in sections 4.3-4.5, are Claude's proposals, settled in each
phase's RED tests. Phase 11's were ruled before its RED (plan R40-R42, pedkindraw S14): the four give
`shrinkPedigree()`'s answer for their step, calling its copied internals. `familyCheck()`'s were ruled before its
RED (plan R43-R45, pedkindraw S15), and `ibdMatrix()`'s before its RED (plan R46-R48, pedkindraw S16).

### 4.4 New exports, short checker and unrelated-set finder (R9)

| Interface | Input | Output | Error | Phase |
|---|---|---|---|---|
| `checkPedigree(ped)` | pedigree | data frame `check`, `id`, `detail`, one row per problem, zero rows when clean; never repairs | stops only when `ped` is not a data frame or lacks `id`, `sire`, `dam` | 13 |
| `findUnrelated(ped, genotyped)` | pedigree, logical per row | character ids: genotyped, kinship 0 between every two, and no genotyped animal can be added; the same answer every time | stops on wrong lengths or NA in `genotyped` | 13 |

`checkPedigree()`'s checks come from the comparison's measured case list (doc section 4): `duplicateIds`,
`ownParent`, `cycle`, `rowlessParents` (a parent id with no row), `missingParentCodes` (`"0"`, `""` or similar
used for an unknown parent), `maleDams`, `femaleSires`, `unknownSexParents`, `sireAndDam` (one id used as both).
Legal here and not reported: one known parent, unknown sex of a non-parent, `H`, numeric ids. It reports and
stops there: kinship2 refuses, Pedixplorer silently changes a parent's sex, BGmisc offers repair; repair here
stays the user's step with `addParents()` and `correctParentSex()`. The copied computation functions do **not**
call it (their raw errors on a bad pedigree stay as copied, finding 9); calling it from them is later new work.

`findUnrelated()` must give sets as large as kinship2's and Pedixplorer's on the doc's three pedigrees (section
5.4: 4, 2 and 44), and finish 10,000 animals, where kinship2 took 6.5 s (section 7).

### 4.5 New exports, converters (R7)

| Interface | Input | Output | Error | Phase |
|---|---|---|---|---|
| `asPedFrame(x, ...)`, S3 generic, methods for kinship2's `pedigree` and Pedixplorer's `Pedigree` | an object of either class | list `ped` (data frame in the conventions above) and `twinRelations` (data frame, or `NULL` when the object has none) | stops for any other class, naming it; stops when the object's package is not installed | 14 |

What each method reads is the comparison doc's section 11.2 table; its two test cases are required (an unknown
parent's index 0 must not shift later parents; Pedixplorer's all-`NA` `affection` column is not a condition).
kinship2 and Pedixplorer stay in `Suggests` (R7). kinship2's `pedigreeList` (several families) is accepted when no
id repeats across families and refused otherwise, naming the ids; ids are never renamed silently (Claude's
proposal).

### 4.6 Not in this contract

Layout hints (R3) are Phase 15, whose design session comes first. Nothing else from nprcgenekeepr is exported.

---

## 5. Dependencies

| Component | Depends on | Depended on by | Note |
|---|---|---|---|
| Pedigree basics (Phase 6) | `data.table` (only `addIdRecords()`, Phase 6b) | everything | `data.table` adds 1 package; kept so the copied functions return what nprcgenekeepr's do (a later replacement is a recorded divergence) |
| Kinship and twins (Phase 7) | `Matrix`, `methods` (`kinship()`), `stats` (`checkTwinRelations()`) | layout, `findUnrelated()` | Matrix declared by `importClassesFrom(Matrix, ddiMatrix, dgCMatrix)` as well (plan R27, pedkindraw S8) |
| Layout engine (Phase 8) | `quadprog`, `Matrix`, `utils` | renderer | `quadprog::solve.QP.compact()` and `utils::head()`, both arrived pedkindraw S9; Matrix through `kinship()` |
| Renderer (Phase 9) | `visNetwork` | users | `chromote` in Suggests for browser tests |
| Converters (Phase 14) | kinship2, Pedixplorer (Suggests) | users | |

**Imports:** `data.table`, `Matrix`, `quadprog`, `visNetwork`, `stats`, `utils`: 32 packages to install, measured
this session. Each is added by the phase that first needs it; `stats` and `utils` only once a copied function uses
them, and none of Phase 6's does (pedkindraw S2-S3; an unused import is a check NOTE). Phase 7 (pedkindraw S8) added
`Matrix`, `stats` (`checkTwinRelations()` calls `stats::setNames()`) and `methods`, which this list did not name
(`kinship()` calls `methods::new()`; base R, nothing to install). Phase 8 (pedkindraw S9) added `quadprog` (already
installed as kinship2's dependency) and `utils` (`utils::head()` in the layout). **Suggests:** kinship2 (also the fidelity tests;
arrived in Phase 7, plan R28), Pedixplorer, `testthat`, `mockery` (the copied tests' stand-ins, Phase 6), `withr`
(the copied C11 test's `with_seed()`, Phase 7, R28), `chromote`, and what the vignettes need (Phase 16). No circular
dependencies: each phase's slice uses only earlier slices.

---

## 6. Versioning

`0.x` until the first CRAN release. Before it, exports and arguments may change; the last session before Phase 17
reviews the names (section 4's argument mismatch, `addIdRecords()`) and records any change as a divergence. After
it, an export or argument is removed only after one release with a `.Deprecated()` warning.

---

## 7. Performance budget (this Mac: Apple M2 Max, 96 GiB, R 4.6.2; comparison doc sections 7 and 9)

| Operation | Measured, nprcgenekeepr's code | Next size failed on | Target for pedkindraw |
|---|---|---|---|
| Kinship, autosomal, dense | 30,000 animals 29.2 s, process peak 12.96 GiB | memory at 100,000 | the same or better (the rewrite included) |
| Kinship, X chromosome | 30,000 animals 23.6 s | memory at 100,000 | the same or better |
| Generation depth | 100,000 animals 0.101 s | -- | the same |
| Family numbers | 100,000 animals 12.9 s (close to the square of the size) | -- | the same at copy; a faster version is new work under the drift rule |
| Shrink to 16 bits | 1,000 animals 21.0 s | past 120 s at 3,000 | the same or better (rewrite) |
| Unrelated set | none (kinship2 10,000 in 6.5 s) | -- | 10,000 animals |
| Drawing, layout plus browser | 1,000 animals 16.3 s (15.5 s in R) | past 120 s at 2,000 | the same |

---

## 8. Failure modes

| Where | What happens | Contract |
|---|---|---|
| A bad pedigree into a computation function | raw R errors or NA generations with a warning (finding 9) | unchanged at copy; `checkPedigree()` names the problem first |
| Dense kinship of many animals | 8 n^2 bytes; past about 30,000 animals on 32 GB, R runs out of memory | documented in `kinship()`'s help; no silent switch to another method |
| Drawing past about 1,000 animals | past 120 s at 2,000; Mark judged nprcgenekeepr's drawing readable up to 1,000 zoomed in, the largest size drawn (finding 28) | `drawPedigreeDiagram()` has no cap (nprcgenekeepr's app caps at 750); its help states the measured limit |
| kinship2 or Pedixplorer missing | a converter cannot read the object | `asPedFrame()` stops naming the package to install |
| The two copies drift | a fix lands in one repository only | plan section 5: mirror it or record it in `DIVERGENCE.md` |
| The rewrite (R11) differs from nprcgenekeepr | a result that is no longer identical | the phase is not DONE until results are identical; a deliberate difference needs Mark's ruling and a `DIVERGENCE.md` row |

---

## 9. What this changes in the plan

| Phase | Before | After this contract (and C2) |
|---|---|---|
| 5 | `DESCRIPTION`, `LICENSE` | Starts with Mark's ruling on the License line (R11 leaves it open; the empty package needs one). Ruled S1149: MIT (plan R14). |
| 7 | copy `kinship.R`, `mzTwinGroups.R`, `checkTwinRelations.R`, readers if kept | copy `checkTwinRelations.R` and nprcgenekeepr's clean-room `kinship.R` and `mzTwinGroups.R` (C2); no readers (R13). |
| 8 | copy the layout engine | copy it, with nprcgenekeepr's clean-room `.solveJointQP()` and mate-pair step (C2; section 10 item 2) |
| 10 | copy `shrinkPedigree.R` | copy nprcgenekeepr's clean-room `shrinkPedigree.R` (C2) |
| 11 | export the shrink helpers and `bitSize` | export the rewrite's helpers (section 4.3) |
| 12 | port `familycheck`, `ibdMatrix` | write `familyCheck()` and `ibdMatrix()` from their documented behaviour (R11) |
| 13, 14 | sized at Phase 1, specified here | section 4.4, 4.5 |
| 17 | the linux-arm64 read item if the readers came | not needed (R13) |

---

## 10. Open items

1. **License** (R11): ruled S1149, plan R14: MIT, as nprcgenekeepr (`License: MIT + file LICENSE`, copyright holder
   R. Mark Sharp). The rewrite existed (S1140, plan C2), so neither fallback was needed.
2. **R11's reach into the layout engine**: `.solveJointQP()` terms 1-2 and `comparePedigreeStructure()`'s mate-pair
   step are re-expressed from kinship2 (section 3). Closed by C2 (S1130): both were rewritten by nprcgenekeepr's
   clean-room process (its batches D and A, integrated S1139 and S1134), and Phase 8 copies them (the plan says so
   under its rulings table).
3. **nprcgenekeepr's own license**: it ships the same code (section 3) under MIT. Separate work, recorded as its
   own `BACKLOG.md` item (Mark's ruling, S1128); nothing here changes it.
4. **Argument names** (section 6): reviewed before the first CRAN release.
5. **`findPedigreeNumber()`'s speed** (section 7): new work after the copy.
6. **`data.table`** (section 5): kept; replacing it is a recorded divergence if ever wanted.
