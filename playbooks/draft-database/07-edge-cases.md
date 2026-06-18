# PB-draft-database — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-database |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved ARCH | Block; recommend PB-draft-architecture | N |
| EC-ENT-02 | DB already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | ARCH `status: draft` only | Block; await H-PLAN on ARCH or waiver | N |
| EC-ENT-04 | WR missing ARCH artifact ref | Block; list missing IN-10 | N |
| EC-ENT-05 | PRD missing and no waiver | Proceed with `prd_gap: missing`; flag in §2.1 | Y |
| EC-RES-01 | ARCH underspecified for schema | `database_confidence: low`; list blockers in open questions | Y |
| EC-RES-02 | ARCH conflicts with existing schema markers | Document in §10; `arch_alignment: partial_mismatch` | Y |
| EC-RES-03 | PRD entity not in ARCH data flows | Flag `prd_alignment: partial_mismatch`; do not invent scope | Y |
| EC-WF-01 | `WF-REFACTOR` path | `change_type: migration`; §5 required | N |
| EC-WF-02 | `WF-FEATURE` additive schema | `change_type: new_schema`; §5 minimal | N |
| EC-WF-03 | `WF-PERF` index work | `change_type: optimization`; §8 hot paths required | N |
| EC-WF-04 | `WF-SECURITY` column encryption | `change_type: migration`; §7 PII mapping required | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from ARCH only; note gap in §1.2 | N |
| EC-CTX-02 | CONTEXT > budget | Digest datastore info per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full DB in output + `persist: pending` | Y |
| EC-SCP-01 | DDL/SQL scripts in DB | CL-DATABASE #7 fail; use table attribute tables | N |
| EC-SCP-02 | ARCH component list copied into DB | CL-DATABASE #7 fail; reference ARCH path only | N |
| EC-SCP-03 | Agent sets `decision: approve` | CL-DATABASE #10 fail | N |
| EC-LNK-01 | No ARCH link in §1.3 | CL-DATABASE #4 fail | N |
| EC-SEC-01 | PII sample values in input | Redact `[REDACTED]` in attribute notes | N |
| EC-VAL-01 | CL-DATABASE fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes at H-PLAN | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple unrelated schemas in ARCH | Flag; recommend split work_id or ARCH revise | Y |
| EC-MIG-01 | Non-reversible migration requested | Document risk; require human ack in open questions | Y |
| EC-MIG-02 | Zero-downtime migration required | §5 downtime column + rollback plan explicit | Y |
| EC-PERF-01 | WF-PERF without baseline | List assumptions in §8; `database_confidence: medium` | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing section / field | DOC | 3 |
| Scope violation (DDL / ARCH duplication) | DOC | 3 |
| Missing ARCH link | DOC | 3 |
| Insufficient logical/physical model | MODEL | 3 |
| Incomplete migration plan | MIGRATE | 3 |
| Irrecoverable ARCH/PRD gap | Escalate OUT-05 | — |