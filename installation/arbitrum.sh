#!/bin/bash

# this is supposed to download this file's content
# wget -O arbitrum.sh https://raw.githubusercontent.com/bxdoan/Arbitrum-Node/main/arbitrum.sh && chmod +x arbitrum.sh && sudo ./arbitrum.sh

echo -e "\e[1m\e[32m1. Updating the server, installing docker.. \e[0m"
echo "======================================================"
sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
mkdir -p ~/data/arbitrum
chmod -fR 777 ~/data/arbitrum


export L1URL="http://107.6.163.146:8545"


if [ ! $L1URL ]; then
	read -p "Enter your L1 URL: " L1URL
	echo 'export L1URL='$L1URL >> $HOME/.bash_profile
fi


echo -e "\e[1m\e[32m1. Installing Arbitrum Node.. \e[0m"
echo "======================================================"

# docker image pull offchainlabs/arbitrum-node:latest from ref: https://hub.docker.com/r/offchainlabs/nitro-node/tags
curl -s https://api.github.com/repos/OffchainLabs/nitro/releases/latest | grep -oP 'Docker image on Docker Hub at `\K(.*)(?=`\\r\\n\\r\\n\#\#)'
image_name=$(curl -s https://api.github.com/repos/OffchainLabs/nitro/releases/latest | grep -oP 'Docker image on Docker Hub at `\K(.*)(?=`\\r\\n\\r\\n\#\#)')
echo "Install latest image: $image_name"
docker run -d -v ~/data/arbitrum:/home/user/.arbitrum -p 0.0.0.0:8547:8547 -p 0.0.0.0:8548:8548 $image_name --parent-chain.connection.url $L1URL --chain.id=42161 --http.api=net,web3,eth,debug --http.corsdomain=* --http.addr=0.0.0.0 --http.vhosts=* --init.url="https://snapshot.arbitrum.io/mainnet/nitro.tar"


