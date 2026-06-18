#!/usr/bin/env bash
# check-cli.sh — verify AI Dev OS CLI + bundled skills; guide install if missing
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
MANIFEST="$OS_REPO/skills/MANIFEST.yaml"
QUIET="${1:-}"

missing=()
warn=()

_ok() { [[ "$QUIET" != "--quiet" ]] && echo "  OK: $1" || true; }
_fail() { missing+=("$1"); [[ "$QUIET" != "--quiet" ]] && echo "  MISSING: $1" || true; }
_warn() { warn+=("$1"); [[ "$QUIET" != "--quiet" ]] && echo "  WARN: $1" || true; }

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

_h="${AI_DEV_OS_HOME:-$OS_REPO}"

# Commands on PATH
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

# Bundled skills — SSOT in $AI_DEV_OS_HOME/skills/
[[ -f "$MANIFEST" ]] || _fail "skills/MANIFEST.yaml"
if [[ -f "$MANIFEST" ]]; then
  while IFS= read -r skill; do
    [[ -z "$skill" ]] && continue
    if [[ -f "$_h/skills/${skill}/SKILL.md" ]]; then
      _ok "bundled: skills/${skill}/SKILL.md"
    else
      _fail "bundled skill: skills/${skill}/SKILL.md"
    fi
    if [[ -f "$HOME/.grok/skills/${skill}/SKILL.md" ]]; then
      [[ "$QUIET" == "--quiet" ]] || true
    else
      _warn "not synced to ~/.grok/skills/${skill}/ — run install-cli.sh"
    fi
  done < <(awk '/^required:/{p=1;next} /^[a-zA-Z#]/{if(p&&$1!="required:")p=0} p && /^  - /{gsub(/^  - /,""); print}' "$MANIFEST")
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

CLI or bundled skill missing. Run once on this machine:

  cd $_h
  ./scripts/install-cli.sh
  source ~/.zshrc    # Mac
  source ~/.bashrc   # Ubuntu

Skills SSOT: \$AI_DEV_OS_HOME/skills/ (see skills/MANIFEST.yaml)
Agents load: \$AI_DEV_OS_HOME/skills/<name>/SKILL.md

Then verify:
  check-cli
  ai-paths check

EOF
  exit 1
fi

[[ "$QUIET" != "--quiet" ]] && echo ""
[[ "$QUIET" != "--quiet" ]] && echo "=== CLI ready (${#missing[@]} missing, ${#warn[@]} warnings) ==="
exit 0