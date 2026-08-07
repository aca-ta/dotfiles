#!/usr/bin/env python3
"""Minimal Databricks SQL MCP server backed by Statement Execution API.

This avoids the flaky `databricks auth token` and remote MCP paths. It reads the
workspace OAuth access token from Databricks CLI's token cache and calls the
Databricks REST API directly.
"""

from __future__ import annotations

import argparse
import configparser
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


READ_ONLY_KEYWORDS = {"SELECT", "SHOW", "DESCRIBE", "EXPLAIN", "WITH", "VALUES"}
FORBIDDEN_READ_ONLY_KEYWORDS = {
    "ALTER",
    "ANALYZE",
    "CACHE",
    "CALL",
    "COPY",
    "CREATE",
    "DELETE",
    "DROP",
    "GRANT",
    "INSERT",
    "MERGE",
    "OPTIMIZE",
    "REFRESH",
    "REPLACE",
    "RESTORE",
    "REVOKE",
    "SET",
    "TRUNCATE",
    "UNCACHE",
    "UPDATE",
    "USE",
    "VACUUM",
}


@dataclass(frozen=True)
class Settings:
    host: str
    profile: str
    token_cache: Path
    warehouse_id: str | None
    warehouse_name: str
    token_min_ttl_seconds: int
    auth_refresh_timeout_seconds: int
    wait_timeout: str


class DatabricksSqlClient:
    def __init__(self, settings: Settings) -> None:
        self.settings = settings
        self._warehouse_id: str | None = settings.warehouse_id

    def execute(self, statement: str, *, read_only: bool) -> dict[str, Any]:
        if read_only and not is_read_only_sql(statement):
            raise ValueError(
                "read-only tool only allows SELECT, SHOW, DESCRIBE, EXPLAIN, WITH, or VALUES"
            )

        payload = {
            "warehouse_id": self.warehouse_id(),
            "statement": statement,
            "wait_timeout": self.settings.wait_timeout,
            "disposition": "INLINE",
            "format": "JSON_ARRAY",
        }
        response = self._request("POST", "/api/2.0/sql/statements", payload)
        return self._format_statement_response(response)

    def poll(self, statement_id: str) -> dict[str, Any]:
        response = self._request("GET", f"/api/2.0/sql/statements/{statement_id}")
        return self._format_statement_response(response)

    def warehouse_id(self) -> str:
        if self._warehouse_id:
            return self._warehouse_id

        response = self._request("GET", "/api/2.0/sql/warehouses")
        warehouses = response.get("warehouses", [])
        if not warehouses:
            raise RuntimeError("no accessible Databricks SQL warehouses found")

        preferred_name = self.settings.warehouse_name.lower()

        def is_running(warehouse: dict[str, Any]) -> bool:
            return warehouse.get("state") == "RUNNING"

        def name_matches(warehouse: dict[str, Any]) -> bool:
            return str(warehouse.get("name", "")).lower() == preferred_name

        choices = [
            [w for w in warehouses if name_matches(w) and is_running(w)],
            [w for w in warehouses if is_running(w)],
            [w for w in warehouses if name_matches(w)],
            [w for w in warehouses if w.get("enable_serverless_compute")],
            warehouses,
        ]
        for group in choices:
            if group:
                warehouse_id = group[0].get("id")
                if warehouse_id:
                    self._warehouse_id = str(warehouse_id)
                    return self._warehouse_id

        raise RuntimeError("accessible Databricks SQL warehouses had no id")

    def _request(
        self, method: str, path: str, payload: dict[str, Any] | None = None
    ) -> dict[str, Any]:
        body = None if payload is None else json.dumps(payload).encode("utf-8")
        headers = {"Authorization": f"Bearer {self._access_token()}"}
        if body is not None:
            headers["Content-Type"] = "application/json"

        request = urllib.request.Request(
            self.settings.host + path,
            data=body,
            headers=headers,
            method=method,
        )
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                return json.loads(response.read())
        except urllib.error.HTTPError as error:
            details = error.read().decode("utf-8", errors="replace")
            raise RuntimeError(
                f"Databricks API {method} {path} failed: HTTP {error.code}: {details}"
            ) from error
        except urllib.error.URLError as error:
            raise RuntimeError(
                f"Databricks API {method} {path} failed: {error.reason}"
            ) from error

    def _access_token(self) -> str:
        last_error: RuntimeError | None = None
        for attempt in range(2):
            try:
                return self._cached_access_token()
            except RuntimeError as error:
                last_error = error
                if attempt == 0:
                    self._refresh_cli_auth()
                    continue
                raise

        if last_error:
            raise last_error
        raise RuntimeError("unable to load Databricks access token")

    def _cached_access_token(self) -> str:
        try:
            cache = json.loads(self.settings.token_cache.read_text())
        except OSError as error:
            raise RuntimeError(f"cannot read token cache: {self.settings.token_cache}") from error
        except json.JSONDecodeError as error:
            raise RuntimeError(f"invalid token cache JSON: {self.settings.token_cache}") from error

        host = self.settings.host.rstrip("/")
        entry = cache.get("tokens", {}).get(host) or cache.get("tokens", {}).get(host + "/")
        if not entry:
            raise RuntimeError(f"no Databricks token cache entry for {host}")

        token = entry.get("access_token")
        if not token:
            raise RuntimeError(f"Databricks token cache entry for {host} has no access_token")

        expiry = entry.get("expiry")
        if expiry:
            expires_at = parse_databricks_time(expiry)
            min_expiry = datetime.now(timezone.utc) + timedelta(
                seconds=self.settings.token_min_ttl_seconds
            )
            if expires_at <= min_expiry:
                raise RuntimeError(
                    "Databricks cached access token is expired or near expiry"
                )

        return str(token)

    def _refresh_cli_auth(self) -> None:
        try:
            subprocess.run(
                ["databricks", "current-user", "me", "--profile", self.settings.profile],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=self.settings.auth_refresh_timeout_seconds,
            )
        except (OSError, subprocess.CalledProcessError, subprocess.TimeoutExpired) as error:
            raise RuntimeError(
                "unable to refresh Databricks cached access token; "
                f"run `databricks auth login --profile {self.settings.profile}`"
            ) from error

    def _format_statement_response(self, response: dict[str, Any]) -> dict[str, Any]:
        statement_id = response.get("statement_id")
        status = response.get("status", {})
        state = status.get("state")
        result: dict[str, Any] = {
            "statement_id": statement_id,
            "status": status,
        }

        if state != "SUCCEEDED":
            return result

        manifest = response.get("manifest", {})
        columns = [
            column.get("name", "")
            for column in manifest.get("schema", {}).get("columns", [])
        ]
        rows = response.get("result", {}).get("data_array", [])
        records = [dict(zip(columns, row, strict=False)) for row in rows]
        result.update(
            {
                "row_count": len(records),
                "columns": columns,
                "rows": records,
            }
        )
        return result


def load_settings() -> Settings:
    profile = os.environ.get("DATABRICKS_WORKSPACE_PROFILE", "DEFAULT")
    config_file = Path(
        os.environ.get("DATABRICKS_CONFIG_FILE", str(Path.home() / ".databrickscfg"))
    )
    host = os.environ.get("DATABRICKS_HOST") or read_profile_host(config_file, profile)
    if not host:
        raise RuntimeError(f"host not found for Databricks profile {profile!r}")

    return Settings(
        host=host.rstrip("/"),
        profile=profile,
        token_cache=Path(
            os.environ.get(
                "DATABRICKS_TOKEN_CACHE",
                str(Path.home() / ".databricks" / "token-cache.json"),
            )
        ),
        warehouse_id=os.environ.get("DATABRICKS_SQL_WAREHOUSE_ID"),
        warehouse_name=os.environ.get("DATABRICKS_SQL_WAREHOUSE_NAME", "Default"),
        token_min_ttl_seconds=int(os.environ.get("DATABRICKS_TOKEN_MIN_TTL_SECONDS", "120")),
        auth_refresh_timeout_seconds=int(
            os.environ.get("DATABRICKS_AUTH_REFRESH_TIMEOUT_SECONDS", "20")
        ),
        wait_timeout=os.environ.get("DATABRICKS_SQL_WAIT_TIMEOUT", "30s"),
    )


def read_profile_host(config_file: Path, profile: str) -> str | None:
    parser = configparser.ConfigParser()
    parser.read(config_file)
    if parser.has_option(profile, "host"):
        return parser.get(profile, "host")
    if parser.has_option("DEFAULT", "host"):
        return parser.get("DEFAULT", "host")
    return None


def parse_databricks_time(value: str) -> datetime:
    # Databricks CLI cache uses RFC3339 with optional fractional seconds and
    # offsets like +09:00. Python accepts that after normalizing Z.
    return datetime.fromisoformat(value.replace("Z", "+00:00")).astimezone(timezone.utc)


def is_read_only_sql(statement: str) -> bool:
    stripped = strip_sql_comments_and_literals(statement).strip()
    if not stripped:
        return False

    body = stripped
    if body.endswith(";"):
        body = body[:-1].rstrip()
    if ";" in body:
        return False

    match = re.match(r"([A-Za-z]+)", body)
    if not match:
        return False

    first_keyword = match.group(1).upper()
    if first_keyword not in READ_ONLY_KEYWORDS:
        return False

    if first_keyword in {"SELECT", "WITH", "EXPLAIN", "VALUES"}:
        tokens = {
            token.upper()
            for token in re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\b", body)
        }
        if tokens & FORBIDDEN_READ_ONLY_KEYWORDS:
            return False

    return True


def strip_sql_comments_and_literals(statement: str) -> str:
    result: list[str] = []
    i = 0
    while i < len(statement):
        char = statement[i]
        next_char = statement[i + 1] if i + 1 < len(statement) else ""

        if char == "-" and next_char == "-":
            result.append(" ")
            i += 2
            while i < len(statement) and statement[i] not in "\r\n":
                i += 1
            continue

        if char == "/" and next_char == "*":
            result.append(" ")
            i += 2
            while i + 1 < len(statement) and not (
                statement[i] == "*" and statement[i + 1] == "/"
            ):
                i += 1
            i = min(i + 2, len(statement))
            continue

        if char in {"'", '"', "`"}:
            result.append(" ")
            i += 1
            while i < len(statement):
                if statement[i] == char:
                    if (
                        char in {"'", '"'}
                        and i + 1 < len(statement)
                        and statement[i + 1] == char
                    ):
                        i += 2
                        continue
                    i += 1
                    break
                if char == "'" and statement[i] == "\\":
                    i += 2
                    continue
                i += 1
            continue

        result.append(char)
        i += 1

    return "".join(result)


TOOLS = [
    {
        "name": "execute_sql_read_only",
        "description": (
            "Execute read-only SQL queries in Databricks Unity Catalog using "
            "Databricks Statement Execution API."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {"query": {"type": "string"}},
            "required": ["query"],
            "additionalProperties": False,
        },
    },
    {
        "name": "execute_sql",
        "description": (
            "Execute SQL queries in Databricks Unity Catalog using Databricks "
            "Statement Execution API."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {"query": {"type": "string"}},
            "required": ["query"],
            "additionalProperties": False,
        },
    },
    {
        "name": "poll_sql_result",
        "description": "Poll results for a long-running Databricks SQL statement.",
        "inputSchema": {
            "type": "object",
            "properties": {"statement_id": {"type": "string"}},
            "required": ["statement_id"],
            "additionalProperties": False,
        },
    },
]


def run_mcp() -> None:
    client = DatabricksSqlClient(load_settings())
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        try:
            request = json.loads(line)
        except json.JSONDecodeError:
            continue

        method = request.get("method")
        request_id = request.get("id")

        if request_id is None:
            # Notifications do not receive responses.
            continue

        try:
            if method == "initialize":
                send(
                    {
                        "jsonrpc": "2.0",
                        "id": request_id,
                        "result": {
                            "protocolVersion": "2025-03-26",
                            "capabilities": {"tools": {}},
                            "serverInfo": {
                                "name": "databricks-sql-rest",
                                "version": "1.0.0",
                            },
                        },
                    }
                )
            elif method == "tools/list":
                send({"jsonrpc": "2.0", "id": request_id, "result": {"tools": TOOLS}})
            elif method == "tools/call":
                send(
                    {
                        "jsonrpc": "2.0",
                        "id": request_id,
                        "result": handle_tool_call(client, request.get("params", {})),
                    }
                )
            else:
                send_error(request_id, -32601, f"method not found: {method}")
        except Exception as error:  # noqa: BLE001 - MCP should return tool errors as text.
            send(
                {
                    "jsonrpc": "2.0",
                    "id": request_id,
                    "result": {
                        "content": [{"type": "text", "text": str(error)}],
                        "isError": True,
                    },
                }
            )


def handle_tool_call(client: DatabricksSqlClient, params: dict[str, Any]) -> dict[str, Any]:
    name = params.get("name")
    arguments = params.get("arguments") or {}

    if name == "execute_sql_read_only":
        result = client.execute(str(arguments.get("query", "")), read_only=True)
    elif name == "execute_sql":
        result = client.execute(str(arguments.get("query", "")), read_only=False)
    elif name == "poll_sql_result":
        result = client.poll(str(arguments.get("statement_id", "")))
    else:
        return {
            "content": [{"type": "text", "text": f"unknown tool: {name}"}],
            "isError": True,
        }

    return {
        "content": [{"type": "text", "text": json.dumps(result, ensure_ascii=False, indent=2)}],
        "isError": False,
    }


def send(payload: dict[str, Any]) -> None:
    sys.stdout.write(json.dumps(payload, ensure_ascii=False, separators=(",", ":")) + "\n")
    sys.stdout.flush()


def send_error(request_id: Any, code: int, message: str) -> None:
    send({"jsonrpc": "2.0", "id": request_id, "error": {"code": code, "message": message}})


def run_cli() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", help="SQL query to execute")
    parser.add_argument("--poll", help="Statement ID to poll")
    parser.add_argument("--write", action="store_true", help="Allow non-read-only SQL")
    args = parser.parse_args()

    client = DatabricksSqlClient(load_settings())
    if args.poll:
        result = client.poll(args.poll)
    elif args.query:
        result = client.execute(args.query, read_only=not args.write)
    else:
        parser.error("provide --query or --poll")

    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    if len(sys.argv) > 1:
        run_cli()
    else:
        run_mcp()
