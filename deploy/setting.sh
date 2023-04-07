#!/bin/bash

#remove docker
#sudo rm -f /etc/apt/keyrings/docker.gpg
#sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli docker-compose-plugin
#sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce docker-compose-plugin
#sudo rm -rf /var/lib/docker /etc/docker
#sudo rm -rf /var/run/docker.sock

if command -v docker &> /dev/null; then
    logger "docker already installed"
else
    logger "install docker now"
    sudo apt-get update
    sudo apt-get install \
        ca-certificates \
        curl \
        gnupg
    sudo curl -fsSL get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
fi