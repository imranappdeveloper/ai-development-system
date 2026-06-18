#!/usr/bin/env bash
# new-project.sh — bind AI Dev OS to a project (new or existing)
#
# Idempotent: creates only what is missing — never overwrites AGENTS.md, ai-dev-os.yaml, README.md.
# Run from ANY directory. Default target is current folder (pwd).
#
# Usage:
#   ai-new                              # → current folder (new or existing repo)
#   ai-new .                            # → current folder
#   ai-new my-app "one-line idea"       # → ./my-app (creates dir if missing)
#   ai-new -i                           # interactive
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
ROOT="$(cd "$(dirname "$_self")/.." && pwd)"
TEMPLATE="$ROOT/templates/project-starter"
INVOKED_FROM="$(pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

usage() {
  cat <<EOF
AI Development OS — Project Setup (ai-new)

Idempotent bind for new OR existing projects. Creates only missing OS files.

Usage:
  $(basename "$0")                         Setup CURRENT folder
  $(basename "$0") .                       Setup CURRENT folder
  $(basename "$0") <name> ["one-line idea"]  Setup ./<name> (mkdir if missing)
  $(basename "$0") -i|--interactive
  $(basename "$0") -h|--help

Checks (create if missing, never overwrite):
  AGENTS.md  ai-dev-os.yaml  work/  docs/  .gitignore  git repo

Examples:
  # Existing Odoo addon repo:
  cd ~/odoo/auction && ai-new

  # New empty subfolder:
  cd ~/projects && ai-new my-api "REST API for quiet hours"

  # Greenfield in current dir:
  mkdir ~/projects/my-app && cd ~/projects/my-app && ai-new

After setup: grok  (or Antigravity) — type "start" or "Existing project: …"

Guide: $ROOT/docs/PROJECT-KICKOFF.md

EOF
}

resolve_project_dir() {
  local arg="$1"
  if [[ "$arg" == "." ]]; then
    pwd
  elif [[ "$arg" == /* ]]; then
    echo "$arg"
  elif [[ "$arg" == ./* || "$arg" == ../* ]]; then
    echo "$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")"
  else
    echo "$(pwd)/$arg"
  fi
}

project_name_from_dir() {
  local dir="$1"
  basename "$dir" | sed 's/[^a-zA-Z0-9._-]/-/g'
}

dir_has_app_content() {
  local dir="$1"
  local count
  count="$(find "$dir" -mindepth 1 -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' \
    ! -name 'AGENTS.md' ! -name 'ai-dev-os.yaml' ! -name 'README.md' \
    ! -name 'work' ! -name 'docs' ! -name 'CONTEXT.md' \
    2>/dev/null | wc -l | tr -d ' ')"
  [[ "${count:-0}" -gt 0 ]]
}

substitute() {
  local src="$1" dst="$2"
  local idea="$3"
  sed \
    -e "s|{{AI_DEV_OS_HOME}}|$ROOT|g" \
    -e "s|{{PROJECT_ROOT}}|$PROJECT_DIR|g" \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_IDEA}}|$idea|g" \
    "$src" > "$dst"
}

setup_os_binding() {
  local idea="$1"
  local created=0
  local skipped=0
  local is_existing=false

  if dir_has_app_content "$PROJECT_DIR"; then
    is_existing=true
  fi

  echo "=== AI Development OS — Project Setup ==="
  info "Project: $PROJECT_NAME"
  info "Location: $PROJECT_DIR"
  info "Invoked from: $INVOKED_FROM"
  info "OS home: $ROOT"
  if $is_existing; then
    info "Mode: existing project (additive — no overwrites)"
  else
    info "Mode: greenfield / empty folder"
  fi
  echo ""

  # --- AGENTS.md ---
  if [[ -f "$PROJECT_DIR/AGENTS.md" ]]; then
    info "AGENTS.md — exists, kept"
    skipped=$((skipped + 1))
  else
    substitute "$TEMPLATE/AGENTS.md" "$PROJECT_DIR/AGENTS.md" "$idea"
    info "AGENTS.md — created"
    created=$((created + 1))
  fi

  # --- ai-dev-os.yaml ---
  if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]]; then
    info "ai-dev-os.yaml — exists, kept"
    skipped=$((skipped + 1))
  else
    substitute "$TEMPLATE/ai-dev-os.yaml" "$PROJECT_DIR/ai-dev-os.yaml" "$idea"
    info "ai-dev-os.yaml — created"
    created=$((created + 1))
  fi

  # --- README.md ---
  if [[ -f "$PROJECT_DIR/README.md" ]]; then
    info "README.md — exists, kept"
    skipped=$((skipped + 1))
  else
    substitute "$TEMPLATE/README.md" "$PROJECT_DIR/README.md" "$idea"
    info "README.md — created"
    created=$((created + 1))
  fi

  # --- work/ docs/ ---
  mkdir -p "$PROJECT_DIR/work/kickoff" "$PROJECT_DIR/docs"
  touch "$PROJECT_DIR/work/.gitkeep" "$PROJECT_DIR/docs/.gitkeep" 2>/dev/null || true
  info "work/ docs/ — ready"

  # --- .gitignore ---
  if [[ -f "$PROJECT_DIR/.gitignore" ]]; then
    info ".gitignore — exists, kept"
    skipped=$((skipped + 1))
  else
    cat > "$PROJECT_DIR/.gitignore" <<'GITIGNORE'
# OS runtime (optional — commit work/ if you want artifact history)
# work/

.env
*.local
GITIGNORE
    info ".gitignore — created"
    created=$((created + 1))
  fi

  # --- git ---
  if [[ -d "$PROJECT_DIR/.git" ]]; then
    info "git — repo exists, kept"
    skipped=$((skipped + 1))
  elif command -v git >/dev/null 2>&1; then
    (cd "$PROJECT_DIR" && git init -q)
    info "git — initialized"
    created=$((created + 1))
  else
    info "git — not installed, skipped"
  fi

  echo ""
  if [[ $created -eq 0 ]]; then
    echo "=== Already fully bound ($skipped items unchanged) ==="
  else
    echo "=== Done — created $created item(s), kept $skipped existing ==="
  fi
  echo ""
  echo "Paths (check ai-dev-os.yaml):"
  echo "  ai_dev_os_home: $ROOT"
  echo "  project_root:   $PROJECT_DIR"
  echo ""
  echo "Open in your agent:"
  echo "  cd $PROJECT_DIR && grok"
  echo ""
  if $is_existing; then
    echo "In chat:"
    echo "  Existing project: <what you want on this codebase>"
  else
    echo "In chat:"
    echo "  start"
    if [[ -n "${PROJECT_IDEA:-}" ]]; then
      echo "  (idea: $PROJECT_IDEA)"
    fi
  fi
  echo ""
  echo "Guide: $ROOT/docs/PROJECT-KICKOFF.md"
}

main() {
  local project_arg="." idea_arg=""

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ "${1:-}" == "-i" || "${1:-}" == "--interactive" ]]; then
    echo "=== AI Development OS — Project Setup ==="
    echo "Current folder: $INVOKED_FROM"
    read -rp "Subfolder name (Enter = use current folder): " project_arg
    project_arg="${project_arg:-.}"
    read -rp "One-line idea (optional): " idea_arg
  elif [[ $# -ge 1 ]]; then
    project_arg="$1"
    if [[ $# -ge 2 ]]; then
      idea_arg="$2"
    fi
  fi

  PROJECT_DIR="$(resolve_project_dir "$project_arg")"
  PROJECT_NAME="$(project_name_from_dir "$PROJECT_DIR")"
  PROJECT_IDEA="$idea_arg"

  [[ -d "$TEMPLATE" ]] || die "Template missing: $TEMPLATE"

  # Create subfolder only when it does not exist
  if [[ "$project_arg" != "." && "$project_arg" != "./" ]]; then
    if [[ ! -e "$PROJECT_DIR" ]]; then
      mkdir -p "$PROJECT_DIR"
      info "Created directory: $PROJECT_DIR"
    fi
  fi

  [[ -d "$PROJECT_DIR" ]] || die "Not a directory: $PROJECT_DIR"

  local idea_text
  if [[ -n "$PROJECT_IDEA" ]]; then
    idea_text="$PROJECT_IDEA"
  elif dir_has_app_content "$PROJECT_DIR"; then
    idea_text="_(existing project — see CONTEXT.md)_"
  else
    idea_text="_(not set — agent will ask in Q1)_"
  fi

  setup_os_binding "$idea_text"
}

main "$@"