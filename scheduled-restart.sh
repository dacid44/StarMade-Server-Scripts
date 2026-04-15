#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/.env"

if [[ -x "$(command -v docker)" ]] && docker inspect -f '{{.State.Status}}' $CONTAINER_NAME; then
    if ! [[ -x "$(command -v script)" ]]; then
        echo "script command not found, please install util-linux[-script]"
    fi
    IS_DOCKER=1
fi

send_command() {
    if [[ "$IS_DOCKER" == "1" ]]; then
        echo "$1" | script -E never -qefc 'docker attach --detach-keys=ctrl-d starmade' /dev/null
    else
        tmux send-keys -t "$TMUX_SESSION" "$1" Enter
    fi
}

echo "$(date) - Starting scheduled daily restart..." >> "$LOG_DIR/restart.log"

send_command "/start_countdown 60 Server restarting for daily maintenance!"
send_command "/server_message_broadcast warning \"Server will restart for daily maintenance in 60 seconds!\""
sleep 60

send_command "/shutdown 0"
if [[ "$IS_DOCKER" != "1" ]]; then
    sleep 5
    sudo systemctl restart "$SYSTEMCTL_SERVICE"
fi

echo "$(date) - Daily restart complete." >> "$LOG_DIR/restart.log"
