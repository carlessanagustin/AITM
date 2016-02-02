# Práctica de Nagios



Introducimos etc-nagios3/conf.d/AITM/zape.cfg

```
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

$ vagrant ssh zape
/usr/sbin/nagios3 -v nagios.cfg
ok? then: service nagios3 reload
Abrir http://localhost:8080/nagios3/ > Current Status > Hosts


# Preguntas y respuestas

# Solución de problemas

* Problema: No sucede nada accediendo a http://localhost:8082/nagios3/
* Solución:

```
$ vagrant ssh zape -c "sudo service apache2 restart"
```

------

Creado por [carlessanagustin.com](http://www.carlessanagustin.com)