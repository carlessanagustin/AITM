#!/bin/bash

# provision environment
yum -y update
curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
yum -y install gcc-c++ make vim wget git
yum -y install nodejs npm

# deploy app
cd /home/vagrant
npm update
git clone https://github.com/xescuder/ait.git
cd ait
npm install

# run app
nohup bash ./scripts/web-server.sh &
