#!/bin/bash

#if [ -z ${HTTP_SESSION} ]
#then
#	./utils/redirect.sh /bin/login.sh
#	exit 1
#fi

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

    <nav class=\"menu\">
      <ul>
        <li>
          <a class=\"menu-item selected\" href=\"tasks.sh\">
            <span></span>
            <div class=\"menu-item-text\">Manage tasks</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"monitoring.sh\">
            <span></span>
            <div class=\"menu-item-text\">Monitoring</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"logs.sh\">
            <span></span>
            <div class=\"menu-item-text\">Logs</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"users.sh\">
            <span></span>
            <div class=\"menu-item-text\">Users</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"packets.sh\">
            <span></span>
            <div class=\"menu-item-text\">Packet handler</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"scheduler.sh\">
            <span></span>
            <div class=\"menu-item-text\">Schedule tasks</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item\" href=\"music.sh\">
            <span></span>
            <div class=\"menu-item-text\">Music</div>
          </a>
        </li>
      </ul>
    </nav>

    <div class=\"background\"></div>"

    ./utils/errors/errors.sh

    echo "<div class=\"content\">
      <div class=\"title\">Manage tasks</div>

      <div class=\"main-content\">
        <section>
          <form class=\"task-actions\" method=\"POST\" action=\"utils/kill.sh\">
            <div class=\"task-inputs\">
              <div class=\"form-label\">PID: <input name=\"pid\" dir=\"rtl\" required></div>

              <div class=\"dropdown\">
                <button class=\"btn dropdown-button\" type=\"button\">Terminate</button>
                <div class=\"dropdown-items\">
                  <div class=\"btn\">Interrupt</div>
                </div>
              </div>
            </div>

            <input class=\"btn\" type=\"submit\" value=\"Kill\">
          </form>
        </section>

        <section>
          <table class=\"table tasks-table\">
            <tr class=\"table-header\">
              <th>PID</th>
              <th>Process</th>
              <th>Status</th>
            </tr>"

ps aux --no-header |  while read line
do
      echo "<tr><td>"
	      echo $line | awk '{print $2}'
	      echo "</td><td>"
	      echo $line | awk '{for(i=11;i<=NF;++i) print $i}' 
	      echo "</td><td>"
	      echo $line | awk '{print $8}' 
	      echo "</td></tr>"
done

     echo "</table>
        </section>
      </div>
    </div>
     <script src=\"/js/tasks.js\"></script>
     <script src=\"/js/dropdown.js\"></script>
  </body>
</html>"

exit 0
