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

# copy files
COPY_TARGETS=("/etc/systemd/system/docker.service" "/etc/systemd/system/docker.socket")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# add env value
echo "export DOCKER_HOST=tcp://0.0.0.0:${DOCKER_PORT}" >> ${PRVENV_DEFAULT_BASHRC}

# systemd reload
${PRVENV_CMD_INIT_RELOAD}

## port open for docker remote api
firewall-cmd --permanent --zone=public --add-port=${DOCKER_PORT}/tcp
firewall-cmd --reload

## start docker
${PRVENV_CMD_INIT_ENABLE} docker
${PRVENV_CMD_INIT_START} docker
