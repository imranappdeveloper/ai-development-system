#!/usr/bin/env bash
# check-integration.sh — verify AI Dev OS is fully integrated on this machine + project
#
# Usage:
#   check-integration.sh                 # from project root
#   check-integration.sh /path/to/project
#   check-integration.sh --quiet         # summary line only; exit 1 on FAIL
#
# Exit 0 = no blocking FAIL; exit 1 = blocking FAIL present
set -euo pipefail

_self="${BASH_SOURCE[0]}"
while [[ -L "$_self" ]]; do
  _dir="$(cd -P "$(dirname "$_self")" && pwd)"
  _self="$(readlink "$_self")"
  [[ $_self != /* ]] && _self="$_dir/$_self"
done
OS_HOME="$(cd "$(dirname "$_self")/.." && pwd)"

QUIET=false
PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet) QUIET=true; shift ;;
    -h|--help)
      cat <<EOF
AI Dev OS — integration check (machine + project)

Usage:
  $(basename "$0") [project-dir] [--quiet]

Checks:
  - CLI + skill symlinks (check-cli)
  - Path resolution (ai-paths check)
  - Project binding (AGENTS.md, ai-dev-os.yaml, work/, docs/)
  - AGENTS.md OS blocks
  - docs/agents/ completeness
  - task-run / AFK scaffold
  - Optional: graphify hook, gh, CONTEXT.md

Exit 0 = no blocking FAIL; exit 1 = fix required
EOF
      exit 0
      ;;
    -*) echo "ERROR: Unknown option: $1" >&2; exit 1 ;;
    *)
      [[ -z "$PROJECT_DIR" ]] || { echo "ERROR: Unexpected argument: $1" >&2; exit 1; }
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

if [[ -z "$PROJECT_DIR" ]]; then
  PROJECT_DIR="$(pwd)"
else
  PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
fi

[[ -d "$PROJECT_DIR" ]] || { echo "ERROR: Not a directory: $PROJECT_DIR" >&2; exit 1; }

fail_items=()
warn_items=()
ok_count=0

_fail() { fail_items+=("$1"); [[ "$QUIET" != true ]] && echo "  FAIL: $1" || true; }
_warn() { warn_items+=("$1"); [[ "$QUIET" != true ]] && echo "  WARN: $1" || true; }
_ok()   { ok_count=$((ok_count + 1)); [[ "$QUIET" != true ]] && echo "  OK: $1" || true; }
_section() { [[ "$QUIET" != true ]] && { echo ""; echo "--- $1 ---"; } || true; }

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
    skills-source)      grep -qF 'skills/MANIFEST.yaml' "$file" ;;
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

[[ "$QUIET" != true ]] && echo "=== AI Dev OS — Integration Report ===" || true
[[ "$QUIET" != true ]] && echo "  OS:      $OS_HOME" || true
[[ "$QUIET" != true ]] && echo "  Project: $PROJECT_DIR" || true

# --- Machine / CLI ---
_section "Machine (CLI)"
export AI_DEV_OS_HOME="${AI_DEV_OS_HOME:-$OS_HOME}"
if "$OS_HOME/scripts/check-cli.sh" --quiet 2>/dev/null; then
  _ok "check-cli"
else
  _fail "check-cli — run: cd \$AI_DEV_OS_HOME && ./scripts/install-cli.sh && source ~/.bashrc"
fi

if ( cd "$PROJECT_DIR" && "$OS_HOME/scripts/ai-paths.sh" check >/dev/null 2>&1 ); then
  _ok "ai-paths check"
else
  _fail "ai-paths — AI_DEV_OS_HOME not resolvable; run install-cli.sh"
fi

# --- Project binding ---
_section "Project binding"
bound=false
if [[ -f "$PROJECT_DIR/AGENTS.md" ]]; then
  _ok "AGENTS.md"
  bound=true
else
  _fail "AGENTS.md missing — run: ai-new ."
fi

if [[ -f "$PROJECT_DIR/ai-dev-os.yaml" ]]; then
  _ok "ai-dev-os.yaml"
  bound=true
else
  _fail "ai-dev-os.yaml missing — run: ai-new ."
fi

for dir in work docs; do
  if [[ -d "$PROJECT_DIR/$dir" ]]; then
    _ok "$dir/"
  else
    _warn "$dir/ missing — run: ai-new ."
  fi
done

if [[ "$bound" != true ]]; then
  [[ "$QUIET" != true ]] && echo "" || true
  [[ "$QUIET" != true ]] && echo "Summary: NOT BOUND — run ai-new . then /setup-ads" || true
  exit 1
fi

# --- AGENTS.md blocks ---
_section "AGENTS.md OS blocks"
agents="$PROJECT_DIR/AGENTS.md"
critical_blocks=(header path-resolution config requirement-check skills-source setup-ads)
optional_blocks=(agent-skills afk-task-run user-flow bug-fix setup-ads-behavior implementation-tdd os-status-footer never user-approvals project-idea)

for block in "${critical_blocks[@]}"; do
  if ads_block_present "$block" "$agents"; then
    _ok "block: $block"
  else
    _fail "AGENTS.md missing block: $block — run: ai-new ."
  fi
done

for block in "${optional_blocks[@]}"; do
  if ads_block_present "$block" "$agents"; then
    _ok "block: $block"
  else
    _warn "AGENTS.md missing block: $block — run: ai-new ."
  fi
done

if grep -qF '_Setup pending — run `/setup-project-agents`._' "$agents" 2>/dev/null; then
  _warn "agent-skills block still has setup placeholder — run: /setup-project-agents"
fi

# --- docs/agents/ ---
_section "docs/agents/"
agent_docs=(issue-tracker.md triage-labels.md domain.md engineering-standards.md task-run.md)
agents_dir="$PROJECT_DIR/docs/agents"
if [[ -d "$agents_dir" ]]; then
  _ok "docs/agents/"
  for doc in "${agent_docs[@]}"; do
    if [[ -f "$agents_dir/$doc" ]]; then
      _ok "docs/agents/$doc"
    else
      _warn "docs/agents/$doc missing — run: /setup-project-agents"
    fi
  done
else
  _warn "docs/agents/ missing — run: /setup-project-agents (required before plan-to-issue-v2 / task-run)"
fi

# --- task-run / AFK ---
_section "AFK / task-run"
if [[ -d "$PROJECT_DIR/work/task-run" ]]; then
  _ok "work/task-run/"
else
  _warn "work/task-run/ missing — run: setup-task-run.sh . or /setup-ads Phase 1.6"
fi

if [[ -f "$agents_dir/task-run.md" ]]; then
  _ok "docs/agents/task-run.md"
else
  _warn "docs/agents/task-run.md missing — run: setup-task-run.sh ."
fi

# --- Token optimization + usage feedback scripts ---
_section "Token optimization (AFK)"
for ts in issue-spec-check.sh issue-context-pack.sh afk-state-sync.sh grill-intake.py usage-feedback.sh; do
  if [[ -x "$OS_HOME/scripts/$ts" ]]; then
    _ok "scripts/$ts"
  else
    _warn "scripts/$ts missing — sync OS: /sync-project"
  fi
done

if [[ -d "$PROJECT_DIR/work/feedback" && -d "$PROJECT_DIR/work/telemetry" ]]; then
  _ok "work/feedback + work/telemetry"
else
  _warn "work/feedback or work/telemetry missing — run: ai-new ."
fi

if [[ -f "$PROJECT_DIR/docs/USAGE-FEEDBACK.md" ]]; then
  _ok "docs/USAGE-FEEDBACK.md"
else
  _warn "docs/USAGE-FEEDBACK.md missing — run: ai-new . or /sync-project"
fi

if grep -qE '^feedback:' "$PROJECT_DIR/ai-dev-os.yaml" 2>/dev/null; then
  _ok "ai-dev-os.yaml feedback block"
else
  _warn "ai-dev-os.yaml missing feedback: block — run: ai-new ."
fi

# --- Optional ---
_section "Optional"
if [[ -d "$PROJECT_DIR/.git" ]]; then
  _ok "git repo"
  if [[ -x "$PROJECT_DIR/.git/hooks/post-commit" ]] \
    && grep -qF 'graphify' "$PROJECT_DIR/.git/hooks/post-commit" 2>/dev/null; then
    _ok "graphify post-commit hook"
  elif command -v graphify >/dev/null 2>&1; then
    _warn "graphify on PATH but post-commit hook missing — run: setup-graphify.sh ."
  fi
  if git -C "$PROJECT_DIR" remote get-url origin 2>/dev/null | grep -qiE 'github\.com'; then
    if command -v gh >/dev/null 2>&1; then
      _ok "gh CLI (GitHub remote)"
    else
      _warn "GitHub remote but gh not on PATH — install gh for AFK issue flow"
    fi
  fi
else
  _warn "no git repo — optional for local-only work"
fi

if [[ -f "$PROJECT_DIR/CONTEXT.md" ]]; then
  _ok "CONTEXT.md"
else
  _warn "CONTEXT.md missing — created during /setup-ads grill (brownfield may need manual stub)"
fi

if command -v grok >/dev/null 2>&1 || command -v agy >/dev/null 2>&1; then
  _ok "AFK agent CLI (grok or agy)"
else
  _warn "neither grok nor agy on PATH — server AFK unavailable on this machine"
fi

# --- Summary ---
fail_n=${#fail_items[@]}
warn_n=${#warn_items[@]}

if [[ "$QUIET" == true ]]; then
  if [[ $fail_n -gt 0 ]]; then
    echo "INTEGRATION: FAIL ($fail_n blocking, $warn_n warnings)"
    exit 1
  elif [[ $warn_n -gt 0 ]]; then
    echo "INTEGRATION: PARTIAL ($warn_n warnings)"
    exit 0
  else
    echo "INTEGRATION: OK"
    exit 0
  fi
fi

echo ""
echo "=== Summary ==="
if [[ $fail_n -eq 0 && $warn_n -eq 0 ]]; then
  echo "Status: FULLY INTEGRATED ($ok_count checks passed)"
  echo ""
  echo "Ready for: /plan-to-issue-v2, /work-to-pr-v2, /task-run"
  exit 0
elif [[ $fail_n -eq 0 ]]; then
  echo "Status: PARTIAL — $warn_n warning(s), 0 blocking"
  echo ""
  echo "Fix warnings before AFK or planning:"
  for item in "${warn_items[@]}"; do
    echo "  - $item"
  done
  exit 0
else
  echo "Status: NOT READY — $fail_n blocking, $warn_n warning(s)"
  echo ""
  echo "Blocking:"
  for item in "${fail_items[@]}"; do
    echo "  - $item"
  done
  if [[ $warn_n -gt 0 ]]; then
    echo ""
    echo "Also:"
    for item in "${warn_items[@]}"; do
      echo "  - $item"
    done
  fi
  exit 1
fi