# Sound of Sunshine

## General Information
- The application runs on the Apache Web Server. The web server folder is located in `/var/www/`

## Run
- The following Apache Modules should be activated: `cgi.load`, `session.load`, `session_cookie.load`

- Add the file `webserver.conf` in `/etc/apache2/sites-enabled/` with the following content:

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

- Restart the Apache service.
- Add the following lines to the file `/etc/rsyslog.conf`:

```
#
#Server manager log files
#
$template aso, "<%timestamp%> <%syslogpriority-text%>%msg%\n"
local0.*	/var/log/aso.log;aso
```

- Create the file `aso.log` en `/var/log/aso.log`.

- Restart the service `rsyslog`.

- To start LKM access the directory `led-handler-LKM` and execute `make install`.
