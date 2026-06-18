# PB-survey-codebase — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (completion blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches INT unless refresh override | 100% |
| AC-ACC-02 | `survey_type` valid enum | 100% |
| AC-SCN-01 | Scan manifest present; paths ⊆ 05-context allowlist | 100% |
| AC-SCN-02 | `files_touched` ≤ 40; T3 caps respected | 100% |
| AC-EVD-01 | Structural claims cite path + reference | ≥1 citation per major module |
| AC-COM-01 | All OUT-01 required sections present | 100% |
| AC-COM-02 | §6.2 intake alignment block present | 100% |
| AC-SEC-01 | No secrets in SURVEY | 0 leaks |
| AC-GAT-01 | No human gate block; `exit_gate: none` honored | 100% |
| AC-RTG-01 | No routing-matrix content in SURVEY | 100% |
| AC-PRD-01 | No PRD/architecture/code dumps | 0 violations |
| AC-PER-01 | SURVEY persisted before handoff | File path or `persist: pending` |

---

## CL-SURVEY Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria (INT + H-INTAKE or waiver) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-SCN-01 + AC-SCN-02 |
| 5 | AC-EVD-01 |
| 6 | AC-COM-01 |
| 7 | AC-PRD-01 + AC-SEC-01 |
| 8 | AC-COM-02 |
| 9 | AC-PER-01 + WR `survey_complete` |
| 10 | AC-GAT-01 + AC-RTG-01 |

**Handoff allowed:** CL-SURVEY `result: pass` AND all required ACs pass.