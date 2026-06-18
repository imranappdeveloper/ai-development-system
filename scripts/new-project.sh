#!/usr/bin/env bash
# new-project.sh — bind AI Dev OS to a project (new or existing)
#
# Idempotent: creates only what is missing — never overwrites ai-dev-os.yaml, README.md.
# AGENTS.md: merges missing OS blocks (ADS-BLOCK markers) when file already exists.
# Run from ANY directory. Default target is current folder (pwd).
#
# Usage:
#   ai-new                              # → current folder (new or existing repo)
#   ai-new .                            # → current folder
#   ai-new my-app "one-line idea"       # → ./my-app (creates dir if missing)
#   ai-new -i                           # interactive
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
INVOKED_FROM="$(pwd)"

die() { echo "ERROR: $1" >&2; exit 1; }
info() { echo "  $1"; }

usage() {
  cat <<EOF
AI Development OS — Project Setup (ai-new)

Idempotent bind for new OR existing projects. Creates only missing OS files.

Usage:
  $(basename "$0")                         Setup CURRENT folder
  $(basename "$0") .                       Setup CURRENT folder
  $(basename "$0") <name> ["one-line idea"]  Setup ./<name> (mkdir if missing)
  $(basename "$0") -i|--interactive
  $(basename "$0") -h|--help

Checks (create if missing; AGENTS.md merges missing OS blocks only):
  AGENTS.md  ai-dev-os.yaml  work/  docs/  .gitignore  git repo  graphify hook  task-run

Examples:
  # Existing Odoo addon repo:
  cd ~/odoo/auction && ai-new

  # New empty subfolder:
  cd ~/projects && ai-new my-api "REST API for quiet hours"

  # Greenfield in current dir:
  mkdir ~/projects/my-app && cd ~/projects/my-app && ai-new

After setup: grok  (or Antigravity) — type "start" or "Existing project: …"

Guide: $ROOT/docs/PROJECT-KICKOFF.md

EOF
}

resolve_project_dir() {
  local arg="$1"
  if [[ "$arg" == "." ]]; then
    pwd
  elif [[ "$arg" == /* ]]; then
    echo "$arg"
  elif [[ "$arg" == ./* || "$arg" == ../* ]]; then
    echo "$(cd "$(dirname "$arg")" && pwd)/$(basename "$arg")"
  else
    echo "$(pwd)/$arg"
  fi
}

project_name_from_dir() {
  local dir="$1"
  basename "$dir" | sed 's/[^a-zA-Z0-9._-]/-/g'
}

dir_has_app_content() {
  local dir="$1"
  local count
  count="$(find "$dir" -mindepth 1 -maxdepth 1 \
    ! -name '.git' ! -name '.gitignore' \
    ! -name 'AGENTS.md' ! -name 'ai-dev-os.yaml' ! -name 'README.md' \
    ! -name 'work' ! -name 'docs' ! -name 'CONTEXT.md' \
    2>/dev/null | wc -l | tr -d ' ')"
  [[ "${count:-0}" -gt 0 ]]
}

substitute() {
  local src="$1" dst="$2"
  local idea="$3"
  sed \
    -e "s|{{AI_DEV_OS_HOME}}|$ROOT|g" \
    -e "s|{{PROJECT_ROOT}}|$PROJECT_DIR|g" \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_IDEA}}|$idea|g" \
    "$src" > "$dst"
}

# Fingerprint fallback when AGENTS.md predates ADS-BLOCK markers (any match = block present).
ads_block_present() {
  local block="$1"
  local file="$2"
  if grep -qF "<!-- ADS-BLOCK:${block} -->" "$file" 2>/dev/null; then
    return 0
  fi
  case "$block" in
    header)             grep -qE 'AI Development OS|grill-first kickoff' "$file" ;;
    path-resolution)    grep -qF 'Path resolution (Mac / Ubuntu' "$file" \
                        || grep -qF 'env:AI_DEV_OS_HOME' "$file" ;;
    requirement-check)  grep -qF 'REQUIREMENT-CHECK.md' "$file" ;;
    skills-source)    grep -qF 'skills/MANIFEST.yaml' "$file" ;;
    agent-skills)       grep -qF 'docs/agents/issue-tracker.md' "$file" \
                        || grep -qF 'Agent skills' "$file" ;;
    afk-task-run)       grep -qF 'AFK-TASK-RUN.md' "$file" ;;
    user-flow)          grep -qF 'USER-FLOW.md' "$file" ;;
    config)             grep -qF 'Read `ai-dev-os.yaml`' "$file" ;;
    bug-fix)            grep -qF 'BUG-FIX.md' "$file" ;;
    setup-ads)          grep -qF 'SETUP-ADS.md' "$file" && grep -qF '/setup-ads' "$file" ;;
    setup-ads-behavior) grep -qF 'check-cli' "$file" ;;
    implementation-tdd) grep -qF '/tdd' "$file" && grep -qF 'PB-implement' "$file" ;;
    os-status-footer)   grep -qF 'OS-STATUS-FOOTER' "$file" ;;
    never)              grep -qF 'Skip grill on greenfield' "$file" ;;
    user-approvals)     grep -qF 'Start coding' "$file" ;;
    project-idea)       grep -qF 'Project idea (if provided' "$file" \
                        || grep -qF '{{PROJECT_IDEA}}' "$file" ;;
    *)                  return 1 ;;
  esac
}

merge_agents_md() {
  local idea="$1"
  local existing="$PROJECT_DIR/AGENTS.md"
  local template="$TEMPLATE/AGENTS.md"
  local tmp_template merged=0
  local block_name="" block_lines=() append_buf=""
  MERGED_AGENTS_BLOCKS=0

  [[ -f "$existing" ]] || return 1

  tmp_template="$(mktemp)"
  substitute "$template" "$tmp_template" "$idea"

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^BLOCK: ]]; then
      block_name="${line#BLOCK:}"
      block_lines=()
      continue
    fi
    if [[ "$line" == "ENDBLOCK" ]]; then
      [[ -n "$block_name" ]] || continue
      if [[ "$block_name" == "project-idea" ]] \
        && ! grep -qF '{{PROJECT_IDEA}}' "$existing"; then
        block_name=""
        continue
      fi
      if ads_block_present "$block_name" "$existing"; then
        block_name=""
        continue
      fi
      append_buf+="<!-- ADS-BLOCK:${block_name} -->"$'\n'
      local l
      for l in "${block_lines[@]}"; do
        append_buf+="$l"$'\n'
      done
      append_buf+="<!-- /ADS-BLOCK:${block_name} -->"$'\n'
      append_buf+=$'\n'
      merged=$((merged + 1))
      block_name=""
      continue
    fi
    if [[ -n "$block_name" ]]; then
      block_lines+=("$line")
    fi
  done < <(awk '
    /^<!-- ADS-BLOCK:/ {
      name = $0
      sub(/^<!-- ADS-BLOCK:/, "", name)
      sub(/ -->$/, "", name)
      print "BLOCK:" name
      in_block = 1
      next
    }
    /^<!-- \/ADS-BLOCK:/ {
      in_block = 0
      print "ENDBLOCK"
      next
    }
    in_block { print }
  ' "$tmp_template")

  rm -f "$tmp_template"

  MERGED_AGENTS_BLOCKS=$merged
  if [[ $merged -eq 0 ]]; then
    info "AGENTS.md — exists, kept (all OS blocks present)"
    return 0
  fi

  {
    cat "$existing"
    printf '\n---\n\n<!-- Merged by ai-new — AI Development OS blocks -->\n\n'
    printf '%s' "$append_buf"
  } > "${existing}.ai-new.tmp"
  mv "${existing}.ai-new.tmp" "$existing"
  info "AGENTS.md — merged $merged block(s)"
}

setup_os_binding() {
  local idea="$1"
  local created=0
  local skipped=0
  local is_existing=false

  if dir_has_app_content "$PROJECT_DIR"; then
    is_existing=true
  fi

  echo "=== AI Development OS — Project Setup ==="
  info "Project: $PROJECT_NAME"
  info "Location: $PROJECT_DIR"
  info "Invoked from: $INVOKED_FROM"
  info "OS home: $ROOT"
  if $is_existing; then
    info "Mode: existing project (additive — no overwrites)"
  else
    info "Mode: greenfield / empty folder"
  fi
  echo ""

  # --- AGENTS.md (merge missing OS blocks when file exists) ---
  if [[ -f "$PROJECT_DIR/AGENTS.md" ]]; then
    merge_agents_md "$idea"
    if [[ "${MERGED_AGENTS_BLOCKS:-0}" -gt 0 ]]; then
      created=$((created + 1))
    else
      skipped=$((skipped + 1))
    fi
  else
    substitute "$TEMPLATE/AGENTS.md" "$PROJECT_DIR/AGENTS.md" "$idea"
    info "AGENTS.md — created"
    created=$((created + 1))
  fi

  # --- ai-dev-os.yaml (portable — env:AI_DEV_OS_HOME, no machine paths) ---
  if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]]; then
    info "ai-dev-os.yaml — exists, kept"
    skipped=$((skipped + 1))
  else
    substitute "$TEMPLATE/ai-dev-os.yaml" "$PROJECT_DIR/ai-dev-os.yaml" "$idea"
    info "ai-dev-os.yaml — created (portable — uses \$AI_DEV_OS_HOME)"
    created=$((created + 1))
  fi

  # --- local override example ---
  if [[ ! -f "$PROJECT_DIR/ai-dev-os.local.yaml.example" ]]; then
    cp "$TEMPLATE/ai-dev-os.local.yaml.example" "$PROJECT_DIR/ai-dev-os.local.yaml.example"
    info "ai-dev-os.local.yaml.example — created"
    created=$((created + 1))
  fi

  # --- README.md ---
  if [[ -f "$PROJECT_DIR/README.md" ]]; then
    info "README.md — exists, kept"
    skipped=$((skipped + 1))
  else
    substitute "$TEMPLATE/README.md" "$PROJECT_DIR/README.md" "$idea"
    info "README.md — created"
    created=$((created + 1))
  fi

  # --- work/ docs/ ---
  mkdir -p "$PROJECT_DIR/work/kickoff" "$PROJECT_DIR/docs"
  touch "$PROJECT_DIR/work/.gitkeep" "$PROJECT_DIR/docs/.gitkeep" 2>/dev/null || true
  info "work/ docs/ — ready"

  # --- .gitignore ---
  ensure_gitignore_entry() {
    local file="$1" entry="$2"
    grep -qF "$entry" "$file" 2>/dev/null || echo "$entry" >> "$file"
  }
  if [[ -f "$PROJECT_DIR/.gitignore" ]]; then
    ensure_gitignore_entry "$PROJECT_DIR/.gitignore" "ai-dev-os.local.yaml"
    info ".gitignore — exists, ensured ai-dev-os.local.yaml"
    skipped=$((skipped + 1))
  else
    cat > "$PROJECT_DIR/.gitignore" <<'GITIGNORE'
# OS per-machine paths (optional — prefer AI_DEV_OS_HOME in shell)
ai-dev-os.local.yaml

# OS runtime (optional — commit work/ if you want artifact history)
# work/

.env
*.local

# graphify cache (graph.json + GRAPH_REPORT.md may be committed)
graphify-out/.graphify_*
graphify-out/.graphify_chunk_*.json
GITIGNORE
    info ".gitignore — created"
    created=$((created + 1))
  fi

  # --- git ---
  if [[ -d "$PROJECT_DIR/.git" ]]; then
    info "git — repo exists, kept"
    skipped=$((skipped + 1))
  elif command -v git >/dev/null 2>&1; then
    (cd "$PROJECT_DIR" && git init -q)
    info "git — initialized"
    created=$((created + 1))
  else
    info "git — not installed, skipped"
  fi

  # --- graphify (CLI + post-commit hook; initial build on existing codebases) ---
  if [[ -x "$ROOT/scripts/setup-graphify.sh" ]]; then
    echo ""
    "$ROOT/scripts/setup-graphify.sh" "$PROJECT_DIR" || info "graphify — setup skipped or partial"
  fi

  # --- task-run server AFK (agent config, work/task-run/, docs/agents/task-run.md) ---
  if [[ -x "$ROOT/scripts/setup-task-run.sh" ]]; then
    echo ""
    "$ROOT/scripts/setup-task-run.sh" "$PROJECT_DIR" --no-poll || info "task-run — setup skipped or partial"
  fi

  echo ""
  if [[ $created -eq 0 ]]; then
    echo "=== Already fully bound ($skipped items unchanged) ==="
  else
    echo "=== Done — created $created item(s), kept $skipped existing ==="
  fi
  echo ""
  echo "Paths (portable — set once per machine):"
  echo "  export AI_DEV_OS_HOME=\"$ROOT\"   # add to ~/.zshrc or ~/.bashrc"
  echo "  project_root:   $PROJECT_DIR (auto — this repo)"
  if [[ -n "${AI_DEV_OS_HOME:-}" ]]; then
    "$ROOT/scripts/ai-paths.sh" sync 2>/dev/null && info "ai-dev-os.local.yaml synced for this machine" || true
  fi
  echo ""
  echo "Open in your agent:"
  echo "  cd $PROJECT_DIR && grok"
  echo ""
  echo "In chat:"
  echo "  /setup-ads"
  if $is_existing; then
    echo "  Existing project: <what you want on this codebase>"
  else
    echo "  New project: <one-line idea>"
    if [[ -n "${PROJECT_IDEA:-}" ]]; then
      echo "  (idea: $PROJECT_IDEA)"
    fi
  fi
  echo ""
  echo "Guide: $ROOT/docs/PROJECT-KICKOFF.md"
}

main() {
  local project_arg="." idea_arg=""

  if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
  fi

  if [[ "${1:-}" == "-i" || "${1:-}" == "--interactive" ]]; then
    echo "=== AI Development OS — Project Setup ==="
    echo "Current folder: $INVOKED_FROM"
    read -rp "Subfolder name (Enter = use current folder): " project_arg
    project_arg="${project_arg:-.}"
    read -rp "One-line idea (optional): " idea_arg
  elif [[ $# -ge 1 ]]; then
    project_arg="$1"
    if [[ $# -ge 2 ]]; then
      idea_arg="$2"
    fi
  fi

  PROJECT_DIR="$(resolve_project_dir "$project_arg")"
  PROJECT_NAME="$(project_name_from_dir "$PROJECT_DIR")"
  PROJECT_IDEA="$idea_arg"

  [[ -d "$TEMPLATE" ]] || die "Template missing: $TEMPLATE"

  # Create subfolder only when it does not exist
  if [[ "$project_arg" != "." && "$project_arg" != "./" ]]; then
    if [[ ! -e "$PROJECT_DIR" ]]; then
      mkdir -p "$PROJECT_DIR"
      info "Created directory: $PROJECT_DIR"
    fi
  fi

  [[ -d "$PROJECT_DIR" ]] || die "Not a directory: $PROJECT_DIR"

  local idea_text
  if [[ -n "$PROJECT_IDEA" ]]; then
    idea_text="$PROJECT_IDEA"
  elif dir_has_app_content "$PROJECT_DIR"; then
    idea_text="_(existing project — see CONTEXT.md)_"
  else
    idea_text="_(not set — agent will ask in Q1)_"
  fi

  setup_os_binding "$idea_text"
}

main "$@"