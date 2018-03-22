# Práctica de Ansible

Vamos a conocer ANSIBLE; herramienta para el despliegue de aplicaciones y gestión de la configuración - http://www.ansible.com/

Sigue las instrucciones paso a paso con la ayuda del instructor. Las prácticas de realizarán en una máquina Ubuntu de Vagrant.

## 0. Requisitos previos: Entorno local

* Instalar Ansible - http://docs.ansible.com/ansible/intro_installation.html

> NOTA: Windows no es compatible como máquina de control

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)

## 1. Configuración de SSH

* Iniciamos el entorno

```shell
vagrant ssh-config
mkdir -p ansible/keys
cp ~/.vagrant.d/boxes/zape/0/virtualbox/vagrant_private_key ./ansible/keys/vagrant_private_key_zape
cp ~/.vagrant.d/boxes/zipi/0/virtualbox/vagrant_private_key ./ansible/keys/vagrant_private_key_zipi
vagrant up && vagrant ssh zape
```

* En otra ventana de terminal ejecutamos:

```
vagrant ssh zipi
```

## 2. Configuración de Ansible

* Preparamos la carpeta de trabajo (zape)

```shell
cd /vagrant/ansible && mkdir -p hosts
sudo cp /etc/ansible/ansible.cfg .
```

> Tambien podemos descargar la configuración del respositorio oficial: https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg

* Editamos `ansible.cfg`
* Aseguramos que tenemos la siguiente configuración en `ansible.cfg`

```python
remote_user = vagrant
host_key_checking = False
```

> NOTA: Orden de prioridad del fichero de configuración:
1. ANSIBLE_CONFIG (variable de entorno POSIX)
2. ansible.cfg (en carpeta actual)
3. ~/.ansible.cfg (en el directorio home del usuario ejecutor)
4. /etc/ansible/ansible.cfg

## 3. "hello world"

* Especificamos el inventorio de instancias
* Creamos el archivo `hosts/all` (zape)

```ini
[zape]
192.168.56.11

[zipi]
192.168.56.10
```

* Ejecutamos (zape)

```shell
ansible zape -i hosts/all -m ping --key-file=./keys/vagrant_private_key_zape
```

* ¿Que sucede?

## 3. El playbook

* Construimos nuestro primer playbook de Ansible
* Creamos el archivo `request.yml` (zape)

```yaml
---
- hosts: zipi

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

* Cambiamos el archivo `hosts/all` (zape)

```ini
[zape]
192.168.56.11 ansible_ssh_private_key_file=./keys/vagrant_private_key_zape

[zipi]
192.168.56.10

[zipi:vars]
ansible_connection=ssh
ansible_user=vagrant
ansible_ssh_private_key_file=./keys/vagrant_private_key_zipi
```

> Ansible Behavioral Inventory Parameters: http://docs.ansible.com/ansible/latest/intro_inventory.html#list-of-behavioral-inventory-parameters

* Ejecutamos (zape)

```
ansible all -i hosts/all -m ping
```

* ¿Que sucede?
* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml \
    --list-hosts --list-tasks
```

* ¿Que sucede?
* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?

## 4. Primeros cambios

* Confirmamos que no existe ningun usuario `jenkins` en la VM zipi (local)

```
vagrant ssh zipi -c "sudo cat /etc/shadow | grep -i jenkins"
```

* Creamos un usuario y lo configuramos
* Añadimos al archivo `request.yml` (zape)

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

> Para crear una contraseña:
root# mkpasswd --method=sha-512
root# Password: jenkins123

* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml
```

* Confirmamos que no existe ningun usuario `jenkins` en la VM zipi (local)

```
vagrant ssh zipi -c "sudo cat /etc/shadow | grep -i jenkins"
```

* ¿Que sucede?
* Instalamos los paquetes necesarios para arrancar nuestro código.
* Añadimos al archivo `request.yml` (zape)

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

* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?

> Mostrar facts (variables) de Ansible: `ansible zipi -i hosts/all -m setup`
> Más sobre variables: http://docs.ansible.com/ansible/latest/playbooks_variables.html

## 5. Preparamos entorno para nuestra aplicación

* Instalamos nodejs para distribuciones RedHat y Debian.
* Añadimos al archivo: `request.yml` (zape)

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

* Creamos el archivo `vars_RedHat.yml` (zape)

```yaml
---
nodejs_url: "https://rpm.nodesource.com/setup_4.x"
```

* Creamos el archivo `vars_Debian.yml` (zape)

```yaml
---
nodejs_url: "https://deb.nodesource.com/setup_4.x "
```

* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml
```

* ¿Que sucede?

> IMPORTANTE: Ponemos la sección `vars_files` en la parte superior de `request.yml` (zape)

## 6. Publicamos nuestra aplicación

* Visitamos: `http://localhost:3000`
* ¿Que sucede?
* Descargamos el repositorio del código, instalamos dependencias y iniciamos aplicación.
* Añadimos al archivo `request.yml` (zape)

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

* Ejecutamos (zape)

```
ansible-playbook \
    -i hosts/all request.yml
```

* Visitamos de nuevo: `http://localhost:3000`
* ¿Que sucede?

> Código: https://github.com/xescuder/ait/tree/9abd6d6ac6533f0cb03274fb252f723373cbb1d9
> Ver contenido `vagrant ssh zipi -c "ls ait"`. Ejecutar en terminal local.

## 7. Comandos

* Securizar ficheros

```shell
ansible-vault encrypt \
    --output=SECURErequest.yml \
    request.yml
```
* ¿Que sucede?
* Los ya conocidos...

```shell
ansible <host-pattern> [options]
ansible-playbook playbook.yml
ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

* Otros comandos interesantes...

```shell
ansible-doc [options] [module...]
ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
ansible-pull [options] [playbook.yml]
```

> Public Ansible role repository: https://galaxy.ansible.com/

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
