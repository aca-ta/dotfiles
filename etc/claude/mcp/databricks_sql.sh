#!/usr/bin/env bash
set -euo pipefail

script_path="${BASH_SOURCE[0]}"
while [[ -L "$script_path" ]]; do
  script_dir="$(cd "$(dirname "$script_path")" && pwd)"
  link_target="$(readlink "$script_path")"
  if [[ "$link_target" == /* ]]; then
    script_path="$link_target"
  else
    script_path="$script_dir/$link_target"
  fi
done

script_dir="$(cd "$(dirname "$script_path")" && pwd)"
# 標準ライブラリのみ・Python 3.9+ で動くので、マシンごとの差を吸収して探す。
# DATABRICKS_SQL_MCP_PYTHON があれば最優先する。
if [[ -n "${DATABRICKS_SQL_MCP_PYTHON:-}" ]]; then
  python_bin="$DATABRICKS_SQL_MCP_PYTHON"
else
  python_bin=""
  for candidate in "$(command -v python3 || true)" /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3; do
    # pyenv の shim などはパスがあっても実行できないことがあるので、実際に動くか確かめる
    if [[ -n "$candidate" && -x "$candidate" ]] \
      && "$candidate" -c 'import sys; sys.exit(sys.version_info < (3, 9))' >/dev/null 2>&1; then
      python_bin="$candidate"
      break
    fi
  done
  if [[ -z "$python_bin" ]]; then
    echo "databricks_sql.sh: Python 3.9+ が見つかりません。DATABRICKS_SQL_MCP_PYTHON で指定してください" >&2
    exit 1
  fi
fi

exec "$python_bin" "$script_dir/databricks_sql_rest_mcp.py" "$@"
