# Práctica de Git

Vamos a conocer GIT para el control de versiones de nuestros ficheros - http://git-scm.com/

Sigue las instrucciones paso a paso con la ayuda del instructor.

## Requisitos previos: Entorno local

* Instalar Git - https://git-scm.com/
* Instalar Cliente Git - https://git-scm.com/downloads/guis

## Ejercicio

* Realizar los siguientes ejercicios - http://try.github.io

---

## Configuración general

```
git config --global user.name "name surname"
git config --global user.email email@example.com
git config --list
```

## Crear proyecto

```
mkdir temp
cd temp
git init
```

## Ver estado

```
git status
git log
git diff
.gitignore
```


## Descargar proyecto

```
git clone <URL.git>
```

## Instantáneas

(snapshots o compromiso)

```
git add .
git commit -m "<message>"
```

## Compartir proyectos (colaborar)

```
git pull <remote_alias> <branch_name>
git remote add <remote_alias> <url>
(remote_alias == origin)
git remote -v
git push -u <remote_alias> <branch_name>
(remote_alias == origin)
git push -u origin --all
git push -u origin --tags
```

## Ramas

```
git branch <branch_name>
git checkout <branch_destination>
git merge <branch_origen>
git diff <branch_destination>..<branch_origen>
```

## Vocabulario básico

* HEAD: rama actual
* HEAD^: padre de HEAD
* HEAD-4: 4 pasos atras de HEAD

## Deshacer

```
* git checkout HEAD <file>
* git reset --hard HEAD
* git revert <commit>
* git reset --hard <commit>
* git reset <commit>
* git reset --keep <commit>
```

## Etiquetas

```
git tag -a v1.4 -m 'my version 1.4'
git tag
git show v1.4
git log --pretty=oneline
git tag -a v1.2 9fceb02
```

# Preguntas y respuestas

---

# Conexión remota (seguridad)

```
ssh-keygen
ssh-agent /bin/bash
ps -e  | grep [s]sh-agent
ssh-add ~/.ssh/id_rsa
ssh-add -l
cat ~/.ssh/id_rsa.pub
```

---

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
