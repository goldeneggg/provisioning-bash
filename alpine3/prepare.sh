#!/bin/bash

### common prepare script. expect to be called `source prepare.sh`

#set -eux
set -ux

export MYNAME=`basename $0`
export MYDIR=$(cd $(dirname $0) && pwd)
export MYUSER=$(whoami)
export MYLOGDIR=${MYDIR}/logs
export MYLOG=${MYLOGDIR}/${MYNAME}.log

source ${MYDIR}/envs

function isroot {
  [ ${MYUSER} = "root" ] && echo "yes"
}

# [ $(isroot) ] \
#   && { export ENV_RC=${PRVENV_DEFAULT_BASHRC}; } \
#   || { export ENV_RC=${PRVENV_USER_BASHRC}; }
