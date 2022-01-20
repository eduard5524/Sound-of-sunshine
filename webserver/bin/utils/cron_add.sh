#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
command=$(echo $POST | awk -F '&' '{print $1}' | awk -F '=' '{print $2}')
minute=$(echo $POST | awk -F '&' '{print $2}' | awk -F '=' '{print $2}')
hour=$(echo $POST | awk -F '&' '{print $3}' | awk -F '=' '{print $2}')
dom=$(echo $POST | awk -F '&' '{print $4}' | awk -F '=' '{print $2}')
month=$(echo $POST | awk -F '&' '{print $5}' | awk -F '=' '{print $2}')
dow=$(echo $POST | awk -F '&' '{print $6}' | awk -F '=' '{print $2}')

user=$(echo "${HTTP_SESSION}" | awk -F "user=" '{print $2}')

echo "$minute $hour  $dom $month $dow  $command" | sudo tee -a /var/spool/cron/crontabs/$user > /dev/null

./log.sh notice "Added new scheduled task."

./redirect.sh /bin/scheduler.sh

exit 0
