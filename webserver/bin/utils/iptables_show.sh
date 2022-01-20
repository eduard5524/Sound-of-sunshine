#!/bin/bash

lines=$(sudo iptables -L $1 -n --line-number | awk 'NR > 2 {print $0}' | wc -l)

if [ $lines -eq 0 ]
then
	echo "<tr>"
	echo "<td style=\"width: 100%;text-align: center;\" colspan=\"6\">No rules</td>"
	echo "</tr>"
	exit 0
fi

sudo iptables -L $1 -n --line-number | awk 'NR > 2 {print $0}' | while read line
do
	n=$(echo $line | awk '{print $1}')
	policy=$(echo $line | awk '{print $2}')
	protocol=$(echo $line | awk '{print toupper($3)}')
	source=$(echo $line | awk '{print $5}')
	destination=$(echo $line | awk '{print $6}')
	port=$(echo $line | awk '{print $8}' | awk -F ":" '{print $2}')
	
	if [ $protocol == "ALL" ]
	then
		protocol="All"
	fi

	if [ -z $port ]
	then
		port="-"
	fi

	echo "<tr>"
	echo "<td>$protocol</td>"
	echo "<td>$source</td>"
	echo "<td>$destination</td>"
	echo "<td>$port</td>"
	echo "<td>$policy</td>"
	echo "<td><form method=\"POST\" action=\"utils/iptables_delete.sh\"><input type=\"hidden\" name=\"chain\" value=\"$1\"><input type=\"hidden\" name=\"line\" value=\"$n\"><input type=\"submit\" value=\"Delete\"></form></td>"
	echo "</tr>"

	i=$((i+1))
done

exit 0
