#!/bin/bash

if [ -z ${HTTP_SESSION} ]
then
	./utils/redirect.sh /bin/login.sh
	exit 1
fi

read POST
method=$(echo $POST | awk -F '&' '{print $1}' | awk -F '=' '{print $2}')
chain=$(echo $POST | awk -F '&' '{print $2}' | awk -F '=' '{print $2}')
policy=$(echo $POST | awk -F '&' '{print $3}' | awk -F '=' '{print $2}')
source=$(echo $POST | awk -F '&' '{print $4}' | awk -F '=' '{print $2}')
destination=$(echo $POST | awk -F '&' '{print $5}' | awk -F '=' '{print $2}')
protocol=$(echo $POST | awk -F '&' '{print $6}' | awk -F '=' '{print $2}')
port=$(echo $POST | awk -F '&' '{print $7}' | awk -F '=' '{print $2}')

cmd="iptables -$method $chain"

if [ -n "$source" ]
then
	source=$(echo $source | awk -F "%2F" 'NF > 1 {print $1"/"$2} NF < 2 {print $1}')
	cmd=$(echo $cmd -s $source)
fi

if [ -n "$destination" ]
then
	destination=$(echo $destination | awk -F "%2F" 'NF > 1 {print $1"/"$2} NF < 2 {print $1}')
	cmd=$(echo $cmd -d $destination)
fi

if [ -n "$protocol" ]
then
	cmd=$(echo $cmd -p $protocol)
fi

if [ -n "$port" ]
then
	cmd=$(echo $cmd --dport $port)
fi

cmd=$(echo $cmd -j $policy)

sudo $cmd 2>> errors/log

./log.sh notice "Added firewall rule."

./redirect.sh /bin/packets.sh

exit 0
