#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

${PRVENV_CMD_PKG_INS} php5-fpm

${PRVENV_CMD_PKG_INS} php5-cli php5-curl php5-gd php5-memcache php5-memcached php5-mysql php5-xmlrpc

: "----- modify php.ini for fpm"
declare -r PHP_INI_FILE=/etc/php5/fpm/php.ini
if [ ! -f ${PHP_INI_FILE}.org ]
then
  cp ${PHP_INI_FILE} ${PHP_INI_FILE}.org
fi
## fix_pathinfo=1 is insecure
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${PHP_INI_FILE}

/etc/init.d/php5-fpm restart
