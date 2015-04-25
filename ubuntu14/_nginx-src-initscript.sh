#!/bin/bash


: "----- create upstart config"
declare -ar COPY_TARGETS=("/etc/init/nginx.conf")
for target in ${COPY_TARGETS[@]}
do
  cp ${MYDIR}/files/${MYNAME}${target} ${target}
done

${PRVENV_CMD_INIT_START} nginx
