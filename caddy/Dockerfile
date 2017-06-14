FROM debian:jessie

RUN apt-get update && apt-get install -y curl \
  && curl https://getcaddy.com | bash

# RUN chmod u=rwx /www/launch.sh
ENTRYPOINT ["/memo/configs/caddy/launch.sh"]

EXPOSE 80
