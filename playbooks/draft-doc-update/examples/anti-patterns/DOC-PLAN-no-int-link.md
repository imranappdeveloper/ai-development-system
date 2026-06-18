---
document_id: DOC-PLAN-WR-BAD-NOINT
work_id: WR-BAD-002
doc_plan_type: full
workflow_id: WF-DOCS
status: pending_review
upstream_int_path: null
quality_chain_gap: none
---

# DOC-PLAN — BAD EXAMPLE (no INT link)

## 3. Upstream Traceability

```yaml
upstream_traceability:
  intake_work_type: documentation
  intake_workflow_id: WF-DOCS
  upstream_int_path: null
  quality_chain_linked: false
  quality_chain_refs: []
  quality_chain_alignment: not_applicable
```

## 5. Planned Updates

| ID | Doc path | Change type | Priority | Owner | Acceptance signal |
|----|----------|-------------|----------|-------|-------------------|
| DU-01 | docs/api.md | create | P0 | human | Exists |

**Why anti-pattern:** CL-DOC-UPDATE #4 — `upstream_int_path` must be set; INT is required entry artifact.