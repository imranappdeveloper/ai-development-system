#!/usr/bin/env bash
# issue-spec-check.sh — structural issue spec preflight (deterministic)
#
# Usage:
#   issue-spec-check.sh --issue N [--project DIR]
#   issue-spec-check.sh --body-file PATH [--issue N]
#   issue-spec-check.sh --offline --body-file PATH
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/lib/issue-spec-check.sh
source "$OS_REPO/scripts/lib/issue-spec-check.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

issue="" body_file="" project_dir="" offline=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) issue="$2"; shift 2 ;;
    --body-file) body_file="$2"; shift 2 ;;
    --project) project_dir="$2"; shift 2 ;;
    --offline) offline=true; shift ;;
    -h|--help)
      cat <<'EOF'
issue-spec-check — structural GitHub issue spec validation

  --issue N [--project DIR]
  --body-file PATH [--issue N]
  --offline --body-file PATH   skip gh blocked-by resolution

Exit 0 = READY (structural); 1 = NEEDS_SPEC; 2 = usage error
EOF
      exit 0
      ;;
    *) die "unknown arg: $1" ;;
  esac
done

if [[ -n "$project_dir" ]]; then
  cd "$project_dir"
fi

body=""
if [[ -n "$body_file" ]]; then
  [[ -f "$body_file" ]] || die "body file not found: $body_file"
  body="$(cat "$body_file")"
elif [[ -n "$issue" ]]; then
  command -v gh >/dev/null 2>&1 || die "gh CLI required for --issue"
  body="$(gh issue view "$issue" --json body -q .body)"
else
  die "requires --issue or --body-file"
fi

if _issue_spec_check_structural "$body" "$offline"; then
  _issue_spec_format_report "$issue"
  exit 0
else
  _issue_spec_format_report "$issue"
  exit 1
fi