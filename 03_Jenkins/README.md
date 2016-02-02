# Práctica de Jenkins

Vamos a conocer el entorno de Integración Continua JENKINS - http://jenkins-ci.org/

Sigue las instrucciones paso a paso con la ayuda del instructor.

############### help
* Abrir un nuevo Git Bash (Windows) o Terminal (Linux/MacOSX)
* ¿Que sucede?
```
~$ 
```
############### help

---

Instalación de la VM en Vagrant
(a procesar en nuestra máquina local)
  cd test
 vagrant box add uTrusty64 ../ubuntu-trusty-64-updated.box
 vagrant box list
 vagrant init uTrusty64
 vagrant up
 Abrimos el navegador y buscamos http://localhost:8081
Configuración básica de Jenkins
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Manage Plugins > ALL
 Manage Jenkins > Configure System > Jenkins Location
 System Admin e-mail address: carles_mayh@yahoo.es
 Manage Jenkins > Configure System > E-mail Notification
 SMTP server: smtp.correo.yahoo.es
 Default user e-mail suffix: @yahoo.es
 Activa: Use SMTP Authentication
 User Name: carles_mayh
 Password: XXXXX
 Activa: Use SSL
 SMTP Port: 465
 Reply-To Address: carles_mayh-jenkins@yahoo.es
 Activa: Test configuration by sending test e-mail
 Test e-mail recipient: carles_mayh@yahoo.es
 Test configuration
 Save
Instalamos plugins de mantenimiento de Jenkins
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Manage Plugins > Available > Search
 Instalar plugin: thinBackup
 Instalar plugin: Green Balls
 Instalar plugin: Disk Usage Plugin
 Instalar plugin: Monitoring
 Restart Jenkins
Mostrar LOG de Jenkins
(a procesar en la VM en Vagrant) - (*) en local
  (*) vagrant ssh
 tail -f /var/log/jenkins/jenkins.log
 Salir: CTRL+C
Pre-configuración de ThinBackup
(a procesar en la VM en Vagrant)
  sudo su -
 mkdir /backup-jenkins
 chown jenkins:jenkins /backup-jenkins
Tour por los plugins instalados
(a procesar en Jenkins http://localhost:8080/)
  Mostrar Monitoring plugin
 Mostrar Disk Usage plugin
 Manage Jenkins > ThinBackup > Settings
 Backup directory: /backup-jenkins
 Activar: Clean up differential backups
 Activar: Move old backups to ZIP files
 Save
Configurar la seguridad de Jenkins
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Configure Global Security
 Activar: Enable security
 Activar: Security Realm > Jenkins’ own user database
 Activar: Security Realm > Allow users to sign up
 Activar: Authorization > Project-based Matrix Authorization Strategy
 User/group to add: carles
 Select All
 Save
 Sign up
Instalar plugins de seguridad
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Manage Plugins > Available > Search
 Instalar plugin: Escaped Markup
 Instalar plugin: Mask passwords
 Instalar plugin: Audit Trail
 Restart Jenkins
Configurar el plugin Audit Trail
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Configure System > Audit Trail > Add logger > Log file
 Log Location: /var/log/jenkins/pf-jenkins.log
 Log File Size MB: 50
 Log File Count: 5
Instalar plugins de control de versiones
(a procesar en Jenkins http://localhost:8080/)
  Instalar plugin: Git
 Instalar plugin: GitHub
 Instalar plugin: Delivery Pipeline
 Instalar plugin: Build Pipeline
 Instalar plugin: Python Wrapper
 Instalar plugin: Python
 Instalar plugin: pyenv
 Instalar plugin: ShiningPanda
 Instalar plugin: Cobertura
 Instalar plugin: SLOCCount
 Instalar plugin: Unicorn Validation
 Instalar plugin: Violations
 Instalar plugin: Violations Columns
 Instalar plugin: HTML Publisher
 Instalar plugin: HTML5 Notifier
Job: Hello World
(a procesar en Jenkins http://localhost:8080/)
  New Item
 Item name: taller jenkins demo
 Activar: Freestyle project
 OK
 Description: blablabla...
 Build > Add build step > Execute shell
 Command: echo "hello world"
 Command: pwd
 Command: ls -la
 Save
 Build Now
Job: Primer test
(a procesar en Jenkins http://localhost:8080/)
  New Item
 Item name: taller jenkins git
 Copy existing Item: taller jenkins demo
 GitHub project: https://github.com/carlessanagustin/pystache/
 Source Code Management > Git
 Repository URL: https://github.com/carlessanagustin/pystache.git
 Branch Specifier (blank for 'any'): */local
 Build > Add build step > Execute shell
 Command: bash run_tests.sh
 Apply
 Build Now
Job: Test avanzado
(a procesar en Jenkins http://localhost:8080/)
  taller jenkins git > Configure
 Build > Add build step > Virtualenv Builder
 Command: pip install -r requirements.txt
 Build > Add build step > Execute shell
 Command: bash run_tests_with_junit.sh
 Apply
 Build Now
 Console Output: Explanation
 Go to: https://github.com/carlessanagustin/pystache/blob/local/test.py
 Jenkins > Build > Execute shell
 Delete command: bash run_tests_with_junit.sh
 Build > Add build step > Virtualenv Builder
 Command: bash run_tests_with_junit.sh
 Post-build Actions > Add post-build action > Publish JUnit test result report
 Test report XMLs: python_tests_xml/*.xml
 Activar: Retain long standard output/error
 Apply
 Build Now
 Console Output
 Test Result: Explanation
 No Tags: Explanation
Job: Gráficas
(a procesar en Jenkins http://localhost:8080/)
  taller jenkins git > Configure
 Build > Virtualenv Builder
 Command: bash run_tests_with_lint.sh
 Post-build Actions > Add post-build action > Report Violations
 pep8: pep8.log
 pylint: pyflakes.log
 Apply
 Build Now
 Mostrar resultados
 Build > Virtualenv Builder
 Command: bash run_tests_with_coverage.sh
 Post-build Actions > Add post-build action > Publish cobertura Coverage Report
 Apply
 Build Now
 Mostrar resultados
 Build > Add build step > Execute Python Script
 Command: (copiar+pegar) https://github.com/carlessanagustin/pystache/blob/local/gen_data.py
 Post-build Actions > Add post-build action > Plot build data
 Plot group
 Plot title
 Plot y-axis label
 Plot Style: stacked area
 Activar: Keep records for deleted builds
 Data series file: hits.properties
 Activar: Load data from properties file
 Data series legend label: Hits
 Add
 Data series file: misses.properties
 Activar: Load data from properties file
 Data series legend label: Misses
 Apply
 Build Now
 Mostrar resultados
 Build > Execute shell
 Command: sloccount --duplicates --wide --details * >> sloccount.sc
 Post-build Actions > Add post-build action > Publish SLOCCount analysis results
 SLOCCount reports: sloccount.sc
 Apply
 Build Now
 Mostrar resultados
Configurar un pipeline (cadena de montaje)
(a procesar en Jenkins http://localhost:8080/)
  Jenkins > +
 View name: Pipeline demo
 Activar: Build Pipeline View
 OK
 Select Initial Job: pystache demo
 No Of Displayed Builds: 3
 Activar: ALL
 Save
 Pystache demo > Configure
 Post-build Actions > Add post-build action > Build other projects
 Projects to build: pystache demo 2
 Activar: Trigger only if build is stable
 Save
 Jenkins > Pipeline demo > Run
 Mostrar resultados
 Hacer paralelismo de pipelines + explicación
Nueva vista
(a procesar en Jenkins http://localhost:8080/)
  Jenkins > +
 View name: My view
 Activar: List View
 Seleccionar Jobs
 Seleccionar Columns
 OK
Nodes/slaves (1/3) - Añadir node/slave a Jenkins
(a procesar en Jenkins http://localhost:8080/)
  Manage Jenkins > Manage Nodes > New Node
 Node name: AITM test machine
 Dumb Slave: Enable
 # of executors: 1 (CPU cores)
 Remote root directory: /home/jenkins
 Labels: aitm test ubuntu linux
 Usage: Utilize this node as much as possible
 Launch method: Launch slave agents on Unix machines via SSH
 Host: 192.168.32.11
 Credentials > Add (C)
 C: Kind: Username with password
 C: Scope System
 C: Username: jenkins
 C: Password: jenkins123
 C: Add
 Availability: Keep this slave on-line as much as possible
 Save
 Jenkins > Manage Jenkins > Manage Nodes > AITM test machine > Launch slave agent
Nodes/slaves (2/3) - Configuración mínima del node/slave
(terminal: a procesar en la máquina node/slave)
  vagrant ssh zape
 sudo useradd -m -s /bin/bash jenkins
 sudo passwd jenkins
 password: jenkins123
Nodes/slaves (3/3) - Asignación de proyectos a node/slave
(a procesar en Jenkins http://localhost:8080/)
  Jenkins > New Item > Item name: testing node
 Freestyle project: Enabled
 Restrict where this project can be run: Enabled
 Label Expression: AITM test machine
 Build > Add build step > Execute Shell: ifconfig
 Save
Plugins para nodes/slaves
(a procesar en Jenkins http://localhost:8080/)
  Instalar: Multi slave config plugin
 Configurar: Manage Jenkins > Configure System > Multi Slave Config Plugin
 Instalar: Slave Setup Plugin
 Configurar: Manage Jenkins > Configure System > Slave Setups > Add
más sobre nodes/slaves...
https://wiki.jenkins-ci.org/display/JENKINS/Step+by+step+guide+to+set+up+master+and+slave+machines

https://wiki.jenkins-ci.org/display/JENKINS/Distributed+builds#Distributedbuilds-Differentwaysofstartingslaveagents
Otros plugins interesantes
(a procesar en Jenkins http://localhost:8080/)
  Unicorn plugin
 Google Calendar plugin
 Chat plugins
 Twitter plugin
 Sounds plugin
 seleniumhtmlreport plugin: Web testing framework
 EnvInject plugin
 Multi slave config plugin
 JobConfigHistory plugin
 Email-ext plugin
Fitnesse test
(fully-integrated standalone wiki and acceptance-testing framework)
  Fitnesse plugin: Acceptance testing framework
 Download: http://www.fitnesse.org/FitNesseDownload
 Run: java -jar fitnesse-standalone.jar -p 39996 -l logs -a tester:test
 Go to:  http://localhost:39996
JMeter test
(stress/performance testing)
  Performance Plugin: JMeter
 Download: http://jmeter.apache.org/download_jmeter.cgi


---

# Preguntas y respuestas

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)