# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G14 DONE (S42-S63).
**G15's plan written (S64, R141, `docs/planning/mates-without-offspring-plan.md`):** gap B1, two animals mated with
no offspring together. Mark's pick: a `matings` table, a data frame of `sire` and `dam` given to
`makePedigreeMatingLayout(matings = NULL)`, listed by `getMatings()` and returned by `asPedFrame()` as a fourth
element. Three build sessions: **G15a the layout** (1, or 2), G15b `getMatings()`, G15c the converters.
**Next: G15a, the layout draws declared matings** (the plan's section 7, `:222`; strict TDD; measure first, then the
pre-RED picker with pictures).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S64's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G15a (recommended: the plan's order, R97's). Also READY: the narrow legend
(`methodology/BACKLOG.md:61`), the drawing vignette's measured trait (`:68`), the `smallPed` fixture (`:91`),
rewording `DIVERGENCE.md`'s older rows (`:43`), tests for full coverage (`:97`), `findPedigreeNumber()`'s speed
(`:227`, READY since S6 and missing from S48-S64's pickers), and the "Ready, small" items (seven: `:153`, `:165`,
`:172`, `:181`, `:191`, `:208`, `:214`). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:74`); long
names at the edges (`:82`); the dashboard not seeing `methodology/BACKLOG.md` (`:137`); copying nprcgenekeepr's
colony overview (`:144`, later). Name every item in the picker (memory "Picker sets: name items, include all").
**Session boundary:** one session (two if the anchor rule or the collision warnings grow), G15a DONE; G15b and G15c
are sessions of their own.
**Priority:** HIGH (G15a-G15c, G16-G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 22 differ, 0 without a row**: S64 changed no package code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through S64.
2. Check S64's push: `docs/planning/` changed, which neither workflow's `paths-ignore` lists, so both run with no
   package change. Expected, not measured: CI fails on Ubuntu R-devel only (S4Vectors in "setup-r-dependencies",
   as S56-S63), the other four `success`, Ubuntu release's tests the same as S63's push (FAIL 0, WARN 0, SKIP 2,
   PASS 13,832); the site builds.
3. **G15a** by `docs/planning/mates-without-offspring-plan.md` section 7 (`:222`-`:244`), its interface in section 5
   (`:131`), its inventory in section 6 (`:165`), its dragons in section 8 (`:279`). Before the pre-RED picker
   (Learning 17), on a scratch copy: (a) pictures in headless Chrome at 500 px of the typed shapes (section 4) in
   both edge styles, today's anchor rule and the "hub" rule side by side, and what a mating point with nothing below
   looks like; (b) the 7 seeds whose rectilinear drawing gained a collision warning (18, 30, 55, 65, 73, 77, 84 of
   `tests/testthat/helper-layoutHints.R:14`'s generator, 1-3 matings from `pickMatings()`): which line crosses which
   animal, and whether the declared mating causes it; (c) what `trimPedigree()` and its kin leave in a `matings`
   table. Then the picker (the plan's `:232`-`:234`: the anchor, a pair named twice, the sexes, the hover's words,
   rows naming removed animals, whether the point is drawn), RED, GREEN, REFACTOR by the gates.

### Gotchas
- **A unit with no offspring has no side** (the plan's dragon 1; `R/makePedigreeDiagramData.R:1522`-`:1524`):
  `childSide` is `NA` and `NA == 0.0` stops an `if`. The gap case does not reach it; `secondMate` (A with B and
  offspring, A with G and none) does. RED needs that shape, or the fix goes untested.
- **New mating units go after the offspring units** (dragon 7): numbering the declared ones first renumbers every
  `__union_<n>` and breaks 600 of 600.
- **R70's check must read `matings`** (dragon 3): the layout returns the declared pair as a mate hint (G10), and
  passed back it stops today; check `matings` before `hints` (`.checkLayoutHints()`, `R/layoutHints.R:28`).
- **Today's anchor rule draws a hub twice** (dragon 2): `secondMate` and `twoChildless` draw A at each mating;
  kinship2 draws it once. The "hub" variant fixed `twoChildless` only.
- **The references fail where pedkindraw draws:** kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; Pedixplorer refuses a pair named twice; `rel()` is S4 (read with
  `as.data.frame()`). Compare only where each returns, with a floor (`expect_gte()`).
- **zsh does not split `$VAR` in `for f in $VAR`** (dragon 79): a check reported every file missing. **"missing
  value where TRUE/FALSE needed"** is found with `conditionCall(e)` (dragon 80).
- **A `cd` into `methodology/` persists** (it happened again in S64's ratchet run): run the ratchet as
  `(cd methodology && python3 quality_ratchet.py --run)` or follow it with an absolute `cd`.
- **Carried:** vis.js outlines in screen pixels, lines in units (73); the fidelity check compares the drawing's
  script (74); `pkg::` in a test warns in `R CMD check` (75); a number measured under one prototype option goes
  stale when another is picked (76); `\s` in an R one-liner inside shell quotes fails; dry-run every edit script on
  a copy (S64's prototype, option and close-out scripts each checked all anchors first); `NOT_CRAN=true` for the
  browser tests; guarded `rm` (`"${SP:?}"`); an unquoted heredoc rewrites backslashes (69); a `DIVERGENCE.md` row by
  its first cell (70); lintr refuses `par()` (71); covr's line numbers move with each edit; a `git archive` copy's
  `.Rprofile` (67) and the fidelity tool on a copy needs `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv
  lib>` (37); Monitors on `pgrep` (68); `gen` from `findGeneration()` (66); `tools/gapCases.R` leaves `Rplots.pdf`
  (41); the 5-file cap splits GREEN; the ratchet's suite gate times out at 300 s; `CLAUDE.md` is over its budget
  (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's
  library (`BACKLOG.md:165`).
- **Ledger sizes:** see S64's receipt (`CHANGELOG.md` about 145 KB, `HANDOFFS.md` about 115 KB, both under the
  196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/3df268da-e0a2-458c-a7fc-ce6aea638359/scratchpad/g15/`,
  may be gone; the plan's section 10 says what each did): `refcases.R` (16 shapes in kinship2 and Pedixplorer),
  `pxhint.R`, `apply_proto.py` (the prototype's edits), `apply_fix.py` (variants `na`, `hub`), `protorun.R`
  (`runLayout()`, `checkMatings()`, `pickMatings()`, `kindOf()`; `Rscript protorun.R <copy> <nSeeds> [out.rds]`),
  `tabulate.R`, `extras.R`, `trace2.R`, `apply_option.py`, `runtests.R` (test files of a copy, failures named),
  `closeout1.py`; outputs `refcases.out`, `rand_na.rds`, `rand_hub.rds`, `fidelity_na.out`.
- **Times** (S64's): the 16 reference shapes about 1 min; `protorun.R` on 100 seeds, both styles, with and without
  matings about 3 min; the fidelity tool about 3.5 min (97.5 s and 96.3 s); the suite about 5 min.

### Key files
- `docs/planning/mates-without-offspring-plan.md` (new): section 2 `:38` (the references' table), 3 `:72` (the
  options), 4 `:90` (the prototype), 5 `:131` (the interface), 6 `:165` (the inventory), 7 `:206` (phases; G15a
  `:222`, G15b `:246`, G15c `:258`), 8 `:279` (dragons).
- `docs/planning/standalone-pedigree-package-plan.md`: `:89` (Next), `:298` (R141), `:1299` (G15's plan entry);
  `docs/planning/cran-submission-plan.md:35`, `:688`; `docs/planning/gaps-and-shared-code-plan.md`: `:17` (status),
  `:379` (G15's row), `:810`-`:818` (dragons 78-80).
- G15a's code: `R/makePedigreeDiagramData.R:540` (`.findIsolatedIds()`), `:638` (`.buildMatingUnitForest()`),
  `:669`-`:686` (the pair keys), `:1522`-`:1528` (`childSide`), `:2179` (the last argument), `:2206` (the hints'
  check), `:2276` (isolated ids), `:2327` (the forest), `:2554` ("%d offspring"); help `:1812`, `:1930`, `:1947`,
  `:2117`-`:2122`; `R/layoutHints.R:28`, `:114`-`:180` (`.checkLayoutHintMate()`), `:148`, `:189`
  (`.layoutHintTogether()`), `:489` (`.layoutHintsUsedMate()`); `tools/gapCases.R:289`-`:312`;
  `vignettes/drawing.Rmd:69`, `:433`-`:446`; `DIVERGENCE.md:14`, `:17`, `:18`.
- Later: `R/getMatings.R:40` (G15b); `R/asPedFrame.R:248`, `:287`, `:351`-`:353`, `:404`, `:496`-`:527` (G15c).
- `methodology/BACKLOG.md:26` (G15-G17), and the items listed in the orient picker above.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S63's entries were removed in S3-S64 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 63 Handoff Evaluation (by Session 64)
**Score: 9/10.**
- **What helped:** item 3 of "What You Must Do" was the session's plan: measure kinship2's and Pedixplorer's
  `matesNoOffspring` first, the input to Mark in a picker with each option measured, a grep inventory of
  `.buildMatingUnitForest()` (rightly at `:638`, G15's row's `:454` stale), `.findIsolatedIds()` (`:540`, `:2276`),
  the mate hint's stop (R70) and the converters' left-out pairs, per-phase DONE and surface, 600 of 600. The
  orient predictions held: drift 91/22/0, nprcgenekeepr's 4 commits, S63's CI (R-devel only; Ubuntu release FAIL 0,
  WARN 0, SKIP 2, PASS 13,832, S62's 13,636 plus the new test's 196). The gotchas were used: dry-run edit scripts,
  guarded `rm`, dragon 67's `.Rprofile`, dragon 37's fidelity run on a copy, `NOT_CRAN`, the `cd methodology` trap.
- **What was missing:** that the converters drop the spouse pairs in their twins readers too
  (`R/asPedFrame.R:287`, `:404`, help `:37`-`:40`, `:86`), not only the hint rows at `:491`-`:508`; that R119
  defers "mates with no offspring" to G15, so `getMatings()` is in its scope; that no G phase had yet had a plan of
  its own (where it goes and what it is called); and the backlog's `findPedigreeNumber()` speed (`:227`, READY) and
  two DECISION NEEDED items (`:137`, `:144`), which its orient list (and so S64's picker) left out.
- **What was wrong:** nothing found wrong (R70's stop cited at `R/layoutHints.R:151` is inside the `stop()` that
  starts at `:150`).
- **ROI:** high.

### What Session 64 Did
**Deliverable:** Phase G15's plan, `docs/planning/mates-without-offspring-plan.md` (gap B1, mates with no offspring),
a planning session, no package code; ruling R141.
**Started:** 2026-11-20 23:36 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G15's plan
(Recommended)" (orient); "A matings table (Recommended)" (the input, R141). No corrections from Mark.
**Commits:** claim `d58a52f`; the plan, R141 and G15's row `445302f`; close-out 1 `41814b1`; close-out 2 (these
notes, the receipt, the ledger). Pushed at close.
**Measured:** kinship2 and Pedixplorer on 16 typed shapes, one process each under `timeout 30` (both draw the pair
joined on one row; both fail on 2 animals and on no offspring at all; Pedixplorer refuses a pair named twice;
kinship2's spouse hint alone draws such a pair in 11 of 13, Pedixplorer's in 2 of 4, against R74's "both ignore
it"); a scratch prototype of the picked input: 13 of 20 random pedigrees stopped at `childSide` (`:1524`) until a
unit with no offspring took the sex rule, then 0 of 100 in either style, all 200 declared matings on one row with
the point between and nothing between, 72 pedigrees gaining repeat nodes (130; "hub" 129), 7 gaining a collision
warning, the related pair's line `#D55E00` 4, the returned hints refused when passed back, fidelity 600 of 600; each
input option's cost in existing tests on scratch copies (10, 2, 3; a column 0 read).
**Self-assessment: 8/10.**
+ Every claim in the plan and the picker measured first; the one stop traced to its line and fixed in the
  prototype; the picker answered at once; all `file:line` citations checked by machine, 4 corrected before the
  commit; each phase names its surface and what the surface cannot enforce.
- Slips, all caught before a commit: the reference script read Pedixplorer's S4 `rel()` with `$`; a zsh loop
  reported every test file missing; the plan's first draft had 3 wrong line ranges, an unmeasured "the same without
  them" and an imprecise "11 of 13 valid shapes". The orient picker left out three backlog items (`:227`, `:137`,
  `:144`) by following the handoff's list instead of the backlog. The deepest reasoning mode could not be set from
  inside the session (told Mark: `/effort max`).
**Learnings:** the gaps plan's dragons 78-80; the G15 plan's own dragons 1-8. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S64 entries (the session, ruling R141, push 1).
