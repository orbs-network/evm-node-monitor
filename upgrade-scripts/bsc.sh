#!/bin/bash

# Define log file
LOG_FILE="upgrade-script.log"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "*** $NETWORK upgrade script started ***"

# Fetch the current local version of Bsc node
LOCAL_VERSION_RAW=$(curl -s -X POST --data '{"jsonrpc":"2.0","id":1,"method":"web3_clientVersion"}' -H 'Content-Type: application/json' http://localhost:8545 | grep -oP 'Geth/\K[^-]+')

# Remove 'v' prefix if present
LOCAL_VERSION=${LOCAL_VERSION_RAW#v}

# Check if LOCAL_VERSION is valid
if [[ -z "$LOCAL_VERSION" ]]; then
    log "Invalid local version. Node might not be installed."
    echo "Invalid local version. Node might not be installed."
    exit 1
fi

log "Local version fetched: $LOCAL_VERSION"

# Fetch the latest version from GitHub tagged as "latest"
LATEST_VERSION_RAW=$(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest | awk -F '"' '/tag_name/ {print $4}')

# Remove 'v' prefix if present
LATEST_VERSION=${LATEST_VERSION_RAW#v}
log "Latest version fetched from GitHub: $LATEST_VERSION_RAW (Processed as $LATEST_VERSION)"

# Function to compare versions
version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# Compare versions and upgrade if the latest version is greater
if version_gt $LATEST_VERSION $LOCAL_VERSION; then
    log "New version available. Upgrading from $LOCAL_VERSION to $LATEST_VERSION"

    # shellcheck disable=SC2164
    cd /home/ubuntu/

    wget "$(curl -s https://api.github.com/repos/bnb-chain/bsc/releases/latest |grep browser_ |grep geth_linux |cut -d\" -f4)"
    mv geth_linux geth
    chmod -v u+x geth

    sudo service bsc restart

    log "Upgrade command executed. Result: $UPGRADE_RESULT"

else
    log "No upgrade required. Current version is $LOCAL_VERSION"
fi

log "*** $NETWORK upgrade script ended ***"
