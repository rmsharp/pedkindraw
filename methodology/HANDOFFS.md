# Handoff Receipts — durable close-out proof

The cumulative, append-only record of **each session's close-out handoff**, distilled into a
machine-checkable block. It is the durable answer to *"was close-out actually performed, and what
did the session hand its successor?"* — the part of close-out that otherwise lives only in the
transient `SESSION_NOTES.md` (overwritten every session) or the spoken report (which leaves no file
at all).

One `handoff` block per **session** (not per commit), newest on top. The canonical-only
`bin/check-handoff` (copy it into your `bin/` if you want the structural check) asserts each block is
present and structurally complete; the next session's Phase 0 reconcile greps this file for a missing
or still-`pending` receipt and backfills it — that reconcile, not the checker, is the dependable
backstop, so the discipline needs no tooling. Together — a write-step at close-out **and** a
reconcile-on-read backstop — this makes a skipped handoff *detectable* rather than silent.

> **A green `bin/check-handoff` is not a good handoff.** The check verifies presence and structure,
> never semantic quality. Faithfulness is still scored 1–10 by the next session (Phase 3A). A
> well-formed but hollow receipt passes the check and is caught only by that human judgement.

## How to write a receipt

**At Phase 1B (claim the session)** — write the stub block below with `status: pending`, filling what
you can, and commit it with your session-claim commit. This committed `pending` block is the crash
breadcrumb: if the session ends before close-out, the next session's Phase 0 reconcile sees it.

**At Phase 3D (close-out)** — overwrite that block in place to `status: complete` and fill every
field. The block must satisfy all six Minimum Handoff Requirements (`SESSION_RUNNER.md` §3D).

**Naming the acting model (optional).** No new key — `REQUIRED_KEYS` is unchanged, and the fenced
block below stays exactly as documented. When a one-line summary is useful, especially for a
single-tier session where it saves a reader a cross-reference into `CHANGELOG.md`'s per-action
**Model:** bullet (see that file's format section), name the model in this receipt's free-text
prose area — the Format section below documents that area as *"the durable proxy for the Phase 3G
spoken report."* This formalizes what a capability-tiered session already does organically when it
states which tier built which layer and which tier reviewed it; this fork's own first receipt
(root `HANDOFFS.md`, session S1) is the worked precedent. `CHANGELOG.md`'s **Model:** bullet
remains the structured, per-action record; this is a convenience pointer for the session-level
view, not a second schema — and it is fine for both to name the same model on a single-tier
session, since they answer different questions ("what happened, action by action" vs. "which model
ran this session"). A canonical-only `bin/model-report` (copy it into your `bin/` if you want it,
same as `bin/check-handoff`) reads this free-text convention back alongside `CHANGELOG.md`'s
**Model:** bullets and git's `Co-Authored-By` trailers, keeping all three visually separate.

## Format — a fenced `handoff` block

````
```handoff
session: S<N>
date: YYYY-MM-DD
status: <pending | complete>
self_score: <1-10>
predecessor_score: <1-10>
active_task: <current state>
what_was_done: <what you did, including a commit sha — or the literal `pending`>
next_steps: <specific and actionable; never "pick next from backlog">
key_files: <each entry carries a path:line token, e.g. SessionManager.java:245>
gotchas: <traps the next session should watch for>
runtime_smoke: <a run result, or "n/a — docs-only", or "impossible: <reason>"; where .quality-gates.json declares gates, the `quality_ratchet: N/M pass · …` summary line of this session's --run>
changelog_ref: <PR #N, a short-sha, or CHANGELOG.md "<its ### heading>" — never a bare line number, which decays once the ledger is trimmed>
commit: <short-sha — or the literal `pending`>
```
<free-text prose: the durable proxy for the Phase 3G spoken report, plus the +/- self-score breakdown>

Write clean `key: value` lines — no inline `#` comments (a `#` is a literal value character,
as in `changelog_ref: PR #52`). The keys are the six Phase 3D Minimum Handoff Requirements (the sixth
*is* `self_score`) plus `predecessor_score` (the Phase 3A evaluation) and a little metadata. `status`
is `pending` at the Phase 1B claim and `complete` at
close-out; a third value, `reconciled`, is written *only* by a later session's Phase 0 reconcile
when it reconstructs a receipt a crashed session never completed — you never write it yourself.
````

`self_score` and `predecessor_score` are distinct keys so one can never stand in for the other; omit
`predecessor_score` on Session 1 (there is no predecessor to score). `commit: pending` and
`what_was_done: pending` are legal at write time (the receipt ships in the very commit whose sha it
would name); no future session is assigned to fill either in later, so `pending` is a legitimate
resting value for both, not a promise a later session owes.

**A receipt's identity is `session` + `date`, not `session` alone.** `S<N>` is a per-sequence
counter, and one ledger may legitimately merge more than one sequence — a fork and its upstream each
running their own, so two distinct sessions share an `S<N>` by construction. Keep `S<N>` unique
within a sequence if you can (never renumber an already-written receipt to do it — a visible gap
that closes on merge is the lesser defect), but do not treat a repeated id across sequences as
corruption. `bin/check-handoff --all` keys on the pair for this reason.

**Concurrent sequences in one repository** get a tag. Each repository's `main` uses bare `S<N>`; a session
claimed on any other branch of the same repository writes `S<N>-<seq>` (`S24-ratchet`, the branch's short name
or the agent's), so two sessions live at once never share a name. Each line's newest pending receipt is that line's live claim, even when another line's receipts sit above it; a pending receipt superseded within its own line is a session that never closed out. When their branches merge, `HANDOFFS.md`
conflicts — it is deliberately left out of the `.gitattributes` union driver, which would fuse two prepended
receipts into one block — and the merge is resolved keep-both, ours on top, from the three index stages:

```sh
git show :1:HANDOFFS.md > base; git show :2:HANDOFFS.md > ours; git show :3:HANDOFFS.md > theirs
git merge-file -p --union --diff3 ours base theirs > HANDOFFS.md   # --diff3 keeps each receipt whole
```

Then check every receipt before committing the merge (the canonical `bin/check-handoff --all` refuses a key
repeated in one block). **A merge is one action with one receipt:** the merging session writes one receipt
naming the merged range and its sequence tag, scores the merged sequence's last receipt in one line of its own,
and owes no `status: reconciled` receipt per merged commit. The method behind all of this:
`ITERATIVE_METHODOLOGY.md` §Parallel Actors.

## Size, and when to archive

handoffs-format: 2 — keep this marker, and bring it across with this section; `bin/status` reads it.

This file gains a receipt every session and nothing removes one, so it grows without bound. The
protocol never asks a session to read it whole: Phase 0 reconciles it against `git log` and checks
the newest receipt, and a session reads that receipt at the top — past the harness's default-read
refusal, with an offset and a limit. Archive it when the trimmer's trigger fires. The tool states the
trigger, and this file names no size of its own.

**Run this rather than estimating it:**

```sh
python3 methodology_trim.py --file HANDOFFS.md --check
```

`--check` evaluates the trigger and never writes. `--write` performs the trim, refuses unless it
can prove the split lossless, and **neither commits nor stages** — it leaves this file modified and
the new shard *untracked*, and leaves the commit to you (`git add HANDOFFS.md docs/archive/`).

An archive is a **shard**: a new frozen file, same format, same newest-on-top order.

- **Path: `docs/archive/HANDOFFS-through-<CUT-KEY>.md`.** Both halves are load-bearing — the
  directory keeps the shard from shadowing this file, and the `HANDOFFS-` prefix is what the
  trigger's own glob looks for. A shard named otherwise is silently invisible to it.
- **This file keeps one short pointer** naming each shard, the span it covers and how many receipts
  it holds — with the command that recomputes those counts, never a hand-maintained number.
- **The shard back-links here and states only facts about itself.** It must not restate a
  forward-looking rule: a shard is frozen, so a rule copied into one cannot be corrected when the
  live rule moves.
- **After a split, anything that enumerates receipts must span both** — `HANDOFFS.md
  $(git ls-files 'docs/archive/HANDOFFS-*.md')` — or it silently counts a shrunken
  population. Enumerate the shards with `git ls-files`, never as a bare glob: zsh aborts a
  command whose glob matches nothing, so before the first split the bare form counts nothing
  at all — the same reason the ledger's audit is written that way.

The reasoning this file shares with `CHANGELOG.md` — how a ledger is read, why the tool is the only
statement of its trigger, and what a split must conserve — is in the *Reading and archiving*
subsection of `FRAMEWORK_APPARATUS.md` §The Action Ledger.
That subsection makes archiving optional for `CHANGELOG.md`; this file keeps its own rule, above —
archive it when the trimmer's trigger fires. Everything needed to *act* is here.

What is specific to *this* file, and gets receipts wrong if assumed:

- **A record is a `handoff` block *plus the prose beneath it*, not the fence alone.** The self-score
  and predecessor-score paragraphs sit outside the fence and belong to the receipt above them. A
  fence-only cut severs every receipt from its own scoring.
- **Archive oldest-first by position, never by sorting on `session:`.** Two independent `S<N>`
  sequences can share one ledger — a fork and its upstream each running their own counter — and
  their numbers collide. The record's identity is **session + date**.
- **A trim leaves the newest-receipt check alone and moves what the older-receipt checks see.**
  Phase 0 reconcile is frontier-based and a structural checker applies the full schema to the newest
  receipt only, so neither is disturbed. Its other passes are not so confined — `--all` reads every
  receipt, and a rule a project adds over its older receipts reads them too. So after a trim,
  **run the checker against each shard as well**, and recompute any "all N older receipts" count from
  the files rather than carrying it forward.
- **Never trim to zero receipts.** An empty receipt ledger is indistinguishable from a broken one.
- **A shard freezes, and nothing in it is rewritten** — not even a `commit:` slot. A `pending` there
  stays `pending`: it is a legitimate resting value (above), and no later session is assigned to fill
  it in.

## Three files, three questions, one shared key

- **`SESSION_NOTES.md`** — the *transient scratchpad*: rich working notes, overwritten every session.
- **`HANDOFFS.md`** (this file) — the *durable receipt*: the distilled, machine-checkable proof that
  the handoff was written. Nothing is ever deleted; when the file is archived, the oldest receipts
  move to a frozen shard (see **Size, and when to archive** above).
- **`CHANGELOG.md`** — the *cumulative action ledger*: *"what was done here, ever?"*, append-only.

The shared key across all three is the commit sha (`changelog_ref` / `commit` here). This file
**distills** the handoff; it does not copy the scratchpad. The belongs-here test: *would the next
session need this block to continue the work without re-reading the whole repo?*

## Citing the gate run — honesty made countable

Where the project declares quality gates (`.quality-gates.json` with at least one gate), a
`status: complete` receipt cites the session's own gate run: paste the summary line
`quality_ratchet.py --run` prints (`quality_ratchet: N/M pass · F fail · U unmeasured · results
<sha12> · manifest <sha12>`) into `runtime_smoke` (or `what_was_done`). A run that reads `U unmeasured`
with `U` above 0 is not a clean one: repair the gate (its command, or `timeout_seconds` if it is only
slow) and run again, or name each unmeasured gate in the same field as `unmeasured: <gate>, <gate> — by
hand: <result>`, at least `U` names. The canonical-only
`bin/check-handoff` lints the **newest** receipt for that token and clause when a manifest with gates is present;
the next session's Phase 0 reconcile compares the cited `results` hash and counts against the current
`.quality-gates-results.json` (or re-runs `--run`) and treats a contradiction — a receipt claiming
`6/6 pass` over results that say otherwise — as the same class of finding as an unrecorded commit.
Ceiling, stated as v3.3 stated it: the lint checks the citation's **structure**, the reconcile checks
its **counts**; neither reaches the truth of anything no gate expresses. Receipts written before the
manifest existed are not re-judged.

---

<!-- Receipts go below, newest on top. Delete the seed-sentinel line above when you add the first one. -->

```handoff
session: S10
date: 2026-11-11
status: pending
active_task: plan Phase 8, second of two sessions (R30): R/comparePedigreeStructure.R copied test-first from nprcgenekeepr baef1e12c, the layout's cases in the fidelity tool, push, CI, Phase 8 DONE; IN PROGRESS
what_was_done: pending
commit: pending
```

```handoff
session: S9
date: 2026-11-11
status: complete
self_score: 7
predecessor_score: 8
active_task: plan Phase 8's first session is DONE (R30: all the layout code, makePedigreeMatingLayout(), makePedigreeDiagramData(), 48 internal functions and 4 constants, and 295 tests); next is Phase 8's second session (R30: comparePedigreeStructure.R test-first, the fidelity tool's layout cases, push, CI, Phase 8 DONE), READY
what_was_done: claim 85a6264; RED d0a41ab datasets examplePedigree, pedWithGenotype, rhesusPedigree; 1403f85 three rhesus csv files byte for byte; 0ddff68 tools/makeComputedTestFixtures.R saving what nprcgenekeepr's code builds (QC'd rhesus pedigree, shrinkPedigree() Track B) and two helpers; 8b38610, 8268e06, 327270e, 7b35b82 13 test files with asserted edits (R31 leaves out 3 Chrome and 2 saved-results tests); RED state 270 failures, 2 early passes (a fixture check, quadprog installed), WARN 0; GREEN ad6dc98 Imports quadprog and utils plus positionTreeApportion.R, orderRootSubtrees.R, penaltyCrossprod.R; d120883 makePedigreeDiagramData.R whole and affectedConditions.R lines 1-75 (R32), examples type their own pedigree, NAMESPACE and man; 1f356cd fixture fix (two Track B calls, not one); ae4bd90 seven tests changed (5 edition 3, R29; 2 warnings handled as the file does, R33; Mark's pick); 1e91c1a DIVERGENCE.md's first three rows (R32's deferred functions); REFACTOR 162dcc3 tools/renvFreeEnv.R shared by two tools; close-out 6e02298 (plan R30-R33, rows 8-9, record; contract; ROADMAP; BACKLOG; CLAUDE.md Learnings 10, 12, 13) and close-out 2 (notes, this receipt, ledger, gate tests-no-saved-expect-condition). Not pushed
next_steps: Phase 8's second session (methodology/SESSION_NOTES.md ACTIVE TASK; methodology/BACKLOG.md:11; plan :125 R30, :372 row 8, :405 S9's record): check nprcgenekeepr's copied files and the comparison file still match baef1e12c; pre-RED picker (fidelity sizes); copy test_comparePedigreeStructure.R and its helper (16 nprcgenekeepr::: calls, 2 rhesus reads), run nprcgenekeepr's own file (Learning 12), then R/comparePedigreeStructure.R; layout cases in runCases() bounded hard (375 animals 1-2 s, 3,694 animals 180 s), each reaching its branch (65 unreached lines in BACKLOG.md:11); push once, read CI; Phase 8 DONE close-out
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK), methodology/BACKLOG.md:11 (the item), docs/planning/standalone-pedigree-package-plan.md:125-128 (R30-R33), :372 (row 8), :405 (S9's record), R/makePedigreeDiagramData.R:58, :1524, :1670, tests/testthat/test_makePedigreeMatingLayout.R:3-14, tests/testthat/helper-shrinkPedigreeStandIn.R, tools/makeComputedTestFixtures.R, tools/renvFreeEnv.R, tools/compareResultsWithNprcgenekeepr.R:26 and :128, DIVERGENCE.md, CLAUDE.md:165-168
gotchas: CI has never run the layout (nothing pushed since 16a8799) and some copied tests depend on the math library (R's own BLAS vs CI Ubuntu's OpenBLAS); edition 3 hides a saved expect_message() value behind RED's missing-function errors (gate tests-no-saved-expect-condition); R33 for warnings nprcgenekeepr has too; the layout takes 180 s on 3,694 animals, so the fidelity cases need hard size bounds; nprcgenekeepr's S1155 commits while you work; zsh `===` and Rscript -e backslashes
runtime_smoke: tests 428 FAIL 0 WARN 0 SKIP 0 (295 new; each checks as many expectations as nprcgenekeepr's own run of its 13 files at baef1e12c); lint 0 (package, 5 tools); roxygen unchanged, the two .Rd equal nprcgenekeepr's but for examples; R CMD check --as-cran Status 1 NOTE, the allowed one, examples OK (7 nodes, 8 edges; the layout's union nodes), tests 66 s; coverage 96.67%, new code 96.12%; drift tool exit 0 (77, 3 recorded); results tool 360 of 360, kinship 0, no layout cases yet; no drawing to look at until Phase 9's renderer; quality_ratchet: 4/4 pass · 0 fail · 0 unmeasured · results 08889eff3b69 · manifest ce7204f4cde2
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S9: plan Phase 8's first session, the layout engine's code and tests copied test-first"
commit: 6e02298
```

```handoff
session: S8
date: 2026-11-11
status: complete
self_score: 7
predecessor_score: 8
active_task: plan Phase 7 is DONE (kinship(), checkTwinRelations(), mzTwinGroups(), mzTwinIdsAbsentMessage); next is Phase 8, the layout engine (makePedigreeMatingLayout(), makePedigreeDiagramData(); the plan estimates 2 sessions), READY
what_was_done: claim cfea7c1; RED fddfa73 fixture pedOne, 2b687f7 Suggests kinship2 and withr (renv: five cached dependencies came back latest, reinstalled by name), 0e13f79 and aa38423 34 tests in 4 files copied from nprcgenekeepr baef1e12c (R26; one changed for testthat edition 3, R29) plus helper-outcome.R; GREEN 9050dd9 Imports Matrix methods stats, 74ac842 mzTwinGroups.R, 7c45113 checkTwinRelations(), 75b55c8 kinship() with @importClassesFrom Matrix ddiMatrix dgCMatrix (R27), code unchanged and help rewritten, 5596306 and 33067bf runCases() Phase 7 cases (30 in all) and kinship's largest difference; REFACTOR 16a8799 fidelity tool header, lookup for S7's nested ifelse, size range; pushed once (14 commits, c71b74a..16a8799), CI run 43106941979 5/5 Status OK first attempt; close-out fb9b9ae plan (status, R26-R29, 7 row, Done 7), contract section 5, ROADMAP.md, BACKLOG.md, CLAUDE.md (Learnings 3, 9 updated; 10, 11 new); close-out 2 these notes, this receipt, the ledger, gate test-suite-warnings-zero (not pushed). Mark's picks: Start Phase 7, 34 behavior tests, Import the 2 classes, Add kinship2 and withr, Expect both warnings, three TDD gates
next_steps: Phase 8 (methodology/SESSION_NOTES.md ACTIVE TASK; plan :367 the row, :389 Done 7; contract :128-129): check nprcgenekeepr's seven Phase 8 files still match baef1e12c (its S1155 is active); measure the set (Learning 9 survey plus a grep for ::, tests per file); picker on the two-session split; pre-RED picker; RED reading WARN as well as FAIL; GREEN with Imports quadprog (already locked) and runCases() cases bounded in size and checked to reach their branches; DONE as Phase 7, push once, read CI; close-out updates plan, ROADMAP.md, BACKLOG.md
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK, Phase 8), docs/planning/standalone-pedigree-package-plan.md:367 (Phase 8 row), docs/planning/standalone-pedigree-package-plan.md:389 (Done 7), docs/planning/standalone-pedigree-package-plan.md:120 (R26-R29), docs/planning/pedkindraw-api-contract.md:129 (makePedigreeMatingLayout), tools/compareResultsWithNprcgenekeepr.R:128 (cases), tools/compareResultsWithNprcgenekeepr.R:94 (size bound), methodology/BACKLOG.md:11 (Phase 8 item), CLAUDE.md:165 (Learning 10), CLAUDE.md:166 (Learning 11)
gotchas: nprcgenekeepr runs testthat edition 2 and pedkindraw 3 (R29, Learning 10): a copied expect_warning() around a call that warns twice leaks a WARN here, and a test run from the scratchpad falls back to edition 2 and hides it; the Phase 1 pedigrees reach 100,000 animals, so layout cases need a size bound like kinship's (tool :94-103), and the results file is about 60 MB per package; codetools misses pkg::fn calls (Learning 9); renv rebuild = TRUE rebuilds only the named packages (Learning 3); zsh = and glob traps and Rscript -e backslashes (use a script file); commit 33067bf overstates (kinship.R:183 was reached by smallPed's one animal); R/drawPedigreeDiagram.R (Phase 9) already differs from baef1e12c in nprcgenekeepr; 2 close-out commits unpushed
runtime_smoke: tests 133 FAIL 0 WARN 0 SKIP 0 PASS 446 (the kinship2 comparison ran); lint 0; roxygen leaves NAMESPACE and man/ unchanged; R CMD check --as-cran Status 1 NOTE, the allowed one (Maintainer, New submission), dependencies in R code OK, examples OK and kinship()'s prints what its comment says; results tool 360 of 360 identical, 132 kinship matrices largest difference 0, exit 0; drift tool 24 same, exit 0; coverage 98.62% (kinship.R 97.06%); new gate measured 1 on the source form of the test and 0 as committed; CI run 43106941979 5/5 Status OK, PASS 446 each; quality_ratchet: 3/3 pass · 0 fail · 0 unmeasured · results 959da9c9c7a2 · manifest 5e17b07ed47f
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S8 DONE: plan Phase 7, kinship and twins copied test-first from nprcgenekeepr's clean-room code"
commit: fb9b9ae
```
Session 8, Claude Opus 5.5, single tier. Predecessor S7 scored 8: its measured Phase 7 set and the Matrix gotcha made
the survey a check, every cited line was right; it missed testthat's edition difference (no session had looked) and the
pedigrees' size, and said checkTwinRelations() needs nothing outside base (it calls stats::setNames()). Self-score 7:
+ the Matrix question settled from R's check code before asking, the edition difference found by experiment and made a
ruling, a learning and a gate shown to fail, every copied line asserted, the fidelity cases checked for reach and two
variants added, a byte-identical refactor, CI green first try; − two pickers needed clarifying, the named zsh traps and
the Rscript -e backslash trap hit again, a misread grep cost several runs, and a pushed commit message overstates a gap.

```handoff
session: S7
date: 2026-11-11
status: complete
self_score: 8
predecessor_score: 8
active_task: plan Phase 6b is DONE, so plan Phase 6 is complete (6a S3, 6b S7); next is Phase 7, kinship and twins (kinship(), checkTwinRelations(), mzTwinGroups()), READY
what_was_done: claim 38cf048; RED 52c6eb6 fixtures pedSix and qcPed, 0d675f1 and 4ac1889 nine test files copied from nprcgenekeepr baef1e12c (47 tests: the 10 qcStudbook/runQcStudbook/convertDate/removeDuplicates tests left out and listed, R24; sexCodes's value test only, R25); GREEN 5fedd14 Imports data.table, e312c29 59e9778 5cc50f0 f0b4a66 a9257b1 the 11 functions and the constant sexCodes (code unchanged, help text rewritten, addIdRecords not exported), d8ef65e runCases() 22 cases; REFACTOR c71b74a getProbandPedigree inherits ped from trimPedigree again; pushed once (29 commits, to c71b74a), CI run 43052891573 5/5 Status OK on attempt 2 (attempt 1 Ubuntu DNS while installing R; failed jobs re-run); close-out 3da6981 plan (status, R24-R25, 6b row, Done 6b), ROADMAP.md, BACKLOG.md, CLAUDE.md Learning 9; close-out 2 these notes, this receipt, the ledger (not pushed). Mark's picks: Start Phase 6b, Leave out and list, File plus its value test, three TDD gates
next_steps: Phase 7 (methodology/SESSION_NOTES.md ACTIVE TASK; plan :361 the row, :384 C2; contract :140 kinship(), :127 checkTwinRelations()): Learning 9 survey of R/kinship.R, R/mzTwinGroups.R, R/checkTwinRelations.R at baef1e12c (S7 found kinship() reads sexCodes and mzTwinIdsAbsentMessage); count which of the 8 test_kinship*.R files test only Phase 6-7 functions; pre-RED picker; RED, GREEN with the imports settled (methods; Matrix reached only via asNamespace), runCases() cases incl. the constant; DONE as 6b, push once, read CI; close-out updates plan, ROADMAP.md, BACKLOG.md
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK, Phase 7), docs/planning/standalone-pedigree-package-plan.md:361 (Phase 7 row), docs/planning/standalone-pedigree-package-plan.md:374 (Done 6b), docs/planning/standalone-pedigree-package-plan.md:117 (R24-R25), docs/planning/pedkindraw-api-contract.md:140 (kinship), docs/planning/pedkindraw-api-contract.md:206 (section 5 Phase 7), tools/compareResultsWithNprcgenekeepr.R:57 (cases), tools/compareWithNprcgenekeepr.R:46 (functions only), methodology/BACKLOG.md:11 (Phase 7 item), CLAUDE.md:163 (Learning 9)
gotchas: kinship() calls methods:: and reaches Matrix only by asNamespace("Matrix"), so Imports: Matrix alone will likely draw the NOTE "Namespace in Imports field not imported from" (a prediction; R16 allows no such NOTE); the drift tool does not compare constants (BACKLOG :48), so mzTwinIdsAbsentMessage needs a runCases() case; the Phase 1 pedigrees reach few repair branches, so check each new case reaches its branch; CI Ubuntu 26.04 runners failed DNS on attempt 1 in S7 and passed on re-run; zsh aborts on an unmatched glob (hit again in S7) and reads a leading = as a command path; lint needs the package loaded; renv installs with the dated repository and rebuild = TRUE; 2 close-out commits unpushed
runtime_smoke: tests 99 FAIL 0 WARN 0 SKIP 0 PASS 347; lint 0; roxygen leaves NAMESPACE and man/ unchanged; R CMD check --as-cran Status 1 NOTE, the allowed one (Maintainer, New submission), examples OK and each new example prints what its comment says; results tool 264 of 264 identical, exit 0; drift tool 21 same, exit 0; coverage 99.05%; CI run 43052891573 5/5 Status OK, PASS 347 each; quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S7 DONE: plan Phase 6b, the 11 functions that repair and trim pedigrees and the constant sexCodes copied test-first"
commit: 3da6981
```
Session 7, Claude Opus 5.5, single tier. Predecessor S6 scored 8: every cited line right and the 10 tests' exact
ranges, which made the picker and the copy script direct; it carried S3's function-only survey (no `sexCodes`) and
named `pedOne` as a fixture the tests do not use. Self-score 8: + the plan's gap and the handoff's error found from the
source before RED and put to Mark plainly, every edit asserted by text, three near-empty fidelity cases caught by
reading the results, the CI failure diagnosed as the runner's without touching code; − the zsh empty-glob trap
(flagged) still cost a check run, "31 commits" said before counting (29), one throwaway script failed on an escape.

```handoff
session: S6
date: 2026-11-11
status: complete
self_score: 8
predecessor_score: 9
active_task: step H2 of the hand-over plan is DONE, so the planning move is complete (S4-S6): the plan and contract here are current, with Mark's S2-S4 picks as rulings R16-R23, methodology/ROADMAP.md filled and open work in methodology/BACKLOG.md; next is Phase 6b, the 11 functions that repair and trim pedigrees
what_was_done: claim ccd6e6c; abb8548 the plan (status block; section 1.3; R16-R23, each with session and source, confirmed by Mark's picker "Add all eight"; Phase 5 and 6a Done records; Phase 6 rows 6a/6b; C2 written into Phases 7, 8 and 10; section 5's drift tool reads the clone; provenance note 17 lines); 86b4126 the contract (section 5 imports and mockery; section 9 rows 5, 7, 8, 10; section 10 item 2 closed by C2; beyond H2's list, C13's fatherId/motherId in sections 4 and 4.2 and the clean-room differences C11/C15/C16, one line in section 3); 96f9e4b ROADMAP.md filled, BACKLOG.md created (9 items), the pre-repository pointer entry; 9dc150f hand-over plan H2 DONE, CLAUDE.md Learning 8, a backlog item for the dashboard; close-out 2 notes, receipt, ledger. Nothing pushed
next_steps: Phase 6b (methodology/SESSION_NOTES.md ACTIVE TASK; plan :357 the 6b row, :344 the slice DONE line; contract :132 addIdRecords not exported): copy at nprcgenekeepr baef1e12c (S6 checked none of 6b's files changed up to 3d262d628); pre-RED picker on the 10 nprcgenekeepr-only tests; fixtures pedOne, pedSix, qcPed; 8 test files RED; 11 R files GREEN with Imports data.table (rebuild = TRUE, snapshot(dev = TRUE), gate); add the 11 to runCases(); DONE as 6a, push once, read CI; close-out updates the plan, ROADMAP.md and BACKLOG.md
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK, 6b), docs/planning/standalone-pedigree-package-plan.md:344 (copy slices), docs/planning/standalone-pedigree-package-plan.md:357 (6b row), docs/planning/standalone-pedigree-package-plan.md:108 (R16-R23), docs/planning/pedkindraw-api-contract.md:132 (addIdRecords), docs/planning/pedkindraw-api-contract.md:201 (section 5), methodology/BACKLOG.md:11 (6b item), methodology/ROADMAP.md:16 (slice table), tools/compareResultsWithNprcgenekeepr.R:44 (cases), tests/testthat/helper-fixtures.R:5 (fixtures), CLAUDE.md:162 (Learning 8)
gotchas: 17 commits unpushed (6b's push carries them; nprcgenekeepr 3d262d628 unpushed, Mark's); the dashboard shows Backlog ✗ because the synced tool looks only at the root and docs/, not methodology/ (backlog item, Mark's call); ledger counts can be loose (S3's "10 test files" was 9 and a helper; Learning 8); renv cache trap for data.table (Learning 3); lint needs the package loaded (Learning 4); paths in the copied plan and contract are nprcgenekeepr's unless the text says pedkindraw's; zsh aborts on an unmatched glob and reads a leading = as a command path
runtime_smoke: n/a, documents only (no R, test or tool file changed; drift and results tools not rerun); R CMD check --as-cran Status 1 NOTE, the allowed one (Maintainer, New submission); tests FAIL 0 WARN 0 SKIP 0 PASS 122; tarball 0 docs/ or methodology/ entries; docs/research unchanged since H1; dashboard runs, 82/100; quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S6 DONE: plan step H2, the copied plan and contract brought up to date, the roadmap filled and the backlog opened"
commit: 9dc150f
```
Session 6, Claude Opus 5.5, single tier. Predecessor S5 scored 9: every H2 edit site cited with line and words, all
right at S6's start, and the warning that the status-block rewrite falsifies the note; it named the ledger and
receipts as sources where R22's attribution is only in S3's committed notes, and (carried from S4's plan) missed C13
and S1127. Self-score 8: + exact-anchor edits, every DONE criterion shown, two pickers first try, four carried facts
re-checked (Learning 8); − three slips caught before commit (note-length formula, R18's wording, bare paths against
the note's rule) and one 123-column backlog line committed, then rewrapped; contract edits beyond H2's list (named
in the commit).

```handoff
session: S5
date: 2026-11-11
status: complete
self_score: 9
predecessor_score: 9
active_task: step H1 of the hand-over plan is DONE (the five planning documents copied from nprcgenekeepr 3d262d628 and this repository pointed at them); next is step H2, bringing the copied plan and contract up to date and opening methodology/ROADMAP.md and methodology/BACKLOG.md, then Phase 6b
what_was_done: claim b8b72f7; f2249d0 plan and contract, ec910a6 three studies (byte for byte, cmp silent); 38633f1 a provenance note under each title (16, 14, 13, 13, 13 lines; diff against the source shows added lines only); 3e192e9 CLAUDE.md governing documents and plan-constraints line, DIVERGENCE.md:4 and the two tools' header comments point at docs/planning/; close-out marks H1 DONE in the hand-over plan, corrects three H2 citations there (C2 :88 -> the copy's :108; CLAUDE.md :115 -> :117, :138 -> :140), adds CLAUDE.md Learning 7. Mark's pick: H1 only. Nothing pushed
next_steps: H2 (one session; hand-over plan :212-268): picker first confirming rulings R16 on (:221-228); commit 1 the plan (status block :19-29, the note's status-block sentence :6-9 and its stated count :17, section 1.3 :64, rulings after R15 :104, Phase 5 :309, Phase 6-10 rows :338-342, section 5 :378); commit 2 the contract (section 5 :192, section 9 :248-250, section 10 item 2 :262); commit 3 ROADMAP.md, new BACKLOG.md (:243-249), pointer entry (:250-252); DONE :254-263, no push. Then Phase 6b (methodology/SESSION_NOTES.md, THEN block)
key_files: docs/planning/planning-handover-plan.md:212 (H2), docs/planning/standalone-pedigree-package-plan.md:3 (provenance note), docs/planning/standalone-pedigree-package-plan.md:19 (status block), docs/planning/pedkindraw-api-contract.md:3 (note), docs/planning/pedkindraw-api-contract.md:258 (open items), methodology/ROADMAP.md:1 (the seed), CLAUDE.md:21 (governing documents), CLAUDE.md:138 (what sessions here keep up to date), CLAUDE.md:161 (Learning 7), methodology/SESSION_NOTES.md:11 (ACTIVE TASK, H2)
gotchas: line numbers move with every edit, H2's own included (Learning 7), so find each cited line by its quoted words; line numbers inside the copied text are nprcgenekeepr's (plan +16 here, contract +14, studies +13); rewriting the plan's status block makes its provenance note's sentence at :6-9 false and may change the note's stated length at :17; the studies must stay unchanged (H2 DONE reads git log -- docs/research); zsh aborts on an unmatched glob and reads a bare word starting with = as a command path; 11 commits unpushed (Phase 6b's push carries them) and nprcgenekeepr 3d262d628 unpushed (Mark's); pedkindraw.Rproj and the context-budget path fix wait on Mark
runtime_smoke: n/a, documents and comments only; the two tools still run: drift exit 0 (10 same, 0 differ), results exit 0 (120 of 120 identical); testthat FAIL 0 PASS 122; R CMD check --as-cran Status 1 NOTE, the allowed one; tarball 0 /docs/ entries; quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S5 DONE: plan step H1, the five planning documents copied from nprcgenekeepr and this repository pointed at them"
commit: 3e192e9
```
Session 5, Claude Opus 5.5, single tier. Predecessor S4 scored 9: exact commands with the source commit and dry-run
results, exact commit-4 lines, the path and line-shift gotchas that shaped the note; it missed `CLAUDE.md:21` and the
copied status block's "not updated here again", and its H2 step cited C2 at a pre-H0b line. Self-score 9: + every
DONE criterion checked with output, byte-level note insert, three stale H2 citations fixed and Learning 7; − the note
script wrote four files before the fifth failed its width check (restored, rerun), one zsh `=` slip.

```handoff
session: S4
date: 2026-11-10
status: complete
self_score: 8
predecessor_score: 9
active_task: the plan to move pedkindraw's planning from nprcgenekeepr into this repository is written and its step H0 DONE (the hand-over note in nprcgenekeepr); next is step H1, copying the five documents and re-pointing CLAUDE.md, DIVERGENCE.md and the tools, then H2, then Phase 6b
what_was_done: claim a262439; H0a 0283214 (docs/planning/planning-handover-plan.md: Mark's direction, the decision table, an inventory by search and by citation, steps H0-H2 each with DONE, surface and session boundary, risks, alternatives; ^docs$ in .Rbuildignore); H0b in nprcgenekeepr 3d262d628 (plan status block records Phase 5 and 6a DONE and freezes that copy; BACKLOG.md item shrunk to the RECURRING drift watch; its CHANGELOG entry, 760 B); close-out records both hashes in the plan and adds CLAUDE.md Learning 6. Mark's picks: Plan, then note; methodology/BACKLOG.md; five documents. Nothing pushed
next_steps: H1 (one session; plan section 4): check the five nprcgenekeepr files unchanged since 3d262d628; commit 1 plan and contract and commit 2 the three studies, each via git show 3d262d628:<path> and checked with cmp; commit 3 a provenance note under each title (diff shows only added lines); commit 4 CLAUDE.md:22-23 and :136, DIVERGENCE.md:4, the two tool header comments; DONE: both tools exit 0, test suite, R CMD check --as-cran 0/0/allowed NOTE, no docs/ in the tarball; no push. Then H2 (rulings R16 on confirmed by picker first; plan, contract, ROADMAP.md, new BACKLOG.md, pre-history pointer entry), then Phase 6b (methodology/SESSION_NOTES.md, THEN block)
key_files: docs/planning/planning-handover-plan.md:55 (decision and path rule), docs/planning/planning-handover-plan.md:97 (the five files), docs/planning/planning-handover-plan.md:128 (pedkindraw lines to change), docs/planning/planning-handover-plan.md:179 (H1), docs/planning/planning-handover-plan.md:210 (H2), methodology/SESSION_NOTES.md:11 (ACTIVE TASK, H1), methodology/SESSION_NOTES.md:55 (H2 and 6b), CLAUDE.md:22 (governing documents to re-point), CLAUDE.md:136 (now false; H1 rewrites it), .Rbuildignore:23 (^docs$), /Users/rmsharp/Development/nprcgenekeepr/BACKLOG.md:40 (the shrunk item)
gotchas: paths inside the copies are nprcgenekeepr's except the five copied files, so the provenance note must say so and the paths are not rewritten; the copies' line numbers shift by the note's length while older citations stay right because they name nprcgenekeepr's frozen files; zsh aborts a whole command on an unmatched glob; the nprcgenekeepr commit is not pushed (Mark's call) and moved its later BACKLOG items up 13 lines (#138 now :70, S1153's receipt says :83); S3's close-out and all S4 commits are unpushed (6b's push carries them); pedkindraw.Rproj and the context-budget fix still wait on Mark (H2 lists them in BACKLOG.md)
runtime_smoke: n/a, documents only. R CMD build leaves docs/ out (file list identical to S3's checked tarball); H1's copy and cmp commands dry-run in the scratchpad, all five byte-identical at 3d262d628; nprcgenekeepr readers 5 files, 37 blocks, 0 failed; quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452
changelog_ref: CHANGELOG.md "2026-11-11 · [ad hoc] S4 DONE: plan to move pedkindraw's planning from nprcgenekeepr into this repository; step H0 done"
commit: pending
```
Session 4, Claude Opus 5.5, single tier. Predecessor S3 scored 9: Mark's direction verbatim, the right starting files
and the two-writers gotcha; it missed the two older studies (they predate the name), `^docs$`, and nprcgenekeepr's
commit rules. Self-score 8: + inventory by citation as well as name, every pedkindraw line listed with before and
after, H1's commands dry-run; the nprcgenekeepr commit followed its rules. − first picker rested on a premise Mark
settled in a word; four line citations needed fixing before commit; one zsh glob abort.

```handoff
session: S3
date: 2026-11-10
status: complete
self_score: 8
predecessor_score: 8
active_task: Phase 6a DONE (10 relationship functions); next is Phase 6b, the 11 functions that repair and trim pedigrees, in a new session (Mark split Phase 6 in S3)
what_was_done: claim 1274024; RED 1017c25 (lacy1989Ped and smallPed fixtures from nprcgenekeepr baef1e12c, tools/makeTestFixtures.R), 518cba5, 7c22e4b, 430effe (10 test files, 48 tests, mockery in Suggests; all failing on missing functions); GREEN 844542d, 7357272 (10 R files, code unchanged, help text rewritten), 8d76336, 0565f7f (NAMESPACE, 8 help pages), b332309 (tools/compareWithNprcgenekeepr.R, tools/compareResultsWithNprcgenekeepr.R, DIVERGENCE.md); REFACTOR no changes; pushed 32d525c..b332309, CI 42960032938 5/5 Status OK; close-out adds CLAUDE.md Learnings 4-5, Learning 3 widened, the lint command and tool rows, gate lint-package-zero
next_steps: FIRST (Mark's direction after close-out): a planning session that plans copying the information about pedkindraw held in nprcgenekeepr into this repository's methodology ledgers and other files, and updates nprcgenekeepr to say this repository works on from here, following the original plan and updating it as needed (methodology/SESSION_NOTES.md:11); THEN Phase 6b: pick the source commit (nprcgenekeepr is at 0a567d619; check the 6b files unchanged since baef1e12c); pre-RED picker on the 10 tests that exercise qcStudbook, runQcStudbook, convertDate and removeDuplicates (leave out with header notes, recommended); fixtures pedOne, pedSix, qcPed via tools/makeTestFixtures.R; copy 8 test files then 11 R files (addIdRecords not exported); Imports data.table installed with rebuild = TRUE; add the 11 to runCases(); DONE as 6a, push, CI
key_files: methodology/SESSION_NOTES.md:11 (ACTIVE TASK with the 6b set), tools/compareResultsWithNprcgenekeepr.R:44 (cases list to extend), tools/compareResultsWithNprcgenekeepr.R:137 (renvFreeEnv), tools/makeTestFixtures.R:1 (usage), tests/testthat/helper-fixtures.R:5 (fixture loading), R/getProbandPedigree.R:21 (ped written out; may inherit from trimPedigree in 6b), CLAUDE.md:118 (lint command), CLAUDE.md:155 (Learnings 3-5), /Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md:113 (addIdRecords not exported)
gotchas: lint needs the package loaded (Learning 4); renv cache keeps a package's first source, so install new packages with rebuild = TRUE (Learning 3); R run in nprcgenekeepr's folder from here inherits pedkindraw's renv variables (Learning 5); the results tool refuses a clone whose copied files changed; a piped $? is not the tool's exit code; nprcgenekeepr's test_findPedigreeNumber.R first expectation matches no ids (finding for nprcgenekeepr, copied unchanged); CI notices on Node 20 and Ubuntu 26; close-out commit not pushed; pedkindraw.Rproj and the context-budget fix still Mark's
runtime_smoke: R CMD check --as-cran installs the package, runs the 8 examples (expected output) and the tests installed (FAIL 0 PASS 122): 0 errors, 0 warnings, 1 allowed NOTE; CI 5/5 Status OK with PASS 122 each; results tool 120/120 identical on 12 Phase 1 pedigrees; drift tool 0 differ; quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452
changelog_ref: CHANGELOG.md "2026-11-10 · [ad hoc] S3 DONE: Phase 6a, the 10 relationship functions copied test-first (nprcgenekeepr plan Phase 6, first half)"
commit: pending
```
Session 3, Claude Opus 5.5, single tier. Predecessor S2 scored 8: exact pointers, and the toCharacter, .Rbuildignore and
covr notes were all right; its Imports line (data.table, stats, utils) was copied from the contract unchecked (only
data.table is used, and only in 6b); it missed the nprcgenekeepr-bound examples and the mockery and stringi needs.
Self-score 8: + measured the call graph and each test's needs before every picker, all answered first time; every
sameness claim has a check shown to fail (expectation counts, identical fixtures, two negative controls). − the renv
cache trap recurred (the gate caught it); twice read a piped $? as a tool's exit code; the results tool took three tries
to start its child process.

```handoff
session: S2
date: 2026-11-10
status: complete
self_score: 8
predecessor_score: 9
active_task: Phase 5 DONE (5b this session); next is Phase 6, the first copy slice (pedigree basics), in a new session
what_was_done: claim 774c3c4; RED 3c008b4 (4 tests on DESCRIPTION and LICENSE, failing for want of the package); GREEN 652b984 DESCRIPTION 0.0.1, LICENSE 2017-2026, NAMESPACE; a21da76 .Rbuildignore, .gitignore, .lintr; 66b275f renv on Posit 2026-10-31 (25 packages, identical to nprcgenekeepr's lock); 32d525c R-CMD-check workflow and the CLAUDE.md NOTE rule; pushed master once at 32d525c, CI run 42930770118 5/5 Status OK; REFACTOR no changes; 618b8a6 quality gate renv-lock-no-latest-repository and ignore fixes; CLAUDE.md Learnings 2-3
next_steps: Phase 6: record the nprcgenekeepr source commit (R/, tests/, DESCRIPTION unchanged 617420377..e96085bd4); plain-words pre-RED picker on the slice's scope (22 functions, toCharacter in or out per R13); RED copies the slice's tests with source headers and saved fixtures; GREEN copies the code, adds Imports data.table, stats, utils, renv with the dated repo set before install and snapshot(dev = TRUE); add tools/compareWithNprcgenekeepr.R, DIVERGENCE.md and their .Rbuildignore lines; DONE per plan:310-313
key_files: CLAUDE.md:115 (check pass rule with the allowed NOTE), CLAUDE.md:136 (copied-file headers), CLAUDE.md:137 (drift rule), tests/testthat/test_package.R:5 (file-reading helper), /Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md:318 (Phase 6 row), /Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md:88 (copied exports), /Users/rmsharp/Development/nprcgenekeepr/.Rbuildignore:57 (^tools$)
gotchas: 618b8a6 and the close-out are not pushed (Phase 6's push carries them); plan:318 lists toCharacter but contract:38 (R13) excludes it; CI's check-r-package turns off the CRAN incoming check, so read the local Status line; covr errors until R/ exists; roxygen2, lintr, covr are in the renv library but not the lock; snapshot.dev is false, so always snapshot(dev = TRUE); pedkindraw.Rproj is untracked and not S2's (Mark's call); the context-budget path fix awaits its own session
runtime_smoke: R CMD check --as-cran installs and loads the package and runs the tests installed (FAIL 0 PASS 13), 0 errors, 0 warnings, 1 allowed NOTE; CI 5/5 Status OK; quality_ratchet: 1/1 pass · 0 fail · 0 unmeasured · results d088b0dff568 · manifest eac7a277c6cd
changelog_ref: CHANGELOG.md "2026-11-10 · [ad hoc] S2 DONE: Phase 5b, the R package skeleton test-first (nprcgenekeepr plan Phase 5, R15)"
commit: pending
```
Session 2, Claude Opus 5.5, single tier. Predecessor S1 scored 9: exact pointers and labelled predictions,
nothing wrong; it missed the renv "latest" trap, covr on an empty package, and CI's disabled incoming check.
Self-score 8: + every decision and gate by picker; RED failing for the right reason; R's own version rule read
from its source; the renv lock fixed until stable and gated; CI read past the green badge. − the first picker
used shorthand Mark couldn't follow (Learning 2); the first snapshot skipped the dated repository CLAUDE.md asks
for; one ignore line guessed the ratchet's output path.

```handoff
session: S1
date: 2026-11-10
status: complete
self_score: 8
active_task: Phase 5a DONE; next is Phase 5b, the R package skeleton test-first, in a new session (nprcgenekeepr plan Phase 5, R15)
what_was_done: bin/sync --layout new committed as 26bd620 (31 files under methodology/, methodology 34067813); claim 8e48839; CLAUDE.md 4ef233f (template, nprcgenekeepr's TDD contract word for word, R-package Build/Test/Verify, plan constraints); close-out adds Learning 1
next_steps: Phase 5b: picker for LICENSE YEAR and Authors@R; pre-RED scope picker and TDD gates; DESCRIPTION, LICENSE, NAMESPACE, testthat 3e, dated renv, .lintr, .Rbuildignore, .gitignore, R-CMD-check on Linux/macOS/Windows, at most 5 files per commit; R CMD check --as-cran 0/0/0, push master once, gh run list
key_files: CLAUDE.md:40 (TDD contract), CLAUDE.md:86 (phase-gate format), CLAUDE.md:109 (Build/Test/Verify), methodology/SESSION_NOTES.md:11 (ACTIVE TASK for 5b), /Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md:289 (Phase 5)
gotchas: .Rbuildignore must exclude methodology/ and CLAUDE.md; no .gitignore yet, so dashboard and context-budget outputs show untracked; seeded .context-budget.json uses bare paths (UNMEASURED, exit 1); expected New submission NOTE under --as-cran; nprcgenekeepr plan status line not updated
runtime_smoke: n/a — docs-only; methodology_dashboard.py exit 0; context_budget.py CLAUDE.md ok, seed paths unmeasured; .quality-gates.json declares 0 gates
changelog_ref: 4ef233f
commit: pending
```
Session 1, Claude Opus 5.5, single tier. No predecessor (Session 1). Self-score 8: + every governing file
read before proposing, dry run before writing, the contract taken by `sed` and diff-checked identical, the
orient tools run to find what the next session meets (budget paths, `.gitignore`); − the plan's closing choice
was prose, not a picker, and Mark had to ask for one (Learning 1); − the budget-path gap is handed on, not fixed.
