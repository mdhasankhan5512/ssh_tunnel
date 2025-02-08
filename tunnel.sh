#!/bin/bash

# Load configuration values from /etc/config/custom_ssh_tunnel
CONFIG_FILE="/etc/config/custom_ssh_tunnel"
HOST=$(uci get custom_ssh_tunnel.settings.host)
PORT=$(uci get custom_ssh_tunnel.settings.port)
USERNAME=$(uci get custom_ssh_tunnel.settings.username)
PASSWORD=$(uci get custom_ssh_tunnel.settings.password)
SNI=$(uci get custom_ssh_tunnel.settings.sni)
LOCAL_PORT=$(uci get custom_ssh_tunnel.settings.local_port)

# Start a tmux session and run the SSH tunnel
tmux new-session -d -s ssh_tunnel
sleep 4
tmux send-keys -t ssh_tunnel "sshpass -p '${PASSWORD}' ssh -o 'ProxyCommand=openssl s_client -connect ${HOST}:${PORT} -servername ${SNI} -quiet' -o ServerAliveInterval=30 -o StrictHostKeyChecking=no -N -D ${LOCAL_PORT} ${USERNAME}@${HOST}" C-m
sleep 3
service redsocks start
sleep 3
service redsocks restart
