#!/usr/bin/env bash
set -euo pipefail

state_dir="$HOME/.local/state/workmux/agents"
current_instance=$(tmux display-message -p '#{socket_path}')
current_pane=$(tmux display-message -p '#{pane_id}')
live_panes=$(tmux list-panes -a -F '#{pane_id}')

waiting_panes=$(
  jq -s -r --arg inst "$current_instance" --arg panes "$live_panes" '
    ($panes | split("\n")) as $live
    | map(select(.pane_key.instance == $inst and .status == "waiting" and ([.pane_key.pane_id] - $live | length) == 0))
    | sort_by(.session_name, .window_name)
    | .[].pane_key.pane_id
  ' "$state_dir"/*.json 2>/dev/null || true
)

if [ -z "$waiting_panes" ]; then
  tmux display-message "No agent needs input"
  exit 0
fi

next_pane=$(
  printf '%s\n' "$waiting_panes" | awk -v cur="$current_pane" '
    { panes[NR] = $0; if ($0 == cur) idx = NR }
    END {
      if (idx == "") { print panes[1]; exit }
      print panes[(idx % NR) + 1]
    }
  '
)

tmux switch-client -t "$next_pane"
