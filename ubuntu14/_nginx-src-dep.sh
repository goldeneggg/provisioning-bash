#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} zlib1g-dev libpcre3 libpcre3-dev libssl-dev
