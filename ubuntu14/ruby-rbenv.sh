#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


bash ${MYDIR}/rbenv.sh

# args
## 1 = ruby version
declare RUBY_VER=${1:-"2.2.2"}
echo "ruby version = ${RUBY_VER}"

declare -r RBENV_PATH=$HOME/.rbenv/bin
declare -r RBENV_BIN=${RBENV_PATH}/rbenv
export PATH=${RBENV_PATH}:${PATH}

${RBENV_BIN} rehash

: "----- check already installed target version"
${RBENV_BIN} versions | grep ${RUBY_VER}
if (( $? ))
then
  : "----- install ruby of target version"
  echo "Ruby version ${RUBY_VER} is not installed yet. Start install."

  # *Note: required root priv
  sudo -E bash ${MYDIR}/_ruby-rbenv-dep.sh

  ${RBENV_BIN} install ${RUBY_VER}

  ${RBENV_BIN} rehash
  ${RBENV_BIN} global ${RUBY_VER}
fi

which ruby
ruby -v
