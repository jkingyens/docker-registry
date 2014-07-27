# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Latest Ubuntu LTS
from    ubuntu:14.04

# Update
run apt-get update
run apt-get -y upgrade

# Install pip
run apt-get -y install python-pip

# Install deps for backports.lzma (python2 requires it)
run apt-get -y install python-dev liblzma-dev libevent1-dev libffi-dev libssl-dev

add . /docker-registry

# Install core
run pip install /docker-registry/depends/docker-registry-core

# Install the GCS plugin
run pip install /docker-registry/depends/docker-registry-driver-gcs

# Install registry
run pip install /docker-registry/

env BOTO_CONFIG /conf/boto.cfg
env DOCKER_REGISTRY_CONFIG /conf/config.yml
env SETTINGS_FLAVOR prod

expose 5000

cmd exec docker-registry
