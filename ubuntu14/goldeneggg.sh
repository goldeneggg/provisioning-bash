#!/bin/bash

#>>>>>>>>>> prepare
MYNAME=`basename $0`
MYDIR=$(cd $(dirname $0) && pwd)
MYUSER=$(whoami)

# load environments
source ${MYDIR}/envs
#<<<<<<<<<<


# args
## 1 = github user
## 2 = github mail
GITHUB_USER=""
GITHUB_MAIL=""
if [ $# -eq 2 ]
then
  GITHUB_USER=$1
  echo "ARGS(1) = github user = ${GITHUB_USER}"
  GITHUB_MAIL=$2
  echo "ARGS(2) = github mail = ${GITHUB_MAIL}"
fi

# setup dotfiles
cd ~
git clone https://github.com/goldeneggg/dotfiles.git
cd dotfiles
bash setup.sh -L --github-user ${GITHUB_USER} --github-mail ${GITHUB_MAIL}
