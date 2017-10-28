#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
declare -r DOCKER_VERSION=${1:-"17.09.0"}"~ce-0~ubuntu"

: "----- install image-extra(for only ubuntu14 trusty)"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} linux-image-extra-$(uname -r) linux-image-extra-virtual

: "----- install dependency packages"
${PRVENV_CMD_PKG_INS} apt-transport-https ca-certificates curl software-properties-common

: "----- add docker officlal GPG KEY"
declare -r FINGERPRINT=0EBFCD88
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint ${FINGERPRINT}

: "----- add repository for setup pattern (is stable)"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

: "----- install docker-ce"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} docker-ce=${DOCKER_VERSION}
