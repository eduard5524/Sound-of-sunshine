#!/bin/bash

#echo "Button 1 test script execution - See '/var/log/kern.log' for module execution information" > /home/pi/led-handler-LKM/B1.log

echo load /var/www/webserver/music/* >> /var/www/webserver/bin/utils/fifo

exit 0
