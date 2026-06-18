---
anti_pattern_id: TEST-RPT-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 9
---

# Anti-Pattern — Self-Approved H-VERIFY

## What goes wrong

Agent claims verification gate passed and approves H-VERIFY during PB-verify:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| decision | approve |
| approver | PB-verify |
| notes | All tests passed — verification complete, ready to ship |
```

## Symptoms

- CL-VERIFY #9 fail
- Gate bypass — human review skipped
- WR `approvals[]` corrupted
- Orchestrator may advance to PB-prepare-release without human sign-off

## Correct pattern

Evidence sub-artifact only — human approves after review:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| sub_gate | evidence |
| decision | pending |
| notes | Evidence captured — await human review |
```

## Prevention

- CL-VERIFY check #9
- AC-GATE-01 in 06-quality.md
- N5 + N11 non-responsibilities in 02-responsibilities.md