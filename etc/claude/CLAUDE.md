# CLAUDE.md

全プロジェクト共通の個人設定。プロジェクト固有のルール（リポジトリの `CLAUDE.md` / `AGENTS.md`）が
これと矛盾する場合は、**プロジェクト側を優先**する。

## Databricks

### SQL の実行は MCP ツールを使う

SQL の実行には MCP ツール `mcp__databricks_sql__execute_sql_read_only` を使う。
**scratchpad にシェルラッパー（`dbsql.sh` / `dbsql_async.sh` 等）を作らない。**

scratchpad はセッションごとにパスが変わる一時領域なので、ラッパーを作ると SQL 文が
1文字違うたびに新しい許可要求が発生し、プロジェクトの `.claude/settings.local.json` に
使い捨てのルールが際限なく蓄積する。

長時間クエリは MCP 側が非同期に切り替わるので、`mcp__databricks_sql__poll_sql_result`
で結果を取得する。タイムアウトを理由にシェルへ迂回しない。

### 定義変更は明示的な許可を得るまで実行しない

以下は読み取りではなく**変更**であり、既定は「都度確認」。

- `databricks api post|patch|put|delete`（特に `/api/2.1/jobs/update`、`/jobs/reset`）
- `databricks jobs reset|update|create|delete`
- `databricks bundle deploy`
- `databricks pipelines start-update|delete`

**「どうすれば〜できますか」「〜するには何が必要ですか」は方法を問う質問であって、
実行の許可ではない。** 方法を答えるにとどめ、実行してよいか確認すること。

変更してよい場合も、実行前に現定義をバックアップし（`databricks jobs get <id> -o json`）、
実行後に何をどう変えたかを報告する。

### 接続先

プロファイルは `DEFAULT` を使う（`~/.databrickscfg`）。
個別に切り替える必要がある場合は、その理由を明示してから切り替える。

## 許可設定

`.claude/settings.local.json` に「don't ask again」で溜めるルールは、
**動詞を問わないワイルドカード（`Bash(databricks api *)` 等）にしない**。
書き込み系まで無言で通るようになる。読み取り専用に絞ったルールを提案すること。
