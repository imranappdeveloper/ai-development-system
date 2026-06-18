# PB-implement — Implementation (umbrella)

**Human-facing label** for implementation work. **Not** an orchestrator routing ID.

| Field | Value |
|-------|-------|
| skill_id | `PB-implement` |
| type | `umbrella` |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` (documentation umbrella) |
| exit_gate | `none` |
| checklist_id | `null` (advisory: `CL-IMPLEMENT-UMBRELLA` in [06-quality.md](./06-quality.md)) |
| path | `{AI_DEV_OS_HOME}/playbooks/implement/` |

---

## Identity Resolution (SSOT)

| ID | Role | Path | Invokable? |
|----|------|------|------------|
| **PB-implement** | Build-program umbrella + lane routing guide | `playbooks/implement/` | **No** |
| **PB-implement-backend** | Implement-phase server/API/DB code | `playbooks/implement-backend/` | Yes (when promoted) |
| **PB-implement-frontend** | Implement-phase web UI code | `playbooks/implement-frontend/` | Yes (when promoted) |
| **PB-implement-mobile** | Implement-phase mobile screen code | `playbooks/implement-mobile/` (planned) | Yes (when promoted) |
| **PB-implement-devops** | Implement-phase CI/CD and infra code | `playbooks/implement-devops/` | Yes (when promoted) |

**Orchestrator SSOT:** `workflows/project-orchestrator/routing-matrix.yaml` will list lane routing IDs — never `PB-implement` once children are promoted. Legacy `PB-implement` row remains `planned` until child migration.

Per **STD-NAMING-001** §Exceptions: `PB-implement` is an umbrella label only.

---

## Quick Reference

```text
Human says "Implement" / "build it"  → Resolve to PB-implement-<lane>
Orchestrator invokes                 → PB-implement-backend | frontend | mobile | devops (never umbrella)
Umbrella produces                    → No artifacts — routing documentation only
Decision matrix                      → fixtures/decision-matrix.yaml
Golden routing example               → examples/golden/implement-routing-decision-001.md
Prerequisite gate                    → PB-draft-ui-ux PASS (test-runs/latest-gate.md)
```

### When to use which routing ID

| Need | Routing ID | Lane | Produces |
|------|------------|------|----------|
| API handlers, migrations, server logic | `PB-implement-backend` | backend | CODE (server) |
| Web components, pages, client UI | `PB-implement-frontend` | frontend | CODE (web) |
| Native or mobile screen implementation | `PB-implement-mobile` | mobile | CODE (mobile) |
| Pipelines, IaC, deployment automation | `PB-implement-devops` | devops | CODE (infra) |

Typical **WF-FEATURE** spine after decompose: `PB-decompose-issues` → `H-DECOMPOSE` → **lane child(ren)** with **`/tdd`** (vertical RED→GREEN per ISS) → `H-IMPLEMENT` → `PB-verify`.

**Multi-lane:** One ISS epic may resolve to **multiple** lane children in parallel — never invoke umbrella once for all lanes.

---

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why umbrella exists; when not to invoke |
| [02-responsibilities.md](./02-responsibilities.md) | Documentation duties vs child playbooks |
| [03-workflow.md](./03-workflow.md) | Lane routing resolution steps |
| [04-io-contract.md](./04-io-contract.md) | Documentation-only I/O (no orchestrator contract) |
| [05-context.md](./05-context.md) | What to read before lane decisions |
| [06-quality.md](./06-quality.md) | Advisory `CL-IMPLEMENT-UMBRELLA` + child checklist refs |
| [07-edge-cases.md](./07-edge-cases.md) | Wrong routing ID scenarios (≥15 EC-RT-*) |
| [08-limitations.md](./08-limitations.md) | Cannot invoke; no artifact production |
| [09-system-prompt.md](./09-system-prompt.md) | Meta guidance — **never deploy as invoke target** |
| [10-review.md](./10-review.md) | Architect review record |
| [11-test-plan.md](./11-test-plan.md) | Umbrella identity, routing, build-order tests |

---

## Related Playbooks

| Playbook | Relationship |
|----------|--------------|
| [PB-decompose-issues](../decompose-issues/) | Upstream — ISS-* for WF-FEATURE |
| [PB-draft-issue](../draft-issue/) | Upstream — single ISS for WF-BUGFIX |
| [PB-draft-api](../draft-api/) | Plan artifact — backend lane signal |
| [PB-draft-database](../draft-database/) | Plan artifact — backend lane signal |
| [PB-draft-ui-ux](../draft-ui-ux/) | Plan artifact — frontend/mobile lane signal |
| [PB-verify](../verify/) | Downstream — after CODE + H-IMPLEMENT |

---

## Build Order

From `skills/meta-skill/LIFECYCLE.md` engineering chain:

1. `PB-draft-database` → `PB-draft-api` → `PB-draft-ui-ux` (sequential gates)
2. **`PB-implement`** (umbrella spec — this folder) — **authorized after PB-draft-ui-ux gate PASS**
3. Author/promote children: `PB-implement-backend` → `PB-implement-frontend` → `PB-implement-mobile` → `PB-implement-devops`

Umbrella promotion does **not** unblock orchestrator execution of children; each child has its own promotion gate.

---

## Version & Promotion Status

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft (documentation umbrella) |
| promotion gate | Documentation completeness — see [11-test-plan.md](./11-test-plan.md) |
| orchestrator registration | **Excluded** — umbrella not in routing-matrix invoke list (children TBD) |
| prerequisite | [PB-draft-ui-ux test-runs/latest-gate.md](../draft-ui-ux/test-runs/latest-gate.md) — PASS |