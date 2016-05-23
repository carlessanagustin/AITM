# Práctica de Nagios

Vamos a conocer NAGIOS, el sistema de monitorización - http://www.nagios.org/

Sigue las instrucciones paso a paso con la ayuda del instructor.

## Monitorizar un host

* Abrimos la carpeta **etc-nagios3** en un editor (Brackets, Sublime Text, Notepad++, ...)
* Abrir http://localhost:8082/nagios3/ > Current Status > Hosts
* ¿Que sucede?
* Abrir Git Bash (Windows) o Terminal (Linux/MacOSX)

```shell
vagrant up
vagrant ssh zape
sudo su -
cd /etc/nagios3
mkdir -p /etc/nagios3/conf.d/AITM
vim conf.d/AITM/zape.cfg
```

* Añadimos...

```shell
define host {
    host_name               zape.AITM-UPC.cat
    alias                   zape
    address                 192.168.32.11
    max_check_attempts      3
    check_period            24x7
    check_command           check-host-alive
    contacts                root
    notification_interval   60
    notification_period     24x7
}
```

* Salvamos y salimos con *:x*
* Ejecutamos...

```shell
/usr/sbin/nagios3 -v nagios.cfg
```

* ¿Que sucede?
* Ejecutamos...

```shell
service nagios3 reload
```

* Abrir http://localhost:8082/nagios3/ > Current Status > Hosts
* ¿Que sucede?

### NOTAS:

1. Los archivos de configuración deben terminar en *.cfg
2. Los archivos de configuración distinguen entre mayúsculas y minúsculas.

## Servicios, contactos, agenda y notificaciones.

* Abrir http://localhost:8082/nagios3/ > Current Status > Services
* ¿Que sucede?

```shell
vim conf.d/AITM/zape.cfg
```

* Añadimos...

```shell
define service {
    host_name              zape.AITM-UPC.cat
    service_description    HTTP
    check_command          check_http
    max_check_attempts     3
    check_interval         5
    retry_interval         1
    check_period           24x7
    notification_interval  60
    notification_period    weekends
    contacts               myadmin
}
define contact {
    contact_name                    myadmin
    alias                           administrador de AITM
    email                           introduce@tu_email.cat
    host_notification_commands      notify-host-by-email
    host_notification_options       d,u,r
    host_notification_period        24x7
    service_notification_commands   notify-service-by-email
    service_notification_options    w,u,c,r
    service_notification_period     24x7
}
define timeperiod {
    timeperiod_name  weekends
    alias            Weekends
    saturday         00:00-24:00
    sunday           00:00-24:00
}
```

* Salvamos y salimos con *:x*
* Ejecutamos...

```shell
/usr/sbin/nagios3 -v nagios.cfg
```

* ¿Que sucede?
* Ejecutamos...

```shell
service nagios3 reload
```

* Abrir http://localhost:8082/nagios3/ > Current Status > Services
* ¿Que sucede?

### NOTAS:

1. d,u,r == DOWN, becoming UNREACHABLE, or coming back UP.
2. w,u,c,r == WARNING, UNKNOWN, or CRITICAL states, and also when they recover and go back to being in the OK state.
3. notify-host-by-email >> commands.cfg

## Uso de la interfaz web

* Abrir http://localhost:8082/nagios3/ >>
* Current Status > Tactical Overview
* Reports > Availability
* Reports > Trends
* System > Scheduling Queue
* System > Configuration

## Localización de los ficheros en Ubuntu

### Para nagios3

* CONFIG: /etc/nagios3
* BIN: /usr/sbin/nagios3
* HTDOCS & more: /usr/share/nagios3

### Para nagios-nrpe-plugin

* CONFIG: /etc/nagios-plugins
* PLUGINS: /usr/lib/nagios (en Bash, Perl, Python, binarios, ...)

## Plugins (aun en zape)

* Abrir un nuevo Git Bash (Windows) o Terminal (Linux/MacOSX)

```shell
/usr/lib/nagios/plugins/check_http -I 192.168.32.10
/usr/lib/nagios/plugins/check_http -I 192.168.32.11
/usr/lib/nagios/plugins/check_http -I 192.168.32.12
```

* Abrir http://localhost:8082/nagios3/ > Current Status > Services
* ¿Que sucede?

```shell
vim conf.d/localhost_nagios2.cfg
...
check_command                   check_users!20!50
...
/usr/lib/nagios/plugins/check_users
Usage:
check_users -w <users> -c <users>
```

* ¿Que sucede?

```shell
more /usr/lib/nagios/plugins/check_oracle
more /usr/lib/nagios/plugins/check_ifstatus
```

* ¿Que sucede?

```shell
ls /usr/lib/nagios/plugins
```

* Abrimos https://nagios-plugins.org/doc/man/index.html
* Más plugins: https://exchange.nagios.org/

## Habilitando la ejecución remota

* En **zape**:

```shell
/usr/lib/nagios/plugins/check_nrpe
```

* ¿Que sucede?
* Introducimos en /etc/nagios3/conf.d/AITM/zape.cfg ...

```shell
define service {
    use                  generic-service
    host_name            zape.AITM-UPC.cat
    service_description  LOAD
    check_command        check_nrpe!check_load
}
```

```shell
/usr/lib/nagios/plugins/check_nrpe -H 192.168.32.10 -c check_load
```

* ¿Que sucede?

* En **zipi**:

```shell
vim /etc/nagios/nrpe.cfg
```

* Añadimos...

```shell
allowed_hosts=127.0.0.1, 192.168.32.0/24
```

* Buscar y revisar: command[check_users] ...

```shell
sudo su -
service nagios-nrpe-server start
/usr/lib/nagios/plugins/check_load localhost
```

* En **zape**:

```shell
/usr/lib/nagios/plugins/check_nrpe -H 192.168.32.10 -c check_load
```

* ¿Que sucede?
* Abrirmos https://www.digitalocean.com/community/tutorials/how-to-create-nagios-plugins-with-bash-on-ubuntu-12-10

# Preguntas y respuestas

# Eliminamos las instancias Vagrant

```
vagrant destroy -f
```

---

# Solución de problemas

* Problema: No sucede nada accediendo a http://localhost:8082/nagios3/
* Solución:

```shell
vagrant ssh zape -c "sudo service apache2 restart"
vagrant ssh zape -c "sudo service nagios3 restart"
```

------

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)
