import os
import re
import time
import subprocess
from datetime import datetime

CONFIG_FILE = "/etc/config/custom_ssh_tunnel"
CHECK_URL = "https://facebook.com"  # Changed to facebook.com
SERVICE_NAME = "zzz"
LOG_FILE = "/var/log/custom_ssh_tunnel.log"

def log_message(message):
    """Logs messages to a file, recreating the log file every day."""
    today_str = datetime.now().strftime("%Y-%m-%d")
    if not os.path.exists(LOG_FILE) or time.localtime(os.stat(LOG_FILE).st_mtime).tm_mday != time.localtime().tm_mday:
        open(LOG_FILE, "w").close()  # Clear log file daily

    with open(LOG_FILE, "a") as log:
        log.write(f"{datetime.now()} - {message}\n")
    print(message)


def read_config():
    """Reads the configuration file and extracts relevant settings."""
    with open(CONFIG_FILE, "r") as file:
        lines = file.readlines()

    config = {"current_server": None, "sni": None, "local_port": None, "servers": []}

    for line in lines:
        line = line.strip()
        if line.startswith("option current_server"):
            config["current_server"] = line.split("'")[1]
        elif line.startswith("option sni"):
            config["sni"] = line.split("'")[1]
        elif line.startswith("option local_port"):
            config["local_port"] = line.split("'")[1]
        elif line.startswith("list servers"):
            config["servers"].append(line.split("'")[1])

    return config


def check_internet():
    """Checks internet connectivity using curl."""
    try:
        result = subprocess.run(
            ["curl", "-s", "--head", CHECK_URL],
            capture_output=True,
            timeout=30  # Set a timeout to avoid hanging indefinitely
        )

        # Return True if successful response (HTTP status code 200 or similar)
        if result.returncode == 0 and "HTTP/2 301" in result.stdout.decode():
            return True
        else:
            return False
    except subprocess.TimeoutExpired:
        log_message("Curl command timed out. Internet may be unavailable.")
        return False
    except Exception as e:
        log_message(f"Error checking internet: {e}")
        return False


def parse_server(server):
    """Parses a server entry and returns its details."""
    match = re.match(r"(.+?):(.+?)@(.+?):(.+?):(\d{2}-\d{2}-\d{4})", server)
    if match:
        return {
            "host": match.group(1),
            "port": match.group(2),
            "username": match.group(3),
            "password": match.group(4),
            "expiry": datetime.strptime(match.group(5), "%d-%m-%Y")
        }
    return None


def remove_expired_servers(config):
    """Removes expired servers from the configuration."""
    today = datetime.today()
    new_servers = []
    for server in config["servers"]:
        parsed = parse_server(server)
        if parsed and parsed["expiry"] >= today:
            new_servers.append(server)
        else:
            log_message(f"Removing expired server: {server}")

    config["servers"] = new_servers

    if config["current_server"] and parse_server(config["current_server"])["expiry"] < today:
        log_message(f"Current server expired: {config['current_server']}")
        config["current_server"] = None

    write_config(config)


def write_config(config):
    """Writes the updated configuration back to the file."""
    with open(CONFIG_FILE, "w") as file:
        file.write("config tunnel 'settings'\n")
        file.write(f"    option current_server '{config['current_server']}'\n")
        file.write(f"    option sni '{config['sni']}'\n")
        file.write(f"    option local_port '{config['local_port']}'\n")
        for server in config["servers"]:
            file.write(f"    list servers '{server}'\n")


def restart_service():
    """Restarts the service."""
    log_message("Restarting service...")
    os.system(f"service {SERVICE_NAME} stop")
    os.system(f"service {SERVICE_NAME} start")


def switch_server(config):
    """Switches to the next available server or loops back to the first server if none work."""
    if config["servers"]:
        if config["current_server"] in config["servers"]:
            config["servers"].append(config["servers"].pop(0))  # Rotate servers
        config["current_server"] = config["servers"][0]
        log_message(f"Switching to new server: {config['current_server']}")
        write_config(config)
        restart_service()
    else:
        log_message("No available servers. Restarting service...")
        restart_service()


def main():
    while True:
        config = read_config()
        remove_expired_servers(config)

        if not check_internet():
            log_message("Internet unavailable. Switching server...")
            switch_server(config)
        else:
            log_message("Internet is available. Monitoring...")

        time.sleep(30)  # Ensures the check is done every 30 seconds


if __name__ == "__main__":
    main()
