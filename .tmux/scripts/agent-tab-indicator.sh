#!/usr/bin/env bash
# Per-tab agent indicator for window-status-format.
# Usage: agent-tab-indicator.sh <window_id>
# Outputs a spinner frame (running), icon (needs-input/done), or nothing.

set -euo pipefail

WINDOW_ID="${1:-}"
[ -z "$WINDOW_ID" ] && exit 0

tmux_get_env() {
  tmux show-environment -g "$1" 2>/dev/null | sed 's/^[^=]*=//' || true
}

SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Find agent panes in this window
found_state=""
found_agent=""
while IFS=' ' read -r pane_id _; do
  state=$(tmux_get_env "TMUX_AGENT_PANE_${pane_id}_STATE")
  agent=$(tmux_get_env "TMUX_AGENT_PANE_${pane_id}_AGENT")
  if [ -n "$state" ] && [ "$state" != "off" ]; then
    found_state="$state"
    found_agent="$agent"
    # Prefer running/needs-input over done
    case "$state" in running|needs-input) break ;; esac
  fi
done < <(tmux list-panes -t "$WINDOW_ID" -F '#{pane_id} #{pane_tty}' 2>/dev/null)

# Fallback: process detection if no hook state found
if [ -z "$found_state" ]; then
  processes="opencode,claude,codex,aider"
  while IFS=' ' read -r _ pane_tty _; do
    [ -z "$pane_tty" ] && continue
    IFS=',' read -ra procs <<< "$processes"
    for proc in "${procs[@]}"; do
      if ps -t "$(basename "$pane_tty")" -o command= 2>/dev/null | grep -qw "$proc"; then
        found_state="detected"
        found_agent="$proc"
        break 2
      fi
    done
  done < <(tmux list-panes -t "$WINDOW_ID" -F '#{pane_id} #{pane_tty} #{pane_active}' 2>/dev/null)
fi

[ -z "$found_state" ] && exit 0

case "$found_state" in
  running)
    frame_idx=$(tmux_get_env "TMUX_AGENT_ANIMATION_FRAME")
    # Map 0-6 bounce to 0-9 spinner frames
    if [ -n "$frame_idx" ]; then
      idx=$(( frame_idx % ${#SPINNER_FRAMES[@]} ))
    else
      # No animation daemon — use epoch-based frame
      idx=$(( $(date +%s) % ${#SPINNER_FRAMES[@]} ))
    fi
    printf '%s ' "${SPINNER_FRAMES[$idx]}"
    ;;
  needs-input)
    printf '⚠ '
    ;;
  done)
    printf '✔ '
    ;;
  detected)
    printf '💻 '
    ;;
esac
