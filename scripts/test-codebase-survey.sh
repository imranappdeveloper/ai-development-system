#!/usr/bin/env bash
# test-codebase-survey.sh — unit checks for mcp/codebase-survey (no live Ollama required)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fail=0

echo "=== test-codebase-survey ==="

PROJECT="$TMP/project"
mkdir -p "$PROJECT/src"
echo "export const x = 1;" >"$PROJECT/src/a.ts"
echo "# readme" >"$PROJECT/README.md"

MCP_LIB="$ROOT/mcp/codebase-survey"
export PYTHONPATH="$MCP_LIB"

python3 - "$PROJECT" <<'PY'
import sys
from pathlib import Path

from survey_lib import read_listed_files, survey, _files_referenced_in_summary

root = Path(sys.argv[1])
contents, read, missing = read_listed_files(root, ["src/a.ts", "missing.ts", "../outside"])
assert "src/a.ts" in read
assert "missing.ts" in missing
print("  OK: read_listed_files")

ref, unref = _files_referenced_in_summary("see src/a.ts and a.ts", ["src/a.ts"])
assert ref == ["src/a.ts"] and unref == []
print("  OK: coverage check")

res = survey(root, ["src/a.ts"], host="http://127.0.0.1:1")
assert res.fallback_recommended is True
assert "unreachable" in res.error.lower()
print("  OK: survey fail-closed when ollama unreachable")
PY

payload='{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"0"}}}'
json_line="$(cd "$MCP_LIB" && printf '%s\n' "$payload" | python3 server.py | head -1)"
echo "$json_line" | python3 -c "import json,sys; r=json.load(sys.stdin); assert r['result']['serverInfo']['name']=='codebase-survey'; assert r['result']['protocolVersion']=='2025-06-18'" \
  && echo "  OK: mcp initialize (ndjson)" || { echo "  FAIL: mcp initialize" >&2; fail=1; }

len=${#payload}
framed_line="$(cd "$MCP_LIB" && printf 'Content-Length: %s\r\n\r\n%s' "$len" "$payload" | python3 server.py | head -1)"
echo "$framed_line" | python3 -c "import json,sys; r=json.load(sys.stdin); assert r['result']['serverInfo']['name']=='codebase-survey'" \
  && echo "  OK: mcp initialize (content-length)" || { echo "  FAIL: mcp content-length" >&2; fail=1; }

# shellcheck source=scripts/lib/local-survey.sh
source "$ROOT/scripts/lib/local-survey.sh"
status="$(local_survey_status "$ROOT")"
state="${status##*|}"
case "$state" in
  disabled|ready|enabled-no-ollama|enabled-unreachable) echo "  OK: local_survey_status ($state)" ;;
  *) echo "  FAIL: local_survey_status ($state)" >&2; fail=1 ;;
esac

AI_DEV_OS_HOME="$ROOT" server_path="$(local_survey_server_path)"
[[ -f "$server_path" ]] && echo "  OK: server path" || { echo "  FAIL: server path" >&2; fail=1; }

[[ $fail -eq 0 ]] && echo "=== pass ===" || exit 1