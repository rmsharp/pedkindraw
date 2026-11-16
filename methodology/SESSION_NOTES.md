# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Phase 16e, the website** (`docs/planning/documentation-plan.md:209`, section 5.6; its DONE at `:290`;
its open detail D4 at `:334`; ruling R78 at `docs/planning/standalone-pedigree-package-plan.md:192`). The orient
picker asks Mark: 16e (recommended: the plan's next phase, `standalone-pedigree-package-plan.md:50`); the "Select by
id" bug (`methodology/BACKLOG.md:32`); the gap document (`:52`, Mark's S26 request); tests for full coverage
(`:62`); or hold.
**Status:** READY. Phase 16d DEFERRED (S30, ruling R82 at `standalone-pedigree-package-plan.md:196`): "the
comparison of pedkindraw with kinship2 and Pedixplorer" (Mark) waits until pedkindraw times itself (its own timing
runs, a plan of its own replacing R79). The draft is on the branch `draft/speed-vignette` (`612eed9`, pushed, NOT
merged; leave it). So 16e builds the site with TWO articles (`pedkindraw.Rmd`, `drawing.Rmd`), and Phase 16 is DONE
after it.
**Plan (16e):** `_pkgdown.yml` (`url`, `destination: pkgdown_site`, `template: bootstrap: 5`, the reference index
in the six groups plus the package page, 32 topics; two articles); `pkgdown::check_pkgdown()` run before the file is
complete (the documentation plan's 5.7); `.github/workflows/pkgdown.yaml` (on push to master and by hand, R and pandoc
as `R-CMD-check.yaml` sets them up, the package installed for the build, `CLAUDE.md` and `DIVERGENCE.md` removed from
the runner's copy, `pkgdown_site/` deployed to `gh-pages`); `.Rbuildignore` and `.gitignore` lines (5.1's last row);
GitHub Pages turned on only with Mark's approval (`gh api -X POST repos/rmsharp/pedkindraw/pages`, outward-facing);
then `DESCRIPTION:13`'s `URL` and the README name the site, only once it answers (R16).
**Session boundary:** one session, 16e only; then Phase 16 DONE. Phase 17 (CRAN) starts with its own plan.
**Priority:** HIGH (the last session of Phase 16).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 5 differ, all with rows); `git -C ../nprcgenekeepr log --oneline
   b4abb9a0b..HEAD -- R/affectedConditions.R R/drawPedigreeDiagram.R R/deceasedSlash.R R/makePedigreeDiagramData.R
   R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15); if it has ported R81, `methodology/BACKLOG.md:41`
   is unblocked.
2. Push S30's close-out 2 commit with the session's first push (methodology only: it starts no CI run).
3. Before the pre-work picker (Learning 17), measure D4's two ways: pkgdown into renv by Learning 3's recipe (9
   packages: `pkgdown`, `downlit`, `fansi`, `httr2`, `ragg`, `systemfonts`, `textshaping`, `whisker`, `xml2`; run the
   gate `renv-lock-no-latest-repository` after the snapshot) or from R's own library (pkgdown 2.2.1) through the
   scratch recipe; and a trial `pkgdown::build_site()` into a scratch folder with the package installed (S25's M3:
   34.5 s, 45 pages; it published `CLAUDE.md` and `DIVERGENCE.md` and stopped on the stale 0.0.1 without install).

### Gotchas
- **Show Mark a page's framing before filling it (S30's lesson).** S30 built and checked nine tables before Mark
  read the page and judged its framing premature (a third of it explained nprcgenekeepr's code; R82). For a page
  whose sources or framing could be questioned, put an outline (sections, what each table compares, what the page
  explains) in a picker after the inventory, before the table work. Define on the page every term a table uses:
  Mark asked what "Generation depth", "Family trees" and "Shrink to 16 bits" were.
- **CI's `paths-ignore` lists only `CLAUDE.md` and `methodology/**`** (`.github/workflows/R-CMD-check.yaml:11-13`):
  a push touching `docs/planning/` starts a full run (16-19 min). The draft branch starts none (CI runs on
  `main`/`master` only).
- **Pictures of a page:** chromote `b$screenshot(selector = "html", cliprect = c(0, top, 1000, h))` with `top` in
  page coordinates; `sips -c ... --cropOffset` ignored its offsets and returned the wrong parts (S30). Pandoc's
  `Table:` caption line renders as a `<caption>` above the table in `html_vignette`.
- **Shell traps (S30):** `cmd | tail -2; echo $?` prints `tail`'s status, not `cmd`'s (capture the status first); zsh
  does not split an unquoted `$VAR` into words (`xargs`, or `${=VAR}`); `Rscript -e '...grepl("^\\|", x)...'` stopped
  with "'\|' is an unrecognized escape" (put the R code in a file).
- **The suite gate's 300 s limit** (`methodology/BACKLOG.md:108`) is below the suite's 4.3-4.5 min; cite a timed-out
  run with the suite's WARN count by hand.
- **Scratch install recipe** (stale pedkindraw 0.0.1 in renv's library, `methodology/BACKLOG.md:117`): `git archive
  HEAD | tar -x -C <tree>`; `env -u RENV_PROJECT R_LIBS=<scratch lib>:<renv lib> R_LIBS_USER=<renv lib> R CMD build
  --no-manual <tree>` and `R CMD INSTALL --library=<scratch lib> <tarball>`.
- **`.lintr` excludes `vignettes`, `tests`, `inst/extdata`**; the words gate reads `R man vignettes README.Rmd
  README.md NEWS.md`.
- **nprcgenekeepr moves during a session:** its S1177 was in progress through S30 (HEAD `1500e74e1`, then
  `9d51ecca4`; none on the copied files).
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23-S30 added nothing; learnings go in these Gotchas).
- **Left for Mark:** `pedkindraw.Rproj` untracked at the root (`.Rbuildignore:6` keeps it out of the build).
- **Times on this Mac:** the suite 4.3 min; `quality_ratchet.py --run` about 5 min; `R CMD check --as-cran` 3.0 min;
  a vignette page render 5-8 s; CI 14-19 min.

### Key files
- `docs/planning/documentation-plan.md:209` (5.6, the website), `:290` (16e's DONE), `:334` (D4), `:186` (5.5,
  with S30's note on the draft); `docs/planning/standalone-pedigree-package-plan.md:50` (Next), `:192` (R78), `:196`
  (R82), `:815` (the "Deferred 16d" record).
- `DESCRIPTION:13` (`URL`); `.github/workflows/R-CMD-check.yaml:7-13` (triggers, `paths-ignore`); `.Rbuildignore`.
- `methodology/BACKLOG.md:11` (16e), `:19` (the speed vignette, later), `:32` ("Select by id"), `:41` (after
  nprcgenekeepr's port, BLOCKED), `:108` (the suite gate's time limit), `:117` (the stale copy).
- The branch `draft/speed-vignette` (`612eed9`): `vignettes/speed.Rmd`, `tools/checkSpeedTables.R`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S29's entries were removed in S3-S30 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 31 Did
**Deliverable:** plan Phase 16e, the website (`docs/planning/documentation-plan.md` 5.6 and 16e's DONE; R78, R82):
the pkgdown site on GitHub Pages with two articles (IN PROGRESS)
**Started:** 2026-11-16 16:43 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Website, 16e (Recommended)"
(orient picker)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 29 Handoff Evaluation (by Session 30)
**Score: 9/10.**
- **What helped:** the steps in order (drift tool, nprcgenekeepr's log, the push with the first push, and "write
  `tools/checkSpeedTables.R` against them first", which made the failing run before the tables part of the plan);
  every key line it cited was right when read (`documentation-plan.md:67`, `:185`, `:269`; the contract's `:279`;
  `drawing.Rmd:681`; `pedkindraw.Rmd:399`; `R/pedkindraw-package.R:42`); the shell gotchas (zsh, `grep -F`); the
  suite gate's time limit.
- **What was missing:** the result files' layout and rounding (each summary script prints `format(signif(s, 3))`,
  S1141's prints three decimals); that S1141 ran kinship only to 30,000 animals and shrinking to 3,000, so the
  rewrite's rows have cells no record tried; that pedkindraw's `drawPedigreeDiagram.R` is copied at `4283e3502`, not
  `baef1e12c`, which matters to any "the timed code is the copy" claim. Each cost one lookup.
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 30 Did
**Deliverable:** plan Phase 16d, the speed and size-limits vignette, drafted to R79 and then, on Mark's reading,
deferred: ruling R82. TDD phase none (documentation), checks written first. No package file changed.
**Started:** 2026-11-16 15:15 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Speed vignette (Recommended)"
(orient); "Add definitions (Recommended)" (after asking what three computation rows meant); "Defer it (Recommended)"
and "pedkindraw times itself" (after "Disambiguation between pedkindraw and nprcgenekeepr may need to wait until
pedkindraw is completely separated. That is, this comparison may be premature." and "The comparison of pedkindraw
with kinship2 and Pedixplorer").
**Commits:** claim `a580612` (pushed with S29's close-out commits, CI `43958321631` 5/5); the draft `612eed9` on the
branch `draft/speed-vignette` (pushed, not merged); ruling `6883985` (the plan's R82, the documentation plan's notes,
the contract's shrink row); close-out 1 `7de3d09` (ROADMAP, BACKLOG), pushed with the ruling, CI `43966717453` 5/5;
close-out 2 (these notes, the receipt, the ledger), not pushed.
**Verified:** the check script run before the tables were filled, exit 1, 0 of 417 numbers; at the end 366 of 366
cells holding a number and 621 of 621 cells, exit 0; a changed number, swapped rows, an unmarked table and a changed
Done record each failed it (scratch tree); a separate cross-check against the studies' printed tables (comparison doc
7.1, 7.2, 9.2, 9.3; S1141's 4.2) agreed on 298 cells and caught planted changes; the code each record timed against
the copy by `git diff` (Part A and Part B differ from the copy in 6 of 34 copied files, S1141 in 1); the functions
Part A's other rows reach (codetools) touch none of the 6; the study's `rhesus375` the shipped example's ids, sires,
dams and sexes; the fidelity tool 600 of 600 identical, kinship difference 0; the trial page in headless Chrome, 35
KB, all 9 tables inside the 700 px column; drift tool 91 functions, 5 differ, 0 without a row; `quality_ratchet.py --run` 5/5 pass, 0 fail, 0
unmeasured, results `5ddbb5b1aeb3`, manifest `01151c525b8a` (the suite gate within its 300 s this time).
**Self-assessment: 7/10.**
+ The check was written and run failing first, then proved by four planted changes and by a second path that did
  not share its mapping; captions put each table's date, commits, versions and machine where the reader looks, and
  the script checks them against the documents that state them; claims were measured before the page stated them
  (the copy's identity, the call closure, the fidelity run); one unsupported sentence ("most of it on the layout")
  was cut before Mark saw it; the deferral left nothing half-done: the draft kept on a branch, the pointers taken
  out, every document that expected 16d updated.
- The framing (a third of the page about nprcgenekeepr's code) reached Mark only with the finished draft; an outline
  picker after the inventory would have found R82 two hours earlier. The page defined none of its computations
  until Mark asked. One shell slip each: crops from `sips` in the wrong order, and an exit status read from `tail`.
**Learnings:** no `CLAUDE.md` row (over its budget); in the Gotchas above: show Mark a page's framing before filling
it, and define its terms; CI's `paths-ignore`; chromote clips and `Table:` captions; three shell traps.
**Ledger:** `CHANGELOG.md` S30 entries (the session, the branch push and the two master pushes).
