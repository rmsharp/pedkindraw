#!/usr/bin/env bash
# The check behind the quality gate 'examples-no-open-connections'
# (methodology/.quality-gates.json; pedkindraw S70, plan section 13): builds the
# package in a scratch folder and runs R CMD check's examples the way GitHub's
# jobs run them, with NOT_CRAN=true (so an example guarded by it runs, Chrome
# ones included) and _R_CHECK_CONNECTIONS_LEFT_OPEN_=true (so a connection an
# example leaves open is an ERROR: chromote leaves two processx pipes open),
# which the check on a developer's own machine runs without. Prints "errors: N",
# N the ERRORs R CMD check reports, or 99 when the build or the check did not
# finish. Run from anywhere; takes about 30 s.
#   bash tools/checkExamples.sh
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
lib=$(cd "$here" && Rscript -e 'cat(renv::paths$library())' 2> /dev/null | tail -1)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work" || exit 1
run() {
  env -u RENV_PROJECT R_LIBS="$lib" R_LIBS_USER="$lib" NOT_CRAN=true \
    _R_CHECK_CONNECTIONS_LEFT_OPEN_=true "$@"
}
if ! run R CMD build --no-build-vignettes "$here" > build.log 2>&1; then
  tail -5 build.log
  echo "errors: 99"
  exit 0
fi
run R CMD check --no-tests --no-manual --no-vignettes --no-build-vignettes \
  --ignore-vignettes pedkindraw_*.tar.gz > check.log 2>&1
grep -E "checking examples|connections left open|^Status" check.log
status=$(grep -E "^Status:" check.log | tail -1)
if [ -z "$status" ]; then
  echo "errors: 99"
else
  echo "errors: $(echo "$status" | grep -oE '[0-9]+ ERROR' | grep -oE '^[0-9]+' || true)" | sed 's/errors: $/errors: 0/'
fi
