---
scenario_id: HT-01
skill_id: PB-draft-api
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Plan
  playbook_invocation:
    skill_id: PB-draft-api
    mode: new
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: ARCH
      path: work/architecture/WR-FEATURE-ALPHA.md
    - type: PRD
      path: work/prd/WR-FEATURE-ALPHA.md
    - type: DB
      path: work/database/WR-FEATURE-ALPHA.md
expected_outputs:
  out_01_path: work/api/WR-FEATURE-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement-backend
---

---
document_id: API-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
change_type: new
workflow_id: WF-FEATURE
api_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T16:00:00Z
upstream_arch_path: work/architecture/WR-FEATURE-ALPHA.md
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
upstream_db_path: work/database/WR-FEATURE-ALPHA.md
template_id: TP-api
---

# API Specification — User profile preferences

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | API-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-draft-api |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | pending_review |
| api_version | v1 |
| change_type | new |

---

## 1. Overview

### 1.1 Purpose

Expose authenticated REST endpoints for users to view and update email notification preferences on the profile page (PRD FR-01–FR-03).

### 1.2 Base Information

| Field | Value |
|-------|-------|
| base_url | `/api/v1` |
| protocol | REST |
| spec_format | OpenAPI |
| spec_ssot_path | `openapi/profile-preferences.yaml` (generated in Implement) |

### 1.3 Scope

| In scope | Out of scope |
|----------|--------------|
| GET/PATCH current-user preferences | Push notification APIs |
| GDPR consent acknowledgment on update | Admin user management |
| Error model for profile module | OAuth provider changes |

### 1.4 Related Documents

| Document | Path |
|----------|------|
| architecture | work/architecture/WR-FEATURE-ALPHA.md |
| PRD | work/prd/WR-FEATURE-ALPHA.md |
| database | work/database/WR-FEATURE-ALPHA.md |

```yaml
arch_alignment:
  arch_document_id: ARCH-WR-FEATURE-ALPHA
  arch_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  arch_path: work/architecture/WR-FEATURE-ALPHA.md
prd_alignment:
  prd_document_id: PRD-WR-FEATURE-ALPHA
  prd_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  prd_path: work/prd/WR-FEATURE-ALPHA.md
prd_gap: none
db_alignment:
  db_document_id: DB-WR-FEATURE-ALPHA
  db_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  db_path: work/database/WR-FEATURE-ALPHA.md
db_gap: none
```

---

## 2. Authentication & Authorization

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| authentication | Existing OAuth session cookie (`auth/` module) | STD-SEC-001 |
| authorization model | Authenticated user may access own preferences only | STD-SEC-001 |
| scopes / roles | `user:preferences:read`, `user:preferences:write` (session-bound) | |

---

## 3. Common Conventions

### 3.1 Request / Response Format

| Aspect | Convention |
|--------|------------|
| content type | `application/json` |
| date format | ISO-8601 UTC (`timestamptz`) |
| id format | UUID v4 for `user_id` |
| pagination | N/A — single-resource endpoints |
| sorting | N/A |
| filtering | N/A |

### 3.2 Error Model

| Field | Description |
|-------|-------------|
| error code | Machine-readable string (e.g. `PREFERENCE_VALIDATION_FAILED`) |
| message | Human-readable summary |
| details | Optional field-level validation array |
| correlation_id | Request trace ID per STD-OPS-001 |

### 3.3 Versioning Strategy

URL path versioning (`/api/v1`). Additive fields allowed in v1 without version bump. Breaking changes require v2 and §8 migration.

---

## 4. Endpoints / Operations

### 4.1 Operation Catalog

| ID | Method / Op | Path / RPC | Summary | Auth required |
|----|-------------|------------|---------|---------------|
| API-001 | GET | `/users/me/preferences` | Get current user email notification preference | yes |
| API-002 | PATCH | `/users/me/preferences` | Update preference with GDPR consent | yes |

### 4.2 Operation Detail — API-001

#### Summary

Return the authenticated user's email notification preference (PRD FR-01).

#### Request

| Parameter | In | Type | Required | Description |
|-----------|-----|------|----------|-------------|
| — | — | — | — | No parameters; user derived from session |

#### Response

| Status | Body | Description |
|--------|------|-------------|
| 200 | `UserPreferenceResponse` | Current preference state |
| 401 | `ErrorResponse` | Unauthenticated |
| 404 | `ErrorResponse` | Preference row not yet provisioned |

#### Errors

| Status / code | Condition |
|---------------|-----------|
| 401 | Missing or invalid session |
| 404 | No `user_preferences` row for user (pre-backfill) |

### 4.3 Operation Detail — API-002

#### Summary

Update email notification opt-in; requires GDPR consent acknowledgment (PRD FR-02, FR-03).

#### Request

| Parameter | In | Type | Required | Description |
|-----------|-----|------|----------|-------------|
| email_notifications_enabled | body | boolean | yes | Desired opt-in state |
| consent_acknowledged | body | boolean | yes | Must be `true` to persist change |

#### Response

| Status | Body | Description |
|--------|------|-------------|
| 200 | `UserPreferenceResponse` | Updated preference |
| 400 | `ErrorResponse` | Validation failure (consent not acknowledged) |
| 401 | `ErrorResponse` | Unauthenticated |

#### Errors

| Status / code | Condition |
|---------------|-----------|
| 400 / `CONSENT_REQUIRED` | `consent_acknowledged` not true |
| 401 | Missing or invalid session |

---

## 5. Data Models

| Model | Field | Type | Required | Description |
|-------|-------|------|----------|-------------|
| UserPreferenceResponse | email_notifications_enabled | boolean | yes | Maps to DB `user_preferences.email_notifications_enabled` |
| UserPreferenceResponse | consent_acknowledged_at | string (ISO-8601) \| null | no | Maps to DB `consent_acknowledged_at` |
| UserPreferenceResponse | updated_at | string (ISO-8601) | yes | Maps to DB `updated_at` |
| UserPreferenceUpdateRequest | email_notifications_enabled | boolean | yes | Request body field |
| UserPreferenceUpdateRequest | consent_acknowledged | boolean | yes | GDPR gate — must be true |
| ErrorResponse | code | string | yes | Machine-readable error code |
| ErrorResponse | message | string | yes | Human-readable message |
| ErrorResponse | correlation_id | string | yes | STD-OPS-001 trace ID |

---

## 6. Events / Webhooks (if applicable)

| Event | Payload | Delivery | Retry |
|-------|---------|----------|-------|
| — | N/A | N/A | N/A |

Not applicable for v1 profile preferences.

---

## 7. Rate Limits & Quotas

| Limit | Value | Scope |
|-------|-------|-------|
| read | 60 req/min | per authenticated user |
| write | 10 req/min | per authenticated user |

---

## 8. Breaking Changes & Migration

| Change | Affected clients | Migration path | Sunset date |
|--------|------------------|----------------|-------------|
| — | N/A | N/A | N/A |

`change_type: new` — no breaking changes in initial release.

---

## 9. Security Considerations

| Threat | Mitigation | Standard ref |
|--------|------------|--------------|
| injection | Parameterized repository queries; JSON schema validation | STD-SEC-001 |
| excessive data exposure | Return preference fields only; no cross-user access | STD-SEC-001 |
| rate abuse | Per-user rate limits in §7 | STD-SEC-001 |
| consent bypass | Reject PATCH when `consent_acknowledged` false | STD-SEC-001 |

---

## 10. Testing Notes

Contract tests against OpenAPI SSOT in Implement phase (TP-testing).

| Test type | Scope |
|-----------|-------|
| contract | API-001, API-002 request/response schemas |
| integration | Session auth + DB read/write via PreferencesRepository |

---

## 11. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Default response when preference row missing pre-backfill — 404 vs auto-provision? | Product | open |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | pending |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | WR-FEATURE-ALPHA |
| upstream | work/architecture/WR-FEATURE-ALPHA.md, work/prd/WR-FEATURE-ALPHA.md, work/database/WR-FEATURE-ALPHA.md |
| downstream | TP-feature, TP-testing |
| standards | STD-ARCH-005, STD-SEC-001, STD-DOC-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-06-18 | PB-draft-api | Initial draft |