#!/bin/bash

# provision environment
if type "yum" &> /dev/null ;
then
  echo 'RedHat based OS'
  #sudo yum -y update
  sudo yum -y install gcc-c++ make vim wget git
  curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
  sudo yum -y install nodejs npm
elif type "apt-get" &> /dev/null ;
then
  echo 'Debian based OS'
  sudo apt-get update
  sudo apt-get -y install build-essential vim wget git
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo 'Unknown OS'
  exit 1
fi
