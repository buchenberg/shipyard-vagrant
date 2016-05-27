#!/bin/bash

#Install Shipyard
docker run \
-ti \
-d \
--restart=always \
--name shipyard-rethinkdb \
rethinkdb

docker run \
-ti \
-d \
-p 4001:4001 \
-p 7001:7001 \
--restart=always \
--name shipyard-discovery \
microbox/etcd -name discovery

docker run \
-ti \
-d \
-p 2375:2375 \
--hostname=$HOSTNAME \
--restart=always \
--name shipyard-proxy \
-v /var/run/docker.sock:/var/run/docker.sock \
-e PORT=2375 \
shipyard/docker-proxy:latest

docker run \
-ti \
-d \
--restart=always \
--name shipyard-swarm-manager \
swarm:latest \
manage --host tcp://0.0.0.0:3375 etcd://10.245.1.2:4001

docker run -d --name shipyard-swarm-agent swarm join --advertise=10.245.1.2:2375 etcd://10.245.1.2:4001

docker run \
-ti \
-d \
--restart=always \
--name shipyard-controller \
--link shipyard-rethinkdb:rethinkdb \
--link shipyard-swarm-manager:swarm \
-p 8080:8080 \
shipyard/shipyard:latest \
server \
-d tcp://swarm:3375
