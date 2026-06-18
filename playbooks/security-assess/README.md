# PB-security-assess

**Security Assess** — Plan-phase playbook producing SEC-ASSESS artifacts for WF-SECURITY.

| Field | Value |
|-------|-------|
| skill_id | `PB-security-assess` |
| display_name | Security Assess |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `active` |
| exit_gate | `H-PLAN` (human) |
| checklist | `CL-SECURI` |
| path | `{AI_DEV_OS_HOME}/playbooks/security-assess/` |

---

## Quick Reference

```text
Invoke  → approved INT + work_id + project_root + AI_DEV_OS_HOME
Produce → SEC-ASSESS at work/security/{work_id}.md
Gate    → CL-SECURI (agent) then H-PLAN (human)
Stop    → await H-PLAN; recommend PB-implement (default) or PB-security-review
```

**Not** PB-security-review — assessment only (threat model, scope, remediation plan). No code fixes.

## Workflows

| workflow_id | Notes |
|-------------|-------|
| WF-SECURITY | Primary path — required before implement |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-PLAN, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget |
| [06-quality.md](./06-quality.md) | ACs & checklist map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden + anti-patterns |
| [fixtures/](./fixtures/) | wf-security-alpha project workspace |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| promoted | active |
| gate evidence | `test-runs/latest-gate.md` VERDICT PASS |
| prerequisite | PB-intake-classify `test-runs/latest-gate.md` VERDICT PASS |