#!/usr/bin/env bash

# upgrading system
apt-get update
apt-get -y upgrade

# language settings
apt-get -y install language-pack-en
locale-gen en_GB.UTF-8
