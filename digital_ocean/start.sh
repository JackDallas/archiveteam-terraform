#! /usr/bin/env bash

set -e

docker kill "$(docker ps -q --filter="name=warrior")" || true
docker rm "$(docker ps -qa --filter="name=warrior")" || true

docker pull atdr.meo.ws/archiveteam/${project}

for i in {1..${warriors}}
do
  docker run --name warrior-"$i" -d --env concurrent_items=${concurrent_items} --restart=always atdr.meo.ws/archiveteam/${project} ${downloader}
done

docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower --interval 10
