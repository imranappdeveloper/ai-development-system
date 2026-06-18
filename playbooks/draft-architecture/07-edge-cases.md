# PB-draft-architecture — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-architecture |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved PRD | Block; recommend PB-draft-prd | N |
| EC-ENT-02 | ARCH already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | PRD `status: draft` only | Block; await H-PLAN on PRD or waiver | N |
| EC-ENT-04 | WR missing PRD artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | `work_type: bugfix` | Block; recommend PB-draft-issue | N |
| EC-RES-01 | PRD underspecified for design | `architecture_confidence: low`; list blockers in open questions | Y |
| EC-RES-02 | PRD conflicts with CONTEXT | Document in §9 Risks; `prd_alignment: partial_mismatch` | Y |
| EC-RES-03 | PRD requires tech PRD forbids | Flag `requires_prd_revise`; do not silently adopt | Y |
| EC-WF-01 | `WF-REFACTOR` path | `architecture_type: delta`; §8 Migration required | N |
| EC-WF-02 | `WF-PROJECT-NEW` path | `architecture_type: greenfield`; §8 N/A or minimal | N |
| EC-WF-03 | `WF-FEATURE` on existing codebase | `architecture_type: delta`; bounded component changes | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from PRD only; note gap in §2.1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest module map per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full ARCH in output + `persist: pending` | Y |
| EC-SCP-01 | Code snippets in ARCH | CL-ARCH #7 fail; remove — use component tables | N |
| EC-SCP-02 | PRD FR list copied into ARCH | CL-ARCH #7 fail; reference PRD path only | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-ARCH #10 fail | N |
| EC-LNK-01 | No PRD link in §1.3 | CL-ARCH #4 fail | N |
| EC-SEC-01 | PII/secrets in stakeholder input | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-ARCH fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-PLAN | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple unrelated systems in PRD | Flag; recommend split work_id or PRD revise | Y |
| EC-ADR-01 | Material decision without ADR ref | List in §7 with `ADR: TBD` and open question | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (code / PRD duplication) | DOC | 3 |
| Missing PRD link | DOC | 3 |
| Insufficient structural detail | MODEL | 3 |
| Irrecoverable PRD gap | Escalate OUT-05 | — |