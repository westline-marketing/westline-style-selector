#!/usr/bin/env bash
# `npm run preflight`: fast checks run by .githooks/pre-push and by the CI `preflight`
# job; the publish workflow gates a release on the same test and build. Budget: one minute.
#   1. git diff --check on the commits since the base (whitespace errors)
#   2. npm run typecheck
#   3. npm test
#   4. npm run build (tsc into the ignored dist/)
# Base: `--base <ref>` (CI passes HEAD^1), else the merge base of HEAD and
# origin/main. The checks read the working tree.
set -uo pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

if [ "${1:-}" = --base ]; then
  base=$(git rev-parse --verify --quiet "${2:-}^{commit}")
else
  base=$(git merge-base HEAD origin/main 2>/dev/null)
fi
if [ -z "$base" ]; then
  echo "preflight: cannot resolve the base ${2:-(merge base with origin/main)}; run git fetch origin main." >&2
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "preflight: uncommitted and untracked files are checked as they are on disk." >&2
fi

failed=
step() {
  local name=$1 start=$SECONDS
  shift
  if "$@"; then
    echo "preflight: $name ok ($((SECONDS - start))s)"
  else
    echo "preflight: $name FAILED ($((SECONDS - start))s)" >&2
    failed="$failed, $name"
  fi
}

echo "preflight: checking changes since $(git rev-parse --short "$base")"
step "git diff --check" git diff --check "$base" HEAD
step typecheck npm run --silent typecheck
step test npm run --silent test
step build npm run --silent build

if [ -n "$failed" ]; then
  echo "preflight: failed: ${failed#, } (${SECONDS}s)" >&2
  exit 1
fi
echo "preflight: passed (${SECONDS}s)"
