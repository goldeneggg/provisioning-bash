#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# args
## 1 = docker version
## 2 = docker port
declare -r DOCKER_VER=${1:-"17.09.0-ce"}
declare -r DOCKER_PORT=${2:-4243}
echo "docker ver = ${DOCKER_VER} port = ${DOCKER_PORT}"

: "----- useradd into docker group"
if (( $# >= 3 ))
then
  shift 2
  echo "args for docker group users = ${@}"
fi

declare -a DOCKER_GROUP_USERS
if (( $# >= 1 ))
then
  DOCKER_GROUP_USERS="${@}"
  echo "users of docker group = ${DOCKER_GROUP_USERS}"
fi

: "----- install docker from source"
declare -r DOCKER_PREFIX=/usr

: "----- To install, run the following commands as root:"
# command as follows from https://docs.docker.com/engine/installation/linux/docker-ce/binaries/#install-static-binaries
declare -r DOCKER_TGZ_URL=https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VER}.tgz
curl -fsSLO ${DOCKER_TGZ_URL} && tar --strip-components=1 -xvzf docker-${DOCKER_VER}.tgz -C ${DOCKER_PREFIX}/bin

#: "----- Then start docker in daemon mode:"
# /usr/local/bin/dockerd

: "----- setup systemd for docker"
declare -r SERVICE_DOCKER=/etc/systemd/system/docker.service
declare -r SOCKET_DOCKER=/etc/systemd/system/docker.socket

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service -O ${SERVICE_DOCKER}
${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket -O ${SOCKET_DOCKER}

: "----- accepts access from everywhere"
declare -r TCP_DOCKER_HOST="tcp://0.0.0.0:${DOCKER_PORT}"
declare -r ENV_DOCKER_HOST="DOCKER_HOST=${TCP_DOCKER_HOST}"
echo "export ${ENV_DOCKER_HOST}" >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- sed TCP_DOCKER_HOST in docker.service"
# TCP_DOCKER_HOSTに / を含んでいるので変数が展開されるとsedの構文エラーとなる。この場合sedの置換区切り文字を / から | に変更すると良い
sed -i "/ExecStart/ s|$| -H ${TCP_DOCKER_HOST}|g" ${SERVICE_DOCKER}

: "----- install docker-compose"
declare -r DOCKER_COMPOSE_VER=${3:-"1.12.0"}
declare -r DOCKER_COMPOSE_PREFIX=/usr/local

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o ${DOCKER_COMPOSE_PREFIX}/bin/docker-compose
chmod +x ${DOCKER_COMPOSE_PREFIX}/bin/docker-compose


: "----- groupadd docker"
set +e
groups | grep docker > /dev/null
if (( $? ))
then
  groupadd docker

  : "----- add docker group into targer users"
  for u in ${DOCKER_GROUP_USERS[@]}
  do
    usermod -aG docker ${u}
  done
fi
set -e

: "----- systemd reload"
${PRVENV_CMD_INIT_RELOAD}

: "----- start docker"
${PRVENV_CMD_INIT_ENABLE} docker
${PRVENV_CMD_INIT_START} docker
