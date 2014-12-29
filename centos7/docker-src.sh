#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

# args
## 1 = docker port
DOCKER_PORT=2375
if [ $# -eq 1 ]
then
  DOCKER_PORT=${1}
  echo "ARGS(1) = docker port = ${DOCKER_PORT}"
fi

# install latest docker
cd /usr/bin
${PRVENV_WGETCMD} https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

# setup upstart for docker
SERVICE_DOCKER=/etc/systemd/system/docker.service
SOCKET_DOCKER=/etc/systemd/system/docker.socket

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service-O ${SERVICE_DOCKER}
${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket -O ${SOCKET_DOCKER}

# add env value
TCP_DOCKER_HOST="tcp://0.0.0.0:${DOCKER_PORT}"
ENV_DOCKER_HOST="DOCKER_HOST=${TCP_DOCKER_HOST}"
echo "export ${ENV_DOCKER_HOST}" >> ${PRVENV_DEFAULT_BASHRC}
## TCP_DOCKER_HOSTに / を含んでいるので変数が展開されるとsedの構文エラーとなる。この場合sedの置換区切り文字を / から | に変更すると良い
sed -i "/ExecStart/ s|$| -H ${TCP_DOCKER_HOST}|g" ${SERVICE_DOCKER}

# systemd reload
${PRVENV_CMD_INIT_RELOAD}

## port open for docker remote api
firewall-cmd --permanent --zone=public --add-port=${DOCKER_PORT}/tcp
firewall-cmd --reload

## start docker
${PRVENV_CMD_INIT_ENABLE} docker
${PRVENV_CMD_INIT_START} docker
