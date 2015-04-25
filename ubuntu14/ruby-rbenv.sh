#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = ruby version
declare RUBY_VER=${1:-"2.2.2"}
echo "ruby version = ${RUBY_VER}"

bash ${MYDIR}/rbenv.sh

declare -r RBENV_BIN=$HOME/.rbenv/bin/rbenv
${RBENV_BIN} rehash

: "----- check already installed target version"
${RBENV_BIN} versions | grep ${RUBY_VER}
if (( $? ))
then
  : "----- install ruby of target version"
  echo "Ruby version ${RUBY_VER} is not installed yet. Start install."

  # *Note: required root priv
  sudo bash ${MYDIR}/_ruby-rbenv-dep.sh

  ${RBENV_BIN} install ${RUBY_VER}

  ${RBENV_BIN} rehash
  ${RBENV_BIN} global ${RUBY_VER}
fi

which ruby
ruby -v
