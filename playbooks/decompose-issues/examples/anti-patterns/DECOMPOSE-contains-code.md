---
anti_pattern_id: DECOMPOSE-contains-code
severity: P0
related_ec: EC-SCP-01
fails_checklist: 7
---

# Anti-Pattern — Implementation Code in ISS-*

## What goes wrong

Issue body includes handler or UI implementation:

```python
# ISS-BE-001 — BAD
@router.get("/users/me/preferences")
def get_preferences(session: Session):
    return repo.get_prefs(session.user_id)
```

```tsx
// ISS-FE-001 — BAD
export function ProfilePage() {
  const [prefs, setPrefs] = useState(null);
  return <div>{prefs.email}</div>;
}
```

## Symptoms

- CL-DECOMP #7 fail
- Scope bleeds into Implement phase
- AC not testable at design level
- Lane child duplicates or conflicts with issue intent

## Correct pattern

Use testable acceptance criteria and references only:

| id | criterion | verify |
|----|-----------|--------|
| AC-1 | GET `/users/me/preferences` returns preference | contract test API-001 |

## Prevention

- CL-DECOMP check #7
- N5 in 02-responsibilities.md
- EC-SCP-01 in 07-edge-cases.md