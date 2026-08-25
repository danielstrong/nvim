#!/usr/bin/env bash
set -euo pipefail

state_dir="$HOME/.local/state/workmux/agents"
current_instance=$(tmux display-message -p '#{socket_path}')
live_panes=$(tmux list-panes -a -F '#{pane_id}')

selected=$(
  jq -s -r --arg inst "$current_instance" --arg panes "$live_panes" '
    ($panes | split("\n")) as $live
    | map(select(.pane_key.instance == $inst and ([.pane_key.pane_id] - $live | length) == 0))
    | sort_by(.session_name, .window_name)
    | .[]
    | [
        (if .status == "working" then "🤖"
         elif .status == "waiting" then "💬"
         elif .status == "done" then "✅"
         else "?" end),
        .session_name,
        .window_name,
        (.workdir | sub("^" + env.HOME; "~")),
        .pane_key.pane_id
      ]
    | @tsv
  ' "$state_dir"/*.json 2>/dev/null \
  | fzf --delimiter='\t' --with-nth=1,2,3,4 --reverse --height=40% --prompt='agent> '
)

[ -z "$selected" ] && exit 0

pane_id=$(printf '%s' "$selected" | awk -F'\t' '{print $NF}')
tmux switch-client -t "$pane_id"
