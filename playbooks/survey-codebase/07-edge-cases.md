# PB-survey-codebase — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | Prerequisite intake/onboard gate not PASS | Block invoke per sequential promotion | N |
| EC-ENT-03 | `project_root` unreadable | Block; OUT-05 with path error | Y |
| EC-ENT-04 | Duplicate SURVEY same revision | Block unless `mode: refresh` | N |
| EC-ENT-05 | Auto-invoked without explicit request | Block; survey is optional only | N |
| EC-RES-01 | Scan exceeds T3 file cap | Stop at cap; document in §9; `survey_confidence: medium` | N |
| EC-RES-02 | Survey contradicts INT | `alignment: requires_re_intake`; recommend PB-intake-classify | Y |
| EC-RES-03 | Partial_mismatch | Document in §6.2; human may re-intake | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from repo scan; note gap in SURVEY §9 | N |
| EC-CTX-02 | CONTEXT > budget | Digest sections; cite `context_md_path` if partial read | N |
| EC-CTX-03 | Chat-only agent | Full SURVEY in output + `persist: pending` | Y |
| EC-SCN-01 | Monorepo >40 packages | Sample representative packages; list remainder in §9 | N |
| EC-SCN-02 | Generated code dominates tree | Exclude `dist/` per forbidden; note in §8 | N |
| EC-SCN-03 | `scan_focus` path outside allowlist | Reject focus; use nearest allowlist prefix | N |
| EC-SEC-01 | Secrets in repo files | Redact `[REDACTED]`; do not copy to SURVEY | N |
| EC-VAL-01 | CL-SURVEY fail | Recovery ≤3 → OUT-05 | Y |
| EC-SCP-01 | PRD content in SURVEY | CL-SURVEY #7 fail; remove | N |
| EC-SCP-02 | Agent assigns new work_type | CL-SURVEY #8 fail | N |
| EC-SCP-03 | Routing matrix pasted in SURVEY | CL-SURVEY #10 fail; remove | N |
| EC-GAT-01 | Agent adds H-FRAME block | CL-SURVEY #10 fail; advisory handoff only | N |
| EC-MUL-01 | Multiple repos in INT | Flag; recommend split or re-intake | Y |