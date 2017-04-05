
```shell
sudo useradd -m -s /bin/bash jenkins
sudo passwd jenkins
sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
```

```shell
if type "yum";
then
  echo 'RedHat based OS'
  sudo yum -y install gcc-c++ make vim wget git
  curl --silent --location https://rpm.nodesource.com/setup_4.x | sudo bash -
  sudo yum -y install nodejs npm
elif type "apt-get";
then
  echo 'Debian based OS'
  sudo apt-get update
  sudo apt-get -y install build-essential vim wget git python-minimal
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo 'Unknown OS'
  exit 1
fi
```

```shell
git clone https://github.com/xescuder/ait.git
npm install jasmine
```

```shell
cd test/unit
../../node_modules/jasmine/bin/jasmine.js init
../../node_modules/jasmine/bin/jasmine.js
```

```shell
npm install pm2
BUILD_ID=dontKillMe node_modules/pm2/bin/pm2 start server/start.js
```
