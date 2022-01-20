#Como hacer funcionar la práctica:

Esta práctica funciona sobre el servidor web Apache

La carpeta `webserver` debe ir dentro del directorio `/var/www/`

Módulos Apache que se deben activar: `cgi.load`, `session.load`, `session_cookie.load`

Añadir fichero `webserver.conf` en `/etc/apache2/sites-enabled/` con el siguiente contenido:

```
<VirtualHost *:80>
 ServerAdmin user@localhost
 ServerName aso
 ServerAlias aso
 DocumentRoot /var/www/webserver

 Session ON
 SessionEnv ON
 SessionCookieName session path=/
 SessionHeader X-Replace-Session

 <Directory "/var/www/webserver/bin">
   Options +ExecCGI
   AllowOverride None
   AddHandler cgi-script .sh
 </Directory>

 ErrorLog ${APACHE_LOG_DIR}/error.log
 CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Hacer un restart del servicio Apache

Añadir estas líneas al fichero `/etc/rsyslog.conf`:

```
#
#Server manager log files
#
$template aso, "<%timestamp%> <%syslogpriority-text%>%msg%\n"
local0.*	/var/log/aso.log;aso
```

Crear fichero `aso.log` en `/var/log/aso.log`

Hacer un restart del servicio `rsyslog`

Para iniciar el LKM, acceder al directorio `led-handler-LKM` y ejecutar `make install`
