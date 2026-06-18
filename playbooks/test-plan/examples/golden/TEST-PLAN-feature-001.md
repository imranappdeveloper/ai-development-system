---
scenario_id: HT-01
skill_id: PB-test-plan
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Verify
  playbook_invocation:
    skill_id: PB-test-plan
    mode: new
    test_phase: plan
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: CODE
      path: work/implement/backend/WR-FEATURE-ALPHA.md
    - type: PRD
      path: work/prd/WR-FEATURE-ALPHA.md
    - type: ISS
      path: work/issues/ISS-BE-001.md
  issue_ids:
    - ISS-BE-001
expected_outputs:
  out_01_path: work/testing/plan/WR-FEATURE-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-test-generate
---

---
document_id: TEST-PLAN-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
test_phase: plan
test_scope: mixed
workflow_id: WF-FEATURE
test_confidence: high
status: in_review
revision: 0
created: 2026-06-18T20:00:00Z
upstream_code_paths:
  - work/implement/backend/WR-FEATURE-ALPHA.md
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
upstream_issue_paths:
  - work/issues/ISS-BE-001.md
template_ref: templates/testing/template.md
---

# Test Plan — User profile preferences

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | TEST-PLAN-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-test-plan |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | in_review |
| test_phase | plan |

```yaml
code_alignment:
  code_document_id: CODE-BE-WR-FEATURE-ALPHA
  code_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  code_path: work/implement/backend/WR-FEATURE-ALPHA.md
code_gap: none
```

---

## 1. Overview

### 1.1 Purpose

Plan verification for ISS-BE-001 backend preferences API and migration — map PRD/ISS acceptance criteria to test cases before PB-test-generate and PB-verify execution.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| Preferences API contract tests (API-001, API-002) | Frontend profile UI |
| Repository unit tests | Production deployment |
| Migration verification | Push notifications |
| Regression on `auth/` session module | Performance benchmarks (deferred) |

### 1.3 References

| Artifact | Path | Relevant AC |
|----------|------|-------------|
| ISS | work/issues/ISS-BE-001.md | AC-1, AC-2, AC-3 |
| PRD | work/prd/WR-FEATURE-ALPHA.md | US-001 email preferences |
| CODE | work/implement/backend/WR-FEATURE-ALPHA.md | §4 Files Changed, §6 Testing Notes |
| API | work/api/WR-FEATURE-ALPHA.md | API-001, API-002 |

---

## 2. Test Strategy

### 2.1 Approach

Strategy per STD-TEST-002 — plan phase only; execution deferred to PB-test-generate / PB-verify.

| Layer | Included | Rationale |
|-------|----------|-----------|
| unit | yes | Repository logic per CODE §4 `preferences_repository.py` |
| integration | deferred | Requires test DB — planned for PB-verify |
| contract | yes | API-001/API-002 handlers per ISS AC-1, AC-2 |
| e2e | no | UI out of scope — PB-implement-frontend |
| manual | no | Automated contract + unit sufficient for backend slice |

### 2.2 TDD Record (if applicable)

| Step | Test | Status |
|------|------|--------|
| red | TC-001 contract GET 401 | pending |
| green | TC-002 contract GET 200 | pending |
| refactor | TC-003 repository consent gate | pending |

---

## 3. Test Cases

### 3.1 Acceptance Criteria Mapping

| AC ID | Test case ID | Description | Type | Priority |
|-------|--------------|-------------|------|----------|
| AC-1 | TC-001 | GET preferences returns 200 for authenticated session | contract | P1 |
| AC-1 | TC-002 | GET preferences returns 401 without session | contract | P1 |
| AC-2 | TC-003 | PATCH rejects when consent_acknowledged false | contract | P1 |
| AC-2 | TC-004 | PATCH succeeds when consent_acknowledged true | contract | P1 |
| AC-3 | TC-005 | Migration creates user_preferences with indexes | unit | P1 |
| AC-3 | TC-006 | Repository read returns preference row | unit | P1 |

### 3.2 Test Case Detail — TC-001

| Field | Value |
|-------|-------|
| title | GET preferences authenticated |
| precondition | Valid session cookie; user_preferences row seeded |
| steps | 1. GET `/api/v1/users/me/preferences` with session 2. Assert 200 body schema |
| expected result | 200; body matches API-001 schema |
| actual result | _planned — execution deferred_ |
| status | pending |

### 3.2 Test Case Detail — TC-003

| Field | Value |
|-------|-------|
| title | PATCH consent gate |
| precondition | Authenticated session; consent_acknowledged=false in payload |
| steps | 1. PATCH `/api/v1/users/me/preferences` 2. Assert 400 |
| expected result | 400 with consent error per API-002 |
| actual result | _planned — execution deferred_ |
| status | pending |

---

## 4. Regression Scope

| Area | Tests run | Reason |
|------|-----------|--------|
| `auth/` session module | TC-REG-001 session fixture smoke | CODE uses session auth |
| Existing user routes | TC-REG-002 GET `/users/me` unchanged | Adjacent route stability |

---

## 5. Security Testing (if applicable)

| Check | Method | Result | Standard ref |
|-------|--------|--------|--------------|
| IDOR on preferences | Planned contract TC-001/002 session binding | pending | STD-SEC-001 |
| SQL injection | Planned unit TC-005 parameterized queries | pending | STD-SEC-001 |

---

## 6. Performance Testing (if applicable)

_n/a — WF-FEATURE backend slice; perf deferred._

---

## 7. Accessibility Testing (if applicable)

_n/a — backend-only scope._

---

## 8. Test Environment

| Field | Value |
|-------|-------|
| environment | local \| ci |
| branch / commit | feature/preferences |
| data fixtures | `tests/fixtures/users.py` — to be generated by PB-test-generate |
| config | `TEST_DATABASE_URL` for integration (deferred) |

---

## 9. Execution Evidence

_plan_only — no tests executed during PB-test-plan. Evidence populated by PB-verify after PB-test-generate._

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| — | — | — |

### 9.2 Results Summary

| Metric | Value |
|--------|-------|
| total | pending |
| passed | pending |
| failed | pending |
| skipped | pending |
| coverage (informational) | pending |

---

## 10. Sign-Off Criteria

| Criterion | Met | Evidence |
|-----------|-----|----------|
| all AC mapped to tests | pending | §3.1 — 6 TC-* for 3 AC |
| all required tests pass | pending | PB-verify |
| no open blockers | pending | — |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| sub_gate | plan |
| decision | pending |
| approver | |
| date | |
| notes | Plan sub-artifact — full H-VERIFY after PB-verify evidence |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | WR-FEATURE-ALPHA |
| upstream | work/implement/backend/WR-FEATURE-ALPHA.md, work/issues/ISS-BE-001.md |
| downstream | PB-test-generate |
| standards | STD-TEST-001, STD-TEST-002 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-06-18 | PB-test-plan | Initial test plan (plan phase) |