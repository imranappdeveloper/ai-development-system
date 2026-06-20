#!/usr/bin/env bash
# issue-spec-check.sh — structural issue spec validation (deterministic only)

_issue_spec_trim() {
  local s="$1"
  s="${s//$'\r'/}"
  echo "$s" | sed -e 's/[[:space:]]*$//'
}

_issue_spec_extract_section() {
  local body="$1"
  local heading="$2"
  awk -v h="$heading" '
    BEGIN { found=0 }
    $0 ~ "^##[[:space:]]+" h "[[:space:]]*$" { found=1; next }
    found && /^##[[:space:]]+/ { exit }
    found { print }
  ' <<<"$body"
}

_issue_spec_spec_before_stamp() {
  local body="$1"
  if grep -q '^## AFK preflight' <<<"$body"; then
    awk '/^## AFK preflight/{exit} {print}' <<<"$body" | sed -e '${/^$/d;}' 
  else
    echo "$body"
  fi
}

_issue_spec_compute_sha256_16() {
  local spec
  spec="$(_issue_spec_trim "$1")"
  printf '%s' "$spec" | sha256sum | awk '{print substr($1,1,16)}'
}

_issue_spec_count_checkbox_acs() {
  local ac_section="$1"
  grep -cE '^[[:space:]]*-[[:space:]]+\[[ xX]\]' <<<"$ac_section" 2>/dev/null || echo 0
}

_issue_spec_parse_blocked_refs() {
  local blocked_section="$1"
  local line ref
  blocked_section="$(echo "$blocked_section" | tr '[:upper:]' '[:lower:]')"
  if grep -qE '(^|[[:space:]])(none|n/a|-)[[:space:]]*$' <<<"$(echo "$blocked_section" | head -1 | xargs)" 2>/dev/null; then
    return 0
  fi
  if [[ -z "$(echo "$blocked_section" | tr -d '[:space:]')" ]]; then
    return 0
  fi
  while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    for ref in $(grep -oE '#[0-9]+|[0-9]+' <<<"$line" || true); do
      ref="${ref#\#}"
      [[ "$ref" =~ ^[0-9]+$ ]] || continue
      echo "$ref"
    done
  done <<<"$blocked_section"
}

_issue_spec_stamp_valid() {
  local body="$1"
  local stamp
  stamp="$(_issue_spec_extract_section "$body" "AFK preflight")"
  [[ -n "$stamp" ]] || return 1
  grep -qE 'plan-review:[[:space:]]*READY' <<<"$stamp" || return 1
  grep -qE 'stamped-at:' <<<"$stamp" || return 1
  grep -qE 'spec-sha256:[[:space:]]*[0-9a-f]{16}' <<<"$stamp" || return 1
  return 0
}

_issue_spec_stamp_hash() {
  local body="$1"
  local stamp
  stamp="$(_issue_spec_extract_section "$body" "AFK preflight")"
  grep -oE 'spec-sha256:[[:space:]]*[0-9a-f]{16}' <<<"$stamp" | head -1 | sed 's/.*:[[:space:]]*//'
}

_issue_spec_afk_skip_eligible() {
  local body="$1"
  local spec hash stamped
  _issue_spec_stamp_valid "$body" || return 1
  spec="$(_issue_spec_spec_before_stamp "$body")"
  hash="$(_issue_spec_compute_sha256_16 "$spec")"
  stamped="$(_issue_spec_stamp_hash "$body")"
  [[ "$hash" == "$stamped" ]]
}

_issue_spec_check_blocked() {
  local blocked_section="$1"
  local offline="${2:-false}"
  local refs ref missing=0
  refs="$(_issue_spec_parse_blocked_refs "$blocked_section" || true)"
  [[ -z "$refs" ]] && return 0
  while IFS= read -r ref; do
    [[ -z "$ref" ]] && continue
    if [[ "$offline" == "true" ]]; then
      continue
    fi
    if ! gh issue view "$ref" --json number >/dev/null 2>&1; then
      echo "blocked-ref-missing:#$ref"
      missing=1
    fi
  done <<<"$refs"
  return "$missing"
}

# Sets ISSUE_SPEC_RESULT, ISSUE_SPEC_FAILURES (newline-separated), ISSUE_SPEC_NOTES
_issue_spec_check_structural() {
  local body="$1"
  local offline="${2:-false}"
  local what ac blocked failures="" notes="" n_ac=0

  ISSUE_SPEC_RESULT="READY"
  ISSUE_SPEC_FAILURES=""
  ISSUE_SPEC_NOTES=""
  ISSUE_SPEC_CHECKBOX_COUNT=0
  ISSUE_SPEC_SHA256=""
  ISSUE_SPEC_AFK_SKIP="false"

  what="$(_issue_spec_extract_section "$body" "What to build")"
  what="$(echo "$what" | sed '/^[[:space:]]*$/d')"
  if [[ -z "$what" ]]; then
    failures+="missing-what-to-build"$'\n'
  fi

  ac="$(_issue_spec_extract_section "$body" "Acceptance criteria")"
  if [[ -z "$(echo "$ac" | sed '/^[[:space:]]*$/d')" ]]; then
    failures+="missing-acceptance-criteria"$'\n'
  else
    n_ac="$(_issue_spec_count_checkbox_acs "$ac")"
    ISSUE_SPEC_CHECKBOX_COUNT="$n_ac"
    if [[ "$n_ac" -lt 2 ]]; then
      failures+="fewer-than-2-checkbox-acs"$'\n'
    fi
  fi

  blocked="$(_issue_spec_extract_section "$body" "Blocked by")"
  local blocked_fail
  blocked_fail="$(_issue_spec_check_blocked "$blocked" "$offline" || true)"
  if [[ -n "$blocked_fail" ]]; then
    while IFS= read -r bf; do
      [[ -n "$bf" ]] && failures+="$bf"$'\n'
    done <<<"$blocked_fail"
  fi

  local spec
  spec="$(_issue_spec_spec_before_stamp "$body")"
  ISSUE_SPEC_SHA256="$(_issue_spec_compute_sha256_16 "$spec")"
  if _issue_spec_afk_skip_eligible "$body"; then
    ISSUE_SPEC_AFK_SKIP="true"
  fi

  failures="${failures%$'\n'}"
  if [[ -n "$failures" ]]; then
    ISSUE_SPEC_RESULT="NEEDS_SPEC"
    ISSUE_SPEC_FAILURES="$failures"
    return 1
  fi

  ISSUE_SPEC_NOTES="semantic_review_required"
  return 0
}

_issue_spec_format_report() {
  local issue_num="${1:-}"
  local prefix=""
  [[ -n "$issue_num" ]] && prefix="Issue #${issue_num}: "

  echo "${prefix}${ISSUE_SPEC_RESULT}"
  echo "structural_checks: passed=$([[ "$ISSUE_SPEC_RESULT" != "NEEDS_SPEC" ]] && echo true || echo false)"
  echo "checkbox_ac_count: ${ISSUE_SPEC_CHECKBOX_COUNT}"
  echo "spec-sha256: ${ISSUE_SPEC_SHA256}"
  echo "afk-preflight-skip: ${ISSUE_SPEC_AFK_SKIP}"
  if [[ "$ISSUE_SPEC_RESULT" == "NEEDS_SPEC" && -n "$ISSUE_SPEC_FAILURES" ]]; then
    echo "structural_failures:"
    while IFS= read -r f; do
      [[ -n "$f" ]] && echo "  - $f"
    done <<<"$ISSUE_SPEC_FAILURES"
  fi
  if [[ "$ISSUE_SPEC_RESULT" != "NEEDS_SPEC" ]]; then
    echo "next: run semantic issue-spec-review (criteria testable, glossary, lock-doc alignment)"
  fi
}