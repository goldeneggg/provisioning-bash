#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# args
## 1 = el version
## 2 = el revision
declare -r EL_VERSION=${1:-"7"}
echo "el version = ${EL_VERSION}"
declare -r EL_REVISION=${2:-"3"}
echo "el revision = ${EL_REVISION}"

: "----- uninstall mariadb-libs (and dependency libraries)"
${PRVENV_CMD_PKG_RMV} postfix mariadb-libs

: "----- set mysql80 repository"
${PRVENV_CMD_LOCAL_PKG_INS} https://dev.mysql.com/get/mysql80-community-release-el${EL_VERSION}-${EL_REVISION}.noarch.rpm

: "----- install mysql-community-server ver8.0"
${PRVENV_CMD_PKG_INS} mysql-community-server
