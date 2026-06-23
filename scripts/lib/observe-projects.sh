#!/usr/bin/env bash
# observe-projects.sh — registry of OS-bound projects for multi-project observe dashboard
set -euo pipefail

_observe_projects_config_dir() {
  echo "${HOME}/.config/ai-dev-os"
}

_observe_projects_registry() {
  echo "$(_observe_projects_config_dir)/projects.json"
}

_observe_projects_slug() {
  local path="$1"
  basename "$path" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-'
}

_observe_projects_register() {
  local project_dir="$1"
  [[ -d "$project_dir" ]] || return 1
  project_dir="$(cd "$project_dir" && pwd)"
  [[ -f "$project_dir/ai-dev-os.yaml" && -f "$project_dir/AGENTS.md" ]] || return 0

  mkdir -p "$(_observe_projects_config_dir)"
  python3 - "$project_dir" "$(_observe_projects_registry)" <<'PY'
import json, os, sys
from datetime import datetime, timezone
from pathlib import Path

root = Path(sys.argv[1]).resolve()
reg_path = Path(sys.argv[2])
name = root.name
slug = "".join(c if c.isalnum() else "-" for c in name.lower()).strip("-") or "project"
entry = {
    "id": slug,
    "name": name,
    "path": str(root),
    "added_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
}
data = {"version": 1, "projects": []}
if reg_path.exists():
    try:
        data = json.loads(reg_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        pass
projects = [p for p in data.get("projects", []) if p.get("path") != str(root)]
projects.insert(0, entry)
data["version"] = 1
data["projects"] = projects[:50]
reg_path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
PY
}

_observe_projects_list() {
  local reg
  reg="$(_observe_projects_registry)"
  [[ -f "$reg" ]] || { echo '{"version":1,"projects":[]}'; return 0; }
  python3 - "$reg" <<'PY'
import json, sys
from pathlib import Path

reg = Path(sys.argv[1])
try:
    data = json.loads(reg.read_text(encoding="utf-8"))
except Exception:
    data = {"version": 1, "projects": []}
valid = []
for p in data.get("projects", []):
    path = p.get("path", "")
    if path and Path(path).is_dir() and (Path(path) / "ai-dev-os.yaml").is_file():
        valid.append(p)
data["projects"] = valid
print(json.dumps(data, separators=(",", ":")))
PY
}