# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 12, second session: `ibdMatrix()`** (`methodology/BACKLOG.md:11`; plan row
`docs/planning/standalone-pedigree-package-plan.md:497`; contract `docs/planning/pedkindraw-api-contract.md:159`).
New code written from kinship2's documentation, never its source (R11, R14). The orient picker asks Mark:
`ibdMatrix()` (it finishes Phase 12), or the other READY item, **tests for full coverage**
(`methodology/BACKLOG.md:27`: 44 of 1,929 statements the tests miss, the same 44 S14 listed by file and line), or hold.
**Status:** READY. Phase 12's first session DONE (S15): `familyCheck()` (R43-R45), 16 tests; suite 553 tests,
0 failed, WARN 0, SKIP 0; `R CMD check --as-cran` R16's NOTE only; drift tool 90 functions, 0 differ; pushed through
`b314273` (CI run `43461775633`: 5/5 `Status: OK` at the first attempt); S15's close-out commit is not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:36` (Next), `:497` (row 12), `:115` (R14),
`:144-146` (R43-R45, `familyCheck()`'s rulings: the pattern for `ibdMatrix()`'s); contract `:159` (its row, a
proposal), `:161-165` (shapes and errors are settled before RED).
**Session boundary:** one session, `ibdMatrix()` only; it completes Phase 12 ("Done 12" in the plan).
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`); nprcgenekeepr's
   S1162 (vignettes) committed during S15.
2. Read `?kinship2::ibdMatrix` (help only, R14; print it with `tools::Rd2txt(tools::Rd_db("kinship2")[["ibdMatrix.Rd"]])`),
   then re-run a few of the measurements under Gotchas to confirm them, each case in its own process under
   `timeout 15` (Learning 19): one of them never returns.
3. A pre-RED picker, measured first (Learnings 17-19): the return shape (kinship2 returns a `dsCMatrix`; the
   contract says "symmetric sparse `Matrix` named by id"); how `idmap` works (kinship2's is unusable, so only its
   help says what it should do: column 1 the ids in `id1`/`id2`, column 2 the names for the result); the order of the
   ids (kinship2: numbers by value, character by the locale; C16 says byte order); and the errors, among them what to
   do where kinship2 fails (a missing diagonal without `diagonal`, unequal lengths, conflicting values for one pair, a
   gap in numeric ids, empty input, factor ids). Then the checks (R45's pattern). Record the picks as rulings R46 on,
   in their own commit before RED.
4. RED: compute every expected value with kinship2 (where it returns) or a scratch run before writing it
   (Learning 18). GREEN: `R/ibdMatrix.R`. Checks: suite WARN 0, lint, roxygen, drift 0, `R CMD check --as-cran`,
   coverage of the new file; push; CI; the plan's "Done 12" (row 12 DONE), contract 4.3, ROADMAP, BACKLOG.

### Gotchas
- **kinship2 1.9.6.2's `ibdMatrix()`, measured S15** (scratch runs; the scripts were in S15's scratchpad, not kept):
  - It returns a `dsCMatrix`, `uplo` `"U"`, zero values dropped; a pair given either way round gives the same
    matrix; ids sorted, numbers by value (9, 10), character by the locale (`a A b B`; `"10"` before `"9"`).
  - A 3-column data frame or matrix as `id1` works; 2 columns stop ("Argument id1 is a matrix or dataframe  but does
    not have 3 columns"); `id1` alone as a vector stops (`id2` missing).
  - `idmap` is refused in every form tried: 2-column data frame, 2-column matrix, 1 or 3 columns ("idmap must have
    2 columns"); a list ("missing value where TRUE/FALSE needed"). Nothing to compare `idmap` against.
  - An id with no diagonal entry and no `diagonal`: it never returns (killed at 15 s; the first run stalled past
    120 s). `diagonal = 1` fills only the missing diagonal entries (a given 0.9 is kept).
  - Unequal lengths are recycled with only warnings, giving wrong values.
  - The same pair twice with one value is kept once (not summed); (1, 2) = 0.5 and (2, 1) = 0.3 keeps 0.5 silently.
  - Ids 1 and 3 give a 3 x 3 matrix with an all-zero row and column for 2 (diagonal 0); ids 9 and 10 give 2 x 2.
  - Character ids that are not numbers warn "NAs introduced by coercion" and still work.
  - `NA` in `x` stops ("missing value where TRUE/FALSE needed"); an `NA` id stops ("NA/NaN argument"); character
    `x` stops ("“sTMatrix” is not a defined class"); factor ids in a 3-column table stop (`max()` on a factor);
    `x = 0` is dropped, `x = 1.5` kept; empty vectors give warnings and a 1 x 1 matrix named `NA`.
- **`timeout` is MacPorts' GNU one** (`/opt/local/libexec/gnubin/timeout`); exit 124 means it fired.
- **kinship2's numbers can differ from its help's words** (Learning 19): `familycheck()`'s `join` counts a family
  once per shared tree (R43). Print the smallest case where a prototype differs before deciding which is right.
- **The kinship2 comparisons skip without kinship2** and assert a floor on the cases compared (`expect_gte()`,
  `tests/testthat/test_familyCheck.R:216`, `:235`): kinship2 stops in about half the cases, so an exact count
  would fail if kinship2 were fixed.
- **Times on this Mac:** full suite ~95 s; `covr::package_coverage(type = "tests")` ~2 min; `R CMD check --as-cran`
  ~5 min, its tests 78 s. Run `R CMD check` from a scratch folder with `R_LIBS` and `R_LIBS_USER` set to the renv
  library (`Rscript -e 'cat(renv::paths$library())'`); worked first time again.
- **zsh:** a `cd` into an empty folder followed by `rm -rf pedkindraw_*` fails ("no matches found"); quote the glob
  or use `find`.

### Key files
- `methodology/BACKLOG.md:11` (the `ibdMatrix()` item), `:27` (coverage); `docs/planning/pedkindraw-api-contract.md:158-159`.
- `R/familyCheck.R:72` (`familyCheck()`; `:75-86` its stops, `:93-104` the per-tree join count), `:125`
  (`.familyJoinTable()`), `:141` (`.familyTrees()`, the `makefamid()` numbering).
- `tests/testthat/helper-familyCheck.R:11` (`familyCheckPedigrees()`, the 9 fixtures as vectors), `:34`
  (`familyCheckPatterns()`), `:62` (`familyCheckRandomCase()`), `:89` (`normalizedFamilyCheck()`), `:104`
  (`kinship2FamilyCheck()`): a pattern for `ibdMatrix()`'s kinship2 comparisons.
- `tests/testthat/test_familyCheck.R:199`, `:219`, `:238` (the three kinship2 tests).
- `CLAUDE.md:174` (Learning 19).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S14's entries were removed in S3-S15 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 16 Did
**Deliverable:** plan Phase 12, second session: `ibdMatrix()` from kinship2's documentation (R14); kinship2's help
read and S15's measurements re-run under a time limit, then a pre-RED picker (shape, `idmap`, id order, errors,
checks), rulings, RED, GREEN, REFACTOR, checks, push, CI; it completes Phase 12 (IN PROGRESS)
**Started:** 2026-11-13 10:47 CST · **Model:** Claude Opus 5.5 · Mark picked "ibdMatrix()" at the orient picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 14 Handoff Evaluation (by Session 15)
**Score: 9/10.**
- **What helped:** "help, not source" with R14 cited, and that running kinship2 is allowed (R42), which made the
  scratch measurements the session's spine; the gap-analysis rows and contract rows, every line number right
  (`:94`, `:99`, `:115`, `:158-159`); "compute every RED value first" (one test value was then fixed before RED);
  `helper-shrinkSteps.R` as the pattern for the kinship2 helper; the out-of-folder `R CMD check` recipe and the
  times, both right; "nothing to copy or call".
- **What was missing:** that pedkindraw's `findPedigreeNumber()` is not kinship2's `makefamid()` (it gives each
  singleton its own number and an unreachable id `NA`, where `makefamid()` gives 0); found by reading it. And that
  kinship2's functions might fail or hang (only measurable; Learning 19 now says so).
- **What was wrong:** nothing found; every cited line checked.
- **ROI:** high.

### What Session 15 Did
**Deliverable:** plan Phase 12's first session, `familyCheck()`, new code test-first; push, CI (DONE).
**Started:** 2026-11-12 20:47 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 12, first session"
(orient); "familyCheck() now" (scope); "kinship2's numbers", "Plain stops, no kinship2 failures", "Keep it",
"Tests + kinship2 check" (pre-RED, R43-R45); the PRE-RED, RED, GREEN and REFACTOR gates "Yes".
**Commits:** claim `c2c3f63`; rulings `8baf3ae`; RED `d3dd469`; GREEN `d40fadc`; REFACTOR `b314273`; pushed
(`dff6509..b314273`, 7 commits with S14's two close-out commits); close-out `a478c70` and this commit, not pushed.
**Verified:** before the pickers, kinship2's `familycheck()` and `ibdMatrix()` run on typed cases (each
`ibdMatrix()` case under `timeout 15`); a scratch prototype of `familyCheck()` equal to kinship2 in 86 of 86 fixture
and 188 of 188 random cases where kinship2 returns (join counted per tree; counted once per family it differs in
90), its tree numbers `identical()` to `makefamid()`'s on 9 fixtures, and kinship2 stopping in all 227 of 463 cases
whose joins lie in one tree and in none of the other 236; every RED value computed by kinship2 or the prototype
first; RED 553 tests, 16 errors, each first on the missing function, WARN 0, SKIP 0; GREEN and REFACTOR: suite 553,
0 failed, WARN 0, SKIP 0, 2747 expectations; lint 0; roxygen idempotent; drift 90, 0 differ; `R CMD check
--as-cran` 1 NOTE (R16's), PASS 2740 SKIP 3, twice; coverage 97.38%, `R/familyCheck.R` 57 of 57 statements;
`quality_ratchet` 4/4; CI `43461775633` 5/5 `Status: OK`, first attempt (macOS PASS 2747; Windows 2746, SKIP 1; Ubuntu 2736, SKIP 2).
**Self-assessment: 8/10.**
+ Every picker option stated measured counts (Learnings 17, 18), including the finding that kinship2's `join`
  disagrees with its own help page, which became a picker choice instead of a silent pick; every expected value
  machine-checked before RED; RED clean (16 of 16 on the missing function); the new file fully covered; the
  REFACTOR gate's line estimate (about 5) close to the result (+6).
- Slips: a scratch `ibdMatrix()` script with no time limit stalled for two minutes before I killed it and re-ran each
  case under `timeout`; my first propagation loop in the prototype was wrong and was rewritten before any
  measurement used it; a `sed` edit to a scratch script made an unnamed list element (fixed by Edit); one RED test
  value was first typed as a sum (`c(1, 0, 0) + c(1, 0, 0)`) and corrected before the run; one lint
  (`0` for `0L`) fixed in GREEN.
**Ledger:** `CHANGELOG.md` S15 entries (the session and the push).
