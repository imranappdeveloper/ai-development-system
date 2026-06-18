# PB-draft-prd — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-prd |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | PRD already H-PLAN approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type: bugfix` | Block; recommend PB-draft-issue | N |
| EC-ENT-04 | DISC missing, no waiver | Set `discovery_gap: missing`; proceed if workflow soft-allows; flag in risks | Y |
| EC-ENT-05 | H-FRAME not recorded, DISC present | Block handoff as complete; await H-FRAME or waiver | Y |
| EC-RES-01 | DISC contradicts INT scope | Document in §10 Risks; `discovery_alignment: partial` | Y |
| EC-RES-02 | Stale DISC (`revision` < INT) | `discovery_gap: stale`; cite both versions | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT/DISC; note gap in §2 | N |
| EC-CTX-02 | CONTEXT > budget | Digest module map | N |
| EC-CTX-03 | Chat-only agent | Full PRD in output + `persist: pending` | Y |
| EC-SEC-01 | PII in stakeholder input | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-PRD fail | Recovery ≤3 → OUT-05 | Y |
| EC-SCP-01 | Code snippets in PRD | CL-PRD #7 fail; remove | N |
| EC-SCP-02 | Architecture/API detail in PRD | CL-PRD #7 fail; defer to TP-architecture | N |
| EC-HUM-01 | Vague H-PLAN revise notes | Request specificity; re-HAND | Y |

---

## P1 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-PRD-01 | Narrow enhancement scope | `prd_type: lite`; trimmed sections allowed per TP-prd | N |
| EC-PRD-02 | WF-PRD path, no DISC | `discovery_gap: waiver`; INT-only traceability | N |
| EC-REV-01 | Multiple H-PLAN revise cycles | Increment `revision`; preserve approval history | Y |
| EC-MUL-01 | Multiple initiatives in INT | Flag; recommend split or re-intake | Y |
| EC-NXT-01 | `new_project` vs feature routing | Recommend PB-bootstrap-project vs PB-draft-architecture only | N |