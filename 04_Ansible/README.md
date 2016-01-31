# Práctica de Ansible

## Requisitos previos: Entorno local

* Instalar Ansible - http://docs.ansible.com/ansible/intro_installation.html

NOTA: Windows no es compatible como máquina de control

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)
* Iniciamos máquinas virtuales

```
$ vagrant up zipi zape
```

## Comandos Ansible

```
$ ansible <host-pattern> [options]
$ ansible-playbook playbook.yml
```

```
$ ansible-doc [options] [module...]
$ ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
$ ansible-pull [options] [playbook.yml]
$ ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg



# Preguntas y respuestas

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)