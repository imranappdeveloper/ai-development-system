#!/usr/bin/env bash
# usage-feedback.sh — telemetry events, milestone snapshots, feedback entries, reports
#
# Usage:
#   usage-feedback.sh event --type TYPE [--skill NAME] [--milestone M]
#   usage-feedback.sh snapshot --milestone grill|tasks-published|afk-run [metric flags]
#   usage-feedback.sh feedback --category CAT --severity SEV --text "..."
#   usage-feedback.sh report
#   usage-feedback.sh meta-gate
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
# shellcheck source=scripts/resolve-os-paths.sh
source "$OS_REPO/scripts/resolve-os-paths.sh"
# shellcheck source=scripts/lib/usage-snapshot.sh
source "$OS_REPO/scripts/lib/usage-snapshot.sh"

die() { echo "ERROR: $1" >&2; exit 1; }

usage() {
  cat <<EOF
usage-feedback — AI Dev OS usage telemetry and feedback

  event --type TYPE [--skill NAME] [--milestone M] [--project DIR]
  snapshot --milestone grill|tasks-published|afk-run [options]
  feedback --category CAT --severity low|medium|high --text "..." [--skill S] [--issue]
  report [--project DIR]
  meta-gate [--project DIR]

Snapshot options:
  --grill-questions N   --partial-footers N   --lock-approved true|false
  --prs N   --needs-info N   --spec-retries N   --queued N
  --afk-stalled   --crash   --duration-sec N   --skills "a,b"
  --issues-published N
EOF
}

PROJECT_ARG=""
CMD="${1:-}"
shift || true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_ARG="$2"
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

if [[ -n "$PROJECT_ARG" ]]; then
  export USAGE_PROJECT_ROOT="$(cd "$PROJECT_ARG" && pwd)"
fi
resolve_os_paths "${USAGE_PROJECT_ROOT:-$(pwd)}"

case "$CMD" in
  event)
    etype="" skill="" milestone=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --type) etype="$2"; shift 2 ;;
        --skill) skill="$2"; shift 2 ;;
        --milestone) milestone="$2"; shift 2 ;;
        *) die "unknown event arg: $1" ;;
      esac
    done
    [[ -n "$etype" ]] || die "event requires --type"
    _usage_record_event "$etype" "$skill" "$milestone" "{}"
    echo "OK: event recorded"
    ;;
  snapshot)
    milestone=""
    grill_q=0 partial=0 lock_ok=true prs=0 needs_info=0 spec_retry=0 queued=0
    afk_stalled=false crash=false duration_sec=0 skills="" issues_pub=0
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --milestone) milestone="$2"; shift 2 ;;
        --grill-questions) grill_q="$2"; shift 2 ;;
        --partial-footers) partial="$2"; shift 2 ;;
        --lock-approved) lock_ok="$2"; shift 2 ;;
        --prs) prs="$2"; shift 2 ;;
        --needs-info) needs_info="$2"; shift 2 ;;
        --spec-retries) spec_retry="$2"; shift 2 ;;
        --queued) queued="$2"; shift 2 ;;
        --afk-stalled) afk_stalled=true; shift ;;
        --crash) crash=true; shift ;;
        --duration-sec) duration_sec="$2"; shift 2 ;;
        --skills) skills="$2"; shift 2 ;;
        --issues-published) issues_pub="$2"; shift 2 ;;
        *) die "unknown snapshot arg: $1" ;;
      esac
    done
    [[ -n "$milestone" ]] || die "snapshot requires --milestone"
    _usage_write_snapshot "$milestone" "$grill_q" "$partial" "$lock_ok" "$prs" \
      "$needs_info" "$spec_retry" "$queued" "$afk_stalled" "$crash" \
      "$duration_sec" "$skills" "$issues_pub"
    ;;
  feedback)
    category="" severity="" text="" skill="" open_issue=false
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --category) category="$2"; shift 2 ;;
        --severity) severity="$2"; shift 2 ;;
        --text) text="$2"; shift 2 ;;
        --skill) skill="$2"; shift 2 ;;
        --milestone) milestone="$2"; shift 2 ;;
        --issue) open_issue=true; shift ;;
        *) die "unknown feedback arg: $1" ;;
      esac
    done
    [[ -n "$category" && -n "$severity" && -n "$text" ]] || die "feedback requires --category --severity --text"
    _usage_append_feedback "$category" "$severity" "$text" "$skill" "${milestone:-}" "$open_issue"
    ;;
  report)
    _usage_generate_report
    ;;
  meta-gate)
    _usage_meta_review_eligible
    ;;
  -h|--help|"")
    usage
    [[ -z "$CMD" ]] && exit 0 || exit 0
    ;;
  *)
    die "unknown command: $CMD (try --help)"
    ;;
esac