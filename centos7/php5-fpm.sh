#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

# install
${PRVENV_CMD_PKG_INS} php56-fpm

# install additional packages
${PRVENV_CMD_PKG_INS} php56-cli php56-gd php56-mysqlnd php56-xmlrpc

# modify php.ini
declare -r PHP_INI_FILE=/etc/php56/fpm/php.ini
[ -f ${PHP_INI_FILE}.org ] || cp ${PHP_INI_FILE} ${PHP_INI_FILE}.org

## fix_pathinfo=1 is insecure
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${PHP_INI_FILE}

# restart php56-fpm
/etc/init.d/php56-fpm restart
