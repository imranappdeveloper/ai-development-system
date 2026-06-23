#!/usr/bin/env bash
# setup-graphify.sh — install graphify CLI, post-commit hook, optional initial build
#
# Idempotent. Safe to re-run. Called by ai-new after git init.
#
# Usage:
#   setup-graphify.sh [project_dir] [--build] [--skip-build] [--hook-only]
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }
warn() { echo "  WARN: $1"; }

usage() {
  cat <<EOF
AI Development OS — graphify setup

Usage:
  $(basename "$0") [project_dir] [--build] [--skip-build] [--hook-only]

Defaults:
  - Install graphify CLI if missing (uv tool or pip)
  - Install post-commit hook when .git exists
  - Initial build (--no-viz) on existing projects with app code, if graph missing

Flags:
  --build       Force initial graph build even if graph.json exists
  --skip-build  Hook + CLI only — no initial build
  --hook-only   Alias for --skip-build

EOF
}

dir_has_app_content() {
  local dir="$1"
  local count
  count="$(find "$dir" -mindepth 1 -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' \
    ! -name 'AGENTS.md' ! -name 'ai-dev-os.yaml' ! -name 'README.md' \
    ! -name 'work' ! -name 'docs' ! -name 'CONTEXT.md' \
    ! -name 'graphify-out' \
    2>/dev/null | wc -l | tr -d ' ')"
  [[ "${count:-0}" -gt 0 ]]
}

ensure_graphify_cli() {
  if command -v graphify >/dev/null 2>&1; then
    info "graphify — $(command -v graphify)"
    return 0
  fi

  info "graphify — not found, installing..."
  if command -v uv >/dev/null 2>&1; then
    uv tool install --upgrade graphifyy -q 2>&1 | tail -3 || true
  else
    local py="python3"
    "$py" -m pip install graphifyy -q 2>/dev/null \
      || "$py" -m pip install graphifyy -q --break-system-packages 2>&1 | tail -3 || true
  fi

  if command -v graphify >/dev/null 2>&1; then
    info "graphify — installed → $(command -v graphify)"
    return 0
  fi

  warn "graphify CLI not available — skip hook and build (install uv or pip graphifyy manually)"
  return 1
}

ensure_gitignore_graphify() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  local marker="# graphify cache (graph.json + GRAPH_REPORT.md may be committed)"
  if grep -qF "$marker" "$file" 2>/dev/null; then
    return 0
  fi
  cat >>"$file" <<'GITIGNORE'

# graphify cache (graph.json + GRAPH_REPORT.md may be committed)
graphify-out/.graphify_*
graphify-out/.graphify_chunk_*.json
GITIGNORE
  info ".gitignore — ensured graphify cache entries"
}

install_hook() {
  local dir="$1"
  if [[ ! -d "$dir/.git" ]]; then
    warn "graphify hook — no git repo, skipped"
    return 0
  fi
  if ! command -v graphify >/dev/null 2>&1; then
    return 0
  fi
  local status
  status="$(cd "$dir" && graphify hook status 2>/dev/null || true)"
  if echo "$status" | grep -qi 'installed'; then
    info "graphify hook — already installed"
    return 0
  fi
  (cd "$dir" && graphify hook install)
  info "graphify hook — post-commit installed"
}

run_initial_build() {
  local dir="$1"
  local force="${2:-false}"

  if ! command -v graphify >/dev/null 2>&1; then
    return 0
  fi
  if [[ ! -d "$dir/.git" ]]; then
    warn "graphify build — no git repo, skipped"
    return 0
  fi
  if ! dir_has_app_content "$dir"; then
    info "graphify build — greenfield/empty, skipped (hook updates after commits)"
    return 0
  fi
  if [[ "$force" != "true" && -f "$dir/graphify-out/graph.json" ]]; then
    info "graphify build — graph.json exists, skipped (use --build to force)"
    return 0
  fi

  info "graphify build — running initial scan (--no-viz)..."
  if (cd "$dir" && graphify . --no-viz); then
    if [[ -f "$dir/graphify-out/graph.json" ]]; then
      info "graphify build — graph.json ready"
      return 0
    fi
    warn "graphify build — command ok but graph.json missing"
    return 1
  fi
  warn "graphify build — failed (re-run: graphify . --no-viz)"
  return 1
}

verify_graph_json() {
  local dir="$1"
  [[ -f "$dir/graphify-out/graph.json" ]]
}

main() {
  local project_dir="."
  local do_build="auto"
  local force_build=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      --build)
        force_build=true
        do_build="yes"
        shift
        ;;
      --skip-build|--hook-only)
        do_build="no"
        shift
        ;;
      -*)
        die "Unknown flag: $1"
        ;;
      *)
        project_dir="$1"
        shift
        ;;
    esac
  done

  if [[ "$project_dir" == "." ]]; then
    project_dir="$(pwd)"
  elif [[ "$project_dir" != /* ]]; then
    project_dir="$(cd "$(dirname "$project_dir")" && pwd)/$(basename "$project_dir")"
  fi

  [[ -d "$project_dir" ]] || die "Not a directory: $project_dir"

  echo "=== AI Development OS — graphify setup ==="
  info "Project: $project_dir"

  ensure_gitignore_graphify "$project_dir/.gitignore"

  if ! ensure_graphify_cli; then
    echo ""
    echo "=== graphify setup incomplete (CLI missing) ==="
    exit 0
  fi

  install_hook "$project_dir"

  local build_rc=0
  case "$do_build" in
    yes)
      run_initial_build "$project_dir" "$force_build" || build_rc=1
      ;;
    no)
      info "graphify build — skipped (--skip-build)"
      ;;
    auto)
      run_initial_build "$project_dir" false || build_rc=1
      ;;
  esac

  if ! verify_graph_json "$project_dir"; then
    if [[ "$do_build" != "no" ]]; then
      warn "graphify verify — graph.json missing, retrying with --build"
      run_initial_build "$project_dir" true || build_rc=1
    fi
  fi

  echo ""
  if verify_graph_json "$project_dir"; then
    echo "=== graphify ready ==="
    echo "  Graph:  $project_dir/graphify-out/graph.json"
    echo "  Query:  cd $project_dir && graphify query \"<question>\""
    echo "  Screen: resolve-screen.sh --phrase \"login screen\" --json"
    echo "  Update: graphify . --update"
    echo "  Hook:   graphify hook status"
  else
    echo "=== graphify setup incomplete ==="
    echo "  graph.json missing — Graphify MCP and resolve-screen need a build."
    echo "  Fix:    cd $project_dir && graphify . --no-viz"
    echo "  Or:     setup-graphify.sh . --build"
    if command -v graphify >/dev/null 2>&1 && dir_has_app_content "$project_dir"; then
      build_rc=1
    fi
  fi

  return "$build_rc"
}

main "$@"
exit $?