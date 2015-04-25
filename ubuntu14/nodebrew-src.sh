#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


: "----- install nodebrew"
curl -L git.io/nodebrew | perl - setup

declare -r NBBIN=${HOME}/.nodebrew/current/bin
echo "export PATH=${NBBIN}:${PATH}" >> ${PRVENV_USER_BASHRC}

: "----- install node.js using nodebrew"
declare -r MAJOR_VER="0.10"
declare -r MINOR_VER="38"
declare -r VER=${MAJOR_VER}.${MINOR_VER}

${NBBIN}/nodebrew install-binary v${VER}
${NBBIN}/nodebrew use v${VER}
