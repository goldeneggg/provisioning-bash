#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# args
## @ = users of "docker" group
declare -a DOCKER_GROUP_USERS
if (( $# >= 1 ))
then
  DOCKER_GROUP_USERS="$@"
  echo "ARGS(@) = users of docker group = ${DOCKER_GROUP_USERS}"
fi

: "----- install using official script"
${PRVENV_WGETCMD} -qO- https://get.docker.com/ | sh

: "----- add docker group into targer users"
for u in ${DOCKER_GROUP_USERS[@]}
do
  usermod -aG docker ${u}
done

declare -r INIT_SCRIPT=/etc/init.d/docker
${INIT_SCRIPT} start
