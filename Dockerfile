# ==============================================================================
# WARNING: this Dockerfile assumes that the container will be created with
# several bind mounts (see docker-create-container.sh)
# ==============================================================================

ARG DEBIAN_VERSION=stretch

FROM debian:${DEBIAN_VERSION}-slim
MAINTAINER tim.bird@sony.com

# ==============================================================================
# Proxy variables
# ==============================================================================

ARG HTTP_PROXY
ENV http_proxy ${HTTP_PROXY}
ENV https_proxy ${HTTP_PROXY}

# Copy the files to the docker that are required for installation
RUN mkdir /fuego
COPY . /fuego/
WORKDIR /fuego

ARG uid=1000
ARG gid=${uid}
ARG JENKINS_PORT=8090
ARG DEBIAN_VERSION=stretch
ARG NO_JENKINS=
ENV NO_JENKINS=$NO_JENKINS
ENV JENKINS_HOME=/var/lib/jenkins
ENV JENKINS_PORT=$JENKINS_PORT
ARG JENKINS_VERSION=2.249.3
ARG JENKINS_SHA=534014c007edbb533a1833fe6f2dc115faf3faa2
# ==============================================================================
# Install fuego with the script
# ==============================================================================
# Install debian common packages
RUN ./install-scripts/install-debian-common.sh $DEBIAN_VERSION

# Install debian version specific packages or configurations
RUN if [ -f ./install-scripts/install-${DEBIAN_VERSION}.sh ]; then ./install-scripts/install-${DEBIAN_VERSION}.sh; fi

# Install Jenkins
RUN if [ -z $NO_JENKINS ]; then ./install-scripts/install-jenkins.sh ${JENKINS_PORT} ${JENKINS_VERSION} ${JENKINS_SHA} ${uid} ${gid}; fi

# Install extra binaries downloading from repositories
RUN ./install-scripts/install-extras.sh $NO_JENKINS

COPY entrypoint.sh /usr/bin/

# Delete the files that are copied for installation
RUN rm -rf /fuego
WORKDIR /

# ==============================================================================
# Setup startup command
# ==============================================================================
# FIXTHIS: when running multiple Fuego containers, or if the host is already
#  running the netperf server, netperf will complain because the port is taken
ENTRYPOINT entrypoint.sh $NO_JENKINS && /bin/bash
