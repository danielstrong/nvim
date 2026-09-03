#!/usr/bin/env bash
set -e

config_file="$HOME/.config/tmux/create-session.conf"

die() {
  if [[ -n "$TMUX" ]]; then
    tmux display-message "to: $*"
  else
    echo "to: $*" >&2
  fi
  exit 1
}

if ! command -v tmux &>/dev/null; then
  die "tmux is not installed. Please install it first"
fi

if ! command -v sk &>/dev/null; then
  die "sk is not installed. Please install it first"
fi

if [[ -f "$config_file" ]]; then
  source "$config_file"
else
  die "Config file not found: $config_file"
fi

list_sessions() {
  local raw
  raw=$(tmux list-sessions \
    -F "#{?session_attached,1,0}	#{session_name}	#{session_path}	#{session_id}" 2>/dev/null) || return 0
  [[ -n "$raw" ]] || return 0

  paste -d'\t' \
    <(printf '%s\n' "$raw" |
      awk -F'\t' '{ printf "%s%d\t%s\t(%s)\n", ($1 == "1" ? "*" : " "), NR, $2, $3 }' |
      column -t -s '	') \
    <(printf '%s\n' "$raw" | awk -F'\t' '{ printf "session\t%s\n", $4 }')
}

list_dirs() {
  for path in "${TS_SEARCH_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
      find "$path" -mindepth 1 -maxdepth 1 -path '*/.git' -prune -o -type d -print
    fi
  done

  for path in "${TS_EXTRA_PATHS[@]}"; do
    if [[ -d "$path" ]]; then
      echo "$path"
    fi
  done
}

selected=$({
  list_sessions
  list_dirs | awk '{ printf "%s\tdir\t%s\n", $0, $0 }'
} | sk --cycle --prompt "session> " -d '\t' --with-nth 1)

if [[ -z "$selected" ]]; then
  exit 0
fi

IFS=$'\t' read -r _ kind target <<<"$selected"

case "$kind" in
  session) ;;
  dir)
    session=$(basename "$target" | tr . _)
    tmux has-session -t "=$session" 2>/dev/null ||
      tmux new-session -ds "$session" -c "$target"
    target="=$session"
    ;;
  *)
    die "could not parse selection: $selected"
    ;;
esac

if [[ -n "$TMUX" ]]; then
  tmux switch-client -t "$target"
else
  tmux attach-session -t "$target"
fi
