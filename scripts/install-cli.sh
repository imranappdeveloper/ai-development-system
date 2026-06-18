#!/usr/bin/env bash
# install-cli.sh — install ai-new, ai-paths, and bundled skills for AI Development OS
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT/scripts/new-project.sh"
BIN_DIR="${HOME}/.local/bin"
MARKER="# AI Development OS — ai-new CLI"
MANIFEST="$ROOT/skills/MANIFEST.yaml"
GROK_SKILLS="${HOME}/.grok/skills"
AGY_SKILLS="${HOME}/.gemini/config/skills"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

[[ -x "$SCRIPT" ]] || die "Missing script: $SCRIPT"
[[ -f "$ROOT/scripts/ai-paths.sh" ]] || die "Missing script: $ROOT/scripts/ai-paths.sh"
[[ -f "$MANIFEST" ]] || die "Missing skills manifest: $MANIFEST"

mkdir -p "$BIN_DIR"
chmod +x "$SCRIPT" "$ROOT/scripts/ai-paths.sh" "$ROOT/scripts/resolve-os-paths.sh" \
  "$ROOT/scripts/bind-project.sh" "$ROOT/scripts/task-run.sh" \
  "$ROOT/scripts/task-run-server.sh" \
  "$ROOT/scripts/task-run-poll.sh" \
  "$ROOT/scripts/setup-task-run.sh" \
  "$ROOT/scripts/lib/task-run-agent.sh" \
  "$ROOT/scripts/lib/task-run-session.sh" \
  "$ROOT/scripts/test-task-run-session.sh" \
  "$ROOT/scripts/setup-graphify.sh" 2>/dev/null || true

ln -sf "$SCRIPT" "$BIN_DIR/ai-new"
ln -sf "$ROOT/scripts/bind-project.sh" "$BIN_DIR/ai-bind"
ln -sf "$ROOT/scripts/ai-paths.sh" "$BIN_DIR/ai-paths"
ln -sf "$ROOT/scripts/check-cli.sh" "$BIN_DIR/check-cli"
ln -sf "$ROOT/scripts/task-run.sh" "$BIN_DIR/task-run"
ln -sf "$ROOT/scripts/task-run-server.sh" "$BIN_DIR/task-run-server"
ln -sf "$ROOT/scripts/task-run-poll.sh" "$BIN_DIR/task-run-poll"
info "Linked: $BIN_DIR/ai-new"
info "Linked: $BIN_DIR/ai-paths"
info "Linked: $BIN_DIR/check-cli"
info "Linked: $BIN_DIR/ai-bind"
info "Linked: $BIN_DIR/task-run"
info "Linked: $BIN_DIR/task-run-server"
info "Linked: $BIN_DIR/task-run-poll"

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

# Symlink bundled skills — SSOT stays in $ROOT/skills/ (git pull updates all agents)
_link_skill_dir() {
  local name="$1"
  local link_root="$2"
  local label="$3"
  local src="$ROOT/skills/${name}"
  local dst="${link_root}/${name}"

  if [[ ! -f "$src/SKILL.md" ]]; then
    die "Missing bundled skill: $ROOT/skills/${name}/SKILL.md"
  fi
  mkdir -p "$link_root"
  if [[ -L "$dst" ]]; then
    rm -f "$dst"
  elif [[ -e "$dst" ]]; then
    rm -rf "$dst"
  fi
  ln -sfn "$src" "$dst"
  info "Symlink: ${label}/${name} → \$AI_DEV_OS_HOME/skills/${name}/"
}

info "Linking skills from \$AI_DEV_OS_HOME/skills/ (MANIFEST.yaml)..."
while IFS= read -r skill; do
  [[ -z "$skill" ]] && continue
  _link_skill_dir "$skill" "$GROK_SKILLS" "~/.grok/skills"
done < <(awk '/^required:/{p=1;next} /^[a-zA-Z#]/{if(p&&$1!="required:")p=0} p && /^  - /{gsub(/^  - /,""); print}' "$MANIFEST")

mkdir -p "$(dirname "$AGY_SKILLS")"
while IFS= read -r skill; do
  [[ -z "$skill" ]] && continue
  _link_skill_dir "$skill" "$AGY_SKILLS" "~/.gemini/config/skills"
done < <(awk '/^required:/{p=1;next} /^[a-zA-Z#]/{if(p&&$1!="required:")p=0} p && /^  - /{gsub(/^  - /,""); print}' "$MANIFEST")

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin not on PATH in this shell yet."
  echo "      Run:  source ~/.zshrc   (Mac)  or  source ~/.bashrc   (Ubuntu)"
fi

echo ""
echo "Done. Skills SSOT: \$AI_DEV_OS_HOME/skills/"
echo "Symlinks: ~/.grok/skills/ + ~/.gemini/config/skills/ (grok + agy slash discovery)"
echo "Verify: ./scripts/verify-standalone.sh && check-cli"
echo ""
echo "Verify:"
echo "  source ~/.zshrc    # Mac"
echo "  hash -r"
echo "  check-cli"
echo "  which ai-new ai-paths task-run task-run-server task-run-poll grok agy"
echo ""
echo "In project chat:"
echo "  /setup-ads"
echo "  New project: <idea>  |  Existing project: <goal>"