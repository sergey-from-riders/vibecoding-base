#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-apps/web}"

MAX_TS_FILE_LINES=260
MAX_COMPONENT_LINES=70
MAX_FUNCTION_LINES=45
MAX_PAGE_FILE_LINES=120
MAX_COMMENT_RATIO_PERCENT=5
TOKENS_FILE="packages/tokens/tokens.json"
MAX_PROJECT_COLORS=5

if [ ! -d "$ROOT_DIR" ]; then
  echo "Directory not found: $ROOT_DIR" >&2
  exit 2
fi

violations=0

check_file_lines() {
  local file="$1"
  local lines
  lines="$(wc -l <"$file" | tr -d ' ')"

  if [ "$lines" -gt "$MAX_TS_FILE_LINES" ]; then
    echo "VIOLATION ts_file_lines $file lines=$lines limit=$MAX_TS_FILE_LINES"
    violations=$((violations + 1))
  fi

  case "$file" in
    */page.tsx)
      if [ "$lines" -gt "$MAX_PAGE_FILE_LINES" ]; then
        echo "VIOLATION page_file_lines $file lines=$lines limit=$MAX_PAGE_FILE_LINES"
        violations=$((violations + 1))
      fi
      ;;
  esac
}

check_comment_ratio() {
  local file="$1"
  local ratio
  ratio="$(
    awk '
      BEGIN { total=0; comments=0; inblock=0 }
      {
        total++
        line=$0
        if (inblock==1) {
          comments++
          if (line ~ /\*\//) inblock=0
          next
        }
        if (line ~ /^[[:space:]]*\/\//) { comments++; next }
        if (line ~ /\/\*/) {
          comments++
          if (line !~ /\*\//) inblock=1
        }
      }
      END {
        if (total==0) print 0
        else print int((comments * 100) / total)
      }
    ' "$file"
  )"

  if [ "$ratio" -gt "$MAX_COMMENT_RATIO_PERCENT" ]; then
    echo "VIOLATION comment_ratio $file ratio=${ratio}% limit=${MAX_COMMENT_RATIO_PERCENT}%"
    violations=$((violations + 1))
  fi
}

check_function_lengths() {
  local file="$1"
  local max_len="$MAX_FUNCTION_LINES"
  case "$file" in
    *.tsx) max_len="$MAX_COMPONENT_LINES" ;;
  esac

  awk -v max_len="$max_len" -v path="$file" '
    function count_char(s, c,   i, n) {
      n=0
      for (i=1; i<=length(s); i++) if (substr(s,i,1)==c) n++
      return n
    }
    BEGIN {
      in_block=0
      seen_open=0
      depth=0
      start=0
      sig=""
      errs=0
    }
    {
      line=$0
      ln=NR
      if (in_block==0 && (line ~ /^[[:space:]]*function[[:space:]]/ || line ~ /=>[[:space:]]*$/ || line ~ /=>[[:space:]]*{/)) {
        in_block=1
        seen_open=0
        depth=0
        start=ln
        sig=line
      }
      if (in_block==1) {
        opens=count_char(line, "{")
        closes=count_char(line, "}")
        if (opens > 0) seen_open=1
        if (seen_open==1) depth += opens
        if (seen_open==1) depth -= closes
        if (seen_open==1 && depth==0) {
          block_len=ln-start+1
          if (block_len > max_len) {
            printf "VIOLATION function_or_component_lines %s lines=%d limit=%d start_line=%d signature=%s\n", path, block_len, max_len, start, sig
            errs++
          }
          in_block=0
        }
      }
    }
    END { if (errs>0) exit 1 }
  ' "$file" || violations=$((violations + 1))
}

while IFS= read -r file; do
  check_file_lines "$file"
  check_comment_ratio "$file"
  check_function_lengths "$file"
done < <(find "$ROOT_DIR" -type f \( -name '*.ts' -o -name '*.tsx' \) ! -path '*/node_modules/*' | sort)

SRC_DIR="$ROOT_DIR/src"
if [ ! -d "$SRC_DIR" ]; then
  SRC_DIR="$ROOT_DIR"
fi

# Strict style and reuse checks
if rg -n "<(button|input|select|textarea|table|dialog)\\b" "$SRC_DIR" \
  -g '!**/components/ui/**' -g '!**/node_modules/**' >/tmp/rp_raw_interactive.out 2>/dev/null; then
  echo "VIOLATION raw_interactive_html_tags found"
  cat /tmp/rp_raw_interactive.out
  violations=$((violations + 1))
fi

if rg -n "\\bshadow\\b|drop-shadow|shadow-" "$SRC_DIR" -g '!**/node_modules/**' >/tmp/rp_shadow.out 2>/dev/null; then
  echo "VIOLATION shadow_usage_found"
  cat /tmp/rp_shadow.out
  violations=$((violations + 1))
fi

if rg -n "border-black|#000000|#000\\b" "$SRC_DIR" -g '!**/node_modules/**' >/tmp/rp_black_border.out 2>/dev/null; then
  echo "VIOLATION black_border_or_black_hex_found"
  cat /tmp/rp_black_border.out
  violations=$((violations + 1))
fi

if rg -n "transition-all" "$SRC_DIR" -g '!**/node_modules/**' >/tmp/rp_transition_all.out 2>/dev/null; then
  echo "VIOLATION transition_all_found"
  cat /tmp/rp_transition_all.out
  violations=$((violations + 1))
fi

if rg -n "style=\\{\\{" "$SRC_DIR" -g '!**/node_modules/**' >/tmp/rp_inline_style.out 2>/dev/null; then
  echo "VIOLATION inline_style_found"
  cat /tmp/rp_inline_style.out
  violations=$((violations + 1))
fi

if rg -n "\\bfetch\\(" "$SRC_DIR" -g '!**/lib/api-client/**' -g '!**/server/**' -g '!**/node_modules/**' >/tmp/rp_fetch.out 2>/dev/null; then
  echo "VIOLATION fetch_outside_shared_api_client"
  cat /tmp/rp_fetch.out
  violations=$((violations + 1))
fi

if [ -f "$TOKENS_FILE" ]; then
  color_count="$( (rg -n '"\$type":[[:space:]]*"color"' "$TOKENS_FILE" || true) | wc -l | tr -d ' ' )"
  if [ "$color_count" -gt "$MAX_PROJECT_COLORS" ]; then
    echo "VIOLATION token_color_count colors=$color_count limit=$MAX_PROJECT_COLORS"
    violations=$((violations + 1))
  fi
fi

if [ "$violations" -gt 0 ]; then
  echo "Web limits check failed: violations=$violations"
  exit 1
fi

echo "Web limits check passed"
