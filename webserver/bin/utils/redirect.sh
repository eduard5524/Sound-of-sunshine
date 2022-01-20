#!/bin/bash

if [ -z $2 ] || [ $2 != "no" ]
then
	echo -e "Content-type: text/html\n\n"
fi

echo "<!DOCTYPE html>
<html lang=\"en\" dir=\"ltr\">
  <head>
    <meta charset=\"utf-8\">
    <meta http-equiv=\"refresh\" content=\"0; url=$1\">

    <title>Server Manager</title>
  </head>
  <body>
  </body>
</html>"

exit 0
