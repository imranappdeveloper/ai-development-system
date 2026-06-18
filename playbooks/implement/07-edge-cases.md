# PB-implement — Edge Cases & Failure Scenarios

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |
| type | umbrella |

---

## Overview

Edge cases for **wrong routing ID usage**, **lane misrouting**, and **umbrella misuse**. Prescribed behavior — agents must not improvise alternate invoke paths.

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
| Lane routing errors | EC-RT-06 – 10 | 5 |
| Entry & gate errors | EC-RT-11 – 15 | 5 |
| Integration & catalog errors | EC-RT-16 – 18 | 3 |

**Total P0 scenarios: 18**

---

## 1. Umbrella Invocation Errors

### EC-RT-01: ORCH-PROJECT invokes PB-implement

| Field | Value |
|-------|-------|
| **Trigger** | `playbook_invocation.skill_id: PB-implement` in orchestrator envelope |
| **Impact** | No lane I/O contract; ambiguous CODE; pipeline stall |
| **Expected behavior** | Fail fast; emit OUT-DOC-02 redirect; resolve lane child per decision matrix |
| **Recovery** | Re-invoke with `PB-implement-backend` or other lane child |
| **Human intervention** | **O** |

---

### EC-RT-02: PB-implement retained as sole routing-matrix invoke key

| Field | Value |
|-------|-------|
| **Trigger** | routing-matrix lists `PB-implement` without lane children after child promotion |
| **Impact** | Systemic lane collapse; wrong CODE scope |
| **Expected behavior** | MS-standards-review rejects; migrate to lane IDs |
| **Recovery** | Add lane rows; deprecate umbrella invoke row |
| **Human intervention** | **Y** |

---

### EC-RT-03: Work Record os_refs.skill = PB-implement

| Field | Value |
|-------|-------|
| **Trigger** | Agent records completed run under umbrella skill_id |
| **Impact** | False audit trail; downstream assumes CODE exists |
| **Expected behavior** | Mark run invalid; do not advance to Verify |
| **Recovery** | Correct os_refs to actual lane child; re-run child if needed |
| **Human intervention** | **O** |

---

### EC-RT-04: Platform adapter deploys umbrella as executable skill

| Field | Value |
|-------|-------|
| **Trigger** | `skills/implement/` adapter copies 09-system-prompt for invoke |
| **Impact** | Vendor "skill" invokes non-executable ID |
| **Expected behavior** | Adapter MUST map "Implementation" alias → routing resolver, not invoke |
| **Recovery** | Fix adapter manifest; point to meta prompt only |
| **Human intervention** | **Y** |

---

### EC-RT-05: Human says "implement it" — agent invokes umbrella

| Field | Value |
|-------|-------|
| **Trigger** | Natural language maps to PB-implement skill_id |
| **Impact** | Same as EC-RT-01 |
| **Expected behavior** | Parse intent → lane routing resolution → child invoke |
| **Recovery** | 09-system-prompt redirect flow |
| **Human intervention** | **N** |

---

## 2. Lane Routing Errors

### EC-RT-06: PB-implement-frontend chosen for API-only ISS

| Field | Value |
|-------|-------|
| **Trigger** | ISS tags `api`, `migration`; agent picks frontend lane |
| **Impact** | Wrong codebase touched; contract violations |
| **Expected behavior** | Redirect to PB-implement-backend; anti-pattern IMP-wrong-lane |
| **Recovery** | Cancel frontend invoke; invoke backend |
| **Human intervention** | **N** |

---

### EC-RT-07: PB-implement-backend chosen for UI-only ISS

| Field | Value |
|-------|-------|
| **Trigger** | ISS tags `component`, `css`; UIUX present; backend selected |
| **Impact** | Server changes for UI work |
| **Expected behavior** | Redirect to PB-implement-frontend |
| **Recovery** | Re-resolve per DM-02 |
| **Human intervention** | **N** |

---

### EC-RT-08: PB-implement-mobile on web-only PRD scope

| Field | Value |
|-------|-------|
| **Trigger** | PRD platform `web`; mobile lane selected |
| **Impact** | Unnecessary mobile scaffold; scope creep |
| **Expected behavior** | Recommend PB-implement-frontend; set medium confidence |
| **Recovery** | Human confirms mobile waiver or switch lane |
| **Human intervention** | **Y** |

---

### EC-RT-09: Full-stack ISS collapsed into single lane invoke

| Field | Value |
|-------|-------|
| **Trigger** | ISS epic spans API + UI; one child invoked |
| **Impact** | Incomplete CODE; partial H-IMPLEMENT |
| **Expected behavior** | Emit multi_lane; parallel backend + frontend invokes |
| **Recovery** | Split ISS subtasks per lane |
| **Human intervention** | **O** |

---

### EC-RT-10: PB-implement-devops invoked for application feature ISS

| Field | Value |
|-------|-------|
| **Trigger** | Feature ISS without infra tags; devops lane habit |
| **Impact** | Pipeline-only changes; feature not built |
| **Expected behavior** | Redirect to app lane per ISS tags |
| **Recovery** | Re-consult decision matrix |
| **Human intervention** | **N** |

---

## 3. Entry & Gate Errors

### EC-RT-11: Implement invoked without ISS-* (WF-FEATURE)

| Field | Value |
|-------|-------|
| **Trigger** | H-DECOMPOSE pending or skipped; no ISS paths |
| **Impact** | Untraceable scope; H-DECOMPOSE bypass |
| **Expected behavior** | Block; anti-pattern IMP-skip-issues |
| **Recovery** | Route to PB-decompose-issues |
| **Human intervention** | **Y** |

---

### EC-RT-12: WF-BUGFIX implement without ISS

| Field | Value |
|-------|-------|
| **Trigger** | Bugfix path; no single ISS artifact |
| **Impact** | Ad-hoc code change |
| **Expected behavior** | Block; route to PB-draft-issue |
| **Recovery** | Draft ISS then lane child |
| **Human intervention** | **Y** |

---

### EC-RT-13: Lane child before H-DECOMPOSE (WF-FEATURE)

| Field | Value |
|-------|-------|
| **Trigger** | ISS-* draft exists but H-DECOMPOSE not approved |
| **Impact** | Code from unapproved breakdown |
| **Expected behavior** | Block lane invoke until gate |
| **Recovery** | Await human gate |
| **Human intervention** | **Y** |

---

### EC-RT-14: Frontend lane without UIUX on large surface

| Field | Value |
|-------|-------|
| **Trigger** | Large UI ISS; UIUX absent |
| **Impact** | Inconsistent UX implementation |
| **Expected behavior** | Set blockers; recommend PB-draft-ui-ux or waiver |
| **Recovery** | Complete Plan artifact or document waiver |
| **Human intervention** | **Y** |

---

### EC-RT-15: Backend lane without API spec on breaking change

| Field | Value |
|-------|-------|
| **Trigger** | Breaking API ISS; API artifact absent |
| **Impact** | Contract drift |
| **Expected behavior** | Block or medium confidence with blockers |
| **Recovery** | Route to PB-draft-api first |
| **Human intervention** | **Y** |

---

## 4. Integration & Catalog Errors

### EC-RT-16: SKILL-CATALOG build treats umbrella as lane blocker

| Field | Value |
|-------|-------|
| **Trigger** | CI waits for umbrella execution before backend promotion |
| **Impact** | False dependency |
| **Expected behavior** | Build order = documentation only; children promote independently |
| **Recovery** | Fix CI/catalog interpretation |
| **Human intervention** | **Y** |

---

### EC-RT-17: CL-IMPLEMENT-UMBRELLA treated as blocking gate

| Field | Value |
|-------|-------|
| **Trigger** | Agent refuses lane invoke until checklist file exists on disk |
| **Impact** | Unnecessary block — checklist is advisory |
| **Expected behavior** | Run advisory inline; proceed to child CL-IMPLEMENT |
| **Recovery** | Clarify 06-quality waiver |
| **Human intervention** | **N** |

---

### EC-RT-18: Engineering chain started before PB-draft-ui-ux gate PASS

| Field | Value |
|-------|-------|
| **Trigger** | Umbrella authored without UI/UX sequential gate |
| **Impact** | Frontend lane signals unreliable |
| **Expected behavior** | Document prerequisite; block umbrella promotion until PASS |
| **Recovery** | Complete PB-draft-ui-ux gate; update test-runs/latest-gate.md |
| **Human intervention** | **Y** |