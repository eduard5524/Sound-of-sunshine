#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
owner=$(echo $POST | awk -F '&' '{print $1}' | awk -F '=' '{print $2}')
line=$(echo $POST | awk -F '&' '{print $2}' | awk -F '=' '{print $2}')
line=$(echo $line"d")

user=$(echo "${HTTP_SESSION}" | awk -F "user=" '{print $2}')

sudo sed -i "$line" /var/spool/cron/crontabs/$owner

if [ $(cat /var/spool/cron/crontabs/$owner | wc -l) -eq 0 ]
then
	sudo rm /var/spool/cron/crontabs/$owner 2>> errors/log
fi

if [ $owner == $user ]
then
	./log.sh notice "Deleted own scheduled task."
else
	./log.sh warning "Deleted scheduled task from $owner's crontab."
fi

./redirect.sh /bin/scheduler.sh

exit 0
