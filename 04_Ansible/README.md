# Práctica de Git

## Requisitos previos: Entorno local

* Instalar Ansible - http://docs.ansible.com/ansible/intro_installation.html

NOTA: Windows no es compatible como máquina de control

## 1. 

ansible
ansible-doc
ansible-galaxy
ansible-playbook
ansible-pull
ansible-vault

```
$ ansible <host-pattern> [options]
$ ansible-doc [options] [module...]
$ ansible-galaxy [init|info|install|list|remove] [--help] [options] ...
$ ansible-playbook playbook.yml
$ ansible-pull [options] [playbook.yml]
$ ansible-vault [create|decrypt|edit|encrypt|rekey|view] [--help] [options] file_name
```

https://github.com/ansible/ansible/blob/devel/examples/ansible.cfg