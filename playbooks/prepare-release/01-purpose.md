# PB-prepare-release — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| name | Release Manager |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Produce a durable **REL** artifact at `work/release/{work_id}.md` from **CODE**, **TEST-RPT**, and upstream work — document version, scope, changelog, deployment plan, and verification evidence — then stop without deploying or approving H-SHIP.

---

## What Problem Does It Solve?

After implementation and verification, teams need a traceable release record before production ship. Without a dedicated release manager playbook:

| Failure | Cost |
|---------|------|
| Release notes only in chat | No audit trail; H-SHIP false confidence |
| Agent runs deploy commands | Unauthorized production changes |
| Changelog not tied to CODE | Scope drift; wrong version shipped |
| TEST-RPT evidence ignored | Ship without regression proof |
| Agent self-approves H-SHIP | Gate bypass; operate phase undefined |

**This playbook solves the structured release preparation problem.** It reads CODE and TEST-RPT (soft), synthesizes REL per `templates/release/template.md`, and hands off to human at **H-SHIP**.

It does **not** execute deployments, apply infra, run smoke tests in production, approve H-SHIP, or close H-OPERATE.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Workflow phase is **Ship** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| CODE artifact linked in WR | Yes |
| TEST-RPT linked (soft) | Yes (soft — waived for `WF-RELEASE` per `gates.yaml`) |
| H-VERIFY approved when full verify chain ran (soft) | Yes (soft — waived for `WF-RELEASE`) |
| Human or orchestrator requests release record before ship | Yes |

**Typical triggers:** WF-FEATURE after verify chain complete; WF-RELEASE intake for version-only ship; hotfix path with single CODE lane.

**Quality chain position:** **Last skill** in the quality chain — after **PB-test-plan** → **PB-test-generate** → **PB-review** → **PB-security-review** → **PB-perf-review** → **PB-draft-doc-update** → **PB-verify** (TEST-RPT). Optional verify sub-artifacts may be absent when waived; document gaps in REL §1 and §11.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Need test execution or TEST-RPT | PB-verify |
| Need code review only | PB-review |
| Need security code review | PB-security-review |
| Need performance review | PB-perf-review |
| Need to change implementation | PB-implement-* |
| Need post-release operate triage | PB-maintenance-triage (after H-SHIP) |
| Intake-only release request without CODE | PB-intake-classify → scope implement first |

---

## Single Responsibility

> **Prepare release record from verified work — document REL — stop without deploy.**

Sub-steps (persist, CL-RELEASE, handoff) are mandatory parts of release preparation, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-implement-* | CODE artifacts with §4 Files Changed |
| PB-verify | TEST-RPT execution evidence |
| PB-review | REVIEW findings (soft upstream) |
| PB-security-review | SEC-REVIEW (soft upstream) |
| PB-perf-review | PERF-REVIEW (soft upstream) |
| PB-draft-doc-update | DOC-PLAN doc deltas (soft upstream) |
| PB-prepare-release | REL artifact, changelog, deployment plan (document only) |
| Human at H-SHIP | Authoritative approve / revise / reject ship |
| Human at H-OPERATE | Post-release smoke and operate closure |

Release-prep-only mode: agent produces REL and awaits human ship decision — **never** triggers CI/CD or production commands.