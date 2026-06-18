# PB-feature-planner — Feature Planner (umbrella)

**Human-facing label** for feature planning work. **Not** an orchestrator routing ID.

| Field | Value |
|-------|-------|
| skill_id | `PB-feature-planner` |
| type | `umbrella` |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` (documentation umbrella) |
| exit_gate | `none` |
| checklist_id | `null` (advisory: `CL-FEAT-PLAN` in [06-quality.md](./06-quality.md)) |
| path | `{AI_DEV_OS_HOME}/playbooks/feature-planner/` |

---

## Identity Resolution (SSOT)

| ID | Role | Path | Invokable? |
|----|------|------|------------|
| **PB-feature-planner** | Build-program umbrella + routing guide | `playbooks/feature-planner/` | **No** |
| **PB-draft-feature** | Plan-phase feature spec (FEAT) | `playbooks/draft-feature/` | Yes |
| **PB-decompose-issues** | Decompose-phase issue breakdown (ISS-*) | `playbooks/decompose-issues/` | Yes |

**Orchestrator SSOT:** `workflows/project-orchestrator/routing-matrix.yaml` and `skill-dependency-graph.yaml` list `PB-draft-feature` and `PB-decompose-issues` — never `PB-feature-planner`.

Per **STD-NAMING-001** §Exceptions: `PB-feature-planner` is an umbrella label only.

---

## Quick Reference

```text
Human says "Feature Planner"  → Resolve to PB-draft-feature and/or PB-decompose-issues
Orchestrator invokes          → PB-draft-feature | PB-decompose-issues (never umbrella)
Umbrella produces             → No artifacts — routing documentation only
Decision matrix               → fixtures/decision-matrix.yaml
Golden routing example        → examples/golden/umbrella-routing-decision-001.md
```

### When to use which routing ID

| Need | Routing ID | Phase | Produces |
|------|------------|-------|----------|
| Narrow feature spec from DISC (PRD alternative) | `PB-draft-feature` | Plan | FEAT |
| Break approved PRD into implementable issues | `PB-decompose-issues` | Decompose | ISS-* |
| Full product requirements document | `PB-draft-prd` | Plan | PRD (sibling — not umbrella child) |

Typical **WF-FEATURE** spine: `PB-draft-prd` → `H-PLAN` → `PB-decompose-issues` → `H-DECOMPOSE` → `PB-implement`.

**FEAT path:** `PB-draft-feature` → `H-PLAN` → optionally `PB-decompose-issues` when PRD-equivalent plan exists.

---

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why umbrella exists; when not to invoke |
| [02-responsibilities.md](./02-responsibilities.md) | Documentation duties vs child playbooks |
| [03-workflow.md](./03-workflow.md) | Routing resolution steps for humans/agents |
| [04-io-contract.md](./04-io-contract.md) | Documentation-only I/O (no orchestrator contract) |
| [05-context.md](./05-context.md) | What to read before routing decisions |
| [06-quality.md](./06-quality.md) | Advisory `CL-FEAT-PLAN` + child checklist refs |
| [07-edge-cases.md](./07-edge-cases.md) | Wrong routing ID scenarios (≥15 EC-RT-*) |
| [08-limitations.md](./08-limitations.md) | Cannot invoke; no artifact production |
| [09-system-prompt.md](./09-system-prompt.md) | Meta guidance — **never deploy as invoke target** |
| [10-review.md](./10-review.md) | Architect review record |
| [11-test-plan.md](./11-test-plan.md) | Umbrella identity, routing, build-order tests |

---

## Related Playbooks

| Playbook | Relationship |
|----------|--------------|
| [PB-draft-feature](../draft-feature/) | Child routing ID — Plan / FEAT |
| [PB-decompose-issues](../decompose-issues/) | Child routing ID — Decompose / ISS-* |
| [PB-draft-prd](../draft-prd/) | Sibling Plan path — PRD (not under umbrella routing_ids) |
| [PB-discovery-research](../discovery-research/) | Upstream — DISC for draft-feature path |

---

## Build Order

From `skills/meta-skill/SKILL-CATALOG.yaml`:

1. `PB-draft-prd` (sibling prerequisite context)
2. **`PB-feature-planner`** (umbrella spec — this folder)
3. Author/promote children: `PB-draft-feature`, then `PB-decompose-issues`

Umbrella promotion does **not** unblock orchestrator execution of children; each child has its own promotion gate.

---

## Version & Promotion Status

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | active (documentation umbrella) |
| promotion gate | Documentation completeness — see [11-test-plan.md](./11-test-plan.md) |
| orchestrator registration | **Excluded** — umbrella not in routing-matrix invoke list |