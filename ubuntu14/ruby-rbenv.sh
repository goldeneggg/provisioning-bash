#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


bash ${MYDIR}/rbenv.sh

# args
## 1 = ruby minor version
declare -r MAJOR_VER=${1:-"2.4"}
declare -r MINOR_VER=${2:-"3"}
declare -r RUBY_VER=${MAJOR_VER}.${MINOR_VER}
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
