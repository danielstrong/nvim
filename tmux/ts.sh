#!/usr/bin/env bash
# set -euo pipefail
set -e

config_file="$HOME/.config/tmux/create-session.conf"

if [[ -f "$config_file" ]]; then
  source "$config_file"
else
  echo "Config file not found: $config_file"
  exit 1
fi

if ! command -v tmux &>/dev/null; then
  echo "tmux is not installed. Please install it first"
  exit 1
fi

if ! command -v sk &>/dev/null; then
  echo "sk is not installed. Please install it first"
  exit 1
fi

has_session() {
  tmux has-session -t "$1" 2>/dev/null
}

find_dirs() {
  tmux list-sessions -F "[TMUX] #{session_name}" 2>/dev/null

  for path in "${TS_SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
      find "$path" -mindepth 1 -maxdepth 1 -path '*/.git' -prune -o -type d -print
    fi
  done

  for path in "${TS_SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
      echo "$path"
    fi
  done
}

if [[ -n "$1" ]]; then
  selected="$1"
else
  selected=$(find_dirs | sk --cycle)
fi

if [[ -z "$selected" ]]; then
  exit 0
fi

if [[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
  selected="${BASH_REMATCH[1]}"
fi

selected_name=$(basename "$selected" | tr . _)

if ! has_session "$selected_name"; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z "$TMUX" ]]; then
  tmux attach-session -t "$selected_name"
else
  tmux switch-client -t "$selected_name"
fi
