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

# Install Grok skills
_install_skill() {
  local name="$1"
  local src="$ROOT/skills/${name}/SKILL.md"
  local dst="$HOME/.grok/skills/${name}/SKILL.md"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    info "Installed Grok skill: ~/.grok/skills/${name}/SKILL.md"
  else
    info "WARN: skills/${name}/SKILL.md missing — skip"
  fi
}

# Full skill folder (templates + SKILL.md)
_install_skill_bundle() {
  local name="$1"
  local src="$ROOT/skills/${name}"
  local dst="$HOME/.grok/skills/${name}"
  if [[ -d "$src" && -f "$src/SKILL.md" ]]; then
    mkdir -p "$(dirname "$dst")"
    rm -rf "$dst"
    cp -a "$src" "$dst"
    info "Installed Grok skill bundle: ~/.grok/skills/${name}/"
  else
    info "WARN: skills/${name}/ bundle missing — skip"
  fi
}

# Symlink from ~/.agent-skills/shared when present (AFK pipeline)
_link_agent_skill() {
  local name="$1"
  local shared="${AGENT_SKILLS:-$HOME/.agent-skills/shared}"
  local dst="$HOME/.grok/skills/${name}"
  if [[ -d "$shared/$name" ]]; then
    mkdir -p "$(dirname "$dst")"
    ln -sfn "$shared/$name" "$dst"
    info "Linked Grok skill: ~/.grok/skills/${name} → $shared/$name"
  elif [[ -f "$ROOT/skills/${name}/SKILL.md" ]]; then
    _install_skill "$name"
  fi
}

_install_skill "setup-ads"
_install_skill "task-run"
_install_skill_bundle "setup-matt-pocock-skills"

for _s in plan-to-issue-v2 work-to-pr-v2 to-issues issue-processor grill-me grill-with-docs tdd; do
  _link_agent_skill "$_s"
done

if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "NOTE: ~/.local/bin not on PATH in this shell yet."
  echo "      Run:  source ~/.zshrc   (Mac)  or  source ~/.bashrc   (Ubuntu)"
fi

echo ""
echo "Done. Verify:"
echo "  source ~/.zshrc    # Mac"
echo "  hash -r"
echo "  check-cli"
echo "  which ai-new ai-paths"
echo "  ai-paths check"
echo "  ls ~/.grok/skills/setup-ads/SKILL.md ~/.grok/skills/task-run/SKILL.md"
echo "  ls ~/.grok/skills/setup-matt-pocock-skills/SKILL.md"
echo ""
echo "AFK task manager (new chat after issues published):"
echo "  task-run.sh <epic> --server --detach"
echo ""
echo "In project chat:"
echo "  /setup-ads"
echo "  New project: <idea>  |  Existing project: <goal>"
echo ""
echo "Or without PATH:"
echo "  \$AI_DEV_OS_HOME/scripts/ai-paths.sh"