#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

./log.sh crit "Shutted down the server."

sudo shutdown now 2>> errors/log
#sudo systemctl stop apache2.service

exit 0
