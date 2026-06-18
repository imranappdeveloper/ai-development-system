---
scenario_id: HT-01
skill_id: PB-draft-feature
prompt_version: 1.0.0
inputs:
  work_id: WR-FEAT-NARROW-001
  project_root: fixtures/projects/wf-feat-narrow
  artifact_refs:
    - type: DISC
      path: work/discovery/WR-FEAT-NARROW-001.md
expected_outputs:
  artifact_path: work/feature/WR-FEAT-NARROW-001.md
  checklist_result: pass
  gate_decision: pending
  recommended_next_skill: PB-decompose-issues
---

---
document_id: FEAT-WR-FEAT-NARROW-001
work_id: WR-FEAT-NARROW-001
feat_type: enhancement
feat_scope: narrow_slice
workflow_id: WF-FEATURE
status: pending_review
revision: 0
created: 2026-06-18T14:00:00Z
upstream_disc_path: work/discovery/WR-FEAT-NARROW-001.md
upstream_int_path: work/intake/WR-FEAT-NARROW-001.md
discovery_alignment: aligned
discovery_gap: none
---

# FEAT — Notification channel toggles on profile page

## Summary

Authenticated users can enable or disable email notification channels from the profile page. This narrow slice delivers self-service preference control without avatar upload or push notifications (deferred per DISC).

## Upstream Context

```yaml
upstream_traceability:
  discovery_linked: true
  discovery_alignment: aligned
  intake_workflow_id: WF-FEATURE
  prd_waived: true
  narrow_slice_rationale: DISC recommends profile prefs as single vertical slice; PRD overhead waived
```

| Reference | Path |
|-----------|------|
| discovery | work/discovery/WR-FEAT-NARROW-001.md |
| intake | work/intake/WR-FEAT-NARROW-001.md |

OAuth session exists; profile UI absent. GDPR email consent required per DISC.

## Scope

### In Scope

| Item | Notes |
|------|-------|
| Display current notification channel toggles | Email channel required v1 |
| Persist toggle changes for authenticated user | Session-scoped save feedback |
| Accessible form labels and error states | WCAG 2.1 AA intent |

### Out of Scope

| Item | Rationale |
|------|-----------|
| Avatar upload | DISC out of scope |
| Push notifications | Open question — deferred |
| Admin impersonation | Separate security initiative |

## User-Visible Behavior

### Flows

| Flow ID | Actor | Steps summary |
|---------|-------|---------------|
| F-01 | Logged-in user | Open profile → view notification toggles → change email toggle → save → see confirmation |
| F-02 | Logged-in user | Attempt save with validation error → see inline message |

### Business Rules

| Rule ID | Rule | Source |
|---------|------|--------|
| BR-01 | Email channel cannot be fully disabled if account has no alternate contact | DISC GDPR constraint |
| BR-02 | Unauthenticated users cannot access preference UI | DISC security note |

## Acceptance Criteria

| ID | Criterion | Testable | Verification method |
|----|-----------|----------|---------------------|
| AC-01 | Authenticated user sees current email notification toggle state | yes | Manual + automated UI test |
| AC-02 | Toggle change persists across sessions | yes | E2E test |
| AC-03 | Unauthenticated access is blocked | yes | Route guard test |
| AC-04 | Form controls meet WCAG 2.1 AA labels | yes | Accessibility audit |

## Dependencies

| Dependency | Type | Status |
|------------|------|--------|
| OAuth session | internal | active per DISC |
| User preference storage | internal | assumed — detail deferred to implement |

High-level only — no API/DB specification in this artifact.

## Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | Push notifications required in v1? | Product | open |

## Human Approval

| gate_id | H-PLAN |
| decision | pending |

## References

| Type | Path |
|------|------|
| DISC | work/discovery/WR-FEAT-NARROW-001.md |
| INT | work/intake/WR-FEAT-NARROW-001.md |
| work_record | WR-FEAT-NARROW-001 |