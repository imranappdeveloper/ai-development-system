"""Core logic for script-gated local codebase survey via Ollama (stdlib only)."""

from __future__ import annotations

import json
import os
import re
import urllib.error
import urllib.request
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any

DEFAULT_MODEL = "qwen2.5-coder:14b"
DEFAULT_HOST = "http://127.0.0.1:11434"
MAX_FILE_BYTES = 256_000
MAX_TOTAL_BYTES = 1_500_000
OLLAMA_TIMEOUT_S = 120


@dataclass
class SurveyResult:
    ok: bool
    summary: str = ""
    files_requested: list[str] = field(default_factory=list)
    files_read: list[str] = field(default_factory=list)
    files_missing: list[str] = field(default_factory=list)
    files_referenced: list[str] = field(default_factory=list)
    files_unreferenced: list[str] = field(default_factory=list)
    model: str = DEFAULT_MODEL
    error: str = ""
    fallback_recommended: bool = False

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


def _normalize_path(project_root: Path, rel: str) -> Path | None:
    rel = rel.strip().strip("`").strip()
    if not rel or rel.startswith("-"):
        return None
    candidate = Path(rel)
    if candidate.is_absolute():
        try:
            candidate.resolve().relative_to(project_root.resolve())
        except ValueError:
            return None
        return candidate.resolve()
    return (project_root / candidate).resolve()


def read_listed_files(
    project_root: Path,
    files: list[str],
    *,
    max_file_bytes: int = MAX_FILE_BYTES,
    max_total_bytes: int = MAX_TOTAL_BYTES,
) -> tuple[dict[str, str], list[str], list[str]]:
    """Return (contents, read_paths, missing_paths). Paths are project-relative posix."""
    project_root = project_root.resolve()
    contents: dict[str, str] = {}
    read_paths: list[str] = []
    missing_paths: list[str] = []
    total = 0

    for raw in files:
        resolved = _normalize_path(project_root, raw)
        if resolved is None:
            missing_paths.append(raw)
            continue
        try:
            resolved.relative_to(project_root)
        except ValueError:
            missing_paths.append(raw)
            continue

        rel_posix = resolved.relative_to(project_root).as_posix()
        if not resolved.is_file():
            missing_paths.append(rel_posix)
            continue

        size = resolved.stat().st_size
        if size > max_file_bytes:
            snippet = resolved.read_text(encoding="utf-8", errors="replace")[:max_file_bytes]
            contents[rel_posix] = (
                snippet + f"\n\n[truncated — file exceeds {max_file_bytes} bytes]\n"
            )
        else:
            contents[rel_posix] = resolved.read_text(encoding="utf-8", errors="replace")

        total += len(contents[rel_posix].encode("utf-8"))
        read_paths.append(rel_posix)
        if total > max_total_bytes:
            break

    return contents, read_paths, missing_paths


def build_prompt(file_contents: dict[str, str]) -> str:
    parts = [
        "You are a codebase survey assistant. Summarize the following files for a parent agent.",
        "Rules:",
        "- Read-only analysis; do not suggest edits.",
        "- Mention EVERY file path listed below by its exact path at least once.",
        "- Cover: purpose, key symbols, dependencies, and how files relate.",
        "- Be factual; if unclear, say unknown.",
        "",
        "Files:",
    ]
    for path, body in file_contents.items():
        parts.append(f"\n### {path}\n```\n{body}\n```")
    parts.append("\nReturn a concise structured summary in markdown.")
    return "\n".join(parts)


def _files_referenced_in_summary(summary: str, read_paths: list[str]) -> tuple[list[str], list[str]]:
    referenced: list[str] = []
    unreferenced: list[str] = []
    for path in read_paths:
        base = Path(path).name
        if path in summary or base in summary:
            referenced.append(path)
        else:
            unreferenced.append(path)
    return referenced, unreferenced


def call_ollama(
    *,
    host: str,
    model: str,
    prompt: str,
    timeout_s: int = OLLAMA_TIMEOUT_S,
) -> str:
    url = host.rstrip("/") + "/api/chat"
    payload = json.dumps(
        {
            "model": model,
            "messages": [{"role": "user", "content": prompt}],
            "stream": False,
            "keep_alive": "30m",
            "options": {"num_predict": 1024, "temperature": 0.2},
        }
    ).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=timeout_s) as resp:
        data = json.loads(resp.read().decode("utf-8"))
    message = data.get("message") or {}
    content = message.get("content") or ""
    if not str(content).strip():
        raise RuntimeError("ollama returned empty content")
    return str(content).strip()


def ollama_reachable(host: str, timeout_s: float = 2.0) -> bool:
    url = host.rstrip("/") + "/api/tags"
    try:
        with urllib.request.urlopen(url, timeout=timeout_s) as resp:
            return resp.status == 200
    except (urllib.error.URLError, TimeoutError, OSError):
        return False


def survey(
    project_root: str | Path,
    files: list[str],
    *,
    host: str | None = None,
    model: str | None = None,
    timeout_s: int = OLLAMA_TIMEOUT_S,
) -> SurveyResult:
    root = Path(project_root).resolve()
    host = host or os.environ.get("OLLAMA_HOST", DEFAULT_HOST)
    model = model or os.environ.get("OLLAMA_MODEL", DEFAULT_MODEL)
    requested = [f.strip() for f in files if f and f.strip()]

    if not requested:
        return SurveyResult(
            ok=False,
            error="no files provided — script-gated survey requires a file list",
            fallback_recommended=True,
            model=model,
        )

    if not root.is_dir():
        return SurveyResult(
            ok=False,
            files_requested=requested,
            error=f"project_root not a directory: {root}",
            fallback_recommended=True,
            model=model,
        )

    contents, read_paths, missing = read_listed_files(root, requested)
    if not contents:
        return SurveyResult(
            ok=False,
            files_requested=requested,
            files_missing=missing,
            error="no readable files from list",
            fallback_recommended=True,
            model=model,
        )

    if not ollama_reachable(host):
        return SurveyResult(
            ok=False,
            files_requested=requested,
            files_read=read_paths,
            files_missing=missing,
            error=f"ollama unreachable at {host}",
            fallback_recommended=True,
            model=model,
        )

    try:
        summary = call_ollama(
            host=host,
            model=model,
            prompt=build_prompt(contents),
            timeout_s=timeout_s,
        )
    except (urllib.error.URLError, TimeoutError, OSError, RuntimeError, json.JSONDecodeError) as exc:
        return SurveyResult(
            ok=False,
            files_requested=requested,
            files_read=read_paths,
            files_missing=missing,
            error=f"ollama error: {exc}",
            fallback_recommended=True,
            model=model,
        )

    referenced, unreferenced = _files_referenced_in_summary(summary, read_paths)
    ok = len(unreferenced) == 0 and len(missing) == 0

    return SurveyResult(
        ok=ok,
        summary=summary,
        files_requested=requested,
        files_read=read_paths,
        files_missing=missing,
        files_referenced=referenced,
        files_unreferenced=unreferenced,
        model=model,
        error="" if ok else "summary incomplete — not all files referenced",
        fallback_recommended=not ok,
    )


def parse_files_arg(files: Any) -> list[str]:
    if files is None:
        return []
    if isinstance(files, list):
        return [str(f) for f in files]
    if isinstance(files, str):
        text = files.strip()
        if not text:
            return []
        if text.startswith("["):
            try:
                parsed = json.loads(text)
                if isinstance(parsed, list):
                    return [str(f) for f in parsed]
            except json.JSONDecodeError:
                pass
        return [line.strip() for line in re.split(r"[\n,]+", text) if line.strip()]
    return [str(files)]