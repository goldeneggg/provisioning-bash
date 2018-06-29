#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## @ = users of "docker" group
declare -a DOCKER_GROUP_USERS
if (( $# >= 1 ))
then
  DOCKER_GROUP_USERS="$@"
  echo "ARGS(@) = users of docker group = ${DOCKER_GROUP_USERS}"
fi

: "----- remove old version if exists"
# Note: docker-engine package does not exist
${PRVENV_CMD_PKG_RMV} docker docker-engine docker.io

: "----- install dependency packages"
${PRVENV_CMD_PKG_INS} apt-transport-https ca-certificates curl software-properties-common

: "----- install docker.io"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} docker.io

: "----- add docker group into targer users"
for u in ${DOCKER_GROUP_USERS[@]}
do
  usermod -aG docker ${u}
done

: "----- start docker"
${PRVENV_CMD_INIT_RESTART} docker
