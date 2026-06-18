#!/usr/bin/env bash
# install-cli.sh — install ai-new, ai-paths, and bundled skills for AI Development OS
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/new-project.sh"
BIN_DIR="${HOME}/.local/bin"
MARKER="# AI Development OS — ai-new CLI"
MANIFEST="$ROOT/skills/MANIFEST.yaml"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -x "$SCRIPT" ]] || die "Missing script: $SCRIPT"
[[ -f "$ROOT/scripts/ai-paths.sh" ]] || die "Missing script: $ROOT/scripts/ai-paths.sh"
[[ -f "$MANIFEST" ]] || die "Missing skills manifest: $MANIFEST"

mkdir -p "$BIN_DIR"
chmod +x "$SCRIPT" "$ROOT/scripts/ai-paths.sh" "$ROOT/scripts/resolve-os-paths.sh" \
  "$ROOT/scripts/bind-project.sh" "$ROOT/scripts/task-run.sh" 2>/dev/null || true

ln -sf "$SCRIPT" "$BIN_DIR/ai-new"
ln -sf "$ROOT/scripts/bind-project.sh" "$BIN_DIR/ai-bind"
ln -sf "$ROOT/scripts/ai-paths.sh" "$BIN_DIR/ai-paths"
ln -sf "$ROOT/scripts/check-cli.sh" "$BIN_DIR/check-cli"
ln -sf "$ROOT/scripts/task-run.sh" "$BIN_DIR/task-run"
info "Linked: $BIN_DIR/ai-new"
info "Linked: $BIN_DIR/ai-paths"
info "Linked: $BIN_DIR/check-cli"
info "Linked: $BIN_DIR/ai-bind"
info "Linked: $BIN_DIR/task-run"

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
    if grep -qF 'export AI_DEV_OS_HOME=' "$rc" 2>/dev/null; then
      info "Shell block exists in $rc — symlinks refreshed"
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

# Install skills from OS bundle only ($ROOT/skills/) — no external agent-skills deps
_install_skill_dir() {
  local name="$1"
  local src="$ROOT/skills/${name}"
  local dst="$HOME/.grok/skills/${name}"
  if [[ ! -f "$src/SKILL.md" ]]; then
    die "Missing bundled skill: $ROOT/skills/${name}/SKILL.md"
  fi
  mkdir -p "$(dirname "$dst")"
  rm -rf "$dst"
  cp -a "$src" "$dst"
  info "Installed skill: ~/.grok/skills/${name}/ ← \$AI_DEV_OS_HOME/skills/${name}/"
}

info "Installing skills from \$AI_DEV_OS_HOME/skills/ (MANIFEST.yaml)..."
while IFS= read -r skill; do
  [[ -z "$skill" ]] && continue
  _install_skill_dir "$skill"
done < <(awk '/^required:/{p=1;next} /^[a-zA-Z#]/{if(p&&$1!="required:")p=0} p && /^  - /{gsub(/^  - /,""); print}' "$MANIFEST")

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin not on PATH in this shell yet."
  echo "      Run:  source ~/.zshrc   (Mac)  or  source ~/.bashrc   (Ubuntu)"
fi

echo ""
echo "Done. This repo is standalone SSOT — see docs/STANDALONE.md"
echo "Skills: \$AI_DEV_OS_HOME/skills/ (MANIFEST.yaml)"
echo "Verify: ./scripts/verify-standalone.sh && check-cli"
echo ""
echo "Verify:"
echo "  source ~/.zshrc    # Mac"
echo "  hash -r"
echo "  check-cli"
echo "  which ai-new ai-paths task-run"
echo ""
echo "In project chat:"
echo "  /setup-ads"
echo "  New project: <idea>  |  Existing project: <goal>"