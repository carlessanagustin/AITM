#!/usr/bin/env bash

USER=vagrant
DOCKER_VERSION=17.12.1~ce-0~ubuntu

########################### DOCKER ENGINE ###########################
sudo groupadd docker
sudo usermod -aG docker $USER

sudo apt-get -y remove docker docker-engine docker.io
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
# sudo apt-cache madison docker-ce | awk '{print $3}'
sudo apt-get -y install docker-ce=$DOCKER_VERSION

sudo systemctl enable docker
sudo systemctl start docker

echo manual | sudo tee /etc/init/docker.override
sudo update-rc.d docker defaults
