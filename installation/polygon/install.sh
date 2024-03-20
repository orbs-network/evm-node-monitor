#!/bin/bash

# RUN THIS IN SCREEN! this is a very long process.

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <bor_version> <heimdall_version>"
    exit 1
fi

# Assigning command line arguments to variables
bor_version=$1
heimdall_version=$2
network_type=mainnet
node_type=sentry

# Updating and installing dependencies
sudo apt-get update
sudo apt-get install -y build-essential

# Download and execute the Heimdall installation script with command line arguments
curl -L https://raw.githubusercontent.com/maticnetwork/install/main/heimdall.sh | bash -s -- "$heimdall_version" "$network_type" "$node_type"

heimdalld version --long

sudo cp -f ./heimdall.config.toml /var/lib/heimdall/config/config.toml
sudo cp -f ./bor.config.toml /var/lib/bor/config.toml

sudo sed -i 's|^seeds =.*|seeds = "1500161dd491b67fb1ac81868952be49e2509c9f@52.78.36.216:26656,dd4a3f1750af5765266231b9d8ac764599921736@3.36.224.80:26656,8ea4f592ad6cc38d7532aff418d1fb97052463af@34.240.245.39:26656,e772e1fb8c3492a9570a377a5eafdb1dc53cd778@54.194.245.5:26656,6726b826df45ac8e9afb4bdb2469c7771bd797f1@52.209.21.164:26656"|g' /var/lib/heimdall/config/config.toml
sudo chown heimdall /var/lib/heimdall


curl -L https://raw.githubusercontent.com/maticnetwork/install/main/bor.sh | bash -s -- "$bor_version" "$network_type" "$node_type"

sudo sed -i 's|.*\[p2p.discovery\]|  \[p2p.discovery\] |g' /var/lib/bor/config.toml
sudo sed -i 's|.*bootnodes =.*|    bootnodes = ["enode://b8f1cc9c5d4403703fbf377116469667d2b1823c0daf16b7250aa576bacf399e42c3930ccfcb02c5df6879565a2b8931335565f0e8d3f8e72385ecf4a4bf160a@3.36.224.80:30303", "enode://8729e0c825f3d9cad382555f3e46dcff21af323e89025a0e6312df541f4a9e73abfa562d64906f5e59c51fe6f0501b3e61b07979606c56329c020ed739910759@54.194.245.5:30303"]|g' /var/lib/bor/config.toml
sudo chown bor /var/lib/bor

sudo sed -i 's/User=heimdall/User=root/g' /lib/systemd/system/heimdalld.service
sudo sed -i 's/User=bor/User=root/g' /lib/systemd/system/bor.service


# Setting up snapshots directory and downloading snapshots
sudo mkdir -p snapshots
cd snapshots || exit
curl -L https://snapshot-download.polygon.technology/snapdown.sh | bash -s -- --network mainnet --client heimdall --extract-dir data --validate-checksum true
curl -L https://snapshot-download.polygon.technology/snapdown.sh | bash -s -- --network mainnet --client bor --extract-dir data --validate-checksum true

# Removing any existing data directories for Heimdall and Bor
sudo rm -rf /var/lib/heimdall/data
sudo rm -rf /var/lib/bor/chaindata

# Renaming and setting up symlinks to match default client data directory configurations
sudo mv ~/snapshots/heimdall_extract ~/snapshots/data
sudo mv ~/snapshots/bor_extract ~/snapshots/chaindata
sudo ln -s ~/snapshots/data /var/lib/heimdall
sudo ln -s ~/snapshots/chaindata /var/lib/bor

# Starting services (these lines are commented out by default)
# Uncomment them if you want to start services automatically

# sudo service heimdalld start
# wait for Heimdall to fully sync then start Bor
# sudo service bor start
