# Getting Started — AI Development OS v1.0

Simple setup for **new** and **existing** projects. No architecture knowledge required.

| Read this if… | Jump to |
|---------------|---------|
| **Bind / kickoff any project** | **[SETUP-ADS.md](./SETUP-ADS.md)** — `/setup-ads` ← **start here** |
| **After setup** | [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) |
| **Fix a bug** | **[BUG-FIX.md](./BUG-FIX.md)** ← report once, options + Start coding |
| **How you interact** | **[USER-FLOW.md](./USER-FLOW.md)** ← questions & options, no doc reading |
| **GitHub / AFK setup** | **`/setup-project-agents`** — in `/setup-ads` Phase 1.5 → `docs/agents/` |
| **Validate user input** | **[REQUIREMENT-CHECK.md](./REQUIREMENT-CHECK.md)** — context, impact, edge cases |
| **Bundled skills** | **`skills/MANIFEST.yaml`** — load from `$AI_DEV_OS_HOME/skills/` only |
| **Standalone SSOT** | **[STANDALONE.md](./STANDALONE.md)** — this repo only; no external deps |
| First time installing the OS | [§1 One-time setup](#1-one-time-setup-5-minutes) |
| Brand-new app / greenfield | [PROJECT-KICKOFF.md §1](./PROJECT-KICKOFF.md#1-new-project-kickoff) |
| Code already exists | [PROJECT-KICKOFF.md §2](./PROJECT-KICKOFF.md#2-existing-project-kickoff) |
| Gate reference (agents) | [§4 Every piece of work](#4-every-piece-of-work-same-for-both) |
| Quick smoke test | [§5 Test in 10 minutes](#5-test-in-10-minutes) |

---

## How it works (30 seconds)

```
You: /setup-ads + one sentence
    → ai-new + grill (new: /grill-me | existing: /grill-with-docs)
    → Agent writes CONTEXT.md + work/ silently (you never read spec files)
    → You: "yes" on summary; A/B/C only when paths diverge
    → Agent plans + splits into tasks — short list, not documents
    → You: Start AFK (batch) or Start coding (bugs) before implementation
```

**Users:** follow [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) — answer questions, don't read playbooks.  
**Agents:** read playbooks internally; never dump spec files on the user. OS status footer on the **last line** of every reply — [OS-STATUS-FOOTER.md](./OS-STATUS-FOOTER.md).

---

## 1. One-time setup (5 minutes)

### Step 1 — Install the OS (once per machine)

Clone or copy this repository somewhere permanent:

```bash
git clone <your-repo-url> ~/ai-development-system
# or use your existing path:
export AI_DEV_OS_HOME=/data/project/ai-development-system
```

Add to `~/.bashrc` (Ubuntu) or `~/.zshrc` (Mac) — **once per machine**:

```bash
export AI_DEV_OS_HOME=~/ai-development-system   # ← your clone path on THIS machine
```

Or run `install-cli.sh` — it sets this automatically.  
**Multi-machine (Mac + Ubuntu):** [MULTI-MACHINE.md](./MULTI-MACHINE.md) — project files stay portable; only shell env differs.

**Optional — `ai-new` shortcut** (one command from any folder):

```bash
$AI_DEV_OS_HOME/scripts/install-cli.sh
source ~/.bashrc   # or open a new terminal
which ai-new       # → ~/.local/bin/ai-new
```

### Step 2 — Verify the OS is healthy

```bash
cd $AI_DEV_OS_HOME
./scripts/verify-catalog.sh
./scripts/simulate-workflow.sh all
```

Both should end with **FAIL=0**. If not, fix the OS before touching a project.

### Step 3 — Tell your AI agent (once per chat)

Copy-paste into Grok / Antigravity / your agent:

```text
AI Development OS v1.0 rules:
- AI_DEV_OS_HOME = <your path>
- Playbook SSOT is under playbooks/ — never guess routing
- One skill per turn; stop at human gates
- Write artifacts to project_root/work/ — not chat-only
- Last line of every response = OS status footer (see OS-STATUS-FOOTER.md)
```

**Done.** You do not copy `playbooks/`, `workflows/`, or `standards/` into your app repo.

### Existing project (brownfield bind)

`ai-new` is **idempotent** — safe on repos that already have code:

```bash
cd /path/to/your-existing-app    # e.g. Odoo auction addon
ai-new
```

Creates only what is missing: `AGENTS.md`, `ai-dev-os.yaml`, `work/`, `docs/`, `.gitignore`, `git init` — **never overwrites** existing files.

---

## 2. New project (greenfield)

**One command** (from any folder):

```bash
# Subfolder in current directory:
ai-new my-app "Your one-line idea"
cd my-app && grok

# OR scaffold current folder:
cd ~/projects/my-app
ai-new
grok
```

(`ai-new` after `install-cli.sh`; otherwise use `$AI_DEV_OS_HOME/scripts/new-project.sh`.)

**Antigravity:** open the project folder in the IDE instead of `grok`.

In chat type: **`start`**

See [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) for the full grill → intake → discovery flow.

---

## 3. Existing project (brownfield)

**Use [PROJECT-KICKOFF.md §2](./PROJECT-KICKOFF.md#2-existing-project-kickoff).**

```bash
cd /path/to/your-existing-app
mkdir -p work
```

In Grok or Antigravity chat:

```text
Existing project: <what you want to do on this codebase>
Use PROJECT-KICKOFF — grill with /grill-with-docs; explore the repo; one question at a time.
```

Agent builds or updates `CONTEXT.md` from your answers + code exploration, then spec + tasks silently — see [USER-FLOW.md](./USER-FLOW.md).

---

## 4. Every piece of work (same for both)

**Users:** [USER-FLOW.md](./USER-FLOW.md) — understand → spec → tasks → **Start AFK** → `/task-run` → merge PRs.

**Agents:** record internal gates silently when user picks options or says Start coding:

| Internal gate | When to record (silent) |
|---------------|-------------------------|
| H-INTAKE | After kickoff `yes` |
| H-FRAME | After discovery/onboard complete |
| H-PLAN | After PRD/spec complete |
| H-DECOMPOSE | After user confirms task split |
| H-IMPLEMENT | When user says **Start AFK** or **Start coding** |
| H-VERIFY / H-SHIP | After verify/release (silent) |

User never says Approve intake / frame / plan / decompose.

### Step 1 — Kickoff or new task

**New/existing project:** [PROJECT-KICKOFF](./PROJECT-KICKOFF.md) (grill → CONTEXT.md).  
**New task on same project:** new `work_id` (e.g. `WR-002`); same USER-FLOW phases.

### Step 2 — Next skill only (agents)

```text
Execute PB-<next-skill> ONLY.
work_id: WR-001
project_root: <path>
AI_DEV_OS_HOME: <path>

Load: playbooks/<skill>/09-system-prompt.md + 04-io-contract.md + checklist.
Upstream artifacts must exist (see work/ folder).
Stop after handoff.
```

**Implementation (`PB-implement-*`):** batch via **`/task-run`** after Start AFK; bugs after **Start coding**. Load **`/tdd`**; per **task** vertical slice (RED→GREEN→refactor).

### Step 4 — Check `work/` folder

Artifacts accumulate under `work/`:

```text
work/
├── WR-001.md                 # Work Record (index)
├── intake/WR-001.md          # INT
├── discovery/WR-001.md       # DISC (if ran)
├── prd/WR-001.md             # PRD (if ran)
├── issues/ISS-*.md           # Issues (if decomposed)
├── implement/backend/...     # CODE (if implemented)
└── ...
```

---

## 5. Test in 10 minutes

**Sandbox (safe — not your real repo):**

```bash
mkdir -p ~/os-sandbox-test/work
cat > ~/os-sandbox-test/CONTEXT.md <<'EOF'
# os-sandbox-test
## Module map
| Module | Path |
| api | src/ |
EOF
mkdir -p ~/os-sandbox-test/src
```

Run intake prompt from §2B or §3B with `project_root: ~/os-sandbox-test`.

**Pass:** `work/intake/*.md` and `work/WR-*.md` exist; agent did not write code.

---

## 6. Cheat sheet — which workflow?

| You want to… | Say in intake | Typical workflow |
|--------------|---------------|------------------|
| Build new product | “new app …” | WF-PROJECT-NEW → WF-FEATURE |
| Add feature | “add feature …” | WF-FEATURE |
| Fix bug | `Bug Fix: …` — see **[BUG-FIX.md](./BUG-FIX.md)** | WF-BUGFIX (automatic) |
| Onboard existing repo | “adopt OS on this repo” | WF-PROJECT-EXISTING |
| Security review plan | “security assessment …” | WF-SECURITY |
| Performance baseline | “perf baseline …” | WF-PERF |
| Update docs | “update documentation …” | WF-DOCS |
| Ship release | “release v…” | WF-RELEASE |

Intake picks this — you can correct at H-INTAKE if wrong.

---

## 7. Save tokens (important)

| Do | Don't |
|----|-------|
| Load 3 files per skill (09, 04, checklist) | Load all 01–11 playbooks |
| One skill per agent turn | “Run entire workflow” |
| Use `CONTEXT.md` + artifacts | Re-paste full chat history |
| Approve gates explicitly | Let agent self-approve |

---

## 8. Troubleshooting

| Problem | Fix |
|---------|-----|
| Agent writes code at intake | Say: “Stop. PB-intake-classify only. See 08-limitations.md.” |
| Agent skips gate | Require `decision: pending` until you approve |
| “Can't find playbook” | Set `AI_DEV_OS_HOME` with absolute path |
| Existing project, no CONTEXT | Create §3A CONTEXT.md first |
| Wrong workflow | Revise at H-INTAKE or re-run intake with clearer request |
| Overwhelmed | Use **one slice**: intake → one next skill → stop |

---

## 9. Where to read more

| Topic | Doc |
|-------|-----|
| Full catalog | [INDEX.md](../INDEX.md) |
| Architecture | [ARCHITECTURE.md](./ARCHITECTURE.md) |
| v1.0 freeze scope | [release/v1.0/PLATFORM-MANIFEST.md](../release/v1.0/PLATFORM-MANIFEST.md) |
| Which skill next | `workflows/project-orchestrator/routing-matrix.yaml` |
| Testing detail | Ask agent to follow §5 above, or full test in prior session guide |

---

## 10. Copy-paste card (pin this)

```text
┌─────────────────────────────────────────────┐
│ AI DEV OS v1.0 — SESSION CARD               │
├─────────────────────────────────────────────┤
│ AI_DEV_OS_HOME = ___________________        │
│ project_root   = ___________________        │
│ work_id        = WR-___                     │
├─────────────────────────────────────────────┤
│ 1. PB-intake-classify → H-INTAKE approve    │
│ 2. One PB-* per turn (09+04+checklist)      │
│ 3. Artifacts → project_root/work/           │
│ 4. Never self-approve gates                 │
└─────────────────────────────────────────────┘
```