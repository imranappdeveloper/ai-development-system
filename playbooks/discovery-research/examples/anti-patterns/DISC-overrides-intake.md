# Anti-pattern — Discovery overrides intake classification

**Violation:** CL-DISCOVERY #8 — agent assigns new `work_type` or `workflow_id` in DISC.

## Bad DISC excerpt

```yaml
work_type: enhancement   # changed from INT feature
workflow_id: WF-ENHANCEMENT
```

## Why wrong

- Classification SSOT is INT (post H-INTAKE)
- Must use `intake_classification_alignment` block instead

## Correct behavior

```yaml
intake_classification_alignment:
  intake_work_type: feature
  intake_workflow_id: WF-FEATURE
  alignment: partial_mismatch
  mismatch_summary: Evidence suggests enhancement scope — recommend re-intake
```

If mismatch is material → `alignment: requires_re_intake` and recommend PB-intake-classify.