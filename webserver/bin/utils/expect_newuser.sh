#!/usr/bin/expect

set username [lindex $argv 0];
set password [lindex $argv 1];

spawn sudo adduser --gecos "" $username

expect "New password:"
send -- "$password\r"
expect "Retype new password:"
send "$password\r"
expect EOF

exit 0
