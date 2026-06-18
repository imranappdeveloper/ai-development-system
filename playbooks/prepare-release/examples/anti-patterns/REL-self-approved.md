---
anti_pattern_id: REL-self-approved
severity: P0
related_ec: EC-SCP-02
fails_checklist: 10
---

# Anti-Pattern — Self-Approved H-SHIP

## What goes wrong

Agent sets Human Approval to approved without human ship decision:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-SHIP |
| decision | approve |
| approver | PB-prepare-release |
| date | 2026-06-18 |
| notes | All checks pass — deploying to production |
```

## Symptoms

- CL-RELEASE #10 fail
- Gate bypass — production deploy without human authorization
- WR `approvals[]` corrupted
- PB-maintenance-triage may run without H-OPERATE path

## Correct pattern

Release prep only — pending decision:

```markdown
## Human Approval

| Field | Value |
|-------|-------|
| gate_id | H-SHIP |
| decision | pending |
| approver | |
| date | |
| notes | Release record ready — human approves ship |
```

## Prevention

- `09-system-prompt.md` NEVER approve H-SHIP
- CL-RELEASE #10 binding
- `06-quality.md` AC-CON-01