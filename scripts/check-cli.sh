#!/usr/bin/env bash
# check-cli.sh — verify AI Dev OS CLI + setup-ads skill; guide install if missing
# Usage: check-cli.sh [--quiet]
# Exit 0 = ready; exit 1 = missing tools (prints install instructions)
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_REPO="$(cd "$(dirname "$_self")/.." && pwd)"
QUIET="${1:-}"

missing=()
warn=()

_ok() { [[ "$QUIET" != "--quiet" ]] && echo "  OK: $1"; }
_fail() { missing+=("$1"); [[ "$QUIET" != "--quiet" ]] && echo "  MISSING: $1"; }
_warn() { warn+=("$1"); [[ "$QUIET" != "--quiet" ]] && echo "  WARN: $1"; }

[[ "$QUIET" != "--quiet" ]] && echo "=== AI Dev OS — CLI check ==="

# AI_DEV_OS_HOME
if [[ -n "${AI_DEV_OS_HOME:-}" && -d "${AI_DEV_OS_HOME}" ]]; then
  _ok "AI_DEV_OS_HOME=$AI_DEV_OS_HOME"
elif [[ -d "$OS_REPO" ]]; then
  _warn "AI_DEV_OS_HOME unset — using script location: $OS_REPO"
  export AI_DEV_OS_HOME="$OS_REPO"
else
  _fail "AI_DEV_OS_HOME not set and OS repo not found"
fi

# Commands on PATH
_h="${AI_DEV_OS_HOME:-$OS_REPO}"
if command -v ai-new >/dev/null 2>&1; then
  _ok "ai-new → $(command -v ai-new)"
elif [[ -x "$_h/scripts/new-project.sh" ]]; then
  _warn "ai-new not on PATH — run install-cli.sh"
else
  _fail "ai-new"
fi
if command -v ai-paths >/dev/null 2>&1; then
  _ok "ai-paths → $(command -v ai-paths)"
elif [[ -x "$_h/scripts/ai-paths.sh" ]]; then
  _warn "ai-paths not on PATH — run install-cli.sh"
else
  _fail "ai-paths"
fi

# Grok skills
if [[ -f "$HOME/.grok/skills/setup-ads/SKILL.md" ]]; then
  _ok "setup-ads skill → ~/.grok/skills/setup-ads/SKILL.md"
else
  _fail "setup-ads skill (~/.grok/skills/setup-ads/SKILL.md)"
fi
if [[ -f "$HOME/.grok/skills/task-run/SKILL.md" ]]; then
  _ok "task-run skill → ~/.grok/skills/task-run/SKILL.md"
else
  _warn "task-run skill missing — run install-cli.sh (needed for AFK batch)"
fi

# ~/.local/bin on PATH
if [[ ":${PATH}:" == *":${HOME}/.local/bin:"* ]]; then
  _ok "~/.local/bin on PATH"
else
  _warn "~/.local/bin not on PATH — run: source ~/.zshrc or ~/.bashrc"
fi

if [[ ${#missing[@]} -gt 0 ]]; then
  [[ "$QUIET" != "--quiet" ]] && echo ""
  [[ "$QUIET" != "--quiet" ]] && echo "=== Install required ==="
  [[ "$QUIET" != "--quiet" ]] && cat <<EOF

CLI or skill missing. Run once on this machine:

  cd $OS_REPO
  ./scripts/install-cli.sh
  source ~/.zshrc    # Mac
  source ~/.bashrc   # Ubuntu

Then verify:
  check-cli.sh
  ai-paths check

EOF
  exit 1
fi

[[ "$QUIET" != "--quiet" ]] && echo ""
[[ "$QUIET" != "--quiet" ]] && echo "=== CLI ready ==="
exit 0