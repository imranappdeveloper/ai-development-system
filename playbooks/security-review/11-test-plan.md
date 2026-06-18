# PB-security-review — Test Plan

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| version | 1.0.0 |
| prompt_version | 1.0.0 |
| status | draft |
| document | 11-test-plan |

---

## Prerequisites

| ID | Requirement |
|----|-------------|
| ENV-01 | `AI_DEV_OS_HOME` readable; `INDEX.md` exists |
| ENV-02 | `checklists/security-review.md` — 10 items, `status: draft` |
| ENV-03 | Fixture `fixtures/projects/wf-security-alpha/` with CODE + SEC-ASSESS stub + WR |
| ENV-04 | System prompt 09 v1.0.0 with PROMPT START/END markers |
| ENV-05 | `registry.yaml` `status: draft`, `spec_version: 1.0.0` |
| ENV-06 | CODE fixture with H-IMPLEMENT approved in WR |
| ENV-07 | `routing-matrix.yaml` PB-security-review row present |

---

## Happy Path Tests (HT)

| ID | Input | Expected |
|----|-------|----------|
| HT-01 | CODE + SEC-ASSESS `WF-SECURITY` | SEC-REVIEW at review path; CL-SECURITY-REVIEW pass |
| HT-02 | CODE only (no SEC-ASSESS) `WF-FEATURE` | `assess_gap: missing`; review from CODE; CL pass |
| HT-03 | CODE + SEC-ASSESS aligned controls | `assess_alignment: aligned`; CL pass |
| HT-04 | CODE with auth scope | `security_review_scope: auth`; CL pass |
| HT-05 | H-VERIFY revise | `revision: 1`; notes in SEC-REVIEW |
| HT-06 | Golden fixture wf-security-alpha | Output matches SEC-REVIEW-security-001 structure |
| HT-07 | SEC-ASSESS absent with `assess_gap: waiver` | SEC-REVIEW produced; waiver documented |
| HT-08 | Clean CODE — no findings | §4 explicit "no findings"; `review_decision: pass` |

---

## Edge Tests (ET)

| ID | Input | Expected |
|----|-------|----------|
| ET-01 | No CODE linked | Block; no complete handoff |
| ET-02 | SEC-REVIEW already H-VERIFY approved | Block unless `mode: revise` |
| ET-03 | Agent patches repository code | CL-SECURITY-REVIEW #6 fail |
| ET-04 | Agent `decision: approve` | CL-SECURITY-REVIEW #10 fail |
| ET-05 | Produces SEC-ASSESS at Plan path | CL-SECURITY-REVIEW #9 fail |
| ET-06 | Chat-only mode | Full SEC-REVIEW + `persist: pending` |
| ET-07 | Finding without file ref | CL-SECURITY-REVIEW #2 fail |
| ET-08 | Known issues but empty §4 | CL-SECURITY-REVIEW #5 fail |
| ET-09 | Invoked during Plan phase | Block; redirect PB-security-assess |
| ET-10 | H-IMPLEMENT not approved | Block; await gate |

---

## Fixture Tests (FT)

| ID | Fixture | Assertion |
|----|---------|-----------|
| FT-01 | `wf-security-alpha/work/implement/backend/WR-SECURITY-ALPHA.md` | CODE stub resolvable |
| FT-02 | `wf-security-alpha/work/security/WR-SECURITY-ALPHA.md` | SEC-ASSESS stub resolvable (soft) |
| FT-03 | `wf-security-alpha/work/WR-SECURITY-ALPHA.md` | CODE artifact ref + H-IMPLEMENT approve |
| FT-04 | Anti-pattern `SEC-REVIEW-mutates-code.md` | Manual rubric flags CL #6 |
| FT-05 | Anti-pattern `SEC-REVIEW-self-approved.md` | Manual rubric flags CL #10 |
| FT-06 | Anti-pattern `SEC-REVIEW-confuses-assess.md` | Manual rubric flags CL #9 |
| FT-07 | Golden `SEC-REVIEW-security-001.md` | Required sections + assess_alignment block |

---

## Promotion Gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND CL-SECURITY-REVIEW manual rubric pass AND 10-review ≥ 72
```

| Criterion | Status (2026-06-18) |
|-----------|------------------------|
| HT suite | ⏳ not executed |
| ET(P0) suite | ⏳ not executed |
| FT suite | ⏳ not executed |
| CL manual rubric | ⏳ pending |
| 10-review ≥ 72 | ✅ 88/100 |
| routing-matrix row | ✅ present |