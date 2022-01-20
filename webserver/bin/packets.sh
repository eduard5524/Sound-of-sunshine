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
          <a class=\"menu-item selected\" href=\"packets.sh\">
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
      <div class=\"title\">Packet handler</div>
      <div class=\"main-content\">
        <section>
          <div class=\"subtitle\">INPUT</div>

          <form class=\"packet-actions\" method=\"POST\" action=\"utils/iptables_add.sh\">
            <div class=\"packet-inputs\">
              <input type=\"hidden\" name=\"method\" value=\"I\">
              <input type=\"hidden\" name=\"chain\" value=\"INPUT\">
              <input type=\"hidden\" name=\"policy\" value=\"ACCEPT\">
              <div class=\"form-label\">IP Source: <input name=\"source\" dir=\"rtl\"></div>
              <div class=\"form-label\">IP Destination: <input name=\"destination\" dir=\"rtl\"></div>
              <div class=\"form-label\">Protocol: <input name=\"protocol\" dir=\"rtl\"></div>
              <div class=\"form-label\">Port: <input name=\"port\" dir=\"rtl\"></div>
              <div class=\"form-label\">Policy:
                <div class=\"dropdown\">
                  <button class=\"btn dropdown-button\" type=\"button\">Accept</button>
                  <div class=\"dropdown-items\">
                    <div class=\"btn\">Drop</div>
                  </div>
                </div>
              </div>
            </div>
            <div class=\"dropdown\">
              <button class=\"btn dropdown-button\" type=\"button\">Insert</button>
              <div class=\"dropdown-items\">
                <div class=\"btn\">Append</div>
              </div>
            </div>

            <input class=\"btn\" type=\"submit\" value=\"+ Add\">
          </form>
        </section>

        <section>
          <table class=\"table packet-table\">
            <tr class=\"table-header\">
              <th>Protocol</th>
              <th>Source</th>
              <th>Destination</th>
	      <th>Port</th>
              <th>Policy</th>
              <th></th>
            </tr>"
	
	    ./utils/iptables_show.sh INPUT 

    	    echo  "</table>
        </section>

        <section>
          <div class=\"subtitle\">FORWARD</div>

          <form class=\"packet-actions\" method=\"POST\" action=\"utils/iptables_add.sh\">
            <div class=\"packet-inputs\">
              <input type=\"hidden\" name=\"method\" value=\"I\">
              <input type=\"hidden\" name=\"chain\" value=\"FORWARD\">
              <input type=\"hidden\" name=\"policy\" value=\"ACCEPT\">
              <div class=\"form-label\">IP Source: <input name=\"source\" dir=\"rtl\"></div>
              <div class=\"form-label\">IP Destination: <input name=\"destination\" dir=\"rtl\"></div>
              <div class=\"form-label\">Protocol: <input name=\"protocol\" dir=\"rtl\"></div>
              <div class=\"form-label\">Port: <input name=\"port\" dir=\"rtl\"></div>
              <div class=\"form-label\">Policy:
                <div class=\"dropdown\">
                  <button class=\"btn dropdown-button\" type=\"button\">Accept</button>
                  <div class=\"dropdown-items\">
                    <div class=\"btn\">Drop</div>
                  </div>
                </div>
              </div>
            </div>
            <div class=\"dropdown\">
              <button class=\"btn dropdown-button\" type=\"button\">Insert</button>
              <div class=\"dropdown-items\">
                <div class=\"btn\">Append</div>
              </div>
            </div>

            <input class=\"btn\" type=\"submit\" value=\"+ Add\">
          </form>
        </section>

        <section>
          <table class=\"table packet-table\">
            <tr class=\"table-header\">
              <th>Protocol</th>
              <th>Source</th>
              <th>Destination</th>
	      <th>Port</th>
              <th>Policy</th>
              <th></th>
            </tr>"

    	    ./utils/iptables_show.sh FORWARD
    
      	    echo "</table>
        </section>

        <section>
          <div class=\"subtitle\">OUTPUT</div>

          <form class=\"packet-actions\" method=\"POST\" action=\"utils/iptables_add.sh\">
            <div class=\"packet-inputs\">
              <input type=\"hidden\" name=\"method\" value=\"I\">
              <input type=\"hidden\" name=\"chain\" value=\"OUTPUT\">
              <input type=\"hidden\" name=\"policy\" value=\"ACCEPT\">
              <div class=\"form-label\">IP Source: <input name=\"source\" dir=\"rtl\"></div>
              <div class=\"form-label\">IP Destination: <input name=\"destination\" dir=\"rtl\"></div>
              <div class=\"form-label\">Protocol: <input name=\"protocol\" dir=\"rtl\"></div>
              <div class=\"form-label\">Port: <input name=\"port\" dir=\"rtl\"></div>
              <div class=\"form-label\">Policy:
                <div class=\"dropdown\">
                  <button class=\"btn dropdown-button\" type=\"button\">Accept</button>
                  <div class=\"dropdown-items\">
                    <div class=\"btn\">Drop</div>
                  </div>
                </div>
              </div>
            </div>
            <div class=\"dropdown\">
              <button class=\"btn dropdown-button\" type=\"button\">Insert</button>
              <div class=\"dropdown-items\">
                <div class=\"btn\">Append</div>
              </div>
            </div>

            <input class=\"btn\" type=\"submit\" value=\"+ Add\">
          </form>
        </section>

        <section>
          <table class=\"table packet-table\">
            <tr class=\"table-header\">
              <th>Protocol</th>
              <th>Source</th>
              <th>Destination</th>
	      <th>Port</th>
              <th>Policy</th>
              <th></th>
            </tr>"

	    ./utils/iptables_show.sh OUTPUT

  	    echo "</table>
        </section>
      </div>
    </div>

    <script src=\"/js/utils.js\"></script>
    <script src=\"/js/dropdown.js\"></script>
  </body>
</html>"

exit 0
