# PB-perf-review — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-perf-review |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | CODE present; H-IMPLEMENT soft when CODE linked |
| P2 | Load CODE + PERF-BASE (soft) + WR | T1/T2 bundles per 05-context.md |
| P3 | Extract performance scope | Hot paths from CODE §4; NFR refs from PERF-BASE / PRD |
| P4 | Compare targets vs implementation | §3 NFR/baseline table; `baseline_alignment` when PERF-BASE linked |
| P5 | Identify performance findings | §4 severity-tagged items with locations |
| P6 | Build hotspot inventory | §5 ranked hotspots with rationale |
| P7 | Produce PERF-REVIEW (OUT-01) | Complete per 04-io-contract |
| P8 | Update Work Record | Link PERF-REVIEW; `perf_review_pending` |
| P9 | Run CL-PERF-REVIEW | Validation record = pass |
| P10 | Prepare handoff | H-VERIFY `decision: pending`; recommend next skill |

### perf_review_scope enum

| perf_review_scope | From signal |
|-------------------|-------------|
| `api_latency` | API handlers, middleware in CODE §4 |
| `database` | Queries, migrations, repositories |
| `memory` | Caching, buffers, large allocations |
| `concurrency` | Locks, pools, async patterns |
| `frontend_render` | UI components in CODE (frontend lane) |
| `mobile` | Mobile lane CODE |
| `infra` | DevOps lane CODE (CI, scaling config) |
| `mixed` | Multiple domains in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference TEST-RPT / TEST-PLAN perf sections (soft) | When linked in WR |
| S2 | Flag CODE gaps blocking review confidence | `perf_confidence: low`; `requires_code_revise` |
| S3 | Note measurement assumptions | §7 Recommendations — human benchmark steps only |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | WF-PERF mandatory baseline comparison | When PERF-BASE linked |
| O2 | Suggest splitting work_id | Hotspot count exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify CODE | PB-implement-* |
| N3 | Author PERF-BASE targets | PB-perf-baseline |
| N4 | Run load tests, k6, ab, wrk, locust, etc. | PB-verify / human |
| N5 | Populate §6 with live benchmark metrics | PB-verify / human |
| N6 | Approve H-VERIFY or advance to ship | Human |
| N7 | Auto-invoke next playbook | Human / orchestrator |
| N8 | Deep unrestricted repo profiling | Bounded per 05-context.md |
| N9 | Implement application fixes | PB-implement-* |
| N10 | Modify OS repository files | OS maintainer |
| N11 | Store decisions only in chat | Must persist PERF-REVIEW |
| N12 | Self-approve verification | Human at H-VERIFY |
| N13 | Skip CL-PERF-REVIEW or finding traceability | Never |
| N14 | Copy secrets into PERF-REVIEW | Redact `[REDACTED]` |
| N15 | Embed routing matrix in output | SSOT: routing-matrix.yaml |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| PERF-REVIEW draft | proposes | reviews findings; approves/rejects |
| Severity and hotspot ranking | proposes | may override at H-VERIFY |
| `baseline_gap: waiver` | documents | authorizes proceed without PERF-BASE |
| H-VERIFY decision | **never** approves | approve \| revise \| reject |
| Next playbook | recommends PB-prepare-release | approves chain |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| CODE | artifact | Required entry |
| PERF-BASE | artifact (soft) | WF-PERF baseline comparison |
| CL-PERF-REVIEW | checklist | Handoff blocker |
| STD-NAMING-001 | standard | Artifact paths |
| templates/review/template.md | template | Review shape reference |