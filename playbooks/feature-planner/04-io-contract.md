# PB-feature-planner — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 04-io-contract |
| type | umbrella |

---

## Overview

**PB-feature-planner is not orchestrator-invokable.** This contract documents **consultation inputs** (what readers provide when resolving routing) and **documentation outputs** (routing recommendations only).

**Contract rule:** No undocumented I/O for routing-resolution consultations. **No OUT-* artifacts** are written to Work Record by the umbrella.

**Waiver W-UMB-03:** Standard execution IN/OUT envelope does not apply.

---

## Input Summary

| Category | Count | Required |
|----------|-------|----------|
| Consultation context | 5 | 2–5 |
| Environment | 2 | 2 |
| OS artifacts (read) | 4 | 3 |
| Project artifacts (read) | 3 | 0–3 conditional |

---

## Inputs — Consultation Context

### IN-01: `routing_question`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Source** | Human or agent |
| **Format** | Natural language or structured `resolve_routing: true` |

**Examples:** "Run feature planner", "Should I decompose or draft feature?", "Plan this enhancement"

**Validation:** Must not be satisfied by direct child invoke with known valid `skill_id`.

---

### IN-02: `current_phase`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Work Record, ORS, session |
| **Format** | `Plan` \| `Decompose` \| `Implement` \| `unknown` |

**Default:** Infer from artifacts (PRD present → post-Plan).

---

### IN-03: `workflow_id`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | INT, Work Record |
| **Format** | `WF-*` |

**Validation:** If present, must exist in INDEX.

---

### IN-04: `artifact_inventory`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Work Record paths |
| **Format** | List of artifact types: `DISC`, `PRD`, `FEAT`, `ISS-*`, `ISS` |

**Purpose:** Drives plan vs decompose routing.

---

### IN-05: `proposed_skill_id`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Agent or orchestrator (pre-invoke check) |
| **Format** | `PB-*` |

**Validation:** If `PB-feature-planner` → trigger redirect flow (Step 1, 03-workflow).

---

## Inputs — Environment

### IN-20: `ai_dev_os_home`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Source** | Session envelope |
| **Format** | Absolute path |

---

### IN-21: `project_root`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Session envelope |
| **Format** | Absolute path or null |

---

## Inputs — OS Artifacts (read)

### IN-30: `INDEX.md`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Purpose** | Validate child playbook paths and status |

---

### IN-31: `routing-matrix.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Purpose** | Invokable child SSOT |

---

### IN-32: `skill-dependency-graph.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | recommended |
| **Purpose** | Phase dependencies, WF-FEATURE spine |

---

### IN-33: `fixtures/decision-matrix.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | recommended |
| **Purpose** | Machine-readable routing rules |

---

## Inputs — Project Artifacts (read)

### IN-40: `INT` / intake record

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | workflow_id unknown |

---

### IN-41: `PRD` artifact

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | Decompose routing considered |

---

### IN-42: `DISC` artifact

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | PB-draft-feature path considered |

---

## Outputs — Documentation Only

### OUT-DOC-01: `routing_resolution`

| Attribute | Value |
|-----------|-------|
| **Type** | Ephemeral documentation / chat block |
| **Persisted** | **No** — not written to Work Record |
| **Format** | YAML block per 03-workflow Step 5 |

**Fields:**

```yaml
routing_resolution:
  umbrella_consulted: PB-feature-planner
  resolved_targets: []
  never_invoke: PB-feature-planner
  routing_confidence: high | medium | low
  blockers: []
  advisory_checklist: CL-FEAT-PLAN
```

---

### OUT-DOC-02: `redirect_notice`

| Attribute | Value |
|-----------|-------|
| **When** | IN-05 = `PB-feature-planner` |
| **Content** | Explicit message: umbrella not invokable; list child IDs |
| **Persisted** | No |

---

## Human-Only Outputs

| Output | Owner |
|--------|-------|
| H-PLAN approval | Human — child Plan skills |
| H-DECOMPOSE approval | Human — PB-decompose-issues |
| PRD, FEAT, ISS-* artifacts | Child playbooks |

Umbrella produces **none** of these.

---

## Invoke Template (forbidden)

```yaml
# ⛔ INVALID — DO NOT USE
playbook_invocation:
  skill_id: PB-feature-planner  # FORBIDDEN
```

### Valid child invoke (reference)

```yaml
playbook_invocation:
  skill_id: PB-draft-feature  # or PB-decompose-issues
  mode: new
work_id: WR-###
ai_dev_os_home: /path/to/ai-development-system
project_root: /path/to/project
```

---

## Contract Rule

| Rule | Enforcement |
|------|-------------|
| Umbrella never in orchestrator invoke list | routing-matrix.yaml |
| No OUT-* Work Record artifacts from umbrella | Agent MUST NOT persist FEAT/PRD/ISS |
| Routing resolution must name ≥1 child or explicit blockers | CL-FEAT-PLAN #1 |
| Undocumented consultation fields forbidden | This file is exhaustive for umbrella |