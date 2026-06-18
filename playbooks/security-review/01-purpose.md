# PB-security-review — Purpose

| Field | Value |
|-------|-------|
| skill_id | PB-security-review |
| name | Security Review |
| version | 1.0.0 |
| status | draft |
| document | 01-purpose |

---

## One-Liner

Review **implemented CODE** for security defects — produce a durable **SEC-REVIEW** record at `work/security-review/{work_id}.md` — then stop.

---

## What Problem Does It Solve?

After implementation, teams need a security-focused review of code changes before ship. Without a dedicated Verify-phase security reviewer:

| Failure | Cost |
|---------|------|
| Plan-phase assess mistaken for code review | Threat model without implementation verification |
| Security findings only in chat | No audit trail; H-VERIFY lacks evidence |
| Agent patches code during review | Scope bleed; untested changes |
| P0 findings undocumented | Ship with auth bypass or data exposure |
| SEC-ASSESS ignored when present | Implementation diverges from approved controls |

**This playbook solves the Verify-phase security code review problem.** It reads CODE (and SEC-ASSESS when linked), reviews cited files for STD-SEC-001 compliance, persists SEC-REVIEW, and hands off at H-VERIFY.

It does **not** deliver Plan-phase threat assessment, implement fixes, run vuln scanners, deploy, or approve its own gate.

---

## When to Use

| Condition | Required |
|-----------|----------|
| CODE artifact linked in Work Record | Yes |
| H-IMPLEMENT approved (or advisory waive documented) | Yes |
| Workflow phase is **Verify** | Yes |
| `workflow_id` ∈ supported workflows in registry | Yes |
| Security-sensitive CODE changes (auth, data, crypto, API surface) | Yes (typical) |

**Typical triggers:** WF-FEATURE after PB-implement + H-IMPLEMENT; WF-SECURITY post-hardening implement; WF-BUGFIX for CVE fix verification.

---

## When Not to Use

| Situation | Use instead |
|-----------|-------------|
| No CODE artifact yet | PB-implement (lane child) |
| Plan-phase threat modeling needed | **PB-security-assess** (Plan) |
| General code quality review (non-security focus) | PB-review |
| User wants automated test execution | PB-verify |
| User wants production deployment | PB-prepare-release after H-VERIFY |
| INT-only security triage | PB-intake-classify → PB-security-assess |

---

## Single Responsibility

> **Review CODE for security — produce SEC-REVIEW record — stop.**

Sub-steps (persist, CL-SECURITY-REVIEW, handoff) are mandatory parts of review completion, not separate playbooks.

---

## Boundaries

| Owner | Responsibility |
|-------|----------------|
| PB-security-assess | Plan-phase SEC-ASSESS at `work/security/{work_id}.md` |
| PB-implement | CODE production at implement lane paths |
| PB-verify | Test execution, TEST-RPT |
| PB-review | General code review, REVIEW artifact |
| PB-security-review | Security code review, SEC-REVIEW artifact |
| Human at H-VERIFY | Approve verify, authorize ship |
| PB-prepare-release | Release record after H-VERIFY |

Security review may flag **requires_implement_revise** — it must not silently patch repository code.