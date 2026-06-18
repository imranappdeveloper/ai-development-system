# PB-implement — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |
| type | umbrella |

---

## One-Liner

Document **how implementation work maps to routable lane playbooks** (`PB-implement-backend`, `PB-implement-frontend`, `PB-implement-mobile`, `PB-implement-devops`) — and **never** execute as an orchestrator skill.

---

## What Problem Does It Solve?

"Implementation" spans multiple technology lanes and SDLC handoffs. Humans and agents naturally say **"Implement this"** or **"Build the feature"** without knowing which `PB-implement-*` routing ID applies.

Without this umbrella:

| Failure | Cost |
|---------|------|
| `PB-implement` invoked as a skill | Orchestrator deadlock — no lane I/O contract, ambiguous CODE output |
| Wrong lane selected (frontend vs backend) | Cross-lane rework, broken contracts, merge conflicts |
| All lanes merged into one invoke | Token blowout, unclear H-IMPLEMENT scope |
| Implement without ISS-* | H-DECOMPOSE bypassed; untraceable scope |
| Build program treats umbrella as blocking skill | Lane children delayed; false dependency on non-invokable ID |
| Adapter deploys umbrella prompt as executable skill | Silent misrouting across repos |

**This umbrella solves the identity and lane-routing problem** for implementation. It is the **human-facing label** and **documentation SSOT** for when to use each child routing ID.

It does **not** write application code, migrations, components, or pipeline configs.

---

## Why Does It Exist?

Per **STD-NAMING-001** §Exceptions and P0 identity resolution:

1. **SKILL-CATALOG** and **LIFECYCLE.md** list `PB-implement` as an engineering-chain umbrella — a folder must exist with clear semantics.
2. **Orchestrator** must invoke concrete lane skills — not umbrella labels.
3. **Agents** need a single place to resolve "implement the feature" into correct routing IDs.
4. **Authors** need build-order guidance for lane playbook promotion after `PB-draft-ui-ux` gate PASS.

The umbrella is **draft as documentation** — not as a deployable execution skill.

---

## When Should It Be Used?

Consult **this folder** (read spec, decision matrix, golden examples) when:

| Condition | Action |
|-----------|--------|
| Human says "Implement", "build it", "write the code" | Resolve lane per [03-workflow.md](./03-workflow.md) |
| Authoring or reviewing implement-lane playbooks | Use build order in README + [11-test-plan.md](./11-test-plan.md) |
| Agent unsure: backend vs frontend vs mobile vs devops | Load `fixtures/decision-matrix.yaml` |
| Onboarding to OS implement spine | Read identity table in README |
| SKILL-CATALOG build program tracking | Umbrella marks documentation milestone after UI/UX gate |

### Typical routing outcomes (not umbrella invocation)

| Situation | Route to |
|-----------|----------|
| ISS-* with API/DB scope | `PB-implement-backend` |
| ISS-* with UIUX web scope | `PB-implement-frontend` |
| ISS-* with mobile-primary UIUX | `PB-implement-mobile` |
| ISS-* tagged cicd/infra | `PB-implement-devops` |
| Full-stack feature ISS | Multiple lane children in parallel |
| WF-BUGFIX single ISS (UI) | `PB-implement-frontend` |
| WF-BUGFIX single ISS (default) | `PB-implement-backend` (verify tags) |

---

## When Should It NOT Be Used?

| Situation | Why not | Use instead |
|-----------|---------|-------------|
| ORCH-PROJECT skill invocation | Umbrella is not in routing-matrix invoke list (target state) | Lane child per decision matrix |
| `playbook_invocation.skill_id: PB-implement` | Forbidden — no execution contract | Resolve child per decision matrix |
| Producing CODE artifacts | Umbrella produces nothing | Lane child playbook |
| Passing H-IMPLEMENT | Umbrella has `exit_gate: none` | Lane child with correct gate |
| Platform adapter "skill" deployment | Prompt is meta-only | Child `09-system-prompt.md` |
| Replacing child specs | Children remain SSOT for execution | `playbooks/implement-*/` (when authored) |
| Planning API/UI/DB design | Plan phase | `PB-draft-api`, `PB-draft-ui-ux`, `PB-draft-database` |
| Verification or review | Post-implement | `PB-verify`, `PB-review` |

### Challenge: "But the user said Implement"

**Resolve, do not invoke.** Translate intent:

```text
"Implement the feature" → Which lane(s)? backend | frontend | mobile | devops
                       → ISS-* present? If no → PB-decompose-issues or PB-draft-issue first
                       → Multi-lane? → parallel child invokes
```

See [09-system-prompt.md](./09-system-prompt.md) meta guidance.

---

## Single Responsibility

> **Document umbrella identity, lane routing resolution, and build order for implementation. Never execute implementation work.**

The umbrella succeeds when:

1. No orchestrator path lists `PB-implement` as invokable (target state after child migration)
2. Humans/agents can pick the correct lane child without guessing
3. Lane playbooks remain authoritative for CODE production
4. Advisory `CL-IMPLEMENT-UMBRELLA` guides routing review without blocking gates

---

## Boundaries

| In scope | Out of scope |
|----------|--------------|
| Identity resolution for Implementation label | API/UI/DB plan authoring |
| Lane routing decision documentation | CODE production (all lanes) |
| Build order for engineering catalog | Issue decomposition (`PB-decompose-issues` execution) |
| Anti-patterns for wrong ID usage | Verification (`PB-verify`) |
| Advisory quality checklist | Human gate execution |
| Prerequisite gate documentation (PB-draft-ui-ux) | Child playbook authoring (separate folders) |

---

## Workflow Context

| Field | Value |
|-------|-------|
| type | umbrella |
| orchestrator_phase | none |
| exit_gate | none |
| routing_ids | PB-implement-backend, PB-implement-frontend, PB-implement-mobile, PB-implement-devops |
| blocking | false — documentation only |
| prerequisite | PB-draft-ui-ux sequential gate PASS |

---

## Related Standards

| Ref | Relationship |
|-----|--------------|
| STD-NAMING-001 | Umbrella label exception |
| STD-SKILL-001 | Contract with documented waivers (W-UMB-01–03) |
| skill-dependency-graph.yaml | Implement phase dependencies |
| routing-matrix.yaml | Invokable lane IDs (children when promoted) |
| LIFECYCLE.md | Engineering build order |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.0 | 2026-06-18 | Complete umbrella purpose — draft documentation |