#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"

send_command() {
    tmux send-keys -t "$TMUX_SESSION" "$1" Enter
}

echo "$(date) - Starting scheduled daily restart..." >> "$LOG_DIR/restart.log"

send_command "/start_countdown 60 Server restarting for daily maintenance!"
send_command "/server_message_broadcast warning \"Server will restart for daily maintenance in 60 seconds!\""
sleep 60

send_command "/shutdown 0"
sleep 5
sudo systemctl restart "$SYSTEMCTL_SERVICE"

echo "$(date) - Daily restart complete." >> "$LOG_DIR/restart.log"
