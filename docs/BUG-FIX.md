# Bug Fix — Report Once, Agent Does the Rest

**For users:** Paste one message. Agent triages, reproduces, finds root cause, proposes a fix plan, implements with `/tdd`, verifies. You only approve **formatted summaries** — never read playbooks.

**For agents:** This doc is the SSOT when the user reports a bug. Run skills automatically; persist `work/` artifacts silently; stop only at the three checkpoints below.

| Trigger | Example |
|---------|---------|
| `Bug Fix:` | `Bug Fix: push fires during quiet hours` |
| `bug:` | `bug: CSV export empty for large lists` |
| `fix:` | `fix: login redirect loop on Safari` |
| Broken / failing | `Notifications are not working since yesterday` |

---

## User message (copy-paste)

```text
Bug Fix: <what is broken — one line>

Details: <steps, expected vs actual, errors, when it started — whatever you have>
```

Optional extras: screenshots, stack traces, environment. **No work_id, no playbook names required.**

---

## Agent flow (automatic)

```mermaid
flowchart TD
    A[User: Bug Fix message] --> B[/triage — enough info?]
    B -->|missing detail| Q[One clarifying question]
    Q --> B
    B -->|ok| C[/diagnose — reproduce + root cause]
    C --> D[Silent: intake + diagnose + issue → work/]
    D --> E["Checkpoint 1: Fix Plan card"]
    E -->|Start coding| F[/tdd — implement fix]
    F --> G[Short done summary]
    G --> H[Silent: verify]
    H --> I["Checkpoint 3: Done card"]
```

### Phase 0 — Triage (`/triage`)

Load skill: `triage` (`~/.grok/skills/triage/SKILL.md`).

| Do | Don't |
|----|-------|
| Classify as **bug** | Ask user to read triage docs |
| Check reporter gave enough to reproduce | Run full issue-tracker workflow unless project uses GitHub issues |
| **One** clarifying question if repro impossible | Grill with many questions |

If detail is thin, ask **one** question only:

```text
I need one thing to reproduce: <specific question>
```

### Phase 1 — Diagnose (`/diagnose`)

Load skill: `diagnose` (`~/.grok/skills/diagnose/SKILL.md`).

| Step | Agent action |
|------|----------------|
| Feedback loop | Build failing test / script / repro (Phase 1 of diagnose) |
| Reproduce | Confirm user's symptom — not a nearby different bug |
| Root cause | Rank hypotheses; instrument; confirm cause |
| Fix approach | Choose minimal fix; note regression-test seam |

**Do not** ask the user to run diagnostic commands unless environment access is blocked.

### Phase 2 — Document silently (OS playbooks)

Assign `work_id` automatically (`WR-###` next free). Run internally — **no spec dump**:

| Order | Playbook | Artifact |
|-------|----------|----------|
| 1 | `PB-intake-classify` | `work/intake/{work_id}.md` |
| 2 | `PB-diagnose-bug` | `work/diagnose/{work_id}.md` |
| 3 | `PB-draft-issue` | `work/issue/{work_id}.md` |
| — | Update WR | `work/{work_id}.md` |

Workflow: **WF-BUGFIX**. Gates recorded as `pending` until user approves at checkpoints.

### Phase 3 — Fix plan (options — not a document)

Present cause + fix as **A/B/C** per [USER-FLOW.md](./USER-FLOW.md). Wait for option or **Start coding**.

```text
Bug: {one line}
Cause: {plain English}

A) Start coding — {fix approach in one line}
B) Different approach — {short alt}
C) Need one detail — {single question}

I recommend A because …
```

On **Start coding** (A): record gates in WR; proceed to implement.  
On **B**: one follow-up options question. On **C**: one answer, then re-offer A/B/C.

### Phase 4 — Implement (`/tdd`)

Load **`/tdd`**. Run `PB-implement-*` lane (backend / frontend / mobile / devops per issue).

- RED: regression test for confirmed bug
- GREEN: minimal fix
- Refactor if needed
- Write `work/implement/{lane}/{work_id}.md`

**No checkpoint mid-implement** — run to completion unless blocked (missing access, ambiguous fix).

### Phase 5 — Done summary

Short summary (≤6 lines): cause, files changed, test pass. Run `PB-verify` silently.

### Phase 6 — Done

```text
┌─────────────────────────────────────────────┐
│ BUG FIX COMPLETE — {work_id}                │
├─────────────────────────────────────────────┤
│ Verified:   {summary}                       │
│ Artifacts:  work/verify/{work_id}.md       │
│ Commit ready: {suggested message}           │
├─────────────────────────────────────────────┤
│ Reply: Done.                                │
└─────────────────────────────────────────────┘
```

---

## User vocabulary

| You say | Meaning |
|---------|---------|
| `A` / `B` / `C` | Pick option on fix plan |
| **Start coding** | Begin implementation |
| `Done.` | Close out bug work |

Never required: `H-INTAKE`, `work_id`, playbook names, `AI_DEV_OS_HOME` (agent reads `ai-dev-os.yaml` + env).

---

## When the agent may ask you (exceptions)

| Situation | Agent asks |
|-----------|------------|
| Cannot reproduce | One specific repro step or access |
| Two equally valid fixes | Which behavior you prefer (A vs B) |
| Needs credentials / prod access | Permission or staging URL |
| Otherwise | **Nothing** — use checkpoints only |

---

## Proof the OS was used

After a bug fix, these should exist:

```text
work/{work_id}.md
work/intake/{work_id}.md
work/diagnose/{work_id}.md
work/issue/{work_id}.md
work/implement/{lane}/{work_id}.md
work/verify/{work_id}.md
```

Chat should show the three formatted cards — not raw playbook files.

Every reply: OS status footer on the **last line only** — [OS-STATUS-FOOTER.md](./OS-STATUS-FOOTER.md).

---

## Session card (agent — first turn after user report)

```text
BUG FIX MODE — AI Development OS v1.0
Read: {AI_DEV_OS_HOME}/docs/BUG-FIX.md
project_root: {from ai-dev-os.yaml}
Auto work_id: next WR-###
Skills: /triage → /diagnose → silent PB-* → /tdd → verify
User sees: 3 checkpoint cards only
```

---

## References

| Doc | Role |
|-----|------|
| [GETTING-STARTED.md](./GETTING-STARTED.md) | OS install |
| [PROJECT-KICKOFF.md](./PROJECT-KICKOFF.md) | New projects & features |
| `workflows/WF-BUGFIX/phases.yaml` | Workflow spine (agent internal) |