---
anti_pattern_id: CODE-skip-validation
severity: P0
related_ec: EC-VAL-01
fails_checklist: 5
---

# Anti-Pattern — Skip Validation Documentation

## What goes wrong

Agent produces CODE record with empty or omitted §6 Validation Notes:

```markdown
## 6. Validation Notes

_TBD — will validate in CI later._
```

Or removes §6 entirely, assuming PB-verify will handle pipeline checks later.

## Symptoms

- CL-IMPLEMENT-DEVOPS #5 fail
- PB-verify cannot determine what was validated
- False confidence at H-IMPLEMENT
- STD-TEST-001 violation

## Correct pattern

Always document validation — run, added, plan-only, or explicitly `pending_ci` with commands:

```markdown
## 6. Validation Notes

| validation_type | command / path | status | notes |
|-----------------|----------------|--------|-------|
| workflow-syntax | `actionlint .github/workflows/ci.yml` | added | No errors |
| terraform-plan | `terraform plan -var-file=staging.tfvars` | plan_only | 2 resources to add — no apply |
| pipeline-dry-run | `act -j test --dryrun` | pending_ci | Requires act in CI image |
```

## Prevention

- CL-IMPLEMENT-DEVOPS check #5
- VAL-DOC mandatory step in workflow
- AC-VAL-01 / AC-VAL-02 in 06-quality.md