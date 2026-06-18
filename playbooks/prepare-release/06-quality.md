# PB-prepare-release — Quality

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 06-quality |

---

## Quality Dimensions

| Dimension | Weight | Measure |
|-----------|--------|---------|
| Scope traceability | 25% | §2.1 rows match WR artifacts |
| Changelog grounding | 25% | §4 entries cite CODE §4 or ISS |
| Verification evidence | 20% | §8.1 mapped from TEST-RPT or documented waiver |
| Deployment plan quality | 15% | §7 steps with owners — plan only |
| Release-only discipline | 10% | No deploy execution |
| Gate compliance | 5% | CL-RELEASE pass + H-SHIP pending |

---

## Required Acceptance Criteria (handoff blockers)

| AC ID | Criterion | Pass |
|-------|-----------|------|
| AC-ACC-01 | `workflow_id` matches WR unless revise override | 100% |
| AC-ACC-02 | `release_type` valid enum in REL metadata | 100% |
| AC-ACC-03 | `release_confidence` valid enum | 100% |
| AC-ACC-04 | `semver` present in §3 | 100% |
| AC-SCP-01 | §2.1 Included Work has ≥1 row | 100% |
| AC-SCP-02 | §2.2 Excluded documented when scope narrowed | When applicable |
| AC-CODE-01 | CODE path in `upstream_code_paths` | 100% |
| AC-CODE-02 | `code_alignment` block when CODE present | 100% |
| AC-TEST-01 | TEST-RPT path in frontmatter when linked | 100% |
| AC-TEST-02 | TEST-RPT waiver documented for WF-RELEASE skip | When no TEST-RPT |
| AC-LOG-01 | §4 at least one changelog subsection non-empty | 100% |
| AC-LOG-02 | Security subsection populated when SEC-REVIEW linked | When applicable |
| AC-DEP-01 | §7.2 Deployment Steps table has ≥1 row | 100% |
| AC-DEP-02 | §7.3 Rollback Plan has ≥1 row | 100% |
| AC-VER-01 | §8.1 all four standard rows evaluated | 100% |
| AC-VER-02 | §8.1 Evidence cites TEST-RPT or waiver | Per row |
| AC-RISK-01 | §10 Risks table populated or explicit none | 100% |
| AC-OPEN-01 | §11 Open Items includes upstream P0 blockers | When present |
| AC-SCP-03 | Agent did not execute deploy commands | 0 runs |
| AC-CON-01 | `decision: pending` at H-SHIP | 100% |
| AC-PRS-01 | REL persisted at release path before handoff | File path or `persist: pending` |
| AC-CHAIN-01 | Quality chain position noted in §1 | 100% |

---

## CL-RELEASE Map

| Check # | AC IDs / rule |
|---------|---------------|
| 1 | EC entry criteria (EC-ENT-01–EC-ENT-08) |
| 2 | AC-TEST-01 + AC-TEST-02 |
| 3 | AC-CODE-01 + AC-CODE-02 |
| 4 | AC-PRS-01 + release path |
| 5 | AC-SCP-01 + AC-SCP-02 |
| 6 | AC-ACC-04 + AC-LOG-01 |
| 7 | AC-DEP-01 + AC-DEP-02 — plan only |
| 8 | AC-VER-01 + AC-VER-02 |
| 9 | WR status + REL artifact link |
| 10 | AC-CON-01 + AC-CHAIN-01 + PB-maintenance-triage recommendation |

**Handoff allowed:** CL-RELEASE `result: pass` AND all required ACs pass.