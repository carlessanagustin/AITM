#!/bin/bash

apt-get update
apt-get -y upgrade

apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        python-minimal

# Add Docker’s official GPG key
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
apt-get update

groupadd docker
usermod -aG docker ubuntu

apt-get -y purge lxc-docker
apt-cache policy docker-engine
apt-get -y install docker-engine

service docker start
update-rc.d docker defaults

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.11.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# install docker-machine
curl -L "https://github.com/docker/machine/releases/download/v0.9.0/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

reboot
