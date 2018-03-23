#!/usr/bin/env bash

DEST=/opt
REVISION=9abd6d6ac6533f0cb03274fb252f723373cbb1d9

apt-get update
apt-get -y install build-essential vim wget git curl python-minimal
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get -y install nodejs

cd $DEST
git clone https://github.com/xescuder/ait.git
cd ait
git checkout $REVISION .

## start
#node $DEST/ait/server/start.js
