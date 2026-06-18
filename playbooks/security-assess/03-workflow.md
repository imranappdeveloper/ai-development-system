# PB-security-assess — Workflow

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 03-workflow |

---

## Overview

Nine-step linear workflow: verify entry → load context → model threats → document controls → persist → validate → hand off at H-PLAN.

---

## Steps

| Step | ID | Action |
|------|-----|--------|
| 1 | INIT | Verify entry criteria; load INDEX, CL-SECURI, INT path from WR |
| 2 | LOAD | Read INT + CONTEXT slice; bounded architecture markers |
| 3 | MODEL | Build threat model (STRIDE default); assets and trust boundaries |
| 4 | DOC | Build SEC-ASSESS per 04-io-contract — scope, controls, risks, remediation |
| 5 | PERSIST | Write `{project_root}/work/security/{work_id}.md`; update Work Record |
| 6 | VAL | CL-SECURI (10 checks); recovery ≤3 attempts |
| 7 | HAND | Handoff package; **stop** — await H-PLAN |
| 8 | STOP | No downstream invoke until human approves |
| 9 | LOG | Record validation in OUT-03 |

```mermaid
flowchart LR
    INIT[1 INIT] --> LOAD[2 LOAD]
    LOAD --> MODEL[3 MODEL]
    MODEL --> DOC[4 DOC]
    DOC --> PERSIST[5 PERSIST]
    PERSIST --> VAL[6 CL-SECURI]
    VAL --> HAND[7 HAND]
    HAND --> H[H-PLAN]
```

---

## Entry Criteria

| # | Criterion |
|---|-----------|
| EC-ENT-01 | `work_id` and approved INT exist |
| EC-ENT-02 | H-INTAKE gate satisfied per routing-matrix |
| EC-ENT-03 | No prior SEC-ASSESS with H-PLAN `approve` unless `mode: revise` |
| EC-ENT-04 | `workflow_id: WF-SECURITY` or INT `work_type: security` |
| EC-ENT-05 | `project_root` resolvable when required |
| EC-ENT-06 | WR records INT path in `artifacts[]` |
| EC-ENT-07 | PB-intake-classify promotion gate PASS |

---

## Exit Criteria

| # | Criterion |
|---|-----------|
| XC-01 | OUT-01 persisted (or `persist: pending` with human ack) |
| XC-02 | CL-SECURI `result: pass` |
| XC-03 | OUT-04 handoff includes `gate_id: H-PLAN`, `decision: pending` |
| XC-04 | WR `status: security_assess_pending_review` |

---

## Human Gate — H-PLAN

| Field | Rule |
|-------|------|
| gate_id | `H-PLAN` |
| Agent sets | `decision: pending` only |
| Human options | `approve` \| `revise` \| `reject` |
| On approve | WR status advanced; may recommend `PB-implement` |
| On revise | Re-enter LOAD with `human_revise_notes`; increment `revision` |
| On reject | WR status rejected; orchestrator recovery |

---

## Revise Loop

Human `revise` at H-PLAN → re-enter **LOAD** → update SEC-ASSESS → full CL-SECURI → handoff again.

---

## Recovery

CL-SECURI fail → fix per `checklists/security.md` recovery table → re-VAL (≤3) → OUT-05 escalation.

---

## Next Playbook Routing (recommend only)

| Signal | Primary | Alternate |
|--------|---------|-----------|
| Default WF-SECURITY success | PB-implement | Lane child per WR |
| Assessment-only / advisory path | PB-security-review | After implement + H-IMPLEMENT |
| Upstream gap | PB-intake-classify | Human waiver |
| Wrong workflow | Block — cite EC-ENT-* | — |

---

## Sequential Gates (promotion)

| Prerequisite | Gate record | Required verdict |
|--------------|-------------|------------------|
| PB-intake-classify | `playbooks/intake-classify/test-runs/latest-gate.md` | VERDICT PASS |

Promotion chain documented in `test-runs/latest-gate.md` and `11-test-plan.md` ENV-06.