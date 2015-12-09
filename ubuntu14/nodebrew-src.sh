#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


set -e

: "----- install nodebrew"
declare -r NODEBREW_DIR=${HOME}/.nodebrew
[ -d ${NODEBREW_DIR} ] && rm -fr ${NODEBREW_DIR}
curl -L git.io/nodebrew | perl - setup

declare -r NODEBREW_BIN=${NODEBREW_DIR}/current/bin
echo "export PATH=${NODEBREW_BIN}:${PATH}" >> ${ENV_RC}
set +u; source ${ENV_RC}; set -u

: "----- install node.js using nodebrew"
declare -r MAJOR_VER="0.12"
declare -r MINOR_VER=${1:-"9"}
declare -r VER=${MAJOR_VER}.${MINOR_VER}

${NODEBREW_BIN}/nodebrew install-binary v${VER}
${NODEBREW_BIN}/nodebrew use v${VER}
