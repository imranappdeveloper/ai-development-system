# PB-draft-api — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-api |
| name | Draft API |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Translate an **approved ARCH** (and **PRD / DB when available**) into an **approved-ready API Specification artifact (API)** — then stop.

---

## What Problem Does It Solve?

After architecture approval at H-PLAN, teams still need durable HTTP contract decisions: endpoints, request/response shapes, auth scopes, error models, and versioning. Without a dedicated API step:

| Failure | Cost |
|---------|------|
| Endpoints invented during Implement | Rework, inconsistent client contracts |
| Undocumented breaking changes | Client outages and rollback incidents |
| Auth gaps on new operations | STD-SEC-001 violations |
| Data model drift from DB | Repository rework and integration bugs |
| API scattered in chat | No SSOT for Plan phase |

**This playbook solves the API-design problem.** It produces one authoritative API document traceable to ARCH and grounded in PRD requirements and DB entities when present.

It does **not** classify work, write PRDs or ARCH, design database schemas, decompose issues, or implement handlers.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved ARCH linked in Work Record | Yes |
| `PB-draft-architecture` completed or ARCH produced by approved path | Yes |
| API specification not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre- or at H-PLAN) | Yes |
| `workflow_id` ∈ `WF-FEATURE`, `WF-ENHANCEMENT`, `WF-REFACTOR`, `WF-SECURITY` | Yes |
| Material API surface change needed | Yes |

**Typical triggers:** WF-FEATURE after ARCH when REST/GraphQL surface is non-trivial; WF-ENHANCEMENT additive endpoints; WF-REFACTOR contract changes; WF-SECURITY auth or exposure hardening.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved ARCH | PB-draft-architecture |
| API already H-PLAN approved | PB-decompose-issues or PB-implement-backend |
| Trivial CRUD fully specified in ARCH | Skip API (optional path) |
| User wants database schema design | PB-draft-database |
| User wants UI spec | PB-draft-ui-ux |
| User wants handler code written | PB-implement-backend (post H-PLAN) |

---

## Single Responsibility

> **Design API contracts from ARCH — produce API and stop.**

Sub-steps (persist, CL-API, handoff) are mandatory parts of API design completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-draft-prd | Requirements, user-facing capabilities at product level |
| PB-draft-architecture | Components, data flows, technology boundaries |
| PB-draft-database | Logical/physical schema, indexes, migration plan |
| PB-draft-api | HTTP operations, models, auth, errors, versioning |
| Human at H-PLAN | Approve API, resolve open questions sufficient for Implement |
| PB-implement-backend | Handler code, OpenAPI generation, contract tests |

API may flag **arch_alignment: partial_mismatch** — it must not silently override ARCH boundaries.