#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

: "----- install redis from apt repository"
${PRVENV_CMD_PKG_INS} redis-server

/etc/init.d/redis-server restart
