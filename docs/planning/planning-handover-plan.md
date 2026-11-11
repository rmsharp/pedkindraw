# Plan: move pedkindraw's planning from nprcgenekeepr into this repository

**Date:** 2026-11-11 · **Session:** S4 · **Type:** planning session (`methodology/SESSION_RUNNER.md` §Planning
Sessions; `methodology/workstreams/ARCHITECTURE_WORKSTREAM.md`). No package code was written or changed.
**Status:** plan written S4. Step H0 (this plan, and the hand-over note in nprcgenekeepr) DONE S4. Steps H1 and H2
are next, one session each, before Phase 6b.
**Measured at:** pedkindraw `a262439` (the S4 claim); nprcgenekeepr `71217b296` (S1153's close-out; clean tree, idle).

---

## 1. Context

### 1.1 Mark's direction (after S3's close-out, his words)

"next session make a plan to copy information held within nprcgenekeepr into this repository into standard
methodology ledgers and other files. Update nprcgenekeepr that this repository will work going forward following
the original plan but updating it if needed."

### 1.2 The problem

Everything that governs pedkindraw lives in nprcgenekeepr: the plan, its rulings R1-R15 and C2, the API contract, the
evidence behind them, and the only record of where the work stands (the plan's status line and a `BACKLOG.md` item).
This repository points at them by absolute path (`CLAUDE.md:22-23`). Nothing in the plan ever hands them over: §1.3
moves *sessions* here from Phase 5 on, but not the planning; Phase 17 says "its own plan first" without saying where;
the drift rule (§5) has no end date (S3's reading of all 424 lines, confirmed S4).

Three things already go wrong:

1. **The status is stale where it is kept.** nprcgenekeepr's plan says "Phase 5 (skeleton) is the next pickup"
   (`nprcgenekeepr:docs/planning/standalone-pedigree-package-plan.md:8-9`) and its backlog item says the same
   (`nprcgenekeepr:BACKLOG.md:41,50-52`). Phase 5 finished in S2 and Phase 6a in S3. `CLAUDE.md:136` leaves that update
   to nprcgenekeepr sessions, which never work on pedkindraw.
2. **Rulings made here have no place in the plan.** Mark's picks in S2-S3 (the allowed check NOTE, the Phase 6
   split, `toCharacter()` left out, fixtures instead of datasets) are recorded only in this repository's notes,
   ledger and `CLAUDE.md`, while the plan they amend lives elsewhere.
3. **No list of open work exists here.** pedkindraw has no `BACKLOG.md`, and `methodology/ROADMAP.md` is the unfilled
   seed. Open items (Phase 6b, `pedkindraw.Rproj`, the context-budget fix, CI notices) live only in the transient
   `methodology/SESSION_NOTES.md`.

### 1.3 Constraints

- **Copy, not move** (Mark's word "copy"; plan R8's spirit). nprcgenekeepr keeps its files. Its ledgers and receipts
  cite them by path, so deleting them would break its own history.
- **nprcgenekeepr changes only in its docs and `BACKLOG.md`** (plan §1.3), and only in a session of its own or, as
  here, in one commit that follows its rules (a `methodology/CHANGELOG.md` entry of at most 1,000 B, its
  `BACKLOG.md`-reading tests run). One writer per working tree: check its `git status` is clean and its ACTIVE TASK
  is not IN PROGRESS before writing there (failure mode #29).
- **At most 5 files per commit** (`methodology/SAFEGUARDS.md`).
- **Mark's S4 picks:** "Plan, then note" (the note in nprcgenekeepr is written this session, after the plan);
  open work goes in a **`methodology/BACKLOG.md`** file (not GitHub issues); **five documents** are copied
  (section 3.1).

---

## 2. Decision

pedkindraw's repository becomes the home of its own plan. Its sessions follow the plan and change it where needed,
in their own copy. nprcgenekeepr's copies are frozen at the commit that writes the hand-over note (H0b) and are
not updated there again.

| Information | Home from now on | Form |
|---|---|---|
| The plan: purpose, rulings, phases with DONE criteria, drift rule, risks | `docs/planning/standalone-pedigree-package-plan.md` | copied (H1), then brought up to date (H2) |
| The API contract | `docs/planning/pedkindraw-api-contract.md` | copied (H1), then brought up to date (H2) |
| The evidence: comparison study, gap analysis, split scoping study | `docs/research/` (same file names) | copied (H1), not edited: dated records |
| Rulings made in pedkindraw sessions (S2-S4) | the plan's §2, as R16 on | H2 |
| Where the work stands | the plan's status block; `methodology/ROADMAP.md` (milestones, what is built) | H2 |
| Open work | `methodology/BACKLOG.md` (new, Mark's S4 pick) | H2 |
| What happened before this repository existed (nprcgenekeepr S667-S1150) | one pointer entry in `methodology/CHANGELOG.md` | H2 |
| How sessions here treat the plan | `CLAUDE.md` "Plan constraints every session carries" | H1 |
| The comparison scripts and Phase 1 pedigrees (`tools/pedigreeComparison/`) | stay in nprcgenekeepr | cited by path; the results tool reads them from the clone |
| The clean-room plan, the license scoping, the colony overview design | stay in nprcgenekeepr | cited by path; their pedkindraw facts are carried into the plan (H2) or the backlog (H2) |
| nprcgenekeepr's history of this work (ledgers, receipts, learnings) | stays in nprcgenekeepr | the H2 pointer entry names the sessions |

**Same file names, same folders.** The three copied studies and two governing documents keep their nprcgenekeepr
paths, so their links to each other (`docs/planning/pedkindraw-api-contract.md`,
`docs/research/pedigree-package-comparison-2026-11.md` and the rest) resolve here without edits.

**Every other path in the copies stays nprcgenekeepr's.** The copies name `R/kinship.R:62`, `BACKLOG.md`,
`tools/pedigreeComparison/`, `vignettes/...` and so on, meaning nprcgenekeepr's files. A provenance note at the top of
each copy says so and lists the five files that do resolve here. Text written here later names nprcgenekeepr's files
as `nprcgenekeepr:<path>` (this plan's own convention). Rewriting every path in the copies was rejected (section 7).

**Old line citations stay true.** Notes and receipts written before the copy cite nprcgenekeepr's files by absolute
path (for example `methodology/SESSION_NOTES.md:39-40`), and those files are frozen, so the citations keep resolving.
Citations written after H1 use this repository's copies, whose line numbers differ by the provenance note's length.

---

## 3. Inventory (measured S4)

Search: `git -C ../nprcgenekeepr grep -il -e pedkindraw -e "standalone pedigree" -e "standalone-pedigree"`
(33 files), then each hit read, then every repository path the governing documents cite (Appendix A). The search
misses the two older studies, which predate the name; they were found through the plan's citations.

### 3.1 Copied here (Mark's S4 pick: five documents, 2,224 lines)

| nprcgenekeepr file | Lines | Last changed | Needed here by |
|---|---:|---|---|
| `docs/planning/standalone-pedigree-package-plan.md` | 424 | `617420377` 2026-11-10 | every phase |
| `docs/planning/pedkindraw-api-contract.md` | 254 | `1adaf9457` 2026-11-10 | every phase that adds an export |
| `docs/research/pedigree-package-comparison-2026-11.md` | 853 | `bf00e62b5` 2026-11-03 | Phases 13 (contract §4.4: doc sections 4, 5.4, 7), 14 (§4.5: doc section 11.2), 16 (the timing tables) |
| `docs/research/kinship2-feature-gap-analysis-2026-09-20.md` | 202 | `42d617267` 2026-10-02 | Phase 12 (plan: "gap analysis rows 7, 12"); plan §1.2 |
| `docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md` | 491 | `42d617267` 2026-10-02 | plan §1.2; "Later, optional" (plan: "the scoping doc §7 steps 3-4 are the checklist") |

The plan file changes once more before it is copied: H0b writes the hand-over note into its status block. H1 copies
every file at the H0b commit, so the copy equals nprcgenekeepr's last version.

### 3.2 Stays in nprcgenekeepr, cited by path

| nprcgenekeepr file | What it holds about pedkindraw | What happens |
|---|---|---|
| `BACKLOG.md:40-63` | the status item | H0b shrinks it to a pointer that keeps nprcgenekeepr's drift duty (section 4, H0b) |
| `docs/planning/cleanroom-rewrite-plan.md` (809 lines): `:60` (C2), `:90`, `:357`, `:365-375` (§4.8), `:689`, `:708`, `:748`, `:773` | C2: Phases 7, 8 and 10 copy the clean-room code; the waits, all lifted (the rewrite finished S1140, `nprcgenekeepr:BACKLOG.md:62-63`) | H2 writes §4.8's facts into the plan's Phase 7, 8 and 10 rows |
| `docs/planning/nprcgenekeepr-license-scoping.md` (274): `:7`, `:25`, `:169-174`, `:221`, `:259-260` | nprcgenekeepr's own license work; pedkindraw named as a possible shared route | nothing: its open item 3 (`:259-260`) was settled by C2 |
| `docs/planning/colony-overview-scoping.md:117-118`; `docs/planning/colony-overview-design.md:21` (D8) | "Whether pedkindraw copies it later is Mark's call" | H2 adds a backlog item: DECISION NEEDED, later |
| `tools/pedigreeComparison/` (52 tracked files, 5.9 MB; 18 cite the plan in their headers) | Phase 1-2 scripts; the 13 Phase 1 pedigrees in `data/` | stays: `tools/compareResultsWithNprcgenekeepr.R:90` reads `data/` from the clone, which the results check needs anyway |
| `docs/planning/cran-3.0.0-submission-plan.md` (1,145), `docs/planning/pedigree-diagram-*`, `tools/perf/harness.R`, `vignettes/...`, `inst/extdata/...` | cited by the plan as models or sources | stays; read from the clone when a phase needs it (Phase 17 models its plan on the first) |
| `methodology/CHANGELOG.md` (20 matching lines), `methodology/HANDOFFS.md` (18), `methodology/archive/HANDOFFS-through-2026-11-09.md` (39), `methodology/SESSION_NOTES.md` (4), `PROJECT_LEARNINGS.md:3172,3175,3232,3235`, two other archives (1 each) | the history of S1121-S1150 | stays; H2's pointer entry names the sessions. No learning is carried: each concerns finished work (the license inventory, Phase 5's set-up) |

No open GitHub issue in `rmsharp/nprcgenekeepr` concerns pedkindraw (`gh issue list --state all --search`, S4).
No nprcgenekeepr test reads the plan or names pedkindraw (`git -C ../nprcgenekeepr grep -l -e standalone-pedigree
-e pedkindraw -- tests/`: none). Its `BACKLOG.md` is read by `test_docsAuditLooseEnds.R` and
`test_docsAuditSixRulings.R`, which check other wording only (`:41-48`, `:63-72`); H0b runs both.

### 3.3 In pedkindraw: every line that points at nprcgenekeepr's planning

`git grep -n -e "nprcgenekeepr/docs" -e pedigreeComparison -e standalone-pedigree -e api-contract` outside the
synced methodology files:

| File:line | Now | After |
|---|---|---|
| `CLAUDE.md:22-23` | the governing documents, by absolute nprcgenekeepr path | this repository's `docs/planning/` copies (H1) |
| `CLAUDE.md:136` | "the plan's status line and its `BACKLOG.md` item in nprcgenekeepr are updated by sessions there" | sessions here keep the plan, `methodology/ROADMAP.md` and `methodology/BACKLOG.md`; nprcgenekeepr's copies are frozen (H1) |
| `DIVERGENCE.md:4` | "nprcgenekeepr `docs/planning/standalone-pedigree-package-plan.md` section 5" | the copy here (H1) |
| `tools/compareWithNprcgenekeepr.R:1`, `tools/compareResultsWithNprcgenekeepr.R:2` | header comments citing nprcgenekeepr's plan | the copy here (H1; comments only) |
| `tools/compareResultsWithNprcgenekeepr.R:15,90` | `tools/pedigreeComparison/data` in the clone | unchanged (section 3.2) |
| `methodology/SESSION_NOTES.md:39-40` | Phase 6b's pointers into nprcgenekeepr's plan and contract | each session rewrites its notes; H1's hand-off uses the copies |
| `methodology/CHANGELOG.md`, `methodology/HANDOFFS.md` (S1-S3 entries) | history citing nprcgenekeepr's plan | unchanged: history, and the cited file is frozen |
| `.Rbuildignore` | no `^docs$` | `^docs$` added S4 with this plan, so `docs/` stays out of the built package |
| `methodology/ROADMAP.md` | the unfilled seed | filled (H2) |
| `methodology/BACKLOG.md` | absent | created (H2) |

The copied R files' headers ("Copied from nprcgenekeepr R/... at nprcgenekeepr commit ...") cite code, not planning,
and stay. The drift tool reads only `R/` (`tools/compareWithNprcgenekeepr.R:103`), so headers on the copied documents
cannot confuse it.

---

## 4. Steps

Each step is one session unless it says otherwise. Close out when its DONE criteria hold. Phase 6b waits until H2 is
DONE. Mark may fold H1 and H2 into one session at H1's orientation picker; if he does, the 5-file commit cap still
holds and H2's commits follow H1's.

### H0 -- This plan and the hand-over note (S4; DONE)

**H0a:** this document and `^docs$` in `.Rbuildignore`, committed in pedkindraw.

**H0b:** one commit in nprcgenekeepr, after re-checking its tree is clean and its ACTIVE TASK is not IN PROGRESS:
- **Plan status block** (`nprcgenekeepr:docs/planning/standalone-pedigree-package-plan.md:5-9`): the stale "Phase 5
  (skeleton) is the next pickup" becomes the state at the freeze (Phase 5 DONE in pedkindraw S1-S2, Phase 6a DONE
  S3), and a closing sentence says the plan is carried in pedkindraw's repository from 2026-11-11 (Mark's
  direction), whose sessions follow it and change it where needed in their own copy; this copy is no longer updated
  here; nprcgenekeepr's one standing duty is section 5's last line.
- **Backlog item** (`nprcgenekeepr:BACKLOG.md:40-63`): shrunk to a short item tagged RECURRING (the drift watch)
  that keeps the purpose line, says the work is carried in `rmsharp/pedkindraw` from 2026-11-11, points at the
  frozen plan and at pedkindraw's `methodology/BACKLOG.md`, and keeps the duty: a fix to a function pedkindraw copied
  that is not yet mirrored gets a line in nprcgenekeepr's `BACKLOG.md` naming it.
- **Ledger:** a `methodology/CHANGELOG.md` entry in nprcgenekeepr, `[ad hoc]`, at most 1,000 B, naming pedkindraw S4.
- **Not changed:** the contract, the studies, any test, `R/`, `CLAUDE.md`, nprcgenekeepr's session notes and receipts.

**DONE:** both commits exist; nprcgenekeepr's `test_docsAuditLooseEnds.R` and `test_docsAuditSixRulings.R` pass;
its entry is at most 1,000 B; `R CMD build .` here leaves `docs/` out of the tarball. **Surface:** this Mac; docs only.
**Not pushed** in either repository (pedkindraw's next push is Phase 6b's; nprcgenekeepr's is Mark's).

### H1 -- Copy the five documents and point this repository at them (one session)

**Steps.**
1. Orient. Record the source commit `C`: the H0b commit (this plan's close-out writes its hash into
   `methodology/SESSION_NOTES.md`). Check the five files are unchanged since: `git -C ../nprcgenekeepr log --oneline
   C..HEAD -- <the five paths>` prints nothing. If it prints a commit, copy at that commit instead and say why.
2. **Commit 1** (2 files): the plan and the contract, byte for byte:
   `git -C ../nprcgenekeepr show "C:<path>" > <path>`.
3. **Commit 2** (3 files): the three studies, the same way.
4. **Commit 3** (5 files): a provenance note under each title line: copied from nprcgenekeepr `<path>` at
   nprcgenekeepr commit `C` (pedkindraw S<N>, this plan's step H1); from here on this copy is the live one and
   nprcgenekeepr's is frozen (the plan and the contract only; the studies are dated records, not edited); paths
   name nprcgenekeepr's files except the five copied here, which the note lists. Nothing else changes.
5. **Commit 4** (4 files): `CLAUDE.md:22-23` and `:136` (section 3.3), `DIVERGENCE.md:4`, the two tool header
   comments.

**DONE:**
- After commits 1-2, each copy equals its source:
  `git -C ../nprcgenekeepr show "C:$p" | cmp - "$p"` is silent for each of the five.
- After commit 3, the copies differ from their sources only by the added note:
  `diff <(git -C ../nprcgenekeepr show "C:$p") "$p" | grep -c '^<'` prints 0 for each.
- `git grep -n "nprcgenekeepr/docs" -- CLAUDE.md DIVERGENCE.md tools` prints nothing.
- Both tools still pass: `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr` and
  `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr` exit 0 (their headers changed, not their code).
- `R CMD build . && R CMD check --as-cran pedkindraw_*.tar.gz`: 0 errors, 0 warnings, only the allowed NOTE
  (`CLAUDE.md:115`); `tar tzf pedkindraw_*.tar.gz | grep -c '/docs/'` prints 0.
- `Rscript -e 'testthat::test_local()'` passes.

**Surface:** this Mac. CI cannot see anything H1 changes (documents and comments), so H1 does not push.
**Session boundary:** one session. Close out when the above holds.

### H2 -- Bring the plan up to date; open the roadmap and backlog (one session)

**Steps.**
1. Orient. A picker confirms with Mark the list of rulings below before any is written (plain words, Learning 2).
2. **Commit 1** (1 file), the plan:
   - **Status block:** the state now (Phases 1-4 in nprcgenekeepr, Phase 5 S1-S2, Phase 6a S3, the move S4 and H1-H2,
     next Phase 6b), replacing H0b's freeze sentence.
   - **§1.3:** "Phases 1-4 run here; Phases 5 onward run in the new repository" rewritten for this repository as the
     plan's home; the nprcgenekeepr-boundary line kept.
   - **§2, new rulings from R16,** each with its session and "Mark": S2 the allowed check NOTE until the package is
     on CRAN (`CLAUDE.md:115`); S2 `LICENSE` YEAR 2017-2026 and Mark alone in `Authors@R`; S2 the context-budget fix
     waits for its own session; S3 Phase 6 split into 6a (10 functions) and 6b (11); S3 `toCharacter()` stays out
     (R13; it settles the conflict between plan Phase 6's row and contract R13); S3 sample pedigrees are test
     fixtures, not package datasets, and examples type their own pedigree; S3 the copied tests' `stringi` calls
     replaced by base R with identical values; S4 the plan's home moves here, open work in `methodology/BACKLOG.md`,
     the five documents copied. Sources: `methodology/CHANGELOG.md` S2 and S3 entries, `methodology/HANDOFFS.md`
     S2 and S3 receipts.
   - **Phase 5:** a "Done (S1-S2)" record. **Phase 6:** the split, a "Done 6a (S3)" record, `toCharacter` out of the
     row, `data.table` settled (only `addIdRecords()`). **Phases 7, 8 and 10:** C2 and
     `nprcgenekeepr:docs/planning/cleanroom-rewrite-plan.md` §4.8 written in: each copies the clean-room code
     (`R/kinship.R` and `R/mzTwinGroups.R`; the layout solver; `R/shrinkPedigree.R`), nothing waits, "write ...
     from the published methods" no longer applies.
   - **§5:** "differs from the installed nprcgenekeepr's" becomes "read from the local clone with git", as the tool
     does (`CLAUDE.md:138`).
3. **Commit 2** (1 file), the contract: §5's Imports (`stats` and `utils` only once a copied function uses them;
   none in Phase 6, S2's finding); §9's rows 7, 8 and 10 as in the plan; §10 item 2 closed by C2 (the plan says so at
   `:88`; the contract still lists it open).
4. **Commit 3** (3 files):
   - `methodology/ROADMAP.md`: current milestone (the copy slices, Phases 6-10), planned (Phases 11-17, pointing to
     the plan's §4), what is built (Phase 6a's 8 exports and 2 internals; the drift and results tools), completed
     milestones (Phases 1-4 in nprcgenekeepr, Phase 5, Phase 6a, the move).
   - `methodology/BACKLOG.md` (new), each item tagged `(READY | BLOCKED | DECISION NEEDED, Effort S|M|L)`: Phase 6b
     (READY, M; its scope from `methodology/SESSION_NOTES.md`); Phases 7-17 (one item pointing to the plan's §4);
     `pedkindraw.Rproj`, commit or ignore (DECISION NEEDED, S); the context-budget path fix (READY, S; Mark's S2
     ruling: its own session); CI notices, `actions/checkout@v5` and Ubuntu 26 (READY, S); argument names reviewed
     before the first CRAN release (contract §6, §10 item 4); `findPedigreeNumber()`'s speed (contract §10 item 5);
     whether to copy nprcgenekeepr's colony overview (DECISION NEEDED, later; its D8); the vacuous first expectation
     in `test_findPedigreeNumber.R`, to report to an nprcgenekeepr session (READY, S).
   - `methodology/CHANGELOG.md`: one backfilled pointer entry for the work before this repository existed
     (nprcgenekeepr S667, S741-S742, S1117, S1121-S1130, S1140, S1149-S1150; where: nprcgenekeepr's
     `methodology/CHANGELOG.md` and `methodology/HANDOFFS.md`).

**DONE:**
- The plan's status block, §2 and Phase 5-10 rows match the facts above; every ruling added has a session and a
  source in this repository's ledger or receipts.
- `methodology/BACKLOG.md` exists, every item tagged; `methodology/ROADMAP.md` has no seed comment left unanswered.
- The H1 checks still hold for the three studies (unchanged since H1: `git log --oneline -- docs/research` shows only
  H1's commits).
- `R CMD check --as-cran` and the test suite as in H1; the `lint-package-zero` and
  `renv-lock-no-latest-repository` gates pass (`python3 methodology/quality_ratchet.py --run`).
- `python3 methodology/methodology_dashboard.py` runs; the next session's Phase 0 reads `methodology/BACKLOG.md`
  (`methodology/SESSION_RUNNER.md:17` falls back to it, and `gh issue list` shows no issues).

**Surface:** this Mac; documents only. No push (Phase 6b's push carries H1 and H2).
**Session boundary:** one session. Phase 6b follows in a new session.

---

## 5. After the move

- **Two copies of the plan exist and are allowed to differ.** Unlike copied code (plan §5, `DIVERGENCE.md`), the
  documents are not drift-checked: nprcgenekeepr's are frozen records, this repository's are live.
- **nprcgenekeepr's one remaining duty** is the drift rule's last line (plan §5): a fix to a copied function not yet
  mirrored gets a line in its `BACKLOG.md`. The H0b backlog item carries it there.
- **Sessions here** update the plan's status block, `methodology/ROADMAP.md` and `methodology/BACKLOG.md` at
  close-out, and record a new ruling in the plan's §2 in the session that makes it.

## 6. Risks

| Risk | Where it bites | Countermeasure |
|---|---|---|
| A reader takes a copied path (`R/kinship.R:62`, `BACKLOG.md`) for this repository's file | every later session | the provenance note at the top of each copy; later text writes `nprcgenekeepr:<path>` |
| An nprcgenekeepr session keeps updating its frozen plan out of habit | after H0b | the freeze sentence in its status block and the backlog item; nothing reads it there |
| nprcgenekeepr changes a source file between H0b and H1 | H1 | H1 step 1's `git log C..HEAD` check; copy the newer version and say why |
| The copy is not byte-exact (encoding, a final newline) | H1 | `cmp` against `git show` before the provenance commit |
| `docs/` enters the built package and gives a check NOTE | from S4 on | `^docs$` in `.Rbuildignore` (S4); H1 checks the tarball listing |
| A ruling is mis-stated when written into the plan from the ledgers | H2 | Mark confirms the list by picker first; each ruling names its session and source |
| Line citations in old notes point at the wrong copy | after H1 | old citations use absolute nprcgenekeepr paths and that file is frozen (section 2) |

## 7. Alternatives considered

| Alternative | Pros | Cons | Why not |
|---|---|---|---|
| Move the files: delete them in nprcgenekeepr | one copy only | nprcgenekeepr's ledgers, receipts and learnings cite them by path; deleting breaks its history | Mark said "copy" |
| Leave planning in nprcgenekeepr and read it by path (today) | no work | its status needs nprcgenekeepr sessions, which never come; already stale | Mark's direction |
| Rewrite every nprcgenekeepr path in the copies to `nprcgenekeepr:<path>` | each path unambiguous | 24 code-file citations plus `BACKLOG.md`, `CLAUDE.md` and tool paths, edited by hand; the copies stop matching their sources byte for byte | the provenance note does the same job with no edits and keeps the copies checkable with `diff` |
| Copy only the plan and the contract | 678 lines instead of 2,224 | Phases 12-14 and 16 would read the studies from the clone | Mark's S4 pick: five documents |
| GitHub issues instead of `BACKLOG.md` | the methodology checks issues first | public; outward-facing per item | Mark's S4 pick: `BACKLOG.md` |
| Copy `tools/pedigreeComparison/` too | the Phase 1 pedigrees local | 52 files, 5.9 MB, for finished Phases 1-2; the results check needs the clone regardless | not needed |
| Do H1 and H2 in this session | fewer sessions | bundles the plan with its execution (failure mode #18) | planning sessions stop at the plan |

## 8. Scope boundary

This plan does not: change any R code, test or package file except `.Rbuildignore`; re-open any ruling R1-R15 or C2;
change nprcgenekeepr beyond H0b's two edits and its ledger entry; copy nprcgenekeepr's code, tools, history or
learnings; push either repository.

---

## Appendix A -- Commands behind section 3

Run from pedkindraw's root, nprcgenekeepr cloned beside it.

```sh
# Every nprcgenekeepr file naming the package (33)
git -C ../nprcgenekeepr grep -il -e pedkindraw -e "standalone pedigree" -e "standalone-pedigree"
# Repository paths each governing document cites
for f in docs/planning/standalone-pedigree-package-plan.md docs/planning/pedkindraw-api-contract.md \
         docs/research/pedigree-package-comparison-2026-11.md; do
  git -C ../nprcgenekeepr show HEAD:$f | grep -o -E '(docs|inst|tools|methodology|vignettes|data-raw)/[A-Za-z0-9_./*-]+' |
    sort | uniq -c; done
# Size and last change of each copied document
for f in <the five paths>; do wc -l ../nprcgenekeepr/$f; git -C ../nprcgenekeepr log -1 --format='%h %cs' -- $f; done
# nprcgenekeepr tests that read BACKLOG.md or the plan
git -C ../nprcgenekeepr grep -l -E '"BACKLOG\.md"' -- tests/
git -C ../nprcgenekeepr grep -l -e standalone-pedigree -e pedkindraw -- tests/
# pedkindraw lines pointing at nprcgenekeepr's planning
git grep -n -e "nprcgenekeepr/docs" -e pedigreeComparison -e standalone-pedigree -e api-contract -- \
  ':!methodology/SESSION_RUNNER.md' ':!methodology/workstreams' ':!renv'
```
