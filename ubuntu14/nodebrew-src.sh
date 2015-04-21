#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# download node
MAJOR_VER="0.10"
MINOR_VER="38"
VER=${MAJOR_VER}.${MINOR_VER}

# install nodebrew
curl -L git.io/nodebrew | perl - setup

# nodebrew install binary
NBBIN=${HOME}/.nodebrew/current/bin
echo "export PATH=${NBBIN}:${PATH}" >> ${PRVENV_DEFAULT_BASHRC}

${NBBIN}/nodebrew install-binary v${VER}
${NBBIN}/nodebrew use v${VER}
