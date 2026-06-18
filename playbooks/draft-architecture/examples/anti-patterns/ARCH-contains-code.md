---
document_id: ARCH-WR-BAD-CODE
work_id: WR-BAD-CODE
architecture_type: delta
status: pending_review
---

# Architecture — BAD EXAMPLE (contains code)

## 4. Component Design

```python
class ProfileService:
    def update_email(self, user_id, email):
        db.execute("UPDATE users SET email = ?", email)
```

**Why anti-pattern:** CL-ARCH #7 — architecture documents structure and boundaries; implementation code belongs in PB-implement phase.