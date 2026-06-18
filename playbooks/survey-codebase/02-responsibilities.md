# PB-survey-codebase — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-survey-codebase |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Approved INT linked in WR, or waiver recorded |
| P2 | Load INT + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Set `survey_type` | Maps from INT `work_type` + invocation scope |
| P4 | Execute bounded scan | Paths within allowlist; manifest recorded in SURVEY §2 |
| P5 | Map structure & dependencies | Module map, stack, integrations with path citations |
| P6 | Surface risks & complexity | Test coverage signals, coupling, legacy markers |
| P7 | Produce SURVEY (OUT-01) | Complete per 04-io-contract |
| P8 | Update Work Record | Link SURVEY; status `survey_complete` |
| P9 | Run CL-SURVEY | Validation record = pass |
| P10 | Prepare advisory handoff | Recommend PB-discovery-research only; **no gate** |

### survey_type enum

| survey_type | From INT signal |
|-------------|-----------------|
| `feature_context` | `work_type: feature` |
| `existing_project` | `work_type: existing_project` |
| `enhancement` | `work_type: enhancement` |
| `exploratory` | Human-directed scope; INT `work_type` preserved in §6.2 |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write PRD | PB-draft-prd |
| N3 | Write architecture / API / database specs | PB-draft-architecture |
| N4 | Decompose issues | PB-decompose-issues |
| N5 | Write or modify application code | PB-implement |
| N6 | Fabricate or self-approve human gates | Human / orchestrator |
| N7 | Auto-invoke next playbook | Human or orchestrator after handoff |
| N8 | Update CONTEXT.md | PB-onboard-project / human-approved doc skills |
| N9 | Unbounded full-repo scan | Bounded per 05-context.md caps |
| N10 | Embed routing matrix in SURVEY | Orchestrator SSOT only |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store findings only in chat | Must persist SURVEY |
| N13 | Dump full source files into SURVEY | Markers, headers, excerpts ≤40 lines |
| N14 | Skip CL-SURVEY | Never |
| N15 | Copy secrets/PII into SURVEY | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Bounded scan & SURVEY draft | executes | may direct scope focus |
| Intake alignment assessment | proposes `alignment` field | decides on re-intake |
| Open gaps / unknowns | lists | prioritizes for discovery |
| Next playbook | recommends PB-discovery-research | approves invoke via orchestrator |
| Gate on SURVEY | **none** — agent must not add H-FRAME block | N/A |