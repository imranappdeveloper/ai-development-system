#!/usr/bin/env bash
# test-observe.sh — unit checks for observe-event.sh and observe.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export AI_DEV_OS_HOME="$ROOT"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail=0
PROJECT="$TMP/project"
mkdir -p "$PROJECT/work/telemetry/runs"

cp "$ROOT/templates/project-starter/ai-dev-os.yaml" "$PROJECT/ai-dev-os.yaml"
sed -i '' "s|{{PROJECT_NAME}}|test-project|g" "$PROJECT/ai-dev-os.yaml" 2>/dev/null \
  || sed -i "s|{{PROJECT_NAME}}|test-project|g" "$PROJECT/ai-dev-os.yaml"

echo "=== test-observe ==="

run_id="$(cd "$PROJECT" && "$ROOT/scripts/observe-event.sh" run-start --skill task-run --agent grok)"
[[ -n "$run_id" ]] && echo "  OK: run-start id" || { echo "  FAIL: run-start" >&2; fail=1; }

(cd "$PROJECT" && "$ROOT/scripts/observe-event.sh" emit --type step_start \
  --run-id "$run_id" --step work-to-pr-v2/implement --step-index 4/7 --issue 42) \
  && echo "  OK: step_start emit" || { echo "  FAIL: step_start" >&2; fail=1; }

run_file="$PROJECT/work/telemetry/runs/${run_id}.jsonl"
[[ -f "$run_file" ]] && echo "  OK: run jsonl created" || { echo "  FAIL: run file" >&2; fail=1; }
grep -q 'step_start' "$run_file" && echo "  OK: step in trace" || { echo "  FAIL: step missing" >&2; fail=1; }

(cd "$PROJECT" && "$ROOT/scripts/observe-event.sh" run-end --run-id "$run_id" --status ok) \
  && echo "  OK: run-end" || { echo "  FAIL: run-end" >&2; fail=1; }

status_after_end="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status --json)"
python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('session_active') is False; assert d.get('elapsed_sec', -1)==0" <<<"$status_after_end" \
  && echo "  OK: session idle after run-end" \
  || { echo "  FAIL: session idle after run-end" >&2; fail=1; }

status_json="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status --json)"
python3 -c "import json,sys; d=json.load(sys.stdin); assert d['telemetry_level']=='verbose'" <<<"$status_json" \
  && echo "  OK: status json level" \
  || { echo "  FAIL: status json" >&2; fail=1; }

report_out="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" report --run-id "$run_id")"
grep -q 'Timeline' <<<"$report_out" && echo "  OK: report timeline" || { echo "  FAIL: report" >&2; fail=1; }

# minimal level suppresses tool_call
sed -i '' 's/level: verbose/level: minimal/' "$PROJECT/ai-dev-os.yaml" 2>/dev/null \
  || sed -i 's/level: verbose/level: minimal/' "$PROJECT/ai-dev-os.yaml"
before="$(wc -l <"$run_file" | tr -d ' ')"
rid2="$(cd "$PROJECT" && "$ROOT/scripts/observe-event.sh" run-start --skill test)"
(cd "$PROJECT" && "$ROOT/scripts/observe-event.sh" emit --type tool_call --run-id "$rid2" --step Read) || true
run_file2="$PROJECT/work/telemetry/runs/${rid2}.jsonl"
if ! grep -q 'tool_call' "$run_file2" 2>/dev/null; then
  echo "  OK: minimal suppresses tool_call"
else
  echo "  FAIL: minimal should suppress tool_call" >&2
  fail=1
fi

# script auto-log without manual observe-event
bash "$ROOT/scripts/lib/observe-script-log.sh" record \
  --project "$PROJECT" --script ads-preflight.sh --args "--json" --exit 0 \
  && echo "  OK: script_invoked record" || { echo "  FAIL: script record" >&2; fail=1; }

grep -q 'script_invoked' "$PROJECT/work/telemetry/events.jsonl" \
  && echo "  OK: script_invoked in events.jsonl" \
  || { echo "  FAIL: script_invoked missing" >&2; fail=1; }

status_json2="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status --json)"
python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('last_script')=='ads-preflight.sh'" <<<"$status_json2" \
  && echo "  OK: status shows last script" \
  || { echo "  FAIL: status last_script" >&2; fail=1; }

python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('health')=='active'" <<<"$status_json2" \
  && echo "  OK: status active after script activity" \
  || { echo "  FAIL: status health active" >&2; fail=1; }

card_out="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status 2>&1)"
grep -q 'Project:' <<<"$card_out" && grep -q 'Health:' <<<"$card_out" && grep -q 'Last script:' <<<"$card_out" \
  && echo "  OK: status card shows activity" \
  || { echo "  FAIL: status card" >&2; fail=1; }

# registry ignores missing project roots
_reg="$HOME/.gemini/antigravity/.active_run_context.json"
mkdir -p "$(dirname "$_reg")"
_reg_backup=""
[[ -f "$_reg" ]] && _reg_backup="$(mktemp)" && cp "$_reg" "$_reg_backup"
printf '{"project_root":"%s","run_id":"RUN-stale","agent":"grok","status":"active","last_heartbeat":"%s"}\n' \
  "$TMP/nonexistent-project" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$_reg"
status_local="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status --json)"
python3 -c "import json,sys; d=json.load(sys.stdin); assert d.get('project')==sys.argv[1]" "$PROJECT" <<<"$status_local" \
  && echo "  OK: stale registry ignored" \
  || { echo "  FAIL: stale registry" >&2; fail=1; }
if [[ -n "$_reg_backup" ]]; then cp "$_reg_backup" "$_reg"; rm -f "$_reg_backup"; else rm -f "$_reg"; fi

# watch auto-starts telemetry when no session
watch_project="$TMP/watch-project"
mkdir -p "$watch_project/work/telemetry/runs"
cp "$ROOT/templates/project-starter/ai-dev-os.yaml" "$watch_project/ai-dev-os.yaml"
sed -i '' "s|{{PROJECT_NAME}}|watch-project|g" "$watch_project/ai-dev-os.yaml" 2>/dev/null \
  || sed -i "s|{{PROJECT_NAME}}|watch-project|g" "$watch_project/ai-dev-os.yaml"
[[ -f "$watch_project/work/telemetry/.current-run" ]] && rm -f "$watch_project/work/telemetry/.current-run"
watch_out="$(cd "$watch_project" && "$ROOT/scripts/observe.sh" watch --interval 1 2>&1 & wp=$!; sleep 2; kill $wp 2>/dev/null; wait $wp 2>/dev/null || true)"
[[ -f "$watch_project/work/telemetry/.current-run" ]] \
  && echo "  OK: watch auto-starts session" \
  || { echo "  FAIL: watch auto-start" >&2; fail=1; }
grep -q 'Started telemetry session:' <<<"$watch_out" \
  && echo "  OK: watch announces new session" \
  || { echo "  FAIL: watch session message" >&2; fail=1; }

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1