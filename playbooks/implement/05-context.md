# PB-implement — Context

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 05-context |
| type | umbrella |

---

## Overview

Context guidance for **consulting** the umbrella — not for executing a long-running implement job. Budgets are minimal because lane routing is a short decision, not CODE production.

---

## Context Layers

| Layer | Content | Load when |
|-------|---------|-----------|
| **T0** | Session envelope: `ai_dev_os_home`, `work_id`, `workflow_id` | Always |
| **T1** | Umbrella spec: README, 03-workflow, decision matrix | Routing question |
| **T2** | OS routing: routing-matrix, skill-dependency-graph | Lane selection |
| **T3** | Project artifacts: ISS-*, API, UIUX, WR | Lane disambiguation |

**Do not load** child `09-system-prompt.md` files when only resolving routing — load child spec **after** resolution.

**Do not load** full project source trees during routing — lane children own codebase context per STD-CTX-001.

---

## Allowed Reads

| Path | Layer | Purpose |
|------|-------|---------|
| `playbooks/implement/README.md` | T1 | Identity |
| `playbooks/implement/03-workflow.md` | T1 | Steps |
| `playbooks/implement/fixtures/decision-matrix.yaml` | T1 | Lane rules |
| `playbooks/implement/examples/golden/*` | T1 | Examples |
| `playbooks/draft-ui-ux/test-runs/latest-gate.md` | T1 | Prerequisite gate |
| `INDEX.md` | T2 | Catalog |
| `workflows/project-orchestrator/routing-matrix.yaml` | T2 | Invokable SSOT |
| `workflows/project-orchestrator/skill-dependency-graph.yaml` | T2 | Dependencies |
| `work/{work_id}.md` | T3 | Phase status, lane tags |
| `work/intake/{work_id}.md` | T3 | workflow_id |
| ISS-* / ISS artifact paths (metadata) | T3 | Lane signals |
| API / UIUX / DB artifact paths (existence) | T3 | Lane hints |

---

## Forbidden Reads (during routing only)

| Path | Reason |
|------|--------|
| Target project source code trees | Belongs to lane child execution — not routing |
| Child 09-system-prompt before resolution | Premature execution |
| Unrelated playbook specs | Token waste |
| `skills/` adapter copies | SSOT is playbooks/ |
| Full PRD body unless platform tag unknown | Metadata sufficient for lane choice |

---

## Budget Table

| Resource | Cap | Rationale |
|----------|-----|-----------|
| Total tokens (routing consultation) | ≤ 8K | Decision-only |
| Files read | ≤ 14 | Matrix + registries + WR + ISS headers |
| Project artifact depth | Metadata + ISS tags + existence check | No full codebase |
| Mermaid / diagram rendering | 0 in agent output | Reference only |

If routing requires full ISS epic review, **hand off to lane child** — umbrella does not absorb implement work.

---

## Memory Strategy

| Data | Persist? | Where |
|------|----------|-------|
| Routing resolution YAML | No | Ephemeral chat only |
| Resolved lane skill_id(s) | Yes | Next child invoke envelope |
| "Used umbrella" flag | Optional | WR note — `os_refs.umbrella_consulted: PB-implement` |
| CL-IMPLEMENT-UMBRELLA result | Optional | WR debug section — not a gate |

**Never** record `os_refs.skill: PB-implement` as a completed skill run.

---

## Context Assembly Checklist (C1–C6)

| ID | Check | Pass |
|----|-------|------|
| C1 | routing-matrix loaded | `PB-implement` absent from invoke keys (target) |
| C2 | Lane child statuses known | planned until children authored |
| C3 | ISS inventory accurate | ISS-* paths match WR |
| C4 | workflow_id consistent with INT | No mismatch without note |
| C5 | Token budget ≤ 8K | No full codebase load |
| C6 | PB-draft-ui-ux prerequisite documented | test-runs/latest-gate.md PASS |