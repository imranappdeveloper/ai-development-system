#!/usr/bin/env bash
# install-cli.sh — install ai-new (and optional shell alias) for AI Development OS
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/new-project.sh"
BIN_DIR="${HOME}/.local/bin"
LINK="$BIN_DIR/ai-new"
BASHRC="${HOME}/.bashrc"
MARKER="# AI Development OS — ai-new CLI"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -x "$SCRIPT" ]] || die "Missing script: $SCRIPT"

mkdir -p "$BIN_DIR"
ln -sf "$SCRIPT" "$LINK"
ln -sf "$ROOT/scripts/bind-project.sh" "$BIN_DIR/ai-bind" 2>/dev/null || true
ln -sf "$ROOT/scripts/ai-paths.sh" "$BIN_DIR/ai-paths" 2>/dev/null || true
chmod +x "$SCRIPT" "$ROOT/scripts/ai-paths.sh" "$ROOT/scripts/resolve-os-paths.sh"
info "Linked: $LINK → $SCRIPT"
info "Linked: $BIN_DIR/ai-paths"

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin is not on PATH in this shell."
  echo "      Add to ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "      Or open a new login shell if your distro already adds ~/.local/bin."
fi

_write_shell_block() {
  local rc="$1"
  [[ -f "$rc" ]] || return 0
  grep -qF "$MARKER" "$rc" 2>/dev/null && return 0
  {
    echo ""
    echo "$MARKER"
    echo "export AI_DEV_OS_HOME=\"$ROOT\""
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "alias ai-new=\"\$AI_DEV_OS_HOME/scripts/new-project.sh\""
  } >> "$rc"
  info "Added AI_DEV_OS_HOME + ai-new to $rc"
}

_write_shell_block "$BASHRC"
_write_shell_block "$HOME/.zshrc"

echo ""
echo "Done. Verify:"
echo "  hash -r 2>/dev/null || true"
echo "  which ai-new"
echo "  ai-new --help"
echo ""
echo "Usage:"
echo "  cd ~/projects/my-app && ai-new"
echo "  cd ~/projects && ai-new my-app \"one-line idea\""