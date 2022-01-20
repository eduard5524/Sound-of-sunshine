#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

filter=$(echo $QUERY_STRING | awk -F "=" '{print $2}' | sed 's/+/ /g')


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
          <a class=\"menu-item selected\" href=\"logs.sh\">
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

    <div class=\"background\"></div>

    <div class=\"content\">
      <div class=\"title\">Logs</div>

      <div class=\"main-content\">
        <section>
          <form class=\"log-filter\" method=\"GET\" action=\"logs.sh\">
            <div class=\"form-label\">Filter: <input name=\"query\" dir=\"rtl\" required></div>
            <input class=\"btn\" type=\"submit\" value=\"Search\">
          </form>
        </section>

        <section>"
	
	if [ -n "$filter" ]
	then
		echo "<div style=\"color: var(--dark-gray);margin-bottom: 10px; padding-left: 20px;\">Filtering by \"$filter\"</div>"
	fi

        echo "<table class=\"table log-table\">
            <tr class=\"table-header\">
              <th>User</th>
              <th>Time</th>
              <th>Log</th>
            </tr>"

	if [ -z $filter ]
	then
		logs=$(tac /var/log/aso.log)
	else
		logs=$(tac /var/log/aso.log | grep -i "$filter")
	fi

	echo "$logs" | while read line
	do
		user=$(echo $line | sed 's/> </-/g' | sed -E 's/<|>//g' | awk -F "-" '{print $3}')
		date=$(echo $line | sed 's/> </-/g' | sed -E 's/<|>//g' | awk -F "-" '{print $1}')
		message=$(echo $line | sed 's/> </-/g' | sed -E 's/<|>//g' | awk -F "-" '{print $4}')
		priority=$(echo $line | sed 's/> </-/g' | sed -E 's/<|>//g' | awk -F "-" '{print $2}')

        	echo "<tr class=\"$priority\">"
   		echo "<td>$user</td>"
                echo "<td>$date</td>"
                echo "<td>$message</td>"
                echo "</tr>"
	done

        echo "</table>
        </section>
      </div>
    </div>

    <script src=\"/js/utils.js\"></script>
  </body>
</html>"

exit 0
