---
scenario_id: HT-04
skill_id: PB-security-assess
prompt_version: 1.0.0
inputs:
  work_id: WR-SECURITY-ALPHA
  project_root: fixtures/projects/wf-security-alpha
  artifact_refs:
    - type: INT
      path: work/intake/WR-SECURITY-ALPHA.md
expected_outputs:
  artifact_path: work/security/WR-SECURITY-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement
---

---
document_id: SEC-ASSESS-WR-SECURITY-ALPHA
work_id: WR-SECURITY-ALPHA
workflow_id: WF-SECURITY
assess_scope: mixed_security
threat_model_method: stride
assess_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T12:00:00Z
upstream_int_path: work/intake/WR-SECURITY-ALPHA.md
---

# Security Assessment — Auth session hardening

## Summary

Plan-phase assessment for refresh-token session hardening per INT. Primary risks: token theft via session fixation, brute-force on refresh endpoint, and missing client binding. Controls SA-001–SA-003 define implement requirements; remediation is prioritized without code in this artifact.

## Scope

| In scope | Out of scope |
|----------|--------------|
| Refresh token rotation and binding | Frontend cookie UI styling |
| Rate limiting on `/auth/refresh` | Infrastructure WAF configuration |
| Session middleware design | Verify-phase CODE review (PB-security-review) |
| Auth error logging hygiene | Live penetration testing |

## Assets & Trust Boundaries

| Asset | Boundary | Notes |
|-------|----------|-------|
| Refresh tokens | App server ↔ browser | HttpOnly cookie transport |
| Access tokens | API gateway ↔ services | Short TTL |
| Client fingerprint hash | Edge ↔ app | Derived from `X-Client-Fingerprint` |

```text
[Browser] --HTTPS--> [API] --internal--> [Session store]
```

## Threat Model

**Method:** STRIDE

| ID | Category | Threat | Likelihood | Impact |
|----|----------|--------|------------|--------|
| T-01 | Spoofing | Stolen refresh token reused from another device | Medium | High |
| T-02 | Tampering | Malformed refresh body causes verbose errors | Low | Medium |
| T-03 | Denial of Service | Refresh endpoint brute-forced | Medium | Medium |
| T-04 | Information Disclosure | Auth errors leak stack traces | Low | Medium |
| T-05 | Elevation | Long-lived refresh without rotation | Medium | High |

## Security Controls

| Control ID | Requirement | Verification hint |
|------------|-------------|-------------------|
| SA-001 | Rotate refresh token on each successful use | Unit test: old token invalid after refresh |
| SA-002 | Rate limit `/auth/refresh` (e.g. 10/min per IP) | Integration test: 429 after threshold |
| SA-003 | Bind refresh token to client fingerprint hash | Middleware rejects mismatch |

## Risk Register

| Risk ID | Description | Severity | Mitigation |
|---------|-------------|----------|------------|
| R-01 | Refresh token theft enables session hijack | high | SA-001 + SA-003 |
| R-02 | Refresh brute-force | medium | SA-002 |
| R-03 | Verbose auth errors in production | medium | Sanitize error responses (implement task) |

## Remediation Plan

| Priority | Action | Owner | Depends on |
|----------|--------|-------|------------|
| P0 | Implement SA-001 rotation in refresh handler | implement-backend | H-PLAN approve |
| P0 | Implement SA-003 fingerprint binding in session middleware | implement-backend | H-PLAN approve |
| P1 | Add SA-002 rate limit middleware on refresh route | implement-backend | SA-001 |
| P2 | Audit auth error responses for stack leakage | implement-backend | — |

**No code patches in this artifact** — implement per approved controls after H-PLAN.

## References

| artifact | path |
|----------|------|
| INT | work/intake/WR-SECURITY-ALPHA.md |

## Open Questions

| # | Question | Owner |
|---|----------|-------|
| 1 | Confirm fingerprint header contract with mobile clients | Human / product |

## Human Approval

| gate_id | H-PLAN |
| decision | pending |