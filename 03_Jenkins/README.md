# Práctica de Jenkins

Vamos a conocer el entorno de Integración Continua JENKINS - http://jenkins-ci.org/

Sigue las instrucciones paso a paso con la ayuda del instructor.

## Instalación de la VM en Vagrant

```
vagrant up
```
* Abrimos el navegador y buscamos http://localhost:8081/

## Configuración básica de Jenkins

* Manage Jenkins > Configure System > Jenkins Location
* System Admin e-mail address: example@example.com
* Manage Jenkins > Configure System > E-mail Notification
* SMTP server: smtp.example.com
* Default user e-mail suffix: @example.com
* Activa: Use SMTP Authentication
* User Name: my_username
* Password: XXXXX
* Activa: Use SSL
* SMTP Port: 465
* Reply-To Address: reply-example@example.com
* Activa: Test configuration by sending test e-mail
* Test e-mail recipient: example@example.com
* Test configuration
* Save

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
* Backup directory: /backup-jenkins
* Activar: Clean up differential backups
* Activar: Move old backups to ZIP files
* Save

## Mostrar LOG de Jenkins

```
vagrant ssh zipi -c \
  "sudo tail -f /var/log/jenkins/jenkins.log"
```

> Salir: CTRL+C

## Configurar la seguridad de Jenkins

* Manage Jenkins > Configure Global Security
* Activar: Enable security
* Activar: Security Realm > Jenkins’ own user database
* Activar: Security Realm > Allow users to sign up
* Activar: Authorization > Project-based Matrix Authorization Strategy
* User/group to add: your_name
* Select All
* Save
* Sign up

## Job: Hello World

* New Item
* Item name: hello_world_job_demo
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

## Plugins de control de versiones

* Instalar plugin: Git
* Instalar plugin: Delivery Pipeline
* Instalar plugin: Build Pipeline
* Instalar plugin: Build Monitor View
* Instalar plugin: Mission Control
* Instalar plugin: Sectioned View
* Instalar plugin: Escaped Markup
* Instalar plugin: Mask passwords
* Instalar plugin: Audit Trail

## Nueva vista

* Jenkins > +
* View name: My view
* Activar: List View
* Seleccionar Jobs
* Seleccionar Columns
* OK

## Nodes/slaves (1/3) - Añadir node/slave a Jenkins

* Manage Jenkins > Manage Nodes > New Node
* Node name: test_environment
* Dumb Slave: Enable
* # of executors: 1
* Remote root directory: /home/ubuntu/jenkins_agent
* Labels: test, centos, redhat, linux
* Usage: Utilize this node as much as possible
* Launch method: Launch slave agents on Unix machines via SSH
* Host: 192.168.32.13
* Credentials > Add (C)
* C: Kind: Username with password
* C: Scope System
* C: Username: ubuntu
* Buscar contraseña en: `cat ~/.vagrant.d/boxes/ubuntu-VAGRANTSLASH-xenial64/20170224.0.0/virtualbox/Vagrantfile`
* C: Password: ____
* C: Add
* Availability: Keep this slave on-line as much as possible
* Save
* Jenkins > Manage Jenkins > Manage Nodes > AITM test machine > Launch slave agent

## Nodes/slaves (2/3) - Configuración mínima del node/slave

```
vagrant ssh zape
sudo useradd -m -s /bin/bash jenkins
sudo passwd jenkins
password: jenkins123
```

## Nodes/slaves (3/3) - Asignación de proyectos a node/slave

* Jenkins > New Item > Item name: testing node
* Freestyle project: Enabled
* Restrict where this project can be run: Enabled
* Label Expression: AITM test machine
* Build > Add build step > Execute Shell: ifconfig
* Save

## Plugins para nodes/slaves

* Instalar: Multi slave config plugin
* Configurar: Manage Jenkins > Configure System > Multi Slave Config Plugin
* Instalar: Slave Setup Plugin
* Configurar: Manage Jenkins > Configure System > Slave Setups > Add

### Más sobre nodes/slaves...

* https://wiki.jenkins-ci.org/display/JENKINS/Step+by+step+guide+to+set+up+master+and+slave+machines

* https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds#Distributedbuilds-Differentwaysofstartingslaveagents

## Otros plugins interesantes

* Unicorn plugin
* Google Calendar plugin
* Chat plugins
* Twitter plugin
* Sounds plugin
* seleniumhtmlreport plugin: Web testing framework
* EnvInject plugin
* Multi slave config plugin
* JobConfigHistory plugin
* Email-ext plugin

## Fitnesse test

(fully-integrated standalone wiki and acceptance-testing framework)

* Fitnesse plugin: Acceptance testing framework
* Download: http://www.fitnesse.org/FitNesseDownload
* Run: java -jar fitnesse-standalone.jar -p 39996 -l logs -a tester:test
* Go to:  http://localhost:39996

## JMeter test

(stress/performance testing)

* Performance Plugin: JMeter
* Download: http://jmeter.apache.org/download_jmeter.cgi

# Preguntas y respuestas

# Eliminamos las instancias Vagrant

```
vagrant destroy -f
```

---

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
