#!/usr/bin/env bash
# ads-preflight.sh — blocking checks for /ads session preflight (structured JSON)
#
# Usage:
#   ads-preflight.sh [project-dir] [--json] [--quiet]
#
# Exit 0 = all blocking checks pass; exit 1 = blocking failure
# --json always prints JSON to stdout (human summary to stderr unless --quiet)
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"

PROJECT_DIR=""
JSON=false
QUIET=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON=true; shift ;;
    --quiet) QUIET=true; shift ;;
    -h|--help)
      cat <<EOF
ADS session preflight — blocking checks for /ads

Usage:
  $(basename "$0") [project-dir] [--json] [--quiet]

Blocking: check-cli, ai-paths, AGENTS.md, ai-dev-os.yaml, docs/agents/* (5 files)
Warn-only: telemetry scaffolds, observe CLI, local survey state

Exit 0 = ready; exit 1 = fix blocking items first
EOF
      exit 0
      ;;
    -*) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    *)
      [[ -z "$PROJECT_DIR" ]] || { echo "ERROR: Unexpected argument: $1" >&2; exit 1; }
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

[[ -z "$PROJECT_DIR" ]] && PROJECT_DIR="$(pwd)"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
[[ -d "$PROJECT_DIR" ]] || { echo "ERROR: Not a directory: $PROJECT_DIR" >&2; exit 1; }

export AI_DEV_OS_HOME="${AI_DEV_OS_HOME:-$OS_HOME}"
export OBSERVE_PROJECT_ROOT="$PROJECT_DIR"
# shellcheck source=scripts/lib/observe-script-log.sh
source "$OS_HOME/scripts/lib/observe-script-log.sh"
_observe_script_log_begin "ads-preflight.sh" "$*"
trap '_observe_script_log_finish $?' EXIT

declare -a CHECK_IDS=()
declare -a CHECK_STATUSES=()
declare -a CHECK_MESSAGES=()
declare -a WARNINGS=()
blocking_fail=false

_add_check() {
  CHECK_IDS+=("$1")
  CHECK_STATUSES+=("$2")
  CHECK_MESSAGES+=("$3")
  if [[ "$2" == "fail" ]]; then
    blocking_fail=true
  fi
}

_add_warn() {
  WARNINGS+=("$1")
}

_log() {
  [[ "$QUIET" == true || "$JSON" == true ]] || echo "  $1" >&2
}

# --- Blocking: CLI ---
if "$OS_HOME/scripts/check-cli.sh" --quiet 2>/dev/null; then
  _add_check "check-cli" "ok" "CLI and bundled skills ready"
  _log "OK: check-cli"
else
  _add_check "check-cli" "fail" "Run: cd \$AI_DEV_OS_HOME && ./scripts/install-cli.sh && source ~/.zshrc"
  _log "FAIL: check-cli"
fi

# --- Blocking: ai-paths ---
if ( cd "$PROJECT_DIR" && "$OS_HOME/scripts/ai-paths.sh" check >/dev/null 2>&1 ); then
  _add_check "ai-paths" "ok" "AI_DEV_OS_HOME resolvable from project"
  _log "OK: ai-paths check"
else
  _add_check "ai-paths" "fail" "AI_DEV_OS_HOME not resolvable — run install-cli.sh"
  _log "FAIL: ai-paths check"
fi

# --- Blocking: project binding ---
if [[ -f "$PROJECT_DIR/AGENTS.md" ]]; then
  _add_check "agents-md" "ok" "AGENTS.md present"
  _log "OK: AGENTS.md"
else
  _add_check "agents-md" "fail" "AGENTS.md missing — run: ai-new ."
  _log "FAIL: AGENTS.md"
fi

if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]]; then
  _add_check "ai-dev-os-yaml" "ok" "ai-dev-os.yaml present"
  _log "OK: ai-dev-os.yaml"
else
  _add_check "ai-dev-os-yaml" "fail" "ai-dev-os.yaml missing — run: ai-new ."
  _log "FAIL: ai-dev-os.yaml"
fi

# --- Blocking: docs/agents/ ---
agent_docs=(issue-tracker.md triage-labels.md domain.md engineering-standards.md task-run.md)
agents_dir="$PROJECT_DIR/docs/agents"
missing_agent_docs=()

if [[ -d "$agents_dir" ]]; then
  for doc in "${agent_docs[@]}"; do
    if [[ -f "$agents_dir/$doc" ]]; then
      _add_check "docs-agents-$doc" "ok" "docs/agents/$doc present"
      _log "OK: docs/agents/$doc"
    else
      missing_agent_docs+=("$doc")
      _add_check "docs-agents-$doc" "fail" "docs/agents/$doc missing — run: /setup-project-agents"
      _log "FAIL: docs/agents/$doc"
    fi
  done
else
  for doc in "${agent_docs[@]}"; do
    _add_check "docs-agents-$doc" "fail" "docs/agents/ missing — run: /setup-project-agents"
    _log "FAIL: docs/agents/ (need $doc)"
  done
fi

# --- Warn-only: telemetry / observe scaffolds ---
for dir in work docs; do
  if [[ -d "$PROJECT_DIR/$dir" ]]; then
    _add_check "dir-$dir" "ok" "$dir/ present"
  else
    _add_check "dir-$dir" "warn" "$dir/ missing — run: ai-new ."
    _add_warn "$dir/ missing — run: ai-new ."
  fi
done

if [[ -d "$PROJECT_DIR/work/telemetry/runs" ]]; then
  _add_check "telemetry-runs" "ok" "work/telemetry/runs/ present"
else
  _add_check "telemetry-runs" "warn" "work/telemetry/runs/ missing — run: ai-new . or /sync-project"
  _add_warn "work/telemetry/runs/ missing — observe may not persist traces"
fi

for ts in observe.sh observe-event.sh; do
  if [[ -x "$OS_HOME/scripts/$ts" ]]; then
    _add_check "script-$ts" "ok" "scripts/$ts present"
  else
    _add_check "script-$ts" "warn" "scripts/$ts missing — run: /sync-project"
    _add_warn "scripts/$ts missing"
  fi
done

# --- Warn-only: local survey state (agent runs live MCP probe separately) ---
# shellcheck source=scripts/lib/local-survey.sh
source "$OS_HOME/scripts/lib/local-survey.sh"
IFS='|' read -r _ls_enabled _ls_model _ls_host _ls_state <<<"$(local_survey_status "$PROJECT_DIR")"
case "$_ls_state" in
  ready)
    _add_check "local-survey" "ok" "local survey ready (Ollama $_ls_model)"
    ;;
  disabled)
    _add_check "local-survey" "ok" "local survey disabled (cloud-only OK)"
    ;;
  enabled-no-ollama)
    _add_check "local-survey" "warn" "local_survey enabled but ollama not on PATH"
    _add_warn "local survey enabled but Ollama missing — cloud fallback only"
    ;;
  enabled-unreachable)
    _add_check "local-survey" "warn" "Ollama unreachable at $_ls_host"
    _add_warn "Ollama unreachable — run: ollama serve && ollama pull $_ls_model"
    ;;
    *)
    _add_check "local-survey" "warn" "local survey state unknown ($_ls_state)"
    _add_warn "local survey state unknown"
    ;;
esac

# --- Warn-only: graphify (screen resolver + MCP) ---
_graphify_state="missing-graph"
_graphify_hook=false
if command -v graphify >/dev/null 2>&1; then
  if [[ -f "$PROJECT_DIR/graphify-out/graph.json" ]]; then
    _graphify_state="ready"
    _add_check "graphify" "ok" "graphify-out/graph.json present"
    _log "OK: graphify graph.json"
  else
    _add_check "graphify" "warn" "graph.json missing — run: setup-graphify.sh . --build"
    _add_warn "graphify graph.json missing — resolve-screen and Graphify MCP need a build"
    _log "WARN: graphify graph.json missing"
  fi
  if [[ -d "$PROJECT_DIR/.git" ]] \
    && grep -qF 'graphify' "$PROJECT_DIR/.git/hooks/post-commit" 2>/dev/null; then
    _graphify_hook=true
    _add_check "graphify-hook" "ok" "post-commit hook installed"
  else
    _add_check "graphify-hook" "warn" "post-commit hook missing — run: setup-graphify.sh ."
    _add_warn "graphify hook missing — graph will not auto-update on commit"
    _log "WARN: graphify hook"
  fi
else
  _graphify_state="cli-missing"
  _add_check "graphify" "warn" "graphify CLI not on PATH — optional; install via setup-graphify.sh"
  _add_warn "graphify CLI missing — screen resolver falls back to aliases only"
  _log "WARN: graphify CLI missing"
fi

# --- JSON output ---
overall="ok"
[[ "$blocking_fail" == true ]] && overall="fail"

export ADS_PREFLIGHT_PROJECT="$PROJECT_DIR"
export ADS_PREFLIGHT_OVERALL="$overall"
export ADS_PREFLIGHT_LS_ENABLED="$_ls_enabled"
export ADS_PREFLIGHT_LS_STATE="$_ls_state"
export ADS_PREFLIGHT_LS_MODEL="$_ls_model"
export ADS_PREFLIGHT_GRAPHIFY_STATE="$_graphify_state"
export ADS_PREFLIGHT_GRAPHIFY_HOOK="$_graphify_hook"

# Build JSON with python reading from env-encoded data
_checks_payload=""
for i in "${!CHECK_IDS[@]}"; do
  _checks_payload+="${CHECK_IDS[$i]}"$'\t'"${CHECK_STATUSES[$i]}"$'\t'"${CHECK_MESSAGES[$i]}"$'\n'
done
_warn_payload=""
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
  for w in "${WARNINGS[@]}"; do
    _warn_payload+="$w"$'\n'
  done
fi

export ADS_CHECKS_PAYLOAD="$_checks_payload"
export ADS_WARN_PAYLOAD="$_warn_payload"

json_out="$(python3 - <<'PY'
import json, os

checks = []
for line in os.environ.get("ADS_CHECKS_PAYLOAD", "").splitlines():
    if not line.strip():
        continue
    parts = line.split("\t", 2)
    if len(parts) == 3:
        checks.append({"id": parts[0], "status": parts[1], "message": parts[2]})

warnings = [w for w in os.environ.get("ADS_WARN_PAYLOAD", "").splitlines() if w.strip()]

doc = {
    "status": os.environ.get("ADS_PREFLIGHT_OVERALL", "fail"),
    "project": os.environ.get("ADS_PREFLIGHT_PROJECT", ""),
    "local_survey": {
        "enabled": os.environ.get("ADS_PREFLIGHT_LS_ENABLED", "") == "true",
        "state": os.environ.get("ADS_PREFLIGHT_LS_STATE", ""),
        "model": os.environ.get("ADS_PREFLIGHT_LS_MODEL", ""),
        "probe_recommended": os.environ.get("ADS_PREFLIGHT_LS_STATE", "") not in ("disabled",),
    },
    "graphify": {
        "state": os.environ.get("ADS_PREFLIGHT_GRAPHIFY_STATE", ""),
        "hook_installed": os.environ.get("ADS_PREFLIGHT_GRAPHIFY_HOOK", "") == "true",
        "fix_hint": "setup-graphify.sh . --build" if os.environ.get("ADS_PREFLIGHT_GRAPHIFY_STATE", "") != "ready" else "",
    },
    "checks": checks,
    "warnings": warnings,
}
print(json.dumps(doc, indent=2))
PY
)"

if [[ "$JSON" == true ]]; then
  printf '%s\n' "$json_out"
else
  [[ "$QUIET" != true ]] && echo "=== ADS preflight ===" >&2
  [[ "$QUIET" != true ]] && echo "  Project: $PROJECT_DIR" >&2
  [[ "$QUIET" != true ]] && printf '%s\n' "$json_out" >&2
fi

if [[ "$blocking_fail" == true ]]; then
  [[ "$QUIET" != true && "$JSON" != true ]] && echo "Status: NOT READY — fix blocking checks" >&2
  exit 1
fi

[[ "$QUIET" != true && "$JSON" != true ]] && echo "Status: READY" >&2
exit 0