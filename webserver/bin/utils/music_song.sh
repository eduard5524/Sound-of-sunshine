#!/bin/bash

read POST
song=$(echo $POST | awk -F "&" '{print $1}' | awk -F "=" '{print $2}' | sed 's/+/ /g')

echo load ../../music/$song >> ../../music/fifo

./redirect.sh /bin/music.sh

exit 0
