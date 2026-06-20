#!/usr/bin/env bash
# ai-pr-review-notify.sh — post AFK AI review notifications after /review --pr
#
# Usage:
#   ai-pr-review-notify.sh --issue N --pr-number N --pr-url URL --review-file PATH
#   ai-pr-review-notify.sh --issue N --pr-number N --pr-url URL --skipped
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/lib/ai-pr-review-notify.sh
source "$OS_REPO/scripts/lib/ai-pr-review-notify.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

issue="" pr_number="" pr_url="" review_file="" skipped=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --issue) issue="$2"; shift 2 ;;
    --pr-number) pr_number="$2"; shift 2 ;;
    --pr-url) pr_url="$2"; shift 2 ;;
    --review-file) review_file="$2"; shift 2 ;;
    --skipped) skipped=true; shift ;;
    -h|--help)
      cat <<'EOF'
ai-pr-review-notify — post PR flag + issue one-liner after AFK AI review

  --issue N --pr-number N --pr-url URL --review-file PATH
  --issue N --pr-number N --pr-url URL --skipped
EOF
      exit 0
      ;;
    *) die "unknown arg: $1" ;;
  esac
done

[[ -n "$issue" && -n "$pr_number" && -n "$pr_url" ]] || die "requires --issue --pr-number --pr-url"
command -v gh >/dev/null 2>&1 || die "gh CLI required"

if [[ "$skipped" != "true" ]]; then
  [[ -n "$review_file" && -f "$review_file" ]] || die "requires --review-file when not --skipped"
fi

_ai_pr_review_post_notifications "$issue" "$pr_number" "$pr_url" "$review_file" "$skipped"