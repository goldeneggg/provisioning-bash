#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# download node
declare -r MAJOR_VER="0.10"
declare -r MINOR_VER="38"
declare -r VER=${MAJOR_VER}.${MINOR_VER}

# install nodebrew
curl -L git.io/nodebrew | perl - setup

# nodebrew install binary
declare -r NBBIN=${HOME}/.nodebrew/current/bin
echo "export PATH=${NBBIN}:${PATH}" >> ${PRVENV_USER_BASHRC}

${NBBIN}/nodebrew install-binary v${VER}
${NBBIN}/nodebrew use v${VER}
