#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

# Note: before run this script, require to install mysql-apt-config
# See: mysql-apt-config.sh

# See: https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install-linux-quick.html
: "----- install mysql-shell"
${PRVENV_CMD_PKG_UPD}
${PRVENV_CMD_PKG_INS} mysql-shell

