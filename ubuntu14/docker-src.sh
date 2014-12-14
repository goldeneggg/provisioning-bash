#!/bin/bash

usage() {
    cat << __EOT__
Usage: $0

Setup latest docker environment
__EOT__
}

MYDIR=$(cd $(dirname $0) && pwd)
MYNAME=`basename $0`
WGETCMD="wget --no-check-certificate --no-cache"

# prepare dependency
bash ${MYDIR}/init_ja.sh

# install latest docker
cd /usr/bin
${WGETCMD} https://get.docker.io/builds/Linux/x86_64/docker-latest -O docker
chmod +x docker

# setup upstart for docker
${WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker -O /etc/init.d/docker
chmod +x /etc/init.d/docker
${WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/sysvinit-debian/docker.default -O /etc/default/docker
${WGETCMD} https://raw.githubusercontent.com/docker/docker/master/contrib/init/upstart/docker.conf -O /etc/init/docker.conf

# modify DOCKER_OPTS
export DOCKER_HOST=tcp://0.0.0.0:4243
echo "DOCKER_OPTS=\"-D -H $DOCKER_HOST\"" >> /etc/default/docker

# add env value
echo "export DOCKER_HOST=${DOCKER_HOST}" >> /etc/bash.bashrc

# reload upstart config
initctl reload-configuration

## start docker
initctl start docker
