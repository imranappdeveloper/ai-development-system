# PB-discovery-research — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-discovery-research |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | DISC already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type: bugfix` | Block; recommend PB-draft-issue | N |
| EC-RES-01 | Insufficient evidence | `discovery_confidence: low`; list blockers in open questions | Y |
| EC-RES-02 | Research contradicts INT | `alignment: requires_re_intake`; recommend PB-intake-classify | Y |
| EC-RES-03 | Partial_mismatch | Document in §6.2; human decides at H-FRAME | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT only; note gap in DISC | N |
| EC-CTX-02 | CONTEXT > budget | Digest module map | N |
| EC-CTX-03 | Chat-only agent | Full DISC in output + `persist: pending` | Y |
| EC-SEC-01 | PII in stakeholder input | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-DISCOVERY fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-SCP-01 | PRD drafted in DISC | CL-DISCOVERY #7 fail; remove | N |
| EC-SCP-02 | Agent assigns new work_type | CL-DISCOVERY #8 fail | N |
| EC-MUL-01 | Multiple initiatives in INT | Flag; recommend split or re-intake | Y |