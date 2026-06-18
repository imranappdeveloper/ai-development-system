# STD-TEST-001 — Testing

| Field | Value |
|-------|-------|
| standard_id | STD-TEST-001 |
| version | 1.0.0 |
| status | active |
| owner | Quality Lead |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Define **how skills and workflows are validated** before promotion — fixtures, goldens, test plans — not application unit test style (target repo).

## Scope

- Playbook `11-test-plan.md`, `fixtures/`, `examples/golden/`, `examples/anti-patterns/`
- Orchestrator G-ORCH scenarios
- Excludes: skill promotion gate list (**STD-SKILL-001** §16) — referenced, not duplicated

## Rules

### Test artifacts (MUST before `active`)

| Artifact | Path | Purpose |
|----------|------|---------|
| Test plan | `11-test-plan.md` | Suites, gates, evidence |
| Fixtures | `fixtures/` | Inputs + minimal project context |
| Golden | `examples/golden/` | Pass-shape reference outputs |
| Anti-pattern | `examples/anti-patterns/` | Known failures |

### Suite types (MUST)

| Code | Name | Scope |
|------|------|-------|
| HT | Happy path | Primary workflow for skill |
| ET | Edge | P0 EC-* from `07-edge-cases.md` |
| FT | Failure | Recovery and escalation |
| RT | Regression | Golden diff on spec/prompt change |
| IT | Integration | Downstream consumer reads OUT-* |
| ST | Stress | Concurrency, batch, token pressure |

### Evidence (MUST)

Promotion records date, suite, pass/fail in `10-review.md` — not chat.

### QA scenarios (SHOULD)

Skills with ≥50 edge cases SHOULD add `12-qa-scenarios.md` catalog; goldens still required for RT.

### Workflow tests (MUST)

At least one end-to-end path documented: WF-FEATURE Intake → Discovery with fixture linkage.

### No silent skip (MUST NOT)

`active` promotion with waived suite requires WR waiver + `10-review.md` explicit gap.

## Examples

```
fixtures/inputs/feature-request.md
  → golden/INT-feature-001.md
  → discovery fixtures/inputs/approved-int-feature.md
  → golden/DISC-feature-001.md
```

## Exceptions

- `planned` stubs: fixtures MAY be `.gitkeep` until spec phase
- Meta skills: reports as output — goldens are review report snapshots
- P3 skills MAY defer ST until first `active` cycle with documented gap

## Validation

| Gate | Criteria |
|------|----------|
| T-TEST-01 | G-SKILL-01–08 from STD-SKILL-001 satisfied |
| T-TEST-02 | ≥1 golden + ≥1 anti-pattern |
| T-TEST-03 | 11-test-plan promotion formula defined |
| T-TEST-04 | RT runs on `prompt_version` bump |

MS-quality-review audits T-TEST-*.

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-SKILL-001 | Promotion gates G-SKILL-* |
| STD-PROMPT-001 | RT on prompt changes |
| STD-VER-001 | When RT is mandatory |
| STD-WF-001 | IT workflow paths |
| STD-MD-001 | Golden file format |