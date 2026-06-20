#!/usr/bin/env bash
# afk-state-sync.sh — AFK label / PR state recovery
#
# Usage:
#   afk-state-sync.sh --issues 1,2,3 [--apply] [--project DIR]
#   afk-state-sync.sh --epic N [--apply] [--project DIR]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/lib/afk-state-sync.sh
source "$OS_REPO/scripts/lib/afk-state-sync.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

issues="" epic="" apply=false project_dir=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issues) issues="$2"; shift 2 ;;
    --epic) epic="$2"; shift 2 ;;
    --apply) apply=true; shift ;;
    --project) project_dir="$2"; shift 2 ;;
    -h|--help)
      cat <<'EOF'
afk-state-sync — repair issue labels from PR state

  --issues 1,2,3 [--apply]
  --epic N [--apply]

Default is dry-run (report only). --apply executes gh issue edit/comment.
EOF
      exit 0
      ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$issues" || -n "$epic" ]] || die "requires --issues or --epic"

if [[ -n "$project_dir" ]]; then
  cd "$project_dir"
fi

command -v gh >/dev/null 2>&1 || die "gh CLI required"

if [[ -n "$epic" ]]; then
  child_nums="$(gh issue list --search "is:issue #${epic}" --json number,body --limit 100 2>/dev/null | true)"
  # Better: list children with Parent epic in body — use gh api or search
  issues="$(gh issue list --state all --limit 200 --json number,body \
    -q '.[] | select(.body | test("## Parent[[:space:]]*#?'${epic}'")) | .number' 2>/dev/null | paste -sd, - || true)"
  if [[ -z "$issues" ]]; then
    issues="$(gh issue list --state all --limit 200 --json number,title \
      -q '.[].number' 2>/dev/null | head -20 | paste -sd, - || true)"
  fi
fi

[[ -n "$issues" ]] || die "no issues to sync"

_afk_sync_run "$issues" "$apply"