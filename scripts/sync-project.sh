#!/usr/bin/env bash
# sync-project.sh — pull OS + project, refresh CLI/skills, re-bind project (ai-new)
#
# Usage:
#   sync-project.sh                    # from project dir — sync OS then project
#   sync-project.sh /path/to/project
#   sync-project.sh --os-only          # machine/OS only (no project)
#   sync-project.sh --project-only     # project only (skip OS pull/install)
#
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }
warn() { echo "  WARN: $1"; }

usage() {
  cat <<EOF
Sync Project — pull OS + project, refresh skills, re-bind

Usage:
  $(basename "$0")                         Sync OS + current project
  $(basename "$0") <project-dir>           Sync OS + named project
  $(basename "$0") --os-only               OS pull + install-cli only
  $(basename "$0") --project-only          Project only (skip OS steps)
  $(basename "$0") --skip-os-pull          install-cli without OS git pull
  $(basename "$0") --skip-project-pull     ai-new without project git pull

Skill: \$AI_DEV_OS_HOME/skills/sync-project/SKILL.md
EOF
}

OS_ONLY=false
PROJECT_ONLY=false
SKIP_OS_PULL=false
SKIP_PROJECT_PULL=false
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --os-only) OS_ONLY=true; shift ;;
    --project-only) PROJECT_ONLY=true; shift ;;
    --skip-os-pull) SKIP_OS_PULL=true; shift ;;
    --skip-project-pull) SKIP_PROJECT_PULL=true; shift ;;
    -*) die "Unknown option: $1" ;;
    *)
      [[ -z "$PROJECT_DIR" ]] || die "Unexpected argument: $1"
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

[[ "$OS_ONLY" == true && "$PROJECT_ONLY" == true ]] && die "Use only one of --os-only or --project-only"

if [[ -z "$PROJECT_DIR" ]]; then
  PROJECT_DIR="$(pwd)"
else
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
fi

[[ -d "$PROJECT_DIR" ]] || die "Not a directory: $PROJECT_DIR"

echo "=== Sync Project ==="
info "OS: $OS_HOME"
info "Project: $PROJECT_DIR"

# --- OS sync ---
if [[ "$PROJECT_ONLY" != true ]]; then
  echo ""
  echo "--- OS ---"
  if [[ "$SKIP_OS_PULL" != true ]]; then
    if [[ -d "$OS_HOME/.git" ]]; then
      info "git pull (OS)..."
      git -C "$OS_HOME" pull --ff-only || warn "OS git pull failed — continuing"
    else
      warn "OS repo is not a git checkout — skip pull"
    fi
  fi
  [[ -x "$OS_HOME/scripts/install-cli.sh" ]] || die "Missing: $OS_HOME/scripts/install-cli.sh"
  info "install-cli.sh..."
  "$OS_HOME/scripts/install-cli.sh"
  if AI_DEV_OS_HOME="$OS_HOME" "$OS_HOME/scripts/check-cli.sh" --quiet 2>/dev/null; then
    info "check-cli: OK"
  else
    warn "check-cli failed — run: source ~/.bashrc && check-cli"
  fi
fi

if [[ "$OS_ONLY" == true ]]; then
  echo ""
  echo "=== OS sync complete ==="
  exit 0
fi

# --- Project sync ---
echo ""
echo "--- Project ---"
if [[ -d "$PROJECT_DIR/.git" ]]; then
  if [[ "$SKIP_PROJECT_PULL" != true ]]; then
    info "git pull (project)..."
    git -C "$PROJECT_DIR" pull --ff-only || warn "project git pull failed — continuing"
  fi
else
  warn "project is not a git repo — skip pull"
fi

AI_NEW="${AI_DEV_OS_HOME:-$OS_HOME}/scripts/new-project.sh"
[[ -x "$AI_NEW" ]] || AI_NEW="$(command -v ai-new 2>/dev/null || true)"
[[ -n "$AI_NEW" && -x "$AI_NEW" ]] || die "ai-new not found — run install-cli.sh"

info "ai-new (merge OS blocks)..."
( cd "$PROJECT_DIR" && "$AI_NEW" . )

echo ""
echo "=== Project sync complete ==="
echo ""
echo "Next (in Grok/Agy chat from project):"
echo "  /setup-project-agents --detect-only   # if docs/agents/ exists"
echo "  continue your work"
echo ""
echo "Skill: \$AI_DEV_OS_HOME/skills/sync-project/SKILL.md"