---
scenario_id: HT-01
skill_id: PB-test-generate
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Verify
  playbook_invocation:
    skill_id: PB-test-generate
    mode: new
    test_phase: generate
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: TEST-PLAN
      path: work/testing/plan/WR-FEATURE-ALPHA.md
    - type: CODE
      path: work/implement/backend/WR-FEATURE-ALPHA.md
  issue_ids:
    - ISS-BE-001
expected_outputs:
  out_01_path: work/testing/generate/WR-FEATURE-ALPHA.md
  checklist_result: pass
  exit_gate: none
  recommended_next_skill: PB-verify
  alternate_next_skill: PB-review
---

---
document_id: TEST-GEN-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
test_phase: generate
test_scope: mixed
workflow_id: WF-FEATURE
test_confidence: high
status: complete
revision: 0
created: 2026-06-18T21:00:00Z
upstream_test_plan_path: work/testing/plan/WR-FEATURE-ALPHA.md
upstream_code_paths:
  - work/implement/backend/WR-FEATURE-ALPHA.md
generated_file_count: 4
template_ref: null
---

# Test Generation Record — User profile preferences

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | TEST-GEN-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-test-generate |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | complete |
| test_phase | generate |

```yaml
plan_alignment:
  test_plan_document_id: TEST-PLAN-WR-FEATURE-ALPHA
  test_plan_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  test_plan_path: work/testing/plan/WR-FEATURE-ALPHA.md
code_gap: none
```

---

## 1. Overview

### 1.1 Purpose

Generate executable test files for ISS-BE-001 backend preferences API per TEST-PLAN TC-001 through TC-006 — document paths for PB-verify execution.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| Contract tests TC-001–TC-004 | Integration tests (deferred per plan) |
| Unit tests TC-005–TC-006 | Frontend UI tests |
| Fixture `tests/fixtures/users.py` | Performance benchmarks |

### 1.3 References

| Artifact | Path | Relevant TC-* |
|----------|------|---------------|
| TEST-PLAN | work/testing/plan/WR-FEATURE-ALPHA.md | TC-001–TC-006 |
| CODE | work/implement/backend/WR-FEATURE-ALPHA.md | §6 Testing Notes |
| API | work/api/WR-FEATURE-ALPHA.md | API-001, API-002 |

---

## 2. Generation Strategy

| Layer | Action | Rationale |
|-------|--------|-----------|
| unit | generated | TC-005, TC-006 per TEST-PLAN §2.1 |
| contract | generated | TC-001–TC-004 per TEST-PLAN §2.1 |
| integration | deferred | Plan §2.1 — requires TEST_DATABASE_URL |
| e2e | not applicable | UI out of scope |

---

## 3. Generated Files Catalog

| Path | file_action | Layer | TC-* refs | Notes |
|------|-------------|-------|-----------|-------|
| tests/contract/test_preferences_api.py | created | contract | TC-001, TC-002, TC-003, TC-004 | GET/PATCH preferences handlers |
| tests/unit/test_preferences_repository.py | created | unit | TC-005, TC-006 | Migration + repository read |
| tests/fixtures/users.py | created | fixture | TC-001, TC-002 | Session + preferences seed data |
| tests/conftest.py | updated | shared | TC-001–TC-006 | Added preferences session fixture |

---

## 4. Fixtures Generated

| Path | Purpose | TC-* |
|------|---------|------|
| tests/fixtures/users.py | Authenticated user + preferences row | TC-001, TC-002 |

---

## 5. Gaps / Deferred

| TC-* | Reason | Owner |
|------|--------|-------|
| TC-REG-001 | Regression smoke — existing `tests/unit/test_auth_session.py` covers | PB-verify |
| TC-REG-002 | Adjacent route — deferred integration | PB-verify |
| integration layer | TEST_DATABASE_URL not configured in fixture | PB-verify |

---

## 6. Execution Evidence

_generate_only — no tests executed during PB-test-generate. Evidence populated by PB-verify._

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| — | — | — |

---

## 7. Handoff

| Field | Value |
|-------|-------|
| recommended_next_skill | PB-verify |
| alternate_next_skill | PB-review |
| exit_gate | none |
| generated_file_count | 4 |
| tc_addressed | 6 / 6 in-scope (2 deferred to verify env) |
| notes | Generation complete — await PB-verify for execution evidence |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | WR-FEATURE-ALPHA |
| upstream | work/testing/plan/WR-FEATURE-ALPHA.md |
| downstream | PB-verify, PB-review |
| standards | STD-TEST-001, STD-TEST-002 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-06-18 | PB-test-generate | Initial test generation record |