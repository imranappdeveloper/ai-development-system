# PB-feature-planner — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |
| type | umbrella |

---

## One-Liner

Document **how feature planning work maps to routable playbooks** (`PB-draft-feature`, `PB-decompose-issues`) — and **never** execute as an orchestrator skill.

---

## What Problem Does It Solve?

"Feature planning" spans multiple SDLC phases and playbooks. Humans and agents naturally say **"Feature Planner"** or **"plan this feature"** without knowing which `PB-*` routing ID applies.

Without this umbrella:

| Failure | Cost |
|---------|------|
| `PB-feature-planner` invoked as a skill | Orchestrator deadlock — no I/O contract, no artifacts |
| Wrong child selected (FEAT vs PRD vs decompose) | Rework loops, missing gates, invalid ISS-* |
| Decompose merged into Plan phase | Scope creep in PRD/FEAT; H-DECOMPOSE bypassed |
| Build program treats umbrella as blocking skill | Children delayed; false dependency on non-invokable ID |
| Adapter deploys umbrella prompt as executable skill | Silent misrouting |

**This umbrella solves the identity and routing-resolution problem** for feature planning. It is the **human-facing label** and **documentation SSOT** for when to use each child routing ID.

It does **not** draft PRDs, feature specs, or issues.

---

## Why Does It Exist?

Per **STD-NAMING-001** §Exceptions and P0 #15 identity resolution:

1. **SKILL-CATALOG** lists `PB-feature-planner` as a build-order item — a folder must exist with clear semantics.
2. **Orchestrator** must invoke concrete skills — `PB-draft-feature` and `PB-decompose-issues` — not umbrella labels.
3. **Agents** need a single place to resolve "run feature planner" into correct routing IDs.
4. **Authors** need build-order guidance for child playbook promotion.

The umbrella is **active as documentation** — not as a deployable execution skill.

---

## When Should It Be Used?

Consult **this folder** (read spec, decision matrix, golden examples) when:

| Condition | Action |
|-----------|--------|
| Human says "Feature Planner", "plan the feature", "break down feature" | Resolve routing ID per [03-workflow.md](./03-workflow.md) |
| Authoring or reviewing feature-planning playbooks | Use build order in README + [11-test-plan.md](./11-test-plan.md) |
| Agent unsure: `PB-draft-feature` vs `PB-decompose-issues` | Load `fixtures/decision-matrix.yaml` |
| Onboarding to OS feature-planning spine | Read identity table in README |
| SKILL-CATALOG build program tracking | Umbrella marks documentation milestone |

### Typical routing outcomes (not umbrella invocation)

| Situation | Route to |
|-----------|----------|
| DISC complete; narrow slice; PRD waived | `PB-draft-feature` |
| Approved PRD; need ISS-* for implement | `PB-decompose-issues` |
| Full WF-FEATURE plan document needed | `PB-draft-prd` (sibling) then `PB-decompose-issues` |
| Single bugfix issue | `PB-draft-issue` (outside umbrella) |

---

## When Should It NOT Be Used?

| Situation | Why not | Use instead |
|-----------|---------|-------------|
| ORCH-PROJECT skill invocation | Umbrella is not in routing-matrix | `PB-draft-feature` or `PB-decompose-issues` |
| `playbook_invocation.skill_id: PB-feature-planner` | Forbidden — no execution contract | Resolve child per decision matrix |
| Producing FEAT, PRD, or ISS-* artifacts | Umbrella produces nothing | Child playbook |
| Passing H-PLAN or H-DECOMPOSE | Umbrella has `exit_gate: none` | Child with correct gate |
| Platform adapter "skill" deployment | Prompt is meta-only | Child `09-system-prompt.md` |
| Replacing child specs | Children remain SSOT for execution | `playbooks/draft-feature/`, `playbooks/decompose-issues/` |

### Challenge: "But the user said Feature Planner"

**Resolve, do not invoke.** Translate intent:

```text
"Run Feature Planner" → Which phase? Plan → PB-draft-feature or PB-draft-prd
                      → Decompose → PB-decompose-issues (requires H-PLAN + PRD)
```

See [09-system-prompt.md](./09-system-prompt.md) meta guidance.

---

## Single Responsibility

> **Document umbrella identity, child routing resolution, and build order for feature planning. Never execute planning work.**

The umbrella succeeds when:

1. No orchestrator path lists `PB-feature-planner` as invokable
2. Humans/agents can pick `PB-draft-feature` vs `PB-decompose-issues` without guessing
3. Child playbooks remain authoritative for FEAT and ISS-* production
4. Advisory `CL-FEAT-PLAN` guides routing review without blocking gates

---

## Boundaries

| In scope | Out of scope |
|----------|--------------|
| Identity resolution P0 #15 | PRD authoring (`PB-draft-prd`) |
| Routing decision documentation | FEAT authoring (`PB-draft-feature` execution) |
| Build order for catalog | Issue decomposition (`PB-decompose-issues` execution) |
| Anti-patterns for wrong ID usage | Implementation (`PB-implement`) |
| Advisory quality checklist | Human gate execution |

---

## Workflow Context

| Field | Value |
|-------|-------|
| type | umbrella |
| orchestrator_phase | none |
| exit_gate | none |
| routing_ids | PB-draft-feature, PB-decompose-issues |
| blocking | false — documentation only |

---

## Related Standards

| Ref | Relationship |
|-----|--------------|
| STD-NAMING-001 | Umbrella label exception |
| STD-SKILL-001 | Contract with documented waivers (W-UMB-01–03) |
| skill-dependency-graph.yaml | Child dependencies and WF-FEATURE spine |
| routing-matrix.yaml | Invokable IDs only |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.0 | 2026-06-18 | Complete umbrella purpose — active documentation |