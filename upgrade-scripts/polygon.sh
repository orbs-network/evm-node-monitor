#!/bin/bash

# Define log file
LOG_FILE="upgrade-script.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "*** $NETWORK upgrade script started ***"

# Fetch the current local version of bor
LOCAL_VERSION=$(/usr/bin/bor version | grep "Version:" | awk '{print $2}')

# Check if LOCAL_VERSION is valid
if [[ -z "$LOCAL_VERSION" ]]; then
    log "Invalid local version. Node might not be installed."
    echo "Invalid local version. Node might not be installed."
    exit 1
fi

log "Local version fetched: $LOCAL_VERSION"

# Fetch the latest version from GitHub tagged as "latest"
LATEST_VERSION_RAW=$(curl -s https://api.github.com/repos/maticnetwork/bor/releases/latest | awk -F '"' '/tag_name/ {print $4}')
# Remove 'v' prefix if present
LATEST_VERSION=${LATEST_VERSION_RAW#v}
log "Latest version fetched from GitHub: $LATEST_VERSION_RAW (Processed as $LATEST_VERSION)"

# Function to compare versions
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Compare versions and upgrade if the latest version is greater
if version_gt $LATEST_VERSION $LOCAL_VERSION; then

    log "New version available. Upgrading from $LOCAL_VERSION to $LATEST_VERSION"

    sudo service bor stop
    log "Bor service stopped."

    UPGRADE_RESULT=$(curl -L https://raw.githubusercontent.com/maticnetwork/install/main/bor.sh | bash -s -- $LATEST_VERSION_RAW mainnet sentry)
    log "Upgrade command executed. Result: $UPGRADE_RESULT"

    NEW_VERSION_CHECK=$(/usr/bin/bor version)
    log "New version check: $NEW_VERSION_CHECK"

    log "sleeping 5 sec..."
    sleep 5

    log "starting bor..."
    sudo service bor start
    log "Bor service started."

    log "Upgrade completed to version $(/usr/bin/bor version | grep "Version:" | awk '{print $2}')"

else
    log "No upgrade required. Current version is $LOCAL_VERSION"
fi

log "*** $NETWORK upgrade script ended ***"
