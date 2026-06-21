#!/usr/bin/env bash
# observe.sh — run observability CLI (status, watch, report)
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"
LIB="$OS_HOME/scripts/lib/observe-event.sh"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -f "$LIB" ]] || die "Missing: $LIB"
# shellcheck source=scripts/lib/observe-event.sh
source "$LIB"

usage() {
  cat <<EOF
observe — run observability (live + retrospective)

Usage:
  $(basename "$0") status [--json] [--remote]
  $(basename "$0") watch [--remote] [--interval SEC]
  $(basename "$0") report [--run-id ID] [--remote]

Remote: configure in ai-dev-os.local.yaml:
  observe:
    remote_host: ubuntu-afk
    remote_project_root: ~/projects/my-app

Telemetry level: ai-dev-os.yaml → telemetry.level (verbose|standard|minimal)
EOF
}

PROJECT_ROOT="$(pwd)"
REMOTE=false
JSON=false
INTERVAL=60
RUN_ID=""
CMD=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    status|watch|report)
      [[ -z "$CMD" ]] || die "multiple commands"
      CMD="$1"
      shift
      ;;
    --json) JSON=true; shift ;;
    --remote) REMOTE=true; shift ;;
    --interval)
      [[ $# -ge 2 ]] || die "--interval requires seconds"
      INTERVAL="$2"
      shift 2
      ;;
    --run-id)
      [[ $# -ge 2 ]] || die "--run-id requires value"
      RUN_ID="$2"
      shift 2
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

[[ -n "$CMD" ]] || { usage; exit 0; }

_observe_remote_config() {
  local yaml="$PROJECT_ROOT/ai-dev-os.local.yaml"
  REMOTE_HOST=""
  REMOTE_ROOT=""
  [[ -f "$yaml" ]] || return 0
  REMOTE_HOST="$(awk '
    /^observe:/{o=1; next}
    o && /^[a-zA-Z#]/{o=0}
    o && $1 == "remote_host:" {gsub(/^[^:]*:[[:space:]]*/,""); gsub(/["'\'']/, ""); print; exit}
  ' "$yaml" 2>/dev/null || true)"
  REMOTE_ROOT="$(awk '
    /^observe:/{o=1; next}
    o && /^[a-zA-Z#]/{o=0}
    o && $1 == "remote_project_root:" {gsub(/^[^:]*:[[:space:]]*/,""); gsub(/["'\'']/, ""); print; exit}
  ' "$yaml" 2>/dev/null || true)"
}

_observe_remote_exec() {
  local subcmd="$1"
  _observe_remote_config
  [[ -n "$REMOTE_HOST" ]] || die "observe.remote_host not set in ai-dev-os.local.yaml"
  [[ -n "$REMOTE_ROOT" ]] || die "observe.remote_project_root not set in ai-dev-os.local.yaml"
  ssh "$REMOTE_HOST" "cd $(printf '%q' "$REMOTE_ROOT") && observe.sh $subcmd"
}

_latest_run_file() {
  local runs_dir
  runs_dir="$(_observe_runs_dir)"
  [[ -d "$runs_dir" ]] || return 1
  ls -t "$runs_dir"/*.jsonl 2>/dev/null | head -1 || true
}

_parse_last_event() {
  local file="$1" field="$2"
  [[ -f "$file" ]] || return 0
  tail -1 "$file" | python3 -c "
import json,sys
field=sys.argv[1]
try:
  d=json.load(sys.stdin)
  v=d.get(field)
  if v is None: print('')
  else: print(v)
except Exception:
  print('')
" "$field" 2>/dev/null || true
}

_find_open_step() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  python3 - "$file" <<'PY'
import json, sys
path = sys.argv[1]
steps = {}
order = []
with open(path) as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        try:
            e = json.loads(line)
        except json.JSONDecodeError:
            continue
        key = e.get("step") or e.get("event_type")
        et = e.get("event_type")
        if et == "step_start":
            steps[key] = e
            order.append(key)
        elif et == "step_end" and key in steps:
            del steps[key]
if not steps:
    sys.exit(0)
last = steps.get(order[-1], {}) if order else {}
for k in ("issue", "step", "step_index", "ts", "run_id", "agent"):
    print(f"{k}={last.get(k, '')}")
PY
}

_elapsed_since() {
  local ts="$1"
  [[ -n "$ts" ]] || { echo "0"; return; }
  python3 - "$ts" <<'PY'
import sys
from datetime import datetime, timezone
ts = sys.argv[1].replace("Z", "+00:00")
try:
    start = datetime.fromisoformat(ts)
    now = datetime.now(timezone.utc)
    print(int((now - start).total_seconds()))
except Exception:
    print(0)
PY
}

_cmd_status() {
  local run_file current_run
  current_run="$(_observe_read_current_run_id)"
  run_file="$(_latest_run_file)"
  if [[ -n "$current_run" ]]; then
    run_file="$(_observe_run_file "$current_run")"
  fi

  local issue="" step="" step_index="" ts="" run_id="" agent="" elapsed=0
  if [[ -f "$run_file" ]]; then
    eval "$(_find_open_step "$run_file")"
    run_id="${run_id:-$current_run}"
    [[ -z "$run_id" ]] && run_id="$(_parse_last_event "$run_file" run_id)"
    elapsed="$(_elapsed_since "$ts")"
  fi

  local level health
  level="$(_observe_telemetry_level)"
  health="idle"
  [[ -n "$current_run" || -n "$step" ]] && health="active"

  if [[ "$JSON" == true ]]; then
    printf '{"health":"%s","telemetry_level":"%s","run_id":"%s","issue":"%s","step":"%s","step_index":"%s","agent":"%s","elapsed_sec":%s,"last_ts":"%s"}\n' \
      "$health" "$level" "${run_id:-}" "${issue:-}" "${step:-}" "${step_index:-}" "${agent:-}" "${elapsed:-0}" "${ts:-}"
    return 0
  fi

  echo "=== Observe — status ==="
  info "Project: $PROJECT_ROOT"
  info "Telemetry level: $level"
  info "Health: $health"
  if [[ "$health" == "active" ]]; then
    [[ -n "$run_id" ]] && info "Run: $run_id"
    [[ -n "$issue" ]] && info "Issue: #$issue"
    [[ -n "$step" ]] && info "Step: $step ${step_index:+($step_index)}"
    [[ -n "$agent" ]] && info "Agent: $agent"
    info "Elapsed: ${elapsed}s (since last step_start)"
  else
    info "No active run — start work or check work/telemetry/runs/"
  fi
}

_cmd_report() {
  local runs_dir="$(_observe_runs_dir)"
  local target=""
  if [[ -n "$RUN_ID" ]]; then
    target="$(_observe_run_file "$RUN_ID")"
  else
    target="$(_latest_run_file)"
  fi
  [[ -n "$target" && -f "$target" ]] || die "no run trace found"

  echo "=== Observe — report ==="
  info "Run file: $target"
  python3 - "$target" <<'PY'
import json, sys
from collections import defaultdict
path = sys.argv[1]
events = []
with open(path) as f:
    for line in f:
        line = line.strip()
        if line:
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError:
                pass
if not events:
    print("  (empty)")
    sys.exit(0)
run_id = events[0].get("run_id", "?")
print(f"  Run: {run_id}")
print(f"  Events: {len(events)}")
step_durations = defaultdict(int)
open_steps = {}
for e in events:
    et = e.get("event_type")
    step = e.get("step") or et
    if et == "step_start":
        open_steps[step] = e.get("ts")
    elif et == "step_end" and step in open_steps:
        pass
issues = sorted({e.get("issue") for e in events if e.get("issue")})
if issues:
    print(f"  Issues: {', '.join('#'+str(i) for i in issues)}")
print("  Timeline:")
for e in events:
    et = e.get("event_type", "?")
    step = e.get("step", "")
    idx = e.get("step_index", "")
    issue = e.get("issue")
    dur = e.get("duration_sec")
    extra = []
    if issue:
        extra.append(f"issue=#{issue}")
    if idx:
        extra.append(idx)
    if dur is not None:
        extra.append(f"{dur}s")
    suffix = f" ({', '.join(extra)})" if extra else ""
    label = step or et
    print(f"    - {e.get('ts','?')} {label}{suffix}")
PY
}

_cmd_watch() {
  echo "=== Observe — watch (interval ${INTERVAL}s, Ctrl-C to stop) ==="
  local last_sig=""
  while true; do
    local line
    if [[ "$JSON" == true ]]; then
      line="$(OBSERVE_PROJECT_ROOT="$PROJECT_ROOT" "$0" status --json 2>/dev/null || true)"
    else
      line="$(OBSERVE_PROJECT_ROOT="$PROJECT_ROOT" "$0" status 2>/dev/null | tail -n +2 || true)"
    fi
    local sig
    sig="$(printf '%s' "$line" | head -1)"
    if [[ "$sig" != "$last_sig" ]]; then
      if [[ "$JSON" == true ]]; then
        echo "$line"
      else
        echo "--- $(date -u +%H:%M:%S) ---"
        echo "$line"
      fi
      if grep -q '"health":"active"' <<<"$line" 2>/dev/null || grep -q 'Health: active' <<<"$line" 2>/dev/null; then
        :
      fi
      last_sig="$sig"
    fi
    sleep "$INTERVAL"
  done
}

if [[ "$REMOTE" == true ]]; then
  case "$CMD" in
    status) _observe_remote_exec "status $( [[ "$JSON" == true ]] && echo --json )" ;;
    watch) _observe_remote_exec "watch --interval $INTERVAL" ;;
    report) _observe_remote_exec "report $( [[ -n "$RUN_ID" ]] && echo --run-id "$RUN_ID" )" ;;
  esac
  exit 0
fi

OBSERVE_PROJECT_ROOT="$PROJECT_ROOT"
case "$CMD" in
  status) _cmd_status ;;
  report) _cmd_report ;;
  watch) _cmd_watch ;;
esac