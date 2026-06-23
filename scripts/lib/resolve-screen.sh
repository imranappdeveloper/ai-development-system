#!/usr/bin/env bash
# resolve-screen.sh — screen nickname → file paths (alias cache + Graphify fallback)

_resolve_screen_project_root() {
  echo "${RESOLVE_SCREEN_PROJECT_ROOT:-$(pwd)}"
}

_resolve_screen_aliases_path() {
  echo "$(_resolve_screen_project_root)/work/ui-aliases.yaml"
}

_resolve_screen_graph_path() {
  echo "$(_resolve_screen_project_root)/graphify-out/graph.json"
}

_resolve_screen_match_alias() {
  local phrase="$1"
  local aliases_file="$2"
  RESOLVE_SCREEN_PHRASE="$phrase" RESOLVE_SCREEN_ALIASES="$aliases_file" python3 - <<'PY'
import json, os, re, sys

try:
    import yaml
except ImportError:
    yaml = None

phrase = os.environ.get("RESOLVE_SCREEN_PHRASE", "").strip().lower()
path = os.environ.get("RESOLVE_SCREEN_ALIASES", "")
if not phrase or not os.path.isfile(path):
    print(json.dumps({"match": None}))
    sys.exit(0)

raw = open(path, encoding="utf-8").read()
if yaml:
    data = yaml.safe_load(raw) or {}
else:
    # minimal fallback: key: at column 0
    data = {}
    key = None
    entry = {}
    for line in raw.splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if re.match(r"^[A-Za-z0-9].*:$", line) and not line.startswith(" "):
            if key:
                data[key] = entry
            key = line[:-1].strip()
            entry = {}
            continue
        m = re.match(r"^\s+(\w+):\s*(.+)$", line)
        if m and key:
            k, v = m.group(1), m.group(2).strip().strip('"').strip("'")
            if k == "files":
                entry.setdefault("files", [])
            else:
                entry[k] = v
        m = re.match(r"^\s+-\s+(.+)$", line)
        if m and key:
            entry.setdefault("files", []).append(m.group(1).strip())

    if key:
        data[key] = entry

STOP = {"screen", "page", "view", "tab", "panel", "dialog", "modal", "the", "and"}

def sig_words(text):
    return [w for w in re.split(r"\s+", text) if len(w) > 2 and w not in STOP]

best = None
best_score = 0
for nick, spec in (data or {}).items():
    if not isinstance(spec, dict):
        continue
    n = str(nick).strip().lower()
    if not n:
        continue
    score = 0
    if phrase == n:
        score = 100
    elif n in phrase or phrase in n:
        score = 80 + min(len(n), len(phrase))
    else:
        words = sig_words(n)
        if not words:
            continue
        hits = sum(1 for w in words if w in phrase)
        if hits == len(words):
            score = 60 + hits * 10
        elif hits and len(words) == 1 and hits == 1:
            score = 55
    if score > best_score:
        best_score = score
        best = {"nickname": nick, **{k: v for k, v in spec.items() if k != "files"}, "files": list(spec.get("files") or [])}

print(json.dumps({"match": best if best_score >= 55 else None, "score": best_score}))
PY
}

_resolve_screen_graphify_query() {
  local phrase="$1"
  local graph_path="$2"
  local budget="${3:-1500}"
  command -v graphify >/dev/null 2>&1 || return 1
  [[ -f "$graph_path" ]] || return 1
  graphify query "$phrase" --budget "$budget" --graph "$graph_path" 2>/dev/null
}

_resolve_screen_extract_paths() {
  local text="$1"
  RESOLVE_SCREEN_TEXT="$text" python3 - <<'PY'
import json, os, re

text = os.environ.get("RESOLVE_SCREEN_TEXT", "")
exts = r"(?:dart|tsx?|jsx?|vue|kt|swift|py|go|rs)"
pat = re.compile(rf"[\w./-]+\.{exts}\b")
seen = []
for m in pat.finditer(text):
    p = m.group(0).lstrip("./")
    if p not in seen and not p.startswith("node_modules/"):
        seen.append(p)
print(json.dumps(seen[:8]))
PY
}

_resolve_screen_append_alias() {
  local nickname="$1"
  local query="$2"
  local node="${3:-}"
  shift 3
  local files=("$@")
  local aliases_file="$(_resolve_screen_aliases_path)"
  RESOLVE_SCREEN_NICK="$nickname" \
  RESOLVE_SCREEN_QUERY="$query" \
  RESOLVE_SCREEN_NODE="$node" \
  RESOLVE_SCREEN_ALIASES="$aliases_file" \
  RESOLVE_SCREEN_FILES="$(printf '%s\n' "${files[@]}")" \
  python3 - <<'PY'
import json, os, sys

nick = os.environ.get("RESOLVE_SCREEN_NICK", "").strip()
query = os.environ.get("RESOLVE_SCREEN_QUERY", "").strip()
node = os.environ.get("RESOLVE_SCREEN_NODE", "").strip()
path = os.environ.get("RESOLVE_SCREEN_ALIASES", "")
files = [f.strip() for f in os.environ.get("RESOLVE_SCREEN_FILES", "").splitlines() if f.strip()]
if not nick or not files:
    sys.exit(1)

try:
    import yaml
except ImportError:
    yaml = None

data = {}
if os.path.isfile(path):
    if yaml:
        data = yaml.safe_load(open(path, encoding="utf-8")) or {}
    else:
        pass

if yaml:
    data[nick] = {"query": query or nick, "files": files}
    if node:
        data[nick]["node"] = node
    os.makedirs(os.path.dirname(path), exist_ok=True)
    header = (
        "# Screen nicknames only — AI appends on Graphify miss.\n"
        "# Graphify post-commit hook owns code structure.\n\n"
    )
    body = yaml.dump(data, default_flow_style=False, sort_keys=False, allow_unicode=True)
    open(path, "w", encoding="utf-8").write(header + body)
else:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write(f"\n{nick}:\n  query: \"{query or nick}\"\n  files:\n")
        for fp in files:
            f.write(f"    - {fp}\n")
        if node:
            f.write(f"  node: {node}\n")
print(json.dumps({"written": nick, "files": files}))
PY
}

_resolve_screen_log_usage() {
  local phrase="$1" source="$2" status="$3" files_csv="$4" nickname="${5:-}"
  local root
  root="$(_resolve_screen_project_root)"
  export OBSERVE_PROJECT_ROOT="$root"
  local lib_dir
  lib_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck source=scripts/lib/observe-event.sh
  source "$lib_dir/observe-event.sh"
  _observe_activity_emit resolve_screen \
    --skill resolve-screen \
    --args-summary "$phrase" \
    --step "$source" \
    --status "$status" \
    --files "$files_csv" \
    --target "$nickname"
}

_resolve_screen_run() {
  local phrase="$1"
  local write="${2:-false}"
  local budget="${3:-1500}"
  local aliases_file graph_path alias_json match_json source status files_json graph_ctx
  aliases_file="$(_resolve_screen_aliases_path)"
  graph_path="$(_resolve_screen_graph_path)"

  alias_json="$(_resolve_screen_match_alias "$phrase" "$aliases_file")"
  match_json="$(python3 -c "import json,sys; d=json.load(sys.stdin); print(json.dumps(d.get('match')))" <<<"$alias_json")"

  if [[ "$match_json" != "null" && -n "$match_json" ]]; then
    source="alias"
    status="hit"
    files_json="$(python3 -c "import json,sys; m=json.load(sys.stdin); print(json.dumps(m.get('files') or []))" <<<"$match_json")"
    local nickname
    nickname="$(python3 -c "import json,sys; print(json.load(sys.stdin).get('nickname',''))" <<<"$match_json")"
    _resolve_screen_log_usage "$phrase" "$source" "$status" "$(python3 -c "import json,sys; print(','.join(json.load(sys.stdin)))" <<<"$files_json")" "$nickname"
    python3 -c "
import json, sys
m = json.loads(sys.argv[1])
print(json.dumps({
    'ok': True,
    'source': 'alias',
    'nickname': m.get('nickname'),
    'query': m.get('query'),
    'node': m.get('node'),
    'files': m.get('files') or [],
    'phrase': sys.argv[2],
}))
" "$match_json" "$phrase"
    return 0
  fi

  if [[ -f "$graph_path" ]] && command -v graphify >/dev/null 2>&1; then
    graph_ctx="$(_resolve_screen_graphify_query "$phrase" "$graph_path" "$budget" || true)"
    if [[ -n "$graph_ctx" ]]; then
      files_json="$(_resolve_screen_extract_paths "$graph_ctx")"
      local file_count
      file_count="$(python3 -c "import json,sys; print(len(json.load(sys.stdin)))" <<<"$files_json")"
      if [[ "$file_count" -gt 0 ]]; then
        source="graphify"
        status="hit"
        if [[ "$write" == "true" ]]; then
          local nick query node
          nick="$(python3 -c "import re,sys; p=sys.argv[1].lower(); ws=[w for w in re.split(r'\s+',p) if len(w)>2]; print(' '.join(ws[:3]) if ws else p[:40])" "$phrase")"
          query="$phrase"
          node="$(python3 -c "
import re, sys
text = sys.stdin.read()
for pat in [r'class\s+(\w+Screen)', r'class\s+(\w+Page)', r'(\w+Screen)\b', r'(\w+Page)\b']:
    m = re.search(pat, text)
    if m:
        print(m.group(1))
        break
" <<<"$graph_ctx")"
          mapfile -t _resolved_files < <(python3 -c "import json,sys; [print(f) for f in json.load(sys.stdin)]" <<<"$files_json")
          _resolve_screen_append_alias "$nick" "$query" "$node" "${_resolved_files[@]}" || true
        fi
        _resolve_screen_log_usage "$phrase" "$source" "$status" "$(python3 -c "import json,sys; print(','.join(json.load(sys.stdin)))" <<<"$files_json")" ""
        python3 -c "
import json, sys
files = json.loads(sys.argv[1])
print(json.dumps({
    'ok': True,
    'source': 'graphify',
    'nickname': None,
    'query': sys.argv[2],
    'node': None,
    'files': files,
    'phrase': sys.argv[2],
    'graphify_excerpt': (sys.argv[3][:500] if len(sys.argv) > 3 else ''),
    'alias_written': sys.argv[4] == 'true',
}))
" "$files_json" "$phrase" "$graph_ctx" "$write"
        return 0
      fi
    fi
  fi

  source="miss"
  status="miss"
  _resolve_screen_log_usage "$phrase" "$source" "$status" "" ""
  local hint="Add alias manually or run: setup-graphify.sh . --build"
  [[ -f "$graph_path" ]] || hint="graph.json missing — run: setup-graphify.sh . --build"
  python3 -c "
import json, sys
print(json.dumps({
    'ok': False,
    'source': 'miss',
    'nickname': None,
    'files': [],
    'phrase': sys.argv[1],
    'hint': sys.argv[2],
}))
" "$phrase" "$hint"
  return 1
}