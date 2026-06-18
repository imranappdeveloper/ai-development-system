---
scenario_id: HT-01
skill_id: PB-security-review
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-SECURITY
    current_phase: Verify
  playbook_invocation:
    skill_id: PB-security-review
    mode: new
    review_type: security_code
  work_id: WR-SECURITY-ALPHA
  project_root: fixtures/projects/wf-security-alpha
  artifact_refs:
    - type: CODE
      path: work/implement/backend/WR-SECURITY-ALPHA.md
    - type: SEC-ASSESS
      path: work/security/WR-SECURITY-ALPHA.md
expected_outputs:
  out_01_path: work/security-review/WR-SECURITY-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-prepare-release
---

---
document_id: SEC-REVIEW-WR-SECURITY-ALPHA
work_id: WR-SECURITY-ALPHA
review_type: security_code
security_review_scope: mixed_security
workflow_id: WF-SECURITY
security_review_confidence: high
review_decision: changes_requested
status: pending_review
revision: 0
created: 2026-06-18T20:00:00Z
upstream_code_path: work/implement/backend/WR-SECURITY-ALPHA.md
upstream_assess_path: work/security/WR-SECURITY-ALPHA.md
---

# Security Review — Auth session hardening

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | SEC-REVIEW-WR-SECURITY-ALPHA |
| work_id | WR-SECURITY-ALPHA |
| review_type | security_code |
| author | PB-security-review |
| created | 2026-06-18 |
| status | pending_review |

---

## 1. Review Context

### 1.1 Summary

Verify-phase security code review of CODE-BE-WR-SECURITY-ALPHA against SEC-ASSESS-WR-SECURITY-ALPHA controls and STD-SEC-001.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| Session middleware, token rotation handler | Frontend cookie UI (PB-implement-frontend) |
| Rate limit on `/auth/refresh` | Infrastructure WAF rules |
| CODE §4 cited files only | Plan-phase threat model updates |

```yaml
assess_alignment:
  assess_document_id: SEC-ASSESS-WR-SECURITY-ALPHA
  assess_work_id: WR-SECURITY-ALPHA
  alignment: partial_mismatch
  mismatch_summary: Control SA-003 (refresh token binding) not fully implemented in session middleware
  assess_path: work/security/WR-SECURITY-ALPHA.md
assess_gap: none
```

---

## 2. Standards Checklist

| Standard | Applicable | Pass | Notes |
|----------|------------|------|-------|
| STD-SEC-001 | yes | fail | Refresh token not bound to client fingerprint |
| STD-LOG-001 | yes | pass | No PII in auth error logs |
| STD-REVIEW-001 | yes | pass | Findings documented with severity |

---

## 3. Review Scope

| CODE §4 path | Dimension | Reviewed |
|--------------|-----------|----------|
| `src/middleware/session.ts` | auth | yes |
| `src/routes/auth/refresh.ts` | api_surface, input_validation | yes |
| `src/lib/rate-limit.ts` | dependencies | yes |

---

## 4. Findings

| ID | Severity | File | Summary | Remediation |
|----|----------|------|---------|-------------|
| F-001 | P1 | `src/middleware/session.ts` | Refresh token accepted without device binding (SA-003) | Bind token to `X-Client-Fingerprint` hash per SEC-ASSESS §3.2 |
| F-002 | P2 | `src/routes/auth/refresh.ts` | Generic 500 on malformed body leaks stack in dev mode | Return 400 with sanitized message in all environments |

---

## 5. SEC-ASSESS Control Traceability

| Control ID | SEC-ASSESS requirement | CODE evidence | Status |
|------------|------------------------|---------------|--------|
| SA-001 | Rotate refresh on use | `refresh.ts` L42–58 | pass |
| SA-002 | Rate limit refresh endpoint | `rate-limit.ts` | pass |
| SA-003 | Bind refresh to client fingerprint | Not found in middleware | fail |

---

## 6. Remediation Recommendations

1. Implement SA-003 in `session.ts` — recommend PB-implement-backend revise.
2. Re-run PB-verify auth integration tests after fix.

---

## 7. Open Questions

| ID | Question | Owner |
|----|----------|-------|
| Q-001 | Waive SA-003 for mobile clients without fingerprint header? | security lead |

---

## 8. Human Approval

| gate_id | H-VERIFY |
|---------|----------|
| decision | pending |
| approver | (awaiting human) |
| date | — |