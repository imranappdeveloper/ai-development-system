# PB-review — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-review |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No CODE linked in WR | Block; recommend PB-implement-* | N |
| EC-ENT-02 | REVIEW already H-VERIFY approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-IMPLEMENT not approved when CODE present | Block soft; document in handoff | Y |
| EC-ENT-04 | WR missing CODE artifact ref | Block; list missing IN-41 | N |
| EC-ENT-05 | PRD and ISS both absent | Proceed with `review_confidence: low` or block per human | Y |
| EC-ENT-06 | PB-test-plan gate not PASS | Block soft; cite prerequisite IN-33 | N |
| EC-ENT-07 | PB-test-generate not yet authored | Proceed with chain note; no invoke block at draft | N |
| EC-RES-01 | CODE §2 AC conflicts with ISS AC | Flag in §4; `review_confidence: low` | Y |
| EC-RES-02 | CODE partial_mismatch with PRD | `code_alignment: partial_mismatch`; open questions | Y |
| EC-RES-03 | P0 security finding in §5.1 | `recommendation: reject`; route PB-implement-* | Y |
| EC-WF-01 | `WF-BUGFIX` single ISS | Narrow scope; reproduction path in findings | N |
| EC-WF-02 | `WF-FEATURE` multiple ISS-* | Map each ISS AC in §4 | N |
| EC-WF-03 | `WF-SECURITY` | §3 STD-SEC-001 row mandatory | N |
| EC-WF-04 | `WF-DOCS` with review waiver | Document waiver; skip or minimal REVIEW | Y |
| EC-CTX-01 | CONTEXT.md missing | Proceed from CODE/ISS; note gap in §1.3 | N |
| EC-CTX-02 | CONTEXT > budget | Digest style rules per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full REVIEW in output + `persist: pending` | Y |
| EC-SCP-01 | Agent modifies source file | CL-REVIEW #9 fail; STOP | N |
| EC-SCP-02 | Agent runs `pytest` / `npm test` | CL-REVIEW #9 fail | N |
| EC-SCP-03 | Agent sets H-VERIFY `decision: approve` | CL-REVIEW #10 fail | N |
| EC-SCP-04 | Agent implements fix during review | CL-REVIEW #9 fail; redirect PB-implement-* | N |
| EC-MAP-01 | AC without §4 row | CL-REVIEW #2 fail | N |
| EC-MAP-02 | §4 row without evidence | CL-REVIEW #2 fail | N |
| EC-SEC-01 | Secrets in CODE or diff | Redact `[REDACTED]`; P0 blocker B-SEC | N |
| EC-VAL-01 | CL-REVIEW fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | Multiple CODE lanes (BE+FE) | Merge AC from all linked CODE paths | Y |
| EC-PAR-01 | Partial ISS scope | Review records completed ISS; deferred in §1.2 | Y |
| EC-DIFF-01 | No PR/diff ref available | `review_target` = CODE path; cite CODE §4 | N |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing AC assessment | EXTRACT | 3 |
| Code modification attempted | SCOPE | 3 — escalate if repeated |
| Standards §3 incomplete | STANDARDS | 3 |
| Missing REVIEW persist | PERSIST | 3 |
| Irrecoverable CODE/AC gap | Escalate OUT-05 | — |