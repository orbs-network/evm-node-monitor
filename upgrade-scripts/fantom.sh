#!/bin/bash

# Define log file
LOG_FILE="upgrade-script.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "*** $NETWORK upgrade script started ***"

# Fetch the current local version of bor
LOCAL_VERSION=$(/home/ubuntu/go-opera/build/opera version | grep '^Version:' | cut -d':' -f2 | xargs)

# Check if LOCAL_VERSION is valid
if [[ -z "$LOCAL_VERSION" ]]; then
    log "Invalid local version. Node might not be installed."
    echo "Invalid local version. Node might not be installed."
    exit 1
fi

log "Local version fetched: $LOCAL_VERSION"

# Fetch the latest version from GitHub tagged as "latest"
LATEST_VERSION_RAW=$(curl -s "https://api.github.com/repos/Fantom-foundation/go-opera/releases/latest" | grep '"tag_name":' | cut -d '"' -f4)
# Remove 'v' prefix if present
LATEST_VERSION=${LATEST_VERSION_RAW#v}
log "Latest version fetched from GitHub: $LATEST_VERSION_RAW (Processed as $LATEST_VERSION)"

# Function to compare versions
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Compare versions and upgrade if the latest version is greater
if version_gt $LATEST_VERSION $LOCAL_VERSION; then
    log "New version available. Upgrading from $LOCAL_VERSION to $LATEST_VERSION"

    sudo service fantom stop
    log "fantom opera-go service stopped."

    # shellcheck disable=SC2164
    cd /home/ubuntu/go-opera/

    git checkout release/$LATEST_VERSION

    make

    UPGRADE_RESULT=$(git status)
    log "Upgrade command executed. Result: $UPGRADE_RESULT"

    NEW_VERSION_CHECK=$(/home/ubuntu/go-opera/build/opera version)
    log "New version check: $NEW_VERSION_CHECK"

    sudo service fantom start
    log "fantom opera-go service started."

    log "Upgrade completed to version $(/usr/bin/bor version | grep "Version:" | awk '{print $2}')"
else
    log "No upgrade required. Current version is $LOCAL_VERSION"
fi

log "*** $NETWORK upgrade script ended ***"
