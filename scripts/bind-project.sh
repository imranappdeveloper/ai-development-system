#!/usr/bin/env bash
# bind-project.sh — add or complete OS binding on an existing repo (no overwrite of AGENTS.md)
#
# Usage:
#   cd /path/to/your-repo
#   $AI_DEV_OS_HOME/scripts/bind-project.sh
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
PROJECT_DIR="$(pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -d "$TEMPLATE" ]] || die "Template missing: $TEMPLATE"

PROJECT_NAME="$(basename "$PROJECT_DIR" | sed 's/[^a-zA-Z0-9._-]/-/g')"

substitute() {
  local src="$1" dst="$2"
  sed \
    -e "s|{{AI_DEV_OS_HOME}}|$ROOT|g" \
    -e "s|{{PROJECT_ROOT}}|$PROJECT_DIR|g" \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_IDEA}}|_(existing project — see CONTEXT.md)_|g" \
    "$src" > "$dst"
}

echo "=== Bind AI Development OS ==="
info "Project: $PROJECT_DIR"
info "OS home: $ROOT"
echo ""

added=0

if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]]; then
  info "ai-dev-os.yaml exists — skipped"
else
  substitute "$TEMPLATE/ai-dev-os.yaml" "$PROJECT_DIR/ai-dev-os.yaml"
  info "Created ai-dev-os.yaml"
  added=$((added + 1))
fi

if [[ -f "$PROJECT_DIR/AGENTS.md" ]]; then
  info "AGENTS.md exists — kept (not overwritten)"
else
  substitute "$TEMPLATE/AGENTS.md" "$PROJECT_DIR/AGENTS.md"
  info "Created AGENTS.md"
  added=$((added + 1))
fi

mkdir -p "$PROJECT_DIR/work/kickoff" "$PROJECT_DIR/docs"
touch "$PROJECT_DIR/work/.gitkeep" "$PROJECT_DIR/docs/.gitkeep" 2>/dev/null || true
info "work/ and docs/ ready"

if [[ ! -f "$PROJECT_DIR/README.md" ]] || ! grep -q "AI Development OS" "$PROJECT_DIR/README.md" 2>/dev/null; then
  if [[ ! -f "$PROJECT_DIR/README.md" ]]; then
    substitute "$TEMPLATE/README.md" "$PROJECT_DIR/README.md"
    info "Created README.md"
    added=$((added + 1))
  else
    info "README.md exists — kept your file"
  fi
fi

echo ""
if [[ $added -eq 0 ]]; then
  echo "=== Already fully bound ==="
else
  echo "=== Done — added $added file(s) ==="
fi
echo ""
echo "Check paths in ai-dev-os.yaml:"
echo "  ai_dev_os_home: $ROOT"
echo "  project_root:   $PROJECT_DIR"
echo ""
echo "Next: cd here && grok"
echo "  Existing project: Odoo auction addon — <your goal>"