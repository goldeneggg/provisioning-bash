#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || (echo "${MYUSER} can not run ${MYNAME}"; exit 1)

${PRVENV_CMD_PKG_INS} nginx

/etc/init.d/nginx start
