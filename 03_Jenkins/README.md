# Práctica de Jenkins

Vamos a conocer el entorno de Integración Continua JENKINS - http://jenkins-ci.org/

Sigue las instrucciones paso a paso con la ayuda del instructor.

## Instalación de la VM en Vagrant

```
vagrant up
```
* Navegamos a http://localhost:8081/

## Job: Hello World

* New Item
* Item name: `hello_world_job_demo`
* Activar: Freestyle project
* OK
* Description: hello world example
* Build > Add build step > Execute shell

```shell
pwd
ls -la
id
echo "hello world"
```

* Save
* Build Now
* Build History > #1 > Console Output

## Introducción a Jenkins

* Dashboard
* New Item = New Job = New Project
* People = Users
* Credentials
* Setup Jenkins = Manage Jenkins
* Plugins

## Plugins de mantenimiento de Jenkins

* Manage Jenkins > Manage Plugins > Available > Search
* Instalar plugin: [thinBackup](https://wiki.jenkins-ci.org/display/JENKINS/thinBackup)
* Instalar plugin: [Green Balls](https://wiki.jenkins-ci.org/display/JENKINS/Green+Balls)
* Instalar plugin: [Disk Usage Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Disk+Usage+Plugin) (disk-usage)
* Instalar plugin: [Monitoring](https://wiki.jenkins-ci.org/display/JENKINS/Monitoring)
* Restart Jenkins

## Pre-configuración de ThinBackup

```
vagrant ssh zipi -c \
  "sudo mkdir /backup-jenkins && sudo chown jenkins:jenkins /backup-jenkins"
```

## Tour por los plugins instalados

* Mostrar Monitoring plugin
* Mostrar Disk Usage plugin
* Manage Jenkins > ThinBackup > Settings
* Backup directory: `/backup-jenkins`
* Activar: Clean up differential backups
* Activar: Move old backups to ZIP files
* Save

## Mostrar LOG de Jenkins (opcional)

```
vagrant ssh zipi -c \
  "sudo tail -f /var/log/jenkins/jenkins.log"
```

> Salir: CTRL+C

## Nodes/slaves (1/3) - Configuración mínima del node/slave

* Añadimos el usuario de acceso

```shell
vagrant ssh zape
ubuntu@zape:~$ sudo useradd -m -s /bin/bash jenkins
ubuntu@zape:~$ sudo passwd jenkins
```

* Password: `jenkins123`
* Instalamos Java

```shell
ubuntu@zape:~$ sudo apt-get update && \
    sudo apt-get -y install openjdk-8-jdk openjdk-8-jre
```

## Nodes/slaves (2/3) - Añadir node/slave a Jenkins

* Manage Jenkins > Manage Nodes > New Node
* Node name: `test_environment`
* Select: Permanent Agent
* # of executors: 1
* Remote root directory: `/home/jenkins/jenkins_agent`
* Labels: `test, ubuntu, debian, linux`
* Usage: Utilize this node as much as possible
* Launch method: Launch slave agents on Unix machines via SSH
* Host: `192.168.56.11`
* Credentials > Add (C)
* C: Kind: Username with password
* C: Scope System
* C: Username: `jenkins`
* C: Password: `jenkins123`
* C: Add
* Seleccionamos la nueva credencial creada.
* Availability: Keep this slave on-line as much as possible
* Save
* Jenkins > Manage Jenkins > Manage Nodes > AITM test machine > Launch slave agent o Relaunch agent


## Nodes/slaves (3/3) - Asignación de proyectos a node/slave

* Jenkins > New Item > Item name: `testing node`
* Freestyle project: Enabled
* Restrict where this project can be run: Enabled
* Label Expression: `test_environment`
* Build > Add build step > Execute Shell: ip addr
* Apply
* Build Now

### Más sobre nodes/slaves... (opcional)

* https://wiki.jenkins-ci.org/display/JENKINS/Step+by+step+guide+to+set+up+master+and+slave+machines

* https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds#Distributedbuilds-Differentwaysofstartingslaveagents

## Testing de una aplicación web (1/4) - Configuración del nodo/slave

```
vagrant ssh zape
ubuntu@zape:~$ sudo vi /etc/sudoers
```

* Añadimos al final del fichero: `jenkins ALL=(ALL) NOPASSWD:ALL`

> Guardar y salir: ESC + `:x!`

## Testing de una aplicación web (2/4) - Aprovisionamiento

* New Item
* Item name: `my_code_provisioning`
* Copy from: `hello_world_job_demo`
* OK
* Build > Add build step > Execute shell

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
  sudo apt-get -y install build-essential vim wget git
  curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
  sudo apt-get install -y nodejs
  sudo apt-get -y install python-minimal
else
  echo 'Unknown OS'
  exit 1
fi
```

## Testing de una aplicación web (3/4) - Test

* New Item
* Item name: `my_code_test`
* Copy from: `hello_world_job_demo`
* OK
* Source Code Management > Git > Repository URL: https://github.com/xescuder/ait.git
* Build > Add build step > Execute shell

```shell
rm -Rf node_modules
npm install jasmine
```

* Build > Add build step > Execute shell

```shell
node --version
npm -version
```

* Build > Add build step > Execute shell

```shell
cd test/unit
../../node_modules/jasmine/bin/jasmine.js init
../../node_modules/jasmine/bin/jasmine.js
```

* Save
* Configure: `my_code_provisioning` > Add post-build Actions > Build other projects > Projects to build > `my_code_test`
* Save
* Build Now: `my_code_provisioning`
* Build History > #n > Console Output

## Testing de una aplicación web (4/4) - Run

* New Item
* Item name: `my_code_run`
* Copy from: `hello_world_job_demo`
* OK
* Source Code Management > Git > Repository URL: https://github.com/xescuder/ait.git
* Desactivar: `Delete workspace before build starts`
* Build > Add build step > Execute shell

```shell
npm install pm2
BUILD_ID=dontKillMe node_modules/pm2/bin/pm2 start server/start.js
```

* Save
* Configure: `my_code_test` > Add post-build Actions > Build other projects > Projects to build > `my_code_run`
* Save
* Build Now: `my_code_provisioning`
* Build History > #n > Console Output

## Nueva vista

* Instalar plugin: Delivery Pipeline
* Instalar plugin: Build Monitor View
* Instalar plugin: Mission Control
* Restart Jenkins
* Jenkins > +
* View name: My view
* Seleccionar:
	* Build Monitor View
	* Delivery Pipeline View
	* Mission Control
* OK

# ¿Preguntas y respuestas?

# Eliminamos las instancias Vagrant

```
vagrant destroy -f
```

### extras - Otros plugins interesantes

* Google Calendar plugin
* Chat plugins
* Twitter plugin
* Sounds plugin
* EnvInject plugin
* Multi slave config plugin
* JobConfigHistory plugin
* Email-ext plugin
* Build Pipeline
* Sectioned View
* Escaped Markup
* Mask passwords
* Audit Trail
* Fitnesse plugin
* seleniumhtmlreport plugin: Web testing framework
* Unicorn plugin

---

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
