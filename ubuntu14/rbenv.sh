#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- check already installed rbenv"
declare -r RBENV_ROOT=${HOME}/.rbenv
grep "${RBENV_ROOT}" ${ENV_RC}
if (( $? ))
then
  : "----- install rbenv and plugins"
  git clone https://github.com/sstephenson/rbenv.git ${RBENV_ROOT}

  pushd ${RBENV_ROOT}
  mkdir plugins
  pushd plugins

  git clone https://github.com/sstephenson/ruby-build.git

  git clone https://github.com/sstephenson/rbenv-default-gems.git

  git clone https://github.com/sstephenson/rbenv-gem-rehash.git

  echo "export PATH=${RBENV_ROOT}/bin"':$PATH' >> ${ENV_RC}
  echo 'eval "$(rbenv init -)"' >> ${ENV_RC}
fi

source ${ENV_RC}
rbenv --version
