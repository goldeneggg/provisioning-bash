#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# initial setup
bash ${MYDIR}/init.sh

# contents as follows
