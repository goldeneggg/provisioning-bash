#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- download mysql apt repository"
declare -r APTCONF_VER=${1:-"0.8.7-1"}
declare -r APT_DEB=mysql-apt-config_${APTCONF_VER}_all.deb

pushd ${PRVENV_INSTALL_WORK_DIR}
[ -f ${APT_DEB} ] && rm -f ${APT_DEB}
${PRVENV_WGETCMD} http://dev.mysql.com/get/${APT_DEB}

: "----- remove and purge existed mysql"
${PRVENV_CMD_PKG_RMV_PRGE} mysql-client* mysql-common
${PRVENV_CMD_PKG_AUTORMV_PRGE}

: "----- install mysql-server from local apt repository"
# Note: This task needs interactive user operation. So it's not possible to be automatically...
${PRVENV_CMD_LOCAL_PKG_INS} ${APT_DEB}
${PRVENV_CMD_PKG_UPD}

${PRVENV_CMD_PKG_INS} mysql-server

/etc/init.d/mysql start

: "----- install mysql client library"
${PRVENV_CMD_PKG_INS} libmysqlclient-dev

# security
## drop noname user
#mysql -u root -e "DROP USER ''@'localhost';"
