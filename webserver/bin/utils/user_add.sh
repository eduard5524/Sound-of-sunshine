#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
uname=$(echo $POST | awk -F '&' '{print $1}' | awk -F "=" '{print $2}')
upwd=$(echo $POST | awk -F '&' '{print $2}' | awk -F "=" '{print $2}')

./expect_newuser.sh $uname $upwd > /dev/null
sudo usermod -a -G sudo $uname 2>> errors/log

./log.sh notice "Created user '$uname'."

./redirect.sh /bin/users.sh

exit 0
