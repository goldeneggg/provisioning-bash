#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
declare -r DOCKER_COMPOSE_VER=${1:-"1.24.1"}
declare -r DOCKER_COMPOSE_PREFIX=/usr/local
echo "docker-compose ver = ${DOCKER_COMPOSE_VER}"

: "----- install docker-compose"
curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o ${DOCKER_COMPOSE_PREFIX}/bin/docker-compose
chmod +x ${DOCKER_COMPOSE_PREFIX}/bin/docker-compose
