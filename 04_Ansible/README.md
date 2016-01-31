# Práctica de Ansible

## Requisitos previos: Entorno local

* Instalar Ansible - http://docs.ansible.com/ansible/intro_installation.html

NOTA: Windows no es compatible como máquina de control

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)
* Iniciamos máquinas virtuales

## "hello world"

```
$ vagrant up zape zipi
$ vagrant ssh zape
~$ mkdir -p ansible/hosts && cd ansible
~$ vim hosts/all
```

* Añadimos...

```
[localhost]
127.0.0.1

[zipi]
192.168.32.10

[zape]
192.168.32.10
```

* Salvamos y salimos con *:x*
* Ejecutamos...

```
~$ ansible localhost -i hosts/all -m ping
~$ ansible zape -i hosts/all -m ping
```

* ¿Que sucede?

## Inventario

```
~$ vim hosts/all
```

* Actualizamos...

```
[localhost]
127.0.0.1

[zipi]
192.168.32.10

[zipi:vars]
ntp_server=es.pool.ntp.org
ansible_ssh_user=vagrant

[zape]
192.168.32.11 ansible_ssh_user=vagrant ansible_ssh_pass=vagrant

[entorno:children]
zipi
zape
```

* Salvamos y salimos con *:x*

```
~$ ansible localhost -i hosts/all -m ping
~$ ansible zipi -i hosts/all -m ping
~$ ansible zape -i hosts/all -m ping
```

* ¿Que sucede?

```
~$ ansible zipi -i hosts/all -m ping -k
```

* Introducimos la contraseña del usuario vagrant que es *vagrant*.

* ¿Que sucede?

* También podemos obtener la información de inventorios dinámicos: http://docs.ansible.com/ansible/intro_dynamic_inventory.html

## Configuración

```
~$ wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
~$ vim ansible.cfg
```

* Aseguramos que tenemos la siguiente configuración

```
remote_user   = vagrant

# ask_pass      = True
sudo_user      = root
sudo           = yes
# ask_sudo_pass = True

host_key_checking = False
gathering = smart
```

* Salvamos y salimos con *:x*

TODO: carles

### Orden de prioridad del fichero de configuración

1. ANSIBLE_CONFIG (an environment variable)
2. ansible.cfg (en carpeta actual)
3. ~/.ansible.cfg (en el directorio home del usuario ejecutor)
4. /etc/ansible/ansible.cfg

## Playbook

TODO: carles

## Roles

TODO: carles


## Comandos Ansible

* Los ya conocidos...

```
$ ansible <host-pattern> [options]
$ ansible-playbook playbook.yml
```

* Lo menos conocidos...

```
$ ansible-doc [options] [module...]
$ ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
$ ansible-pull [options] [playbook.yml]
$ ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

# Preguntas y respuestas

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)