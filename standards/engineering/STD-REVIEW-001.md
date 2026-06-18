# STD-REVIEW-001 — Code Review

| Field | Value |
|-------|-------|
| standard_id | STD-REVIEW-001 |
| version | 1.0.0 |
| status | active |
| owner | Engineering Lead |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Standards for **reviewing code artifacts** produced during Implement/Verify — distinct from playbook spec review (`10-review.md`) and `PB-review` skill delivery.

## Scope

- Human and agent review of code changes in target `project_root`
- Review records linked to WR
- Excludes: architect spec review (**STD-SKILL-001**), meta OS audits (**STD-META-001**)

## Rules

### When review is required (MUST)

- Before H-VERIFY `approve` on workflows with Implement phase
- After `PB-implement` handoff when CODE artifact exists
- Security- or perf-touching changes: second reviewer SHOULD per **STD-SEC-001** / **STD-PERF-001**

### Review dimensions (MUST)

| Dimension | Check |
|-----------|-------|
| Correctness | Matches approved plan artifact (PRD/ISS) |
| Scope | No drive-by refactors |
| Tests | Coverage per project policy; verify playbook AC met |
| Security | No secrets, safe dependencies (**STD-SEC-001**) |
| Observability | Logging per **STD-LOG-001** where applicable |
| Style | Project conventions — not OS markdown rules |

### Review record (MUST)

Produce or update review artifact (`TP-review`) or WR note with:

- `reviewer`, `date`, `decision` (approve | changes_requested | reject)
- Finding severity: P0 | P1 | P2
- Links to files/lines reviewed

### Agent review limits (MUST NOT)

- Agent review does not satisfy H-VERIFY alone — human gate remains advisory model per **docs/GOVERNANCE.md**
- Agent MUST NOT approve its own implement output without separate review pass

### Severity (MUST)

| Level | Blocks merge |
|-------|--------------|
| P0 | Security, data loss, broken build |
| P1 | Missing tests, spec deviation |
| P2 | Style, naming nit |

## Examples

```markdown
## Review — WR-FEATURE-001
decision: changes_requested
findings:
  - P1: ISS-003 acceptance test not added
  - P2: log message missing request_id (STD-LOG-001)
```

## Exceptions

- Docs-only / `WF-DOCS` MAY waive code review at H-VERIFY via `gates.yaml`
- Solo maintainer projects MAY use self-review with explicit WR waiver
- `PB-review` playbook when `active` becomes delivery SSOT — this standard remains the normative baseline

## Validation

| Check | Pass |
|-------|------|
| R-REV-01 | Review record exists before H-VERIFY |
| R-REV-02 | P0 findings = 0 at approve |
| R-REV-03 | Scope matches ISS/PRD linkage in WR |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-TEST-001 | Tests as review input |
| STD-SEC-001 | Security findings |
| STD-LOG-001 | Logging findings |
| STD-ARCH-001 | Boundary violations |
| STD-VER-001 | Version bumps on API change |