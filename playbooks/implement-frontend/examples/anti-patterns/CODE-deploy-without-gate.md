---
anti_pattern_id: CODE-deploy-without-gate
severity: P0
related_ec: EC-SCP-02
fails_checklist: 6
---

# Anti-Pattern — Deploy Without Gate

## What goes wrong

Agent completes implementation and includes production deployment:

```bash
# ⛔ FORBIDDEN in PB-implement-frontend output
aws s3 sync dist/ s3://production-cdn-bucket/ --delete
vercel --prod
```

Or in CODE §6:

```yaml
deployment:
  environment: production
  status: deployed
  url: https://app.example.com
```

## Symptoms

- H-IMPLEMENT and H-VERIFY bypassed
- Untested UI in production
- CL-IMPLEMENT-FRONTEND #6 fail
- Incident risk before PB-verify

## Correct pattern

Document tests in §6; hand off with `decision: pending`. Deployment is **human-only** after H-VERIFY and release process.

```yaml
gate_id: H-IMPLEMENT
decision: pending
recommended_next_skill: PB-verify
# No deploy commands
```

## Prevention

- CL-IMPLEMENT-FRONTEND check #6
- 09-system-prompt NEVER deploy binding
- N8 in 02-responsibilities.md
- STOP step in 03-workflow.md