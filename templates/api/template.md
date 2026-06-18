---
template_id: TP-api
version: 1.0.0
status: active
document_type: api
sdlc_workflows: [WF-FEATURE, WF-ENHANCEMENT, WF-REFACTOR, WF-SECURITY]
gates: [H-PLAN]
---

# API Specification — {{api_name}}

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
| api_version | {{version}} |
| change_type | new \| additive \| breaking |

---

## 1. Overview

### 1.1 Purpose

[TODO: What this API exposes and to whom.]

### 1.2 Base Information

| Field | Value |
|-------|-------|
| base_url | {{base_url}} |
| protocol | REST \| GraphQL \| gRPC \| other |
| spec_format | OpenAPI \| protobuf \| other |
| spec_ssot_path | {{path_to_machine_readable_spec}} |

### 1.3 Scope

| In scope | Out of scope |
|----------|--------------|
| | |

---

## 2. Authentication & Authorization

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| authentication | | STD-SEC-001 |
| authorization model | | STD-SEC-001 |
| scopes / roles | | |

---

## 3. Common Conventions

### 3.1 Request / Response Format

| Aspect | Convention |
|--------|------------|
| content type | |
| date format | |
| id format | |
| pagination | |
| sorting | |
| filtering | |

### 3.2 Error Model

| Field | Description |
|-------|-------------|
| error code | |
| message | |
| details | |
| correlation_id | STD-OPS-001 |

### 3.3 Versioning Strategy

[TODO: How API versions are managed and deprecated.]

---

## 4. Endpoints / Operations

### 4.1 Operation Catalog

| ID | Method / Op | Path / RPC | Summary | Auth required |
|----|-------------|------------|---------|---------------|
| API- | | | | yes \| no |

### 4.2 Operation Detail — {{operation_id}}

#### Summary

[TODO: ]

#### Request

| Parameter | In | Type | Required | Description |
|-----------|-----|------|----------|-------------|
| | path \| query \| body \| header | | yes \| no | |

#### Response

| Status | Body | Description |
|--------|------|-------------|
| | | |

#### Errors

| Status / code | Condition |
|---------------|-----------|
| | |

[TODO: Repeat section 4.2 per operation or reference machine-readable SSOT.]

---

## 5. Data Models

| Model | Field | Type | Required | Description |
|-------|-------|------|----------|-------------|
| {{model}} | | | yes \| no | |

---

## 6. Events / Webhooks (if applicable)

| Event | Payload | Delivery | Retry |
|-------|---------|----------|-------|
| | | | |

---

## 7. Rate Limits & Quotas

| Limit | Value | Scope |
|-------|-------|-------|
| | | |

---

## 8. Breaking Changes & Migration

| Change | Affected clients | Migration path | Sunset date |
|--------|------------------|----------------|-------------|
| | | | |

---

## 9. Security Considerations

| Threat | Mitigation | Standard ref |
|--------|------------|--------------|
| injection | | STD-SEC-001 |
| excessive data exposure | | STD-SEC-001 |
| rate abuse | | STD-SEC-001 |

---

## 10. Testing Notes

[TODO: Contract testing approach — link TP-testing.]

| Test type | Scope |
|-----------|-------|
| contract | |
| integration | |

---

## 11. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| | | | open |

---

## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-PLAN |
| decision | pending \| approve \| revise \| reject |
| approver | |
| date | |
| notes | |

---

## References

| Type | ID / Path |
|------|-----------|
| work_record | {{work_id}} |
| upstream | TP-architecture, TP-prd, TP-database |
| downstream | TP-feature, TP-testing |
| standards | STD-ARCH-005, STD-SEC-001, STD-DOC-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | {{date}} | {{author}} | Initial draft |