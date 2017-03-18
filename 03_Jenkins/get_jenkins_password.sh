#!/bin/bash

location=/var/lib/jenkins/secrets/initialAdminPassword

echo "Jenkins password: "
vagrant ssh zipi -c "sudo cat $location"
