# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

# Latest Ubuntu LTS
FROM ubuntu:14.04

# Update
RUN apt-get update \
# Install pip
    && apt-get install -y \
        python-pip \
# Install deps for backports.lmza (python2 requires it)
        python-dev \
        liblzma-dev \
        libevent1-dev \
        libffi-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . /docker-registry

# Install core
RUN pip install /docker-registry/depends/docker-registry-core

# Install the GCS plugin
RUN pip install /docker-registry/depends/docker-registry-driver-gcs

# Install registry
RUN pip install file:///docker-registry#egg=docker-registry[bugsnag,newrelic,cors]

RUN patch \
 $(python -c 'import boto; import os; print os.path.dirname(boto.__file__)')/connection.py \
 < /docker-registry/contrib/boto_header_patch.diff

ENV BOTO_CONFIG /conf/boto.cfg
ENV DOCKER_REGISTRY_CONFIG /conf/config.yml
ENV SETTINGS_FLAVOR prod

EXPOSE 5000

CMD ["docker-registry"]
