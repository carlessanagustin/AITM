#!/bin/bash

apt-get update
apt-get -y upgrade

apt-get -y install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update

apt-get -y purge lxc-docker
apt-cache policy docker-engine

apt-get -y install linux-image-extra-$(uname -r) apparmor
apt-get -y install docker-engine

service docker start
systemctl enable docker

groupadd docker
usermod -aG docker vagrant
