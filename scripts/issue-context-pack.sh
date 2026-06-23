#!/usr/bin/env bash
# issue-context-pack.sh — emit minimal per-issue context bundle
#
# Usage:
#   issue-context-pack.sh --issue N [--project DIR]
#   issue-context-pack.sh --body-file PATH --issue N [--title TITLE] [--project DIR]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/lib/issue-context-pack.sh
source "$OS_REPO/scripts/lib/issue-context-pack.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

issue="" body_file="" title="" project_dir=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) issue="$2"; shift 2 ;;
    --body-file) body_file="$2"; shift 2 ;;
    --title) title="$2"; shift 2 ;;
    --project) project_dir="$2"; shift 2 ;;
    -h|--help)
      cat <<'EOF'
issue-context-pack — minimal AFK context bundle per issue

  --issue N [--project DIR]
  --body-file PATH --issue N [--title TITLE]

Prints path to work/context-packs/issue-N.md
EOF
      exit 0
      ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$issue" ]] || die "requires --issue"

if [[ -n "$project_dir" ]]; then
  export ISSUE_PACK_PROJECT_ROOT="$(cd "$project_dir" && pwd)"
  cd "$ISSUE_PACK_PROJECT_ROOT"
else
  export ISSUE_PACK_PROJECT_ROOT="$(pwd)"
fi

export OBSERVE_PROJECT_ROOT="$ISSUE_PACK_PROJECT_ROOT"
# shellcheck source=scripts/lib/observe-script-log.sh
source "$OS_REPO/scripts/lib/observe-script-log.sh"
_observe_script_log_begin "issue-context-pack.sh" "$*"
trap '_observe_script_log_finish $?' EXIT

body=""
if [[ -n "$body_file" ]]; then
  [[ -f "$body_file" ]] || die "body file not found: $body_file"
  body="$(cat "$body_file")"
else
  command -v gh >/dev/null 2>&1 || die "gh CLI required for --issue without --body-file"
  body="$(gh issue view "$issue" --json body,title -q '.body')"
  [[ -z "$title" ]] && title="$(gh issue view "$issue" --json title -q .title)"
fi

out_dir="$ISSUE_PACK_PROJECT_ROOT/work/context-packs"
pack="$(_issue_pack_write_bundle "$issue" "$title" "$body" "$out_dir")"
_observe_script_log_set_files "$pack,CONTEXT.md,work/requirement-lock.md"
echo "$pack"