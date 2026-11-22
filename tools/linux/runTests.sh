#!/usr/bin/env bash
# Run pedkindraw's tests on Linux, in the container tools/linux/Dockerfile
# builds (pedkindraw S70, docs/planning/picture-files-plan.md section 13).
# A copy of the working tree (no .git, renv or .Rprofile) is mounted, the
# package loaded with pkgload and the tests run with NOT_CRAN=true, as GitHub's
# jobs do. Exit status 1 when any test fails or errors.
#   tools/linux/runTests.sh                      # every test file
#   tools/linux/runTests.sh savePedigreeDiagram  # files matching a filter
# PEDKINDRAW_LINUX_IMAGE names another image (default pedkindraw-linux, built
# on first use).
set -euo pipefail
here=$(cd "$(dirname "$0")/../.." && pwd)
image=${PEDKINDRAW_LINUX_IMAGE:-pedkindraw-linux}
docker image inspect "$image" > /dev/null 2>&1 || docker build -t "$image" "$here/tools/linux"
copy=$(mktemp -d)
trap 'rm -rf "$copy"' EXIT
rsync -a --exclude .git --exclude renv --exclude .Rprofile --exclude '*.Rcheck' \
  "$here"/ "$copy"/
docker run --rm --shm-size=1g -e NOT_CRAN=true -e FILTER="${1:-}" \
  -v "$copy":/pkg -w /pkg "$image" Rscript --no-init-file -e '
suppressMessages(pkgload::load_all(".", quiet = TRUE))
filter <- Sys.getenv("FILTER")
r <- as.data.frame(testthat::test_dir(
  "tests/testthat", filter = if (nzchar(filter)) filter else NULL,
  reporter = "summary", stop_on_failure = FALSE
))
cat(sprintf("files %d, tests %d, expectations %d, failed %d, errors %d, skipped %d, warnings %d\n",
            length(unique(r$file)), nrow(r), sum(r$nb), sum(r$failed),
            sum(r$error), sum(r$skipped), sum(r$warning)))
quit(status = if (sum(r$failed) + sum(r$error) > 0L) 1L else 0L)
'
