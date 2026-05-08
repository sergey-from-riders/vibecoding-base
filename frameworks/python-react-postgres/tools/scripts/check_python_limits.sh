#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-apps/api}"

MAX_PY_FILE_LINES=250
MAX_FUNCTION_LINES=45
MAX_HANDLER_LINES=35
MAX_ROUTES_FILE_LINES=120
MAX_COMMENT_RATIO_PERCENT=8

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

  if [ "$lines" -gt "$MAX_PY_FILE_LINES" ]; then
    echo "VIOLATION file_lines $file lines=$lines limit=$MAX_PY_FILE_LINES"
    violations=$((violations + 1))
  fi

  case "$(basename "$file")" in
    routes.py|router.py|routers.py)
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
      BEGIN { total=0; comments=0; indoc=0 }
      {
        total++
        line=$0
        if (indoc==1) {
          comments++
          if (line ~ /"""/ || line ~ /'\'''\'''\''/) indoc=0
          next
        }
        if (line ~ /^[[:space:]]*#/) {
          comments++
          next
        }
        if (line ~ /^[[:space:]]*("""|'\'''\'''\'' )/) {
          comments++
          if (line !~ /("""|'\'''\'''\'' )[[:space:]]*$/) indoc=1
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
    *_handler.py|handlers.py)
      max_for_file="$MAX_HANDLER_LINES"
      ;;
  esac

  awk -v max_len="$max_for_file" -v path="$file" '
    function indent_len(s,   m) {
      match(s, /^[ ]*/)
      return RLENGTH
    }
    BEGIN {
      in_func=0
      start_line=0
      base_indent=0
      header=""
      violations=0
    }
    {
      line=$0
      ln=NR

      if (in_func==0 && line ~ /^[ ]*(async[ ]+)?def[ ]+[A-Za-z_][A-Za-z0-9_]*[ ]*\(/) {
        in_func=1
        start_line=ln
        base_indent=indent_len(line)
        header=line
        next
      }

      if (in_func==1 && ln > start_line) {
        if (line ~ /^[ ]*$/) next
        current_indent=indent_len(line)
        if (current_indent <= base_indent && line !~ /^[ ]*@/) {
          fn_len=ln-start_line
          if (fn_len > max_len) {
            printf "VIOLATION function_lines %s lines=%d limit=%d start_line=%d signature=%s\n", path, fn_len, max_len, start_line, header
            violations++
          }
          in_func=0
          start_line=0
          base_indent=0
          header=""

          if (line ~ /^[ ]*(async[ ]+)?def[ ]+[A-Za-z_][A-Za-z0-9_]*[ ]*\(/) {
            in_func=1
            start_line=ln
            base_indent=indent_len(line)
            header=line
          }
        }
      }
    }
    END {
      if (in_func==1) {
        fn_len=NR-start_line+1
        if (fn_len > max_len) {
          printf "VIOLATION function_lines %s lines=%d limit=%d start_line=%d signature=%s\n", path, fn_len, max_len, start_line, header
          violations++
        }
      }
      if (violations > 0) exit 1
    }
  ' "$file" || violations=$((violations + 1))
}

while IFS= read -r file; do
  check_file_lines "$file"
  check_comment_ratio "$file"
  check_function_lengths "$file"
done < <(find "$ROOT_DIR" -type f -name '*.py' ! -path '*/.venv/*' ! -path '*/__pycache__/*' | sort)

if [ "$violations" -gt 0 ]; then
  echo "Python limits check failed: violations=$violations"
  exit 1
fi

echo "Python limits check passed"
