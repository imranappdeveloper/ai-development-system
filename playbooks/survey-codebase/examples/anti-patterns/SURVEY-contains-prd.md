# Anti-pattern — PRD content in SURVEY

**Violation:** CL-SURVEY #7 — no PRD drafting in survey phase.

## Bad SURVEY excerpt

```markdown
## Functional Requirements

FR-1: The profile page shall display user email and notification preferences.
FR-2: Users must opt in to marketing emails per GDPR.
```

## Why wrong

- SURVEY documents **observed structure** — not product requirements
- PRD belongs to PB-draft-prd after Plan-phase gates
- Mixing phases pollutes SSOT and triggers downstream rework

## Correct behavior

Document observations with citations:

```markdown
## 7. Patterns & Conventions
- User email field exists on `User` model (`src/models/user.ts:14`) — profile UI not present
```

Defer requirements to PB-discovery-research → PB-draft-prd chain.