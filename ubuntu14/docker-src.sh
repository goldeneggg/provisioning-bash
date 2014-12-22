#!/bin/bash


#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

# install latest docker
cd /usr/bin
${PRVENV_WGETCMD} https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

# setup upstart for docker
INIT_DOCKER=/etc/init.d/docker
DEFAULT_DOCKER=/etc/default/docker
CONF_DOCKER=/etc/init/docker.conf

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker -O ${INIT_DOCKER}
chmod +x ${INIT_DOCKER}

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker.default -O ${DEFAULT_DOCKER}

${PRVENV_WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/upstart/docker.conf -O ${CONF_DOCKER}

# modify DOCKER_OPTS
export DOCKER_HOST=tcp://0.0.0.0:4243
echo "DOCKER_OPTS=\"-D -H $DOCKER_HOST\"" >> ${DEFAULT_DOCKER}

# add env value
echo "export DOCKER_HOST=${DOCKER_HOST}" >> /etc/bash.bashrc

# reload upstart config
${PRVENV_CMD_INIT_RELOAD}

## start docker
${PRVENV_CMD_INIT_START} docker
