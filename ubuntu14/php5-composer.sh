#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# root only
if [ ${MYUSER} != "root" ]
then
  echo "${MYUSER} can not run ${MYNAME}"
  exit 1
fi

# install (globally)
INSTALLER_URL="https://getcomposer.org/installer"
PREFIX=/usr/local

curl -sS ${INSTALLER_URL} | php
mv composer.phar ${PREFIX}/bin/composer
