---
anti_pattern_id: IMP-wrong-lane
severity: P0
related_ec: EC-RT-06, EC-RT-07, EC-RT-08
---

# Anti-Pattern — Wrong Implementation Lane

## What goes wrong

Agent routes work to the incorrect lane child:

```yaml
# ISS tags: api_handlers, database_migration
playbook_invocation:
  skill_id: PB-implement-frontend  # WRONG
```

Or:

```yaml
# ISS tags: react_component, css_layout; UIUX present
playbook_invocation:
  skill_id: PB-implement-backend  # WRONG
```

## Symptoms

- API changes attempted in frontend repo (or vice versa)
- H-IMPLEMENT approval on wrong artifact set
- Cross-lane rework and merge conflicts
- PB-verify fails on wrong test targets

## Correct pattern

1. Read ISS tags and plan artifacts (API, UIUX, DB)
2. Match to `fixtures/decision-matrix.yaml`
3. Invoke correct lane:

| Signals | Lane |
|---------|------|
| API, DB, server | `PB-implement-backend` |
| UIUX web, components | `PB-implement-frontend` |
| Mobile-primary UIUX | `PB-implement-mobile` |
| cicd, terraform, k8s | `PB-implement-devops` |

## Prevention

- CL-IMPLEMENT-UMBRELLA items #7–#8
- Golden example implement-routing-decision-001.md
- EC-RT-06 through EC-RT-08 recovery paths