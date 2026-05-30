#!/usr/bin/env bash
# tmux のウィンドウ(タブ)ラベルを出力する。
#   - SSH 接続中(ssh/autossh/mosh)は接続先ホスト名を "@host" として表示
#   - それ以外は git リポジトリ名、無ければカレントディレクトリ名を表示
# usage: window-label.sh <pane_current_command> <pane_current_path> <pane_tty>

cmd="${1:-}"
path="${2:-}"
tty="${3#/dev/}"

case "$cmd" in
  ssh | autossh | mosh | mosh-client | sshpass)
    # pane の tty 上で動く ssh 系プロセスのコマンドラインから接続先を抽出する
    host=$(
      ps -t "$tty" -o args= 2>/dev/null \
        | grep -Em1 '(^|/)(ssh|autossh|mosh)( |$)' \
        | tr ' ' '\n' \
        | awk '
            NR==1 { next }                              # プログラム名を飛ばす
            skipnext { skipnext = 0; next }             # 直前が「引数を取るオプション」
            /^-[bcDeEFiIJLlMmOopQRSWw]$/ { skipnext = 1; next }
            /^-/ { next }                               # その他のフラグ
            { print; exit }                             # 最初の非オプション = 接続先
          '
    )
    host="${host##*@}" # user@ を除去
    if [ -n "$host" ]; then
      printf '@%s' "$host"
    else
      printf '%s' "$cmd"
    fi
    ;;
  *)
    if [ -n "$path" ] && cd "$path" 2>/dev/null; then
      basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    else
      printf '%s' "${cmd:-shell}"
    fi
    ;;
esac
