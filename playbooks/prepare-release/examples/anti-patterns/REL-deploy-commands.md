---
anti_pattern_id: REL-deploy-commands
severity: P0
related_ec: EC-SCP-01
fails_checklist: 10
---

# Anti-Pattern — Deploy Commands in Handoff

## What goes wrong

Agent includes executable deploy commands in OUT-04 handoff or REL §7:

```markdown
### 7.2 Deployment Steps

| Step | Action | Owner | Verified |
|------|--------|-------|----------|
| 1 | `kubectl apply -f k8s/api-deployment.yaml` | agent | yes |
| 2 | `terraform apply -auto-approve` | agent | yes |
```

Or in handoff:

```yaml
deploy_commands:
  - kubectl apply -f k8s/api-deployment.yaml -n production
  - helm upgrade api ./charts/api --set image.tag=1.2.0
```

## Symptoms

- CL-RELEASE #7 and #10 fail
- Unauthorized production mutation risk
- Scope bleed — release manager acting as deployer
- Violates N1 non-responsibility

## Correct pattern

Plan-only steps with human owner — no executable commands:

```markdown
| Step | Action | Owner | Verified |
|------|--------|-------|----------|
| 1 | Deploy API service to staging (approved pipeline) | platform-team | no |
| 2 | Run DB migration on staging | platform-team | no |
```

## Prevention

- `09-system-prompt.md` NEVER DEPLOY binding
- `03-workflow.md` STOP after HAND
- CL-RELEASE #7 plan-only criterion