#!/bin/bash

echo -e "Content-Type: text/html\n\n"

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
          <a class=\"menu-item\" href=\"scheduler.sh\">
            <span></span>
            <div class=\"menu-item-text\">Schedule tasks</div>
          </a>
        </li>

        <li>
          <a class=\"menu-item selected\" href=\"music.sh\">
            <span></span>
            <div class=\"menu-item-text\">Music</div>
          </a>
        </li>
      </ul>
    </nav>

    <div class=\"background\"></div>

    <div class=\"content\">
      <div class=\"title\">Music</div>

      <div class=\"main-content\">
        <section>
          <ul class=\"music-list\">"
            
	ls -l ../music | awk '{ for (i=9; i<=NF; i++) printf "%s%s", $i, (i<NF ? OFS : ORS)}' | awk -F "." '{print $1}' | grep -v 'playlist\|fifo' | while read line
	do 
		echo "<li><div>$line</div><form method=\"POST\" action=\"utils/music_song.sh\"><input type=\"hidden\" name=\"song\" value=\"$line.mp3\"><input class=\"btn play-btn\" type=\"submit\" value=\"Play\"></form></li>"
	done

      echo "</ul>
	  <div class=\"bluetooth\">
            <a href=\"utils/bluetooth-connect.sh\" class=\"bluetooth-btn btn\">Connect</a>
          </div>
        </section>
      </div>
    </div>

    <div class=\"music-actions\">
      <a href=\"\" class=\"btn\">Retroceder</a>
      <a href=\"utils/music_switch.sh\" class=\"btn\">Play/Pause</a>
      <a href=\"\" class=\"btn\">Skip</a>
      <a href=\"\" class=\"btn\">Shuffle</a>
      <a href=\"\" class=\"btn\">Replay</a>
    </div>

    <script src=\"/js/utils.js\"></script>
  </body>
</html>"

#if [ $(ps aux | grep mpg123 | wc -l) -eq 1 ]
#then
	#sudo -u pi mpg123 -R --fifo ../music/fifo 2>&1 > /dev/null &
#fi

exit 0
