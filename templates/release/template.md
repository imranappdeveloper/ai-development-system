---
template_id: TP-release
version: 1.0.0
status: active
document_type: release
sdlc_workflows: [WF-RELEASE]
gates: [H-FRAME, H-PLAN, H-VERIFY, H-SHIP, H-OPERATE]
---

# Release — {{version}}

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | {{document_id}} |
| work_id | {{work_id}} |
| project | {{project_name}} |
| author | {{author}} |
| created | {{date}} |
| last_updated | {{date}} |
| status | draft \| in_review \| approved \| released |
| version | {{semver}} |
| release_type | major \| minor \| patch \| hotfix |

---

## 1. Release Summary

[TODO: What this release delivers — one paragraph.]

---

## 2. Release Scope

### 2.1 Included Work

| work_id | Type | Summary | PR / link |
|---------|------|---------|-----------|
| | feature \| bugfix \| security \| perf \| docs | | |

### 2.2 Excluded / Deferred

| Item | Reason |
|------|--------|
| | |

### 2.3 Freeze

| Field | Value |
|-------|-------|
| freeze_start | {{date}} |
| freeze_end | {{date}} |
| exceptions | |

---

## 3. Versioning

| Field | Value |
|-------|-------|
| previous_version | |
| new_version | {{semver}} |
| bump_rationale | |

---

## 4. Changelog

### 4.1 Added

- [TODO: ]

### 4.2 Changed

- [TODO: ]

### 4.3 Fixed

- [TODO: ]

### 4.4 Security

- [TODO: ]

### 4.5 Deprecated

- [TODO: ]

### 4.6 Removed

- [TODO: ]

---

## 5. Breaking Changes & Migration

| Change | Impact | Migration steps | Doc link |
|--------|--------|-----------------|----------|
| | | | |

---

## 6. Dependencies

| Dependency | Version | Notes |
|------------|---------|-------|
| | | |

---

## 7. Deployment

### 7.1 Target Environments

| Environment | Date / window | Owner | Status |
|-------------|---------------|-------|--------|
| staging | | | |
| production | | | |

### 7.2 Deployment Steps

| Step | Action | Owner | Verified |
|------|--------|-------|----------|
| | | | yes \| no |

### 7.3 Rollback Plan

| Trigger | Action | Owner | Last tested |
|---------|--------|-------|-------------|
| | | | |

---

## 8. Verification

### 8.1 Pre-Release Checks

| Check | Result | Evidence | Standard ref |
|-------|--------|----------|--------------|
| CI green | pass \| fail | | STD-CI-001 |
| regression tests | pass \| fail | | STD-TEST-002 |
| security scan | pass \| fail \| n/a | | STD-SEC-001 |
| prod readiness | pass \| fail | | STD-PROD-001 |

### 8.2 Smoke Tests (post-deploy)

| Test | Environment | Result | Timestamp |
|------|-------------|--------|-----------|
| | | pass \| fail | |

---

## 9. Communication

| Audience | Channel | Owner | Status |
|----------|---------|-------|--------|
| internal | | | |
| users | | | |

---

## 10. Risks

| Risk | Mitigation | Owner |
|------|------------|-------|
| | | |

---

## 11. Open Items

| Item | Severity | Owner | Blocks release |
|------|----------|-------|----------------|
| | blocker \| should-fix \| defer | | yes \| no |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-SHIP |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

### Post-Release (H-OPERATE)

| Field | Value |
|-------|-------|
| gate_id | H-OPERATE |
| smoke_verified | yes \| no |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| workflow | WF-RELEASE |
| included_work | |
| standards | STD-CI-001, STD-CI-002, STD-PROD-001, STD-DOC-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |