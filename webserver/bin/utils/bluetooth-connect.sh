#!/bin/bash

pulseaudio --start 2>&1 > /dev/null
pactl unload-module  module-bluetooth-discover 2>&1 > /dev/null
pactl   load-module  module-bluetooth-discover 2>&1 > /dev/null

bluetoothctl << EOF
power on
agent on
default agent
connect 88:C6:26:AD:70:21
quit
EOF

./redirect.sh /bin/music.sh

exit 0
