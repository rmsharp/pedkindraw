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
