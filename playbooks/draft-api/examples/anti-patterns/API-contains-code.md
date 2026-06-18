---
document_id: API-WR-BAD-CODE
work_id: WR-BAD-CODE
change_type: new
status: pending_review
---

# API Specification — BAD EXAMPLE (contains handler code)

## 4. Endpoints / Operations

### 4.2 Operation Detail — API-001

```python
@app.get("/users/me/preferences")
def get_preferences(user_id: UUID):
    return db.query(UserPreference).filter_by(user_id=user_id).first()
```

**Why anti-pattern:** CL-API #8 — API specification documents contract structure in tables; handler implementation belongs in PB-implement-backend phase.