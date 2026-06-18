---
anti_pattern_id: TEST-PLAN-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 10
---

# Anti-Pattern — Self-Approved H-VERIFY

## What goes wrong

Agent sets Human Approval to approved without human review:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| decision | approve |
| approver | PB-test-plan |
| date | 2026-06-18 |
| notes | All tests planned — verification complete |
```

## Symptoms

- CL-TEST-PLAN #10 fail
- Gate bypass — downstream PB-verify skipped
- WR `approvals[]` corrupted
- Orchestrator may advance to ship without evidence

## Correct pattern

Plan sub-artifact only — pending decision; recommend PB-test-generate:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| sub_gate | plan |
| decision | pending |
| approver | |
| date | |
| notes | Plan sub-artifact — full H-VERIFY after PB-verify evidence |
```

## Prevention

- CL-TEST-PLAN check #10
- AC-CON-01 in 06-quality.md
- N13 non-responsibility in 02-responsibilities.md