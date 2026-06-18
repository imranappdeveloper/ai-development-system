---
scenario_id: HT-06
skill_id: PB-prepare-release
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Ship
  playbook_invocation:
    skill_id: PB-prepare-release
    mode: new
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  semver_hint: 1.2.0
  release_type_hint: minor
  artifact_refs:
    - type: CODE
      path: work/implement/backend/WR-FEATURE-ALPHA.md
    - type: TEST-RPT
      path: work/testing/WR-FEATURE-ALPHA.md
    - type: REVIEW
      path: work/review/WR-FEATURE-ALPHA.md
expected_outputs:
  out_01_path: work/release/WR-FEATURE-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-maintenance-triage
---

---
document_id: REL-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
workflow_id: WF-FEATURE
release_type: minor
semver: 1.2.0
release_confidence: high
status: in_review
revision: 0
created: 2026-06-18T22:00:00Z
upstream_code_paths:
  - work/implement/backend/WR-FEATURE-ALPHA.md
upstream_test_rpt_path: work/testing/WR-FEATURE-ALPHA.md
upstream_review_paths:
  - work/review/WR-FEATURE-ALPHA.md
template_ref: templates/release/template.md
---

# Release — 1.2.0

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | REL-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-prepare-release |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | in_review |
| version | 1.2.0 |
| release_type | minor |

```yaml
code_alignment:
  code_document_id: CODE-BE-WR-FEATURE-ALPHA
  code_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  code_path: work/implement/backend/WR-FEATURE-ALPHA.md
```

---

## 1. Release Summary

Ships user profile preferences API (GET/PATCH `/users/{id}/preferences`) with PostgreSQL persistence. Quality chain terminal artifact — upstream TEST-RPT regression pass, REVIEW approve recommendation, no P0 blockers. Deployment plan documented for staging then production; human executes deploy after H-SHIP.

---

## 2. Release Scope

### 2.1 Included Work

| work_id | Type | Summary | PR / link |
|---------|------|---------|-----------|
| WR-FEATURE-ALPHA | feature | Backend preferences API + migration | work/implement/backend/WR-FEATURE-ALPHA.md |

### 2.2 Excluded / Deferred

| Item | Reason |
|------|--------|
| Frontend preferences UI | Separate implement lane — not in this release |

### 2.3 Freeze

| Field | Value |
|-------|-------|
| freeze_start | 2026-06-18 |
| freeze_end | 2026-06-19 |
| exceptions | P0 hotfix only with H-SHIP |

---

## 3. Versioning

| Field | Value |
|-------|-------|
| previous_version | 1.1.0 |
| new_version | 1.2.0 |
| bump_rationale | New backward-compatible API surface (preferences endpoints) |

---

## 4. Changelog

### 4.1 Added

- `GET /users/{id}/preferences` — read user preferences
- `PATCH /users/{id}/preferences` — partial update
- `user_preferences` table migration

### 4.2 Changed

- None

### 4.3 Fixed

- None

### 4.4 Security

- Auth required on preferences routes per STD-SEC-001

### 4.5 Deprecated

- None

### 4.6 Removed

- None

---

## 5. Breaking Changes & Migration

| Change | Impact | Migration steps | Doc link |
|--------|--------|-----------------|----------|
| None | — | — | — |

---

## 6. Dependencies

| Dependency | Version | Notes |
|------------|---------|-------|
| PostgreSQL | 15+ | Migration `20260618_user_preferences.sql` |
| API gateway | existing | Route registration required |

---

## 7. Deployment

### 7.1 Target Environments

| Environment | Date / window | Owner | Status |
|-------------|---------------|-------|--------|
| staging | 2026-06-19 AM | platform-team | planned |
| production | 2026-06-19 PM | platform-team | planned |

### 7.2 Deployment Steps

| Step | Action | Owner | Verified |
|------|--------|-------|----------|
| 1 | Run DB migration on staging | platform-team | no |
| 2 | Deploy API service to staging | platform-team | no |
| 3 | Smoke preferences endpoints | qa-team | no |
| 4 | Repeat steps 1–3 on production | platform-team | no |

### 7.3 Rollback Plan

| Trigger | Action | Owner | Last tested |
|---------|--------|-------|-------------|
| Migration failure | Revert migration script; redeploy prior API image | platform-team | 2026-05-01 |
| 5xx on preferences routes | Roll back API deployment | platform-team | 2026-05-01 |

---

## 8. Verification

### 8.1 Pre-Release Checks

| Check | Result | Evidence | Standard ref |
|-------|--------|----------|--------------|
| CI green | pass | TEST-RPT §3.1 — all jobs pass | STD-CI-001 |
| regression tests | pass | TEST-RPT §4 — 12/12 pass | STD-TEST-002 |
| security scan | pass | TEST-RPT §5 — no P0 findings | STD-SEC-001 |
| prod readiness | pass | TEST-RPT §6 — checklist complete | STD-PROD-001 |

### 8.2 Smoke Tests (post-deploy)

| Test | Environment | Result | Timestamp |
|------|-------------|--------|-----------|
| GET preferences 200 | staging | pending | — |
| PATCH preferences 200 | staging | pending | — |

---

## 9. Communication

| Audience | Channel | Owner | Status |
|----------|---------|-------|--------|
| internal | #releases Slack | release-manager | planned |
| users | changelog page | product | planned |

---

## 10. Risks

| Risk | Mitigation | Owner |
|------|------------|-------|
| Migration lock on large table | Run during low-traffic window | platform-team |

---

## 11. Open Items

| Item | Severity | Owner | Blocks release |
|------|----------|-------|----------------|
| None | — | — | no |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-SHIP |
| decision | pending |
| approver | |
| date | |
| notes | Release record ready — human approves ship |

### Post-Release (H-OPERATE)

| Field | Value |
|-------|-------|
| gate_id | H-OPERATE |
| smoke_verified | no |
| approver | |
| date | |
| notes | Pending production smoke after deploy |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | WR-FEATURE-ALPHA |
| workflow | WF-FEATURE |
| included_work | WR-FEATURE-ALPHA |
| standards | STD-CI-001, STD-CI-002, STD-PROD-001, STD-DOC-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-06-18 | PB-prepare-release | Initial draft |