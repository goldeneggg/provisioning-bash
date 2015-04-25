#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# create upstart config
declare -ar COPY_TARGETS=("/etc/init/nginx.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

# start by upstart
${PRVENV_CMD_INIT_START} nginx
