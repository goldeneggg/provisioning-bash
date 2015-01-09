#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# create upstart config
COPY_TARGETS=("/etc/init/nginx.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# start by upstart
${PRVENV_CMD_INIT_START} nginx
