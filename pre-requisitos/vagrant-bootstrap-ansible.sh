#!/usr/bin/env bash

########################### ANSIBLE SERVER ###########################

# add ansible repo
apt-add-repository -y ppa:ansible/ansible

# upgrading system
apt-get update

# packages: basic
apt-get -y install git curl vim screen ssh tree lynx links links2 unzip

# packages: python
apt-get -y install python-pip python-dev build-essential python-virtualenv

# packages: ansible
apt-get -y install software-properties-common
apt-get -y install ansible
pip install pywinrm
