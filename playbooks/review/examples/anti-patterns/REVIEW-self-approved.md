---
anti_pattern_id: REVIEW-self-approved
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
| approver | PB-review |
| date | 2026-06-18 |
| notes | Code review complete — ready to ship |
```

## Symptoms

- CL-REVIEW #10 fail
- Gate bypass — downstream ship without verify evidence
- WR `approvals[]` corrupted
- Orchestrator may advance to PB-prepare-release without TEST-RPT

## Correct pattern

Review sub-artifact only — pending decision:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| sub_gate | review |
| decision | pending |
| approver | |
| date | |
| notes | Review sub-artifact — full H-VERIFY after PB-verify TEST-RPT |
```

## Prevention

- `09-system-prompt.md` NEVER approve H-VERIFY
- CL-REVIEW #10 binding
- `06-quality.md` AC-CON-01