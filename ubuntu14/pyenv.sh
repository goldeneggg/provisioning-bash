#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

declare -r MAJOR_VER_2=${1:-"2.7"}
declare -r MINOR_VER_2=${2:-"15"}
declare -r VER_2=${MAJOR_VER_2}.${MINOR_VER_2}

declare -r MAJOR_VER_3=${3:-"3.6"}
declare -r MINOR_VER_3=${4:-"8"}
declare -r VER_3=${MAJOR_VER_3}.${MINOR_VER_3}

: "----- install pyenv"
declare -r PYENV_DIR=${HOME}/.pyenv
[ -d ${PYENV_DIR} ] && rm -fr ${PYENV_DIR}
git clone git://github.com/yyuu/pyenv.git ${PYENV_DIR}

declare -r PYENV_BIN=${PYENV_DIR}/bin
echo "export PATH=${PYENV_BIN}:${PATH}" >> ${ENV_RC}
echo 'eval "$(pyenv init -)"' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- install pyenv-virtualenv"
declare -r PYENV_PLUGIN_DIR=${PYENV_DIR}/plugins
[ -d ${PYENV_PLUGIN_DIR} ] || mkdir ${PYENV_PLUGIN_DIR}
git clone https://github.com/yyuu/pyenv-virtualenv.git ${PYENV_PLUGIN_DIR}/pyenv-virtualenv

: "----- install python2 using pyenv"
${PYENV_BIN}/pyenv install ${VER_2}
${PYENV_BIN}/pyenv rehash

: "----- install python3 using pyenv and set global"
${PYENV_BIN}/pyenv install ${VER_3}
${PYENV_BIN}/pyenv rehash
${PYENV_BIN}/pyenv global ${VER_3}
