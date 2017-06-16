#!/bin/bash

docker build -t memo-volume ./volume
docker build -t memo-caddy ./caddy
docker build -t memo-myhelloworld ./myHelloWorld
docker build -t memo-registry ./registry

docker run -d \
  -v `pwd`/container_data/configs:/memo/configs \
  -v `pwd`/container_data/logs:/memo/logs \
  --name memo-volume memo-volume

cp -a `pwd`/configs/. `pwd`/container_data/configs/
cp -a `pwd`/configs/logs/. `pwd`/container_data/logs/
chmod u=rwx `pwd`/container_data/configs/caddy/launch.sh

docker run -d --name memo-myhelloworld --volumes-from=memo-volume memo-myhelloworld
docker run -d --name memo-registry -e STORAGE_PATH=/memo/logs/registry --volumes-from=memo-volume memo-registry
docker run -d --name memo-caddy \
  -p 80:80 -p 443:443 \
  --link memo-myhelloworld:memo-myhelloworld \
  --link memo-registry:memo-registry \
  --volumes-from=memo-volume memo-caddy
