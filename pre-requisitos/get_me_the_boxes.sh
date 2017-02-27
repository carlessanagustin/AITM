#!/bin/bash

# base image
vagrant up base --provision && \
    vagrant halt base && \
    vagrant package --output ../../ubuntu-xenial-64-base.box base && \
    vagrant box add base ../../ubuntu-xenial-64-base.box

# extra images
vagrant up zipi zape --provision
vagrant halt
vagrant package --output ../../ubuntu-xenial-64-zipi.box zipi
vagrant package --output ../../ubuntu-xenial-64-zape.box zape

echo "Your boxes ready at: "
cd ../../
pwd

echo "Jenkins password: "
vagrant ssh zipi -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
