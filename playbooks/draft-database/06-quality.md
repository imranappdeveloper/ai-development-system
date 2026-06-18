# PB-draft-database — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | ARCH link + PRD/ARCH entity mapping |
| Schema clarity | 25% | Logical model, physical tables, constraints |
| Completeness | 20% | TP-database required sections |
| Safety | 15% | No DDL/SQL, secrets, or ARCH duplication |
| Gate compliance | 15% | CL-DATABASE pass + H-PLAN pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches ARCH unless revise override | 100% |
| AC-ACC-02 | `change_type` valid enum | 100% |
| AC-ACC-03 | ARCH path in §1.3 Related Documents | 100% |
| AC-DAT-01 | §3 logical model with entities and relationships | Present |
| AC-DAT-02 | §4 physical tables with indexes and constraints | Present |
| AC-DAT-03 | §6 access patterns for hot paths | Present |
| AC-COM-01 | All TP-database required sections present | 100% |
| AC-COM-02 | `arch_alignment` block present | 100% |
| AC-MIG-01 | §5 migration when `change_type: migration` | 100% when applicable |
| AC-SEC-01 | §7 security table populated for PII fields | Per STD-SEC-001 |
| AC-SCP-01 | No executable DDL/SQL or application code | 0 blocks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PRS-01 | DB persisted before handoff | File path or `persist: pending` |

---

## CL-DATABASE Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-07) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-03 + arch_alignment.arch_path |
| 5 | AC-DAT-01 + PRD grounding or prd_gap |
| 6 | AC-COM-01 |
| 7 | AC-SCP-01 + AC-SEC-01 |
| 8 | AC-MIG-01 |
| 9 | AC-PRS-01 + WR status |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-DATABASE `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-DATABASE checks passed | 10 / 10 |
| Required ACs passed | 13 / 13 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |