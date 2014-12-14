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

# copy files
COPY_TARGETS=("/etc/systemd/system/docker.service" "/etc/systemd/system/docker.socket")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# add env value
DOCKER_API_PORT=2375
echo "export DOCKER_HOST=tcp://0.0.0.0:${DOCKER_API_PORT}" >> /etc/bashrc

# systemd
systemctl daemon-reload

## port open for docker remote api
firewall-cmd --add-port=${DOCKER_API_PORT}/tcp --zone=public
firewall-cmd --add-port=${DOCKER_API_PORT}/tcp --zone=public --permanent
systemctl restart firewalld

## start docker
systemctl enable docker
systemctl start docker
