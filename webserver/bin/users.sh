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
          <a class=\"menu-item selected\" href=\"users.sh\">
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
      <div class=\"title\">Users</div>

      <div class=\"main-content\">
	<section>
          <form class=\"new-user\" method=\"POST\" action=\"utils/user_add.sh\">
            <div class=\"form-label\">Username: <input name=\"uname\" dir=\"rtl\" required></div>
            <div class=\"form-label\">Password: <input name=\"upwd\" dir=\"rtl\" type=\"password\" required></div>
            <input class=\"btn\" type=\"submit\" value=\"+ Add user\">
          </form>
        </section>

      	<section>
          <table class=\"table users-table\">
            <tr>
            </tr>"

awk -F ":" '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd | while read user
do
	echo "<tr>
		<td>$user</td>
		<td>
		  <form method=\"POST\" action=\"utils/user_delete.sh\">
		    <input type=\"hidden\" name=\"user\" value=\"$user\">
		    <input type=\"submit\" value=\"Delete\">
		  </form>
		</td>
	     </tr>"
done

echo "    </table>
	</section>
      </div>
    </div>

    <script src=\"/js/utils.js\"></script>
  </body>
</html>"

exit 0
