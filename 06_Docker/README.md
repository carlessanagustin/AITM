# Práctica de Docker

Vamos a conocer DOCKER; Docker permite empaquetar una aplicación con todas sus dependencias en una unidad estandarizada para el desarrollo de software. - https://www.docker.com/

Sigue las instrucciones paso a paso con la ayuda del instructor. Las prácticas de realizarán en una instancia Ubuntu de Vagrant.

## 0. Requisitos previos: Entorno local

* Instalar Docker - https://docs.docker.com/engine/installation/

* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)
* Iniciamos máquina virtual:

```shell
vagrant up && vagrant ssh
```

* Abrimos otro terminal siguiendo los pasos anteriores hasta obtener algo similar:

![Terminales de trabajo](terminals.png)

* Usaremos el terminal 1 para trabajar con contenedores Docker.
* Usaremos el terminal 2 (T2) para monitorizar los containers con el comando siguiente

```shell
watch docker ps -a
```

## 1. "hello world"

```shell
docker run hello-world
```

* ¿Que sucede?

## 2. ¿Que es un contenedor?

```shell
docker run -it busybox
ls /
hostname
ps aux
exit
docker images
```

* ¿Que sucede?
* Contenedor usado: https://hub.docker.com/_/busybox/

## 3. Interactuando con contenedores

```shell
c_id=$(docker run --name docker_example -itd busybox)
echo $c_id
docker attach docker_example
hostname
exit
```

* Apretamos CTRL+P & Q para volver a la VM de Vagrant
* ¿Que sucede?

```shell
docker inspect $c_id
docker inspect --format '{{.NetworkSettings.IPAddress}}' $c_id
docker_hostname=$(docker inspect --format '{{.HostnamePath}}' $c_id)
echo $docker_hostname
sudo more $docker_hostname
echo $c_id
docker stop $c_id
```

* ¿Que sucede?

## 4. Limpiar el entorno local

```shell
docker run --name docker_example -itd busybox
docker ps
docker ps -a
docker ps -aq
```

* ¿Que sucede?

```shell
docker rm $(docker ps -aq)
```

* ¿Que sucede?

## 5. Composición docker-compose.yml + Dockerfile

Compondremos un servidor de aplicaciones Python/Flask con una base de datos Redis.

* Preparación del entorno

```shell
docker pull redis
docker pull python:2.7
docker pull tomcat
docker pull nginx
```

* El script de Docker Compose:

```shell
mkdir -p /vagrant/aitm-06_Docker && cd /vagrant/aitm-06_Docker
vim docker-compose.yml
```

* Añadimos...

```yaml
version: '3'

services:
  web:
    build: .
    command: python app.py
    ports:
     - "5000:5000"
    volumes:
     - .:/code
    links:
     - redis
  redis:
    image: redis
```

* Salvamos y salimos con *:x*
* El Dockerfile:

```shell
vim Dockerfile
```

* Añadimos...

```
FROM python:2.7
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
```

* Salvamos y salimos con *:x*
* Código Python sobre entorno de Flask con conexión a Redis:

```shell
vim app.py
```

* Añadimos...

```python
from flask import Flask
from redis import Redis
import os
app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello World! I have been seen %s times.' % redis.get('hits')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

* Salvamos y salimos con *:x*
* Los requerimientos mínimos de Python

```shell
vim requirements.txt
```

* Añadimos...

```
flask
redis
```

* Salvamos y salimos con *:x*
* Ejecutamos la aplicación

```shell
docker-compose up -d
docker-compose ps
docker-compose logs
curl localhost:5000
```

* ¿Que sucede?
* Abrimos un navegador y vamos a http://127.0.0.1:5000/
* ¿Que sucede?

```shell
docker-compose stop
```

* ¿Que sucede?

## Composiciones avanzadas de Docker

Compondremos varios servidores de aplicación Tomcat con balanceador de carga Nginx.

## Ficheros de configuración

* Configuración del balanceo con Nginx:

```shell
vim nginx.conf
```

* Añadimos...

```
worker_processes 1;

events { worker_connections 1024; }

http {

    sendfile on;

    gzip              on;
    gzip_http_version 1.0;
    gzip_proxied      any;
    gzip_min_length   500;
    gzip_disable      "MSIE [1-6]\.";
    gzip_types        text/plain text/xml text/css
                      text/comma-separated-values
                      text/javascript
                      application/x-javascript
                      application/atom+xml;

    # List of application servers
    upstream app_servers {

        server tomcatapp1:8080;
        server tomcatapp2:8080;
        server tomcatapp3:8080;

    }

    # Configuration for the server
    server {

        # Running port
        listen [::]:80;
        listen 80;

        # Proxying the connections connections
        location / {

            proxy_pass         http://app_servers;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host $server_name;
        }
    }
}
```

* Salvamos y salimos con *:x*
* El script de Docker Compose para Tomcat con Nginx:

```shell
vim compose-tomcat.yml
```

* Añadimos...

```
nginx:
  image: nginx
  links:
   - tomcatapp1:tomcatapp1
   - tomcatapp2:tomcatapp2
   - tomcatapp3:tomcatapp3
  ports:
   - "80:80"
  volumes:
   - nginx.conf:/etc/nginx/nginx.conf
tomcatapp1:
  image: tomcat
  volumes:
   - sample.war:/usr/local/tomcat/webapps/sample.war
tomcatapp2:
  image: tomcat
  volumes:
   - sample.war:/usr/local/tomcat/webapps/sample.war
tomcatapp3:
  image: tomcat
  volumes:
   - sample.war:/usr/local/tomcat/webapps/sample.war
```

* Salvamos y salimos con *:x*
* Descargamos el fichero WAR de muestra

```shell
wget https://github.com/carlessanagustin/DockerDo/raw/master/08_Compose/sample.war
```

## Pasamos a la acción

* Ejecutamos...

```shell
$ docker-compose up -d -f compose-tomcat.yml
T2$ docker-compose ps
$ docker exec composetest_nginx_1 cat /etc/hosts
$ docker exec composetest_tomcatapp1_1 ip a
$ docker exec composetest_tomcatapp2_1 ip a
$ docker exec composetest_tomcatapp3_1 ip a
$ curl http://127.0.0.1/sample/
```

* ¿Que sucede?

# Limpiamos en entorno

```
docker-compose stop
docker-compose rm
```

# Eliminamos las instancias Vagrant

```
vagrant destroy -f
```

---

# Comandos útiles

* Añadir en ` ~/.bashrc`

```shell
alias my_dock_kill_rm='docker kill $(docker ps -aq) ; docker rm $(docker ps -aq)'
alias my_dock_rmi_all='docker rmi -f $(docker images -aq)'
my_dock_teardown() { docker kill $(docker ps -aq) ; docker rm $(docker ps -aq) ; docker rmi -f $(docker images -aq) ; docker volume prune -f ; docker network prune -f ; }
my_dock_in() { docker exec -it $1 sh ; }
```

---

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
