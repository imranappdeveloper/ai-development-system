# PB-onboard-project — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | ONBOARD already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` ≠ `existing_project` | Block; recommend PB-discovery-research or re-intake | N |
| EC-ENT-04 | CONTEXT.md missing | Block; list prerequisite; no ONBOARD handoff as complete | Y |
| EC-ENT-05 | Prerequisite intake gate not PASS | Block invoke per sequential promotion | N |
| EC-RES-01 | CONTEXT severely stale | `context_drift: major`; list proposed updates in §3 | Y |
| EC-RES-02 | Onboard contradicts INT | `alignment: requires_re_intake`; recommend PB-intake-classify | Y |
| EC-RES-03 | Partial_mismatch | Document in §6.2; human decides at H-FRAME | Y |
| EC-CTX-01 | CONTEXT.md empty shell | `onboarding_confidence: low`; blockers in open questions | Y |
| EC-CTX-02 | CONTEXT > budget | Digest with section refs; retain `context_md_path` | N |
| EC-CTX-03 | Chat-only agent | Full ONBOARD in output + `persist: pending` | Y |
| EC-SEC-01 | PII in CONTEXT or repo | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-ONBOAR fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-SCP-01 | Agent writes CONTEXT.md | CL-ONBOAR #7 fail; proposals only | N |
| EC-SCP-02 | Agent assigns new work_type | CL-ONBOAR #8 fail | N |
| EC-MUL-01 | Multiple repos in INT | Flag; recommend split or re-intake | Y |