# PB-onboard-project — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-onboard-project |
| version | 1.0.0 |
| status | active |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches INT (`WF-PROJECT-EXISTING`) | 100% |
| AC-ACC-02 | `onboarding_type: existing_project` | 100% |
| AC-CTX-01 | CONTEXT.md path in frontmatter; §3 cites CONTEXT sections | 100% |
| AC-CTX-02 | Module map present (≥3 rows or documented exception) | 100% |
| AC-COM-01 | All OUT-01 required sections present | 100% |
| AC-COM-02 | §6.2 intake alignment block present | 100% |
| AC-SEC-01 | No secrets in ONBOARD | 0 leaks |
| AC-CON-01 | `decision: pending` at H-FRAME | 100% |
| AC-PRD-01 | ONBOARD persisted before handoff | File path or `persist: pending` |

---

## CL-ONBOAR Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-CTX-01 |
| 5 | AC-CTX-02 |
| 6 | AC-COM-01 |
| 7 | AC-SEC-01 + no forbidden writes |
| 8 | AC-COM-02 |
| 9 | AC-PRD-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-ONBOAR `result: pass` AND all required ACs pass.