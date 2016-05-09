#!/bin/bash

vagrant up base --provision
vagrant halt
vagrant package --output ../../ubuntu-trusty-64-base.box base
vagrant box add base ../../ubuntu-trusty-64-base.box
vagrant up zipi zape --provision
vagrant halt
vagrant package --output ../../ubuntu-trusty-64-zipi.box zipi
vagrant package --output ../../ubuntu-trusty-64-zape.box zape

echo "yout boxes ready at...
ls ../../
