---
example_id: UMB-ROUTING-001
umbrella: PB-feature-planner
purpose: When to use PB-draft-feature vs PB-decompose-issues
status: golden
created: 2026-06-18
---

# Golden Example — Umbrella Routing Decisions

**Rule:** `PB-feature-planner` is consulted for resolution only — never invoked.

---

## Scenario A — Narrow enhancement (Plan → FEAT)

### Context

```yaml
work_id: WR-ENH-NOTIFY-001
workflow_id: WF-ENHANCEMENT
current_phase: Plan
artifacts:
  - DISC  # approved at H-FRAME
  - PRD   # absent
  - FEAT  # absent
human_request: "Plan the notification preference feature"
```

### Decision

| Question | Answer |
|----------|--------|
| Invoke PB-feature-planner? | **No** |
| Resolved routing ID | `PB-draft-feature` |
| Why not PB-draft-prd? | Single bounded slice; DISC sufficient |
| Why not PB-decompose-issues? | No approved PRD; Decompose is later phase |

### routing_resolution

```yaml
routing_resolution:
  umbrella_consulted: PB-feature-planner
  resolved_targets:
    - skill_id: PB-draft-feature
      phase: Plan
      rationale: Narrow enhancement with approved DISC; FEAT path
  never_invoke: PB-feature-planner
  routing_confidence: high
  blockers: []
```

### After H-PLAN

If FEAT describes **one** implementable unit → `PB-implement` (decompose waived).

If FEAT has **multiple** epics → `PB-decompose-issues` (requires PRD waiver or PRD supplement — see EC-RT-15).

---

## Scenario B — Full feature workflow (Plan → PRD → Decompose)

### Context

```yaml
work_id: WR-FEATURE-PROFILE-001
workflow_id: WF-FEATURE
current_phase: Decompose
artifacts:
  - DISC
  - PRD   # approved at H-PLAN
  - FEAT  # absent
human_request: "Break down the profile feature for implementation"
```

### Decision

| Question | Answer |
|----------|--------|
| Invoke PB-feature-planner? | **No** |
| Resolved routing ID | `PB-decompose-issues` |
| Why not PB-draft-feature? | Plan complete via PRD — not FEAT path |
| Why not PB-draft-prd? | PRD already approved |

### routing_resolution

```yaml
routing_resolution:
  umbrella_consulted: PB-feature-planner
  resolved_targets:
    - skill_id: PB-decompose-issues
      phase: Decompose
      rationale: H-PLAN approved PRD exists; ISS-* needed for implement
  never_invoke: PB-feature-planner
  routing_confidence: high
  blockers: []
```

---

## Scenario C — Wrong: invoke umbrella

### Context

```yaml
playbook_invocation:
  skill_id: PB-feature-planner  # INVALID
human_request: "Run Feature Planner"
```

### Expected behavior

```yaml
redirect_notice:
  error: umbrella_not_invokable
  message: PB-feature-planner is documentation only
  action: Re-run routing resolution; invoke PB-draft-feature or PB-decompose-issues
never_invoke: PB-feature-planner
```

---

## Quick comparison table

| Dimension | PB-draft-feature | PB-decompose-issues |
|-----------|------------------|---------------------|
| Phase | Plan | Decompose |
| Upstream gate | H-FRAME (DISC) | H-PLAN (PRD) |
| Produces | FEAT | ISS-* |
| Typical prior skill | PB-discovery-research | PB-draft-prd |
| Child checklist | CL-DRAFT | CL-DECOMP |
| Human gate | H-PLAN | H-DECOMPOSE |