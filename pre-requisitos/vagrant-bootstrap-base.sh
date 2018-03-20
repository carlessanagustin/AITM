#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y upgrade


sudo apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        python-minimal python-simplejson \
        git vim tmux screen ssh tree lynx links links2 zip unzip


sudo apt-get install -y locales locales-all
sudo apt-get install -y language-pack-UTF-8
sudo locale-gen en_US.UTF-8
#sudo locale-gen UTF-8
sudo update-locale
