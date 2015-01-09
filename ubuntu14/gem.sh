#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# args
## @ = install target gems
OPT_GEMS=()
if [ $# -ge 1 ]
then
  OPT_GEMS="$@"
  echo "ARGS(@) = optional install target gems = ${OPT_GEMS}"
fi

# function for install
## *"--no-document" option is only ">=2.0" version
GEM_INS_CMD="gem install --no-document"

gem_ins(){
  g=${1}
  gem list | egrep "^${g} \(" > /dev/null
  if [ $? -ne 0 ]
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
