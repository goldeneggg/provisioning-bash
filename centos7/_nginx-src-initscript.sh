#!/bin/bash


# create upstart config
#COPY_TARGETS=("/etc/init/nginx.conf")
#for target in ${COPY_TARGETS[@]}
#do
#  cp ${MYDIR}/files/${MYNAME}${target} ${target}
#done

# start by systemctl
## TODO test
${PRVENV_CMD_INIT_START} nginx.service
