#!/usr/bin/env bash

ZIPI=ubuntu-xenial-64-zipi.box
ZAPE=ubuntu-xenial-64-zape.box

while true; do
    read -p "Remove local exported boxes? [y|n]" yn
    case $yn in
        [Yy]* ) rm ../../$ZIPI && rm ../../$ZAPE; break;;
        [Nn]* ) echo "Next steps..."; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

vagrant up zipi zape --provision
vagrant halt
vagrant package --output ../../$ZIPI zipi
vagrant package --output ../../$ZAPE zape

echo "Your boxes ready at: "
cd ../../
pwd

while true; do
    read -p "Delete vagrant environment? [y|n]" yn
    case $yn in
        [Yy]* ) source clean_vagrant.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
