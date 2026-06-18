# CL-SECURI — Security Assessment Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-SECURI |
| version | 1.0.0 |
| status | active |
| consumer | PB-security-assess |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-PLAN**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | H-INTAKE approved INT linked; `workflow_id: WF-SECURITY` or INT `work_type: security` |
| 2 | INT traceability | `upstream_int_path` set; Summary cites INT security signals |
| 3 | Threat model | Method documented (`threat_model_method` enum); ≥3 enumerated threats |
| 4 | Scope definition | In/out scope tables present; `assess_scope` enum valid |
| 5 | Security controls | ≥3 SA-* control IDs with testable requirements |
| 6 | Remediation plan | Prioritized actions (P0/P1/P2) — **no code patches, diffs, or deploy commands** |
| 7 | Risk register | ≥1 risk with `risk_severity` and mitigation |
| 8 | Artifact path | Output at `work/security/{work_id}.md` per ARTIFACT-REGISTRY |
| 9 | Work Record status | `security_assess_pending_review` before handoff; `artifacts[]` lists SEC-ASSESS path |
| 10 | Human approval | `gate_id: H-PLAN`, `decision: pending` only — agent never self-approves |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / routing embed / SEC-REVIEW confusion) | DOC | 3 |
| Missing INT link | LOAD | 3 |
| Insufficient threat model | MODEL | 3 |
| Empty risk register | DOC | 3 |
| Irrecoverable upstream gap | Escalate OUT-05 | — |