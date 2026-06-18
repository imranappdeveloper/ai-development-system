# CL-SURVEY — Survey Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-SURVEY |
| version | 1.0.0 |
| status | active |
| consumer | PB-survey-codebase |
| gate | Blocks advisory handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before advisory handoff. **No human gate** on SURVEY (`exit_gate: none`).

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved on linked INT, or documented human waiver; INT path in Work Record; prerequisite intake/onboard gate PASS |
| 2 | `survey_type` valid | One of: `feature_context`, `existing_project`, `enhancement`, `exploratory` |
| 3 | `workflow_id` in INDEX | Matches INT `workflow_id` unless refresh override documented |
| 4 | Bounded scan manifest | §2 lists paths ⊆ `05-context.md` allowlist; `files_touched` ≤ 40; T3 line cap respected |
| 5 | Evidence citations | Every module/stack/dependency claim cites path + reference (line range or symbol) |
| 6 | Required SURVEY sections | Summary, Scope & Manifest, Structure, Module Map, Stack, Dependencies, Patterns, Risks, Gaps, §6.2, Advisory Handoff |
| 7 | No forbidden content | No PRD, architecture spec, issue breakdown, code dumps (>40 lines), or secrets |
| 8 | Intake alignment | §6.2 uses `intake_classification_alignment` — no new `work_type` assignment |
| 9 | Work Record status | `survey_complete` before handoff; SURVEY path in `artifacts[]` |
| 10 | No gate / routing SSOT violation | No `gate_id`, no `decision: approve`, no routing-matrix excerpts; `exit_gate: none` honored |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (forbidden docs) | DOC | 3 |
| Unbounded scan / allowlist breach | PLAN | 3 |
| Missing evidence | SCAN | 3 |
| Gate fabrication | DOC | 3 |
| Irrecoverable (no project_root) | Escalate OUT-05 | — |