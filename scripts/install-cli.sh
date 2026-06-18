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
chmod +x "$SCRIPT"
info "Linked: $LINK → $SCRIPT"

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin is not on PATH in this shell."
  echo "      Add to ~/.bashrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo "      Or open a new login shell if your distro already adds ~/.local/bin."
fi

if [[ -f "$BASHRC" ]] && ! grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
  {
    echo ""
    echo "$MARKER"
    echo "export AI_DEV_OS_HOME=\"$ROOT\""
    echo "alias ai-new=\"\$AI_DEV_OS_HOME/scripts/new-project.sh\""
  } >> "$BASHRC"
  info "Added ai-new alias + AI_DEV_OS_HOME to $BASHRC"
elif [[ -f "$BASHRC" ]]; then
  info "bashrc already has AI Dev OS CLI block — skipped"
else
  info "No $BASHRC — symlink only (ai-new via ~/.local/bin)"
fi

echo ""
echo "Done. Verify:"
echo "  hash -r 2>/dev/null || true"
echo "  which ai-new"
echo "  ai-new --help"
echo ""
echo "Usage:"
echo "  cd ~/projects/my-app && ai-new"
echo "  cd ~/projects && ai-new my-app \"one-line idea\""