#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

./log.sh warning "Rebooted the server."

sudo reboot 2>> errors/log
#sudo systemctl restart apache2.service

exit 0
