# PB-security-assess — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| name | Security Assess |
| version | 1.0.0 |
| status | active |
| document | 01-purpose |

---

## One-Liner

Analyze an **approved INT** for security work and produce an **approved-ready assessment (SEC-ASSESS)** at `{project_root}/work/security/{work_id}.md` — threat model, scope, and remediation plan — then stop.

---

## What Problem Does It Solve?

Without structured Plan-phase security assessment before implementation:

| Failure | Cost |
|---------|------|
| Threat model lives only in chat | No SSOT for H-PLAN or downstream implement/review |
| Verify review without approved controls | PB-security-review cannot trace SA-* controls |
| Scope drift from INT | Wrong hardening shipped; audit gaps |
| Agent patches code during assess | Untested changes; scope bleed |
| Confusion with PB-security-review | Code review mistaken for Plan-phase assessment |

**This playbook solves the Plan-phase security assessment problem.** It produces one authoritative SEC-ASSESS artifact grounded in INT and CONTEXT — threat model, scope boundaries, control requirements, and prioritized remediation plan.

It does **not** classify intake, implement fixes, run vuln scanners, review implemented CODE, or approve human gates.

---

## When to Use

| Condition | Required |
|-----------|----------|
| Upstream INT approved at H-INTAKE | Yes |
| `SEC-ASSESS` not yet approved for this `work_id` | Yes |
| Workflow phase is **Plan** | Yes |
| `workflow_id: WF-SECURITY` or INT `work_type: security` | Yes |

**Typical triggers:** Orchestrator Plan-phase tick after H-INTAKE; human requests security assessment before implement.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| Implemented CODE needs security review | **PB-security-review** (Verify) |
| User wants code changes now | PB-implement-* after H-PLAN on SEC-ASSESS |
| General code quality review | PB-review |
| Automated test execution | PB-verify |
| INT not yet classified | PB-intake-classify |

---

## Single Responsibility

> **Plan-phase security assessment — persist SEC-ASSESS, update WR, and stop.**

Sub-steps (load, validate, CL check, handoff) are mandatory parts of completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-intake-classify | `work_type`, `workflow_id`, INT |
| PB-security-assess | SEC-ASSESS content per 04-io-contract |
| PB-implement-* | Code per approved controls and remediation plan |
| PB-security-review | Verify-phase SEC-REVIEW against CODE + SEC-ASSESS |
| Human at H-PLAN | Approve artifact; resolve open questions |