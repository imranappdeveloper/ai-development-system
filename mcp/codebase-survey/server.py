#!/usr/bin/env python3
"""MCP stdio server — script-gated local codebase survey via Ollama."""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path
from typing import Any

from observe_telemetry import emit_survey_call
from survey_lib import SurveyResult, parse_files_arg, survey

SERVER_NAME = "codebase-survey"
SERVER_VERSION = "1.0.0"
SUPPORTED_PROTOCOLS = ("2024-11-05", "2025-03-26", "2025-06-18")
DEFAULT_PROTOCOL = "2025-06-18"


def _send(msg: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(msg, ensure_ascii=False) + "\n")
    sys.stdout.flush()


def _read_message() -> dict[str, Any] | None:
    while True:
        raw = sys.stdin.buffer.readline()
        if not raw:
            return None
        if raw.startswith(b"Content-Length:"):
            try:
                length = int(raw.decode("ascii").split(":", 1)[1].strip())
            except (ValueError, IndexError):
                continue
            while True:
                sep = sys.stdin.buffer.readline()
                if sep in (b"\r\n", b"\n", b""):
                    break
            body = sys.stdin.buffer.read(length)
            if not body:
                return None
            msg = json.loads(body.decode("utf-8"))
            return msg if isinstance(msg, dict) else None

        line = raw.decode("utf-8", errors="replace").strip()
        if not line:
            continue
        msg = json.loads(line)
        return msg if isinstance(msg, dict) else None


def _tool_schema() -> dict[str, Any]:
    return {
        "name": "survey",
        "description": (
            "Read-only summarize of script-listed files via local Ollama. "
            "Use only when grill-intake, issue-context-pack, requirement-lock, "
            "or user attachments already provide paths. "
            "On error or incomplete coverage, parent must fall back to cloud explore "
            "on the same file list."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "files": {
                    "type": "array",
                    "items": {"type": "string"},
                    "description": "Project-relative file paths from a script or lock doc.",
                },
                "project_root": {
                    "type": "string",
                    "description": "Workspace root (defaults to cwd).",
                },
            },
            "required": ["files"],
        },
    }


def _result_text(result: SurveyResult) -> str:
    return json.dumps(result.to_dict(), indent=2, ensure_ascii=False)


def _negotiated_protocol(params: dict[str, Any]) -> str:
    requested = str((params or {}).get("protocolVersion") or DEFAULT_PROTOCOL)
    if requested in SUPPORTED_PROTOCOLS:
        return requested
    return DEFAULT_PROTOCOL


def _handle_initialize(req_id: Any, params: dict[str, Any]) -> None:
    _send(
        {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "protocolVersion": _negotiated_protocol(params),
                "capabilities": {"tools": {}},
                "serverInfo": {"name": SERVER_NAME, "version": SERVER_VERSION},
            },
        }
    )


def _handle_tools_list(req_id: Any) -> None:
    _send(
        {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {"tools": [_tool_schema()]},
        }
    )


def _handle_tools_call(req_id: Any, params: dict[str, Any]) -> None:
    name = params.get("name")
    if name != "survey":
        _send(
            {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32601, "message": f"unknown tool: {name}"},
            }
        )
        return

    args = params.get("arguments") or {}
    files = parse_files_arg(args.get("files"))
    project_root = args.get("project_root") or str(Path.cwd())
    started = time.monotonic()
    result = survey(project_root, files)
    try:
        emit_survey_call(project_root, result, duration_sec=time.monotonic() - started)
    except Exception:
        pass
    _send(
        {
            "jsonrpc": "2.0",
            "id": req_id,
            "result": {
                "content": [{"type": "text", "text": _result_text(result)}],
                "isError": not result.ok,
            },
        }
    )


def _handle_notification(method: str, params: dict[str, Any]) -> None:
    if method in ("notifications/initialized", "notifications/cancelled"):
        return


def _dispatch(msg: dict[str, Any]) -> None:
    method = msg.get("method")
    req_id = msg.get("id")
    params = msg.get("params") or {}

    if method == "initialize":
        _handle_initialize(req_id, params)
        return
    if method == "ping":
        if req_id is not None:
            _send({"jsonrpc": "2.0", "id": req_id, "result": {}})
        return
    if method == "tools/list":
        _handle_tools_list(req_id)
        return
    if method == "tools/call":
        _handle_tools_call(req_id, params)
        return
    if method and method.startswith("notifications/"):
        _handle_notification(method, params)
        return
    if req_id is not None:
        _send(
            {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32601, "message": f"method not found: {method}"},
            }
        )


def main() -> int:
    while True:
        try:
            msg = _read_message()
        except json.JSONDecodeError:
            continue
        if msg is None:
            break
        _dispatch(msg)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())