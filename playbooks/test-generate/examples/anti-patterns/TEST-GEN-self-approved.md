---
anti_pattern_id: TEST-GEN-self-approved
severity: P0
related_ec: EC-SCP-03
fails_checklist: 9
---

# Anti-Pattern — Self-Approved H-VERIFY

## What goes wrong

Agent claims verification complete and approves H-VERIFY during generation:

```markdown
## Handoff

| Field | Value |
|-------|-------|
| gate_id | H-VERIFY |
| decision | approve |
| approver | PB-test-generate |
| notes | Tests generated and verified — ready to ship |
```

## Symptoms

- CL-TEST-GEN #9 fail
- Gate bypass — PB-verify skipped
- WR `approvals[]` corrupted
- Orchestrator may advance to ship without evidence

## Correct pattern

Generation sub-step only — no gate binding; recommend PB-verify:

```markdown
## 7. Handoff

| Field | Value |
|-------|-------|
| recommended_next_skill | PB-verify |
| alternate_next_skill | PB-review |
| exit_gate | none |
| notes | Generation complete — execution deferred to PB-verify |
```

## Prevention

- CL-TEST-GEN check #9
- AC-GATE-01 in 06-quality.md
- N6 + N12 non-responsibilities in 02-responsibilities.md