# Práctica de Vagrant

Vamos a conocer VAGRANT para la creación y configuración de entornos de desarrollo virtualizados - https://www.vagrantup.com/

Sigue las instrucciones paso a paso con la ayuda del instructor.

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

```shell
mkdir aitm-vagrant
cd aitm-vagrant
vagrant init
vagrant up
```

* ¿Que sucede?
* *Miramos: Vagrantfile*
* Continuamos...

```shell
vagrant init ubuntu/xenial64 -f
vagrant up
```

* ¿Que sucede?
* *Miramos Vagrantfile + `vagrant status` + VirtualBox*
* Continuamos...

```shell
vagrant ssh
    uname -a
    ls /
    exit
```

Y tambien...

```shell
vagrant ssh -c "uname -a"
```

* ¿Que sucede?
* Aparte de *up* existen otros comandos: `vagrant up|suspend|resume|halt|reload`
* Continuamos...

```
vagrant destroy -f
vagrant status
```

## 2. Las *boxes*

```shell
vagrant box add zipi ../../../ubuntu-xenial-64-zipi.box
vagrant box list
vagrant init zipi -fm
```

* Editamos el fichero *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end
```

* Ejecutamos

```shell
vagrant up
vagrant ssh -c "uname -a"
vagrant ssh -c "uname -a"
```

* ¿Que sucede?
* También podemos importar de remoto `vagrant init precise32 http://files.vagrantup.com/precise32.box -m -o Vagrantfile-precise`

## 3. El fichero Vagrantfile

```
vagrant ssh -c "ip addr"
```

* ¿Que sucede?
* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
  
  config.vm.network :private_network,
                ip: "192.168.56.100",
                virtualbox__intnet: true,
                auto_config: true
end
```

* Ejecutamos

```
vagrant reload
vagrant ssh -c "ip addr"
```

* ¿Que sucede?
* Continuamos...

```
mkdir extra
touch extra/this_is_a_test
```
* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.network :private_network,
                ip: "192.168.56.100",
                virtualbox__intnet: true,
                auto_config: true

  config.vm.synced_folder "./extra",
                "/vagrant-extra",
                owner: "vagrant",
                group: "vagrant",
                mount_options: ["dmode=775,fmode=664"]
end
```

* Ejecutamos

```
vagrant reload
vagrant ssh
    hostname
    ls /
    ls /vagrant
    touch /vagrant-extra/extra-file.txt
    ls /vagrant-extra
    exit
ls
ls extra
```

* ¿Que sucede?
* Otros: [Available Vagrant Plugins](https://github.com/hashicorp/vagrant/wiki/Available-Vagrant-Plugins)

## 4. Aprovisionamiento

```
vagrant ssh -c "whereis apachectl"
```

* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.network :private_network,
                ip: "192.168.56.100",
                virtualbox__intnet: true,
                auto_config: true

  config.vm.synced_folder "./extra",
                "/vagrant-extra",
                owner: "vagrant",
                group: "vagrant",
                mount_options: ["dmode=775,fmode=664"]

  config.vm.provision :shell, :inline => "apt-get update && apt-get -y install apache2"
end
```
* Ejecutamos

```
vagrant provision
vagrant ssh -c "whereis apachectl"
```

* ¿Que sucede?
* (Opcional) Aparte de *provision* podemos...

```
vagrant up --provision
vagrant up --no-provision
vagrant reload --provision
```

* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.network :private_network,
                ip: "192.168.56.100",
                virtualbox__intnet: true,
                auto_config: true

  config.vm.synced_folder "./extra",
                "/vagrant-extra",
                owner: "vagrant",
                group: "vagrant",
                mount_options: ["dmode=775,fmode=664"]

#  config.vm.provision :shell, :inline => "apt-get update && apt-get -y install apache2"
  config.vm.provision :shell, :path => "bootstrap.sh"
end
```

* Editamos *bootstrap.sh*

```
#!/usr/bin/env bash
apt-get update
apt-get -y install htop
```

* Salvamos y salimos con *:x*

```
vagrant ssh -c "whereis htop"
vagrant provision
vagrant ssh -c "whereis htop"
```

* ¿Que sucede?
* (opcional) Otros métodos de aprovisionamiento

```
# ansible
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "provisioning/playbook.yml"
end
```

* Más: [Provisioning](https://www.vagrantup.com/docs/provisioning/)

## 5. Reenvío de puertos

En el paso anterior hemos instalado el servidor web Apache. Vamos a ver su homepage.

```
vagrant ssh -c "systemctl status apache2.service"
vagrant ssh -c "ip addr"
```

* Abrimos un navegador y vamos a
	* http://192.168.56.100/
	* http://10.0.2.15/
	* http://172.17.0.1/
* ¿Que sucede?
* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "zipi"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.boot_timeout = 60

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  config.vm.network :private_network,
                ip: "192.168.56.100",
                virtualbox__intnet: true,
                auto_config: true

  config.vm.synced_folder "./extra",
                "/vagrant-extra",
                owner: "vagrant",
                group: "vagrant",
                mount_options: ["dmode=775,fmode=664"]

#  config.vm.provision :shell, :inline => "apt-get update && apt-get -y install apache2"
  config.vm.provision :shell, :path => "bootstrap.sh"

  config.vm.network "forwarded_port",
                guest: 80,
                host: 8080,
                auto_correct: true
end
```

* Ejecutamos

```
vagrant reload
vagrant ssh -c "systemctl status apache2.service"
```

* Abrimos un navegador y vamos a http://localhost:8080
* ¿Que sucede?

## 6. Eliminar el entorno

* Abrimos VirtualBox
* Continuamos en el Terminal

```
vagrant destroy -f
rm -Rf .vagrant
vagrant box list
```

* ¿Que sucede?
* Otros comandos útiles

```
vagrant box remove|update [name]
```

## 7. Iniciando más instancias

```
mv Vagrantfile Vagrantfile-single
vagrant box add zape ../../../ubuntu-xenial-64-zape.box
vagrant box list
vagrant status
```

* Editamos *Vagrantfile*

```ruby
Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 60

  config.vm.define "zipi" do |zipi|
    zipi.vm.provision :shell, :inline => "systemctl mask apt-daily.service && apt-get update && apt-get -y install apache2"
    zipi.vm.host_name = "zipi"
    zipi.vm.box = "zipi"
    zipi.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    zipi.vm.network "forwarded_port", host: 8080, guest: 80, auto_correct: true
    zipi.vm.network "private_network", ip: "192.168.56.10", virtualbox__intnet: true, auto_config: true
  end

  config.vm.define "zape" do |zape|
    zape.vm.provision :shell, :inline => "systemctl mask apt-daily.service && apt-get update && apt-get -y install curl wget lynx"
    zape.vm.host_name = "zape"
    zape.vm.box = "zape"
    zape.vm.provider "virtualbox" do |vb|
      vb.memory = 512
      vb.cpus = 1
    end
    zape.vm.network "forwarded_port", host: 8082, guest: 80, auto_correct: true
    zape.vm.network "private_network", ip: "192.168.56.11", virtualbox__intnet: true, auto_config: true
  end
end
```

* Ejecutamos

```
vagrant up --no-provision
vagrant provision
vagrant ssh zape
    curl http://192.168.56.10
```

* Abrimos un navegador y vamos a http://localhost:8080/
* ¿Que sucede?

## Eliminamos nuestro rastro

```
    exit
vagrant destroy -f
```

# Preguntas y respuestas

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
