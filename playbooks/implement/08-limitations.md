# PB-implement — Limitations

| Field | Value |
|-------|-------|
| skill_id | PB-implement |
| name | Implementation (umbrella) |
| version | 1.0.0 |
| status | draft |
| document | 08-limitations |
| type | umbrella |

---

## Cannot Reliably Do

| Limitation | Reason |
|------------|--------|
| Execute implementation work | No execution contract — documentation only |
| Produce CODE artifacts | Lane child playbooks own output |
| Pass or bind human gates | `exit_gate: none` |
| Appear in orchestrator routing as invokable umbrella | STD-NAMING-001 + routing exclusion |
| Replace child 09-system-prompts | Children are deployable targets |
| Auto-determine lane with 100% accuracy on ambiguous ISS | Requires human judgment at H-IMPLEMENT for edge cases |
| Enforce CL-IMPLEMENT-UMBRELLA as blocking | Advisory checklist by design (W-UMB-02) |
| Invoke lane children (folders not yet authored) | Children `planned` — routing docs only |

---

## Human Required

| Situation | Why |
|-----------|-----|
| H-DECOMPOSE approval | ISS-* breakdown — umbrella cannot approve |
| H-IMPLEMENT approval per lane | CODE quality — umbrella cannot approve |
| Lane choice when confidence medium/low | Technology and scope judgment |
| Waiver for skip-decompose or missing plan artifact | Risk acceptance |
| Architect approval for routing-matrix migration | EC-RT-02 prevention |
| Multi-lane parallel scheduling | Resource and merge coordination |

---

## AI / Agent Limits

| Limit | Mitigation |
|-------|------------|
| May hallucinate PB-implement as valid skill_id | 09-system-prompt NEVER list; EC-RT-05 |
| May route UI work to backend lane | Anti-pattern IMP-wrong-lane |
| May skip ISS entry | Anti-pattern IMP-skip-issues |
| Cannot promote children by umbrella draft status | README build order explicit |
| Routing confidence without ISS inventory | List blockers; do not invoke child |
| May collapse multi-lane into single invoke | DM-05 + EC-RT-09 |

---

## Honest Scope Boundary

```text
PB-implement           = map + guide + build-order documentation
PB-implement-backend   = do server/API/DB implementation (CODE)
PB-implement-frontend  = do web UI implementation (CODE)
PB-implement-mobile    = do mobile implementation (CODE)
PB-implement-devops    = do CI/CD / infra implementation (CODE)
```

If an agent is **writing code**, it is running a **lane child** — not the umbrella.