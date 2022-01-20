#!/bin/bash

error=$(echo ${HTTP_SESSION} | awk -F "error=" '{print $2}')

echo "Content-type: text/html"
echo -e "X-Replace-Session: error=\n"

echo "<!DOCTYPE html>
<html lang=\"en\" dir=\"ltr\">
  <head>
    <meta charset=\"utf-8\">
    <title>Server Manager</title>

    <link rel=\"stylesheet\" href=\"/css/styles.css\">
  </head>
  <body>
    <header>

    </header>

    <nav class=\"menu\">
      <ul>
        <li>
          <a class=\"menu-item selected\" href=\"login.sh\">
            <span></span>
            <div class=\"menu-item-text\">Login</div>
          </a>
        </li>
      </ul>
    </nav>

    <div class=\"background\"></div>

    <div class=\"content\">
        <div class=\"title\">Login</div>
        <form class=\"login-content\" method=\"POST\" action=\"utils/auth.sh\">
          <div class=\"form-label\">Username: <input name=\"uname\" dir=\"rtl\" required></div>
          <div class=\"form-label\">Password: <input name=\"upwd\" dir=\"rtl\" type=\"password\" required></div>
          <input class=\"btn\" type=\"submit\" value=\"Submit\">"

	  if [ -n "$error" ]
	  then
		  echo "<div class="error-msg">Invalid credentials</div>"
	  fi

   echo "</form>
    </div>
  </body>
</html>"

exit 0
