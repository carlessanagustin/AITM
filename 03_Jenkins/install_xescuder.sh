#!/bin/bash

# provision environment
sudo yum -y update
curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
sudo yum -y install gcc-c++ make vim wget git
sudo yum -y install nodejs npm

# deploy app
cd $HOME
npm update
git clone https://github.com/xescuder/ait.git
cd ait
npm install

# run app
cd $HOME/ait
nohup bash ./scripts/web-server.sh &
