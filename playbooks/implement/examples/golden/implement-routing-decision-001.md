---
example_id: IMP-ROUTING-001
umbrella: PB-implement
purpose: When to use PB-implement-backend vs PB-implement-frontend vs other lanes
status: golden
created: 2026-06-18
---

# Golden Example — Implementation Lane Routing Decisions

**Rule:** `PB-implement` is consulted for resolution only — never invoked.

---

## Scenario A — Backend API implementation (ISS + API)

### Context

```yaml
work_id: WR-API-NOTIFY-001
workflow_id: WF-FEATURE
current_phase: Implement
artifacts:
  - ISS-NOTIFY-001
  - ISS-NOTIFY-002
  - API    # approved at H-PLAN
  - UIUX   # absent
gates:
  - H-DECOMPOSE: approved
  - H-PLAN: approved
human_request: "Implement the notification API handlers"
lane_signals: [api_handlers, migrations]
```

### Decision

| Question | Answer |
|----------|--------|
| Invoke PB-implement? | **No** |
| Resolved routing ID | `PB-implement-backend` |
| Why not PB-implement-frontend? | No UIUX; ISS tags are server-only |
| Why not PB-implement-mobile? | No mobile scope in PRD or ISS |

### routing_resolution

```yaml
routing_resolution:
  umbrella_consulted: PB-implement
  resolved_targets:
    - skill_id: PB-implement-backend
      lane: backend
      rationale: API spec + server ISS tags; H-DECOMPOSE approved
  never_invoke: PB-implement
  routing_confidence: high
  implement_lane: backend
  blockers: []
```

---

## Scenario B — Frontend web implementation (ISS + UIUX)

### Context

```yaml
work_id: WR-UI-SETTINGS-001
workflow_id: WF-FEATURE
current_phase: Implement
artifacts:
  - ISS-SETTINGS-UI-001
  - UIUX   # approved at H-PLAN
  - API    # absent for this ISS
gates:
  - H-DECOMPOSE: approved
human_request: "Build the settings page components"
lane_signals: [components, pages, web_ui]
```

### Decision

| Question | Answer |
|----------|--------|
| Invoke PB-implement? | **No** |
| Resolved routing ID | `PB-implement-frontend` |
| Why not PB-implement-backend? | UI-only ISS; no API scope |
| Prerequisite note | PB-draft-ui-ux gate PASS enables reliable UIUX lane signals |

### routing_resolution

```yaml
routing_resolution:
  umbrella_consulted: PB-implement
  resolved_targets:
    - skill_id: PB-implement-frontend
      lane: frontend
      rationale: UIUX approved; web component ISS
  never_invoke: PB-implement
  routing_confidence: high
  implement_lane: frontend
  blockers: []
```

---

## Scenario C — Full-stack feature (multi-lane parallel)

### Context

```yaml
work_id: WR-PROFILE-001
workflow_id: WF-FEATURE
current_phase: Implement
artifacts:
  - ISS-PROFILE-API-001
  - ISS-PROFILE-UI-001
  - API
  - UIUX
gates:
  - H-DECOMPOSE: approved
human_request: "Implement the profile feature end to end"
```

### Decision

| Question | Answer |
|----------|--------|
| Invoke PB-implement once? | **No** — anti-pattern |
| Resolved routing IDs | `PB-implement-backend` + `PB-implement-frontend` (parallel) |
| implement_lane | `multi_lane` |

### routing_resolution

```yaml
routing_resolution:
  umbrella_consulted: PB-implement
  resolved_targets:
    - skill_id: PB-implement-backend
      lane: backend
      rationale: ISS-PROFILE-API-001 + API artifact
    - skill_id: PB-implement-frontend
      lane: frontend
      rationale: ISS-PROFILE-UI-001 + UIUX artifact
  never_invoke: PB-implement
  routing_confidence: high
  implement_lane: multi_lane
  blockers: []
```

---

## Scenario D — Wrong: invoke umbrella

### Context

```yaml
playbook_invocation:
  skill_id: PB-implement  # INVALID
human_request: "Run Implementation"
```

### Expected behavior

```yaml
redirect_notice:
  error: umbrella_not_invokable
  message: PB-implement is documentation only
  action: Re-run lane routing; invoke PB-implement-backend or other lane child
never_invoke: PB-implement
```

---

## Quick comparison table

| Dimension | PB-implement-backend | PB-implement-frontend | PB-implement-mobile | PB-implement-devops |
|-----------|---------------------|----------------------|--------------------|--------------------|
| Phase | Implement | Implement | Implement | Implement |
| Upstream gate | H-DECOMPOSE + H-PLAN | H-DECOMPOSE + H-PLAN | H-DECOMPOSE + H-PLAN | H-DECOMPOSE |
| Key artifacts | ISS-*, API, DB | ISS-*, UIUX | ISS-*, UIUX (mobile) | ISS-* (infra tags) |
| Produces | CODE (server) | CODE (web) | CODE (mobile) | CODE (infra) |
| Child checklist | CL-IMPLEMENT | CL-IMPLEMENT | CL-IMPLEMENT | CL-IMPLEMENT |
| Human gate | H-IMPLEMENT | H-IMPLEMENT | H-IMPLEMENT | H-IMPLEMENT |