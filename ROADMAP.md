# Roadmap

> **v1.1 is frozen (2026-06-19).** v1.0 playbook substrate frozen (2026-06-18). Active planning: [release/v1.0/ROADMAP-v2.md](./release/v1.0/ROADMAP-v2.md).

## v1.1 — Standalone Execution ✅ FROZEN

See [release/v1.1/PLATFORM-MANIFEST.md](./release/v1.1/PLATFORM-MANIFEST.md).

- [x] 19 bundled slash skills (`skills/MANIFEST.yaml`)
- [x] grok + agy symlinks via `install-cli.sh`
- [x] `/setup-ads` + `/setup-task-run` + server AFK stack
- [x] User flows (`USER-FLOW`, `AFK-TASK-RUN`, `STANDALONE`)
- [x] Done-at-PR-create policy
- [x] `verify-standalone.sh` gate
- [x] Release bundle (`release/v1.1/`)

## v1.0 — Foundation ✅ FROZEN

See [release/v1.0/PLATFORM-MANIFEST.md](./release/v1.0/PLATFORM-MANIFEST.md).

- [x] 32 active delivery playbooks
- [x] 14 workflows with normative specs
- [x] CI validation suite
- [x] Release bundle (`release/v1.0/`)

## Next: v1.2 — Execution Depth

See [release/v1.0/ROADMAP-v2.md](./release/v1.0/ROADMAP-v2.md) § v1.2 and [FUTURE-ENHANCEMENTS.md](./release/v1.0/FUTURE-ENHANCEMENTS.md).

- [ ] Runtime agent E2E harness
- [ ] `issue-processor` GitHub rewrite + `task-run` delegation fix
- [ ] `12-qa-scenarios.md` rollout (31 playbooks)
- [ ] Meta skills (`MS-*`) promotion
- [ ] AFK security hardening doc
- [ ] Poll restart on stuck `in-progress`