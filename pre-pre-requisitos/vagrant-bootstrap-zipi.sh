#!/usr/bin/env bash

########################### JENKINS SERVER ###########################

# IMPORTANT: must download "jenkins-nginx" file too
# or "jenkins-apache2"

wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

apt-get update
#apt-get -y upgrade

# language settings
apt-get -y install language-pack-en
locale-gen en_GB.UTF-8

apt-get -y install git curl vim screen ssh tree lynx links links2 unzip
apt-get -y install openjdk-7-jre openjdk-7-jdk

apt-get -y install jenkins
service jenkins start

# OPTION 1: nginx proxy configuration
apt-get -y install nginx
rm /etc/nginx/sites-enabled/default
# change location if needed
cp /vagrant/jenkins-nginx /etc/nginx/sites-available/jenkins
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
service nginx restart

# OPTION 2: apache2 proxy configuration
#apt-get -y install apache2
#a2enmod proxy
#a2enmod proxy_http
#cp /vagrant/jenkins-apache2 /etc/apache2/sites-available/jenkins.conf
#a2ensite jenkins
#service apache2 reload


# to continue...
# 1. then add these lines to Vagrantfile:
# config.vm.provision :shell, :path => "vagrant-bootstrap-jenkins.sh"
# config.vm.network "forwarded_port", guest: 80, host: 8080
# config.vm.network "forwarded_port", guest: 8000, host: 8081
# 2. then provision:
# $ vagrant up --provision
# or...
# $ vagrant reload --provision


########################### NAGIOS NODE ###########################

# upgrading system
apt-get update
apt-get -y upgrade

# language settings
locale-gen UTF-8

# nagios related: Nagios Remote Plugin Executor Server
apt-get -y install nagios-nrpe-server

# ONLY FOR VAGRANT BOX: setup working folder
service nagios-nrpe-server stop
mkdir /vagrant/etc-nrpe
cp -rf /etc/nagios/* /vagrant/etc-nrpe
rm -rf /etc/nagios
ln -fs /vagrant/etc-nrpe /etc/nagios
service nagios-nrpe-server start

# add to default runlevels
update-rc.d nagios-nrpe-server defaults

service nagios-nrpe-server restart

# clean up
apt-get -y autoremove




