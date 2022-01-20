#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

echo "Content-Type: text/html"
echo -e "X-Replace-Session: logged=&user=\n"

./log.sh info "Logged out."

./redirect.sh /bin/login.sh no

exit 0
