#!/bin/bash
mkdir -p /volume1/docker/container_data/configs
mkdir -p /volume1/docker/container_data/logs

chown -R 1000:1000 /volume1/docker/container_data/configs
chown -R 1000:1000 /volume1/docker/container_data/logs

# launch.sh
docker build -t memo-volume ./volume
docker build -t memo-caddy ./caddy
docker build -t memo-myhelloworld ./myHelloWorld
docker build -t memo-registry ./registry

docker run -d \
  -v /volume1/docker/container_data/configs:/memo/configs \
  -v /volume1/docker/container_data/logs:/memo/logs \
  --name memo-volume memo-volume

cp -af ./configs/. /volume1/docker/container_data/configs/
cp -af ./logs/. /volume1/docker/container_data/logs/
chmod u=rwx /volume1/docker/container_data/configs/caddy/launch.sh

docker run -d --name memo-myhelloworld --volumes-from=memo-volume memo-myhelloworld
docker run -d --name memo-registry -e STORAGE_PATH=/memo/logs/registry --volumes-from=memo-volume memo-registry
docker run -d --name memo-caddy \
  -p 80:80 -p 443:443 -p 5888:5000 \
  --link memo-myhelloworld:memo-myhelloworld \
  --link memo-registry:memo-registry \
  --volumes-from=memo-volume memo-caddy
