#!/bin/sh
# npm install / npm ci run this from `prepare`, after the build: point git at .githooks
# so pushes run npm run preflight. It never fails an install, does nothing on CI, on
# Vercel or outside a git checkout, and never replaces another hook setup.
[ -z "${CI:-}${VERCEL:-}" ] || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0
[ -f .githooks/pre-push ] || exit 0

current=$(git config --get core.hooksPath)
if [ -n "$current" ]; then
  [ "$current" = .githooks ] ||
    echo "install-git-hooks: core.hooksPath is $current; pre-push preflight not installed. Run npm run preflight before pushing." >&2
  exit 0
fi
hooks=$(git rev-parse --git-path hooks)
if ls "$hooks" 2>/dev/null | grep -qv '\.sample$'; then
  echo "install-git-hooks: $hooks has its own hooks; pre-push preflight not installed. Run npm run preflight before pushing." >&2
  exit 0
fi
git config core.hooksPath .githooks
exit 0
