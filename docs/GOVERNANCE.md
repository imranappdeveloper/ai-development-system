# Governance

| Field | Value |
|-------|-------|
| document_id | DOC-GOV-001 |
| version | 1.0.0 |
| status | active |
| updated | 2026-06-18 |

**Scope:** Runtime workflow gates, waivers, and skill promotion. Repository ownership, review, versioning, and release policy: [REPOSITORY-GOVERNANCE.md](./REPOSITORY-GOVERNANCE.md). Contributions: [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## 1. Advisory Enforcement

- Human gates (H-*) are **surfaced** by the orchestrator — not enforced via CI
- Agents self-check with CL-* checklists before handoff
- Humans record decisions via `record_gate` (or explicit approval in WR `approvals[]`)

---

## 2. Human Gates

Registry SSOT: `workflows/project-orchestrator/gates.yaml`

| gate_id | Phase boundary | Binds |
|---------|----------------|-------|
| H-INTAKE | Intake → Frame/Plan | INT |
| H-FRAME | Frame → Plan | DISC, ONBOARD |
| H-PLAN | Plan → Decompose/Implement | PRD, plan artifacts |
| H-DECOMPOSE | Decompose → Implement | Issue set |
| H-IMPLEMENT | Implement → Verify | CODE (advisory) |
| H-VERIFY | Verify → Ship | TEST-RPT, REVIEW |
| H-SHIP | Ship → Operate | REL |
| H-OPERATE | Operate closure | MAINT |
| H-META | Meta skill recommendations | Review reports (MS-*) |

### Gate decisions

| Decision | Effect |
|----------|--------|
| `approve` | Append `gate_history`; advance phase |
| `revise` | Re-invoke same playbook with notes |
| `reject` | Abort or hold |
| `waive` | Logged; advance per `waivable_gates` in `gates.yaml` |

---

## 3. Waive Policy (OD-05)

Per-workflow allowlists live in `gates.yaml` → `waivable_gates`. A waive MUST include `waiver_reason` in WR `approvals[]`.

---

## 4. Skill Promotion (draft → active)

Per `standards/SKILL-CONTRACT.md` §16:

- G-SKILL-01 through G-SKILL-08 must pass
- `10-review.md` score ≥ 70, no open P0
- `registry.yaml`, fixtures, golden examples required
- INDEX + routing-matrix row present

---

## 5. Foundation Freeze

Foundation v1 freezes when all P0 audit items are resolved and `FOUNDATION.md` records `status: frozen`.

Meta skills (`MS-*`) and delivery skills beyond intake/discovery remain `draft` or `planned` until their own promotion gates pass.

---

## 6. Open Design Decisions (resolved for v1)

| OD | Resolution |
|----|------------|
| OD-01 | Dual path: machine SSOT in `workflows/`; deployable spec in `playbooks/project-orchestrator/` |
| OD-02 | Spec-only coordinator (no executable service) |
| OD-03 | Human-triggered tick (`start` / `resume` / `tick` / `record_gate`) |
| OD-04 | `parent_run_id` max depth = 2 |
| OD-05 | Waive allowlist in `gates.yaml` |

---

## 7. Related documents

| Document | Path |
|----------|------|
| Repository governance | [REPOSITORY-GOVERNANCE.md](./REPOSITORY-GOVERNANCE.md) |
| Contributing | [CONTRIBUTING.md](./CONTRIBUTING.md) |
| Ownership registry | [OWNERSHIP.yaml](./OWNERSHIP.yaml) |
| SSOT hierarchy | [SSOT-HIERARCHY.md](./SSOT-HIERARCHY.md) |