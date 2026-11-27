## New submission

This is a new submission. pedkindraw draws pedigrees as interactive
'visNetwork' graphs that can be annotated, and computes kinship
coefficients. It also trims and shrinks pedigrees, checks pedigree records,
finds sets of unrelated individuals, and converts 'kinship2' and
'Pedixplorer' pedigree objects.

Its maintainer also maintains nprcgenekeepr ("Genetic Tools for Colony
Management", on CRAN). About half of pedkindraw's R code is in files that
began as copies of nprcgenekeepr's pedigree code, and 22 of pedkindraw's 38
exported functions have the same names as nprcgenekeepr exports. pedkindraw
does not depend on nprcgenekeepr: it offers the drawing and kinship on their
own, without nprcgenekeepr's colony-management tools.
Once pedkindraw is on CRAN, nprcgenekeepr's next release is planned to import
pedkindraw and re-export those 22 functions in place of its own copies, so
that the two packages no longer define functions of the same name.

## R CMD check results

    0 errors | 0 warnings | 1 note

    * checking CRAN incoming feasibility ... NOTE
    Maintainer: 'R. Mark Sharp <rmsharp@me.com>'

    New submission

This is the NOTE for a new package.

* win-builder's incoming check, which also spell-checks DESCRIPTION:
  to be run before submission.

## Check time

A CRAN check runs 21 of the package's 109 test files. With all of them, an
earlier build read 980 seconds on win-builder R-devel, over the 10-minute
limit. The 88 files left out are named in `tests/testthat/slowTestFiles.txt`;
the 21 kept were chosen by a run-time trace so that every one of the 38
exported functions is still called by a test that CRAN runs. Continuous
integration and local runs set `NOT_CRAN=true` and run all 109 files.

* win-builder R-devel "Check time in seconds": to be run before submission.

## Test environments

* Local, macOS 27.2 (aarch64-apple-darwin23), R 4.6.2: `R CMD check
  --as-cran` of the submitted tarball, 1 NOTE (above); the tests it runs
  `[ FAIL 0 | WARN 0 | SKIP 26 | PASS 2697 ]`.
* Local, the same tarball with only R's standard packages installed beside its
  imports (`_R_CHECK_DEPENDS_ONLY_=true`): 1 NOTE (above), with the tests a
  CRAN check runs and with all 109 test files.
* Local, the same package files built and checked with Bioconductor 3.24's
  Pedixplorer 1.10.0 (a suggested package): 1 NOTE (above).
* GitHub Actions, the same package files, all 109 test files: macOS 26.7.2
  (aarch64), R 4.6.2; Windows Server 2022 x64 (build 26100), R 4.6.2; Ubuntu
  26.04.1, R-devel (2026-11-26 r90998), R 4.6.2 and R 4.5.3. `Status: OK` on
  each.
* win-builder R-devel: to be run before submission.
* win-builder R-release: to be run before submission.
* win-builder R-oldrelease: to be run before submission.
* macOS builder, R-devel (Apple silicon): to be run before submission.
* R-hub, R-devel on Linux, Windows and macOS (Intel):
  to be run before submission.

## Downstream dependencies

There are none: this is a new package.
