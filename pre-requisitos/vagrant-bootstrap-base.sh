#!/bin/bash

apt-get update
apt-get -y upgrade

apt-get -y install apt-transport-https ca-certificates

# install docker-engine
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update

apt-get -y purge lxc-docker
apt-cache policy docker-engine

apt-get -y install linux-image-extra-$(uname -r) apparmor
apt-get -y install docker-engine

service docker start
update-rc.d docker defaults

groupadd docker
usermod -aG docker vagrant

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# install docker-machine
curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
chmod +x /usr/local/bin/docker-machine
