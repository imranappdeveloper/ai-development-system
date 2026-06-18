---
scenario_id: HT-01
skill_id: PB-discovery-research
prompt_version: 1.0.0
inputs:
  intake_artifact: work/intake/WR-FEATURE-001.md
  work_id: WR-FEATURE-001
expected_outputs:
  out_01_path: work/discovery/WR-FEATURE-001.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-draft-prd
---

---
document_id: DISC-WR-FEATURE-001
work_id: WR-FEATURE-001
discovery_type: feature
workflow_id: WF-FEATURE
discovery_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T11:00:00Z
upstream_int_path: work/intake/WR-FEATURE-001.md
---

# Discovery — User profile page

## 6.2 Intake Classification Alignment

```yaml
intake_classification_alignment:
  intake_work_type: feature
  intake_workflow_id: WF-FEATURE
  alignment: aligned
  mismatch_summary: null
```

## Summary

OAuth exists; profile UI absent. Stakeholders: product, support. Constraints: GDPR email consent.

## Open Questions

- Notification channels: push required in v1?

## Human Approval

| gate_id | H-FRAME |
| decision | pending |