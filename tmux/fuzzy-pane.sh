#!/usr/bin/env bash
set -e

max_depth=8

die() {
  if [[ -n "$TMUX" ]]; then
    tmux display-message "ti: $*"
  else
    echo "ti: $*" >&2
  fi
  exit 1
}

if ! command -v tmux &>/dev/null; then
  die "tmux is not installed. Please install it first"
fi

if ! command -v sk &>/dev/null; then
  die "sk is not installed. Please install it first"
fi

list_panes() {
  local scope=-s
  local prefix=""
  if [[ -z "$TMUX" ]]; then
    scope=-a
    prefix="#{session_name}: "
  fi

  local raw
  raw=$(tmux list-panes "$scope" \
    -F "#{?#{&&:#{pane_active},#{window_active}},1,0}	${prefix}#{window_name}	#{pane_current_command}	#{pane_current_path}	#{pane_id}" 2>/dev/null) || return 0
  [[ -n "$raw" ]] || return 0

  paste -d'\t' \
    <(printf '%s\n' "$raw" |
      awk -F'\t' '{ printf "%s%d\t%s\t%s\t(%s)\n", ($1 == "1" ? "*" : " "), NR, $2, $3, $4 }' |
      column -t -s '	') \
    <(printf '%s\n' "$raw" | awk -F'\t' '{ printf "pane\t%s\n", $5 }')
}

list_dirs() {
  local root
  if root=$(git rev-parse --show-toplevel 2>/dev/null); then
    find "$root" -maxdepth "$max_depth" -name .git -prune -o -type d -print |
      git -C "$root" check-ignore --stdin --non-matching --verbose |
      awk -F'\t' '$1 == "::" { printf "%s\tdir\t%s\n", $2, $2 }'
  else
    find "$PWD" -maxdepth "$max_depth" \
      \( -name node_modules -o -name .git \) -prune -o -type d -print |
      awk '{ printf "%s\tdir\t%s\n", $0, $0 }'
  fi
}

selected=$({
  list_panes
  list_dirs
} | sk --cycle --prompt "pane> " -d '\t' --with-nth 1)

if [[ -z "$selected" ]]; then
  exit 0
fi

IFS=$'\t' read -r _ kind target <<<"$selected"

case "$kind" in
pane)
  tmux select-window -t "$target"
  tmux select-pane -t "$target"
  if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$target"
  fi
  ;;
dir)
  if [[ -n "$TMUX" ]]; then
    tmux new-window -c "$target" -n "$(basename "$target")"
  else
    session=$(basename "$target" | tr . _)
    tmux has-session -t "=$session" 2>/dev/null ||
      tmux new-session -ds "$session" -c "$target"
    tmux attach-session -t "=$session"
  fi
  ;;
*)
  die "could not parse selection: $selected"
  ;;
esac
