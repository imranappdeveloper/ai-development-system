# CL-ONBOAR — Onboarding Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-ONBOAR |
| version | 1.0.0 |
| status | active |
| consumer | PB-onboard-project |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-FRAME**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT, or documented human waiver; CONTEXT.md readable at `{project_root}/CONTEXT.md` |
| 2 | `onboarding_type` valid | `existing_project` only |
| 3 | `workflow_id` in INDEX | `WF-PROJECT-EXISTING` matches INT unless human revise notes override |
| 4 | CONTEXT.md grounding | `context_md_path` in frontmatter; §3 cites CONTEXT sections with evidence |
| 5 | Module map | §4 present with ≥3 modules or documented exception |
| 6 | Required ONBOARD sections | Summary, Snapshot, CONTEXT Assessment, Module Map, OS Adoption Checklist, Gap Analysis, §6.2, Open Questions, Human Approval |
| 7 | No forbidden content | No PRD, architecture spec, code, or CONTEXT.md writes — proposals only in §3 |
| 8 | Intake alignment | §6.2 uses `intake_classification_alignment` — no new `work_type` assignment |
| 9 | Work Record status | `onboard_pending_review` before handoff; ONBOARD path in `artifacts[]` |
| 10 | Human approval | `gate_id: H-FRAME`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| CONTEXT not cited | ASSESS | 3 |
| Scope violation (forbidden writes) | DOC | 3 |
| Missing module map | MAP | 3 |
| Irrecoverable (no CONTEXT.md) | Escalate OUT-05 | — |