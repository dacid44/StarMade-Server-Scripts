#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"

tmux send-keys -t "$TMUX_SESSION" "/shutdown 0" Enter
sleep 5
tmux kill-session -t "$TMUX_SESSION"
