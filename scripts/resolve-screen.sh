#!/usr/bin/env bash
# resolve-screen.sh — resolve screen/UI phrase to file paths (alias + Graphify)
#
# Usage:
#   resolve-screen.sh --phrase "login screen validation" [--project DIR] [--write] [--json] [--budget N]
#
# Logs resolve_screen events to work/telemetry/events.jsonl via observe-event.
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"

PROJECT_DIR=""
PHRASE=""
WRITE=false
JSON=false
BUDGET=1500

usage() {
  cat <<EOF
resolve-screen — screen nickname → files (alias cache + Graphify)

Usage:
  $(basename "$0") --phrase "login screen" [--project DIR] [--write] [--json] [--budget N]

  --phrase   Screen or UI text from user message (required)
  --project  Bound project root (default: cwd)
  --write    On Graphify hit, append nickname to work/ui-aliases.yaml
  --json     Print JSON result only
  --budget   Graphify query token budget (default: 1500)

Examples:
  resolve-screen.sh --phrase "login screen validation" --json
  resolve-screen.sh --phrase "settings toggle" --write --json

Telemetry: resolve_screen events in work/telemetry/events.jsonl
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --phrase) PHRASE="$2"; shift 2 ;;
    --project) PROJECT_DIR="$2"; shift 2 ;;
    --write) WRITE=true; shift ;;
    --json) JSON=true; shift ;;
    --budget) BUDGET="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "ERROR: Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

[[ -n "$PHRASE" ]] || { echo "ERROR: --phrase required" >&2; exit 1; }
[[ -z "$PROJECT_DIR" ]] && PROJECT_DIR="$(pwd)"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
export RESOLVE_SCREEN_PROJECT_ROOT="$PROJECT_DIR"
export OBSERVE_PROJECT_ROOT="$PROJECT_DIR"

# shellcheck source=scripts/lib/observe-script-log.sh
source "$OS_REPO/scripts/lib/observe-script-log.sh"
_observe_script_log_begin "resolve-screen.sh" "$*"
trap '_observe_script_log_finish $?' EXIT

# shellcheck source=scripts/lib/resolve-screen.sh
source "$OS_REPO/scripts/lib/resolve-screen.sh"

write_flag="false"
[[ "$WRITE" == true ]] && write_flag="true"

set +e
result="$(_resolve_screen_run "$PHRASE" "$write_flag" "$BUDGET")"
rc=$?
set -e

files_csv="$(python3 -c "import json,sys; d=json.loads(sys.argv[1]); print(','.join(d.get('files') or []))" "$result" 2>/dev/null || true)"
[[ -n "$files_csv" ]] && _observe_script_log_set_files "$files_csv"

if [[ "$JSON" == true ]]; then
  printf '%s\n' "$result"
else
  python3 -c "
import json, sys
d = json.loads(sys.argv[1])
print('=== resolve-screen ===')
print(f\"  phrase: {d.get('phrase')}\")
print(f\"  source: {d.get('source')}\")
print(f\"  ok: {d.get('ok')}\")
if d.get('nickname'):
    print(f\"  nickname: {d['nickname']}\")
if d.get('files'):
    print('  files:')
    for f in d['files']:
        print(f'    - {f}')
if d.get('hint'):
    print(f\"  hint: {d['hint']}\")
" "$result"
fi

exit "$rc"