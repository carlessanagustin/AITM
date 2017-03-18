#!/bin/bash

# base box
vagrant up base --provision && \
    vagrant halt base && \
    vagrant package --output ../../ubuntu-xenial-64-base.box base && \
    vagrant box add base ../../ubuntu-xenial-64-base.box

# zipi box: jenkins server
vagrant up zipi --provision
vagrant halt
vagrant package --output ../../ubuntu-xenial-64-zipi.box zipi

## zape box: ansible + nagios server
#vagrant up zape --provision
#vagrant halt
#vagrant package --output ../../ubuntu-xenial-64-zape.box zape

echo "Your boxes ready at: "
cd ../../
pwd

while true; do
    read -p "Delete vagrant environment? [y|n]" yn
    case $yn in
        [Yy]* ) vagrant destroy -f && rm -Rf .vagrant; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
