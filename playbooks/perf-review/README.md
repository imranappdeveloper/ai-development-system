# PB-perf-review

**Performance Reviewer** — Verify-phase playbook producing a **PERF-REVIEW** artifact — static performance analysis of CODE against NFRs and optional PERF-BASE baseline; **never runs load benchmarks**.

| Field | Value |
|-------|-------|
| skill_id | `PB-perf-review` |
| display_name | Performance Reviewer |
| version | `1.0.0` |
| prompt_version | `1.0.0` |
| status | `draft` |
| exit_gate | `H-VERIFY` |
| checklist | `CL-PERF-REVIEW` |
| path | `{AI_DEV_OS_HOME}/playbooks/perf-review/` |

---

## Quick Reference

```text
Invoke  → CODE + work_id + project_root + AI_DEV_OS_HOME
          PERF-BASE (soft) for baseline comparison
Require → H-IMPLEMENT approved (soft); CODE artifact present
Produce → PERF-REVIEW at work/perf-review/{work_id}.md + updated WR + handoff
Gate    → CL-PERF-REVIEW (agent) then H-VERIFY pending — human approves outcome
Stop    → await human H-VERIFY; NEVER run load tests or populate benchmark evidence
```

## Workflows

| workflow_id | Typical scope |
|-------------|---------------|
| WF-PERF | Mandatory perf review path; PERF-BASE expected (soft) |
| WF-FEATURE | NFR + hot-path review when perf-sensitive changes |
| WF-ENHANCEMENT | Regression risk on latency-sensitive endpoints |
| WF-REFACTOR | Structural change impact on throughput/memory |
| WF-BUGFIX | Perf regression fix verification (static) |

## Specification Index

| Doc | Topic |
|-----|-------|
| [01-purpose.md](./01-purpose.md) | Why this playbook exists |
| [02-responsibilities.md](./02-responsibilities.md) | P1–P10, N1–N15 |
| [03-workflow.md](./03-workflow.md) | Steps, H-VERIFY, recovery |
| [04-io-contract.md](./04-io-contract.md) | IN-*/OUT-* |
| [05-context.md](./05-context.md) | Context budget & memory |
| [06-quality.md](./06-quality.md) | ACs & CL-PERF-REVIEW map |
| [07-edge-cases.md](./07-edge-cases.md) | P0 edge cases (27 EC-*) |
| [08-limitations.md](./08-limitations.md) | Boundaries |
| [09-system-prompt.md](./09-system-prompt.md) | Deployable prompt |
| [10-review.md](./10-review.md) | Architect review (74/100) |
| [11-test-plan.md](./11-test-plan.md) | HT/ET/FT promotion gate |

## Examples & Fixtures

| Path | Purpose |
|------|---------|
| [examples/](./examples/) | Golden PERF-REVIEW + anti-patterns |
| [fixtures/](./fixtures/) | wf-perf-alpha with CODE + PERF-BASE stubs |

## Version / Promotion

| Field | Value |
|-------|-------|
| spec_version | 1.0.0 |
| prompt_version | 1.0.0 |
| promoted | pending sequential gate |
| gate evidence | `11-test-plan.md` §Promotion Gate |
| prerequisite | PB-test-plan `test-runs/latest-gate.md` VERDICT PASS |

## Routing

- Registry: `registry.yaml` (draft)
- Orchestrator SSOT: `workflows/project-orchestrator/routing-matrix.yaml` → `skills.PB-perf-review`