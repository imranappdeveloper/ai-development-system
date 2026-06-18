---
anti_pattern_id: CODE-prod-deploy-without-gate
severity: P0
related_ec: EC-SCP-02
fails_checklist: 6
---

# Anti-Pattern — Production Deploy Without Gate

## What goes wrong

Agent completes DevOps implementation and includes production deployment:

```bash
# ⛔ FORBIDDEN in PB-implement-devops output
terraform apply -var-file=production.tfvars
kubectl apply -f k8s/production/deployment.yaml --context prod-cluster
git tag v1.2.0 && git push --tags
```

Or in CODE §6:

```yaml
deployment:
  environment: production
  status: deployed
  url: https://api.example.com
```

## Symptoms

- H-IMPLEMENT and H-VERIFY bypassed
- Untested pipeline changes in production
- CL-IMPLEMENT-DEVOPS #6 fail
- Incident risk before PB-verify

## Correct pattern

Document validation in §6 (plan-only for IaC); hand off with `decision: pending`. Production deployment is **human-only** after H-VERIFY and release process.

```yaml
gate_id: H-IMPLEMENT
decision: pending
recommended_next_skill: PB-verify
# No prod deploy commands
```

## Prevention

- CL-IMPLEMENT-DEVOPS check #6
- 09-system-prompt NEVER PROD DEPLOY binding
- N8 in 02-responsibilities.md
- STOP step in 03-workflow.md