#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

echo -e "Content-type: text/html\n\n"

echo "<!DOCTYPE html>
<html lang=\"en\" dir=\"ltr\">
  <head>
    <meta charset=\"utf-8\">
    <title>Server Manager</title>

    <link rel=\"stylesheet\" href=\"/css/styles.css\">
  </head>
  <body>
    <header>
      <a class=\"logo\" href=\"index.sh\" >Server Manager</a>
      <div>
        <a class=\"btn round shutdown\" href=\"utils/shutdown.sh\"><img src=\"/img/shutdown.png\"></a>
        <a class=\"btn round restart\" href=\"utils/restart.sh\"><img src=\"/img/restart.png\"</a>
        <a class=\"btn logout\" href=\"utils/logout.sh\">Logout</a>
      </div>
    </header>

    <div class=\"index\">
      <a class=\"menu-item index-item\" href=\"tasks.sh\">
        <span></span>
        <div class=\"menu-item-text\">Manage tasks</div>
      </a>

      <a class=\"menu-item index-item\" href=\"monitoring.sh\">
        <span></span>
        <div class=\"menu-item-text\">Monitoring</div>
      </a>

      <a class=\"menu-item index-item\" href=\"logs.sh\">
        <span></span>
        <div class=\"menu-item-text\">Logs</div>
      </a>

      <a class=\"menu-item index-item\" href=\"users.sh\">
        <span></span>
        <div class=\"menu-item-text\">Users</div>
      </a>

      <a class=\"menu-item index-item\" href=\"packets.sh\">
        <span></span>
        <div class=\"menu-item-text\">Packet handler</div>
      </a>

      <a class=\"menu-item index-item\" href=\"scheduler.sh\">
        <span></span>
        <div class=\"menu-item-text\">Schedule tasks</div>
      </a>

      <a class=\"menu-item index-item\" href=\"music.sh\">
        <span></span>
        <div class=\"menu-item-text\">Music</div>
      </a>
    </div>
  </body>
</html>"

exit 0
