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
${PRVENV_CMD_PKG_DEL} docker docker-engine docker.io

: "----- install packages for setup"
${PRVENV_CMD_PKG_UPD}
declare -r SETUP_PKGS="apt-transport-https ca-certificates curl software-properties-common"
${PRVENV_CMD_PKG_INS} ${SETUP_PKGS}

: "----- add docker's official GPG key"
declare -r FINGERPRINT="0EBFCD88"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint ${FINGERPRINT}

: "----- add repositry"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

: "----- install docker-ce"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} docker-ce

: "----- add docker group into targer users"
for u in ${DOCKER_GROUP_USERS[@]}
do
  usermod -aG docker ${u}
done
