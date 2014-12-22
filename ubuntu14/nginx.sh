#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# initial setup
bash ${MYDIR}/init_ja.sh

# install
${PRVENV_CMD_PKG_INS} nginx

# start
/etc/init.d/nginx start
