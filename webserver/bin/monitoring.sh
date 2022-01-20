#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

cpu=$(ps aux | awk 'NR > 1 {print $3}' | rs -T | sed 's/  /+/g' | bc)
memory=$(ps aux | awk 'NR > 1 {print $4}' | rs -T | sed 's/  /+/g' | bc)
disk=$(df | awk 'NR > 1 {print $5}' | sed 's/%//g' | rs -T | sed 's/  /+/g' | bc)

echo -e "Content-type: text/html\n\n"

echo "<!DOCTYPE html>
<html lang=\"en\" dir=\"ltr\">
  <head>
    <meta charset=\"utf-8\">
    <title>Server Manager</title>

    <link rel=\"stylesheet\" href=\"/css/styles.css\">
    <link rel=\"stylesheet\" href=\"/css/chart.css\">
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
          <a class=\"menu-item selected\" href=\"monitoring.sh\">
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

    <div class=\"background\"></div>

    <div class=\"content\">
      <div class=\"title\">Monitoring</div>

      <div class=\"main-content\">
        <section>
          <div class=\"charts\">
            <div class=\"single-chart\">
              <svg viewBox=\"0 0 36 36\" class=\"circular-chart big-chart blue\">
                <path class=\"circle-bg\"
                  d=\"M18 2.0845
                    a 15.9155 15.9155 0 0 1 0 31.831
                    a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                <path class=\"circle\"
                  stroke-dasharray=\"$cpu, 100\"
                  d=\"M18 2.0845
                    a 15.9155 15.9155 0 0 1 0 31.831
                    a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                <text x=\"18\" y=\"20.35\" class=\"percentage\">$cpu%</text>
              </svg>
              <div>CPU</div>
            </div>

            <div class=\"smaller-charts\">
              <div class=\"single-chart\">
                <svg viewBox=\"0 0 36 36\" class=\"circular-chart small-chart yellow\">
                  <path class=\"circle-bg\"
                    d=\"M18 2.0845
                      a 15.9155 15.9155 0 0 1 0 31.831
                      a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                  <path class=\"circle\"
                    stroke-dasharray=\"$memory, 100\"
                    d=\"M18 2.0845
                      a 15.9155 15.9155 0 0 1 0 31.831
                      a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                  <text x=\"18\" y=\"20.35\" class=\"percentage\">$memory%</text>
                </svg>
                <div>Memory


                </div>
              </div>

              <div class=\"single-chart\">
                <svg viewBox=\"0 0 36 36\" class=\"circular-chart small-chart purple\">
                  <path class=\"circle-bg\"
                    d=\"M18 2.0845
                      a 15.9155 15.9155 0 0 1 0 31.831
                      a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                  <path class=\"circle\"
                    stroke-dasharray=\"$disk, 100\"
                    d=\"M18 2.0845
                      a 15.9155 15.9155 0 0 1 0 31.831
                      a 15.9155 15.9155 0 0 1 0 -31.831\"/>
                  <text x=\"18\" y=\"20.35\" class=\"percentage\">$disk%</text>
                </svg>
                <div>Disk</div>
              </div>
            </div>
          </div>
        </section>
        <section>
          <div class=\"subtitle\">Access log</div>

          <table class=\"table packet-table\">
            <tr class=\"table-header\">
              <th>User</th>
              <th>From</th>
              <th>Access datetime</th>
              <th>Duration</th>
            </tr>"

		last -d | grep -v reboot | head -10 | while read access
		do
			user=$(echo $access | awk '{print $1}')
			from=$(echo $access | awk '{print $3}')
			datetime=$(echo $access | awk '{print $5" "$6" "$7}')
			duration=$(echo $access | awk '{print $10}')

			if [ "$duration" == "in" ]
			then
				duration=$(echo "<td style=\"color: var(--dark-green);\">Logged in now</td>")
			else
				duration=$(echo $duration | awk -F ":" '{print $1"h "$2"m"}')
				duration=$(echo "<td>$duration</td>" | sed 's/(//g' | sed 's/)//g')
			fi

			echo "<tr>"
			echo "<td>$user</td>"
			echo "<td>$from</td>"
			echo "<td>$datetime</td>"
			echo "$duration"
			echo "</tr>"
		done

      echo "</table>
        </section>
        <section>
          <div class=\"subtitle\">Routing table</div>

          <table class=\"table packet-table\">
            <tr class=\"table-header\">
              <th>Destination</th>
              <th>Gateway</th>
              <th>Mask</th>
              <th>Interface</th>
            </tr>"
            
		route -n | awk 'NR > 2 {print $0}' | while read line
    		do
			destination=$(echo $line | awk '{print $1}')
			gateway=$(echo $line | awk '{print $2}')
			mask=$(echo $line | awk '{print $3}')
			iface=$(echo $line | awk '{print $NF}')

			echo "<tr>"
			echo "<td>$destination</td>"
			echo "<td>$gateway</td>"
			echo "<td>$mask</td>"
			echo "<td>$iface</td>"
			echo "</tr>"
		done

      echo "</table>
        </section>
        <section>
          <div class=\"subtitle\">Server run time</div>
          <div style=\"margin-left: 20px; color: white; font-size: 18px; text-shadow: 2px 2px black;\">Server has been ON for:</div>"

		days=$(ps -p 1 -o etime | awk 'NR == 2 {print $1}' | awk -F "-" '{print $1}')
		hours=$(ps -p 1 -o etime | awk 'NR == 2 {print $1}' | awk -F "-" '{print $2}' | awk -F ":" '{print $1}')
		minutes=$(ps -p 1 -o etime | awk 'NR == 2 {print $1}' | awk -F ":" '{print $2}')
		seconds=$(ps -p 1 -o etime | awk 'NR == 2 {print $1}' | awk -F ":" '{print $3}')

		echo "<div class=\"time-on\">$days""D $hours""h "$minutes""m $seconds"s</div>"

    echo "</section>
      </div>
    </div>

    <script src=\"/js/utils.js\"></script>
    <script src=\"/js/timer.js\"></script>
  </body>
</html>"

exit 0
