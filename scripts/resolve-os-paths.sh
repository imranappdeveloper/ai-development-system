#!/usr/bin/env bash
# resolve-os-paths.sh — resolve AI_DEV_OS_HOME and project_root (portable, multi-machine)
# Source this file or call: resolve_os_paths [project_dir]
set -euo pipefail

resolve_os_paths() {
  local project_dir="${1:-$(pwd)}"
  local local_file="$project_dir/ai-dev-os.local.yaml"
  local os_home="" project_root=""

  # 1 — environment (primary)
  if [[ -n "${AI_DEV_OS_HOME:-}" && -d "${AI_DEV_OS_HOME}" ]]; then
    os_home="${AI_DEV_OS_HOME}"
  fi

  # 2 — per-machine local override (optional)
  if [[ -f "$local_file" ]]; then
    if [[ -z "$os_home" ]]; then
      os_home="$(grep -E '^[[:space:]]*ai_dev_os_home:[[:space:]]*' "$local_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//;s/"//g;s/'"'"'//g' || true)"
    fi
    project_root="$(grep -E '^[[:space:]]*project_root:[[:space:]]*' "$local_file" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//;s/"//g;s/'"'"'//g' || true)"
  fi

  # 3 — legacy absolute path in committed ai-dev-os.yaml (backward compat)
  local committed="$project_dir/ai-dev-os.yaml"
  if [[ -z "$os_home" && -f "$committed" ]]; then
    local legacy
    legacy="$(grep -E '^ai_dev_os_home:[[:space:]]*' "$committed" 2>/dev/null | head -1 | sed 's/.*:[[:space:]]*//;s/"//g' || true)"
    if [[ -n "$legacy" && "$legacy" != env:* && "$legacy" != auto && -d "$legacy" ]]; then
      os_home="$legacy"
    fi
  fi

  # 4 — infer OS from ai-new symlink location
  if [[ -z "$os_home" ]]; then
    local ai_new
    ai_new="$(command -v ai-new 2>/dev/null || true)"
    if [[ -L "$ai_new" ]]; then
      local target
      target="$(readlink "$ai_new" 2>/dev/null || true)"
      if [[ -n "$target" ]]; then
        os_home="$(cd "$(dirname "$target")/.." && pwd)"
      fi
    fi
  fi

  # project_root: auto = project dir containing ai-dev-os.yaml or cwd
  if [[ -z "$project_root" ]]; then
    if [[ -f "$project_dir/ai-dev-os.yaml" || -f "$project_dir/AGENTS.md" ]]; then
      project_root="$(cd "$project_dir" && pwd)"
    else
      project_root="$(pwd)"
    fi
  fi

  export AI_DEV_OS_HOME_RESOLVED="${os_home:-}"
  export PROJECT_ROOT_RESOLVED="${project_root}"
}

# When executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  resolve_os_paths "${1:-.}"
  echo "AI_DEV_OS_HOME=${AI_DEV_OS_HOME_RESOLVED:-<unset>}"
  echo "project_root=${PROJECT_ROOT_RESOLVED}"
  [[ -n "${AI_DEV_OS_HOME_RESOLVED:-}" ]] || exit 1
fi