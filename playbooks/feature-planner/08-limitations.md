# PB-feature-planner — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-feature-planner |
| name | Feature Planner (umbrella) |
| version | 1.0.0 |
| status | active |
| document | 08-limitations |
| type | umbrella |

---

## Cannot Reliably Do

| Limitation | Reason |
|------------|--------|
| Execute feature planning work | No execution contract — documentation only |
| Produce FEAT, PRD, or ISS-* | Child playbooks own artifacts |
| Pass or bind human gates | `exit_gate: none` |
| Appear in orchestrator routing as invokable | STD-NAMING-001 + routing-matrix exclusion |
| Replace child 09-system-prompts | Children are deployable targets |
| Auto-determine PRD vs FEAT with 100% accuracy | Requires human judgment at H-PLAN for edge cases |
| Enforce CL-FEAT-PLAN as blocking | Advisory checklist by design (W-UMB-02) |

---

## Human Required

| Situation | Why |
|-----------|-----|
| H-PLAN approval | All Plan artifacts — umbrella cannot approve |
| H-DECOMPOSE approval | Issue breakdown — umbrella cannot approve |
| PRD vs FEAT path when confidence medium/low | Business scope judgment |
| Waiver for skip-decompose on large PRD | Risk acceptance |
| Architect approval for routing-matrix changes | EC-RT-02 prevention |

---

## AI / Agent Limits

| Limit | Mitigation |
|-------|------------|
| May hallucinate PB-feature-planner as valid skill_id | 09-system-prompt NEVER list; EC-RT-05 |
| May merge decompose into plan doc | Anti-pattern FP-merge-decompose-into-prd |
| May skip PRD before decompose | Anti-pattern FP-skip-prd |
| Cannot promote children by umbrella active status | README build order explicit |
| Routing confidence without artifacts | List blockers; do not invoke child |

---

## Honest Scope Boundary

```text
PB-feature-planner = map + guide + build-order documentation
PB-draft-feature   = do Plan work (FEAT)
PB-decompose-issues = do Decompose work (ISS-*)
```

If an agent is **doing** planning work, it is running a **child** — not the umbrella.