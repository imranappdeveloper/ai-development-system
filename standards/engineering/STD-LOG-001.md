# STD-LOG-001 — Logging

| Field | Value |
|-------|-------|
| standard_id | STD-LOG-001 |
| version | 1.0.0 |
| status | active |
| owner | Platform Architect |
| review_cycle | quarterly |
| effective | 2026-06-18 |

---

## Purpose

Define **audit trails and run logs** for the OS — what to record, where, and retention — distinct from application logging in target codebases.

## Scope

- ORS `gate_history`, `playbook_history`, tick logs
- WR `approvals[]`
- Excludes: target app log format (project convention), secrets handling (**STD-SEC-001**)

## Rules

### Durable audit (MUST)

| Event | Store | Format |
|-------|-------|--------|
| Human gate decision | WR `approvals[]` + ORS `gate_history` | structured fields |
| Playbook completion | ORS `playbook_history` | append-only |
| Phase transition | ORS `phase_history` | append-only |
| Waiver | WR `approvals[]` with `waiver_reason` | required |

### Tick log (MUST)

Path: `{project_root}/work/orchestrator/logs/{run_id}.md`

Each orchestrator tick appends:

- `timestamp`, `run_id`, `command`, `playbook_id` (if any)
- `result` (ok | hold | recover | fail)
- `failure_code` if applicable — no stack traces with secrets

### Application logging (SHOULD)

Code produced under Implement SHOULD:

- Use structured fields: `work_id`, `request_id`, `level`
- Never log secrets or full PII (**STD-SEC-001**)
- Correlate to WR `work_id` in change descriptions

### Prohibited (MUST NOT)

- Chat transcripts as audit SSOT
- Deleting or rewriting `gate_history` / `approvals[]`
- Logging raw tokens, API keys, or auth headers

### Retention (SHOULD)

- ORS + WR: life of work item
- Tick logs: retain until work `done` + 90 days unless project policy differs

## Examples

```yaml
# gate_history entry
- gate_id: H-INTAKE
  decision: approve
  approver: human@example.com
  at: 2026-06-18T12:00:00Z
```

```markdown
## Tick 2026-06-18T12:01:00Z
command: tick
playbook_id: PB-discovery-research
result: ok
```

## Exceptions

- Debug verbosity MAY increase in `draft` skills — redact before `active`
- Meta review logs MAY live under OS `reviews/` instead of project `work/`
- Chat-only `persist: pending` ticks log handoff hash only — not full body if large

## Validation

| Check | Pass |
|-------|------|
| L-LOG-01 | Gate decisions in approvals or gate_history |
| L-LOG-02 | playbook_history append-only |
| L-LOG-03 | Tick log path matches DESIGN §5 |
| L-LOG-04 | No secret patterns in logs |

## Related Standards

| ID | Relationship |
|----|--------------|
| STD-MEM-001 | Durable vs ephemeral |
| STD-SEC-001 | Redaction in logs |
| STD-VER-001 | Audit for version changes |
| STD-REVIEW-001 | Review decisions logged |
| STD-WF-001 | Phase transitions logged |