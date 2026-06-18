---
scenario_id: HT-05
skill_id: PB-decompose-issues
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Decompose
  playbook_invocation:
    skill_id: PB-decompose-issues
    mode: new
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: PRD
      path: work/prd/WR-FEATURE-ALPHA.md
    - type: ARCH
      path: work/architecture/WR-FEATURE-ALPHA.md
expected_outputs:
  manifest_path: work/issues/_manifest-WR-FEATURE-ALPHA.md
  issue_paths:
    - work/issues/ISS-BE-001.md
    - work/issues/ISS-FE-001.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement-backend
---

---
document_id: MANIFEST-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
decompose_scope: multi_lane
decompose_confidence: high
status: pending_review
created: 2026-06-18T18:00:00Z
issue_ids:
  - ISS-BE-001
  - ISS-FE-001
---

# Decomposition Manifest — User profile preferences

## PRD Alignment

```yaml
prd_alignment:
  prd_document_id: PRD-WR-FEATURE-ALPHA
  prd_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  prd_path: work/prd/WR-FEATURE-ALPHA.md
prd_gap: none
```

## Coverage Map

| PRD ref | ISS-* AC ids | Notes |
|---------|--------------|-------|
| FR-01 | ISS-BE-001 AC-1, ISS-FE-001 AC-1 | View preference — API + UI |
| FR-02 | ISS-BE-001 AC-2, ISS-FE-001 AC-2 | Update preference |
| FR-03 | ISS-BE-001 AC-3, ISS-FE-001 AC-2 | GDPR consent gate |
| NFR-01 | ISS-FE-001 AC-3 | Performance UX skeleton |
| NFR-02 | ISS-FE-001 AC-2 | Consent modal |

## Issue Summary

| issue_id | lane | priority | summary |
|----------|------|----------|---------|
| ISS-BE-001 | backend | P1 | Preferences API + migration |
| ISS-FE-001 | frontend | P1 | Profile page UI (SCR-001–SCR-003) |

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-DECOMPOSE |
| decision | pending |
| approver | |
| date | |

---

## ISS-BE-001 (excerpt)

Path: `work/issues/ISS-BE-001.md`

| AC id | criterion | verify |
|-------|-----------|--------|
| AC-1 | GET `/users/me/preferences` returns preference for session | contract test |
| AC-2 | PATCH rejects when `consent_acknowledged` false | contract test 400 |
| AC-3 | `user_preferences` table + indexes exist | migration test |

## ISS-FE-001 (excerpt)

Path: `work/issues/ISS-FE-001.md`

| AC id | criterion | verify |
|-------|-----------|--------|
| AC-1 | Profile page loads preference with skeleton (SCR-001) | component test |
| AC-2 | GDPR consent modal blocks save until confirmed (SCR-002) | component test |
| AC-3 | Save feedback banner on success/error (SCR-003) | e2e test |

---

## Work Record Update (OUT-02 excerpt)

```yaml
status: decompose_pending_review
artifacts:
  - type: ISS-BE
    path: work/issues/ISS-BE-001.md
  - type: ISS-FE
    path: work/issues/ISS-FE-001.md
os_refs:
  skill: PB-decompose-issues
  workflow_phase: Decompose
approvals:
  - gate_id: H-DECOMPOSE
    decision: pending
```

## Handoff (OUT-04 excerpt)

```yaml
recommended_next_skill: PB-implement-backend
rationale: Backend API is critical path for frontend integration
gate_id: H-DECOMPOSE
decision: pending
checklist_id: CL-DECOMP
result: pass
```