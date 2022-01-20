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

    <nav class=\"menu\">
      <ul>
        <li>
          <a class=\"menu-item\" href=\"tasks.sh\">
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
          <a class=\"menu-item selected\" href=\"scheduler.sh\">
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
      <div class=\"title\">Schedule tasks</div>

      <div class=\"main-content\">
        <section>
          <form class=\"new-cron\" method=\"POST\" action=\"utils/cron_add.sh\">
            <div class=\"cron-inputs\">
              <div class=\"form-label\">Command: <input name=\"command\" dir=\"rtl\" required></div>
              <div class=\"cron-data\">
                <div class=\"form-label\">Minute: <input name=\"minute\" dir=\"rtl\" required></div>
                <div class=\"form-label\">Hour: <input name=\"hour\" dir=\"rtl\" required></div>
              </div>
              <div class=\"cron-data\">
                <div class=\"form-label\">DOM: <input name=\"dom\" dir=\"rtl\" required></div>
                <div class=\"form-label\">Month: <input name=\"month\" dir=\"rtl\" required></div>
                <div class=\"form-label\">DOW: <input name=\"dow\" dir=\"rtl\" required></div>
              </div>
            </div>
            <input class=\"btn\" type=\"submit\" value=\"+ Add task\">
          </form>
        </section>

        <section>
          <table class=\"table cron-table\">
            <tr class=\"table-header\">
              <th>Owner</th>
              <th>Command</th>
              <th>m</th>
              <th>h</th>
              <th>DOM</th>
              <th>mon</th>
              <th>DOW</th>
              <th></th>
            </tr>"
	
	user=$(echo "${HTTP_SESSION}" | awk -F "user=" '{print $2}')

	crontabs=$(sudo ls -l /var/spool/cron/crontabs/ | awk 'NR > 1 {print $NF}')
	
	if [ -z $crontabs ]
	then
		echo "<tr>"
		echo "<td style=\"width: 100%;text-align: center;\" colspan=\"8\">No rules</td>"
		echo "</tr>"
	else
		echo "$crontabs" | while read line
		do
			i=1
			sudo cat /var/spool/cron/crontabs/$line | while read cron
			do
				command=$(echo "$cron" | awk '{print $6}')
				minute=$(echo "$cron" | awk '{print $1}')
				hour=$(echo "$cron" | awk '{print $2}')
				dom=$(echo "$cron" | awk '{print $3}')
				month=$(echo "$cron" | awk '{print $4}')
				dow=$(echo "$cron" | awk '{print $5}')
				
				echo "<tr><td>$line</td>"
				echo "<td>$command</td>"
				echo "<td>$minute</td>"
				echo "<td>$hour</td>"
				echo "<td>$dom</td>"
				echo "<td>$month</td>"
				echo "<td>$dow</td>"
				echo "<td><form method=\"POST\" action=\"utils/cron_delete.sh\"><input type=\"hidden\" name=\"owner\" value=\"$line\"><input type=\"hidden\" name=\"line\" value=\"$i\"><input type=\"submit\" value=\"Delete\"></form></td>"
				echo "</tr>"
				i=$((i+1))
			done	
		done
	fi
      
	echo "</table>
        </section>
      </div>
    </div>

    <script src=\"/js/utils.js\"></script>
  </body>
</html>"

exit 0
