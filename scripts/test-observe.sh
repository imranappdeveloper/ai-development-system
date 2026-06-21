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

status_json="$(cd "$PROJECT" && "$ROOT/scripts/observe.sh" status --json)"
grep -q '"telemetry_level":"verbose"' <<<"$status_json" && echo "  OK: status json level" \
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

echo ""
if [[ $fail -eq 0 ]]; then
  echo "=== ALL OK ==="
  exit 0
fi
echo "=== FAILED ==="
exit 1