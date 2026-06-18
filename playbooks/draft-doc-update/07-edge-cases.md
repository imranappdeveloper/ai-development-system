# PB-draft-doc-update — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-draft-doc-update |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | DOC-PLAN already H-PLAN approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type: feature` without docs path | Block; recommend PB-draft-prd | N |
| EC-ENT-04 | `workflow_id` ≠ WF-DOCS | Block; cite INT mismatch | N |
| EC-ENT-05 | INT not `documentation` and no quality-chain waiver | Block; document in handoff | Y |
| EC-ENT-06 | PB-perf-review handoff without INT | Block; INT required even for docs-only chain | N |
| EC-RES-01 | PERF-REVIEW contradicts INT doc scope | `quality_chain_alignment: partial`; flag in §8 | Y |
| EC-RES-02 | REVIEW findings exceed session budget | Prioritize P0 DU-* rows; defer rest to §8 | Y |
| EC-RES-03 | Referenced doc path missing on disk | §4 `drift_signal: red`; DU-* `create` | N |
| EC-RES-04 | Duplicate doc paths in INT and PERF-REVIEW | Merge into single DU-* row | N |
| EC-WF-01 | WF-DOCS terminal — no next skill | `recommended_next_skill: null` in handoff | N |
| EC-WF-02 | Release-bound docs with RELEASE artifact (soft) | Include RELEASE ref in §3; still WF-DOCS terminal | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from INT; note gap in §2 | N |
| EC-CTX-02 | CONTEXT > budget | Digest module map per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full DOC-PLAN in output + `persist: pending` | Y |
| EC-SCP-01 | Agent edits `docs/README.md` | CL-DOC-UPDATE #7 fail; STOP | N |
| EC-SCP-02 | Agent embeds full API doc content in §5 | CL-DOC-UPDATE #7 fail — plan intent only | N |
| EC-SCP-03 | Agent sets H-PLAN `decision: approve` | CL-DOC-UPDATE #10 fail | N |
| EC-SCP-04 | Agent patches application code | CL-DOC-UPDATE #7 fail | N |
| EC-INV-01 | §4 row without drift signal | CL-DOC-UPDATE #5 fail | N |
| EC-INV-02 | DU-* without acceptance signal | CL-DOC-UPDATE #6 fail | N |
| EC-SEC-01 | PII in stakeholder input | Redact `[REDACTED]` | N |
| EC-VAL-01 | CL-DOC-UPDATE fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague H-PLAN revise notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple doc surfaces in one INT | `doc_scope: mixed`; split DU-* by surface | Y |
| EC-PAR-01 | `docs_target_paths` partial scope | Document out-of-scope in §2.3 | Y |
| EC-OS-01 | `doc_scope: os_docs` without INT signal | Block or downgrade to `project_docs` | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing upstream link / INT | LOAD | 3 |
| Doc body edit attempted | PLAN | 3 — escalate if repeated |
| Missing DOC-PLAN persist | PERSIST | 3 |
| Inventory / DU-* incomplete | INV | 3 |
| Irrecoverable scope ambiguity | Escalate OUT-05 | — |