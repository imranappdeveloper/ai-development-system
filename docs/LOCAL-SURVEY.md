# Local Codebase Survey (Ollama MCP)

Optional **Mac interactive** layer: script-gated read-only summaries via local Ollama. **Ubuntu AFK unchanged** — cloud only.

Lock doc: `work/requirement-lock.md` (REQ-LOCK-001).

---

## Architecture (B1)

```
grill-intake.py / issue-context-pack.sh / lock doc → file list
        ↓
codebase_survey MCP → Ollama qwen2.5-coder:14b
        ↓
agy or Grok (cloud) verifies summary
        ↓ error or incomplete?
Cloud explore on SAME file list (filesystem MCP)
        ↓
Cloud implements
```

---

## Prerequisites (Mac)

```bash
brew install ollama          # or https://ollama.ai
ollama pull qwen2.5-coder:14b
export OLLAMA_MAX_LOADED_MODELS=1
ollama serve                 # runs as service on macOS after install
```

---

## Enable (M2)

**Project** — copy from `ai-dev-os.local.yaml.example`:

```yaml
local_survey:
  enabled: true
  ollama_model: qwen2.5-coder:14b
  ollama_host: http://127.0.0.1:11434
```

**Ubuntu server** — omit or `enabled: false`. Do not register MCP in server agy/grok config.

Auto-detect: if `enabled` omitted and `ollama` is on PATH → treated as enabled on Mac.

---

## Register MCP (Cursor + agy + Grok)

```bash
cd your-project
$AI_DEV_OS_HOME/scripts/setup-local-survey.sh .
```

Dry-run (print snippets only):

```bash
$AI_DEV_OS_HOME/scripts/setup-local-survey.sh . --dry-run
```

Status:

```bash
$AI_DEV_OS_HOME/scripts/setup-local-survey.sh --status .
```

Restart Cursor / agy / Grok after registration.

---

## MCP tool: `survey`

| Argument | Required | Description |
|----------|----------|-------------|
| `files` | yes | Paths from script or lock doc (project-relative) |
| `project_root` | no | Defaults to cwd |

Returns JSON:

| Field | Meaning |
|-------|---------|
| `ok` | true when all files read and referenced in summary |
| `fallback_recommended` | true → parent must use cloud explore on same list |
| `summary` | Markdown summary when ok |
| `files_unreferenced` | Paths missing from summary → triggers fallback |

---

## Script-gated triggers only

| Source | File list from |
|--------|----------------|
| `grill-intake.py` | `files_components` per journey |
| `issue-context-pack.sh` | Files to spot-check |
| `work/requirement-lock.md` | Named paths |
| User `@file` / `@folder` | Explicit attachment |

No list → **no local survey**.

---

## agy vs filesystem MCP

| MCP | Role |
|-----|------|
| `filesystem` | Raw read/write (unchanged) |
| `codebase-survey` | Read listed files + Ollama summarize |

---

## Verification

```bash
check-integration          # WARN if enabled but Ollama down; never FAIL
$AI_DEV_OS_HOME/scripts/test-codebase-survey.sh
```

---

## References

| Doc | Topic |
|-----|-------|
| [MULTI-MACHINE.md](./MULTI-MACHINE.md) | Mac + Ubuntu portable binding |
| [AFK-TASK-RUN.md](./AFK-TASK-RUN.md) | Server stays cloud |
| `templates/project-starter/AGENTS.md` | Agent discovery rule (ADS-BLOCK:local-survey) |