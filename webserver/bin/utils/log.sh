#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

if [ $1 == "-u" ]
then
	user=$2
	logger -p local0.$3 "<$user> <$4>"
	exit 0
fi

user=$(echo "${HTTP_SESSION}" | awk -F "user=" '{print $2}')

logger -p local0.$1 "<$user> <$2>"

exit 0
