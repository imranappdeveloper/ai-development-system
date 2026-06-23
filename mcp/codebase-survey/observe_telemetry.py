"""Append observe telemetry when codebase-survey MCP tool runs (stdlib only)."""

from __future__ import annotations

import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from survey_lib import SurveyResult

MCP_SERVER = "codebase-survey"
MCP_TOOL = "survey"


def _utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _read_telemetry_level(project_root: Path) -> str:
    for name in ("ai-dev-os.yaml", "ai-dev-os.local.yaml"):
        path = project_root / name
        if not path.is_file():
            continue
        in_telemetry = False
        for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
            if line.strip().startswith("telemetry:"):
                in_telemetry = True
                continue
            if in_telemetry:
                if line and not line.startswith((" ", "\t")) and ":" in line:
                    break
                if line.strip().startswith("level:"):
                    val = line.split(":", 1)[1].strip().split("#", 1)[0].strip().strip("'\"")
                    if val:
                        return val
    return "verbose"


def _level_allows_mcp_call(level: str) -> bool:
    # codebase-survey MCP calls are always logged (distinct from verbose tool_call)
    return True


def _current_run_id(project_root: Path) -> str:
    f = project_root / "work" / "telemetry" / ".current-run"
    if f.is_file():
        return f.read_text(encoding="utf-8").strip()
    return ""


def _append_jsonl(path: Path, obj: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as fh:
        fh.write(json.dumps(obj, ensure_ascii=False, separators=(",", ":")) + "\n")


def emit_survey_call(
    project_root: str | Path,
    result: SurveyResult,
    *,
    duration_sec: float,
) -> None:
    root = Path(project_root).resolve()
    if not _level_allows_mcp_call(_read_telemetry_level(root)):
        return

    status = "ok" if result.ok else "fail"
    event: dict[str, Any] = {
        "ts": _utc_now(),
        "event_type": "mcp_call",
        "mcp_server": MCP_SERVER,
        "mcp_tool": MCP_TOOL,
        "target": MCP_SERVER,
        "status": status,
        "duration_sec": int(duration_sec),
        "model": result.model,
        "files": result.files_requested,
        "files_read": result.files_read,
        "files_missing": result.files_missing,
        "files_referenced": result.files_referenced,
        "files_unreferenced": result.files_unreferenced,
        "fallback_recommended": result.fallback_recommended,
        "summary_chars": len(result.summary or ""),
    }
    if result.error:
        event["error"] = result.error[:500]

    run_id = _current_run_id(root)
    if run_id:
        event["run_id"] = run_id

    events_file = root / "work" / "telemetry" / "events.jsonl"
    _append_jsonl(events_file, event)
    if run_id:
        run_file = root / "work" / "telemetry" / "runs" / f"{run_id}.jsonl"
        _append_jsonl(run_file, event)

    # Best-effort global registry heartbeat for Antigravity/Grok
    registry = Path.home() / ".gemini" / "antigravity" / ".active_run_context.json"
    if run_id:
        try:
            registry.parent.mkdir(parents=True, exist_ok=True)
            registry.write_text(
                json.dumps(
                    {
                        "project_root": str(root),
                        "run_id": run_id,
                        "agent": os.environ.get("ADS_AGENT", ""),
                        "status": "active",
                        "last_heartbeat": event["ts"],
                    },
                    separators=(",", ":"),
                )
                + "\n",
                encoding="utf-8",
            )
        except OSError:
            pass