#!/usr/bin/env bash

ZIPI=ubuntu-xenial-64-zipi.box
ZAPE=ubuntu-xenial-64-zape.box

vagrant box add --force zipi ../../$ZIPI
vagrant box add --force zape ../../$ZAPE
