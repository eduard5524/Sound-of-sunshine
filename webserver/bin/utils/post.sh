#!/bin/bash

read POST

echo -e "Content-type: text/html\n\n"

echo "<!DOCTYPE html>
<html lang=\"en\" dir=\"ltr\">
  <head>
    <meta charset=\"utf-8\">
    <title>Server Manager</title>

    <link rel=\"stylesheet\" type=\"text/css\" href=\"/css/styles.css\">
  </head>
  <body>"

echo "<div>$POST</div>"

echo  "</body></html"

exit 0
