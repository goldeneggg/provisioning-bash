#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# install dependencies
${PRVENV_CMD_PKG_INS} build-essential cmake bison libncurses5-dev
