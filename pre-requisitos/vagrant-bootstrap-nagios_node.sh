#!/usr/bin/env bash
########################### NAGIOS NODE ###########################

# nagios related: Nagios Remote Plugin Executor Server
apt-get -y install nagios-nrpe-server

# ONLY FOR VAGRANT BOX: setup working folder
service nagios-nrpe-server stop
mkdir /vagrant/etc-nrpe
cp -rf /etc/nagios/* /vagrant/etc-nrpe
rm -rf /etc/nagios
ln -fs /vagrant/etc-nrpe /etc/nagios
#service nagios-nrpe-server start

# UPSTART
#update-rc.d nagios-nrpe-server defaults
#service nagios-nrpe-server restart

# SYSTEMD
systemctl enable nagios-nrpe-server.service
systemctl restart nagios-nrpe-server.service

# clean up
apt-get -y autoremove
