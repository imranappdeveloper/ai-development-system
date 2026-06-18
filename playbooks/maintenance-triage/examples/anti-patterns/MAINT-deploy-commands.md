# Anti-pattern — Deploy commands in MAINT

**Violation:** CL-MAINT #7 — agent includes live deploy commands.

## Bad MAINT excerpt

```markdown
## 7. Child Work Records
Run: `kubectl apply -f deploy/production.yaml`
Run: `npm run migrate:prod`
```

## Why wrong

- PB-maintenance-triage never executes or instructs production mutation
- Deployment belongs to human CI/CD after H-OPERATE
- N2 forbids deploy/patch commands

## Correct behavior

Document **proposed** child work_ids in §7 table only:

```markdown
| work_id | Workflow | Status | Link |
| (proposed) WR-SEC-001 | WF-SECURITY | proposed | M-001 |
```

No shell commands in MAINT body.