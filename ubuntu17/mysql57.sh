#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

${PRVENV_CMD_PKG_INS} mysql-server-5.7

/etc/init.d/mysql start
