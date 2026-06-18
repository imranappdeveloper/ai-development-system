# STD-PERF-001 — Performance

| Field | Value |
|-------|-------|
| standard_id | STD-PERF-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Efficiency rules for **token use, context size, and orchestration overhead** — not application runtime performance in target repos.

## Scope

- Context tier budgets (**STD-CTX-001**)
- Orchestrator minimal load policy
- Performance work routing (`WF-PERF`, `PB-perf-baseline`)
- Excludes: application profiling methodology (target project)

## Rules

### Token budget (MUST)

- Declare caps in playbook `05-context.md` (T1–T3 percentages)
- Orchestrator envelope includes `token_budget_remaining` when adapter supports
- Exceed budget → degrade per STD-CTX-001 before fail

### Load minimization (MUST)

| Actor | Max load |
|-------|----------|
| ORCH-PROJECT | T0 + T1 only |
| Intake | WR + raw request + CONTEXT slice |
| Discovery | INT + bounded CONTEXT — no full repo scan |
| Implement | Issue-scoped paths only |

### Digest over full copy (SHOULD)

T2 uses paths + SHA digests — not full PRD/DISC bodies in orchestrator handoff.

### Parallelism (MUST NOT)

- One mutating playbook per `work_id` per tick
- Verify phase `PB-verify` and `PB-review` MAY sequence — not parallel mutate on same artifact

### Perf work type (MUST)

`work_type: performance` → `WF-PERF` → `PB-perf-baseline` when active; baseline artifact before implement.

### Measurement (SHOULD)

Test plans SHOULD record approximate token usage on golden runs when tooling available — evidence in `11-test-plan.md`.

## Examples

| Anti-pattern | Fix |
|--------------|-----|
| Load entire `src/` in discovery | Module map in CONTEXT.md + bounded paths |
| Repeat full INT in every tick | WR digest + path ref |
| Embed PRD in orchestrator envelope | T2 path only |

## Exceptions

- `PB-survey-codebase` MAY exceed default T3 with explicit path cap in spec
- Stress tests (ST) intentionally pressure budget — isolated fixtures only
- Human may waive budget with `waiver_reason` for one tick

## Validation

| Check | Pass |
|-------|------|
| P-PERF-01 | 05-context.md declares budgets |
| P-PERF-02 | Orchestrator prompt forbids T3 domain load |
| P-PERF-03 | E-CONTEXT recovery documented in orchestrator |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-CTX-001 | Tier definitions |
| STD-MEM-001 | Avoid redundant persistence |
| STD-PROMPT-001 | Concise prompts |
| STD-WF-001 | WF-PERF path |
| STD-LOG-001 | Tick log size discipline |