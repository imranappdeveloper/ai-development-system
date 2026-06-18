# PB-maintenance-triage — Edge Cases

| Field | Value |
|-------|-------|
| skill_id | PB-maintenance-triage |
| version | 1.0.0 |
| status | active |
| document | 07-edge-cases |

---

## P0 Edge Cases

| ID | Trigger | Expected behavior | Human? |
|----|---------|-------------------|--------|
| EC-ENT-01 | No approved INT | Block; recommend PB-intake-classify | N |
| EC-ENT-02 | MAINT already approved | Block unless `mode: revise` | Y |
| EC-ENT-03 | `work_type` ≠ maintenance and not post-release path | Block; recommend re-intake | N |
| EC-ENT-04 | Prerequisite intake gate not PASS | Block invoke per sequential promotion | N |
| EC-REL-01 | WF-RELEASE path, REL missing | Proceed with waiver note in §1; `triage_confidence: low` | Y |
| EC-REL-02 | REL semver mismatch with INT | Document in §1; flag for human | Y |
| EC-HEA-01 | No metrics available | Signals `yellow` + evidence gap in §2 | Y |
| EC-HEA-02 | Active P0 incident | `cycle_type: reactive`; P0 items in §3.2 | Y |
| EC-BAK-01 | >2 approved child items | CL-MAINT #8 fail; defer excess to §3.3 | N |
| EC-BAK-02 | Item needs unknown workflow | Route `WF-BUGFIX` default or escalate OUT-05 | Y |
| EC-SEC-01 | CVE with exploit in the wild | P0 in §3.2; route WF-SECURITY | Y |
| EC-VAL-01 | CL-MAINT fail | Recovery ≤3 → OUT-05 | Y |
| EC-HUM-01 | Vague revise notes | Request specificity; re-HAND | Y |
| EC-SCP-01 | Deploy command in MAINT §7 | CL-MAINT #7 fail; plan only | N |
| EC-SCP-02 | Agent self-approves H-OPERATE | CL-MAINT #10 fail | N |
| EC-SCP-03 | Agent spawns child ORS | Block; proposals in §7 only | N |
| EC-CTX-01 | CONTEXT.md missing | Skip §6 or note gap; not blocking | N |