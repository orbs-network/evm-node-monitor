#!/bin/bash

# Define log file
LOG_FILE="upgrade-script.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "*** $NETWORK upgrade script started ***"

# Fetch the current local version of Avalanche node
LOCAL_VERSION=$(curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method":"info.getNodeVersion"}' -H 'Content-Type: application/json' http://0.0.0.0:9650/ext/info | awk -F '"' '/"version":/ {print $10}' | awk -F '/' '{print $2}')
# Extract just the version number (e.g., from "avalanche/1.10.11" to "1.10.11")
LOCAL_VERSION=${LOCAL_VERSION#*/}

# Check if LOCAL_VERSION is valid
if [[ -z "$LOCAL_VERSION" ]]; then
    log "Invalid local version. Node might not be installed."
    echo "Invalid local version. Node might not be installed."
    exit 1
fi

log "Local version fetched: $LOCAL_VERSION"

# Fetch the latest version from GitHub tagged as "latest"
LATEST_VERSION_RAW=$(curl -s https://api.github.com/repos/ava-labs/avalanchego/releases/latest | awk -F '"' '/tag_name/ {print $4}')
# Remove 'v' prefix if present
LATEST_VERSION=${LATEST_VERSION_RAW#v}
log "Latest version fetched from GitHub: $LATEST_VERSION_RAW (Processed as $LATEST_VERSION)"

# Function to compare versions
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Compare versions and upgrade if the latest version is greater
if version_gt $LATEST_VERSION $LOCAL_VERSION; then
    log "New version available. Upgrading from $LOCAL_VERSION to $LATEST_VERSION"

    UPGRADE_RESULT=$(~/avalanchego-installer.sh)
    log "Upgrade command executed. Result: $UPGRADE_RESULT"

else
    log "No upgrade required. Current version is $LOCAL_VERSION"
fi

log "*** $NETWORK upgrade script ended ***"
