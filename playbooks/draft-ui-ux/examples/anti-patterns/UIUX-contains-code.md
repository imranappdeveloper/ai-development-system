---
document_id: UIUX-WR-BAD-CODE
work_id: WR-BAD-CODE
change_type: new
status: pending_review
---

# UI/UX Plan — BAD EXAMPLE (contains component code)

## 5. Interaction & States

### SCR-001 Profile toggle

```tsx
export function PreferenceToggle({ value, onChange }) {
  return <Switch checked={value} onCheckedChange={onChange} />;
}
```

**Why anti-pattern:** CL-UIUX #8 — UIUX documents interaction structure in tables; component implementation belongs in PB-implement-frontend phase.