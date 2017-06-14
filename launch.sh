#!/bin/bash

# docker build -t my-ruby-app ./docker-app
# docker build -t my-nginx ./docker-nginx
# docker run --name ruby-app -p 4567:4567 -d my-ruby-app
# docker run --name nginx-container \
#   -v $(pwd)/html:/usr/share/nginx/html:ro \
#   -v $(pwd)/docker-nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
#   --link ruby-app:app \
#   -P -d my-nginx
# curl http://$(docker-machine ip dev):32769/
# curl http://$(docker-machine ip dev):32769/test.html
# curl http://$(docker-machine ip dev):32769/app/
# curl http://$(docker-machine ip dev):32769/app/foo

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
docker run -d --name memo-registry --volumes-from=memo-volume memo-registry
docker run -d --name memo-caddy \
  -p 8888:80 -p 8443:443 \
  --link memo-myhelloworld:memo-myhelloworld \
  --link memo-registry:memo-registry \
  --volumes-from=memo-volume memo-caddy



# docker run --name memo-nginx -p 80:8080 -d memo-nginx
# docker run --name memo-registry -p 4567:4567 -d memo-registry
# docker run -d -p 49001:8080 -v $PWD/jenkins:/var/jenkins_home:z -t jenkins
