# The sound of sunshine

## Resumen de la práctica
El objetivo ha sido crear un servidor web capaz de gestionar diversos aspectos y funcionalidades de un sistema Raspbian (funcionando en una Raspberry Pi Zero WH).

Para poder crear la interfaz web que gestiona el sistema y poder dar respuesta a las diferentes peticiones HTTP, se ha utilizado el programa servidor HTTP Apache.

Una página web se diseña utilizando HTML (y usualmente se añaden estilos CSS y JavaScript). En esta práctica se han creado _scripts_ interpretados por `bash` que al ejecutarse sirven el contenido HTML que el navegador mostrará. También se ha utilizado CSS y JavaScript para una mejor experiencia de usuario. Estos _scripts_ también se encargan de la lógica de la web, llenando cada página con su respectiva información sobre el sistema y utilizando _scripts_ auxiliares para suplir todas las funcionalidades de manera ordenada y eficiente.

Las funcionalidades que la interfaz web dispone para la gestión del sistema son las siguientes:
- Login
- Gestión de procesos
- Monitorización
- Apagar y reiniciar el servidor
- Gestión de _logs_
- Gestión de usuarios
- Filtrado de paquetes
- Gestión de procesos programados
- Funcionalidades musicales
- Webgrafía

Se explicarán los objetivos y el funcionamiento de estas funcionalidades y sus respectivos _scripts_ más adelante.

## Configuración

### Configuración del servidor Apache

Al instalar Apache en la máquina mediante el comando `sudo apt install apache2`, se crean dos árboles de directorios importantes para el desarrollo de la web.

- `/etc/apache2`: En este directorio se encuentran los archivos necesarios para la configuración del servidor Apache y del comportamiento que éste tiene que tener al servir las diferentes páginas web que puede gestionar así como los diferentes opciones y permisos para los directorios y ficheros presentes en `/var/www`.
Dentro de este directorio cabe destacar los siguientes archivos y directorios:

 En el directorio `/etc/apache2/mods-available` se encuentran los módulos disponibles para el servidor Apache y en el directorio `/etc/apache2/mods-enabled` se encuentran los _soft links_ de los módulos que se están utilizando en el servidor, que apuntan al directorio `mods-available`. Estos módulos son útiles ya que añaden funcionalidades extra a nuestro servidor, como por ejemplo, los módulos utilizados en esta práctica han sido el módulo `cgi.load` el cual permite la ejecución de los _scripts_ en la máquina para mostrar el _output_ en la interfaz web en vez de mostrar el código fuente de éste, el módulo `rewrite.load` el cual permite mapear URLs a diferentes ficheros del sistema (esto es útil para que al acceder a la URL `/login` se acceda realmente a un fichero `/bin/login.sh`, por ejemplo) o los módulos de gestión sesiones `session.load` y `session_cookie.load` para poder controlar aspectos en las sesiones del navegador y poder crear _cookies_ de sesión.

  Para habilitar estos módulos y crear un _link_ de éstos en `mods-enabled` se ha utilizado el comando `sudo a2enmod <módulo>`.

 Además y de forma similar, existen los directorios `/etc/apache2/sites-available` donde se pueden crear los ficheros de configuración orientados a cada plataforma web gestionada por Apache. En el caso de esta práctica se ha creado el fichero `webserver.conf` el cual se ve de la siguiente manera:
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
 En esta configuración se puede observar que este _host virtual_ da respuesta a peticiones provenientes en el puerto 80, se menciona el _path_ donde se encuentran los recursos a servir en `DocumentRoot /var/www/webserver`, se configura el módulo de sesión o que se asignan una serie de configuracioens al directorio `/var/www/webserver/bin` como `Options +ExecCGI` o `AddHandler cgi-script .sh` para que se permita la ejecución de los _scripts_ presentes en este árbol de directorios.

 Cabe destacar que para habilitar la configuración de esta plataforma web, de forma similar a los directorios antes mencionados, se debe crear un _soft link_ del fichero presente en `sites-available` a `sites-enabled` para que se pueda servir dicha página web. Por ejemplo, en este caso se puede utilizar el comando `sudo a2ensite webserver.conf`.

 Al hacer modificaciones dentro de el directorio `/etc/apache2/` como por ejemplo, habilitar un módulo o cambiar la configuración de una interfaz web, se deberá reiniciar el _daemon_ de Apache para que estos cambios se hagan efectivos. Por ejemplo utilizando el comando `sudo systemctl restart apache2`.

- `/var/www`: Dentro de este directorio se almacenarán los directorios correspodientes a las diferentes webs que Apache gestionará. En este caso, solo se ha creado una plataforma web por lo que únicamente se ha creado un directorio llamado `/var/www/webserver` el cual contiene los directorios `/var/www/webserver/bin` donde se almacenan los _script_ que se ejecutarán y que permitirán la navegación por la interfaz web formando el HTML pertinente. Dentro de este directorio se puede encontrar un subdirectorio llamado `/var/www/webserver/bin/utils` el cual contiene _scripts_ útiles para gestionar las diferentes peticiones HTTP que puedan surgir desde la interfaz web así como la lógica de algunos procesos o la redirección entre las diferentes páginas web. También podemos encontrar los directorios `/var/www/webserver/css` donde se almacenan las hojas de estilo CSS que estructuran y estilizan las diferentes páginas de la web, `/var/www/webserver/js` donde se almacenan los archivos JavaScript necesarios para algunas  funcionalidades para mejorar la experiencia en la web, `/var/www/webserver/img` donde se almacenan las imágenes que muestra la plataforma web y por último `/var/www/webserver/music` donde se almacena la música necesaria para la funcionalidad musical del servidor.

Además, al instalar Apache, se crea usuario que gestiona los procesos de Apache, `www-data`. Para que éste pueda ejecutar programas con permisos de administrador para gestionar las diferentes peticiones desde la interfaz web, se ha añadido este usuario al grupo de usuarios `sudo` mediante el comando: `sudo usermod -a -G sudo www-data`. Para que no sea necesaria la contraseña del usuario `www-data` al ejecutar comandos con permisos de administrador mediante `sudo`, también se ha creado un fichero en el directorio `/etc/sudoers.d/` llamado `010_apache-nopasswd` con la siguiente línea: `www-data ALL=(ALL) NOPASSWD: ALL` de manera que `www-data` podrá ejecutar los comandos con `sudo` sin necesidad de especificar su contraseña.

### Configuración de los _logs_

Para la gestión de _logs_ de la interfaz web, se ha querido generar un nuevo fichero llamado `/var/log/aso.log` donde se almacenarán los _logs_.

Para el correcto funcionamiento de la gestión de _logs_ se ha añadido la siguiente configuración en el fichero `/etc/rsyslog.conf` para que se puedan gestionar estos _logs_ con el comando `logger`:

```
#
#Server manager log files
#
$template aso, "<%timestamp%> <%syslogpriority-text%>%msg%\n"
local0.*	/var/log/aso.log;aso
```

Como se puede observar, se ha creado una plantilla para los _logs_ que se almacenarán en el fichero `aso.log` donde se querrá mostrar la fecha en la cual se ha producido el _log_, su prioridad y el mensaje en cuestión. Además se ha indicado que los _logs_ con la _facility_ `local0` (ya que es una facility no utilizada por otros elementos de la máquina servidor, de manera que se ha decidido utilizar esta facility para los _logs_ de algunas de las acciones que el usuario ejecuta desde la interfaz web) y con cualquier prioridad se añadan al fichero `/var/log/aso.log` con la plantilla creada anteriormente.

Para hacer esta configuración efectiva, se ha tenido que reiniciar el servicio `rsyslog`. Por ejemplo mediante el comando `sudo systemctl restart rsyslog`.

## Scripts

A continuación se explicarán los _scripts_ utilizados según las diferentes funcionalidades del trabajo, presentes en el directorio `/var/www/webserver/bin/`.

#### Scripts generales

- `utils/redirect.sh`: Este _script_ redirige al usuario a un _path_ distinto mediante la etiqueta `<meta http-equiv="refresh" content="0; url=$1">` que se encuentra en el `<head>` del HTML que muestra, sin que exista una interacción por parte del usuario. Esto es útil para realizar operaciones en "background" que requieren de _scripts_ auxiliares y volver a redirigir al usuario a un _script_ que muestre un HTML al acabar la ejecución de dichos _scripts_. Por ejemplo, al hacer _login_, se ejecutará un _script_ que interpretará las credenciales y las validará o no y redirigirá al usuario a un _script_ que muestre un HTML u otro.

 Este _script_ redirige al usuario a la URL que éste recibe en el primer parámetro.

- `utils/errors/errors.sh`: Este _script_ comprueba la existencia de información en el fichero `utils/errors/log`. Si existe alguna línea en este fichero, significa que se acaba de producir un error al ejecutar un comando de alguna de las funcionalidades y se tendrá que mostrar este error por la plataforma web al actualizarse la página. Este _script_ genera el HTML que muestra el error y es utilizado por los _scripts_ que muestran el HTML de las páginas dentro de la carpeta `/var/www/webserver/bin`.

Para que los errores que podrían producirse al ejecutar alguna acción sobre la interfaz web, como por ejemplo, eliminar un proceso inexistente o añadir una norma de _firewall_ con una sintaxis incorrecta, se redirecciona el _file descriptor_ `stderr` de estos comandos que ejecutan cambios sobre el sistema hacia el fichero `/var/www/webserver/bin/utils/errors/log` mediante el uso de `2>>`.

#### Funcionalidad _login_

- `login.sh`: Este _script_ es ejecutado por Apache cuando se recibe la petición HTTP GET para acceder a la URL `/bin/login.sh`. Este _script_ muestra el HTML de la página de _login_ en la interfaz web. Este _script_ también comprueba la existencia de una _cookie_ de sesión llamada `error` para comprobar si se ha producido un error de autenticación (contraseña y/o usuario inválidos) y mostrar un error informativo por pantalla. Posteriormente, se elimina esta _cookie_ de la sesión para poder intentar de nuevo la autenticación.

- `utils/auth.sh`: Este _script_ se ejecuta al recibir una petición HTTP POST con los datos de nombre de usuario y contraseña del formulario del HTML de _login_ que muestra el _script_ `login.sh`. Este _script_ lee esta información y mediante el uso de `sshpass` y el código de retorno de esta utilidad, se comprueba si los credenciales concuerdan y se puede hacer el _login_ satisfactoriamente.

 En caso afirmativo, se redirigirá al usuario al _script_ `index.sh` para que pueda navegar con libertad en la plataforma web y se crearán las _cookies_ de sesión `logged` con valor `true` y `user` con el valor del nombre del usuario que se acaba de autenticar.

 En caso negativo, se redirigirá al usuario nuevamente a `login.sh` y se creará la _cookie_ `error` para poder mostrar que las credenciales no han sido válidas.

- `utils/logout.sh`: Este _script_ desautentica al usuario de la sesión web eliminando las _cookies_ `logged` y `user` y redirigiendo al usuario al _script_ `login.sh` por si el usuario quiere volver a autenticarse.

#### Gestión de procesos

- `tasks.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/tasks.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML de la página de gestión de procesos y rellena una tabla con información sobre todos los procesos del sistema mediante el comando `ps aux`.

 Además, esta página contiene funcionalidades para acabar con la ejecución de un proceso o interrumpir su ejecución durante un número de segundos a establecer dado su número de PID.

- `utils/kill.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 Este _script_ se ejecuta al recibir una petición HTTP POST proveniente de un formulario del HTML que muestra `tasks.sh` para poder acabar con un proceso o interrumpirlo durante X segundos. Este _script_ recibe el número de PID del proceso sobre el cual se debe realizar una de las dos acciones mencionadas. También se comprueba si la petición POST se ha enviado con el parámetro `segundos`.

 En caso positivo, se realizará la acción de interrumpir el proceso durante el número de segundos indicado.

 En caso negativo, el proceso acabará inmediatamente.

 Este _script_ utiliza la utilidad `kill` para enviar interrupciones a los procesos deseados por el usuario. Se utilizan las siguientes interrupciones: `SIGKILL` para terminar con el proceso, `SIGSTOP` para interrumpir la ejecución del proceso y `SIGCONT` para reanudar la ejecución del proceso.

#### Monitorización

- `monitoring.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/monitoring.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML de la página de monitorización del sistema el cual se encarga de mostrar la carga de CPU de la máquina, el uso de memoria RAM que se está utilizando (mediante el comando `ps aux`) y el espacio de disco que se está utilizando (mediante el comando `df`), de manera porcentual. También se rellena una tabla con información de los diez últimos accesos a la máquina (mediante el comando `last` y otra tabla que muestra la información de _routing_ configurada en el sistema (mediante el comando `route`). Por último, también se muestra un contador de tiempo que corresponde al tiempo que el servidor está activo (mediante el comando `ps -p 1 -o etime` ya que este comando muestra cuanto tiempo lleva activo el proceso con PID número 1 que es el primer proceso que se inicia y que inicia los demás procesos al iniciarse el servidor).

#### Apagar y reiniciar el servidor

- `utils/shutdown.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/utils/shutdown.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ apagará el servidor mediante el comando `sudo shutdown now`. En un principio, esta funcionalidad ejecutaba el comando `sudo systemctl stop apache2` para apagar el servidor Apache, dejando la máquina funcional pero no la interfaz web. El motivo de este cambio es que se ha considerado que es más útil para el administrador de sistemas apagar la máquina entera en vez del servidor Apache de la interfaz web ya que si es necesario, por algún motivo de seguridad, apagar el servidor, es más útil apagar la máquina que el servidor de la interfaz web, lo cual dejaría la máquina encendida igualmente pero al administrador de sistemas sin acceso a la interfaz web.

- `utils/restart.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/utils/restart.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ reiniciará la máquina mediante el comando `sudo reboot`. En un principio, esta funcionalidad ejecutaba el comando `sudo systemctl restart apache2` para reiniciar el servidor Apache, pero finalmente se ha optado por el primer comando por el mismo motivo mencionado anteriormente.

#### Gestión de _logs_

- `logs.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/logs.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML de la página de _logs_ del sistema y se encarga de rellenar una tabla que muestra todos los _logs_ que se han producido y que se encuentran en el archivo `/var/log/aso.log`. El contenido se muestra mediante el comando `tac` el cual es el mismo comando que el famoso `cat` pero invirtiendo el orden de las líneas de _output_. También se utiliza el comando `tac` junto al comando `grep` para poder filtrar entre todos los _logs_ del archivo si el usuario así lo desea.

 Cabe destacar que estos _logs_ se mostrarán con unos colores relacionados con su prioridad de la siguiente manera (las prioridades restante no se utilizan.):
 - Prioridad `info` - sin color
 - Prioridad `notice` - azul
 - Prioridad `warning` - amarillo
 - Prioridad `error` - rojo


- `utils/log.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 En el caso de que el usuario si esté autenticado, este _script_ se encargará de escribir _logs_ mediante el comando `logger` indicando como `local0` como facility. Este _script_ debe recibir dos argumentos correspondientes a la prioridad del _log_ y el mensaje informativo. Además, se indicará en cada _log_ el usuario _loggeado_ en la interfaz web que ha causado el _log_ mediante el valor de la _cookie_ de sesión `user`.

 Cabe destacar que este _script_ se utiliza por la mayoría de _scripts_ internos que ejecutan acciones que suponen algún cambio significante en el servidor como la creación o eliminación de usuarios, _log ins_, _log outs_, cambios de normas de _firewall_, etc.

#### Gestión de usuarios

- `users.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/users.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML que muestra los usuarios humanos del sistema leyendo el fichero `/etc/passwd` y filtrando aquellos UID que estén entre 1000 y 65533 ya que son los valores de UID reservados para los usuarios humanos.

 Además, esta página contiene funcionalidades para eliminar usuarios o crear nuevos usuarios.

- `utils/user_add.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 En el caso de que el usuario si esté autenticado, este _script_ se ejecutará al recibir una petición HTTP POST con los parámetros correspondientes al nombre de usuario y contraseña y se encargará de crear el usuario en el sistema invocando el _script_ `utils/expect_newuser.sh`. Posteriormente cuando el usuario se haya creado satisfactoriamente, se añadirá al usuario al grupo de usuarios `sudo`.

- `utils/expect_newuser.sh`: Este _script_ se encarga de crear un usuario dados dos parámetros que recibe como argumentos correspondientes al nombre y a la contraseña del usuario. Para crear el usuario se utiliza el comando `adduser`, pero como este comando es interactivo, se utiliza el intérprete `expect` para poder automatizar la interacción y indicar el nombre de usuario a crear y su contraseña de manera automatizada.

- `utils/user_delete.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

  En el caso de que el usuario si esté autenticado, este _script_ se ejecutará al recibir una petición HTTP POST con un parámetro correspondiente al nombre de usuario y se encargará de eliminar dicho usuario y su directorio _home_ mediante el comando `userdel`.

  Cabe destacar que el usuario `pi` no se podrá borrar ya que es el usuario administrador principal y necesario para acceder a la máquina.

#### Filtrado de paquetes

- `packets.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/packets.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML que muestra las normas de _firewall_ de la máquina tanto como de paquetes entrantes como salientes o paquetes de _forwarding_. Estas normas se muestran rellenando unas tablas cuya información se obtiene mediante el script `utils/iptables_show.sh`.

 Además, esta página contiene funcionalidades y formularios para poder añadir o insertar nuevas normas de _firewall_ y eliminar normas ya creadas.

- `utils/iptables_show.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 En el caso de que el usuario si esté autenticado, este _script_ recibe como argumento el nombre de la cadena a mostrar información (`INPUT`, `OUTPUT` o `FORWARD`) y mostrará la información de las normas mediante el comando `sudo iptables -L <cadena>`.

- `utils/iptables_add.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 Este _script_ se ejecuta al recibir una petición HTTP POST con los parámetros correspondientes para crear una nueva norma de _firewall_ para el servidor. Este _script_, mediante los parámetros que recibe (los parámetros del formulario no son obligatorios pero sí ayudan a concretar), va construyendo un comando a ejecutar para crear esta nueva norma mediante el comando `sudo iptables` y sus respectivos modificadores a añadir según los parámetros de filtreo recibidos.

- `utils/iptables_delete.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 Este _script_ se ejecuta al recibir una petición HTTP POST con los parámetros correspondientes al nombre de la cadena y línea de norma que se quiere borrar de las normas de _firewall_. Mediante el comando `sudo iptables -D <cadena> <línea>` se borrará esta línea.

#### Gestión de procesos programados

- `scheduler.sh`: Este _script_ se ejecuta al recibir una petición HTTP GET para acceder a la URL `/bin/scheduler.sh`.

 Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder mostrar la información pertinente. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, se redirigirá al usuario a la página de _login_.

 En el caso de que el usuario si esté autenticado, este _script_ muestra el HTML que muestra la lista de procesos programados con información sobre su propietario o la periodicidad en la que se ejecutará este proceso. Esta información se obtiene accediendo a todos los directorios presentes en `/var/spool/cron/crontabs/` ya que son los directorios donde se guardan las tareas programadas de cada usuario.

 Además, esta página contiene funcionalidades y formularios para poder añadir o insertar nuevos procesos programados y eliminar los ya creados.

- `utils/cron_add.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 En el caso de que el usuario si esté autenticado, este _script_ creará una nueva entrada en el fichero `crontab` del usuario que haya efectuado la petición (leyendo la _cookie_ de seisón `user`) con los parámetros que este usuario haya indicado y que se reciban en el servidor mediante una petición HTTP POST.

 Cabe destacar que el usuario que cree un nuevo proceso programado desde la interfaz web, no podrá crear este proceso programado en nombre de otro usuario del sistema y se creará en el fichero `crontab` con su nombre de usuario.

- `utils/cron_delete.sh`: Este _script_ comprueba que se haya establecido la _cookie_ `logged` en la sesión de navegador del usuario para poder ejecutarse. En caso de que no se haya establecido, es decir, el usuario no se ha _loggeado_ satisfactoriamente, el _script_ no se ejecutará útilmente y redirigirá al usuario a la página de _login_ y se saldrá del _script_ mediante el comando `exit`. Esto se aplica como medida de seguridad para que no se pueda utilizar esta funcionalidad sin estar autenticado.

 En el caso de que el usuario si esté autenticado, este _script_ eliminará una entrada del fichero `crontab` del usuario que se indique en la petición HTTP POST mediante el uso del comando `sed`.

 Cabe destacar que, en este caso, el usuario autenticado en la interfaz web sí podrá eliminar procesos programados de otros usuarios ya que se ha considerado que es una medida de seguridad pertinente y podría ser útil en casos de emergencia para los diferentes administradores con acceso a la interfaz web. Por otra parte, estas acciones siempre quedan reflejadas en la página de _logs_.

#### Funcionalidades musicales

No están acabadas (se presentaran correctamente en la entrevista)

## Problemas observados

A continuación se mencionan los principales problemas observados durante el transcurso de esta práctica:

- Para llevar a cabo la práctica, se ha necesitado conectividad con la Raspberry Pi en cada momento, lo que ha resultado algo incómodo por temas de portabilidad. Este aspecto se ha solucionado gracias a la instalación de túneles `ngrok` para poder acceder a la interfaz web y conectarse a la Raspberry Pi mediante SSH de manera remota vía internet.

- Comprender la estructura y el funcionamiento del servidor web Apache ha sido confuso al inicio al ser la primera vez en usar esta herramienta y al no estar familiarizado.

- Aprender el proceso de configuración y estructura de Apache para poder ejecutar _scripts_ en vez de mostrar su código fuente por la interfaz web no ha sido trivial, pero ha ayudado a comprender mejor la estructura de configuración que utiliza Apache así como diversas de sus etiquetas (e.g. `<Directory>`) y a comprender la importancia de los módulos que pueden habilitarse.

- Conseguir relacionar recursos como hojas de estilo CSS, imágenes o códigos JavaScript en el HTML que muestran los _scripts_ ha sido un problema que ha tardado en solucionarse ya que no se encontraba la configuración correcta y la interfaz web no encontraba estos recursos. Esto se consiguió arreglar finalmente, entre otras cosas, añadiendo la opción `AllowOverride none` en la configuración del directorio que contiene los _scripts_ CGI.

- Entender el funcionamiento de Apache frente a peticiones HTTP GET y POST y como leer e interpretar los parámetros que se transfieren en estas peticiones.

- Comprender cómo utilizar sesiones y el uso de _cookies_ de sesión gracias a los modulos `session.load` y `session_cookie.load` así como entender dónde se almacenan las _cookies_ de sesión y como utilizarlas en el entorno _backend_ de la plataforma web.

- Necesidad de aprender a redireccionar entre pantallas web mediante los _scripts_ CGI. Útil especialmente para ejecutar _scripts_ que actualicen información en el sistema y posteriormente en la interfaz web, por ejemplo.

- Comprobar los datos de autenticación al hacer _login_ mediante el uso del comando `sshpass` no ha sido fácil ya que se accedía a una nueva _shell_. Esto se ha solucionado mediante el uso de redirecciones _heredoc_.

- Interactuar con _scripts_ que requieren interacción de usuario de manera automatizada. Se ha solventado mediante el intérprete `expect`.

## Conclusiones

A continuación se listan las conclusiones que se han podido obtener durante el transcurso de este práctica:

- Se ha aprendido a gestionar y configurar un servidor web Apache para que ejecute _scripts_ y sirva el _output_ de estos en la interfaz web.

- Se ha aprendido a gestionar las peticiones HTTP GET y POST mediante el servidor Apache.

- Se ha aprendido a añadir y eliminar _cookies_ de sesión, así como acceder a sus valores para ser utilizados por diversos _scripts_

- Se ha aprendido a utilizar `ngrok`, a configurarlo como servicio y se ha comprendido su utilidad para acceder a los recursos de la Raspberry Pi de forma remota.

- Se han interiorizado muchos de los aspectos del temario de clase, como por ejemplo la configuración y gestión de servicios o _daemons_, configuración de _logs_ mediante la herramienta `rsyslog` y sus _facilities_ y _priorities_, gestión y estructura de los procesos programados, getión de normas de _firewall_ mediante `iptables`, interacción con procesos mediante la herramienta `kill` así como la utilidad de diferentes interrupciones, gestión de usuarios y la utilidad de los ficheros `/etc/passwd` y `/etc/group`, desarrollo de _scripts_ en lenguaje _bash_, etc.

- Se ha aprendido a automatizar _scripts_ que requieren de interacción mediante el intérprete `expect`.

- Se ha aprendido a gestionar la navegación del usuario por las diferentes pantallas y la actualización de los datos de las mismas de manera interna.

- Se ha aprendido e interiorizado la utilidad de la herramienta de redirección _heredoc_ (`<<`).

- En general, se ha interiorizado a profundidad la estructura que siguen los sistemas operativos Debian GNU/Linux así como su gestión y la utilidad de los directorios y ficheros más importantes de éste que permiten la administración del sistema.

## Webgrafía

https://www.digitalocean.com/community/tutorials/como-instalar-el-servidor-web-apache-en-ubuntu-18-04-guia-de-inicio-rapido-es
https://linux.die.net/man/1/expect
https://httpd.apache.org/docs/2.4/mod/mod_alias.html#scriptalias
https://httpd.apache.org/docs/2.4/es/mod/core.html#files
https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html
https://httpd.apache.org/docs/2.4/mod/mod_session.html

https://stackoverflow.com/questions/30802775/how-to-get-post-parameters-from-cgi-scripts-written-in-bash
https://stackoverflow.com/questions/5411538/redirect-from-an-html-page
https://systemd.io/UIDS-GIDS/
https://www.linux.org/threads/how-to-user-privilege-specification.17419/

https://man7.org/linux/man-pages/man7/signal.7.html#:~:text=There%20are%20six%20signals%20that,SIGILL%2C%20SIGSEGV%2C%20and%20SIGTRAP.

https://success.trendmicro.com/solution/TP000086250-What-are-Syslog-Facilities-and-Levels
https://www.thegeekdiary.com/understanding-rsyslog-templates/

https://superuser.com/questions/468161/howto-switch-chage-user-id-witin-a-bash-script-to-execute-commands-in-the-same/468163#468163
https://linuxize.com/post/bash-heredoc/

https://stackoverflow.com/questions/24393993/create-a-percentage-circle-with-css
