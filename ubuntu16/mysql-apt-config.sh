#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }


: "----- download deb package"
# args
## 1 = version id
declare -r VER=${1:-"0.8.13-1"}
echo "version id = ${VER}"
declare -r DEBNAME=mysql-apt-config_${VER}_all.deb

${PRVENV_WGETCMD} https://dev.mysql.com/get/${DEBNAME}

: "----- install mysql-apt-config"
# Note: This command shows interactive selection console so it can't automate
${PRVENV_CMD_LOCAL_PKG_INS} ${DEBNAME}
