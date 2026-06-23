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
  $(basename "$0") dashboard [--port N] [--open]

Remote: configure in ai-dev-os.local.yaml:
  observe:
    remote_host: ubuntu-afk
    remote_project_root: ~/projects/my-app

Telemetry level: ai-dev-os.yaml → telemetry.level (verbose|standard|minimal)
EOF
}

PROJECT_ROOT="$(pwd)"
INVOKE_PROJECT_ROOT="$(pwd)"
REMOTE=false
JSON=false
INTERVAL=60
DASHBOARD_PORT=8765
DASHBOARD_OPEN=false
RUN_ID=""
CMD=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    status|watch|report|dashboard)
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
    --port)
      [[ $# -ge 2 ]] || die "--port requires number"
      DASHBOARD_PORT="$2"
      shift 2
      ;;
    --open) DASHBOARD_OPEN=true; shift ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

[[ -n "$CMD" ]] || { usage; exit 0; }

ACTIVE_GLOBAL_RUN_ID=""
_REGISTRY_FILE="$HOME/.gemini/antigravity/.active_run_context.json"
if [[ -f "$_REGISTRY_FILE" ]]; then
  _PY_PARSER="import json, sys, datetime, os
try:
    with open(sys.argv[1]) as f:
        data = json.load(f)
    if data.get('status') == 'active':
        hb_str = data.get('last_heartbeat')
        root = data.get('project_root') or ''
        if hb_str and root and os.path.isdir(root):
            hb = datetime.datetime.fromisoformat(hb_str.replace('Z', '+00:00'))
            now = datetime.datetime.now(datetime.timezone.utc)
            if (now - hb).total_seconds() < 300:
                print(f\"ACTIVE_PROJECT_ROOT='{root}'\")
                print(f\"ACTIVE_RUN_ID='{data.get('run_id')}'\")
                sys.exit(0)
except Exception:
    pass
print(\"ACTIVE_PROJECT_ROOT=''\")
print(\"ACTIVE_RUN_ID=''\")"
  eval "$(python3 -c "$_PY_PARSER" "$_REGISTRY_FILE")"

  if [[ -n "${ACTIVE_PROJECT_ROOT:-}" && -d "$ACTIVE_PROJECT_ROOT" ]]; then
    PROJECT_ROOT="$ACTIVE_PROJECT_ROOT"
    ACTIVE_GLOBAL_RUN_ID="$ACTIVE_RUN_ID"
  fi
fi

if [[ -z "$RUN_ID" && -n "$ACTIVE_GLOBAL_RUN_ID" ]]; then
  RUN_ID="$ACTIVE_GLOBAL_RUN_ID"
fi

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

_observe_probe_daemons() {
  local gh_status="missing" ollama_status="skip" tmux_status="skip"
  command -v gh >/dev/null 2>&1 && gh_status="ok" || gh_status="missing"
  if curl -sf --max-time 2 http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    ollama_status="ok"
  elif command -v ollama >/dev/null 2>&1; then
    ollama_status="down"
  else
    ollama_status="not_installed"
  fi
  if [[ "$REMOTE" == true || -n "${OBSERVE_PROBE_TMUX:-}" ]]; then
    if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
      tmux_status="ok"
    else
      tmux_status="none"
    fi
  fi
  printf 'gh=%s\nollama=%s\ntmux=%s\n' "$gh_status" "$ollama_status" "$tmux_status"
}

_observe_collect_status_json() {
  local run_file current_run daemons
  current_run="$(_observe_read_current_run_id)"
  run_file=""
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

  local level
  level="$(_observe_telemetry_level)"
  daemons="$(_observe_probe_daemons)"
  local events_file
  events_file="$(_observe_project_root)/work/telemetry/events.jsonl"
  [[ -f "$events_file" ]] || events_file=""

  python3 - "$PROJECT_ROOT" "$level" "$current_run" "$run_file" "$events_file" "$issue" "$step" "$step_index" "$ts" "$run_id" "$agent" "$elapsed" "$daemons" <<'PY'
import json, sys, os
from datetime import datetime, timezone, timedelta

project, level, current_run, run_file, events_file = sys.argv[1:6]
issue, step, step_index, ts, run_id, agent = sys.argv[6:12]
elapsed = int(sys.argv[12] or 0)
daemons_raw = sys.argv[13]
daemons = {}
for line in daemons_raw.splitlines():
    if '=' in line:
        k, v = line.split('=', 1)
        daemons[k] = v

def parse_ts(s):
    if not s:
        return None
    try:
        return datetime.fromisoformat(s.replace('Z', '+00:00'))
    except Exception:
        return None

now = datetime.now(timezone.utc)
recent_cutoff = now - timedelta(minutes=30)

last_script = last_files = last_skill = last_activity_ts = None
activity_recent = False

def last_event_type(path):
    if not path or not os.path.isfile(path):
        return ''
    last = ''
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                last = json.loads(line).get('event_type', '')
            except json.JSONDecodeError:
                pass
    return last

def ingest_event(e):
    global last_script, last_files, last_skill, last_activity_ts, activity_recent
    et = e.get('event_type')
    t = parse_ts(e.get('ts'))
    if t and t >= recent_cutoff:
        activity_recent = True
        if t and (last_activity_ts is None or t > last_activity_ts):
            last_activity_ts = t
    if et == 'script_invoked' and e.get('script'):
        last_script = e
    elif et == 'files_used' and e.get('files'):
        last_files = e
    elif et in ('run_start', 'observe_run_start') and e.get('skill'):
        last_skill = e.get('skill')

for path in [events_file, run_file]:
    if not path or not os.path.isfile(path):
        continue
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                ingest_event(json.loads(line))
            except json.JSONDecodeError:
                pass

session_active = False
if current_run and last_event_type(run_file) != 'run_end':
    session_active = True
elif step:
    session_active = True

health = 'active' if (session_active or activity_recent) else 'idle'

if session_active:
    if ts:
        start_ts = parse_ts(ts)
        if start_ts:
            elapsed = int((now - start_ts).total_seconds())
    elif last_activity_ts:
        elapsed = int((now - last_activity_ts).total_seconds())
else:
    elapsed = 0

display_run_id = (run_id or current_run or '') if session_active else ''

out = {
    'health': health,
    'session_active': session_active,
    'activity_recent': activity_recent,
    'telemetry_level': level,
    'project': project,
    'run_id': display_run_id,
    'issue': issue if session_active else '',
    'step': step if session_active else '',
    'step_index': step_index if session_active else '',
    'agent': agent if session_active else '',
    'elapsed_sec': elapsed,
    'last_ts': ts or (last_activity_ts.isoformat().replace('+00:00', 'Z') if last_activity_ts else ''),
    'last_script': (last_script or {}).get('script', ''),
    'last_script_status': (last_script or {}).get('status', ''),
    'last_skill': last_skill or ((last_script or {}).get('skill') or ''),
    'last_files': (last_files or {}).get('files') or [],
    'daemons': daemons,
}
print(json.dumps(out, separators=(',', ':')))
PY
}

_cmd_status_render() {
  local doc="$1" with_header="${2:-true}"
  if [[ "$with_header" == true ]]; then
    echo "=== Observe — status ==="
  fi
  python3 - "$doc" <<'PY'
import json, sys
d = json.loads(sys.argv[1])
lines = [
    f"  Project: {d.get('project', '')}",
    f"  Telemetry level: {d.get('telemetry_level', '')}",
    f"  Health: {d.get('health', 'idle')}",
]
if d.get('health') == 'active':
    if d.get('run_id'):
        lines.append(f"  Run: {d['run_id']}")
    if d.get('last_skill'):
        lines.append(f"  Skill: {d['last_skill']}")
    if d.get('issue'):
        lines.append(f"  Issue: #{d['issue']}")
    if d.get('step'):
        idx = d.get('step_index') or ''
        suffix = f" ({idx})" if idx else ''
        lines.append(f"  Step: {d['step']}{suffix}")
    if d.get('agent'):
        lines.append(f"  Agent: {d['agent']}")
    if d.get('last_script'):
        st = d.get('last_script_status') or 'ok'
        lines.append(f"  Last script: {d['last_script']} ({st})")
    files = d.get('last_files') or []
    if files:
        shown = ', '.join(files[:5])
        if len(files) > 5:
            shown += f", +{len(files)-5} more"
        lines.append(f"  Files: {shown}")
    lines.append(f"  Elapsed: {d.get('elapsed_sec', 0)}s")
else:
    if d.get('last_script'):
        lines.append(f"  Last script: {d['last_script']}")
    else:
        lines.append("  No recent ADS activity — ADS scripts will appear here as they run")
daemons = d.get('daemons') or {}
if daemons:
    lines.append(f"  gh: {daemons.get('gh', '?')}")
    if daemons.get('ollama') not in (None, 'skip'):
        lines.append(f"  Ollama (survey MCP): {daemons.get('ollama', '?')}")
    if daemons.get('tmux') not in (None, 'skip'):
        lines.append(f"  tmux: {daemons.get('tmux', '?')}")
print('\n'.join(lines))
PY
}

_cmd_status() {
  local doc
  doc="$(_observe_collect_status_json)"
  if [[ "$JSON" == true ]]; then
    printf '%s\n' "$doc"
    return 0
  fi
  _cmd_status_render "$doc" true
}

_cmd_report() {
  local runs_dir="$(_observe_runs_dir)"
  local target=""
  if [[ -n "$RUN_ID" ]]; then
    target="$(_observe_run_file "$RUN_ID")"
  else
    target="$(_latest_run_file || true)"
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
    if et == 'script_invoked':
        label = f"script:{e.get('script', '?')}"
    elif et == 'files_used':
        n = len(e.get('files') or [])
        label = f"files_used ({n})"
    elif et == 'mcp_probe':
        label = f"mcp:{e.get('target', '?')}"
    elif et == 'mcp_call':
        srv = e.get('mcp_server', e.get('target', '?'))
        tool = e.get('mcp_tool', 'survey')
        n = len(e.get('files_read') or [])
        label = f"mcp:{srv}/{tool} ({n} files)"
    elif et == 'daemon_status':
        label = f"daemon:{e.get('daemon', '?')}"
    else:
        label = step or et
    print(f"    - {e.get('ts','?')} {label}{suffix}")
PY
}

_observe_dashboard_prepare_port() {
  local port="$1"
  local url="http://127.0.0.1:${port}"
  local listener pid cap server

  listener="$(lsof -tiTCP:"$port" -sTCP:LISTEN 2>/dev/null | head -1 || true)"
  [[ -n "$listener" ]] || return 0

  cap="$(curl -sf "${url}/api/capabilities" 2>/dev/null || true)"
  if python3 -c "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('observe_actions') else 1)" <<<"$cap" 2>/dev/null; then
    echo "ADS Observe — ${url}/ (already running)"
    [[ "$DASHBOARD_OPEN" == true ]] && open "${url}/" 2>/dev/null || true
    exit 0
  fi

  server="$(curl -sf -I "${url}/" 2>/dev/null | grep -i '^Server:' | head -1 || true)"
  if [[ "$server" == *"ADSObserve"* ]]; then
    info "Restarting stale observe dashboard on port ${port}…"
    kill "$listener" 2>/dev/null || true
    sleep 0.5
    return 0
  fi

  die "port ${port} is already in use by another process (not ADS Observe)"
}

_observe_ensure_watch_session() {
  local root="$1"
  export OBSERVE_PROJECT_ROOT="$root"
  if _observe_has_active_session; then
    return 0
  fi
  local run_id
  run_id="$(OBSERVE_PROJECT_ROOT="$root" "$OS_HOME/scripts/observe-event.sh" run-start --skill observe 2>/dev/null || true)"
  [[ -n "$run_id" ]] || return 1
  info "Started telemetry session: $run_id"
}

_cmd_watch() {
  local heartbeat_sec="${OBSERVE_HEARTBEAT_SEC:-300}"
  local active_root="$INVOKE_PROJECT_ROOT"
  _observe_ensure_watch_session "$active_root"
  echo "=== Observe — watch (interval ${INTERVAL}s, heartbeat ${heartbeat_sec}s, Ctrl-C to stop) ==="
  local last_sig="" last_heartbeat_epoch
  last_heartbeat_epoch="$(date +%s)"
  while true; do

    local doc card sig health elapsed now probe_tmux=""
    [[ "$REMOTE" == true ]] && probe_tmux="1"
    if [[ "$JSON" == true ]]; then
      doc="$(OBSERVE_PROJECT_ROOT="$active_root" OBSERVE_PROBE_TMUX="$probe_tmux" "$0" status --json 2>/dev/null || echo '{}')"
      echo "--- $(date -u +%H:%M:%S) ---"
      echo "$doc"
      sig="$(printf '%s' "$doc" | shasum 2>/dev/null | awk '{print $1}' || printf '%s' "$doc" | md5 2>/dev/null || echo "$doc")"
    else
      doc="$(OBSERVE_PROJECT_ROOT="$active_root" OBSERVE_PROBE_TMUX="$probe_tmux" "$0" status --json 2>/dev/null || echo '{}')"
      card="$(_cmd_status_render "$doc" false)"
      sig="$(printf '%s' "$card" | shasum 2>/dev/null | awk '{print $1}' || printf '%s' "$card" | md5)"
      echo "--- $(date -u +%H:%M:%S) ---"
      echo "$card"
      health="$(python3 -c "import json,sys; print(json.loads(sys.argv[1]).get('health','idle'))" "$doc" 2>/dev/null || echo idle)"
      elapsed="$(python3 -c "import json,sys; print(json.loads(sys.argv[1]).get('elapsed_sec',0))" "$doc" 2>/dev/null || echo 0)"
      now="$(date +%s)"
      if [[ "$health" == "active" && "$sig" == "$last_sig" && $((now - last_heartbeat_epoch)) -ge heartbeat_sec ]]; then
        echo "  ♥ still working… (${elapsed}s elapsed, no change since last activity)"
        last_heartbeat_epoch="$now"
      fi
      [[ "$sig" != "$last_sig" ]] && last_heartbeat_epoch="$now"
    fi
    last_sig="$sig"
    sleep "$INTERVAL"
  done
}

if [[ "$REMOTE" == true ]]; then
  case "$CMD" in
    status) _observe_remote_exec "status $( [[ "$JSON" == true ]] && echo --json )" ;;
    watch) _observe_remote_exec "watch --interval $INTERVAL" ;;
    report) _observe_remote_exec "report $( [[ -n "$RUN_ID" ]] && echo --run-id "$RUN_ID" )" ;;
    dashboard) die "dashboard is local-only — use observe dashboard on Mac" ;;
  esac
  exit 0
fi

OBSERVE_PROJECT_ROOT="$PROJECT_ROOT"
case "$CMD" in
  status) _cmd_status ;;
  report) _cmd_report ;;
  watch) _cmd_watch ;;
  dashboard)
    [[ -f "$OS_HOME/scripts/observe-dashboard.py" ]] || die "missing observe-dashboard.py"
    # shellcheck source=scripts/lib/observe-projects.sh
    source "$OS_HOME/scripts/lib/observe-projects.sh"
    _observe_projects_register "$INVOKE_PROJECT_ROOT" 2>/dev/null || true
    _observe_dashboard_prepare_port "$DASHBOARD_PORT"
    args=(--port "$DASHBOARD_PORT" --project "$INVOKE_PROJECT_ROOT")
    [[ "$DASHBOARD_OPEN" == true ]] && args+=(--open)
    exec python3 "$OS_HOME/scripts/observe-dashboard.py" "${args[@]}"
    ;;
esac