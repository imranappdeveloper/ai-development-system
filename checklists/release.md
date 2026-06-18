# CL-RELEASE — Release Preparation Self-Check

| Field | Value |
|-------|-------|
| checklist_id | CL-RELEASE |
| version | 1.0.0 |
| status | draft |
| consumer | PB-prepare-release |
| gate | Blocks handoff (OUT-04) when `result: fail` |

Agent must pass **all 10 items** before human handoff at **H-SHIP**.

---

## Checks

| # | Check | Pass criterion |
|---|-------|----------------|
| 1 | Entry criteria | CODE linked; Ship phase; `work_id` resolvable; quality chain noted or waived |
| 2 | TEST-RPT grounding | TEST-RPT path in frontmatter or WF-RELEASE waiver in §8.1 |
| 3 | CODE grounding | CODE path in `upstream_code_paths`; `code_alignment` block or mismatch documented |
| 4 | REL persisted | `{project_root}/work/release/{work_id}.md` written (or `persist: pending` with human ack) |
| 5 | Release scope | §2.1 Included Work ≥1 row grounded in WR `artifacts[]` |
| 6 | Version & changelog | §3 semver + bump_rationale; §4 at least one subsection non-empty |
| 7 | Deployment plan | §7.2 steps and §7.3 rollback documented — plan only, no live commands |
| 8 | Pre-release verification | §8.1 all standard rows evaluated with TEST-RPT evidence or waiver |
| 9 | WR updated | REL artifact linked; `status: release_pending` |
| 10 | Human gate & handoff | `gate_id: H-SHIP`, `decision: pending`; no deploy commands; recommend PB-maintenance-triage post H-SHIP |

---

## Recovery

| Fail category | Return step | Max attempts |
|---------------|-------------|--------------|
| Missing scope rows | SCOPE | 3 |
| Deploy command attempted | DEPLOY | 3 — escalate if repeated |
| §8 verification incomplete | VERIFY | 3 |
| Missing REL persist | PERSIST | 3 |
| Irrecoverable CODE/TEST-RPT gap | Escalate OUT-05 | — |