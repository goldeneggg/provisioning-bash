#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

# args
## 1 = docker port
declare DOCKER_PORT=${1:-4243}
echo "docker port = ${DOCKER_PORT}"

: "----- install latest docker"
pushd /usr/bin
${PRVENV_WGETCMD} https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

: "----- setup upstart for docker"
declare -r INIT_DOCKER=/etc/init.d/docker
declare -r DEFAULT_DOCKER=/etc/default/docker
declare -r CONF_DOCKER=/etc/init/docker.conf

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker -O ${INIT_DOCKER}
chmod +x ${INIT_DOCKER}

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker.default -O ${DEFAULT_DOCKER}

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/upstart/docker.conf -O ${CONF_DOCKER}

: "----- accepts access from everywhere"
export DOCKER_HOST=tcp://0.0.0.0:${DOCKER_PORT}
echo "DOCKER_OPTS=\"-D -H $DOCKER_HOST\"" >> ${DEFAULT_DOCKER}

: "----- allow docker command for non-priviledge user"
echo "export DOCKER_HOST=${DOCKER_HOST}" >> ${ENV_RC}
source ${ENV_RC}

${PRVENV_CMD_INIT_RELOAD}

${PRVENV_CMD_INIT_START} docker
