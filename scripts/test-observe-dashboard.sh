#!/usr/bin/env bash
# test-observe-dashboard.sh — API checks for local observe dashboard
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export AI_DEV_OS_HOME="$ROOT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
P1="$TMP/p1"
P2="$TMP/p2"
mkdir -p "$P1/work/telemetry/runs" "$P2/work/telemetry/runs"

for p in "$P1" "$P2"; do
  cp "$ROOT/templates/project-starter/ai-dev-os.yaml" "$p/ai-dev-os.yaml"
  cp "$ROOT/templates/project-starter/AGENTS.md" "$p/AGENTS.md"
  name="$(basename "$p")"
  sed -i '' "s|{{PROJECT_NAME}}|$name|g" "$p/ai-dev-os.yaml" 2>/dev/null \
    || sed -i "s|{{PROJECT_NAME}}|$name|g" "$p/ai-dev-os.yaml"
done

export HOME="$TMP/home"
mkdir -p "$HOME/.config/ai-dev-os"

# shellcheck source=scripts/lib/observe-projects.sh
source "$ROOT/scripts/lib/observe-projects.sh"
_observe_projects_register "$P1"
_observe_projects_register "$P2"

bash "$ROOT/scripts/lib/observe-script-log.sh" record \
  --project "$P1" --script ads-preflight.sh --args "--json" --exit 0

reg="$(_observe_projects_list)"
python3 -c "import json,sys; d=json.load(sys.stdin); assert len(d['projects'])==2" <<<"$reg" \
  && echo "  OK: registry two projects" || { echo "  FAIL: registry" >&2; fail=1; }

PORT="$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')"
mkdir -p "$TMP/empty"
# Start from non-bound cwd so dashboard does not auto-register a 3rd project
(
  cd "$TMP/empty"
  OBSERVE_DASHBOARD_QUIET=1 HOME="$HOME" AI_DEV_OS_HOME="$ROOT" \
    python3 "$ROOT/scripts/observe-dashboard.py" --port "$PORT" --no-open
) &
dp=$!
sleep 1
snap="$(curl -sf "http://127.0.0.1:${PORT}/api/snapshot?project=all" || true)"

if python3 -c "import json,sys; d=json.load(sys.stdin); assert len(d.get('projects',[]))==2; assert len(d.get('events',[]))>=1" <<<"$snap" 2>/dev/null; then
  echo "  OK: snapshot API"
else
  echo "  FAIL: snapshot API" >&2
  [[ -n "$snap" ]] && echo "  DEBUG: $snap" >&2 || echo "  DEBUG: empty response (server/port $PORT)" >&2
  fail=1
fi

snap_p1="$(curl -sf "http://127.0.0.1:${PORT}/api/snapshot?project=p1" || true)"
if python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('filter')=='p1'; assert len(d.get('projects',[]))==1; assert d['projects'][0]['name']=='p1'; assert all(e.get('project')=='p1' for e in d.get('events',[]))" <<<"$snap_p1" 2>/dev/null; then
  echo "  OK: snapshot project filter"
else
  echo "  FAIL: snapshot project filter" >&2
  [[ -n "$snap_p1" ]] && echo "  DEBUG: $snap_p1" >&2
  fail=1
fi

start="$(curl -sf -X POST "http://127.0.0.1:${PORT}/api/observe/start" \
  -H "Content-Type: application/json" \
  -d "{\"project\":\"p1\"}" || true)"
if python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('ok') is True; assert d.get('run_id')" <<<"$start" 2>/dev/null; then
  echo "  OK: observe start API"
else
  echo "  FAIL: observe start API" >&2
  [[ -n "$start" ]] && echo "  DEBUG: $start" >&2
  fail=1
fi

stop="$(curl -sf -X POST "http://127.0.0.1:${PORT}/api/observe/stop" \
  -H "Content-Type: application/json" \
  -d "{\"project\":\"p1\"}" || true)"
if python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('ok') is True" <<<"$stop" 2>/dev/null; then
  echo "  OK: observe stop API"
else
  echo "  FAIL: observe stop API" >&2
  [[ -n "$stop" ]] && echo "  DEBUG: $stop" >&2
  fail=1
fi

snap_after_stop="$(curl -sf "http://127.0.0.1:${PORT}/api/snapshot?project=p1" || true)"
if python3 -c "import json,sys; d=json.load(sys.stdin); p=(d.get('projects') or [{}])[0]; assert p.get('session_active') is False; assert p.get('elapsed_sec', -1)==0" <<<"$snap_after_stop" 2>/dev/null; then
  echo "  OK: snapshot idle after stop"
else
  echo "  FAIL: snapshot idle after stop" >&2
  [[ -n "$snap_after_stop" ]] && echo "  DEBUG: $snap_after_stop" >&2
  fail=1
fi

cap="$(curl -sf "http://127.0.0.1:${PORT}/api/capabilities" || true)"
if python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('observe_actions') is True" <<<"$cap" 2>/dev/null; then
  echo "  OK: capabilities API"
else
  echo "  FAIL: capabilities API" >&2
  fail=1
fi

kill "$dp" 2>/dev/null || true
wait "$dp" 2>/dev/null || true

[[ -f "$ROOT/templates/observe-dashboard/index.html" ]] \
  && echo "  OK: dashboard template" || { echo "  FAIL: template" >&2; fail=1; }

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1