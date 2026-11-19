# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G8 DONE (S42-S49).
**G9 DONE (S50)**: `?shrinkPedigree`'s example shrinks its 7 animals with only F and G genotyped and draws the whole
pedigree with the 3 removed (C, A, B) filled, through the condition column `affected_removed`; a test runs the help
page's own example (R125-R126; help text only, no code changed).
**Next: Phase G10**, gap C3: `makePedigreeMatingLayout()` returns the layout hints it used, in the form it takes
(`docs/planning/gaps-and-shared-code-plan.md:367`; gaps document `docs/research/pedkindraw-gaps-2026-11-18.md:285`;
`methodology/BACKLOG.md:26`). The plan says 2-3 sessions: the first is likely measuring, the pre-RED picker and RED,
but say so only after measuring (a guess). Its pre-RED choices (the row): the new element's name; order hints only,
or mate hints too. Copied code changes (`R/makePedigreeDiagramData.R`), so a `DIVERGENCE.md` sentence at the switch
and **one counted fidelity set-aside** for the new list element (the row's DONE).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G10 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:52`),
rewording `DIVERGENCE.md`'s 14 older rows to "at the switch" (`methodology/BACKLOG.md:34`, documentation only) and the
"Ready, small" items (name all seven in the picker's fourth option, as S48-S50 did).
**Session boundary:** one session of G10 (it may take 2-3). Close out at a clean phase boundary (after RED, or after
GREEN and its checks), never mid-phase.
**Priority:** HIGH (G11-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G9 changed help only); nprcgenekeepr's
   log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S50; a new
   commit there to a copied file departs from R101: report it to Mark. None of those 4 touches the files G10
   changes (`R/makePedigreeDiagramData.R`, `R/layoutHints.R`); they touch `R/drawPedigreeDiagram.R` and
   `R/drawColonyOverview.R` (checked S50).
2. Check S50's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md` and `tools/` changed). Expect the Ubuntu
   R-devel job to fail again installing Bioconductor's S4Vectors 0.50.3 (S49's run `44557579212` did:
   `conformMethod` error, "lazy loading failed"; the backlog's CI item, `methodology/BACKLOG.md:152`): not
   pedkindraw's code. Any other failure is real.
3. **G10, measure before the pre-RED picker (Learning 17):** (a) `Rscript tools/gapCases.R ownHints`
   (`tools/gapCases.R:592`; today: kinship2's `autohint()` gives `order` and `spouse`, Pedixplorer's `auto_hint()`
   a `Hints` object, its `best_hint()` stops for want of R.utils, and `asPedFrame()` of kinship2's hints gives 41
   order numbers and 1 mate row); (b) where the layout settles its order: `.checkLayoutHints()` and
   `.layoutHintRows()` (`R/layoutHints.R:25`, `:255`), the forest and positions
   (`R/makePedigreeDiagramData.R:1980`-`:1981`), the returned list (`:2363`); the hints' help is `:1755`; (c) what
   "passed back, the same positions" holds on: the fixtures and seeded random pedigrees, comparing `nodes$x`/`y`
   with and without the returned hints, each case timed and under a limit; (d) the hint form kinship2's
   `autohint()` and Pedixplorer's `auto_hint()` return (R61-R62, R73-R76 give pedkindraw's form: `order` numbers
   named by id, `mate` rows `left`/`right`/`anchor`); (e) the fidelity tool's set-asides
   (`tools/compareResultsWithNprcgenekeepr.R:835`, `:867`, `:895`; `eachDrawing()` `:725`) as the pattern for the
   new element's; (f) the picker: the element's name, order only or mate hints too, each with measured counts.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:335`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4 row for `makePedigreeMatingLayout()`'s return; a `DIVERGENCE.md` sentence (its row is
   `DIVERGENCE.md:14`); fidelity exit 0 with the one new set-aside counted.

### Gotchas
- **G10's row cites `:1836` and `:2219` from S41**, before Phases G1-G4 moved `R/makePedigreeDiagramData.R`; find
  the places by text (Learning 7). Today the hints are read at `:1904` (check), `:1941` (order rows) and `:1980`
  (forest).
- **A new element in the layout's list changes every drawing case the fidelity tool compares** (600 results), so
  the set-aside must remove exactly that element and count the drawings it removed it from, as R81/R94/R95's do.
- **A test of a help example must read it where the help is** (dragon 28, new): `R CMD check` has no `man/`;
  `helpExampleCode()` (`tests/testthat/helper-helpExample.R:14`) falls back to `tools::Rd_db()`. The layout draws no
  animal without a parent, mate or offspring (`isolatedIds`): a value looked up per id can be `NA`.
- **Wait on a run's own end** (dragon 29, new): S50's wait loop matched "real" in the suite's log ("on the real
  fixture") and stopped early; wait for the background task's notice, or on `time`'s own line (`cpu .* total$`).
- **Measure what the reference draws before trusting a description of it** (S50): the gaps document said kinship2's
  `plot.pedigree.shrink()` marks the removed animals; it draws only the kept ones (R125). Render it (`pdftoppm` and
  R's `png()` both work here) and read the picture.
- **Integers and doubles:** pedkindraw's `bitSize` is integer, kinship2's double; S49's `lacy1989Ped$gen` was
  double. Run the draft tests on the prototype before RED: it caught this in S50.
- **Helpers load alphabetically and a later one with the same name wins** (dragon 26): grep
  `'^<name> <- ' tests/testthat/*.R` before naming a helper.
- **Time a slow or reference version on every fixture before RED** (dragon 27); sort text with `method = "radix"`.
- **Pass an environment variable to Rscript before it** (`S="$S" Rscript ...`), and source the test helpers with
  `TESTTHAT` set from inside `tests/testthat` (dragon 21).
- **Scratch copies:** `git archive HEAD | tar -x -C <dir>`, then `rm -f "${S:?}/<dir>/.Rprofile"`; run with `env -u
  RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`; `R CMD INSTALL -l <scratch lib> <copy>` takes 2 s and
  lets a test read the installed help as `R CMD check` will. Do not edit a tree while its suite or check runs (FM
  #29); docs may be edited once `R CMD build` has made the tarball.
- **Times** (S50's measures): the suite 5.1-5.3 min; the fidelity tool 3.7 min; `R CMD build` and `check --as-cran`
  3.8 min (all three can run at once on a committed tree); `quality_ratchet.py --run` about 5.4 min; the drift tool
  1 s; a gap case 1-2 s.
- **The ratchet's suite gate now times out** (S50): `test-suite-warnings-zero` has a 300 s limit and the suite takes
  304-317 s, so `--run` reads 4/5 with it unmeasured. Name it in the receipt as `unmeasured:
  test-suite-warnings-zero -- by hand: <your suite run>`; raising the limit is the backlog's "Ready, small" item
  (`methodology/BACKLOG.md:114`), a commit of its own, not a side task.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (30,795 B; learnings go to the plans' dragons and these
  notes); never pipe chromote or an R script that saves a file into `head`; the shell is zsh (`pipestatus`), and
  the harness blocks `sleep N; cmd`; `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:367` (G10's row), `:366` (G9's, with R125's correction), `:335`
  ("Every G phase"), `:574`, `:581` (dragons 28-29, new in S50).
- `docs/research/pedkindraw-gaps-2026-11-18.md:285` (C3); `tools/gapCases.R:592` (case `ownHints`), `:508`
  (`shrinkPicture`, G9's probes).
- `R/makePedigreeDiagramData.R`: `:1755` (`@param hints`), `:1876` (`makePedigreeMatingLayout()`), `:1904`, `:1941`,
  `:1980`-`:1981` (hints read), `:2363` (the returned list); `R/layoutHints.R:25` (`.checkLayoutHints()`), `:255`
  (`.layoutHintRows()`); `DIVERGENCE.md:14` (the layout's row).
- `tools/compareResultsWithNprcgenekeepr.R:61` (`runCases()`), `:725` (`eachDrawing()`), `:835`, `:867`, `:895`
  (set-asides).
- `docs/planning/standalone-pedigree-package-plan.md:71` (Next), `:199`-`:200`, `:211` (R61, R62, R73: hints),
  `:263`-`:264` (R125-R126), `:1109` (Done G9); `docs/planning/cran-submission-plan.md:600` (Done G9);
  `docs/planning/pedkindraw-api-contract.md:135` (the layout's row), `:237` (hints from converters).
- G9's work: `R/shrinkPedigree.R:239`-`:256` (the example), `:171` (the pointing sentence);
  `tests/testthat/test_shrinkPedigreeExample.R:16` (`shrinkExampleObjects()`), `:22`-`:59` (4 tests);
  `tests/testthat/helper-helpExample.R:14` (`helpExampleCode()`); `NEWS.md:153`.
- `methodology/BACKLOG.md:26` (G10-G17), `:34` (rewording `DIVERGENCE.md`), `:52` (smallPed fixture), `:114` (the
  suite gate's time limit), `:152` (CI).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S49's entries were removed in S3-S50 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 49 Handoff Evaluation (by Session 50)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(e) for G9 was the session's plan, item for item: the gap case, what
  `shrinkPedigree()` returns, how a condition column marks an animal, the two homes (help example at `:218`,
  vignette at `:191`) and the three ways to test, timed; its picker shape (where, and what test) was the one asked.
  Every prediction held: drift 91/21/0, the same 4 nprcgenekeepr commits, the R-devel job failing on S4Vectors. The
  gotchas on Chrome tests (`skip_if_no_chrome()`, `test_unknownAffected.R:281`), "run the drafts on the prototype
  before RED" (it caught an integer/double fault) and the scratch-copy recipe were used as written. Every cited
  line held at `f985e8e`.
- **What was missing:** that `DIVERGENCE.md` does not compare help text (its lines 9-10), so a help-only change to a
  copied file needs only a header line; that the gaps document's B7 line on kinship2's picture was wrong (not
  knowable without drawing it; the handoff did say to run the case).
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 50 Did
**Deliverable:** Phase G9 DONE: `?shrinkPedigree`'s example draws the whole pedigree with the animals shrinking
removed filled, from `idTrimmed`, and a test runs the help page's own example (R125-R126).
**Started:** 2026-11-19 09:50 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each Claude's recommendation):**
"Phase G9 (Recommended)" (orient); "Help example (Recommended)", "Run the example in a test (Recommended)"
(pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `33d05cb`; RED `f541656`; GREEN 1 `c7d04a3` (example, description sentence, header, man); GREEN 2
`fc478f9` (NEWS, gap case); REFACTOR `f489d7e`; close-out 1 `47f23e4`; close-out 2 (these notes, the receipt, the
ledger). All pushed at close.
**Measured:** kinship2's `plot.pedigree.shrink()` draws only the 18 animals it keeps of sample family 1's 41 (read
from a rendered picture), not the removed ones marked as the gaps document says; its `idTrimmed` omits 5 of its 23
removed; it keeps 130 or 133 by seed (20/20 of 40), pedkindraw 133. On the example's pedigree kinship2 removes the
same A, B, C. The vignette alternative: `small` loses 5 of 16; the 375-animal pedigree 322, with a layout warning
on 72 lines. The draft example and test on scratch copies: 16 of 16 from the source `man/` and from an installed
copy's help; the drawing read in headless Chrome (A, B, C pink, D-G white, "Affected (removed)"). RED: 12 failed, 1
error ("Mismatched lengths, id and sex"). Final: suite 67 files, 820 tests, 0 failed, 0 skipped, 0 warnings (5.3
min); lint 0; roxygen stable; covr: no new statement (parsed code identical); drift 91/21/0; fidelity 600 of 600,
kinship difference 0; `R CMD check --as-cran` 1 NOTE (R16's), the 4 new tests run inside it (its 12 skips all
browser tests "On CRAN"); the REFACTOR's gap-case output identical (9 lines, `cmp`); `quality_ratchet.py --run`
4/5 pass, `test-suite-warnings-zero` unmeasured (its 300 s limit; the suite by hand 0 warnings), results
`42b564bc4c70`.
**Self-assessment: 8/10.**
+ Every pick and gate came first time with no correction; the picker carried measured counts and a screenshot, and
  corrected a wrong claim in the gaps document before it reached the help or NEWS; the test reads the example where
  the help really is, proved both ways, and inside `R CMD check` itself; the probe's `NA` (an undrawn isolated
  animal) was found and stated, not hidden.
- A wait loop matched a test's own words ("real") and let `roxygenise()` run beside the suite (FM #29; it changed
  nothing), and dragon 29 first named the wrong word until checked against the log; the picker described the
  375-animal layout warning as "crossing lines" (corrected to "lines near unrelated animals" in R125); two lints in
  the first probe lines and one integer/double fault in the draft test, all caught before commit.
**Learnings:** the gaps plan's dragons 28-29; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S50 entries (the session, push 1).
