#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

[ $(isroot) ] || { echo "${MYUSER} can not run ${MYNAME}" >&2; exit 1; }

: "----- install memcached from apt repository"
${PRVENV_CMD_PKG_INS} memcached

/etc/init.d/memcached restart
