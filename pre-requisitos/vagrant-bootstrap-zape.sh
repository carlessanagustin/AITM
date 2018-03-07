#!/usr/bin/env bash

########################### NAGIOS SERVER ###########################

MAILNAME="zipi.com"
MAILTYPE="'Internet Site'"
PASS="nagios123"

# postfix unattended
debconf-set-selections <<< "postfix postfix/mailname string $MAILNAME"
debconf-set-selections <<< "postfix postfix/main_mailer_type string $MAILTYPE"
# nagios unattended
debconf-set-selections <<< "nagios3-cgi nagios3/adminpassword string $PASS"
debconf-set-selections <<< "nagios3-cgi nagios3/adminpassword-repeat string $PASS"
# nagios install
apt-get -y install nagios3 nagios-nrpe-plugin

# ONLY FOR VAGRANT BOX: setup working folder
service nagios3 stop
mkdir /vagrant/etc-nagios3
cp -rf /etc/nagios3/* /vagrant/etc-nagios3
rm -rf /etc/nagios3
ln -fs /vagrant/etc-nagios3 /etc/nagios3
service nagios3 start

# cgi configurations: http://technosophos.com/2010/01/13/nagios-fixing-error-could-not-stat-command-file-debian.html
chmod g+x /var/lib/nagios3/rw
usermod -a -G nagios www-data

# add to default runlevels
update-rc.d apache2 defaults
update-rc.d apache2 enable 2
update-rc.d nagios3 defaults
update-rc.d nagios3 enable 2

service apache2 restart
service nagios3 restart

# clean up
apt-get -y autoremove

## Open browser and go to...
## http://localhost:8080/nagios3/

# For nodes that need monitoring install: Nagios Remote Plugin Executor Server
# apt-get -y install nagios-nrpe-server

########################### ANSIBLE SERVER ###########################

# add ansible repo
apt-add-repository -y ppa:ansible/ansible

# upgrading system
apt-get update

# packages: basic
apt-get -y install git curl vim screen ssh tree lynx links links2 unzip

# packages: python
apt-get -y install python-pip python-dev build-essential python-virtualenv

# packages: ansible
apt-get -y install software-properties-common
apt-get -y install ansible
pip install pywinrm

# remember...
# 1. then add these lines to Vagrantfile:
# config.vm.provision :shell, :path => "vagrant-bootstrap-ansible.sh"
# config.vm.network "forwarded_port", guest: 8010, host: 8081
# 2. then provision:
# $ vagrant up --provision
