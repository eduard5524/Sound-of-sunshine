#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
user=$(echo $POST | awk -F "=" '{print $2}')

if [ $user = "pi" ]
then
	echo "Can not delete user 'pi'." >> errors/log
	./redirect.sh /bin/users.sh
	exit 1
fi

sudo userdel -r $user

./log.sh warning "Deleted user '$user'."

./redirect.sh /bin/users.sh

exit 0
