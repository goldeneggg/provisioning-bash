#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# setup dotfiles
cd ~
git clone https://github.com/goldeneggg/dotfiles.git
cd dotfiles
bash setup.sh -L
