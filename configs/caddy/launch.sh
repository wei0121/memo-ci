#!/bin/bash
set timeout 5
spawn caddy -conf /memo/configs/caddy/Caddyfile
expect "(A)gree/(C)ancel: " { send "a\n" }
interact
