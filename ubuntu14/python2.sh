#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

bash ${MYDIR}/_python2-dep.sh

declare -r MINOR_VER=${1:-"7.12"}
declare -r VER="2.${MINOR_VER}"

: "----- install python"
${PRVENV_CMD_PKG_INS} python${VER} python${VER}-dev
