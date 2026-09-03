#!/usr/bin/env bash
set -e

usage="usage: tw.sh [-w|-p]"

die() {
  if [[ -n "$TMUX" ]]; then
    tmux display-message "tw: $*"
  else
    echo "tw: $*" >&2
  fi
  exit 1
}

if ! command -v tmux &>/dev/null; then
  die "tmux is not installed. Please install it first"
fi

if ! command -v sk &>/dev/null; then
  die "sk is not installed. Please install it first"
fi

mode=session

while [[ $# -gt 0 ]]; do
  case "$1" in
    -w | -p)
      [[ "$mode" == session ]] || die "only one of -w/-p may be given; $usage"
      case "$1" in
        -w) mode=window ;;
        -p) mode=pane ;;
      esac
      ;;
    -*)
      die "unknown option $1; $usage"
      ;;
    *)
      die "unexpected argument $1; $usage"
      ;;
  esac
  shift
done

[[ -n "$TMUX" ]] || die "tw.sh only works inside tmux"

case "$mode" in
  session)
    prompt="session> "
    listing=$(tmux list-sessions \
      -F "#{?session_attached,1,0}	#{session_name} (#{session_path})	#{session_id}" |
      awk -F'\t' '{ printf "%s%d  %s\t%s\n", ($1 == "1" ? "*" : " "), NR, $2, $3 }')
    ;;
  window)
    prompt="window> "
    listing=$(tmux list-windows \
      -F "#{?window_active,*, }#{window_index}  #{window_name}")
    ;;
  pane)
    prompt="pane> "
    listing=$(tmux list-panes -s \
      -F "#{?#{&&:#{pane_active},#{window_active}},1,0}	#{pane_current_command} (#{pane_current_path})	#{pane_id}" |
      awk -F'\t' '{ printf "%s%d  %s\t%s\n", ($1 == "1" ? "*" : " "), NR, $2, $3 }')
    ;;
esac

if [[ "$mode" == window ]]; then
  selected=$(printf '%s\n' "$listing" | sk --cycle --prompt "$prompt")
else
  selected=$(printf '%s\n' "$listing" | sk --cycle --prompt "$prompt" -d '\t' --with-nth 1)
fi

if [[ -z "$selected" ]]; then
  exit 0
fi

case "$mode" in
  session)
    tmux switch-client -t "${selected##*$'\t'}"
    ;;
  window)
    index_re='^[ *]*([0-9]+)'
    [[ "$selected" =~ $index_re ]] || die "could not parse window index from: $selected"
    tmux select-window -t ":${BASH_REMATCH[1]}"
    ;;
  pane)
    pane="${selected##*$'\t'}"
    tmux select-window -t "$pane"
    tmux select-pane -t "$pane"
    ;;
esac
