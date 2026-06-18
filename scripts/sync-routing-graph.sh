#!/usr/bin/env bash
# sync-routing-graph.sh — validate routing-matrix skill statuses match playbook registries
# Usage: ./scripts/sync-routing-graph.sh
# Exit 0 with WARN on drift (non-blocking); exit 1 on parse/load errors
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ROUTING_MATRIX="workflows/project-orchestrator/routing-matrix.yaml"
WARN=0

warn() { echo "  WARN: $1"; WARN=$((WARN + 1)); }
pass() { echo "  PASS: $1"; }

if [[ ! -f "$ROUTING_MATRIX" ]]; then
  echo "FAIL: routing matrix not found: $ROUTING_MATRIX"
  exit 1
fi

echo "=== sync-routing-graph: $ROUTING_MATRIX vs playbooks/*/registry.yaml ==="

# Extract PB-* skill ids and statuses from routing-matrix skills section
mapfile -t SKILL_LINES < <(
  awk '
    /^skills:/ { in_skills=1; next }
    in_skills && /^[^ ]/ && !/^  / { in_skills=0 }
    in_skills && /^  PB-/ {
      skill=$1
      sub(/:$/, "", skill)
      print skill
      getline
      while ($0 ~ /^    / && $0 !~ /^    status:/) getline
      if ($0 ~ /^    status:/) {
        status=$2
        print skill "|" status
      }
    }
  ' "$ROUTING_MATRIX" | awk 'NR%2==1 { id=$0; getline; print id "|" $0 }'
)

# Simpler approach: parse with grep/sed pairs
declare -A ROUTING_STATUS=()
current_skill=""
while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]{2}(PB-[^:]+):$ ]]; then
    current_skill="${BASH_REMATCH[1]}"
  elif [[ -n "$current_skill" && "$line" =~ ^[[:space:]]{4}status:[[:space:]]+(.+)$ ]]; then
    ROUTING_STATUS["$current_skill"]="${BASH_REMATCH[1]}"
    current_skill=""
  fi
done < <(awk '/^skills:/{found=1} found{print} /^[a-z]/ && !/^skills:/{if(found) exit}' "$ROUTING_MATRIX")

skill_to_dir() {
  local skill_id="$1"
  local slug="${skill_id#PB-}"
  echo "playbooks/${slug}"
}

for skill_id in "${!ROUTING_STATUS[@]}"; do
  routing_status="${ROUTING_STATUS[$skill_id]}"
  skill_dir="$(skill_to_dir "$skill_id")"
  registry="${skill_dir}/registry.yaml"

  if [[ ! -f "$registry" ]]; then
    warn "$skill_id — registry missing ($registry); routing-matrix status=$routing_status"
    continue
  fi

  registry_status="$(grep -m1 '^status:' "$registry" | awk '{print $2}' || echo unknown)"

  if [[ "$registry_status" == "$routing_status" ]]; then
    pass "$skill_id status=$registry_status (aligned)"
  else
    warn "$skill_id drift — routing-matrix=$routing_status registry=$registry_status"
  fi
done

echo "=== Summary: sync-routing-graph — WARN=$WARN ==="
exit 0