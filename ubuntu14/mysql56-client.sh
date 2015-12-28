#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

: "----- install mysql-client 5.6"
${PRVENV_CMD_PKG_INS} mysql-client-5.6
