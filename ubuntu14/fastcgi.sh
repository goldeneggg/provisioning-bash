#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# prepare dependency
bash ${MYDIR}/init_ja.sh

# install
${PRVENV_CMD_PKG_INS} spawn-fcgi
