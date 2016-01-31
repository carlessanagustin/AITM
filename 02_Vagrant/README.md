# Práctica de Vagrant

## Requisitos previos: Entorno local

* Instalar VirtualBox - https://www.virtualbox.org/
* Instalar Vagrant - https://www.vagrantup.com/
* Instalar Git - https://git-scm.com/

## Solo para Windows

Hay que revisar los permisos de escritura en carpeta del usuario activo.

* Abrir VirtualBox
* Ir a Archivo > Preferencias > Carpeta predeterminada de maquinas > Crear user\ttc\docs\virtualbox_vm

## 1. Los comandos básicos

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)

```
$ mkdir aitm-vagrant
$ cd aitm-vagrant
$ vagrant init
$ vagrant up
```

* ¿Que sucede?
* Continuamos...

```
$ vagrant box add baseUPC ../../base-ubuntu-trusty-64.box
$ vagrant box list
$ vagrant init baseUPC -f
$ vagrant up
```

* ¿Que sucede?
* También podemos usar estos comandos

```
$ vagrant init ubuntu/trusty64 -m -o Vagrantfile-trusty64
$ vagrant init precise32 http://files.vagrantup.com/precise32.box -m -o Vagrantfile-precise
```

* Aparte de *up* existen otros

```
$ vagrant up|suspend|resume|halt|reload
```

* Continuamos...

```
$ vagrant ssh
~$ uname -a
~$ exit
$ vagrant ssh -c "uname -a"
```

* ¿Que sucede?

## 2. El fichero Vagrantfile

```
$ vagrant ssh -c "ifconfig"
```

* ¿Que sucede?
* Editamos el fichero *Vagrantfile*

```
$ vim Vagrantfile
```

* ¿Que sucede?

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "baseUPC"
end
```

* Añadimos...

```ruby
config.vm.network :private_network,
                ip: "192.168.1.100",
                virtualbox__intnet: true,
                auto_config: true
```

* Salvamos y salimos con *:x*

```
$ vagrant reload
$ vagrant ssh -c "ifconfig"
```

* ¿Que sucede?

## 3. Más opciones para Vagrantfile

```
$ mkdir extra
$ vim Vagrantfile
```

* Añadimos...

```ruby
config.vm.host_name = "zipi"
config.vm.provider "virtualbox" do |vb|
  vb.memory = 512
  vb.cpus = 1
end
config.vm.synced_folder "./extra",
                "/vagrant-extra",
                owner: "ubuntu",
                group: "ubuntu",
                mount_options: ["dmode=775,fmode=664"]
```

* Salvamos y salimos con *:x*

```
$ vagrant reload
$ vagrant ssh
~$ hostname
~$ free
~$ ls /
~$ ls /vagrant
~$ touch /vagrant-extra/extra-file.txt
~$ exit
$ ls
$ ls extra
```

* ¿Que sucede?

*A fecha de Enero del 2016 también: VMware, Docker, Hyper-V & Custom Provider.*
(fuente: https://www.vagrantup.com/docs/providers/)

## 4. Aprovisionamiento

* Editamos el fichero *Vagrantfile*

```
$ vim Vagrantfile
```

* Añadimos...

```ruby
config.vm.provision :shell, :inline => "apt-get update && apt-get -y install apache2"
```
* Salvamos y salimos con *:x*

```
$ vagrant provision
```

* ¿Que sucede?
* Aparte de *provision* podemos...

```
$ vagrant up --provision
$ vagrant up --no-provision
$ vagrant reload --provision
```

* Editamos el fichero *Vagrantfile*

```
$ vim Vagrantfile
```
* Intercambiamos *config.vm.provision :shell...* por

```ruby
config.vm.provision :shell, :path => "bootstrap.sh"
```

* Salvamos y salimos con *:x*
* Editamos el fichero *bootstrap.sh*

```
$ vim bootstrap.sh
```

* Añadimos...

```
#!/bin/sh
apt-get update
apt-get -y install apache2
```

* Salvamos y salimos con *:x*

```
$ vagrant provision
```

* ¿Que sucede?

* Otros métodos de aprovisionamiento

```
# inline
config.vm.provision :shell,
            :inline => "apt-get update && apt-get -y upgrade"
# ansible
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "provisioning/playbook.yml"
end
```

*A fecha de Enero del 2016 también: File, Shell, Ansible, Ansible Local, CFEngine, Chef Solo, Chef Zero, Chef Client, Chef Apply, Docker, Puppet Apply, Puppet Agent, Salt.*
(fuente: https://www.vagrantup.com/docs/provisioning/)

## 5. Reenvío de puertos

En el paso anterior hemos instalado el servidor web Apache. Vamos a ver su homepage.

* Abrimos un navegador y vamos a http://192.168.1.100
* ¿Que sucede?
* Editamos el fichero *Vagrantfile*

```
$ vim Vagrantfile
```

* Añadimos...

```ruby
config.vm.network "forwarded_port",
                guest: 80,
                host: 8080,
                auto_correct: true
```

* Salvamos y salimos con *:x*

```
$ vagrant reload
```

* Abrimos un navegador y vamos a http://localhost:8080
* ¿Que sucede?

## 6. Eliminar el entorno

* Abrimos VirtualBox
* Continuamos en el Terminal

```
$ vagrant destroy -f
$ rm -Rf .vagrant
$ vagrant box list
```

* ¿Que sucede?

* Otros comandos útiles

```
$ vagrant box remove|update [name]
```

## 7. Iniciando más instancias

```
$ mv Vagrantfile Vagrantfile-single
$ vim Vagrantfile
```

* Añadimos...

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.boot_timeout = 60

  config.vm.define "zipi" do |zipi|
##### PROVISION #####
    zipi.vm.provision :shell, :path => "bootstrap.sh"
##### PROVISION #####
    zipi.vm.host_name = "zipi"
    zipi.vm.box = "baseUPC"
    zipi.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
##### NETWORK #####
    zipi.vm.network "forwarded_port", host: 8080, guest: 80, auto_correct: true
    zipi.vm.network "private_network", ip: "192.168.32.10", virtualbox__intnet: true, auto_config: true
##### NETWORK #####
  end
    
  config.vm.define "zape" do |zape|
##### PROVISION #####
    zape.vm.provision :shell, :inline => "apt-get update && apt-get -y install curl"
##### PROVISION #####
    zape.vm.host_name = "zape"
    zape.vm.box = "baseUPC"
    zape.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
##### NETWORK #####
    zape.vm.network "forwarded_port", host: 8082, guest: 80, auto_correct: true
    zape.vm.network "private_network", ip: "192.168.32.11", virtualbox__intnet: true, auto_config: true
##### NETWORK #####
  end
end
```

* Salvamos y salimos con *:x*

```
$ vagrant up --provision
```

* ¿Que sucede?

```
$ vagrant ssh zape
~$ curl http://192.168.32.10
```

* Abrimos un navegador y vamos a http://localhost:8080/
* ¿Que sucede?

## Eliminamos nuestro rastro

```
~$ exit
$ vagrant destroy -f
$ vagrant box remove baseUPC
```

# Preguntas y respuestas

Creado por carlessanagustin.com