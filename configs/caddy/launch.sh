#!/bin/sh
cp -r /memo/configs/caddy/cer/.  /root/.caddy/acme/
caddy -agree -log stdout -conf /memo/configs/caddy/Caddyfile
