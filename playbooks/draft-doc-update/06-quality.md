# PB-draft-doc-update — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id: WF-DOCS` matches INT | 100% |
| AC-ACC-02 | `doc_plan_type` valid enum | 100% |
| AC-ACC-03 | `doc_scope` valid enum | 100% |
| AC-UP-01 | `upstream_int_path` populated in frontmatter | 100% |
| AC-UP-02 | Quality-chain refs or `quality_chain_gap` documented | 100% |
| AC-INV-01 | §4 inventory ≥1 row with drift signal | 100% |
| AC-PLN-01 | §5 ≥1 DU-* row with change type and acceptance signal | 100% |
| AC-STD-01 | §6 cites STD-DOC-001 | 100% |
| AC-SEC-01 | No secrets in DOC-PLAN | 0 leaks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PLAN-01 | DOC-PLAN persisted before handoff | File path or `persist: pending` |
| AC-NO-01 | No edits outside `work/doc-plan/` and WR | 0 violations |

---

## CL-DOC-UPDATE Map

| Check # | AC IDs |
|---------|--------|
| 1 | EC entry criteria (approved INT; WF-DOCS) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-UP-01 |
| 5 | AC-INV-01 + goals grounded in INT |
| 6 | AC-PLN-01 + TP-doc-plan sections |
| 7 | AC-NO-01 (plan only — no doc body edits) |
| 8 | AC-STD-01 |
| 9 | AC-PLAN-01 + WR `plan_pending_review` |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-DOC-UPDATE `result: pass` AND all required ACs pass.