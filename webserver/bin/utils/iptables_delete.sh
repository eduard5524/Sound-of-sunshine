#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
chain=$(echo $POST | awk -F "&" '{print $1}' | awk -F "=" '{print $2}')
line=$(echo $POST | awk -F "&" '{print $2}' | awk -F "=" '{print $2}')

sudo iptables -D $chain $line 2>> errors/log

./log.sh warning "Deleted firewall rule."

./redirect.sh /bin/packets.sh

exit 0
