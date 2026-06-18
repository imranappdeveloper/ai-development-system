---
document_id: ARCH-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
architecture_type: delta
workflow_id: WF-FEATURE
architecture_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T14:00:00Z
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
template_id: TP-architecture
---

# Architecture — User profile page

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | ARCH-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-draft-architecture |
| created | 2026-06-18 |
| status | pending_review |
| architecture_type | delta |

---

## 1. Overview

### 1.1 Purpose

Define structural approach for user profile page (email + notification preferences) on existing OAuth-authenticated application.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| Profile read/update API boundary | Push notification delivery infrastructure |
| Profile UI module in web app | Admin user management |
| Preference persistence model | OAuth provider changes |

### 1.3 Related Documents

| Document | Path | Relationship |
|----------|------|--------------|
| PRD | work/prd/WR-FEATURE-ALPHA.md | informs |

```yaml
prd_alignment:
  prd_document_id: PRD-WR-FEATURE-ALPHA
  prd_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  prd_path: work/prd/WR-FEATURE-ALPHA.md
```

---

## 2. Context & Constraints

### 2.1 System Context

```
[User] --> [Web App : Profile Module] --> [API : Profile Service] --> [DB : user_preferences]
                |                              |
                +-------- existing OAuth ------+--> [Auth Module]
```

Actors: authenticated end user. External: OAuth IdP (unchanged). Trust boundary at API gateway.

### 2.2 Assumptions

| Assumption | Impact if invalid |
|------------|-------------------|
| OAuth session available in web app | Profile module inaccessible without auth refactor |
| Single-region deployment | No cross-region consistency model needed |

### 2.3 Constraints

| Constraint | Source |
|------------|--------|
| GDPR email consent | PRD NFR-02 |
| Existing `auth/` module — no modification | CONTEXT.md |

### 2.4 Quality Attributes

| Attribute | Requirement | Standard ref |
|-----------|-------------|--------------|
| security | AuthZ on own profile only | STD-SEC-001 |
| performance | Profile load p95 < 300ms | STD-PERF-001 |
| maintainability | Profile isolated module | STD-ARCH-001 |

---

## 3. Architectural Approach

### 3.1 Style & Patterns

Layered extension: new Profile module in presentation layer; Profile Service in application layer. Justified per STD-ARCH-004 — minimal delta to existing monolith.

### 3.2 Layer / Module Structure

| Layer / Module | Responsibility | Dependencies (inward) |
|----------------|----------------|----------------------|
| Web : Profile UI | Render/edit preferences | API client, auth session |
| API : Profile Service | CRUD preferences | Domain models, DB adapter |
| Domain : UserPreferences | Validation rules | None |
| Infra : DB adapter | Persistence | Domain interfaces |

### 3.3 Dependency Rules

Presentation → Application → Domain → Infrastructure. Profile module must not import from unrelated feature modules.

---

## 4. Component Design

### 4.1 Components

| Component | Responsibility | Interfaces | Owner |
|-----------|----------------|------------|-------|
| ProfileModule | UI routes and forms | REST client | Frontend |
| ProfileService | Business logic | REST API | Backend |
| PreferencesRepository | Data access | SQL | Backend |

### 4.2 Container View

Extends existing web + API containers; no new deployable unit in v1.

### 4.3 Key Interactions

| From | To | Protocol | Purpose |
|------|-----|----------|---------|
| ProfileModule | ProfileService | HTTPS/REST | Read/update preferences |
| ProfileService | PreferencesRepository | Internal | Persist changes |
| ProfileModule | AuthModule | Internal session | Verify user identity |

---

## 5. Data Flow

| Flow | Trigger | Steps | Persistence |
|------|---------|-------|-------------|
| View profile | Page load | Auth check → GET preferences → render | Read user_preferences |
| Update email pref | Form submit | Validate → PATCH → confirm | Update user_preferences |

---

## 6. Cross-Cutting Concerns

| Concern | Approach | Standard ref |
|---------|----------|--------------|
| authentication | Existing OAuth session | STD-SEC-001 |
| authorization | User may only access own profile_id | STD-SEC-001 |
| logging | Structured request logs on mutations | STD-OPS-001 |
| error handling | 4xx/5xx mapped to user-safe messages | STD-OPS-002 |

---

## 7. Technology Choices

| Area | Choice | Rationale | ADR ref |
|------|--------|-----------|---------|
| API style | REST (existing convention) | Consistency with codebase | — |
| Storage | Existing RDBMS | No new datastore for v1 | — |

---

## 8. Migration & Transition

N/A — delta feature on existing schema; additive migration for `user_preferences` table.

---

## 9. Risks & Tradeoffs

| Decision / risk | Tradeoff | Alternative rejected |
|-----------------|----------|---------------------|
| Monolith extension vs microservice | Faster delivery; defers split cost | New profile microservice (overkill v1) |

---

## 10. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Push notifications in v1? | Product | open |

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
| upstream | work/prd/WR-FEATURE-ALPHA.md |
| standards | STD-ARCH-001, STD-SEC-001, STD-PERF-001 |