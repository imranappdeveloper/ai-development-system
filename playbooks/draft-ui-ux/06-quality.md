# PB-draft-ui-ux — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-draft-ui-ux |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Traceability | 25% | PRD link + ARCH/DISC screen mapping |
| UX clarity | 25% | Journeys, screens, states, responsive notes |
| Completeness | 20% | TP-uiux required sections |
| Safety | 15% | No implementation code or routing SSOT embed |
| Gate compliance | 15% | CL-UIUX pass + H-PLAN pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches PRD unless revise override | 100% |
| AC-ACC-02 | `change_type` valid enum | 100% |
| AC-ACC-03 | `uiux_type` valid enum | 100% |
| AC-ACC-04 | PRD path in References / alignment block | 100% |
| AC-UIUX-01 | §2 journeys with success metrics | Present |
| AC-UIUX-02 | §4 screen inventory with priorities | Present |
| AC-UIUX-03 | §5 interaction states (loading, empty, error) | Present |
| AC-COM-01 | All TP-uiux required sections present | 100% |
| AC-COM-02 | `prd_alignment` block present | 100% |
| AC-A11Y-01 | §6 accessibility table populated | Per STD-A11Y-001 |
| AC-RES-01 | §7 responsive/platform notes when multi-surface | Per scope |
| AC-SCP-01 | No component code or application snippets | 0 blocks |
| AC-CON-01 | `decision: pending` at H-PLAN | 100% |
| AC-PRS-01 | UIUX persisted before handoff | File path or `persist: pending` |
| AC-ARCH-01 | Screens align with ARCH or `arch_gap` documented | Per soft ARCH link |
| AC-DISC-01 | Personas cite DISC or `disc_gap` documented | Per soft DISC link |

---

## CL-UIUX Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-01–EC-08) |
| 2 | AC-ACC-02 |
| 3 | AC-ACC-01 |
| 4 | AC-ACC-04 + prd_alignment.prd_path |
| 5 | AC-UIUX-02 + AC-ARCH-01 |
| 6 | AC-UIUX-01 + AC-DISC-01 |
| 7 | AC-COM-01 |
| 8 | AC-SCP-01 |
| 9 | AC-A11Y-01 |
| 10 | AC-CON-01 |

**Handoff allowed:** CL-UIUX `result: pass` AND all required ACs pass.

---

## Required Pass Scorecard

| Metric | Threshold |
|--------|-----------|
| CL-UIUX checks passed | 10 / 10 |
| Required ACs passed | 16 / 16 |
| Open questions with owner | 100% when listed |
| Production readiness (10-review) | ≥ 72 / 100 for `active` promotion |