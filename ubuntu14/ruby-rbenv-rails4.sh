#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# install dependencies  *Note: required root priv
sudo bash ${MYDIR}/_ruby-rbenv-rails4-dep.sh

# install rails
bash ruby-rbenv-gems.sh rails