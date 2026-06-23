#!/usr/bin/env python3
"""grill-intake.py — structured grill intake before mandatory AI explore pass."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

REQUIRED_TOP = ("feature", "problem_statement", "journeys")
REQUIRED_JOURNEY = ("name", "your_request", "agreed_change", "files_components")


def _utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def load_intake(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as f:
        return json.load(f)


def lint_intake(data: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    for key in REQUIRED_TOP:
        if key not in data or not data[key]:
            errors.append(f"missing:{key}")

    journeys = data.get("journeys") or []
    if not isinstance(journeys, list) or len(journeys) < 1:
        errors.append("journeys:need-at-least-one")
    else:
        for i, j in enumerate(journeys):
            if not isinstance(j, dict):
                errors.append(f"journey[{i}]:not-object")
                continue
            for k in REQUIRED_JOURNEY:
                if not str(j.get(k, "")).strip():
                    errors.append(f"journey[{i}]:missing:{k}")
            if j.get("confirmed_forks") in (None, ""):
                errors.append(f"journey[{i}]:missing:confirmed_forks")

    oq = data.get("open_questions") or []
    if oq:
        for i, q in enumerate(oq):
            if not str(q).strip():
                errors.append(f"open_questions[{i}]:empty")
            elif str(q).upper().startswith("BLOCKING"):
                errors.append(f"open_questions[{i}]:blocking-unresolved")

    if data.get("status") == "approved":
        errors.append("forbidden:status-approved-before-ai-pass")

    return errors


def seed_lock(data: dict[str, Any], template_path: Path, out_path: Path) -> None:
    feature = data.get("feature", "feature")
    doc_id = data.get("document_id") or "REQ-LOCK-001"
    body = template_path.read_text(encoding="utf-8")
    body = body.replace("<feature name>", feature)
    body = body.replace("REQ-LOCK-<NNN>", doc_id)
    body = body.replace("<short name>", feature)
    body = body.replace("status | draft | approved", "status | draft")
    body = body.replace("<ISO-8601 UTC when user confirms>", "")
    body = body.replace("<date or WR reference>", data.get("grill_session", _utc_now()[:10]))

    problem = data.get("problem_statement", "").strip()
    body = re.sub(
        r"<2–4 sentences — precise, not vague>",
        problem or "_Draft from grill intake — AI must refine after explore pass._",
        body,
        count=1,
    )

    oos = data.get("out_of_scope") or []
    if oos:
        oos_block = "\n".join(f"- {item}" for item in oos)
    else:
        oos_block = "- _TBD during AI grill pass_"
    body = re.sub(r"- <bullet>\n- <bullet>", oos_block, body, count=1)

    testing = data.get("testing_approach") or {}
    seams = testing.get("seams", "_TBD_")
    prior = testing.get("prior_art", "_TBD_")
    body = re.sub(r"<where to test>", str(seams), body, count=1)
    body = re.sub(r"<similar tests in repo, if any>", str(prior), body, count=1)

    journey_blocks: list[str] = []
    for j in data.get("journeys") or []:
        name = j.get("name", "Journey")
        forks = j.get("confirmed_forks") or "none"
        block = f"""### {name}

| Field | Content |
|-------|---------|
| **Current behavior** | {j.get('current_behavior', '_AI explore pass required_')} |
| **Your request** | {j.get('your_request', '')} |
| **Agreed change** | {j.get('agreed_change', '')} |
| **Files / components** | {j.get('files_components', '')} |
| **Confirmed forks** | {forks} |
"""
        journey_blocks.append(block)

    marker = "Repeat one block per screen or journey slice."
    if marker in body:
        parts = body.split(marker, 1)
        tail = parts[1]
        if "---" in tail:
            _, rest = tail.split("---", 1)
            body = parts[0] + marker + "\n\n" + "\n".join(journey_blocks) + "\n---" + rest
        else:
            body = parts[0] + marker + "\n\n" + "\n".join(journey_blocks)

    ctx = data.get("context_updates") or "none"
    body = re.sub(r"<List terms/decisions written to CONTEXT.md during grill, or `none`>", str(ctx), body)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(body, encoding="utf-8")


def cmd_lint(args: argparse.Namespace) -> int:
    path = Path(args.file)
    if not path.is_file():
        print(f"ERROR: intake file not found: {path}", file=sys.stderr)
        return 2
    errors = lint_intake(load_intake(path))
    if errors:
        print("NEEDS_INTAKE")
        for e in errors:
            print(f"  - {e}")
        return 1
    print("INTAKE_READY")
    print("next: mandatory AI explore pass per grill-for-planning (never approve from script alone)")
    return 0


def cmd_seed_lock(args: argparse.Namespace) -> int:
    root = Path(args.project).resolve()
    intake_path = Path(args.file) if args.file else root / "work" / "grill-intake.json"
    if not intake_path.is_file():
        print(f"ERROR: intake file not found: {intake_path}", file=sys.stderr)
        return 2
    data = load_intake(intake_path)
    errors = lint_intake(data)
    if errors and not args.force:
        print("NEEDS_INTAKE — fix before seeding lock doc", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        return 1
    template = Path(args.template) if args.template else root / "templates" / "requirement-lock" / "template.md"
    if not template.is_file():
        os_home = Path(args.os_home) if args.os_home else Path(__file__).resolve().parent.parent
        template = os_home / "templates" / "requirement-lock" / "template.md"
    out = Path(args.out) if args.out else root / "work" / "requirement-lock.md"
    seed_lock(data, template, out)
    print(f"LOCK_DRAFT: {out}")
    print("status: draft — AI explore + user yes required before approved")
    return 0


def cmd_validate(args: argparse.Namespace) -> int:
    return cmd_lint(args)


def cmd_init(args: argparse.Namespace) -> int:
    root = Path(args.project).resolve()
    out = root / "work" / "grill-intake.json"
    if out.exists() and not args.force:
        print(f"ERROR: already exists: {out} (use --force)", file=sys.stderr)
        return 2
    sample = {
        "feature": args.feature,
        "document_id": "REQ-LOCK-001",
        "status": "draft",
        "grill_session": _utc_now()[:10],
        "problem_statement": "",
        "out_of_scope": [],
        "testing_approach": {"seams": "", "prior_art": ""},
        "open_questions": [],
        "journeys": [
            {
                "name": "Primary journey",
                "current_behavior": "",
                "your_request": "",
                "agreed_change": "",
                "files_components": "",
                "confirmed_forks": "none",
            }
        ],
        "context_updates": "none",
    }
    if args.json:
        sample.update(load_intake(Path(args.json)))
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(sample, indent=2) + "\n", encoding="utf-8")
    print(f"INTAKE_INIT: {out}")
    return 0


def _observe_script_record(project: Path, argv: list[str], exit_code: int, files: str = "") -> None:
    os_home = os.environ.get("AI_DEV_OS_HOME", "")
    if not os_home:
        return
    helper = Path(os_home) / "scripts" / "lib" / "observe-script-log.sh"
    if not helper.is_file():
        return
    args = " ".join(argv[1:]) if len(argv) > 1 else ""
    cmd = [
        "bash",
        str(helper),
        "record",
        "--project",
        str(project.resolve()),
        "--script",
        "grill-intake.py",
        "--args",
        args,
        "--exit",
        str(exit_code),
    ]
    if files:
        cmd.extend(["--files", files])
    subprocess.run(cmd, check=False)


def main() -> int:
    parser = argparse.ArgumentParser(description="Grill intake CLI (pre-AI structured intake)")
    parser.add_argument("--project", default=".", help="Project root")
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_lint = sub.add_parser("lint", help="Validate intake completeness")
    p_lint.add_argument("--file", help="Intake JSON path")
    p_lint.set_defaults(func=cmd_lint)

    p_seed = sub.add_parser("seed-lock", help="Seed draft requirement-lock.md")
    p_seed.add_argument("--file", help="Intake JSON path")
    p_seed.add_argument("--out", help="Output lock doc path")
    p_seed.add_argument("--template", help="Lock template path")
    p_seed.add_argument("--os-home", help="AI_DEV_OS_HOME for template fallback")
    p_seed.add_argument("--force", action="store_true", help="Seed even with lint warnings")
    p_seed.set_defaults(func=cmd_seed_lock)

    p_val = sub.add_parser("validate", help="Alias for lint")
    p_val.add_argument("--file", help="Intake JSON path")
    p_val.set_defaults(func=cmd_validate)

    p_init = sub.add_parser("init", help="Create starter grill-intake.json")
    p_init.add_argument("--feature", required=True, help="Feature slug/name")
    p_init.add_argument("--json", help="Merge fields from JSON file")
    p_init.add_argument("--force", action="store_true")
    p_init.set_defaults(func=cmd_init)

    args = parser.parse_args()
    if args.cmd in ("lint", "validate") and not args.file:
        args.file = str(Path(args.project).resolve() / "work" / "grill-intake.json")
    project = Path(args.project).resolve()
    exit_code = 0
    files = ""
    try:
        exit_code = args.func(args)
        if getattr(args, "file", None):
            files = str(Path(args.file).resolve())
    except SystemExit as exc:
        code = exc.code if isinstance(exc.code, int) else 1
        exit_code = code if code is not None else 1
    finally:
        _observe_script_record(project, sys.argv, exit_code, files)
    return exit_code


if __name__ == "__main__":
    sys.exit(main())