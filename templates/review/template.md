---
template_id: TP-review
version: 1.0.0
status: active
document_type: review
sdlc_workflows: [WF-FEATURE, WF-BUGFIX, WF-REFACTOR, WF-SECURITY, WF-PERF, WF-ENHANCEMENT, WF-DOCS]
gates: [H-VERIFY]
---

# Review — {{artifact_or_pr_title}}

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
| review_type | code \| design \| security \| doc \| release_readiness |
| review_target | {{pr_link_or_artifact_path}} |

---

## 1. Review Context

### 1.1 Summary

[TODO: What is being reviewed and against what criteria.]

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| | |

### 1.3 References

| Artifact | Path |
|----------|------|
| issue / work record | |
| feature spec | |
| test evidence | TP-testing |
| diff / PR | |

---

## 2. Reviewers

| Role | Name | Type |
|------|------|------|
| author | | human \| agent |
| reviewer | | human |
| optional | | |

---

## 3. Standards Checklist

| Standard | Applicable | Pass | Notes |
|----------|------------|------|-------|
| STD-ARCH-001 | yes \| no | pass \| fail \| n/a | |
| STD-ARCH-002 | yes \| no | pass \| fail \| n/a | |
| STD-ARCH-004 | yes \| no | pass \| fail \| n/a | |
| STD-TEST-001 | yes \| no | pass \| fail \| n/a | |
| STD-TEST-002 | yes \| no | pass \| fail \| n/a | |
| STD-SEC-001 | yes \| no | pass \| fail \| n/a | |
| STD-OPS-001 | yes \| no | pass \| fail \| n/a | |
| STD-OPS-002 | yes \| no | pass \| fail \| n/a | |
| STD-DOC-001 | yes \| no | pass \| fail \| n/a | |
| STD-REV-001 | yes \| no | pass \| fail \| n/a | |

---

## 4. Acceptance Criteria Review

| AC ID | Met | Evidence | Notes |
|-------|-----|----------|-------|
| AC- | yes \| no \| partial | | |

---

## 5. Findings

### 5.1 Blockers

| ID | Location | Finding | Required action |
|----|----------|---------|-----------------|
| B- | | | |

### 5.2 Should-Fix

| ID | Location | Finding | Suggested action |
|----|----------|---------|------------------|
| S- | | | |

### 5.3 Nits

| ID | Location | Finding |
|----|----------|---------|
| N- | | |

---

## 6. Scope & Risk Assessment

| Question | Answer |
|----------|--------|
| Diff matches issue scope? | yes \| no |
| Drive-by changes present? | yes \| no |
| Breaking changes documented? | yes \| no \| n/a |
| Rollback feasible? | yes \| no \| n/a |
| Security surface changed? | yes \| no |

---

## 7. Agent Pre-Review (optional)

| Checklist | Result | Notes |
|-----------|--------|-------|
| CL-VERIFY | pass \| fail | |
| CL-SECURITY | pass \| fail \| n/a | |

[TODO: Agent pre-review is advisory — human decision is authoritative per STD-REV-001.]

---

## 8. Resolution

| Finding ID | Resolution | Verified |
|------------|------------|----------|
| | fixed \| waived \| deferred | yes \| no |

### 8.1 Waivers

| Item | Reason | Approved by | Date |
|------|--------|-------------|------|
| | | | |

---

## 9. Outcome

| Field | Value |
|-------|-------|
| recommendation | approve \| revise \| reject |
| summary | |

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
| upstream | TP-testing, issue, PR |
| downstream | H-SHIP |
| standards | STD-REV-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |