#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

# See: latest stable version from https://nodejs.org/ja/download/ at 2018-11-19
declare -r MAJOR_VER=${1:-"10.15"}
declare -r MINOR_VER=${2:-"3"}
declare -r VER=${MAJOR_VER}.${MINOR_VER}

: "----- install ndenv"
declare -r NDENV_DIR=${HOME}/.ndenv
[ -d ${NDENV_DIR} ] && rm -fr ${NDENV_DIR}
git clone https://github.com/riywo/ndenv ~/.ndenv

declare -r NDENV_BIN=${NDENV_DIR}/bin
echo "export PATH=${NDENV_BIN}:${PATH}" >> ${ENV_RC}
echo 'eval "$(ndenv init -)"' >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- install nodebuild"
declare -r NDENV_PLUGIN_DIR=${NDENV_DIR}/plugins
[ -d ${NDENV_PLUGIN_DIR} ] || mkdir ${NDENV_PLUGIN_DIR}
git clone https://github.com/riywo/node-build.git ${NDENV_PLUGIN_DIR}/node-build

: "----- install node.js using ndenv"
${NDENV_BIN}/ndenv install v${VER}
${NDENV_BIN}/ndenv rehash
${NDENV_BIN}/ndenv global v${VER}
