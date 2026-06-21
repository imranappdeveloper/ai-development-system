#!/usr/bin/env bash
# local-survey.sh — read local_survey settings from ai-dev-os.local.yaml (M2)

_local_survey_yaml_value() {
  local file="$1"
  local key="$2"
  [[ -f "$file" ]] || return 0
  awk -v want="$key" '
    /^local_survey:/ { in_ls=1; next }
    in_ls && /^[a-zA-Z_]/ && $0 !~ /^[[:space:]]/ { in_ls=0 }
    in_ls && $1 ~ /^[[:space:]]*(enabled|ollama_model|ollama_host):/ {
      k=$1
      gsub(/^[[:space:]]+|:$/, "", k)
      if (k == want) {
        $1=""
        gsub(/^[[:space:]]+/, "")
        gsub(/"/, "")
        gsub(/\047/, "")
        print
        exit
      }
    }
  ' "$file" 2>/dev/null || true
}

# Echo: enabled|model|host|state
# state: ready | disabled | enabled-no-ollama | enabled-unreachable
local_survey_status() {
  local project_dir="${1:-.}"
  local os_home="${AI_DEV_OS_HOME:-}"
  local local_yaml="$project_dir/ai-dev-os.local.yaml"
  local enabled="" model="" host=""
  local explicit_enabled=false

  if [[ -f "$local_yaml" ]]; then
    enabled="$(_local_survey_yaml_value "$local_yaml" enabled)"
    model="$(_local_survey_yaml_value "$local_yaml" ollama_model)"
    host="$(_local_survey_yaml_value "$local_yaml" ollama_host)"
    [[ -n "$enabled" ]] && explicit_enabled=true
  fi

  if [[ "$explicit_enabled" != true ]]; then
    if command -v ollama >/dev/null 2>&1; then
      enabled="true"
    else
      enabled="false"
    fi
  fi

  model="${model:-qwen2.5-coder:14b}"
  host="${host:-http://127.0.0.1:11434}"

  local state="disabled"
  local enabled_lc
  enabled_lc="$(printf '%s' "$enabled" | tr '[:upper:]' '[:lower:]')"
  case "$enabled_lc" in
    true|yes|1)
      if ! command -v ollama >/dev/null 2>&1; then
        state="enabled-no-ollama"
      elif python3 -c "import urllib.request; urllib.request.urlopen('${host}/api/tags', timeout=2)" >/dev/null 2>&1; then
        state="ready"
      else
        state="enabled-unreachable"
      fi
      ;;
    *)
      state="disabled"
      ;;
  esac

  printf '%s|%s|%s|%s\n' "$enabled" "$model" "$host" "$state"
}

local_survey_server_path() {
  local os_home="${AI_DEV_OS_HOME:-}"
  if [[ -z "$os_home" ]]; then
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    os_home="$script_dir"
  fi
  echo "$os_home/mcp/codebase-survey/server.py"
}