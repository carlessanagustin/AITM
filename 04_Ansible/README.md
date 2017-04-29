# Práctica de Ansible

Vamos a conocer ANSIBLE; herramienta para el despliegue de aplicaciones y gestión de la configuración - http://www.ansible.com/

Sigue las instrucciones paso a paso con la ayuda del instructor. Las prácticas de realizarán en una máquina Ubuntu de Vagrant.

## Requisitos previos: Entorno local

* Instalar Ansible - http://docs.ansible.com/ansible/intro_installation.html

> NOTA: Windows no es compatible como máquina de control

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)

## Configuración

* Iniciamos el entorno

```shell
vagrant up && vagrant ssh zape
```

* Preparamos la carpeta de trabajo

```shell
cd /vagrant && mkdir -p ansible/hosts && cd ansible
sudo cp /etc/ansible/ansible.cfg .
vim ansible.cfg
```

> Tambien podemos descargar la configuración del respositorio oficial: https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg

* Aseguramos que tenemos la siguiente configuración en `ansible.cfg`

```python
remote_user = ubuntu
host_key_checking = False
```

* Salvamos y salimos con *:x*

> NOTA: Orden de prioridad del fichero de configuración:
1. ANSIBLE_CONFIG (variable de entorno POSIX)
2. ansible.cfg (en carpeta actual)
3. ~/.ansible.cfg (en el directorio home del usuario ejecutor)
4. /etc/ansible/ansible.cfg

## "hello world"

* Especificamos el inventorio de instancias
* Creamos el archivo `hosts/all`

```ini
[zape]
192.168.56.11

[base]
192.168.56.12
```

* Ejecutamos

```shell
ansible zape -i hosts/all -m ping -k
```

* ¿Que sucede?
* Introducimos la contraseña del usuario ubuntu que es `e43b35d5be0112aeaa005902`.

> Para obtener la contraseña:
root# cat ~/.vagrant.d/boxes/ubuntu-VAGRANTSLASH-xenial64/20170331.0.0/virtualbox/Vagrantfile

* ¿Que sucede?
* Construimos nuestro primer playbook de Ansible
* Creamos el archivo `request.yml`

```yaml
---
- hosts: base

  tasks:
    - name: que sistema eres?
      command: uname -a
      register: info

    - name: imprimir variable
      debug: var=info

    - name: imprimir campo de variable
      debug: var=info.stdout

    - name: como te llamas?
      command: hostname
      register: info

    - name: dame tu nombre
      debug: var=info.stdout
```

* Cambiamos el archivo `hosts/all`

```ini
[zape]
192.168.56.11

[base]
192.168.56.12

[all:vars]
ansible_connection=ssh
ansible_ssh_user=ubuntu
ansible_ssh_pass=e43b35d5be0112aeaa005902
```

> Para obtener la contraseña:
root# cat ~/.vagrant.d/boxes/ubuntu-VAGRANTSLASH-xenial64/20170331.0.0/virtualbox/Vagrantfile

* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml \
    --list-hosts --list-tasks
```

* ¿Que sucede?
* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?
* Creamos un usuario y lo configuramos

> Para crear una contraseña:
root# mkpasswd --method=sha-512
root# Password: jenkins123

* Añadimos al archivo `request.yml`

```yaml
    - name: Accion "useradd -m -s /bin/bash jenkins"
      become: yes
      user:
        name: jenkins
        createhome: yes
        shell: /bin/bash
        password: "$6$sSmkJFIO$pA7AEcYSe6ojzVvZmf/dflLs6d5s/59ZvFCAAJ/OUM4IrfD7egKFo9gro6OXyLhzfSQe20u7cOKKc8n4LYmN3."

    - name: Añadir "jenkins ALL=(ALL) NOPASSWD:ALL" a /etc/sudoers
      become: yes
      lineinfile:
        dest: /etc/sudoers
        state: present
        regexp: '^jenkins'
        line: 'jenkins ALL=(ALL) NOPASSWD:ALL'
        validate: visudo -cf %s

```

* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?
* Instalamos los paquetes necesarios para arrancar nuestro código.
* Añadimos al archivo `request.yml`

```yaml
    - name: Instalamos requerimientos para RedHat based OS
      become: yes
      yum:
        name: "{{ item }}"
        state: latest
        update_cache: yes
      with_items:
        - gcc-c++
        - make
        - vim
        - wget
        - git
      when: ansible_os_family == "RedHat"

    - name: Instalamos requerimientos para Debian based OS
      become: yes
      apt:
        name: "{{ item }}"
        state: latest
        update_cache: yes
        cache_valid_time: 3600
      with_items:
        - build-essential
        - vim
        - wget
        - git
        - python-minimal
      when: ansible_os_family == "Debian"
```

* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?
* Instalamos nodejs para distribuciones RedHat y Debian.
* Añadimos al archivo: `request.yml`

```yaml
    - name: Download nodejs repo script
      get_url:
        url: "{{ nodejs_url }}"
        dest: "{{ ansible_env.HOME}}/nodejs.sh"

    - name: Run nodejs repo script
      become: yes
      shell: "bash {{ ansible_env.HOME}}/nodejs.sh"

    - name: Instalamos nodejs para RedHat based OS
      become: yes
      yum:
        name: nodejs
        state: latest
        update_cache: yes
      when: ansible_os_family == "RedHat"

    - name: Instalamos nodejs para Debian based OS
      become: yes
      apt:
        name: nodejs
        state: latest
        update_cache: yes
        cache_valid_time: 3600
      when: ansible_os_family == "Debian"

  vars_files:
    - "./vars_{{ ansible_os_family }}.yml"
```

* Creamos el archivo `vars_RedHat.yml`: 

```yaml
---
nodejs_url: "https://rpm.nodesource.com/setup_4.x"
```

* Creamos el archivo `vars_Debian.yml`: 

```yaml
---
nodejs_url: "https://deb.nodesource.com/setup_4.x "
```

* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?
* Descargamos el repositorio del código, instalamos dependencias y iniciamos aplicación.
* Añadimos al archivo `request.yml`

```yaml
    - name: Descargamos el repositorio
      git:
        repo: https://github.com/xescuder/ait.git
        dest: "{{ ansible_env.HOME}}/ait"
        version: 9abd6d6ac6533f0cb03274fb252f723373cbb1d9
        force: yes

    - name: Accion "npm install pm2"
      npm:
        name: "{{ item }}"
        path: "{{ ansible_env.HOME}}/ait/node_modules"
        state: latest
      with_items:
        - pm2

    - name: Run app
      command: node_modules/pm2/bin/pm2 start server/start.js
      args:
        chdir: "{{ ansible_env.HOME}}/ait"
```

* Ejecutamos

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?
* (opcional) Securizar ficheros

```shell
ansible-vault encrypt \
    --output=SECURErequest.yml \
    request.yml
```
* (opcional) ¿Que sucede?

## Comandos

* Los ya conocidos...

```shell
ansible <host-pattern> [options]
ansible-playbook playbook.yml
ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

* Otros comandos incluidos en la instalación...

```shell
ansible-doc [options] [module...]
ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
ansible-pull [options] [playbook.yml]
```

# Preguntas y respuestas

# Eliminamos las instancias Vagrant

```
vagrant destroy -f
```

------

# Información extra

## Generar claves de autenticación de SSH

```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): /home/vagrant/.ssh/id_rsa_ansible
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/vagrant/.ssh/id_rsa_ansible.
Your public key has been saved in /home/vagrant/.ssh/id_rsa_ansible.pub.
The key fingerprint is:
50:e6:96:7b:5b:e7:70:bf:1e:82:b8:b9:75:60:dc:23 your_email@example.com
The key's randomart image is:
+--[ RSA 4096]----+
|        o        |
|       + .       |
|      . +        |
|       o .. .    |
|        S .Eooo  |
|         .oo+=.. |
|         ..o o...|
|          + . . o|
|         +.   .o |
+-----------------+
ssh-copy-id -i /home/vagrant/.ssh/id_rsa_ansible.pub vagrant@192.168.56.11
```

---

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
