#!/bin/bash
# $1 - name for the docker image (default: fuego)
# $2 - port for jenkins (default: 8090)
# $3 - Dockerfile or Dockerfile.nojenkins
#
# Example:
#  ./fuego-host-scripts/docker-build-image.sh --no-cache myfuegoimg 8082 Dockerfile.nojenkins
#
if [ "$1" = "--no-cache" ]; then
	NO_CACHE=--no-cache
	shift
fi

DOCKERIMAGE=${1:-fuego}
JENKINS_PORT=${2:-8090}
DEBIAN_VERSION=${3:-stretch}
NO_JENKINS=${4:-}
DOCKERFILE="Dockerfile"
: "${JENKINS_VERSION:=2.249.3}"
: "${JENKINS_SHA:=534014c007edbb533a1833fe6f2dc115faf3faa2}"

if [ "$(id -u)" == "0" ]; then
	JENKINS_UID=$(id -u $SUDO_USER)
	JENKINS_GID=$(id -g $SUDO_USER)
else
	JENKINS_UID=$(id -u $USER)
	JENKINS_GID=$(id -g $USER)
fi

echo "Using Port $JENKINS_PORT"

sudo docker build ${NO_CACHE} -t ${DOCKERIMAGE} --build-arg HTTP_PROXY=$http_proxy \
	--build-arg uid=$JENKINS_UID --build-arg gid=$JENKINS_GID \
	--build-arg DEBIAN_VERSION=$DEBIAN_VERSION \
	--build-arg NO_JENKINS=$NO_JENKINS \
	--build-arg JENKINS_VERSION=$JENKINS_VERSION \
	--build-arg JENKINS_SHA=$JENKINS_SHA \
	--build-arg JENKINS_PORT=$JENKINS_PORT -f $DOCKERFILE .
