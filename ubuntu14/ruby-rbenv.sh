#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = ruby version
declare RUBY_VER=${1:-"2.2.2"}
echo "ruby version = ${RUBY_VER}"

# prepare dependency
bash ${MYDIR}/rbenv.sh

# check already installed
declare -r RBENV_BIN=$HOME/.rbenv/bin/rbenv
${RBENV_BIN} rehash

${RBENV_BIN} versions | grep ${RUBY_VER}
if (( $? ))
then
  echo "Ruby version ${RUBY_VER} is not installed yet. Start install."

  # install dependencies  *Note: required root priv
  sudo bash ${MYDIR}/_ruby-rbenv-dep.sh

  # install
  ${RBENV_BIN} install ${RUBY_VER}

  # post process
  ${RBENV_BIN} rehash
  ${RBENV_BIN} global ${RUBY_VER}
fi

# confirm
which ruby
ruby -v
