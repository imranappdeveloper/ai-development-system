# Anti-pattern — Agent overrides intake classification

**Violation:** CL-ONBOAR #8 — agent assigns new `work_type` in ONBOARD.

## Bad ONBOARD excerpt

```yaml
intake_classification_alignment:
  intake_work_type: feature
  intake_workflow_id: WF-FEATURE
  alignment: aligned
```

When INT says `existing_project` / `WF-PROJECT-EXISTING`.

## Why wrong

- PB-intake-classify owns classification
- Onboard may only report `partial_mismatch` or `requires_re_intake`

## Correct behavior

```yaml
intake_classification_alignment:
  intake_work_type: existing_project
  intake_workflow_id: WF-PROJECT-EXISTING
  alignment: aligned
```

If mismatch suspected: `alignment: requires_re_intake` and recommend PB-intake-classify.