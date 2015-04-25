#!/bin/bash

### common prepare script. expect to be called `source prepare.sh`

#set -eux
set -ux

declare -r MYNAME=`basename $0`
declare -r MYDIR=$(cd $(dirname $0) && pwd)
declare -r MYUSER=$(whoami)

source ${MYDIR}/envs

function isroot {
  [ ${MYUSER} = "root" ] && echo "yes"
}

[ $(isroot) ] \
  && { export ENV_RC=${PRVENV_DEFAULT_BASHRC}; } \
  || { export ENV_RC=${PRVENV_USER_BASHRC}; }
