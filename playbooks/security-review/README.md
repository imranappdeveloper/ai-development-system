# PB-security-review

**Security Reviewer** — Verify-phase playbook producing security-focused **code review** of implemented CODE (not Plan-phase assessment).

| Field | Value |
|-------|-------|
| skill_id | `PB-security-review` |
| display_name | Security Reviewer |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-VERIFY` (human, **soft optional**) |
| checklist | `CL-SECURITY-REVIEW` |
| review_type | `security_code` |
| path | `{AI_DEV_OS_HOME}/playbooks/security-review/` |

---

## Quick Reference

```text
Invoke  → CODE + work_id + project_root + AI_DEV_OS_HOME
          SEC-ASSESS linked or assess_gap waiver (soft)
Require → CODE artifact; H-IMPLEMENT approved
Produce → SEC-REVIEW at work/security-review/{work_id}.md + updated WR + handoff
Gate    → CL-SECURITY-REVIEW (agent) then H-VERIFY (human, optional)
Stop    → await H-VERIFY; recommend PB-prepare-release — NEVER mutate code or deploy
```

## Distinction from PB-security-assess

| Field | PB-security-assess | PB-security-review |
|-------|-------------------|-------------------|
| Phase | **Plan** | **Verify** |
| Output | SEC-ASSESS at `work/security/{work_id}.md` | SEC-REVIEW at `work/security-review/{work_id}.md` |
| Input focus | INT, threat context | **CODE** implementation record |
| Exit gate | H-PLAN | H-VERIFY (soft optional) |
| Checklist | CL-SECURI | CL-SECURITY-REVIEW |

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-FEATURE | Security review of feature CODE before ship |
| WF-ENHANCEMENT | Review additive auth/data changes |
| WF-REFACTOR | Review breaking security refactors |
| WF-SECURITY | Post-implement verification of hardening |
| WF-BUGFIX | Review security bugfix CODE |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-VERIFY, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-SECURITY-REVIEW map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden SEC-REVIEW + anti-patterns |
| [fixtures/](./fixtures/) | wf-security-alpha with CODE + SEC-ASSESS stub |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-implement lane CODE + optional PB-verify TEST-RPT |