# CRAN 1.0.0: the cross-platform runs (Phase 17o)

**Companion to** `docs/planning/cran-submission-plan.md` Phase 17o and `cran-comments.md`. Written pedkindraw S101,
2026-11-27, from nprcgenekeepr's `docs/planning/cran-3.0.0-phase8-runbook.md` (its S1104), with pedkindraw's own
uploads (17a and 17k sent tarballs to win-builder by FTP) and ruling R173.

**What these runs are.** Five outside services check the package on machines this Mac and CI do not cover. Each one
receives the tarball or reads the repository on GitHub; nothing here submits to CRAN. **Do not submit from this
runbook: that is Phase 17p, and it is Mark's.**

**Who runs them (D9, R173):** Claude, with Mark's approval in the session (his pick, "Claude starts them now").
**Already run, 2026-11-27 (S101 started them, S102 read them):** win-builder's three checks, 1 NOTE each (the
new-submission one), and R-hub run 46055056615, `Status: OK` on its three platforms; the results are in
`cran-comments.md` and the record below. The macOS builder answered 502 to all three uploads (19:12:25 and 19:58:51
UTC, S101; 20:07:45 UTC, S102), so its line was dropped (Mark, R174). Run them again only if a shipped path changes
(step 1), which needs a new tarball too; then each section below is the recipe.

**How long.** win-builder usually answers within an hour of a check starting, but its R-devel queue held a pedkindraw
upload 3 h 47 min before the check began (S90-S92, dragon 34); its result folder is removed about 72 hours after the
check. R-hub took about 33 minutes for nprcgenekeepr (its July run) and 45 minutes for pedkindraw (S101: its Intel macOS
job built 116 packages from source; Linux and Windows took about 4 minutes each). The macOS builder's results appear at its link,
in about 5-10 minutes by nprcgenekeepr's runbook; pedkindraw has not used it before.

Run everything from the repository root.

---

## 1. Confirm that the package files are the checked ones

```sh
git status --short
git diff --stat 2456253 HEAD -- DESCRIPTION LICENSE NAMESPACE NEWS.md R README.md .aspell inst man tests vignettes
git diff --stat 2456253 origin/master -- DESCRIPTION LICENSE NAMESPACE NEWS.md R README.md .aspell inst man tests vignettes
```

The two `git diff` lines print nothing, and `git status --short` prints only `?? pedkindraw.Rproj`. Those 11 paths are
the tarball's top-level entries but `build` (which `R CMD build` makes): 276 tracked files, unchanged since `2456253`
(S101, at HEAD and on GitHub). `2456253` holds the package files Phase 17n checked. If either diff prints anything,
stop: a change there reopens 17n (its checks again, about 1.5 hours) and needs a new tarball.

## 2. The tarball

`pedkindraw_1.0.0.tar.gz` at the repository root (`.gitignore` and `.Rbuildignore` both leave it out), 1,719,147 bytes:

```sh
shasum -a 256 pedkindraw_1.0.0.tar.gz
# abb78758614010fda65b628e1255982b8d51893a5074cae41c62af7d22dcfe3c
```

It is the tarball Phase 17n built and checked (S100: `R CMD check --as-cran`, 1 NOTE, R16's), copied here unchanged.
Upload this one file everywhere below, and submit it in 17p. If it is lost, build another with 17n's recipe (a `git
archive` of HEAD into a scratch folder, then `R CMD build` with renv's library, `CLAUDE.md` Build / Test / Verify):
its SHA-256 will differ, because the build stamps the time, and the record below then names the new one.

## 3. win-builder: three uploads

First see what is waiting (the server's clock is UTC+1):

```sh
curl -sS ftp://win-builder.r-project.org/R-devel/
```

Then upload:

```sh
curl -sS -T pedkindraw_1.0.0.tar.gz ftp://win-builder.r-project.org/R-devel/
curl -sS -T pedkindraw_1.0.0.tar.gz ftp://win-builder.r-project.org/R-release/
curl -sS -T pedkindraw_1.0.0.tar.gz ftp://win-builder.r-project.org/R-oldrelease/
```

Each result comes by email to the maintainer address in `DESCRIPTION`, with a link to its folder. **An upload gives
no receipt:** do not upload again because no email has come. A file still listed in the folder above has not
started; it leaves the list when its batch starts.

## 4. The macOS builder

```sh
curl -sS -H 'Accept: application/json' -F pkgfile=@pedkindraw_1.0.0.tar.gz -F rflavor=r-devel \
  https://mac.r-project.org/macbuilder/v1/submit
```

The form at <https://mac.r-project.org/macbuilder/submit.html> offers only R-devel (S101: its "release" option is
commented out) and sends no email. Keep the reply: it holds the link to the results. If it answers an error status
(nprcgenekeepr's S1105 met 502 all day), try again later; if it stays down, the fold-in session asks Mark whether to
drop its line, as nprcgenekeepr did.

## 5. R-hub: three platforms

R-hub runs in this repository's GitHub Actions, from `.github/workflows/rhub.yaml` (S101, R173: R-hub's file with
renv turned off) on GitHub's `master`, so step 1's second diff is what it checks. Start it with `gh`, logged in as the
repository's owner:

```sh
gh workflow run rhub.yaml --ref master -f config=linux,windows,macos -f id=pedkindraw-1.0.0
gh run list --workflow rhub.yaml --limit 1
```

`rhub::rhub_check(platforms = c("linux", "windows", "macos"))` does the same from R (with `rhub` installed outside
the project library, as nprcgenekeepr's runbook does it). The three platforms are R-devel on GitHub's Ubuntu, Windows
and Intel macOS runners (R-hub's `platforms.json`). Results are in the Actions tab.

## 6. What to expect, and what to do

| Check | Expected |
|---|---|
| win-builder R-devel | 0 errors, 0 warnings, 1 NOTE (Maintainer; "New submission"); "Check time in seconds" 540 or less (R85; 17k's reading was 321 s) |
| win-builder R-release and R-oldrelease | 0 errors, 0 warnings, the same NOTE |
| macOS builder | 0 errors, 0 warnings; not used before, so read any NOTE (S102: down all three tries, its line dropped, R174) |
| R-hub linux, windows, macos | `Status: OK` (its check step is r-lib's `check-r-package`, as CI's is, which turns the incoming check off); its tests in CRAN mode, 21 files (R-hub's `setup-r` step sets `NOT_CRAN` to false; nprcgenekeepr's R-hub run read its CRAN-mode count) |

- **Words in the NOTE.** If win-builder's NOTE lists "Possibly misspelled words in DESCRIPTION" (IBD, Schaid,
  Sinnwell, Therneau), CRAN's check did not read the package's `.aspell` word list (dragon 39). They are an
  abbreviation and three authors' names in the `Description` reference; the fold-in session says so in
  `cran-comments.md`. Not a reason to stop.
- **A URL in the NOTE** can be a moment's failure (dragon 10): open it in a browser and check again before acting.
- **R-devel over 540 s:** upload it again before anything is cut (dragon 8).
- **R-hub stops installing packages** (S4Vectors does not build): renv started on the runner after all; read the
  log's `Repo status` table (dragon 43).
- **Any ERROR or WARNING, or any other NOTE:** stop and do not submit. The next session reads it. A fix goes through
  its own strict-TDD session and reopens 17n.

## 7. Hand the results back

Start a new session and say "fold in the 17o results". Paste, or forward, for each check:

- win-builder: each of the three emails (the session reads `00check.log` and the tests' output from each link);
- the macOS builder: the reply's link;
- R-hub: nothing needed; the session reads the run with `gh`.

That session fills every marked line in `cran-comments.md` (`grep -c 'to be run before submission'
cran-comments.md` must print 0), corrects the NOTE list to what win-builder reported, runs the drift tool and
nprcgenekeepr's log on the copied files again, and records the results in 17o's DONE paragraph.

## 8. Then stop (HARD STOP)

Submission is Phase 17p and it is Mark's: upload `pedkindraw_1.0.0.tar.gz` (the SHA-256 above) on CRAN's submission
page, <https://cran.r-project.org/submit.html>, with `cran-comments.md` pasted whole into its comment box (R173: the
file holds only what CRAN reads), then confirm by the link CRAN emails to the maintainer. No session uploads.

---

## The record (not for CRAN; R173)

- **The tarball:** `pedkindraw_1.0.0.tar.gz`, 1,719,147 bytes, SHA-256
  `abb78758614010fda65b628e1255982b8d51893a5074cae41c62af7d22dcfe3c`, built by 17n (S100) from a `git archive` of
  `fa799c5`, whose package files are `2456253`'s. S101 compared it by machine with HEAD (`47c5f86`): the 276 tracked
  files `.Rbuildignore` keeps are all in it, 275 byte-identical and `DESCRIPTION` equal field by field (the build
  adds `NeedsCompilation`, `Packaged`, `Author` and `Maintainer`); the 10 other files are the build's (three
  vignettes' `.html`, `.R` and `.Rmd` in `inst/doc`, less `speed.R`, and `build/vignette.rds`, `build/partial.rdb`).
- **nprcgenekeepr at S101's Orient:** `3e06730c5`, its tree clean; the same 4 commits on the copied files since
  `baef1e12c` (`4283e3502`, `a85311021`, `392dd347e`, `471589138`); the drift tool 91 copied functions, 23 differ,
  0 without a `DIVERGENCE.md` row. The fold-in session repeats both.
- **The results (S102, 2026-11-27; read from each folder's files, which win-builder removes about 72 hours after the
  check):** win-builder R-devel (2026-11-17 r90926 ucrt; folder `lxX7xipRS4YJ`, check started 19:21:52 UTC), R-release
  (4.6.2; `VGDuwIP07s13`, 19:25:14 UTC) and R-oldrelease (4.5.3; `yiYlDkG2174D`), each on Windows Server 2022 x64:
  `00check.log` `Status: 1 NOTE`, the incoming check's Maintainer line and "New submission" alone (no misspelled
  words, no URL), every other check OK, the three logs the same but for timings and R 4.5.3's missing `current time`
  line; "Check time in seconds" 207, 219 and 242 (R85's limit 540); `tests/testthat.Rout`
  `[ FAIL 0 | WARN 0 | SKIP 27 | PASS 2696 ]` on each, `proc.time()` elapsed 78.95, 84.57 and 95.06 s against CPU
  (user + system) 78.93, 84.60 and 95.07 s (dragon 8). R-hub run 46055056615, read from its job logs: linux (Ubuntu
  26.04.1, R-devel r90998) and macos (Sequoia 15.7.9, Intel, r90998) `[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2697 ]`,
  windows (Server 2022 build 26100, r90926) `SKIP 27 | PASS 2696`, `Status: OK` on each. The macOS builder: 502 at
  20:07:45 UTC (its `/v1/` address 502, its form page 200), the third try; its line dropped (R174).
- **nprcgenekeepr at the fold-in (S102, 20:10 UTC):** unchanged: `3e06730c5`, its tree clean, the same 4 commits on
  the copied files; the drift tool 91 / 23 / 0.
