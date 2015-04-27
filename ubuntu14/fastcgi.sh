#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

${PRVENV_CMD_PKG_INS} spawn-fcgi
