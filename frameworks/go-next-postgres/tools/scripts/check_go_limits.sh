#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-apps/api}"

MAX_GO_FILE_LINES=250
MAX_FUNCTION_LINES=40
MAX_HANDLER_LINES=35
MAX_ROUTES_FILE_LINES=100
MAX_COMMENT_RATIO_PERCENT=5

if ! command -v awk >/dev/null 2>&1; then
  echo "awk is required" >&2
  exit 2
fi

if [ ! -d "$ROOT_DIR" ]; then
  echo "Directory not found: $ROOT_DIR" >&2
  exit 2
fi

violations=0

check_file_lines() {
  local file="$1"
  local lines
  lines="$(wc -l <"$file" | tr -d ' ')"

  if [ "$lines" -gt "$MAX_GO_FILE_LINES" ]; then
    echo "VIOLATION file_lines $file lines=$lines limit=$MAX_GO_FILE_LINES"
    violations=$((violations + 1))
  fi

  case "$(basename "$file")" in
    routes.go|routes_*.go)
      if [ "$lines" -gt "$MAX_ROUTES_FILE_LINES" ]; then
        echo "VIOLATION routes_file_lines $file lines=$lines limit=$MAX_ROUTES_FILE_LINES"
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
        if (line ~ /^[[:space:]]*\/\//) {
          comments++
          next
        }
        if (line ~ /\/\*/) {
          comments++
          if (line !~ /\*\//) inblock=1
        }
      }
      END {
        if (total==0) print 0;
        else print int((comments * 100) / total);
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
  local max_for_file="$MAX_FUNCTION_LINES"

  case "$(basename "$file")" in
    *_handler.go)
      max_for_file="$MAX_HANDLER_LINES"
      ;;
  esac

  awk -v max_len="$max_for_file" -v path="$file" '
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
      header=""
      violations=0
    }
    {
      line=$0
      ln=NR

      if (in_func==0 && line ~ /^[[:space:]]*func[[:space:]]/) {
        in_func=1
        seen_open=0
        depth=0
        start_line=ln
        header=line
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
            printf "VIOLATION function_lines %s lines=%d limit=%d start_line=%d signature=%s\n", path, fn_len, max_len, start_line, header
            violations++
          }
          in_func=0
          seen_open=0
          depth=0
          start_line=0
          header=""
        }
      }
    }
    END {
      if (violations > 0) exit 1
    }
  ' "$file" || violations=$((violations + 1))
}

while IFS= read -r file; do
  check_file_lines "$file"
  check_comment_ratio "$file"
  check_function_lengths "$file"
done < <(find "$ROOT_DIR" -type f -name '*.go' ! -path '*/vendor/*' ! -name '*.pb.go' | sort)

if [ "$violations" -gt 0 ]; then
  echo "Go limits check failed: violations=$violations"
  exit 1
fi

echo "Go limits check passed"
