---
scenario_id: HT-04
skill_id: PB-perf-baseline
prompt_version: 1.0.0
inputs:
  work_id: WR-PERF-ALPHA
  project_root: fixtures/projects/wf-perf-alpha
  artifact_refs:
    - type: INT
      path: work/intake/WR-PERF-ALPHA.md
expected_outputs:
  artifact_path: work/performance/WR-PERF-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement
---

---
document_id: PERF-BASE-WR-PERF-ALPHA
work_id: WR-PERF-ALPHA
workflow_id: WF-PERF
perf_scope: api_latency
baseline_confidence: high
measurement_readiness: ready
status: pending_review
revision: 0
created: 2026-06-18T16:00:00Z
upstream_int_path: work/intake/WR-PERF-ALPHA.md
upstream_prd_path: null
---

# PERF-BASE — List endpoint latency (WF-PERF)

## Summary

Establish measurable latency and query-efficiency targets for the list API before implement. Measurement will occur in staging post-implement — not during this Plan artifact.

## Scope

### In scope

| Area | Detail |
|------|--------|
| GET /items | p95 latency under sustained read load |
| List query | Index usage for `created_at` ordering |
| Pagination | Page size guards |

### Out of scope

| Area | Detail |
|------|--------|
| Write path | POST/PUT performance |
| Load test execution | Deferred to human/PB-verify |
| Mobile client render | Separate work_id if needed |

## Targets & SLOs

| target_id | metric | threshold | slo_tier | notes |
|-----------|--------|-----------|----------|-------|
| NFR-PERF-001 | GET /items p95 latency | < 200ms @ 100 RPS | critical | Staging, warm cache |
| NFR-PERF-002 | DB list query plan | Uses `idx_items_created_at` | standard | EXPLAIN in staging |
| NFR-PERF-003 | Max page size | ≤ 100 rows; default 25 | standard | API contract guard |

## Measurement Plan

| Phase | Method | Owner | When |
|-------|--------|-------|------|
| Pre-deploy | Review query + index DDL in CODE | PB-implement | Implement |
| Post-deploy | k6 smoke @ 100 RPS in staging | Human | After H-IMPLEMENT |
| Regression | CI perf smoke (optional) | PB-verify | Verify phase |

**Plan only:** No scripts, runs, or result data in this artifact.

## Non-Goals

- Execute load tests or paste benchmark output in Plan phase
- Static review of implemented CODE (PB-perf-review, Verify phase)
- Guarantee production traffic shapes without human validation

## Infrastructure Assumptions

| Assumption | Value |
|------------|-------|
| Environment | Staging mirrors prod instance class |
| Data volume | ≥ 100k items seed for representative list |
| Cache | Redis session cache warm before latency sample |

## References

| artifact | path |
|----------|------|
| INT | work/intake/WR-PERF-ALPHA.md |

## Open Questions

| # | Question | Owner |
|---|----------|-------|
| 1 | Confirm staging RPS cap for k6 runs | Human |

## Human Approval

| gate_id | H-PLAN |
|---------|--------|
| decision | pending |