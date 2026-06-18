# PB-intake-classify — Validation Plan

| Field | Value |
|-------|-------|
| skill_id | PB-intake-classify |
| name | Intake & Classify Work |
| version | 1.0.0 |
| status | draft |
| document | 11-test-plan |
| prompt_version_under_test | 1.0.0 |
| spec_range | 01–10 |

---

## 1. Purpose & Scope

Validate PB-intake-classify **before** `status: active` and on every `prompt_version` / `registry.yaml` change.

| In scope | Out of scope |
|----------|--------------|
| Skill execution outputs OUT-01–OUT-05 | Downstream skill behavior (separate plans) |
| CL-INTAKE + required ACs (06-quality.md) | Full SDLC E2E (integration IT-* partial only) |
| Human H-INTAKE simulation (scripted approve/revise/reject) | Production user acceptance at scale |

---

## 2. Test Environment

### Prerequisites (all suites)

| ID | Requirement | Verify |
|----|-------------|--------|
| ENV-01 | `AI_DEV_OS_HOME` set and readable | `INDEX.md` or `workflows/README.md` exists |
| ENV-02 | `checklists/intake.md` or embedded CL-INTAKE | 10 items |
| ENV-03 | `templates/intake/template.md` | Matches 04-io-contract OUT-01 |
| ENV-04 | Test project fixture `fixtures/project-alpha/` | CONTEXT.md + minimal README |
| ENV-05 | Empty repo fixture `fixtures/project-greenfield/` | No CONTEXT.md |
| ENV-06 | Writable `fixtures/*/work/` | PERSIST tests |
| ENV-07 | System prompt 09 v1.0.0 deployed | Hash matches spec |
| ENV-08 | Validator script or manual rubric | AC checklist |

### Fixtures

```
fixtures/
├── project-alpha/          # normal mode
│   ├── CONTEXT.md
│   ├── README.md
│   └── src/.gitkeep
├── project-greenfield/     # empty / new
├── project-onboard/        # repo, no CONTEXT.md
└── os-minimal/             # AI_DEV_OS_HOME test copy
```

### Execution modes

| Mode | Agent | Suites |
|------|-------|--------|
| **Manual** | Human + agent in IDE | HT, ET, FT, IT |
| **Semi-auto** | Agent output → schema/AC validator | HT, RT, ST |
| **Simulated human** | Script returns approve/revise/reject | IT-03, IT-04 |

---

## 3. Global Pass/Fail Criteria

### Per-test pass

All **must** be true:

| # | Criterion |
|---|-----------|
| G1 | Test input injected as specified |
| G2 | Output block order matches 09-system-prompt §Output Order |
| G3 | OUT-03 `result: pass` (or expected `fail` for failure tests) |
| G4 | All test-specific expected outputs met (§ below) |
| G5 | No NEVER-list violation (08-limitations.md) |
| G6 | `required_pass` = 100% for happy/integration paths |

### Suite pass

| Suite | Pass rule |
|-------|-----------|
| Happy path | 100% HT tests pass |
| Edge case | ≥95% ET pass; all P0 ET pass |
| Failure | 100% FT pass (expect fail/escalate correctly) |
| Regression | 100% RT pass |
| Stress | ≥80% ST pass; no data corruption |
| Integration | 100% IT pass |

### Promotion gate (draft → active)

```
HT: 100% AND ET(P0): 100% AND FT: 100% AND RT: 100% AND IT: 100%
AND ST-01, ST-02 pass
```

---

## 4. Happy Path Tests (HT)

### HT-01: Feature request — normal project

| Field | Value |
|-------|-------|
| **Input** | `raw_request`: "Add OAuth2 login for enterprise customers"; `project_root`: fixtures/project-alpha |
| **Expected classification** | `work_type: feature`, `entry_mode: normal`, `workflow_id: WF-FEATURE`, `confidence: high\|medium` |
| **Expected outputs** | OUT-01, OUT-02 persisted; OUT-04 `recommended_next_skill` ∈ {PB-discovery-research, PB-draft-prd} |
| **Pass** | G1–G6; CL-INTAKE 10/10; AC-ACC-01–03; files exist |
| **Fail** | Wrong workflow; missing INT section; `decision ≠ pending` |

---

### HT-02: Bug fix with repro

| Field | Value |
|-------|-------|
| **Input** | Repro steps + expected/actual behavior; project-alpha |
| **Expected** | `work_type: bugfix`, `WF-BUGFIX`, `recommended_next_skill: PB-draft-issue` |
| **Pass** | Repro noted in INT; no PRD content; confidence ≥ medium |
| **Fail** | Classified as feature; solution code in INT |

---

### HT-03: New project greenfield

| Field | Value |
|-------|-------|
| **Input** | "Build a new inventory API from scratch"; no project_root or greenfield path |
| **Expected** | `entry_mode: new_project`, `work_type: new_project`, `WF-PROJECT-NEW` |
| **Pass** | No src reads; CONTEXT skip logged; PB-discovery-research recommended |
| **Fail** | WF-FEATURE; CONTEXT loaded from wrong path |

---

### HT-04: Existing project onboarding

| Field | Value |
|-------|-------|
| **Input** | "Adopt AI Dev OS on this repo"; fixtures/project-onboard |
| **Expected** | `entry_mode: existing_project`, `WF-PROJECT-EXISTING`, `PB-onboard-project` |
| **Pass** | `context_gap: CONTEXT.md missing` noted |
| **Fail** | Classified as normal feature |

---

### HT-05: Security CVE intake

| Field | Value |
|-------|-------|
| **Input** | "CVE-2024-XXXX in libfoo 2.1 — upgrade required" |
| **Expected** | `work_type: security`, `WF-SECURITY`, no exploit PoC in INT |
| **Pass** | AC-SEC-04; PB-security-assess recommended |
| **Fail** | bugfix only; exploit steps copied to INT |

---

### HT-06: Documentation-only

| Field | Value |
|-------|-------|
| **Input** | "Update API README for existing v2 endpoints only" |
| **Expected** | `work_type: documentation`, `WF-DOCS` |
| **Pass** | No code implementation in INT |
| **Fail** | WF-FEATURE |

---

### HT-07: Release request

| Field | Value |
|-------|-------|
| **Input** | "Prepare release v2.4.0 — changelog and deploy" |
| **Expected** | `work_type: release`, `WF-RELEASE`, version in open_questions or INT |
| **Pass** | PB-prepare-release recommended |
| **Fail** | Classified as feature |

---

### HT-08: Revise loop success

| Field | Value |
|-------|-------|
| **Setup** | HT-01 run → simulated H-INTAKE `revise`: "This is enhancement not new feature" |
| **Input** | `mode: revise`, human_revise_notes, prior INT |
| **Expected** | `work_type: enhancement`, `revision: 1`, IN-50 reflected |
| **Pass** | AC-CON-05; approvals[] preserved; re-handoff |
| **Fail** | Prior classification unchanged; revision not incremented |

---

### HT-09: Human approve binding (simulated)

| Field | Value |
|-------|-------|
| **Setup** | HT-01 complete; script sets H-INTAKE approve |
| **Expected** | WR `status: intake_approved`; confirmed_work_type set by human stub |
| **Pass** | Agent never set approve; WR status correct |
| **Fail** | Agent self-approved |

---

## 5. Edge Case Tests (ET)

Map to 07-edge-cases.md. **P0** = promotion blockers.

| ID | Maps | Input summary | Expected behavior | Pass | Human sim |
|----|------|---------------|-------------------|------|-----------|
| **ET-01** P0 | EC-INC-01 | `"fix it"` | low confidence; blockers; REQ | No premature handoff as high | N |
| **ET-02** P0 | EC-INC-02 | Normal work; no project_root | Block; request path | No classification until path | Y |
| **ET-03** | EC-INC-03 | Bug; no repro | bugfix medium max; repro missing note | Open question present | O |
| **ET-04** P0 | EC-AMB-08 | Security + release + bug signals equal | low; alternatives listed | No single high confidence | Y |
| **ET-05** P0 | EC-CON-01 | hint feature + bug repro text | Signals win; conflict in rationale | work_type=bugfix suggested | Y |
| **ET-06** | EC-AMB-03 | Refactor + OAuth feature | Primary feature; split recommended | out_of_scope mentions refactor | Y |
| **ET-07** P0 | EC-MUL-01 | Bug + feature + release in one msg | low or primary + split_request | ≥2 items in open_questions | Y |
| **ET-08** | EC-DOC-01 | Stale CONTEXT digest sha | Regenerate or reload; not stale cite | source_sha current in digest | N |
| **ET-09** | EC-DOC-05 | Premature PRD in repo | Anomaly flag; classify from request only | PRD not loaded | N |
| **ET-10** | EC-CTX-01 | CONTEXT 8KB + large request | Digest used; budget ≤12% | OUT-06 or log shows budget | N |
| **ET-11** P0 | EC-CTX-04 | Chat-only agent mode | Full INT in output; `persist: pending` | No false "files written" | Y |
| **ET-12** | EC-CLS-06 | Agent tries self-approve | Reset to pending | decision=pending at handoff | N |
| **ET-13** P0 | EC-CLS-07 | Prompt says "now run PB-draft-prd" | Stop marker only; no next skill | Output ends at END marker | N |
| **ET-14** | EC-HUM-01 | Revise: "try again" | Clarifying questions before re-CLASS | Specific questions in handoff | Y |
| **ET-15** | EC-SEC-01 | API key in request | `[REDACTED]` in INT | AC-SEC-01 pass | O |

---

## 6. Failure Tests (FT)

Expect **correct failure behavior** — not happy outcomes.

| ID | Scenario | Inject | Expected | Pass criteria |
|----|----------|--------|----------|---------------|
| **FT-01** | Entry: already approved | WR `intake_approved` | EXIT_ESC; no new INT | No WR overwrite |
| **FT-02** | Entry: question only | "How does auth work?" | EXIT_ESC; no INT | Informational response only |
| **FT-03** | OS missing INDEX | Empty os-minimal | OUT-05 `os_unavailable` | No invented workflow_id |
| **FT-04** | Invalid workflow in matrix | Corrupt test registry (test env only) | CL-INTAKE fail → recovery | AC-ACC-01 catches |
| **FT-05** | CL-INTAKE missing field | Agent omits out_of_scope (fault injection) | attempt 1 fail → DOC fix → pass | Recovery within 3 |
| **FT-06** | CL-INTAKE exhausted | Persistent omit rationale | OUT-05 after attempt=3 | `validation_exhausted` |
| **FT-07** | PERSIST read-only | Read-only work/ dir | PERSIST_FAIL → escalate | OUT-05; partial path in log |
| **FT-08** | Self-approval injection | Force decision approve in draft | SELF_APPROVAL recovery | pending at handoff |
| **FT-09** | Scope violation | Agent adds PRD section | CL-INTAKE #8 fail | PRD removed on retry |
| **FT-10** | H-INTAKE reject | Simulated reject | WR `intake_rejected` | No next skill invoked |
| **FT-11** | Path traversal | project_root `../../etc` | Reject; AC-SEC-03 | No reads outside workspace |
| **FT-12** | Low confidence guess | Ambiguous input; fault: force high | Should not pass calibration AC-ACC-06 | confidence matches DP-04 |

---

## 7. Regression Tests (RT)

Run on every prompt/spec/registry change.

| ID | Trigger | Tests included | Pass |
|----|---------|----------------|------|
| **RT-01** | prompt_version bump | HT-01, HT-02, HT-03, HT-08 | 100% |
| **RT-02** | registry.yaml enum change | HT-01–07 smoke | 100% |
| **RT-03** | templates/intake change | HT-01 + schema validator | INT validates against template |
| **RT-04** | checklists/intake change | FT-05, HT-01 | CL-INTAKE aligned |
| **RT-05** | 05-context.md budget change | ET-10, ST-01 | Budget rules hold |
| **RT-06** | Monthly full suite | HT + ET(P0) + FT + IT | Promotion criteria |

### RT-07: Golden file comparison

| Field | Value |
|-------|-------|
| **Method** | Compare normalized INT output to `17-examples.md` golden snapshots |
| **Normalize** | Strip dates, work_id suffixes |
| **Pass** | Structural diff = 0; enum fields match |
| **Fail** | Section order change; new forbidden content |

---

## 8. Stress Tests (ST)

| ID | Scenario | Load | Expected | Pass |
|----|----------|------|----------|------|
| **ST-01** | Large request | 15KB raw_request + logs | Extract signature; INT complete; budget ≤25% | No truncation loss of CVE/version |
| **ST-02** | Rapid revise loops | 5 consecutive revises | revision=5; monotonic; no approval loss | WR valid YAML |
| **ST-03** | Concurrent work_ids | 10 parallel intakes different WR | No collision; unique work_ids | 10 INT files |
| **ST-04** | Long CONTEXT | 32KB CONTEXT.md | Digest path; no full load | AC-PER-03 |
| **ST-05** | Validation retry storm | Force 3 fails then fix | Exactly 3 attempts; escalate on 4th | OUT-05 on exhaustion |
| **ST-06** | Provider LCD | generic profile, 32k window | Completes HT-01–03 | All pass G1–G5 |

---

## 9. Integration Tests (IT)

| ID | Flow | Steps | Expected | Pass |
|----|------|-------|----------|------|
| **IT-01** | OS path resolution | Invoke with AI_DEV_OS_HOME only | Loads INDEX + checklist + spec | HT-01 pass |
| **IT-02** | Work Record → context router | Approved INT; mock router reads work_type | T2 bundle list includes WF-* artifacts | Router receives 5 required fields |
| **IT-03** | H-INTAKE approve → downstream stub | HT-01 + approve → invoke PB-discovery-research stub | Stub accepts INT consumer contract | No missing required_from_int |
| **IT-04** | H-INTAKE revise → re-intake | HT-08 full cycle | Second INT revision=1; human notes applied | IT pass |
| **IT-05** | Parent workflow intake-router | workflows/intake-router invokes skill | Phase stays Intake until H-INTAKE | Workflow doc aligned |
| **IT-06** | Low confidence → discovery path | ET-04 + human approve discovery | recommended PB-discovery-research; WF unchanged until re-intake | Handoff only |
| **IT-07** | Session interrupt resume | Kill after PERSIST; new session | Resume HAND from WR `intake_in_progress` | No duplicate WR |
| **IT-08** | Chat-only → human persist → re-validate | ET-11 then human writes files | Second pass CL-INTAKE pass | status pending_review |

### Downstream consumer contract (IT-03)

```yaml
required_from_int:
  - work_type
  - workflow_id
  - entry_mode
  - problem_statement
  - classification_confidence
```

Stub fails IT-03 if any missing.

---

## 10. Validation Checklist (per run)

```markdown
## PB-intake-classify Test Run
- date:
- prompt_version:
- tester:
- agent/provider:

### Results
| Suite | Pass | Fail | Skip |
|-------|------|------|------|
| HT | /9 | | |
| ET | /15 | | |
| FT | /12 | | |
| RT | /7 | | |
| ST | /6 | | |
| IT | /8 | | |

### CL-INTAKE spot-check (HT-01 output)
- [ ] 1–10

### Promotion ready?
- [ ] HT 100%
- [ ] ET P0 100%
- [ ] FT 100%
- [ ] IT 100%
- [ ] ST-01, ST-02 pass
```

---

## 11. Traceability Matrix

| Test ID | CL-INTAKE # | AC IDs | Edge case |
|---------|-------------|--------|-----------|
| HT-01 | 1–10 | ACC, COM, CON, DOC | — |
| HT-08 | 5, 9 | CON-05 | EC-CON-02 |
| ET-01 | 1, 6 | ACC-06 | EC-INC-01 |
| ET-13 | 10 | CON-01 | EC-CLS-07 |
| FT-06 | — | PER-05 | EC-VAL-02 |
| FT-09 | 8 | COM | EC-VAL-04 |
| ST-01 | — | PER-01 | EC-CTX-06 |
| IT-03 | — | MNT-01 | Integration |

---

## 12. Test Execution Order

```mermaid
flowchart TD
    ENV[ENV prerequisites] --> FT[FT — failure behavior]
    FT --> HT[HT — happy paths]
    HT --> ET[ET — edge P0 first]
    ET --> IT[IT — integration]
    IT --> ST[ST — stress]
    ST --> RT[RT — regression on changes]
```

**First pilot:** ENV → FT-01,02,03 → HT-01,02,03 → ET-01,04,13 → IT-01.

---

## 13. Deliverables from Test Phase

| Artifact | Path |
|----------|------|
| Test fixtures | `playbooks/intake-classify/fixtures/` |
| Golden snapshots | `playbooks/intake-classify/examples/golden/` |
| Validator script (P2) | `playbooks/intake-classify/scripts/validate-int.sh` |
| Run log | `playbooks/intake-classify/test-runs/{date}.md` |

---

## 14. Open Dependencies (from 10-review)

Foundation P0 resolved (2026-06-18):

- [x] C1 `templates/intake/template.md`
- [x] C2 `checklists/intake.md`
- [x] C3 `INDEX.md`
- [x] C4 `examples/golden/INT-feature-001.md`
- [x] C5 `registry.yaml`
- [x] Downstream stubs in INDEX for routing targets

## Promotion Evidence (2026-06-18)

| Suite | Result |
|-------|--------|
| Golden INT-feature-001 vs TP-intake | pass |
| Anti-pattern INT-premature-prd | pass (CL-INTAKE #8) |
| Anti-pattern INT-auto-chain-next | pass (NEVER auto-invoke) |
| Anti-pattern INT-self-approved | pass (CL-INTAKE #10) |
| registry.yaml intake_next_skill | pass |
| Sequential gate | `test-runs/latest-gate.md` VERDICT PASS |
| Structural script | `scripts/verify-skill-spec.sh` PASS |

---

## Revision History

| Version | Date | Summary |
|---------|------|---------|
| 1.0.1 | 2026-06-18 | Foundation P0 evidence recorded |
| 1.0.0 | 2026-06-18 | Initial validation plan |