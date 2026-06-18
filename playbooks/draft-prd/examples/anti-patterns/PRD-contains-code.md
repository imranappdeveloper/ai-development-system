---
document_id: PRD-WR-BAD-CODE
work_id: WR-BAD-001
prd_type: full
status: pending_review
upstream_int_path: work/intake/WR-BAD-001.md
discovery_gap: waiver
---

# PRD — BAD EXAMPLE (contains code)

## 4.1 Functional Requirements

FR-01: Profile API shall return user data.

```python
def get_profile(user_id):
    return db.query("SELECT * FROM users WHERE id = ?", user_id)
```

**Why anti-pattern:** CL-PRD #7 — no application code in PRD. Defer to TP-api and PB-implement.