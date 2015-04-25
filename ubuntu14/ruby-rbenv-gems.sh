#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## @ = install target gems
declare -a OPT_GEMS
if (( $# >= 1 ))
then
  OPT_GEMS="$@"
  echo "ARGS(@) = optional install target gems = ${OPT_GEMS}"
fi

# prepare
declare -r RBENV_BIN=$HOME/.rbenv/bin/rbenv
${RBENV_BIN} rehash

# function for install
## *"--no-document" option is only ">=2.0" version
declare -r GEM_INS_CMD="gem install --no-document"

function gem_ins {
  local g=${1}
  gem list | egrep "^${g} \(" > /dev/null
  if (( $? ))
  then
    ${GEM_INS_CMD} ${g}
  else
    echo "gem [${g}] is already installed"
  fi
}

# gem install (required)
## bundler
gem_ins bundler

# gem install (optional)
for g in ${OPT_GEMS[@]}
do
  gem_ins ${g}
done

${RBENV_BIN} rehash
