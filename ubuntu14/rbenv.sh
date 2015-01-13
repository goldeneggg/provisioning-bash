#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# args
## 1 = envfile path(default: "~/.bashrc", if only non-privilledged user)
ENV_RC=${PRVENV_DEFAULT_BASHRC}
if [ ${MYUSER} != "root" ]
then
  echo "Executed by non-root user = ${MYUSER}"
  ENV_RC=$HOME/.bashrc
  if [ $# -eq 1 ]
  then
    ENV_RC=${1}
    echo "ARGS(1) = envfile path = ${ENV_RC}"
  fi
fi

# check already installed
RBENV_ROOT=$HOME/.rbenv
grep "${RBENV_ROOT}" ${ENV_RC}
if [ $? -ne 0 ]
then
  # clone
  git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT}

  # plugins
  cd ${RBENV_ROOT}
  mkdir plugins
  cd plugins
  git clone https://github.com/sstephenson/ruby-build.git

  # set environments
  echo "export PATH=${RBENV_ROOT}/bin"':$PATH' >> ${ENV_RC}
  #[[ -s "${RBENV_ROOT}/bin/rbenv" ]] && eval "$(rbenv init -)"
  echo 'eval "$(rbenv init -)"' >> ${ENV_RC}
  source ${ENV_RC}
fi

# confirm rbenv version
rbenv --version
