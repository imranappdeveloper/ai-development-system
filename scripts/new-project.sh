#!/usr/bin/env bash
# new-project.sh — scaffold a new project with grill-first AI Dev OS kickoff
#
# Run from ANY directory. Project is created relative to your current folder (pwd).
# OS path is resolved from this script's location — no need to cd into AI_DEV_OS_HOME.
#
# Usage:
#   /path/to/ai-development-system/scripts/new-project.sh              # → current folder
#   /path/to/ai-development-system/scripts/new-project.sh .            # → current folder
#   /path/to/ai-development-system/scripts/new-project.sh my-app       # → ./my-app here
#   /path/to/ai-development-system/scripts/new-project.sh my-app "idea"
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
AI Development OS — New Project

Run from any folder. Project is placed under your current directory (pwd).

Usage:
  $(basename "$0")                         Scaffold CURRENT folder
  $(basename "$0") .                       Scaffold CURRENT folder
  $(basename "$0") <name> ["one-line idea"]  Create ./<name> in current folder
  $(basename "$0") -h|--help

Examples (run from anywhere):
  cd ~/projects
  $ROOT/scripts/new-project.sh
  $ROOT/scripts/new-project.sh my-api "REST API for quiet hours"
  cd my-api && cursor .

  cd ~/projects/existing-empty-dir
  $ROOT/scripts/new-project.sh .

After scaffold, in Cursor chat type: start

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
  if [[ "$(basename "$dir")" == "." || "$dir" == "$(pwd)" ]]; then
    basename "$(pwd)"
  else
    basename "$dir" | sed 's/[^a-zA-Z0-9._-]/-/g'
  fi
}

already_initialized() {
  [[ -f "$1/AGENTS.md" || -f "$1/ai-dev-os.yaml" ]]
}

dir_has_other_files() {
  local dir="$1"
  local count
  count="$(find "$dir" -mindepth 1 -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' \
    ! -name 'AGENTS.md' ! -name 'ai-dev-os.yaml' ! -name 'README.md' \
    ! -name 'work' ! -name 'docs' \
    2>/dev/null | wc -l)"
  [[ "$count" -gt 0 ]]
}

substitute() {
  local src="$1" dst="$2"
  local idea="${PROJECT_IDEA:-_(not set — agent will ask in Q1)_}"
  sed \
    -e "s|{{AI_DEV_OS_HOME}}|$ROOT|g" \
    -e "s|{{PROJECT_ROOT}}|$PROJECT_DIR|g" \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_IDEA}}|$idea|g" \
    "$src" > "$dst"
}

main() {
  local project_arg="." idea_arg=""

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ $# -ge 1 ]]; then
    project_arg="$1"
  fi
  if [[ $# -ge 2 ]]; then
    idea_arg="$2"
  fi

  if [[ "${1:-}" == "-i" || "${1:-}" == "--interactive" ]]; then
    echo "=== AI Development OS — New Project ==="
    echo "Current folder: $INVOKED_FROM"
    read -rp "Subfolder name (Enter = use current folder): " project_arg
    project_arg="${project_arg:-.}"
    read -rp "One-line idea (optional): " idea_arg
  fi

  PROJECT_DIR="$(resolve_project_dir "$project_arg")"
  PROJECT_NAME="$(project_name_from_dir "$PROJECT_DIR")"
  PROJECT_IDEA="$idea_arg"

  [[ -d "$TEMPLATE" ]] || die "Template missing: $TEMPLATE"

  if already_initialized "$PROJECT_DIR"; then
    die "Already initialized (AGENTS.md or ai-dev-os.yaml exists): $PROJECT_DIR"
  fi

  if [[ "$project_arg" != "." && "$project_arg" != "./" ]]; then
    if [[ -e "$PROJECT_DIR" && "$(ls -A "$PROJECT_DIR" 2>/dev/null)" ]]; then
      die "Directory not empty: $PROJECT_DIR"
    fi
    mkdir -p "$PROJECT_DIR"
  fi

  mkdir -p "$PROJECT_DIR/work/kickoff" "$PROJECT_DIR/docs"

  echo "=== Creating project: $PROJECT_NAME ==="
  info "Location: $PROJECT_DIR"
  info "Invoked from: $INVOKED_FROM"
  info "OS home: $ROOT"

  substitute "$TEMPLATE/AGENTS.md" "$PROJECT_DIR/AGENTS.md"
  substitute "$TEMPLATE/ai-dev-os.yaml" "$PROJECT_DIR/ai-dev-os.yaml"
  substitute "$TEMPLATE/README.md" "$PROJECT_DIR/README.md"

  touch "$PROJECT_DIR/work/.gitkeep" "$PROJECT_DIR/docs/.gitkeep"

  if [[ ! -f "$PROJECT_DIR/.gitignore" ]]; then
    cat > "$PROJECT_DIR/.gitignore" <<'GITIGNORE'
# OS runtime (optional — commit work/ if you want artifact history)
# work/

.env
*.local
GITIGNORE
  fi

  if command -v git >/dev/null 2>&1 && [[ ! -d "$PROJECT_DIR/.git" ]]; then
    (cd "$PROJECT_DIR" && git init -q)
    info "git init done"
  fi

  if dir_has_other_files "$PROJECT_DIR"; then
    info "Note: OS files added alongside existing content in this folder"
  fi

  echo ""
  echo "=== Done ==="
  echo ""
  if [[ "$PROJECT_DIR" != "$(pwd)" ]]; then
    echo "  cd $PROJECT_DIR"
    echo ""
  fi
  echo "Project scaffolded. Open in your agent:"
  echo ""
  echo "  grok          # Grok CLI — reads AGENTS.md from cwd"
  echo "  # or open this folder in Antigravity"
  echo ""
  echo "In chat, type only:"
  echo ""
  echo "  start"
  echo ""
  if [[ -n "$PROJECT_IDEA" ]]; then
    echo "  (Idea in AGENTS.md: $PROJECT_IDEA)"
    echo ""
  fi
  echo "Guide: $ROOT/docs/PROJECT-KICKOFF.md"
}

main "$@"