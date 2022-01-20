#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
pid=$(echo $POST | awk -F '&' '{print $1}' | awk -F "=" '{print $2}')
seconds=$(echo $POST | awk -F '&' '{print $2}' | awk -F "=" '{print $2}')

if [ -z $seconds ]
then
	sudo kill -9 $pid 2>> errors/log
	./log.sh warning "Killed process with PID: $pid"
else
	(sudo kill -19 $pid 2>> errors/log; sudo sleep $seconds 2>> errors/log; sudo kill -18 $pid 2>> errors/log) &
	./log.sh notice "Interrupted process with PID: $pid for $seconds seconds"
fi

./redirect.sh /bin/tasks.sh

exit 0
