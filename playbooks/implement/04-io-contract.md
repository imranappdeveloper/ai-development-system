# PB-implement — I/O Contract

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 04-io-contract |
| type | umbrella |

---

## Overview

**PB-implement is not orchestrator-invokable.** This contract documents **consultation inputs** (what readers provide when resolving lane routing) and **documentation outputs** (routing recommendations only).

**Contract rule:** No undocumented I/O for routing-resolution consultations. **No OUT-* CODE artifacts** are written to Work Record by the umbrella.

**Waiver W-UMB-03:** Standard execution IN/OUT envelope does not apply.

---

## Input Summary

| Category | Count | Required |
|----------|-------|----------|
| Consultation context | 6 | 2–6 |
| Environment | 2 | 2 |
| OS artifacts (read) | 4 | 3 |
| Project artifacts (read) | 5 | 0–5 conditional |

---

## Inputs — Consultation Context

### IN-01: `routing_question`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Source** | Human or agent |
| **Format** | Natural language or structured `resolve_routing: true` |

**Examples:** "Implement the feature", "Build the API handlers", "Which implement skill?"

**Validation:** Must not be satisfied by direct lane child invoke with known valid `skill_id`.

---

### IN-02: `current_phase`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Work Record, ORS, session |
| **Format** | `Implement` \| `Decompose` \| `unknown` |

**Default:** Infer from artifacts (ISS-* present → Implement-ready).

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
| **Format** | List: `ISS-*`, `ISS`, `API`, `DB`, `UIUX`, `ARCH`, `PRD` |

**Purpose:** Drives lane routing and entry criteria.

---

### IN-05: `proposed_skill_id`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | Agent or orchestrator (pre-invoke check) |
| **Format** | `PB-*` |

**Validation:** If `PB-implement` → trigger redirect flow (Step 1, 03-workflow).

---

### IN-06: `lane_signals`

| Attribute | Value |
|-----------|-------|
| **Required** | optional |
| **Source** | ISS tags, WR notes, plan artifact types |
| **Format** | List of strings from `enums.implement_lane` signals |

**Purpose:** Disambiguate backend vs frontend vs mobile vs devops.

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
| **Purpose** | Validate lane playbook paths and status |

---

### IN-31: `routing-matrix.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | yes |
| **Purpose** | Invokable lane child SSOT (when promoted) |

---

### IN-32: `skill-dependency-graph.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | recommended |
| **Purpose** | Implement phase dependencies, H-IMPLEMENT binding |

---

### IN-33: `fixtures/decision-matrix.yaml`

| Attribute | Value |
|-----------|-------|
| **Required** | recommended |
| **Purpose** | Machine-readable lane routing rules |

---

## Inputs — Project Artifacts (read)

### IN-40: `INT` / intake record

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | workflow_id unknown |

---

### IN-41: `ISS-*` or `ISS` artifacts

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | Implement routing considered — **mandatory** unless WF-BUGFIX waiver |

---

### IN-42: `API` / `DB` / `UIUX` plan artifacts

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | Lane disambiguation needed |

---

### IN-43: `PRD` platform scope

| Attribute | Value |
|-----------|-------|
| **Required** | conditional |
| **When** | frontend vs mobile decision |

---

### IN-44: Prerequisite gate record

| Attribute | Value |
|-----------|-------|
| **Required** | recommended |
| **When** | Engineering chain authoring |
| **Path** | `playbooks/draft-ui-ux/test-runs/latest-gate.md` |

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
  umbrella_consulted: PB-implement
  resolved_targets: []
  never_invoke: PB-implement
  routing_confidence: high | medium | low
  implement_lane: backend | frontend | mobile | devops | multi_lane
  blockers: []
  advisory_checklist: CL-IMPLEMENT-UMBRELLA
```

---

### OUT-DOC-02: `redirect_notice`

| Attribute | Value |
|-----------|-------|
| **When** | IN-05 = `PB-implement` |
| **Content** | Explicit message: umbrella not invokable; list lane child IDs |
| **Persisted** | No |

---

## Human-Only Outputs

| Output | Owner |
|--------|-------|
| H-DECOMPOSE approval | Human — PB-decompose-issues |
| H-IMPLEMENT approval | Human — lane child playbooks |
| CODE artifacts | Lane child playbooks |

Umbrella produces **none** of these.

---

## Invoke Template (forbidden)

```yaml
# ⛔ INVALID — DO NOT USE
playbook_invocation:
  skill_id: PB-implement  # FORBIDDEN
```

### Valid lane child invoke (reference)

```yaml
playbook_invocation:
  skill_id: PB-implement-backend  # or frontend | mobile | devops
  mode: new
work_id: WR-###
ai_dev_os_home: /path/to/ai-development-system
project_root: /path/to/project
```

---

## Contract Rule

| Rule | Enforcement |
|------|-------------|
| Umbrella never in orchestrator invoke list (target) | routing-matrix.yaml migration |
| No OUT-* Work Record CODE from umbrella | Agent MUST NOT persist CODE |
| Routing resolution must name ≥1 lane child or explicit blockers | CL-IMPLEMENT-UMBRELLA #1 |
| Undocumented consultation fields forbidden | This file is exhaustive for umbrella |