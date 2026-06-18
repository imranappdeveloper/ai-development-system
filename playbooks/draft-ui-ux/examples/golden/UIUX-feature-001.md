---
scenario_id: HT-01
skill_id: PB-draft-ui-ux
prompt_version: 1.0.0
inputs:
  orchestrator_ref:
    workflow_id: WF-FEATURE
    current_phase: Plan
  playbook_invocation:
    skill_id: PB-draft-ui-ux
    mode: new
  work_id: WR-FEATURE-ALPHA
  project_root: fixtures/projects/wf-feature-alpha
  artifact_refs:
    - type: PRD
      path: work/prd/WR-FEATURE-ALPHA.md
    - type: ARCH
      path: work/architecture/WR-FEATURE-ALPHA.md
    - type: DISC
      path: work/discovery/WR-FEATURE-ALPHA.md
expected_outputs:
  out_01_path: work/uiux/WR-FEATURE-ALPHA.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-implement-frontend
---

---
document_id: UIUX-WR-FEATURE-ALPHA
work_id: WR-FEATURE-ALPHA
change_type: new
uiux_type: screen_flow
workflow_id: WF-FEATURE
uiux_confidence: high
status: pending_review
revision: 0
created: 2026-06-18T17:00:00Z
upstream_prd_path: work/prd/WR-FEATURE-ALPHA.md
upstream_arch_path: work/architecture/WR-FEATURE-ALPHA.md
upstream_disc_path: work/discovery/WR-FEATURE-ALPHA.md
template_id: TP-uiux
---

# UI/UX Plan — User profile preferences

## Document Metadata

| Field | Value |
|-------|-------|
| document_id | UIUX-WR-FEATURE-ALPHA |
| work_id | WR-FEATURE-ALPHA |
| project | wf-feature-alpha |
| author | PB-draft-ui-ux |
| created | 2026-06-18 |
| last_updated | 2026-06-18 |
| status | pending_review |
| uiux_type | screen_flow |
| change_type | new |

---

## 1. Overview

### 1.1 Purpose

Define the authenticated user profile experience for viewing and updating email notification preferences (PRD FR-01–FR-03), including GDPR consent capture on save.

### 1.2 Scope

| In scope | Out of scope |
|----------|--------------|
| Profile page layout and preference toggle UX | Push notification settings UI |
| Loading, empty, error, and success states | Admin user management screens |
| GDPR consent modal on preference change | OAuth provider linking flows |
| Responsive layout for web (desktop + tablet) | Native mobile app screens |

### 1.3 Related Documents

| Document | Path |
|----------|------|
| PRD | work/prd/WR-FEATURE-ALPHA.md |
| ARCH | work/architecture/WR-FEATURE-ALPHA.md |
| DISC | work/discovery/WR-FEATURE-ALPHA.md |

```yaml
prd_alignment:
  prd_document_id: PRD-WR-FEATURE-ALPHA
  prd_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  prd_path: work/prd/WR-FEATURE-ALPHA.md
arch_alignment:
  arch_document_id: ARCH-WR-FEATURE-ALPHA
  arch_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  arch_path: work/architecture/WR-FEATURE-ALPHA.md
arch_gap: none
disc_alignment:
  disc_document_id: DISC-WR-FEATURE-ALPHA
  disc_work_id: WR-FEATURE-ALPHA
  alignment: aligned
  mismatch_summary: null
  disc_path: work/discovery/WR-FEATURE-ALPHA.md
disc_gap: none
```

---

## 2. Users & Journeys

| Persona | Primary journey | Success metric |
|---------|-----------------|----------------|
| Authenticated end user (DISC P-01) | Land on profile → view current email preference → toggle → confirm GDPR consent → see success | Completes update in < 60s without support |
| Returning user | Open profile from nav → verify saved preference persists | Zero confusion on current state |

**Journey — update email preference**

1. User navigates to Profile from main navigation.
2. Page loads current preference (ARCH ProfileService read flow).
3. User toggles email notifications on/off.
4. GDPR consent modal appears before save (PRD FR-03).
5. User confirms; system shows inline success and updated toggle state.

---

## 3. Information Architecture

| Area | Screens / states | Notes |
|------|------------------|-------|
| Account | Profile main | Entry from global nav; shows email + preference section |
| Consent | GDPR modal overlay | Blocking modal on preference change only |
| Feedback | Inline success / error banner | Non-blocking; dismissible |

---

## 4. Screen Inventory

| ID | Screen | Purpose | Priority |
|----|--------|---------|----------|
| SCR-001 | Profile page | Display email and current notification preference | P0 |
| SCR-002 | GDPR consent modal | Capture explicit consent before save (FR-03) | P0 |
| SCR-003 | Preference save feedback | Confirm success or surface API error | P0 |

---

## 5. Interaction & States

| Screen | States (loading, empty, error) | Key interactions |
|--------|-------------------------------|------------------|
| SCR-001 Profile | loading: skeleton for preference row; empty: n/a (auth required); error: full-page retry | Toggle preference triggers consent modal |
| SCR-002 GDPR modal | loading: disabled confirm while saving; error: inline message on save failure | Cancel returns to prior toggle; Confirm saves |
| SCR-003 Feedback | success: green banner 5s auto-dismiss; error: persistent until dismissed | Retry on error reopens save flow |

---

## 6. Accessibility (STD-A11Y-001)

| Requirement | Target |
|-------------|--------|
| Keyboard navigation | All interactive elements reachable; modal traps focus |
| Screen reader labels | Toggle announces current on/off state |
| Color contrast | WCAG 2.1 AA for text and toggle indicators |
| Motion | Respect `prefers-reduced-motion` for banner animations |
| Form errors | Error text linked via `aria-describedby` |

---

## 7. Responsive / Platform Notes

| Breakpoint / platform | Layout approach |
|-----------------------|-----------------|
| Desktop (≥1024px) | Two-column profile: identity left, preferences right |
| Tablet (768–1023px) | Single column; preference section below identity |
| Web only (this work_id) | Mobile native deferred — recommend PB-implement-mobile if scope expands |

---

## 8. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Default preference for new users (on vs off)? | Product | open |
| 2 | Push notification UI timeline? | Product | deferred |

---

## Human Approval

| gate_id | H-PLAN |
| decision | pending |
| approver | — |
| date | — |

---

## Changelog

| version | date | author | change |
|---------|------|--------|--------|
| 1.0.0 | 2026-06-18 | PB-draft-ui-ux | Initial draft |