#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
declare -r DOCKER_VERSION=${1:-"17.09.0"}
declare -r DOCKER_APT_VER=${DOCKER_VERSION}"~ce-0~ubuntu"
## @ = users of "docker" group
declare -a DOCKER_GROUP_USERS
if (( $# >= 2 ))
then
  shift 1
  DOCKER_GROUP_USERS="$@"
  echo "ARGS(@) = users of docker group = ${DOCKER_GROUP_USERS}"
fi

: "----- remove old version if exists"
# Note: docker-engine package does not exist
#${PRVENV_CMD_PKG_RMV} docker docker-engine docker.io
${PRVENV_CMD_PKG_RMV} docker docker.io

: "----- install image-extra(for only ubuntu14 trusty)"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} linux-image-extra-$(uname -r) linux-image-extra-virtual

: "----- install dependency packages"
${PRVENV_CMD_PKG_INS} apt-transport-https ca-certificates curl software-properties-common

: "----- add docker officlal GPG KEY"
declare -r FINGERPRINT=0EBFCD88
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint ${FINGERPRINT}

: "----- add repository for setup pattern (is stable)"
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

: "----- install docker-ce"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} docker-ce=${DOCKER_APT_VER}

: "----- add docker group into targer users"
for u in ${DOCKER_GROUP_USERS[@]}
do
  usermod -aG docker ${u}
done
