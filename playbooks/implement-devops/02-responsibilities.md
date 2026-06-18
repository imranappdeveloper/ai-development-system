# PB-implement-devops — Responsibilities

| Field | Value |
|-------|-------|
| skill_id | PB-implement-devops |
| version | 1.0.0 |
| status | draft |
| document | 02-responsibilities |

---

## Primary Responsibilities (P1–P10)

| # | Responsibility | Done when |
|---|----------------|-----------|
| P1 | Verify entry criteria | ISS/ISS-* linked; H-DECOMPOSE or H-PLAN soft satisfied |
| P2 | Load ISS + ARCH + REL + CONTEXT slice | T1/T2 bundles per 05-context.md |
| P3 | Map issues to implementation tasks | §3 Implementation Log lists ISS IDs |
| P4 | Write DevOps code per issues | CI workflows, IaC, deploy configs in repository |
| P5 | Document files changed | §4 Files Changed with paths and summaries |
| P6 | Document pipeline validation | §6 Validation Notes — lint/plan/dry-run; never empty |
| P7 | Produce CODE (OUT-01) | Complete per 04-io-contract at lane path |
| P8 | Update Work Record | Link CODE; `implement_devops_pending_review` |
| P9 | Run CL-IMPLEMENT-DEVOPS | Validation record = pass |
| P10 | Prepare handoff for H-IMPLEMENT | `decision: pending`; recommend PB-verify or PB-prepare-release |

### implement_scope enum

| implement_scope | From signal |
|-----------------|-------------|
| `ci_pipeline` | ISS tags ci, workflow, github-actions, gitlab-ci |
| `infra_as_code` | ISS tags terraform, pulumi, cloudformation, k8s manifests |
| `deploy_pipeline` | ISS tags deploy, staging, release-automation |
| `mixed_devops` | Multiple DevOps concern types in one run |

---

## Secondary Responsibilities (S1–S3)

| # | Responsibility | When |
|---|----------------|------|
| S1 | Generate plan-only evidence for IaC | `terraform plan`, `pulumi preview` — never prod apply |
| S2 | Flag ARCH/REL gaps blocking implementation | `implement_confidence: low` |
| S3 | Note rollback considerations | IaC or pipeline changes with blast radius |

---

## Optional Responsibilities (O1–O2)

| # | Responsibility | When |
|---|----------------|------|
| O1 | Cross-reference existing pipeline/IaC markers | Bounded reads per 05-context.md |
| O2 | Suggest splitting work_id | ISS scope exceeds session budget |

---

## Non-Responsibilities (N1–N15)

| # | Forbidden | Owner |
|---|-----------|-------|
| N1 | Assign or change `work_type` / `workflow_id` | PB-intake-classify |
| N2 | Write or modify PRD | PB-draft-prd |
| N3 | Write or modify ARCH design | PB-draft-architecture |
| N4 | Redesign system topology or service boundaries | PB-draft-architecture |
| N5 | Implement backend, frontend, or mobile application code | Lane children |
| N6 | Approve H-IMPLEMENT or advance workflow | Human |
| N7 | Auto-invoke next playbook | Human after H-IMPLEMENT |
| N8 | Deploy to production or apply prod infra | Human / PB-prepare-release post H-VERIFY |
| N9 | Deep unrestricted codebase audit | Bounded per 05-context.md |
| N10 | Decompose or create ISS artifacts | PB-decompose-issues / PB-draft-issue |
| N11 | Modify OS repository files | OS maintainer |
| N12 | Store decisions only in chat | Must persist CODE |
| N13 | Self-approve implementation | Human at H-IMPLEMENT |
| N14 | Skip CL-IMPLEMENT-DEVOPS or validation documentation | Never |
| N15 | Copy secrets into CODE record | Redact `[REDACTED]` |

---

## Human vs Agent

| Task | Agent | Human |
|------|-------|-------|
| DevOps code & CODE draft | proposes | approves / revises / rejects at H-IMPLEMENT |
| ARCH/REL alignment assessment | proposes alignment blocks | decides on upstream revise vs proceed |
| Pipeline validation adequacy | documents what was run/planned | decides sufficient for PB-verify |
| Production deployment | **never** | release process after verify gates |
| Next playbook | recommends PB-verify or PB-prepare-release | approves after H-IMPLEMENT |

---

## Required Dependencies

| Dependency | Type | Gate / artifact |
|------------|------|-----------------|
| PB-decompose-issues | skill (soft) | ISS-* for WF-FEATURE |
| PB-draft-issue | skill (soft) | ISS for WF-BUGFIX |
| ISS / ISS-* | artifact | H-DECOMPOSE or H-PLAN |
| ARCH | artifact (soft) | Topology and deploy boundary grounding |
| REL | artifact (soft) | Release context when WF-RELEASE scope |
| CL-IMPLEMENT-DEVOPS | checklist | Handoff blocker |
| STD-SEC-001 | standard | Secrets handling in CI |
| STD-TEST-001 | standard | Validation documentation |
| STD-OPS-001 | standard | Observability hooks in pipelines |