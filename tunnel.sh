#!/bin/bash

# Load configuration values from /etc/config/custom_ssh_tunnel
CONFIG_FILE="/etc/config/custom_ssh_tunnel"

# Get the current_server value from the UCI configuration
CURRENT_SERVER=$(uci get custom_ssh_tunnel.settings.current_server)

# Parse the current_server value into host, port, username, and password
HOST=$(echo "$CURRENT_SERVER" | awk -F'[:@]' '{print $1}')
PORT=$(echo "$CURRENT_SERVER" | awk -F'[:@]' '{print $2}')
USERNAME=$(echo "$CURRENT_SERVER" | awk -F'[:@]' '{print $3}')
PASSWORD=$(echo "$CURRENT_SERVER" | awk -F'[:@]' '{print $4}')

# Get additional configuration values
SNI=$(uci get custom_ssh_tunnel.settings.sni)
LOCAL_PORT=$(uci get custom_ssh_tunnel.settings.local_port)

# Create a temporary script to run the SSH tunnel command
cat <<EOF > /tmp/ssh_tunnel.sh
#!/bin/bash
sshpass -p '${PASSWORD}' ssh -o 'ProxyCommand=openssl s_client -connect ${HOST}:${PORT} -servername ${SNI} -quiet' -o ServerAliveInterval=30 -o StrictHostKeyChecking=no -N -D ${LOCAL_PORT} ${USERNAME}@${HOST}
EOF

# Make the temporary script executable
chmod +x /tmp/ssh_tunnel.sh

# Start a tmux session and run the SSH tunnel script
tmux new-session -d -s ssh_tunnel
sleep 2
tmux send-keys -t ssh_tunnel "/tmp/ssh_tunnel.sh" C-m
