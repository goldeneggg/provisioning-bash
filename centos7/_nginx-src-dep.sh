#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} zlib-devel pcre pcre-devel openssl-devel
