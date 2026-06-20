#!/usr/bin/env bash
# issue-context-pack.sh — minimal per-issue context bundle for AFK subagents

_issue_pack_project_root() {
  echo "${ISSUE_PACK_PROJECT_ROOT:-$(pwd)}"
}

_issue_pack_extract_section() {
  local body="$1"
  local heading="$2"
  awk -v h="$heading" '
    BEGIN { found=0 }
    $0 ~ "^##[[:space:]]+" h "[[:space:]]*$" { found=1; next }
    found && /^##[[:space:]]+/ { exit }
    found { print }
  ' <<<"$body"
}

_issue_pack_lock_pointer() {
  local body="$1"
  local ptr journey
  ptr="$(_issue_pack_extract_section "$body" "Requirement lock")"
  if [[ -z "$(echo "$ptr" | sed '/^[[:space:]]*$/d')" ]]; then
    ptr="$(grep -iE 'requirement.lock|REQ-LOCK' <<<"$body" | head -1 || true)"
  fi
  journey="$(grep -oiE 'section:[[:space:]]*.+' <<<"$ptr" | head -1 | sed -E 's/section:[[:space:]]*//i' | sed 's/[[:space:]]*$//')"
  if [[ -n "$journey" ]]; then
    echo "$journey"
    return
  fi
  journey="$(grep -oE '###[[:space:]]+[^#]+' <<<"$ptr" | head -1 | sed 's/^###[[:space:]]*//')"
  [[ -n "$journey" ]] && echo "$journey"
}

_issue_pack_extract_lock_journey() {
  local lock_file="$1"
  local journey_name="$2"
  [[ -f "$lock_file" ]] || return 1
  [[ -z "$journey_name" ]] && return 1
  awk -v j="$journey_name" '
    BEGIN { found=0 }
    $0 ~ "^###[[:space:]]+" j "[[:space:]]*$" { found=1; next }
    found && /^###[[:space:]]+/ { exit }
    found { print }
  ' "$lock_file"
}

_issue_pack_spot_check_files() {
  local body="$1"
  local section files
  section="$(_issue_pack_extract_section "$body" "Files to spot-check")"
  if [[ -z "$(echo "$section" | sed '/^[[:space:]]*$/d')" ]]; then
    section="$(_issue_pack_extract_section "$body" "Files / components")"
  fi
  grep -oE '`[^`]+`' <<<"$section" | tr -d '`' || true
  grep -oE '[a-zA-Z0-9_./-]+\.(md|py|sh|ts|tsx|js|jsx|dart|yaml|json|go|rs)' <<<"$section" || true
}

_issue_pack_collect_adr_refs() {
  local text="$1"
  grep -oE 'docs/adr/[a-zA-Z0-9._-]+' <<<"$text" | sort -u
}

_issue_pack_context_terms() {
  local context_file="$1"
  local haystack="$2"
  [[ -f "$context_file" ]] || return 0
  while IFS= read -r line; do
    [[ "$line" =~ ^###[[:space:]]+ ]] || continue
    term="${line#\#\#\# }"
    term="${term%% *}"
    if grep -qiF "$term" <<<"$haystack"; then
      echo "$term"
    fi
  done < "$context_file"
}

_issue_pack_write_bundle() {
  local issue_num="$1"
  local title="$2"
  local body="$3"
  local out_dir="$4"

  local root lock_file journey lock_section spot context_file adr term
  root="$(_issue_pack_project_root)"
  mkdir -p "$out_dir"

  local out_file="$out_dir/issue-${issue_num}.md"
  local haystack="$body"

  {
    echo "# Context pack — issue #${issue_num}"
    echo ""
    [[ -n "$title" ]] && echo "**Title:** $title"
    echo ""
    echo "## Issue body (spec)"
    echo ""
    echo "$body"
    echo ""
  } >"$out_file"

  lock_file="$root/work/requirement-lock.md"
  journey="$(_issue_pack_lock_pointer "$body")"
  if [[ -f "$lock_file" ]]; then
    if [[ -n "$journey" ]]; then
      lock_section="$(_issue_pack_extract_lock_journey "$lock_file" "$journey" || true)"
      if [[ -z "$lock_section" ]]; then
        # try partial match on ### headings
        lock_section="$(awk -v j="$journey" '
          BEGIN { found=0 }
          tolower($0) ~ ("^###[[:space:]]+" tolower(j)) { found=1; next }
          found && /^###[[:space:]]+/ { exit }
          found { print }
        ' "$lock_file")"
      fi
    fi
    if [[ -n "$lock_section" ]]; then
      {
        echo "## Lock doc section: $journey"
        echo ""
        echo "$lock_section"
        echo ""
      } >>"$out_file"
      haystack+="$lock_section"
    fi
  fi

  {
    echo "## Files to spot-check"
    echo ""
  } >>"$out_file"
  spot="$(_issue_pack_spot_check_files "$body" | sort -u)"
  if [[ -n "$spot" ]]; then
    while IFS= read -r f; do
      [[ -n "$f" ]] && echo "- \`$f\`" >>"$out_file"
    done <<<"$spot"
  else
    echo "- _(none listed — use lock doc Files / components)_" >>"$out_file"
  fi
  echo "" >>"$out_file"

  context_file="$root/CONTEXT.md"
  if [[ -f "$context_file" ]]; then
    {
      echo "## CONTEXT.md excerpts (referenced terms)"
      echo ""
    } >>"$out_file"
    local terms
    terms="$(_issue_pack_context_terms "$context_file" "$haystack" | sort -u)"
    if [[ -n "$terms" ]]; then
      while IFS= read -r term; do
        [[ -z "$term" ]] && continue
        awk -v t="$term" '
          $0 ~ "^###[[:space:]]+" t "[[:space:]]*$" { p=1; print; next }
          p && /^###[[:space:]]+/ { exit }
          p { print }
        ' "$context_file" >>"$out_file"
        echo "" >>"$out_file"
      done <<<"$terms"
    else
      echo "_No glossary terms matched issue text._" >>"$out_file"
      echo "" >>"$out_file"
    fi
  fi

  {
    echo "## ADR references"
    echo ""
  } >>"$out_file"
  adr="$(_issue_pack_collect_adr_refs "$haystack" | sort -u)"
  if [[ -n "$adr" ]]; then
    while IFS= read -r path; do
      [[ -z "$path" ]] && continue
      if [[ -f "$root/$path" ]]; then
        echo "### $path" >>"$out_file"
        echo '```' >>"$out_file"
        head -40 "$root/$path" >>"$out_file"
        echo '```' >>"$out_file"
        echo "" >>"$out_file"
      else
        echo "- \`$path\` _(file missing)_" >>"$out_file"
      fi
    done <<<"$adr"
  else
    echo "_None referenced._" >>"$out_file"
    echo "" >>"$out_file"
  fi

  {
    echo "## Agent notes"
    echo ""
    echo "- Do **not** reload full \`docs/agents/*\` — use this pack + \`docs/agents/engineering-standards.md\` only when implementing."
    echo "- Spot-check listed files only; no broad requirement discovery."
  } >>"$out_file"

  echo "$out_file"
}