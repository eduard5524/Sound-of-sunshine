#!/bin/bash

read POST
uname=$(echo $POST | awk -F '&' '{print $1}' | awk -F "=" '{print $2}')
upwd=$(echo $POST | awk -F '&' '{print $2}' | awk -F "=" '{print $2}')

sudo sshpass -p $upwd ssh -q -o StrictHostKeyChecking=no $uname@localhost > /dev/null << EOF
exit
EOF

if [ $? -ne 0 ]
then
	echo "Content-Type: text/html"
	echo -e "X-Replace-Session: error=auth\n"
	
	./redirect.sh /bin/login.sh no

	exit 0
fi

echo "Content-Type: text/html"
echo -e "X-Replace-Session: logged=true&user=$uname\n"

./log.sh -u $uname info "Logged in."

./redirect.sh /bin/index.sh no

exit 0
