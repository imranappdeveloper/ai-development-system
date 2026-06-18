---
document_id: DB-WR-BAD-SQL
work_id: WR-BAD-SQL
change_type: new_schema
status: pending_review
---

# Database Design — BAD EXAMPLE (contains SQL)

## 5. Migration Plan

```sql
CREATE TABLE user_preferences (
  user_id UUID PRIMARY KEY REFERENCES users(user_id),
  email_notifications_enabled BOOLEAN NOT NULL DEFAULT true
);
```

**Why anti-pattern:** CL-DATABASE #7 — database design documents schema structure in tables; executable DDL belongs in PB-implement phase.