# CL-META-ARCH — Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-META-ARCH |
| version | 1.0.0 |
| status | planned |
| consumer | MS-architecture-review |
| gate | H-META |

**Invoke block:** Skill `status: planned` — orchestrator MUST block invoke (ORCH-S7).


## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Skill status | `active` required for default invoke; `planned`/`draft` scaffold blocks per ORCH-S7 |
| 2 | Entry artifacts | All `routing.requires_artifacts` present or WR `persist: pending` documented |
| 3 | Output contract | Handoff matches `04-io-contract.md` when spec authored |
| 4 | No SSOT violation | No routing matrix embedded in playbook output |
| 5 | Human gate | Exit gate recorded in WR `approvals[]` before downstream invoke |
