---
anti_pattern_id: IMP-skip-issues
severity: P0
related_ec: EC-RT-11, EC-RT-12
---

# Anti-Pattern — Skip Issues Before Implement

## What goes wrong

Agent invokes a lane child without ISS-* or ISS entry:

```yaml
work_id: WR-FEATURE-001
artifacts:
  - PRD
  - API
  - UIUX
  # ISS-* absent
playbook_invocation:
  skill_id: PB-implement-backend
```

## Symptoms

- H-DECOMPOSE bypassed on WF-FEATURE path
- Untraceable implement scope — no ISS acceptance criteria
- CODE changes not mapped to work breakdown
- Verify cannot map tests to ISS IDs

## Correct pattern

**WF-FEATURE / WF-ENHANCEMENT:**

```yaml
# First: decompose
playbook_invocation:
  skill_id: PB-decompose-issues
# After H-DECOMPOSE: lane child per ISS
```

**WF-BUGFIX:**

```yaml
playbook_invocation:
  skill_id: PB-draft-issue
# After H-PLAN: lane child per ISS
```

## Prevention

- Decision matrix DM-08 (`missing_issues` blocker)
- CL-IMPLEMENT-UMBRELLA item #3
- EC-RT-11 / EC-RT-12 block and redirect