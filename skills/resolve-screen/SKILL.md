---
name: resolve-screen
description: >
  Resolve screen/UI phrases to file paths using work/ui-aliases.yaml and Graphify.
  Auto-triggered when user mentions screens, pages, routes, or visible UI text.
  Use for /resolve-screen or before UI work in ad-hoc chats.
---

# Resolve screen — alias cache + Graphify

Turn product language (“login screen validation message”) into **2–3 file paths** before reading code. Logs every use to `work/telemetry/events.jsonl` (`resolve_screen` events).

**SSOT:** `work/requirement-lock.md` (REQ-LOCK-004) when present.

---

## When to run

| Trigger | Action |
|---------|--------|
| User mentions **screen**, **page**, **route**, tab, or **visible UI text** | Run protocol **before** broad codebase search |
| User runs **`/resolve-screen`** | Run protocol explicitly |
| AFK / lock doc already lists **Files to spot-check** | Skip unless issue text has new screen nickname |
| Backend-only task (API, migration, no UI) | Skip |

---

## Protocol (every invocation)

From project root:

```bash
resolve-screen.sh --phrase "<extracted screen/ui phrase>" --json
```

On **Graphify miss** after spot-check confirms files, cache for next time:

```bash
resolve-screen.sh --phrase "<phrase>" --write --json
```

| Step | Detail |
|------|--------|
| 1 | Extract phrase from user message (screen name + optional widget/copy hint) |
| 2 | Run `resolve-screen.sh --json` |
| 3 | If `ok: true` → **spot-check listed files only** (no repo-wide grep) |
| 4 | If `source: miss` → `query_graph` MCP (budget 1500) OR cloud explore on extracted paths only |
| 5 | After confirm → `--write` to append `work/ui-aliases.yaml` |

---

## Result shapes

**Alias hit** (`source: alias`):

```json
{ "ok": true, "source": "alias", "nickname": "login screen", "files": ["lib/..."] }
```

**Graphify hit** (`source: graphify`):

```json
{ "ok": true, "source": "graphify", "files": ["lib/..."], "alias_written": true }
```

**Miss** — run Graphify MCP or ask one clarifying question; then `--write`.

---

## Prerequisites

| Check | Fix |
|-------|-----|
| `graphify-out/graph.json` missing | `setup-graphify.sh . --build` |
| `/ads` warns on graphify | Run fix from preflight JSON `graphify.fix_hint` |
| Empty `work/ui-aliases.yaml` | Normal on first use — aliases grow on miss |

---

## Logging

Every run appends:

- `resolve_screen` — phrase, source (`alias` \| `graphify` \| `miss`), files, status
- `script_invoked` — `resolve-screen.sh` wrapper

View usage:

```bash
observe report
grep resolve_screen work/telemetry/events.jsonl | tail -5
```

---

## AFK / issue-context-pack

`issue-context-pack.sh` merges matching `work/ui-aliases.yaml` entries into **Files to spot-check** when issue text mentions a nickname.

---

## Never

- Map functions or line numbers in `ui-aliases.yaml`
- Hand-maintain a full screen encyclopedia — Graphify owns structure
- Skip resolver then read entire `lib/` for a single UI tweak
- Block work when Graphify is missing — aliases still work; warn only