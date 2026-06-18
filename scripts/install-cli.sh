#!/usr/bin/env bash
# install-cli.sh — install ai-new, ai-paths (and shell aliases) for AI Development OS
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/new-project.sh"
BIN_DIR="${HOME}/.local/bin"
MARKER="# AI Development OS — ai-new CLI"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -x "$SCRIPT" ]] || die "Missing script: $SCRIPT"
[[ -f "$ROOT/scripts/ai-paths.sh" ]] || die "Missing script: $ROOT/scripts/ai-paths.sh"

mkdir -p "$BIN_DIR"
chmod +x "$SCRIPT" "$ROOT/scripts/ai-paths.sh" "$ROOT/scripts/resolve-os-paths.sh" \
  "$ROOT/scripts/bind-project.sh" 2>/dev/null || true

ln -sf "$SCRIPT" "$BIN_DIR/ai-new"
ln -sf "$ROOT/scripts/bind-project.sh" "$BIN_DIR/ai-bind"
ln -sf "$ROOT/scripts/ai-paths.sh" "$BIN_DIR/ai-paths"
info "Linked: $BIN_DIR/ai-new"
info "Linked: $BIN_DIR/ai-paths"
info "Linked: $BIN_DIR/ai-bind"

_ensure_path_in_rc() {
  local rc="$1"
  [[ -f "$rc" ]] || return 0
  if ! grep -qF '.local/bin' "$rc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc"
    info "Added ~/.local/bin to PATH in $rc"
  fi
}

_write_shell_block() {
  local rc="$1"
  [[ -f "$rc" ]] || return 0
  _ensure_path_in_rc "$rc"
  if grep -qF "$MARKER" "$rc" 2>/dev/null; then
    # Upgrade existing block: ensure AI_DEV_OS_HOME matches this clone
    if grep -qF 'export AI_DEV_OS_HOME=' "$rc" 2>/dev/null; then
      info "Shell block exists in $rc — symlinks refreshed (re-run fixes ai-paths)"
    else
      {
        echo ""
        echo "$MARKER"
        echo "export AI_DEV_OS_HOME=\"$ROOT\""
        echo "alias ai-new=\"\$AI_DEV_OS_HOME/scripts/new-project.sh\""
        echo "alias ai-paths=\"\$AI_DEV_OS_HOME/scripts/ai-paths.sh\""
      } >> "$rc"
      info "Appended AI_DEV_OS_HOME block to $rc"
    fi
    return 0
  fi
  {
    echo ""
    echo "$MARKER"
    echo "export AI_DEV_OS_HOME=\"$ROOT\""
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo "alias ai-new=\"\$AI_DEV_OS_HOME/scripts/new-project.sh\""
    echo "alias ai-paths=\"\$AI_DEV_OS_HOME/scripts/ai-paths.sh\""
  } >> "$rc"
  info "Added AI_DEV_OS_HOME + ai-new + ai-paths to $rc"
}

_write_shell_block "$HOME/.bashrc"
_write_shell_block "$HOME/.zshrc"

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin not on PATH in this shell yet."
  echo "      Run:  source ~/.zshrc   (Mac)  or  source ~/.bashrc   (Ubuntu)"
fi

echo ""
echo "Done. Verify:"
echo "  source ~/.zshrc    # Mac"
echo "  hash -r"
echo "  which ai-new ai-paths"
echo "  ai-paths check"
echo ""
echo "Or without PATH:"
echo "  \$AI_DEV_OS_HOME/scripts/ai-paths.sh"