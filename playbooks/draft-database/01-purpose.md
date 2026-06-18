# PB-draft-database — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| name | Draft Database |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Translate an **approved ARCH** (and **PRD when available**) into an **approved-ready Database Design artifact (DB)** — then stop.

---

## What Problem Does It Solve?

After architecture approval at H-PLAN, teams still need durable data decisions: entities, relationships, physical schema, indexes, migration steps, and access patterns. Without a dedicated database step:

| Failure | Cost |
|---------|------|
| Schema invented during Implement | Rework, inconsistent migrations |
| Hidden N+1 or missing indexes | STD-PERF-001 violations in production |
| PII fields undocumented | STD-SEC-001 compliance gaps |
| Migration rollback undefined | Downtime and data-loss risk |
| Data model scattered in chat | No SSOT for Plan phase |

**This playbook solves the data-design problem.** It produces one authoritative Database document traceable to ARCH and grounded in PRD entities when present.

It does **not** classify work, write PRDs or ARCH, decompose issues, write API specs, or implement migrations.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Human-approved ARCH linked in Work Record | Yes |
| `PB-draft-architecture` completed or ARCH produced by approved path | Yes |
| Database design not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** (pre- or at H-PLAN) | Yes |
| `workflow_id` ∈ `WF-FEATURE`, `WF-REFACTOR`, `WF-SECURITY`, `WF-PERF` | Yes |
| Material schema change, migration, or optimization needed | Yes |

**Typical triggers:** WF-FEATURE after ARCH when data model is non-trivial; WF-REFACTOR schema migration; WF-SECURITY encryption or access-control columns; WF-PERF index or partitioning work.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No approved ARCH | PB-draft-architecture |
| DB already H-PLAN approved | PB-decompose-issues or PB-implement |
| Trivial CRUD with existing tables documented in ARCH | Skip DB (optional path) |
| User wants API or UI spec | PB-draft-api / PB-draft-ui-ux |
| User wants migration scripts executed | PB-implement (post H-PLAN) |

---

## Single Responsibility

> **Design data structures from ARCH — produce DB and stop.**

Sub-steps (persist, CL-DATABASE, handoff) are mandatory parts of database design completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-draft-prd | Requirements, domain entities at product level |
| PB-draft-architecture | Components, data flows, technology boundaries |
| PB-draft-database | Logical/physical schema, indexes, migration plan, access patterns |
| Human at H-PLAN | Approve DB, resolve open questions sufficient for Implement |
| PB-draft-api | HTTP contract after DB when API surface is complex |
| PB-implement | Execute migrations and repository code |

Database may flag **arch_alignment: partial_mismatch** — it must not silently override ARCH boundaries.