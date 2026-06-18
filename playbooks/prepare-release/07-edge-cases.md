# PB-prepare-release — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-prepare-release |
| version | 1.0.0 |
| status | draft |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No CODE linked in WR | Block; recommend PB-implement-* | N |
| EC-ENT-02 | REL already H-SHIP approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | H-VERIFY not approved on WF-FEATURE | Block soft; document in handoff | Y |
| EC-ENT-04 | WR missing CODE artifact ref | Block; list missing IN-41 | N |
| EC-ENT-05 | TEST-RPT absent on WF-FEATURE | Block soft; recommend PB-verify | N |
| EC-ENT-06 | WF-RELEASE without TEST-RPT | Proceed with IN-51 waiver in §8.1 | N |
| EC-ENT-07 | WF-RELEASE without H-VERIFY | Proceed per gates.yaml waiver | N |
| EC-ENT-08 | PB-verify not yet active | Proceed with chain note; document gap | N |
| EC-RES-01 | CODE §2 AC conflicts with changelog | Flag in §11; `release_confidence: low` | Y |
| EC-RES-02 | TEST-RPT fail rows in §8.1 | §11 blocker; `recommendation: revise` in handoff | Y |
| EC-RES-03 | P0 SEC-REVIEW finding open | §11 blocker row; blocks H-SHIP approve | Y |
| EC-WF-01 | `WF-RELEASE` version-only ship | Minimal §2.1; semver from INT | N |
| EC-WF-02 | `WF-FEATURE` multi-lane CODE | §2.1 row per lane; merged changelog | N |
| EC-WF-03 | `WF-BUGFIX` hotfix | `release_type: hotfix`; narrow §2.1 | N |
| EC-WF-04 | Optional skill skipped (`no_release`) | Not invoked — out of scope | N |
| EC-CTX-01 | CONTEXT.md missing | Proceed from WR; note gap in §1 | N |
| EC-CTX-02 | CONTEXT > budget | Digest deploy policy per 05-context.md | N |
| EC-CTX-03 | Chat-only agent | Full REL in output + `persist: pending` | Y |
| EC-SCP-01 | Agent runs deploy command | CL-RELEASE #10 fail; STOP | N |
| EC-SCP-02 | Agent sets H-SHIP `decision: approve` | CL-RELEASE #10 fail | N |
| EC-SCP-03 | Agent modifies source file | CL-RELEASE #9 fail; STOP | N |
| EC-SCP-04 | Agent includes live credentials in REL | Redact; CL fail if leaked | N |
| EC-MAP-01 | §2.1 row without WR artifact | CL-RELEASE #5 fail | N |
| EC-MAP-02 | §8.1 row without evidence | CL-RELEASE #8 fail | N |
| EC-SEC-01 | Secrets in CODE or TEST-RPT | Redact `[REDACTED]`; no copy to REL | N |
| EC-VAL-01 | CL-RELEASE fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-MUL-01 | `included_work_ids` multi-WR bundle | §2.1 lists each work_id | Y |
| EC-VER-01 | TEST-RPT `test_phase: plan` only | Block soft; PB-verify required | N |
| EC-DEP-01 | No deploy target in CONTEXT | Use IN-54 hint or §11 open item | Y |

---

## Recovery Matrix

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing scope rows | SCOPE | 3 |
| Deploy command attempted | DEPLOY | 3 — escalate if repeated |
| §8 verification incomplete | VERIFY | 3 |
| Missing REL persist | PERSIST | 3 |
| Irrecoverable CODE/TEST-RPT gap | Escalate OUT-05 | — |