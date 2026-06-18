# PB-draft-issue — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-draft-issue |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | Upstream artifacts linked in WR; required gates satisfied |
| P2 | Load upstream + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map repro + root cause to testable fix ACs; set `issue_lane` | Enums set per registry.yaml |
| P4 | Draft ISS body per 04-io-contract | All required sections present |
| P5 | Trace upstream references | INT/PRD/DIAG paths in References block |
| P6 | Persist OUT-01 artifact | `work/issue/{work_id}.md` written or `persist: pending` |
| P7 | Update Work Record | Link ISS; status `plan_pending_review` |
| P8 | Run CL-ISSUE | Validation record = pass |
| P9 | Prepare handoff for H-PLAN | `decision: pending` only |
| P10 | Recommend next skill (non-binding) | `PB-implement` when criteria met |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Cross-reference soft upstream artifacts | When linked in WR |
| S2 | Flag confidence gaps | `iss_confidence: low` with blockers list |
| S3 | Document open questions for human | In artifact §Open Questions |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Suggest verification approach | Human requests in revise notes |
| O2 | Note downstream lane hint | For implement routing only — not SSOT |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify upstream artifact bodies | Upstream producer skills |
| N3 | Write implementation code | PB-implement-* |
| N4 | Approve H-PLAN or advance workflow | Human |
| N5 | Auto-invoke next playbook | Human after gate |
| N6 | Update CONTEXT.md | PB-onboard-project / human |
| N7 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N8 | Modify OS repository files | OS maintainer |
| N9 | Store decisions only in chat | Must persist ISS |
| N10 | Self-approve artifact | Human at H-PLAN |
| N11 | Skip CL-ISSUE | Never |
| N12 | Embed routing matrix in output | Orchestrator SSOT |
| N13 | Run verify or test suites | PB-verify |
| N14 | Decompose multi-issue sets | PB-decompose-issues |
| N15 | Copy secrets into artifact | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Draft ISS | Yes | Revise notes |
| H-PLAN decision | Never | approve / revise / reject |
| Override workflow_id | Never | Via revise on INT/WR |
| Persist artifact | Yes (or pending ack) | Confirms paths on approve |

---

## Required Dependencies

| Type | ID | Rule |
|------|-----|------|
| Skill | PB-intake-classify | Upstream producer |
| Artifact | ISS path | OUT-01 destination |
| Checklist | CL-ISSUE | Blocks handoff on fail |
| Gate | H-PLAN | Human binding on approve |
