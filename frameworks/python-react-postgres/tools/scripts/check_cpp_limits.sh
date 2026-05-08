#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-apps/desktop/qt}"

MAX_CPP_FILE_LINES=260
MAX_HPP_FILE_LINES=260
MAX_FUNCTION_LINES=45
MAX_COMMENT_RATIO_PERCENT=5

if [ ! -d "$ROOT_DIR" ]; then
  echo "Directory not found: $ROOT_DIR" >&2
  exit 2
fi

violations=0

check_file_lines() {
  local file="$1"
  local lines
  lines="$(wc -l <"$file" | tr -d ' ')"
  case "$file" in
    *.cpp|*.cc|*.cxx)
      if [ "$lines" -gt "$MAX_CPP_FILE_LINES" ]; then
        echo "VIOLATION cpp_file_lines $file lines=$lines limit=$MAX_CPP_FILE_LINES"
        violations=$((violations + 1))
      fi
      ;;
    *.h|*.hpp|*.hh)
      if [ "$lines" -gt "$MAX_HPP_FILE_LINES" ]; then
        echo "VIOLATION hpp_file_lines $file lines=$lines limit=$MAX_HPP_FILE_LINES"
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
  awk -v max_len="$MAX_FUNCTION_LINES" -v path="$file" '
    function count_char(s, c,   i, n) {
      n=0
      for (i=1; i<=length(s); i++) if (substr(s,i,1)==c) n++
      return n
    }
    BEGIN {
      in_func=0
      seen_open=0
      depth=0
      start_line=0
      sig=""
      errs=0
    }
    {
      line=$0
      ln=NR
      if (in_func==0 && line ~ /\)[[:space:]]*(const[[:space:]]*)?(\{|$)/ && line !~ /^[[:space:]]*(if|for|while|switch|catch)\b/) {
        if (line ~ /^[[:space:]]*[A-Za-z_].*\(/ || line ~ /^[[:space:]]*[~A-Za-z_][A-Za-z0-9_:<>*&[:space:]]*\(/) {
          in_func=1
          seen_open=0
          depth=0
          start_line=ln
          sig=line
        }
      }
      if (in_func==1) {
        opens=count_char(line, "{")
        closes=count_char(line, "}")
        if (opens > 0) seen_open=1
        if (seen_open==1) depth += opens
        if (seen_open==1) depth -= closes
        if (seen_open==1 && depth==0) {
          fn_len=ln-start_line+1
          if (fn_len > max_len) {
            printf "VIOLATION function_lines %s lines=%d limit=%d start_line=%d signature=%s\n", path, fn_len, max_len, start_line, sig
            errs++
          }
          in_func=0
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
done < <(find "$ROOT_DIR" -type f \( -name '*.cpp' -o -name '*.cc' -o -name '*.cxx' -o -name '*.h' -o -name '*.hpp' -o -name '*.hh' \) | sort)

check_pattern_zero() {
  local name="$1"
  local pattern="$2"
  if rg -n "$pattern" "$ROOT_DIR" -g '!**/build/**' -g '!**/CMakeFiles/**' >/tmp/rp_cpp_check.out 2>/dev/null; then
    echo "VIOLATION $name"
    cat /tmp/rp_cpp_check.out
    violations=$((violations + 1))
  fi
}

check_pattern_zero "raw_new_detected" "\\bnew\\b"
check_pattern_zero "raw_delete_detected" "\\bdelete\\b"
check_pattern_zero "malloc_free_detected" "\\bmalloc\\b|\\bfree\\b"
check_pattern_zero "unique_ptr_release_detected" "unique_ptr<.*>.*\\.release\\("
check_pattern_zero "shared_ptr_qobject_detected" "shared_ptr\\s*<\\s*Q[A-Za-z0-9_]+\\s*>"

if [ "$violations" -gt 0 ]; then
  echo "C++ limits check failed: violations=$violations"
  exit 1
fi

echo "C++ limits check passed"
