---
template_id: TP-testing
version: 1.0.0
status: active
document_type: testing
sdlc_workflows: [WF-FEATURE, WF-BUGFIX, WF-REFACTOR, WF-SECURITY, WF-PERF, WF-ENHANCEMENT]
gates: [H-IMPLEMENT, H-VERIFY]
---

# Test Plan — {{work_title}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | {{document_id}} |
| work_id | {{work_id}} |
| project | {{project_name}} |
| author | {{author}} |
| created | {{date}} |
| last_updated | {{date}} |
| status | draft \| in_review \| approved |
| test_phase | plan \| evidence |

---

## 1. Overview

### 1.1 Purpose

[TODO: What is being tested and why.]

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| | |

### 1.3 References

| Artifact | Path | Relevant AC |
|----------|------|-------------|
| feature spec / issue | | |
| PRD | | |
| API | | |

---

## 2. Test Strategy

### 2.1 Approach

[TODO: Overall strategy per STD-TEST-002.]

| Layer | Included | Rationale |
|-------|----------|-----------|
| unit | yes \| no | |
| integration | yes \| no | |
| contract | yes \| no | |
| e2e | yes \| no | |
| manual | yes \| no | |

### 2.2 TDD Record (if applicable)

| Step | Test | Status |
|------|------|--------|
| red | | pending \| done |
| green | | pending \| done |
| refactor | | pending \| done |

---

## 3. Test Cases

### 3.1 Acceptance Criteria Mapping

| AC ID | Test case ID | Description | Type | Priority |
|-------|--------------|-------------|------|----------|
| AC- | TC- | | | |

### 3.2 Test Case Detail — {{test_case_id}}

| Field | Value |
|-------|-------|
| title | |
| precondition | |
| steps | |
| expected result | |
| actual result | |
| status | pass \| fail \| blocked \| skipped |

[TODO: Repeat 3.2 per test case or reference test file paths.]

---

## 4. Regression Scope

| Area | Tests run | Reason |
|------|-----------|--------|
| | | |

---

## 5. Security Testing (if applicable)

| Check | Method | Result | Standard ref |
|-------|--------|--------|--------------|
| | | pass \| fail \| n/a | STD-SEC-001 |

---

## 6. Performance Testing (if applicable)

| Scenario | Baseline | Target | Result | Standard ref |
|----------|----------|--------|--------|--------------|
| | | | | STD-PERF-001 |

---

## 7. Accessibility Testing (if applicable)

| Check | Method | Result | Standard ref |
|-------|--------|--------|--------------|
| | manual \| automated | pass \| fail \| n/a | STD-A11Y-001 |

---

## 8. Test Environment

| Field | Value |
|-------|-------|
| environment | local \| ci \| staging \| prod-like |
| branch / commit | {{commit_sha}} |
| data fixtures | |
| config | |

---

## 9. Execution Evidence

### 9.1 Commands Run

| Command | Exit code | Timestamp |
|---------|-----------|-----------|
| | | |

### 9.2 Results Summary

| Metric | Value |
|--------|-------|
| total | |
| passed | |
| failed | |
| skipped | |
| coverage (informational) | |

### 9.3 Failure Log

| Test | Failure | Ticket / fix |
|------|---------|--------------|
| | | |

---

## 10. Sign-Off Criteria

| Criterion | Met | Evidence |
|-----------|-----|----------|
| all AC mapped to tests | yes \| no | |
| all required tests pass | yes \| no | |
| no open blockers | yes \| no | |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| upstream | TP-feature, issue |
| standards | STD-TEST-001, STD-TEST-002 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |