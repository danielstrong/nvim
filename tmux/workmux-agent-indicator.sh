#!/usr/bin/env bash
set -euo pipefail

state_dir="$HOME/.local/state/workmux/agents"
current_instance=$(tmux display-message -p '#{socket_path}')
current_pane=$(tmux display-message -p '#{pane_id}')
live_panes=$(tmux list-panes -a -F '#{pane_id}')

waiting_panes=$(
  jq -s -r --arg inst "$current_instance" --arg panes "$live_panes" --arg cur "$current_pane" '
    ($panes | split("\n")) as $live
    | map(select(.pane_key.instance == $inst and .status == "waiting" and .pane_key.pane_id != $cur and ([.pane_key.pane_id] - $live | length) == 0))
    | .[].pane_key.pane_id
  ' "$state_dir"/*.json 2>/dev/null || true
)

if [ -n "$waiting_panes" ]; then
  printf 'a'
fi
