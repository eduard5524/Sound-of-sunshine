#!/bin/bash

if [ $(cat /var/www/webserver/bin/utils/errors/log 2> /dev/null | wc -l) -gt 0 ]
then

	echo "<div class=\"popup\">
	      <div class=\"popup-card\">
        	<span>Error</span>
	        <div>"

	cat /var/www/webserver/bin/utils/errors/log | while read line
	do
		echo "$line <br>"
	done

	echo "</div>
       		 <div style=\"display: flex; justify-content: center; align-items: center;\">
	 	        <button class=\"popup-btn btn\">Dismiss</button>
	        </div>
	      </div>
	    </div>"

	rm /var/www/webserver/bin/utils/errors/log
fi

exit 0
