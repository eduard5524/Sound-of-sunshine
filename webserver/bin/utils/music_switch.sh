#!/bin/bash

echo "P" >> ../../music/fifo

./redirect.sh /bin/music.sh

exit 0
