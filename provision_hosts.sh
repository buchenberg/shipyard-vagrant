#!/bin/bash

#Update apt
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list
apt-cache policy docker-engine
apt-get update

#Install docker
DEBIAN_FRONTEND=noninteractive 
apt-get install -y --force-yes \
 wget \
 apt-transport-https \
 ca-certificates \
 linux-image-extra-$(uname -r) \
 docker-engine
 
usermod -aG docker vagrant

#Restart docker
service docker restart
