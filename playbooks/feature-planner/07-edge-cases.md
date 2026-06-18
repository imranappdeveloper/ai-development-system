# PB-feature-planner — Edge Cases & Failure Scenarios

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |
| type | umbrella |

---

## Overview

Edge cases for **wrong routing ID usage** and **umbrella misuse**. Prescribed behavior — agents must not improvise alternate invoke paths.

**Legend — Human intervention**

| Code | Meaning |
|------|---------|
| **Y** | Human required |
| **N** | Agent recovers per rules |
| **O** | Optional human acceleration |

---

## Category Index

| Category | ID range | Count |
|----------|----------|-------|
| Umbrella invocation errors | EC-RT-01 – 05 | 5 |
| Plan-path routing errors | EC-RT-06 – 10 | 5 |
| Decompose-path routing errors | EC-RT-11 – 15 | 5 |
| Integration & catalog errors | EC-RT-16 – 18 | 3 |

**Total P0 scenarios: 18**

---

## 1. Umbrella Invocation Errors

### EC-RT-01: ORCH-PROJECT invokes PB-feature-planner

| Field | Value |
|-------|-------|
| **Trigger** | `playbook_invocation.skill_id: PB-feature-planner` in orchestrator envelope |
| **Impact** | No I/O contract; no artifacts; pipeline stall |
| **Expected behavior** | Fail fast; emit OUT-DOC-02 redirect; resolve child per decision matrix |
| **Recovery** | Re-invoke with `PB-draft-feature` or `PB-decompose-issues` |
| **Human intervention** | **O** |

---

### EC-RT-02: PB-feature-planner added to routing-matrix.yaml

| Field | Value |
|-------|-------|
| **Trigger** | Maintainer adds umbrella to orchestrator invoke keys |
| **Impact** | Systemic misrouting across all workflows |
| **Expected behavior** | MS-standards-review / architect rejects; remove row |
| **Recovery** | Revert routing-matrix; document in 10-review |
| **Human intervention** | **Y** |

---

### EC-RT-03: Work Record os_refs.skill = PB-feature-planner

| Field | Value |
|-------|-------|
| **Trigger** | Agent records completed run under umbrella skill_id |
| **Impact** | False audit trail; downstream assumes artifacts exist |
| **Expected behavior** | Mark run invalid; do not advance phase |
| **Recovery** | Correct os_refs to actual child; re-run child if needed |
| **Human intervention** | **O** |

---

### EC-RT-04: Platform adapter deploys umbrella as executable skill

| Field | Value |
|-------|-------|
| **Trigger** | `skills/feature-planner/` adapter copies 09-system-prompt for invoke |
| **Impact** | Vendor "skill" invokes non-executable ID |
| **Expected behavior** | Adapter MUST map "Feature Planner" alias → routing resolver, not invoke |
| **Recovery** | Fix adapter manifest; point to meta prompt only |
| **Human intervention** | **Y** |

---

### EC-RT-05: Human says "run feature planner" — agent invokes umbrella

| Field | Value |
|-------|-------|
| **Trigger** | Natural language maps to PB-feature-planner skill_id |
| **Impact** | Same as EC-RT-01 |
| **Expected behavior** | Parse intent → routing resolution → child invoke |
| **Recovery** | 09-system-prompt redirect flow |
| **Human intervention** | **N** |

---

## 2. Plan-Path Routing Errors

### EC-RT-06: PB-decompose-issues invoked without PRD

| Field | Value |
|-------|-------|
| **Trigger** | Decompose invoked; IN-41 PRD absent; H-PLAN may be pending |
| **Impact** | ISS-* without plan SSOT |
| **Expected behavior** | Block decompose; route to PB-draft-prd or PB-draft-feature |
| **Recovery** | Complete Plan phase first |
| **Human intervention** | **Y** |

---

### EC-RT-07: PB-draft-feature chosen for multi-epic WF-FEATURE

| Field | Value |
|-------|-------|
| **Trigger** | Large scope; agent picks FEAT path to save time |
| **Impact** | Under-specified plan; decompose starved |
| **Expected behavior** | Set `routing_confidence: medium`; recommend PB-draft-prd |
| **Recovery** | Human confirms FEAT path waiver or switch to PRD |
| **Human intervention** | **Y** |

---

### EC-RT-08: PB-draft-prd chosen for single-slice enhancement

| Field | Value |
|-------|-------|
| **Trigger** | Narrow enhancement; full PRD requested by habit |
| **Impact** | Ceremony excess; delayed delivery |
| **Expected behavior** | Recommend PB-draft-feature when DISC sufficient |
| **Recovery** | Human selects path at H-PLAN |
| **Human intervention** | **O** |

---

### EC-RT-09: Both PB-draft-prd and PB-draft-feature run without waiver

| Field | Value |
|-------|-------|
| **Trigger** | Parallel Plan artifacts PRD + FEAT |
| **Impact** | Duplicate SSOT; conflicting requirements |
| **Expected behavior** | Flag AC-CON-02 fail; halt decompose until human picks one |
| **Recovery** | Deprecate one artifact; revise at H-PLAN |
| **Human intervention** | **Y** |

---

### EC-RT-10: PB-draft-feature invoked without DISC or H-FRAME

| Field | Value |
|-------|-------|
| **Trigger** | FEAT path; DISC missing; gate not approved |
| **Impact** | FEAT without discovery grounding |
| **Expected behavior** | Block; recommend PB-discovery-research or PB-draft-prd |
| **Recovery** | Complete Frame phase |
| **Human intervention** | **Y** |

---

## 3. Decompose-Path Routing Errors

### EC-RT-11: Decompose work merged into PRD/FEAT drafting

| Field | Value |
|-------|-------|
| **Trigger** | ISS-* tasks appear inside PRD or FEAT document |
| **Impact** | H-DECOMPOSE bypassed; implement scope embedded in plan |
| **Expected behavior** | Reject; split issues to PB-decompose-issues pass |
| **Recovery** | Strip issues from plan doc; run decompose |
| **Human intervention** | **Y** |

---

### EC-RT-12: PB-decompose-issues on WF-BUGFIX path

| Field | Value |
|-------|-------|
| **Trigger** | workflow_id WF-BUGFIX; agent invokes decompose |
| **Impact** | Wrong skill; bugfix uses single ISS |
| **Expected behavior** | Redirect to PB-draft-issue |
| **Recovery** | Cancel decompose invoke |
| **Human intervention** | **N** |

---

### EC-RT-13: Skip PB-decompose-issues on multi-epic PRD without waiver

| Field | Value |
|-------|-------|
| **Trigger** | Large PRD; agent routes directly to PB-implement |
| **Impact** | Undefined implement scope |
| **Expected behavior** | Block implement; require decompose or explicit human waiver |
| **Recovery** | Invoke PB-decompose-issues |
| **Human intervention** | **Y** |

---

### EC-RT-14: PB-decompose-issues before H-PLAN approval

| Field | Value |
|-------|-------|
| **Trigger** | PRD draft exists but H-PLAN decision pending |
| **Impact** | Issues from unapproved plan |
| **Expected behavior** | Block decompose until H-PLAN approve |
| **Recovery** | Await human gate |
| **Human intervention** | **Y** |

---

### EC-RT-15: FEAT-only path forces decompose without PRD waiver

| Field | Value |
|-------|-------|
| **Trigger** | FEAT approved; decompose invoked; graph expects PRD |
| **Impact** | Entry criteria mismatch |
| **Expected behavior** | Check routing-matrix waiver or single-issue path; else human waiver |
| **Recovery** | Document waiver in WR; or produce PRD slice |
| **Human intervention** | **Y** |

---

## 4. Integration & Catalog Errors

### EC-RT-16: SKILL-CATALOG build treats umbrella as child blocker

| Field | Value |
|-------|-------|
| **Trigger** | CI waits for umbrella execution before decompose promotion |
| **Impact** | False dependency |
| **Expected behavior** | Build order = documentation only; children promote independently |
| **Recovery** | Fix CI/catalog interpretation |
| **Human intervention** | **Y** |

---

### EC-RT-17: CL-FEAT-PLAN treated as blocking gate

| Field | Value |
|-------|-------|
| **Trigger** | Agent refuses child invoke until CL-FEAT-PLAN file exists on disk |
| **Impact** | Unnecessary block — checklist is advisory |
| **Expected behavior** | Run advisory inline; proceed to child CL-DRAFT/CL-DECOMP |
| **Recovery** | Clarify 06-quality waiver |
| **Human intervention** | **N** |

---

### EC-RT-18: routing_ids confused with next_candidates only

| Field | Value |
|-------|-------|
| **Trigger** | Agent invokes PB-draft-architecture as "feature planner" |
| **Impact** | Wrong phase skill |
| **Expected behavior** | Limit resolution to routing_ids + documented siblings (draft-prd) |
| **Recovery** | Re-resolve per decision matrix |
| **Human intervention** | **O** |