#!/usr/bin/env bash
# setup-local-survey.sh — register codebase-survey MCP on Mac (Cursor + agy + Grok); optional on Ubuntu
#
# Usage:
#   setup-local-survey.sh [project_dir] [--dry-run]
#   setup-local-survey.sh --status [project_dir]
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"

# shellcheck source=scripts/lib/local-survey.sh
source "$OS_HOME/scripts/lib/local-survey.sh"

PROJECT_DIR="$(pwd)"
DRY_RUN=false
MODE=setup

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --status) MODE=status; shift ;;
    -h|--help)
      cat <<EOF
Register optional local Ollama codebase-survey MCP for Cursor + agy + Grok (Mac interactive).

Usage:
  $(basename "$0") [project_dir] [--dry-run]
  $(basename "$0") --status [project_dir]

Reads local_survey from ai-dev-os.local.yaml (M2 auto-detect if omitted).
Ubuntu AFK: keep local_survey.enabled: false — script prints skip, no config changes.

Does not modify Ubuntu server task-run. Fails closed to cloud when Ollama is down.
EOF
      exit 0
      ;;
    -*) die "unknown option: $1" ;;
    *) PROJECT_DIR="$(cd "$1" && pwd)"; shift ;;
  esac
done

export AI_DEV_OS_HOME="${AI_DEV_OS_HOME:-$OS_HOME}"
SERVER_PY="$(local_survey_server_path)"
[[ -f "$SERVER_PY" ]] || die "missing MCP server: $SERVER_PY"

IFS='|' read -r enabled model host state <<<"$(local_survey_status "$PROJECT_DIR")"

if [[ "$MODE" == status ]]; then
  echo "local_survey.enabled: $enabled"
  echo "ollama_model: $model"
  echo "ollama_host: $host"
  echo "state: $state"
  echo "server: $SERVER_PY"
  echo "cursor: ${HOME}/.cursor/mcp.json"
  echo "agy: ${HOME}/.gemini/config/mcp_config.json"
  echo "grok: ${HOME}/.grok/config.toml"
  exit 0
fi

if [[ "$state" == "disabled" ]]; then
  info "local_survey disabled — no MCP registration (Ubuntu AFK / cloud-only OK)"
  info "To enable on Mac: add local_survey.enabled: true to ai-dev-os.local.yaml"
  exit 0
fi

if [[ "$state" == "enabled-no-ollama" ]]; then
  die "local_survey enabled but ollama not on PATH — install Ollama or set enabled: false"
fi

if [[ "$state" == "enabled-unreachable" ]]; then
  echo "WARN: Ollama not reachable at $host — MCP will register; agy/Grok fall back to cloud until ollama serve runs" >&2
fi

CURSOR_MCP="${HOME}/.cursor/mcp.json"
AGY_MCP="${HOME}/.gemini/config/mcp_config.json"
GROK_CFG="${HOME}/.grok/config.toml"

mcp_server_entry() {
  python3 - "$SERVER_PY" "$model" "$host" <<'PY'
import json, sys
server, model, host = sys.argv[1:4]
entry = {
    "command": "python3",
    "args": ["-u", server],
    "timeout": 180,
    "env": {
        "OLLAMA_MODEL": model,
        "OLLAMA_HOST": host,
        "PYTHONPATH": __import__("os").path.dirname(server),
        "PYTHONUNBUFFERED": "1",
    },
}
print(json.dumps(entry, indent=2))
PY
}

agy_snippet() {
  mcp_server_entry
}

grok_snippet() {
  cat <<EOF
[mcp_servers.codebase-survey]
command = "python3"
args = ["-u", "$SERVER_PY"]
enabled = true
startup_timeout_sec = 30
tool_timeout_sec = 180
tool_timeouts = { survey = 180 }
env = { OLLAMA_MODEL = "$model", OLLAMA_HOST = "$host", PYTHONPATH = "$(dirname "$SERVER_PY")", PYTHONUNBUFFERED = "1" }
EOF
}

info "state: $state"
info "model: $model"
info "cursor config: $CURSOR_MCP"
info "agy config: $AGY_MCP"
info "grok config: $GROK_CFG"
echo ""
echo "--- Add to ~/.cursor/mcp.json under mcpServers.codebase-survey ---"
mcp_server_entry
echo ""
echo "--- Add to ~/.gemini/config/mcp_config.json under mcpServers.codebase-survey ---"
agy_snippet
echo ""
echo "--- Add to ~/.grok/config.toml ---"
grok_snippet
echo ""
info "Pull model once: ollama pull $model"
info "Keep one model loaded: export OLLAMA_MAX_LOADED_MODELS=1"

if [[ "$DRY_RUN" == true ]]; then
  info "dry-run — configs not written (merge snippets manually or re-run without --dry-run)"
  exit 0
fi

_write_mcp_json() {
  local path="$1"
  python3 - "$path" "$SERVER_PY" "$model" "$host" <<'PY'
import json, pathlib, sys
path, server, model, host = sys.argv[1:5]
cfg = pathlib.Path(path)
if cfg.exists():
    data = json.loads(cfg.read_text(encoding="utf-8"))
else:
    data = {}
servers = data.setdefault("mcpServers", {})
servers["codebase-survey"] = {
    "command": "python3",
    "args": ["-u", server],
    "timeout": 180,
    "env": {
        "OLLAMA_MODEL": model,
        "OLLAMA_HOST": host,
        "PYTHONPATH": str(pathlib.Path(server).parent),
        "PYTHONUNBUFFERED": "1",
    },
}
cfg.parent.mkdir(parents=True, exist_ok=True)
cfg.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
print(f"  updated {path}")
PY
}

_write_mcp_json "$CURSOR_MCP"

if [[ -f "$AGY_MCP" ]]; then
  _write_mcp_json "$AGY_MCP"
else
  info "agy mcp_config.json not found — paste agy snippet above after first agy launch"
fi

if [[ -f "$GROK_CFG" ]]; then
  if ! grep -q '^\[mcp_servers\.codebase-survey\]' "$GROK_CFG" 2>/dev/null; then
    grok_snippet >>"$GROK_CFG"
    info "appended codebase-survey to $GROK_CFG"
  else
    info "grok already has [mcp_servers.codebase-survey] — verify paths manually"
  fi
else
  info "grok config.toml not found — paste grok snippet when using Grok"
fi

info "done — restart Cursor / agy / Grok session to load MCP"