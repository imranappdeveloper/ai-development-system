#!/usr/bin/env bash
# simulate-workflow.sh — walk WF phases.yaml and assert playbooks are invokable
# Usage: ./scripts/simulate-workflow.sh [WF-ID|all]
# Exit 0 when all required playbooks in each workflow are status: active
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WF_FILTER="${1:-all}"
REGISTRY="workflows/WORKFLOW-REGISTRY.yaml"
ROUTING="workflows/project-orchestrator/routing-matrix.yaml"
GATES="workflows/project-orchestrator/gates.yaml"
FAIL=0
WARN=0

fail() { echo "  FAIL: $1"; FAIL=$((FAIL + 1)); }
warn() { echo "  WARN: $1"; WARN=$((WARN + 1)); }
pass() { echo "  PASS: $1"; }

skill_to_dir() {
  local skill_id="$1"
  local slug="${skill_id#PB-}"
  echo "playbooks/${slug}"
}

routing_optional() {
  local skill_id="$1"
  awk -v s="$skill_id" '
    $0 ~ "^  " s ":" { found=1; next }
    found && /^  [A-Z]/ { exit }
    found && /^    optional:/ { print $2; exit }
  ' "$ROUTING" 2>/dev/null || echo "false"
}

gate_waived_for_workflow() {
  local wf_id="$1"
  local gate_id="$2"
  awk -v wf="$wf_id" -v g="$gate_id" '
    $0 ~ "^  " wf ":" { in_wf=1; next }
    in_wf && /^  [A-Z]/ { exit }
    in_wf && $0 ~ "^  - " g "$" { found=1 }
    END { if (found) print "true"; else print "false" }
  ' "$GATES" 2>/dev/null
}

check_workflow_spec() {
  local wf_id="$1"
  local spec_line
  spec_line="$(awk -v wf="$wf_id" '
    $0 ~ "^  " wf ":" { found=1; next }
    found && /^  [A-Z]/ { exit }
    found && /spec:/ { print $2; exit }
  ' "$REGISTRY" 2>/dev/null || true)"

  if [[ -z "$spec_line" || "$spec_line" == "null" ]]; then
    warn "$wf_id: workflow spec null (phases-only)"
    return
  fi

  local spec_path="workflows/${spec_line}"
  if [[ -f "$spec_path" ]]; then
    pass "$wf_id: spec $spec_line"
  else
    fail "$wf_id: spec missing at $spec_path"
  fi
}

simulate_workflow() {
  local wf_id="$1"
  local phases_file="workflows/${wf_id}/phases.yaml"

  echo "=== simulate-workflow: $wf_id ==="

  if [[ ! -f "$phases_file" ]]; then
    fail "$wf_id: phases.yaml missing ($phases_file)"
    return
  fi

  check_workflow_spec "$wf_id"

  mapfile -t PLAYBOOKS < <(
    grep -E 'playbook: PB-' "$phases_file" \
      | sed -E 's/.*playbook: (PB-[^[:space:]]+).*/\1/' \
      | sort -u
  )

  if [[ ${#PLAYBOOKS[@]} -eq 0 ]]; then
    warn "$wf_id: no playbooks in execution_sequence"
    return
  fi

  mapfile -t GATES_IN_WF < <(
    grep -E 'gate: H-' "$phases_file" \
      | sed -E 's/.*gate: (H-[^[:space:]]+).*/\1/' \
      | sort -u
  )

  for gate in "${GATES_IN_WF[@]}"; do
    if [[ "$(gate_waived_for_workflow "$wf_id" "$gate")" == "true" ]]; then
      pass "$wf_id: gate $gate waived per gates.yaml"
    fi
  done

  for pb in "${PLAYBOOKS[@]}"; do
    local dir reg status optional
    dir="$(skill_to_dir "$pb")"
    reg="$dir/registry.yaml"

    if [[ ! -f "$reg" ]]; then
      fail "$wf_id: $pb — registry missing ($reg)"
      continue
    fi

    status="$(grep '^status:' "$reg" | awk '{print $2}')"
    optional="$(routing_optional "$pb")"

    if [[ "$status" == "active" ]]; then
      pass "$wf_id: $pb status=active"
    elif [[ "$optional" == "true" ]]; then
      warn "$wf_id: $pb status=$status (optional — not in default invoke path)"
    else
      fail "$wf_id: $pb status=$status — blocks workflow execution"
    fi
  done
}

list_workflows() {
  find workflows -maxdepth 1 -type d -name 'WF-*' -printf '%f\n' | sort
}

if [[ "$WF_FILTER" == "all" ]]; then
  while IFS= read -r wf; do
    simulate_workflow "$wf"
  done < <(list_workflows)
else
  simulate_workflow "$WF_FILTER"
fi

echo "=== Summary: simulate-workflow — FAIL=$FAIL WARN=$WARN ==="
[[ "$FAIL" -eq 0 ]] && exit 0 || exit 1