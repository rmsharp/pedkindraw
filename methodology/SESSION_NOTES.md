# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G10 DONE (S42-S51).
**G11 DONE (S52)**: `getNearRelativePedigree(ped, probands, maxDist)`, a new export, keeps each animal within
`maxDist` of the probands (distance `log2(1 / k)`, `k` its largest kinship with one) and each parent of those whose
own and its mates' offspring number two or more, the other parents set to `NA`: the animals Pedixplorer's
`useful_inds(max_dist = )` keeps, 1,980 of 1,980 runs measured (R129-R130). One session, not the plan's 2-3.
**Next: Phase G12**, gap B4: a measured trait drawn by a threshold, with the rule in the legend, built on G1's check
(R102-R105) (`docs/planning/gaps-and-shared-code-plan.md:371`; gaps document
`docs/research/pedkindraw-gaps-2026-11-18.md:208`; `methodology/BACKLOG.md:26`). Its DONE: case `measuredTrait`
(`tools/gapCases.R:377`): at threshold 5, A, B, C unaffected and D affected; the legend states the rule. Pre-RED
choices (the row): a threshold argument or a colour scale; above, or at-and-above. Today (run S52) the case prints
Pedixplorer filling white, white, white, red with the legend "Healthy <= to 5" / "Affected > to 5", and pedkindraw
stopping by G1's check ("the condition column 'affected' holds numbers other than 0 and 1 (2.5, 0.3, 9)"). A guess,
not measured: G1's check is called in copied code (`R/makePedigreeDiagramData.R:173`, `:1954`), so G12 probably
changes copied code, which needs a `DIVERGENCE.md` sentence "at the switch" (R98) and the drift tool exit 0; with the
default unchanged the fidelity tool stays 600 of 600. The plan says 2-3 sessions (a guess; G10 and G11 took 1 each).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G12 (recommended: R97's order). Also READY: the `smallPed` fixture (`methodology/BACKLOG.md:53`),
rewording `DIVERGENCE.md`'s older rows to "at the switch" (`methodology/BACKLOG.md:35`, documentation only) and the
"Ready, small" items (`methodology/BACKLOG.md:113`; name all seven in the picker's fourth option, as S48-S52 did).
**Mark's question in S52 (answered, nothing filed):** whether a tutorial says which trait is which section of a
symbol and how a trait's name shows. Yes: the drawing vignette's "Conditions" (`vignettes/drawing.Rmd:197`: sections
counter-clockwise from the top in column order, each legend row the key; `:202`: `affected_diabetes` labelled
"Affected (diabetes)"; `:140`: hovering lists each condition). Two gaps were named to him: no picture of which
position each section takes for 2, 3 and 4 conditions, and the multi-condition tooltip shown only in a hidden
check (`:257`). He did not ask for an item; it would be documentation of its own, and B3/B5 (G13-G14) also touch
the drawing's marks.
**Session boundary:** one session of G12 (it may take 2-3). Close out at a clean phase boundary (after RED, or after
GREEN and its checks), never mid-phase.
**Priority:** HIGH (G13-G17 and 17g follow it).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G11 is pedkindraw's own code);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of
   S52; a new commit there to a copied file departs from R101: report it to Mark.
2. Check S52's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, the README, `_pkgdown.yml` and `tools/`
   changed). Expect the Ubuntu R-devel job to fail again installing Bioconductor's S4Vectors 0.50.3 (S51's run
   `44588760229` did, its other four jobs `success`; `methodology/BACKLOG.md:166`): not pedkindraw's code. Any other
   failure is real. The site build must succeed: `_pkgdown.yml` lists the new topic (`pkgdown::check_pkgdown()` "No
   problems found" on S52's tree).
3. **G12, measure before the pre-RED picker (Learnings 17-21; dragons 31-34):** (a) `Rscript tools/gapCases.R
   measuredTrait` (`tools/gapCases.R:377`); (b) Pedixplorer's help for `generate_colors()` (`threshold`,
   `sup_thres_aff`, `keep_full_scale`, `breaks`) and for whatever it names (dragon 32), and how its legend words the
   rule, help and results only, not its source; (c) G1's check, `.checkConditionNumbers()` (`R/conditionValues.R:20`;
   called at `R/makePedigreeDiagramData.R:173`, `:1954` and `R/shrinkPedigree.R:106`) and its rulings R102-R105
   (`docs/planning/standalone-pedigree-package-plan.md:243`-`:246`): a number other than 0 and 1 stops today, so a
   threshold decides where those numbers become affected; (d) how conditions are drawn and named: `conditionColors`
   (G4, R111-R113), the legend rows, the tooltip, and the drawing vignette's "Conditions" (`vignettes/drawing.Rmd:181`,
   whose hidden checks compare labels: dragon 31); (e) the picker: threshold or colour scale, above or at-and-above,
   each option tried on a scratch prototype with its counts. Anything drawn is measured in headless Chrome from
   vis.js (the plan's "Surface", `docs/planning/gaps-and-shared-code-plan.md:337` and below).
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:337`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4 for a new argument; in copied code a `DIVERGENCE.md` row or sentence and the drift tool exit
   0; fidelity 600 of 600 for an addition.

### Gotchas
- **Time the draft test file before RED** (dragon 33, new): a comparison with the reference package is the slowest
  part. S52's Pedixplorer comparison took 29 s for 500 calls until its object was built once per case (8 s per 100
  cases); 50 seeded cases kept the file at about 10 s, the measure's 1,980 runs going in the ruling.
- **Read the help of every quantity the reference's help names** (dragon 32, new): "a parent with two or more
  offspring" fitted the gap case at every distance and 76 of 396 random pedigrees; `num_child()`'s help (own plus
  mates' offspring) gave 1,980 of 1,980. Hold every candidate rule against every saved case.
- **Rd math gives `R CMD check --as-cran` a NOTE here** (dragon 34, new: "V8 unavailable"): write formulas as code.
  The prototype's check found it before RED; dragon 31's prototype run through the suite, `R CMD build` and the check
  paid for itself again.
- **A new export is listed in four places**: `_pkgdown.yml` (pkgdown refuses the site otherwise),
  `R/pedkindraw-package.R` (`?pedkindraw`), and `README.Rmd` with `README.md` rendered as G7's was (a scratch copy
  without `.Rprofile`, the tree installed in a scratch library, two renders identical; the README names all 36
  exports). pkgdown is not in renv's library: run `pkgdown::check_pkgdown("<repo>")` from a scratch folder with
  `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`.
- **zsh**: it does not split an unquoted variable (S52: `for c in "example 2"; Rscript x.R $c` passed one argument
  and six runs halted; use `${=c}`), and it stops a script on a glob that matches nothing (S51).
- **`identical()` on a `vapply()` result compares its names too** (S52: a right rule first read 0 of 1,980): `unname()`
  first, or build the vector with `USE.NAMES = FALSE`.
- **One writer, one copy** (FM #29): S52 edited a comment in the prototype copy while that copy's suite ran
  (harmless, the package was loaded first, but the slip it warns of). Keep one scratch copy for the suite and another
  for `R CMD build` and check.
- **A help-example test at RED** reads the stale pedkindraw 0.0.1's installed help ("installed help of package
  'pedkindraw' is corrupt") until `man/<topic>.Rd` exists: RED failing for the right reason
  (`methodology/BACKLOG.md:127`).
- **Carried:** run the prototype through `R CMD build` before the RED-to-GREEN gate (dragon 31); a round trip passes
  in silence when the thing passed back is missing (dragon 30); a floor in a draft test is a guess until run (S52
  guessed 480 and measured 245); Pedixplorer may need packages renv's library lacks (run each call in `tryCatch()`);
  helpers load alphabetically, a later one wins (dragon 26); time slow versions first (dragon 27); wait on a run's own
  end (dragon 29); pass an environment variable to Rscript before it (dragon 21); a test of a help example reads it
  where the help is (dragon 28). Scratch copies: `git archive HEAD | tar -x -C <dir>` (or `git ls-files -z | xargs -0
  tar -cf - | tar -x -C <dir>` for the working tree), `rm -f "${S:?}/<dir>/.Rprofile"`, run with
  `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`.
- **Times** (S52's measures): the suite 5.1-5.3 min (69 files, 853 tests); the fidelity tool 3.5 min; `R CMD build`
  and `check --as-cran` 3.8 min; covr (`type = "tests"`) 6.8 min beside three other runs; `quality_ratchet.py --run`
  5.3 min; all four checks at once about 7 min; the new test file about 10 s; the drift tool 1 s; a gap case 3 s.
- **The ratchet's suite gate times out** (300 s; the suite 303-315 s): `--run` reads 4/5 with it unmeasured. Name it
  in the receipt as `unmeasured: test-suite-warnings-zero -- by hand: <your suite run>`; raising the limit is the
  backlog's "Ready, small" item (`methodology/BACKLOG.md:115`), a commit of its own.
- **Carried:** `CLAUDE.md` is over its 28,000 B budget (learnings go to the plans' dragons and these notes); never
  pipe chromote or an R script that saves a file into `head`; the harness blocks `sleep N; cmd` (wait with a
  background `until` loop); `pedkindraw.Rproj` untracked, Mark's.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:371` (G12's row), `:360` (G1's row), `:370` (G11's, with S52's
  measure), `:337` ("Every G phase"), `:596`, `:602`, `:606` (dragons 32-34, new in S52).
- `docs/research/pedkindraw-gaps-2026-11-18.md:208` (B4); `tools/gapCases.R:377` (case `measuredTrait`), `:549`
  (`distanceSubset`, G11's probes from `:571`).
- G1's check: `R/conditionValues.R:20`; `R/makePedigreeDiagramData.R:173`, `:1954`; `R/shrinkPedigree.R:106`;
  `docs/planning/standalone-pedigree-package-plan.md:243`-`:246` (R102-R105).
- `docs/planning/standalone-pedigree-package-plan.md:74` (Next), `:270`-`:271` (R129-R130), `:1134` (Done G11);
  `docs/planning/cran-submission-plan.md:612` (Done G11); `docs/planning/pedkindraw-api-contract.md:188` (G11's row).
- G11's work: `R/getNearRelativePedigree.R:81` (the function; its help and example above, `:58`);
  `tests/testthat/test_getNearRelativePedigree.R` and `helper-getNearRelativePedigree.R` (`nearRelativesSlow()`,
  `pedixplorerNear()`); `R/findUnrelated.R` (`.unrelatedStopMessage(problems, caller)`); `R/checkPedigree.R`
  (`.checkIds(ids, caller, argument)`); `NEWS.md:161`; `README.Rmd:186`; `_pkgdown.yml:54`.
- `methodology/BACKLOG.md:26` (G12-G17), `:35` (rewording `DIVERGENCE.md`), `:53` (smallPed fixture), `:113`
  ("Ready, small"), `:115` (the suite gate's time limit), `:127` (the stale pedkindraw 0.0.1), `:166` (CI).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S51's entries were removed in S3-S52 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 51 Handoff Evaluation (by Session 52)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(e) for G11 was the session's plan, item for item: the gap case's
  numbers held exactly (41 animals, 7 informative, 14, 30, 33; `trimPedigree()` 18 and 13), Pedixplorer's three help
  pages, `useful_inds()` one process per case under `timeout`, the neighbours and R52. Dragon 31 (the prototype through
  the suite and `R CMD build` before the gate) was used as written and found two things before RED (the help's
  math NOTE, pkgdown's index). Every prediction held: drift 91/21/0, the same 4 nprcgenekeepr commits, S51's CI
  failing only on R-devel's S4Vectors, the suite's 5 min, the ratchet's unmeasured suite gate. The scratch-copy
  recipe and "a floor is a guess until run" (S52's 480 was) applied.
- **What was missing:** that a new export must be listed in `_pkgdown.yml`, `?pedkindraw` and the README (G7's
  commits showed it; found by grep); that pkgdown is outside renv's library; that the rule itself, not only the name
  and the default, would be a pre-RED choice.
- **What was wrong:** nothing found. "2-3 sessions (a guess; G10 took 1)": G11 took 1.
- **ROI:** high.

### What Session 52 Did
**Deliverable:** Phase G11 DONE: `getNearRelativePedigree(ped, probands, maxDist)`, the relatives within a distance
of chosen animals, as Pedixplorer's `useful_inds(max_dist = )` keeps them (R129-R130).
**Started:** 2026-11-19 13:12 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "Phase G11
(Recommended)" (orient); "Pedixplorer's rule (Recommended)", "getNearRelativePedigree", "Animals you name
(Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No
corrections. Mark asked mid-session about the condition sections in the tutorials (answered above, nothing filed).
**Commits:** claim `f40a795`; RED `a762ffb`; GREEN 1a `caf41e2` (code, help); GREEN 1b `ceb0eea` (`_pkgdown.yml`,
`?pedkindraw`); GREEN 2 `45381cb` (NEWS, README, contract, gap case); REFACTOR `ebe04e5` (two shared helpers given an
argument); close-out 1 `b8ccc55`; close-out 2 (these notes, the receipt, the ledger). All pushed at close.
**Measured:** on 396 pedigrees (380 seeded random, Pedixplorer's 2 sample families, 6 fixtures), one process each
under `timeout`, no hang: Pedixplorer's kept set at `max_dist` 1-5 is the animals within distance (`log2(1 / k)`)
plus each parent of them whose own and its mates' offspring number two or more, 1,980 of 1,980; pedkindraw's
`kinship()` gave its distances 396 of 396; it stopped on 14. Candidates that failed: within only 219, every parent
1,224, parents with two own offspring 76 of 396 at k = 1 (it fitted the gap case). The prototype in a scratch copy:
the typed cases each equal to Pedixplorer; the drafts 21 of 21 failing at HEAD and passing on it; its whole suite,
`R CMD build` and check before RED. Time: 0.48 s on 3,694 animals (Pedixplorer 2.0 s), 3.7 s on 10,000 (6.3 s).
Final, on `ebe04e5`: suite 69 files, 853 tests, 0 failed, 0 skipped, 0 warnings (5.1 min); lint 0; roxygen stable;
covr 24 of 24 new statements (88 of 88 and 87 of 87 in the helpers' files); drift 91/21/0; on `45381cb` fidelity 600
of 600 with no new set-aside, `R CMD check --as-cran` 1 NOTE (R16's), pkgdown no problems; the REFACTOR's 38
messages, 20 typed results and 300 random ones identical before and after (its commit says 23 typed: an `unlist()`
count split the empty result's 4 columns); `quality_ratchet.py --run` 4/5 pass, `test-suite-warnings-zero`
unmeasured (its 300 s limit), results `42b564bc4c70`.
**Self-assessment: 8/10.**
+ The rule was found exactly from help and results (1,980 of 1,980), with every candidate held against every saved
  case; each picker option carried counts; every pick and gate came first time; the prototype's suite, build and check
  ran before RED and caught the math NOTE and the pkgdown index; the REFACTOR was proved on 358 saved values; one
  session.
- A first rule fitted the gap case by coincidence and cost two rounds of tallies; the draft Pedixplorer test ran at
  29 s before it was timed; the floor was a guess (480) until measured (245); one edit in a copy while its suite
  ran (FM #29); scripting slips (names in `identical()`, zsh word splitting, a regex escape in `Rscript -e`) and
  the REFACTOR commit's count of its typed results (23 for 20, an `unlist()` miscount).
**Learnings:** the gaps plan's dragons 32-34; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S52 entries (the session, the rulings, push 1).
