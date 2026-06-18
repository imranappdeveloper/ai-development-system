# PB-security-assess — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-security-assess |
| version | 1.0.0 |
| status | active |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | INT linked in WR; H-INTAKE satisfied; PB-intake-classify upstream complete |
| P2 | Load upstream + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Build threat model from INT signals | Method documented; threats enumerated |
| P4 | Define assessment scope | In/out tables; `assess_scope` enum set |
| P5 | Draft security controls (SA-*) | Control IDs with testable requirements |
| P6 | Build risk register and remediation plan | Prioritized actions — no code patches |
| P7 | Persist OUT-01 artifact | `work/security/{work_id}.md` written or `persist: pending` |
| P8 | Update Work Record | Link SEC-ASSESS; status `security_assess_pending_review` |
| P9 | Run CL-SECURI | Validation record = pass |
| P10 | Recommend next skill (non-binding) | `PB-implement` or `PB-security-review` per routing |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Map threats to STRIDE (or documented method) | Default for WF-SECURITY |
| S2 | Flag confidence gaps | `assess_confidence: low` with blockers list |
| S3 | Document open questions for human | In artifact §Open Questions |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Suggest verification approach for controls | Human requests in revise notes |
| O2 | Note implement lane hint | For PB-implement routing only — not SSOT |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify INT body | PB-intake-classify |
| N3 | Write implementation code or patches | PB-implement-* |
| N4 | Review implemented CODE for defects | PB-security-review |
| N5 | Approve H-PLAN or advance workflow | Human |
| N6 | Auto-invoke next playbook | Human after gate |
| N7 | Update CONTEXT.md | PB-onboard-project / human |
| N8 | Run automated vuln scanners or pentests | Out of scope — cite in limitations |
| N9 | Modify OS repository files | OS maintainer |
| N10 | Store decisions only in chat | Must persist SEC-ASSESS |
| N11 | Self-approve artifact | Human at H-PLAN |
| N12 | Skip CL-SECURI | Never |
| N13 | Embed routing matrix in output | Orchestrator SSOT |
| N14 | Produce SEC-REVIEW at Verify path | PB-security-review |
| N15 | Copy secrets into artifact | Redact `[REDACTED]` per STD-SEC-001 |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| Draft SEC-ASSESS | Yes | Revise notes |
| H-PLAN decision | Never | approve / revise / reject |
| Override workflow_id | Never | Via revise on INT/WR |
| Accept residual risk | Never | Document in approvals |
| Persist artifact | Yes (or pending ack) | Confirms paths on approve |

---

## Required Dependencies

| Type | ID | Rule |
|------|-----|------|
| Skill | PB-intake-classify | Upstream producer; gate PASS prerequisite |
| Artifact | INT | `work/intake/{work_id}.md` approved |
| Gate | H-INTAKE | Blocks entry |
| Checklist | CL-SECURI | Blocks handoff on fail |
| Gate | H-PLAN | Human binding on approve |
| Standard | STD-SEC-001 | Redaction and forbidden paths |