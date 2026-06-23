#!/usr/bin/env bash
# observe-event.sh — append structured run-trace events (low-token observability)
# Source from observe.sh or call: observe-event.sh emit [flags]

OBSERVE_VERSION="1.0"

_observe_project_root() {
  echo "${OBSERVE_PROJECT_ROOT:-$(pwd)}"
}

_observe_runs_dir() {
  echo "$(_observe_project_root)/work/telemetry/runs"
}

_observe_current_run_file() {
  echo "$(_observe_project_root)/work/telemetry/.current-run"
}

_observe_global_registry_file() {
  echo "$HOME/.gemini/antigravity/.active_run_context.json"
}

_observe_update_global_registry() {
  local project_root="$1" run_id="$2" agent="$3" status="$4"
  local registry
  registry="$(_observe_global_registry_file)"
  mkdir -p "$(dirname "$registry")"
  local ts
  ts="$(_observe_ts)"
  printf '{"project_root":"%s","run_id":"%s","agent":"%s","status":"%s","last_heartbeat":"%s"}\n' \
    "$(_observe_json_escape "$project_root")" \
    "$(_observe_json_escape "$run_id")" \
    "$(_observe_json_escape "$agent")" \
    "$(_observe_json_escape "$status")" \
    "$ts" >"$registry"
}

_observe_ensure_dirs() {
  mkdir -p "$(_observe_runs_dir)" "$(_observe_project_root)/work/telemetry"
}

_observe_ts() {
  date -u +%Y-%m-%dT%H:%M:%SZ
}

_observe_json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/}"
  printf '%s' "$s"
}

_observe_yaml_value() {
  local block="$1" key="$2" default="$3"
  local yaml val
  yaml="$(_observe_project_root)/ai-dev-os.yaml"
  local_yaml="$(_observe_project_root)/ai-dev-os.local.yaml"
  val="$(awk -v b="$block" -v k="$key" '
    $0 ~ "^" b ":" { in_b=1; next }
    in_b && /^[a-zA-Z#]/ { in_b=0 }
    in_b && $1 == k":" {
      gsub(/^[^:]*:[[:space:]]*/, "")
      gsub(/[[:space:]]+#.*$/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      exit
    }
  ' "$yaml" 2>/dev/null || true)"
  if [[ -z "$val" && -f "$local_yaml" ]]; then
    val="$(awk -v b="$block" -v k="$key" '
      $0 ~ "^" b ":" { in_b=1; next }
      in_b && /^[a-zA-Z#]/ { in_b=0 }
      in_b && $1 == k":" {
        gsub(/^[^:]*:[[:space:]]*/, "")
        gsub(/[[:space:]]+#.*$/, "")
        gsub(/^["'\'']|["'\'']$/, "")
        print
        exit
      }
    ' "$local_yaml" 2>/dev/null || true)"
  fi
  [[ -n "$val" ]] && echo "$val" || echo "$default"
}

_observe_telemetry_level() {
  _observe_yaml_value telemetry level verbose
}

_observe_level_allows() {
  local event_type="$1"
  local level
  level="$(_observe_telemetry_level)"
  case "$level" in
    minimal)
      case "$event_type" in
        run_start|run_end|milestone|heartbeat) return 0 ;;
        *) return 1 ;;
      esac
      ;;
    standard)
      case "$event_type" in
        tool_call) return 1 ;;
        *) return 0 ;;
      esac
      ;;
    verbose|*) return 0 ;;
  esac
}

_observe_append_jsonl() {
  local file="$1" line="$2"
  mkdir -p "$(dirname "$file")"
  printf '%s\n' "$line" >>"$file"
}

_observe_new_run_id() {
  printf 'RUN-%s-%s' "$(date -u +%Y-%m-%d)" "$(uuidgen 2>/dev/null | tr '[:upper:]' '[:lower:]' | cut -c1-8 || date +%s | tail -c 9)"
}

_observe_read_current_run_id() {
  local f
  f="$(_observe_current_run_file)"
  [[ -f "$f" ]] && cat "$f" || true
}

_observe_set_current_run_id() {
  local run_id="$1"
  _observe_ensure_dirs
  printf '%s' "$run_id" >"$(_observe_current_run_file)"
}

_observe_clear_current_run_id() {
  rm -f "$(_observe_current_run_file)"
}

_observe_run_file() {
  local run_id="$1"
  echo "$(_observe_runs_dir)/${run_id}.jsonl"
}

_observe_emit() {
  local event_type="$1"
  shift
  local run_id="${OBSERVE_RUN_ID:-}"
  local parent_run_id="" step="" step_index="" issue="" agent="" status="" duration_sec=""
  local tokens_in="" tokens_out="" tokens_source="" skill=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --run-id) run_id="$2"; shift 2 ;;
      --parent-run-id) parent_run_id="$2"; shift 2 ;;
      --step) step="$2"; shift 2 ;;
      --step-index) step_index="$2"; shift 2 ;;
      --issue) issue="$2"; shift 2 ;;
      --agent) agent="$2"; shift 2 ;;
      --status) status="$2"; shift 2 ;;
      --duration-sec) duration_sec="$2"; shift 2 ;;
      --tokens-in) tokens_in="$2"; shift 2 ;;
      --tokens-out) tokens_out="$2"; shift 2 ;;
      --tokens-source) tokens_source="$2"; shift 2 ;;
      --skill) skill="$2"; shift 2 ;;
      *) return 1 ;;
    esac
  done

  _observe_level_allows "$event_type" || return 0

  _observe_ensure_dirs
  [[ -n "$run_id" ]] || run_id="$(_observe_read_current_run_id)"
  [[ -n "$run_id" ]] || return 0

  local ts line run_file
  ts="$(_observe_ts)"
  run_file="$(_observe_run_file "$run_id")"

  line="{"
  line+="\"ts\":\"$ts\""
  line+=",\"run_id\":\"$(_observe_json_escape "$run_id")\""
  line+=",\"event_type\":\"$(_observe_json_escape "$event_type")\""
  [[ -n "$parent_run_id" ]] && line+=",\"parent_run_id\":\"$(_observe_json_escape "$parent_run_id")\""
  [[ -n "$skill" ]] && line+=",\"skill\":\"$(_observe_json_escape "$skill")\""
  [[ -n "$step" ]] && line+=",\"step\":\"$(_observe_json_escape "$step")\""
  [[ -n "$step_index" ]] && line+=",\"step_index\":\"$(_observe_json_escape "$step_index")\""
  [[ -n "$issue" ]] && line+=",\"issue\":${issue}"
  [[ -n "$agent" ]] && line+=",\"agent\":\"$(_observe_json_escape "$agent")\""
  [[ -n "$status" ]] && line+=",\"status\":\"$(_observe_json_escape "$status")\""
  [[ -n "$duration_sec" ]] && line+=",\"duration_sec\":${duration_sec}"
  if [[ -n "$tokens_in" ]]; then
    line+=",\"tokens_in\":${tokens_in}"
  else
    line+=",\"tokens_in\":null"
  fi
  if [[ -n "$tokens_out" ]]; then
    line+=",\"tokens_out\":${tokens_out}"
  else
    line+=",\"tokens_out\":null"
  fi
  if [[ -n "$tokens_source" ]]; then
    line+=",\"tokens_source\":\"$(_observe_json_escape "$tokens_source")\""
  else
    line+=",\"tokens_source\":null"
  fi
  line+="}"

  _observe_append_jsonl "$run_file" "$line"

  local reg_status="active"
  [[ "$event_type" == "run_end" ]] && reg_status="idle"
  local reg_agent="$agent"
  if [[ -z "$reg_agent" && -f "$(_observe_global_registry_file)" ]]; then
    reg_agent="$(grep -o '"agent":"[^"]*' "$(_observe_global_registry_file)" | cut -d'"' -f4 || true)"
  fi
  _observe_update_global_registry "$(_observe_project_root)" "$run_id" "$reg_agent" "$reg_status"

  case "$event_type" in
    run_start|run_end|heartbeat)
      if [[ -f "$(_observe_project_root)/work/telemetry/events.jsonl" || -d "$(_observe_project_root)/work/telemetry" ]]; then
        local summary
        summary="{\"ts\":\"$ts\",\"event_type\":\"observe_${event_type}\",\"run_id\":\"$(_observe_json_escape "$run_id")\",\"skill\":\"$(_observe_json_escape "$skill")\",\"step\":\"$(_observe_json_escape "$step")\",\"status\":\"$(_observe_json_escape "$status")\"}"
        _observe_append_jsonl "$(_observe_project_root)/work/telemetry/events.jsonl" "$summary"
      fi
      ;;
  esac
}