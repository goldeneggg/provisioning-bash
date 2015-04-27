#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}"; exit 1; }

: "----- install (globally) composer"
declare -r INSTALLER_URL="https://getcomposer.org/installer"
declare -r PREFIX=/usr/local

curl -sS ${INSTALLER_URL} | php
mv composer.phar ${PREFIX}/bin/composer
