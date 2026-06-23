#!/usr/bin/env python3
"""Local ADS observe page — multi-project status + event feed."""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import webbrowser
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any
from urllib.parse import parse_qs, urlparse

OS_HOME = Path(__file__).resolve().parent.parent
TEMPLATE_DIR = OS_HOME / "templates" / "observe-dashboard"
REGISTRY = Path.home() / ".config" / "ai-dev-os" / "projects.json"
DEFAULT_PORT = 8765
API_VERSION = 2


def _utc_now() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _observe_event_bin() -> Path:
    env = os.environ.get("AI_DEV_OS_HOME")
    if env:
        candidate = Path(env) / "scripts" / "observe-event.sh"
        if candidate.is_file():
            return candidate
    local = OS_HOME / "scripts" / "observe-event.sh"
    if local.is_file():
        return local
    which = subprocess.run(["which", "observe-event"], capture_output=True, text=True, check=False)
    if which.returncode == 0 and which.stdout.strip():
        return Path(which.stdout.strip())
    return local


def _observe_bin() -> Path:
    env = os.environ.get("AI_DEV_OS_HOME")
    if env:
        candidate = Path(env) / "scripts" / "observe.sh"
        if candidate.is_file():
            return candidate
    local = OS_HOME / "scripts" / "observe.sh"
    if local.is_file():
        return local
    which = subprocess.run(["which", "observe"], capture_output=True, text=True, check=False)
    if which.returncode == 0 and which.stdout.strip():
        return Path(which.stdout.strip())
    return local


def register_project(path: Path) -> None:
    script = OS_HOME / "scripts" / "lib" / "observe-projects.sh"
    if not script.is_file():
        return
    subprocess.run(["bash", "-c", f'source "{script}"; _observe_projects_register "{path}"'], check=False)


def load_registry() -> dict[str, Any]:
    if not REGISTRY.is_file():
        return {"version": 1, "projects": []}
    try:
        data = json.loads(REGISTRY.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {"version": 1, "projects": []}
    valid = []
    for p in data.get("projects", []):
        root = Path(p.get("path", ""))
        if root.is_dir() and (root / "ai-dev-os.yaml").is_file():
            valid.append(p)
    data["projects"] = valid
    return data


def project_status(root: Path) -> dict[str, Any]:
    observe = _observe_bin()
    base = {
        "id": root.name.lower(),
        "name": root.name,
        "path": str(root),
        "health": "unknown",
        "telemetry_level": "",
        "run_id": "",
        "last_script": "",
        "last_skill": "",
        "elapsed_sec": 0,
        "error": "",
    }
    if not observe.is_file():
        base["error"] = "observe.sh not found"
        return base
    try:
        proc = subprocess.run(
            [str(observe), "status", "--json"],
            cwd=root,
            capture_output=True,
            text=True,
            check=False,
            timeout=10,
            env={**os.environ, "OBSERVE_PROJECT_ROOT": str(root)},
        )
        if proc.returncode != 0 or not proc.stdout.strip():
            base["error"] = (proc.stderr or "status failed").strip()[:200]
            return base
        st = json.loads(proc.stdout.strip())
        session_active = st.get("session_active")
        if session_active is None:
            session_active = st.get("health") == "active" and bool(st.get("run_id"))
        base.update(
            {
                "id": st.get("project", str(root)).split("/")[-1].lower(),
                "name": root.name,
                "health": st.get("health", "idle"),
                "session_active": bool(session_active),
                "activity_recent": bool(st.get("activity_recent", False)),
                "telemetry_level": st.get("telemetry_level", ""),
                "run_id": st.get("run_id", ""),
                "last_script": st.get("last_script", ""),
                "last_skill": st.get("last_skill", ""),
                "step": st.get("step", ""),
                "issue": st.get("issue", ""),
                "elapsed_sec": st.get("elapsed_sec", 0),
                "daemons": st.get("daemons", {}),
            }
        )
    except Exception as exc:  # noqa: BLE001
        base["error"] = str(exc)[:200]
    return base


def _read_jsonl(path: Path, limit: int = 80) -> list[dict[str, Any]]:
    if not path.is_file():
        return []
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    events: list[dict[str, Any]] = []
    for line in lines[-limit:]:
        line = line.strip()
        if not line:
            continue
        try:
            events.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return events


def project_events(root: Path, limit: int = 80) -> list[dict[str, Any]]:
    events: list[dict[str, Any]] = []
    events_file = root / "work" / "telemetry" / "events.jsonl"
    events.extend(_read_jsonl(events_file, limit))

    runs_dir = root / "work" / "telemetry" / "runs"
    if runs_dir.is_dir():
        run_files = sorted(runs_dir.glob("*.jsonl"), key=lambda p: p.stat().st_mtime, reverse=True)
        if run_files:
            events.extend(_read_jsonl(run_files[0], limit))

    for e in events:
        e.setdefault("project", root.name)
        e.setdefault("project_path", str(root))

    events.sort(key=lambda e: e.get("ts", ""), reverse=True)
    seen: set[str] = set()
    deduped: list[dict[str, Any]] = []
    for e in events:
        key = json.dumps(e, sort_keys=True, default=str)
        if key in seen:
            continue
        seen.add(key)
        deduped.append(e)
        if len(deduped) >= limit:
            break
    return deduped


def _read_current_run_id(root: Path) -> str:
    current = root / "work" / "telemetry" / ".current-run"
    if not current.is_file():
        return ""
    return current.read_text(encoding="utf-8").strip()


def resolve_project(project_key: str) -> Path | None:
    key = (project_key or "").strip()
    if not key or key == "all":
        return None
    reg = load_registry()
    for p in reg.get("projects", []):
        root = Path(p["path"])
        pid = p.get("id", "")
        pname = p.get("name", "")
        if _project_matches_filter(key, pid=pid, pname=pname, root=root):
            return root
    return None


def start_observing(root: Path) -> dict[str, Any]:
    st = project_status(root)
    if st.get("session_active"):
        return {
            "ok": True,
            "project": root.name,
            "run_id": st.get("run_id", ""),
            "already_active": True,
        }
    event_sh = _observe_event_bin()
    if not event_sh.is_file():
        return {"ok": False, "error": "observe-event.sh not found"}
    try:
        proc = subprocess.run(
            [str(event_sh), "run-start", "--skill", "observe"],
            cwd=root,
            capture_output=True,
            text=True,
            check=False,
            timeout=10,
            env={**os.environ, "OBSERVE_PROJECT_ROOT": str(root)},
        )
        run_id = (proc.stdout or "").strip()
        if proc.returncode != 0 or not run_id:
            err = (proc.stderr or "run-start failed").strip()[:200]
            return {"ok": False, "error": err}
        return {"ok": True, "project": root.name, "run_id": run_id, "already_active": False}
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "error": str(exc)[:200]}


def stop_observing(root: Path) -> dict[str, Any]:
    st = project_status(root)
    if not st.get("session_active"):
        return {"ok": True, "project": root.name, "already_idle": True}
    event_sh = _observe_event_bin()
    if not event_sh.is_file():
        return {"ok": False, "error": "observe-event.sh not found"}
    run_id = st.get("run_id", "") or _read_current_run_id(root)
    args = [str(event_sh), "run-end", "--status", "ok"]
    if run_id:
        args.extend(["--run-id", run_id])
    try:
        proc = subprocess.run(
            args,
            cwd=root,
            capture_output=True,
            text=True,
            check=False,
            timeout=10,
            env={**os.environ, "OBSERVE_PROJECT_ROOT": str(root)},
        )
        if proc.returncode != 0:
            err = (proc.stderr or "run-end failed").strip()[:200]
            return {"ok": False, "error": err}
        return {"ok": True, "project": root.name, "run_id": run_id, "already_idle": False}
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "error": str(exc)[:200]}


def _normalize_project_key(value: str) -> str:
    return value.strip().lower()


def _project_matches_filter(
    project_filter: str | None,
    *,
    pid: str = "",
    pname: str = "",
    root: Path | None = None,
) -> bool:
    if not project_filter or project_filter == "all":
        return True
    key = _normalize_project_key(project_filter)
    checks = {_normalize_project_key(pid), _normalize_project_key(pname)}
    if root is not None:
        checks.update(
            {
                _normalize_project_key(root.name),
                _normalize_project_key(str(root)),
            }
        )
    return key in checks


def api_snapshot(project_filter: str | None = None) -> dict[str, Any]:
    reg = load_registry()
    projects = reg.get("projects", [])
    rows = []
    all_events: list[dict[str, Any]] = []
    filtered = bool(project_filter and project_filter != "all")
    filter_label = ""

    for p in projects:
        root = Path(p["path"])
        pid = p.get("id", "")
        pname = p.get("name", "")
        if not _project_matches_filter(project_filter, pid=pid, pname=pname, root=root):
            continue
        if filtered and not filter_label:
            filter_label = pname or root.name
        row = project_status(root)
        row["id"] = pid or row["id"]
        row["name"] = pname or row["name"]
        rows.append(row)
        all_events.extend(project_events(root, limit=80 if filtered else 40))

    all_events.sort(key=lambda e: e.get("ts", ""), reverse=True)
    return {
        "ts": _utc_now(),
        "api_version": API_VERSION,
        "filter": project_filter or "all",
        "filter_label": filter_label,
        "projects": rows,
        "events": all_events[:120],
        "registry_count": len(projects),
        "showing_count": len(rows),
    }


def api_capabilities() -> dict[str, Any]:
    return {
        "api_version": API_VERSION,
        "observe_actions": True,
        "endpoints": [
            "snapshot",
            "projects",
            "capabilities",
            "observe/start",
            "observe/stop",
        ],
    }


class DashboardHandler(BaseHTTPRequestHandler):
    server_version = "ADSObserve/1.0"

    def log_message(self, fmt: str, *args: Any) -> None:
        if os.environ.get("OBSERVE_DASHBOARD_QUIET") == "1":
            return
        super().log_message(fmt, *args)

    def _send_json(self, payload: dict[str, Any], code: int = 200) -> None:
        body = json.dumps(payload, separators=(",", ":")).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Cache-Control", "no-store")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _send_file(self, path: Path, content_type: str) -> None:
        if not path.is_file():
            self.send_error(404)
            return
        data = path.read_bytes()
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _read_json_body(self) -> dict[str, Any]:
        length = int(self.headers.get("Content-Length", "0") or "0")
        if length <= 0:
            return {}
        try:
            raw = self.rfile.read(length)
            data = json.loads(raw.decode("utf-8"))
            return data if isinstance(data, dict) else {}
        except (json.JSONDecodeError, UnicodeDecodeError):
            return {}

    def do_OPTIONS(self) -> None:
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self) -> None:
        parsed = urlparse(self.path)
        qs = parse_qs(parsed.query)
        body = self._read_json_body()
        project_key = (body.get("project") or (qs.get("project") or [""])[0] or "").strip()
        root = resolve_project(project_key)
        if not root:
            self._send_json({"ok": False, "error": "unknown project"}, code=404)
            return
        if parsed.path == "/api/observe/start":
            self._send_json(start_observing(root))
            return
        if parsed.path == "/api/observe/stop":
            self._send_json(stop_observing(root))
            return
        self.send_error(404)

    def do_GET(self) -> None:
        parsed = urlparse(self.path)
        if parsed.path == "/api/snapshot":
            qs = parse_qs(parsed.query)
            filt = (qs.get("project") or ["all"])[0]
            self._send_json(api_snapshot(None if filt in ("", "all") else filt))
            return
        if parsed.path == "/api/projects":
            self._send_json(load_registry())
            return
        if parsed.path == "/api/capabilities":
            self._send_json(api_capabilities())
            return
        if parsed.path in ("/", "/index.html"):
            self._send_file(TEMPLATE_DIR / "index.html", "text/html; charset=utf-8")
            return
        if parsed.path == "/app.js":
            self._send_file(TEMPLATE_DIR / "app.js", "application/javascript; charset=utf-8")
            return
        if parsed.path == "/style.css":
            self._send_file(TEMPLATE_DIR / "style.css", "text/css; charset=utf-8")
            return
        self.send_error(404)


def main() -> int:
    parser = argparse.ArgumentParser(description="ADS local observe dashboard")
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--project", help="Register this project before start")
    parser.add_argument("--open", action="store_true", help="Open browser")
    parser.add_argument("--no-open", action="store_true")
    args = parser.parse_args()

    if args.project:
        register_project(Path(args.project).resolve())
    elif not args.no_open and Path.cwd().joinpath("ai-dev-os.yaml").is_file():
        # Interactive start from a bound project — register it
        register_project(Path.cwd().resolve())

    if not TEMPLATE_DIR.is_dir():
        print(f"ERROR: missing template dir: {TEMPLATE_DIR}", file=sys.stderr)
        return 1

    url = f"http://{args.host}:{args.port}/"
    server = ThreadingHTTPServer((args.host, args.port), DashboardHandler)
    print(f"ADS Observe — {url}")
    print("  Ctrl-C to stop")
    reg = load_registry()
    print(f"  Projects: {len(reg.get('projects', []))} registered")
    if args.open or (sys.stdout.isatty() and not args.no_open):
        webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    return 0


if __name__ == "__main__":
    sys.exit(main())