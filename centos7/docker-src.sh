#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# args
## 1 = docker port
declare DOCKER_PORT=${1:-2375}
echo "docker port = ${DOCKER_PORT}"

# install latest docker
pushd /usr/bin
${PRVENV_WGETCMD} https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

# setup upstart for docker
declare -r SERVICE_DOCKER=/etc/systemd/system/docker.service
declare -r SOCKET_DOCKER=/etc/systemd/system/docker.socket

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service -O ${SERVICE_DOCKER}
${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket -O ${SOCKET_DOCKER}

# add env value for tcp docker host
declare -r TCP_DOCKER_HOST="tcp://0.0.0.0:${DOCKER_PORT}"
declare -r ENV_DOCKER_HOST="DOCKER_HOST=${TCP_DOCKER_HOST}"
echo "export ${ENV_DOCKER_HOST}" >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

## TCP_DOCKER_HOSTに / を含んでいるので変数が展開されるとsedの構文エラーとなる。この場合sedの置換区切り文字を / から | に変更すると良い
sed -i "/ExecStart/ s|$| -H ${TCP_DOCKER_HOST}|g" ${SERVICE_DOCKER}

# add "docker" group
groupadd docker

# systemd reload
${PRVENV_CMD_INIT_RELOAD}

## port open for docker remote api
firewall-cmd --permanent --zone=public --add-port=${DOCKER_PORT}/tcp
firewall-cmd --reload

## start docker
${PRVENV_CMD_INIT_ENABLE} docker
${PRVENV_CMD_INIT_START} docker
