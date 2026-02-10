#!/bin/bash -euC
set -eu

# Only login if the cached token is invalid/expired
if ! databricks auth token -p "$DATABRICKS_WORKSPACE_PROFILE" > /dev/null 2>&1; then
  databricks auth login -p "$DATABRICKS_WORKSPACE_PROFILE"
fi
DATABRICKS_WORKSPACE_HOSTNAME=`databricks auth describe -p $DATABRICKS_WORKSPACE_PROFILE -o json | jq -r '.details.host'`
DATABRICKS_PERSONAL_ACCESS_TOKEN=`databricks auth token -p $DATABRICKS_WORKSPACE_PROFILE -o json | jq -r '.access_token'`

# Launch MCP remote for Databricks SQL
npx mcp-remote \
    $DATABRICKS_WORKSPACE_HOSTNAME/api/2.0/mcp/sql \
    --header "Authorization: Bearer $DATABRICKS_PERSONAL_ACCESS_TOKEN"

