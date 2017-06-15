#!/usr/bin/expect
set timeout 5
spawn caddy -conf /memo/configs/caddy/Caddyfile
expect "Email address: " { send "williamtse0121@gmail.com\n" }
interact
