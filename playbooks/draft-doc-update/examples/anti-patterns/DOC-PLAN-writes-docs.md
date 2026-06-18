---
document_id: DOC-PLAN-WR-BAD-WRITE
work_id: WR-BAD-003
doc_plan_type: lite
workflow_id: WF-DOCS
status: pending_review
upstream_int_path: work/intake/WR-BAD-003.md
quality_chain_gap: waiver
---

# DOC-PLAN — BAD EXAMPLE (writes doc bodies during plan)

## 5. Planned Updates

| ID | Doc path | Change type | Priority | Owner | Acceptance signal |
|----|----------|-------------|----------|-------|-------------------|
| DU-01 | docs/api.md | create | P0 | agent | **Agent already wrote full API doc below** |

### Agent-written content (FORBIDDEN during Plan)

```markdown
# API Reference
## POST /v1/users
Creates a user. Request body: { "email": "..." }
```

**Why anti-pattern:** CL-DOC-UPDATE #7 — plan only; doc bodies must not be authored until human execution post-H-PLAN. Acceptance signal should describe done-when, not embed prose.