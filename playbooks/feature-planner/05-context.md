# PB-feature-planner — Context

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 05-context |
| type | umbrella |

---

## Overview

Context guidance for **consulting** the umbrella — not for executing a long-running agent job. Budgets are minimal because routing resolution is a short decision, not artifact production.

---

## Context Layers

| Layer | Content | Load when |
|-------|---------|-----------|
| **T0** | Session envelope: `ai_dev_os_home`, `work_id`, `workflow_id` | Always |
| **T1** | Umbrella spec: README, 03-workflow, decision matrix | Routing question |
| **T2** | OS routing: routing-matrix, skill-dependency-graph | Child selection |
| **T3** | Project artifacts: INT, DISC, PRD, FEAT, WR | Phase disambiguation |

**Do not load** child `09-system-prompt.md` files when only resolving routing — load child spec **after** resolution.

---

## Allowed Reads

| Path | Layer | Purpose |
|------|-------|---------|
| `playbooks/feature-planner/README.md` | T1 | Identity |
| `playbooks/feature-planner/03-workflow.md` | T1 | Steps |
| `playbooks/feature-planner/fixtures/decision-matrix.yaml` | T1 | Rules |
| `playbooks/feature-planner/examples/golden/*` | T1 | Examples |
| `INDEX.md` | T2 | Catalog |
| `workflows/project-orchestrator/routing-matrix.yaml` | T2 | Invokable SSOT |
| `workflows/project-orchestrator/skill-dependency-graph.yaml` | T2 | Dependencies |
| `playbooks/draft-feature/registry.yaml` | T2 | FEAT path metadata |
| `playbooks/decompose-issues/registry.yaml` | T2 | Decompose metadata |
| `work/{work_id}.md` | T3 | Phase status |
| `work/intake/{work_id}.md` | T3 | workflow_id |
| Project PRD / FEAT / DISC paths | T3 | Artifact inventory |

---

## Forbidden Reads (during routing only)

| Path | Reason |
|------|--------|
| Target project source code trees | Not needed for routing — belongs to PB-survey-codebase / PB-implement |
| Child 09-system-prompt before resolution | Premature execution |
| Unrelated playbook specs | Token waste |
| `skills/` adapter copies | SSOT is playbooks/ |

---

## Budget Table

| Resource | Cap | Rationale |
|----------|-----|-----------|
| Total tokens (routing consultation) | ≤ 8K | Decision-only |
| Files read | ≤ 12 | Matrix + registries + WR |
| Project artifact depth | Metadata + existence check | No full PRD parse unless decompose path |
| Mermaid / diagram rendering | 0 in agent output | Reference only |

If routing requires full PRD review, **hand off to PB-decompose-issues** — umbrella does not absorb decompose work.

---

## Memory Strategy

| Data | Persist? | Where |
|------|----------|-------|
| Routing resolution YAML | No | Ephemeral chat only |
| Resolved child skill_id | Yes | Next child invoke envelope |
| "Used umbrella" flag | Optional | WR note — `os_refs.umbrella_consulted: PB-feature-planner` |
| CL-FEAT-PLAN result | Optional | WR debug section — not a gate |

**Never** record `os_refs.skill: PB-feature-planner` as a completed skill run.

---

## Context Assembly Checklist (C1–C5)

| ID | Check | Pass |
|----|-------|------|
| C1 | routing-matrix loaded | `PB-feature-planner` absent from invoke keys |
| C2 | Child statuses known | draft-feature, decompose-issues registry readable |
| C3 | Artifact inventory accurate | PRD/FEAT/DISC existence matches paths |
| C4 | workflow_id consistent with INT | No mismatch without note |
| C5 | Token budget ≤ 8K | No full codebase load |