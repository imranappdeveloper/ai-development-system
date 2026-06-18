---
scenario_id: HT-01
skill_id: PB-draft-database
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Plan
  playbook_invocation:
    skill_id: PB-draft-database
    mode: new
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: ARCH
      path: work/architecture/WR-FEATURE-ALPHA.md
    - type: PRD
      path: work/prd/WR-FEATURE-ALPHA.md
expected_outputs:
  out_01_path: work/database/WR-FEATURE-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-draft-api
---

---
document_id: DB-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
change_type: new_schema
workflow_id: WF-FEATURE
database_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T15:00:00Z
upstream_arch_path: work/architecture/WR-FEATURE-ALPHA.md
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
template_id: TP-database
---

# Database Design — User profile preferences

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | DB-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-draft-database |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | pending_review |
| change_type | new_schema |

---

## 1. Overview

### 1.1 Purpose

Define persistent storage for user email notification preferences supporting the profile page feature.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| `user_preferences` table (additive) | Push notification delivery tables |
| Read/write access patterns for profile API | OAuth credential storage |
| GDPR consent timestamp column | Admin audit log schema |

### 1.3 Related Documents

| Document | Path |
|----------|------|
| architecture | work/architecture/WR-FEATURE-ALPHA.md |
| PRD | work/prd/WR-FEATURE-ALPHA.md |
| API | (downstream — PB-draft-api) |

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
```

---

## 2. Data Requirements

### 2.1 Domain Entities

| Entity | Description | Source (PRD / domain) |
|--------|-------------|----------------------|
| UserPreference | Per-user email notification opt-in state | PRD FR-01, FR-02; ARCH PreferencesRepository |
| ConsentRecord | GDPR consent capture timestamp | PRD FR-03, NFR-02 |

### 2.2 Data Volume & Growth

| Metric | Current | Projected | Notes |
|--------|---------|-----------|-------|
| rows | ~50k users | +10% YoY | Single-region monolith |
| storage | < 10 MB | < 50 MB / 3yr | One row per user |

### 2.3 Retention & Lifecycle

| Data type | Retention | Archival / deletion |
|-----------|-----------|---------------------|
| UserPreference | Account lifetime | Cascade on user delete |
| ConsentRecord | 7 years | Anonymize on account delete per legal |

---

## 3. Logical Model

### 3.1 Entity Relationship Overview

```
[users] 1 ---- 1 [user_preferences]
```

Existing `users` table (PK `user_id`) gains optional 1:1 extension via `user_preferences`.

### 3.2 Entities & Attributes

| Entity | Attribute | Type | Nullable | Notes |
|--------|-----------|------|----------|-------|
| UserPreference | user_id | UUID | no | FK → users.user_id |
| UserPreference | email_notifications_enabled | boolean | no | default true |
| UserPreference | consent_acknowledged_at | timestamptz | yes | set on preference change |
| UserPreference | updated_at | timestamptz | no | audit |

### 3.3 Relationships

| From | To | Cardinality | FK | Notes |
|------|-----|-------------|-----|-------|
| users | user_preferences | 1:1 | user_id | ON DELETE CASCADE |

---

## 4. Physical Model

### 4.1 Tables / Collections

| Name | Purpose | Partitioning / sharding |
|------|---------|------------------------|
| user_preferences | Store notification opt-in per user | None — single-region |

### 4.2 Indexes

| Table | Index | Columns | Purpose |
|-------|-------|---------|---------|
| user_preferences | PK | user_id | Primary lookup by authenticated user |
| user_preferences | idx_updated_at | updated_at | Operational monitoring |

### 4.3 Constraints

| Table | Constraint | Rule |
|-------|------------|------|
| user_preferences | PK | user_id |
| user_preferences | FK | user_id → users.user_id ON DELETE CASCADE |
| user_preferences | CK | email_notifications_enabled IN (true, false) |

---

## 5. Migration Plan

### 5.1 Current Schema State

Baseline: `users` table exists; no `user_preferences` table (per CONTEXT.md PostgreSQL monolith).

### 5.2 Target Schema State

Additive `user_preferences` table with FK to `users`.

### 5.3 Migration Steps

| Step | Action | Reversible | Downtime |
|------|--------|------------|----------|
| 1 | CREATE TABLE user_preferences | yes (DROP) | no |
| 2 | ADD FK to users | yes | no |
| 3 | Backfill default rows for existing users (batch) | partial | no |

### 5.4 Rollback Plan

Drop `user_preferences` table if feature rolled back before data dependency from other modules.

---

## 6. Access Patterns

| Operation | Frequency | Latency target | Query / access path |
|-----------|-----------|----------------|---------------------|
| read | High — every profile page load | p95 < 50ms | PK lookup on user_id |
| write | Low — preference change | p95 < 100ms | UPDATE by user_id |

---

## 7. Security & Compliance

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| encryption at rest | PostgreSQL volume encryption (existing) | STD-SEC-001 |
| encryption in transit | TLS to database (existing) | STD-SEC-001 |
| PII fields | user_id links to PII in users; consent timestamp | STD-SEC-001 |
| access control | Application-layer AuthZ — user owns row only | STD-SEC-001 |
| audit logging | Log preference mutations via API layer | STD-OPS-001 |

---

## 8. Performance Considerations

| Hot path | Risk | Mitigation |
|----------|------|------------|
| Profile page read | Extra JOIN if not careful | PK-only lookup; no JOIN required when fetching by user_id |
| Backfill migration | Lock contention | Batch inserts off-peak |

---

## 9. SSOT & Consistency

| Definition | SSOT location | Consumers |
|------------|---------------|-----------|
| schema | This document + migration in Implement | PB-draft-api, PB-implement |

---

## 10. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Default opt-in for existing users — true or false? | Product | open |

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
| upstream | work/architecture/WR-FEATURE-ALPHA.md, work/prd/WR-FEATURE-ALPHA.md |
| downstream | TP-api, TP-feature, TP-testing |
| standards | STD-ARCH-005, STD-SEC-001, STD-PERF-001 |

---

## Revision History

| Version | Date | Author | Summary |
|---------|------|--------|---------|
| 1.0.0 | 2026-06-18 | PB-draft-database | Initial draft |