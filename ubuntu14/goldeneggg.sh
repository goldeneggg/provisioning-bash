#!/bin/bash

#>>>>>>>>>> prepare
source prepare.sh
#<<<<<<<<<<


# args
## 1 = github user
## 2 = github mail
declare -r GITHUB_USER=${1:?"must supply GITHUB_USER"}
declare -r GITHUB_MAIL=${2:?"must supply GITHUB_MAIL"}
echo "github user = ${GITHUB_USER}"
echo "github mail = ${GITHUB_MAIL}"

declare -r HOME_BIN=${HOME}/bin
mkdir -p ${HOME_BIN}

: "----- install stow for dotfiles setup"
declare -r STOW_VER="2.2.0"
declare -r STOW_TAR=stow-${STOW_VER}.tar.gz
curl -L http://ftp.gnu.org/gnu/stow/${STOW_TAR} -o ${STOW_TAR}
tar zxf ${STOW_TAR}
cd stow-${STOW_VER}
./configure --prefix=${HOME_BIN}
make
make install

: "----- install kehchain for ssh-agent over {tmux,screen} sessions"
declare -r KEYCHAIN_VER="2.8.0"
declare -r KEYCHAIN_TAR=keychain-${KEYCHAIN_VER}.tar.bz2
curl -L http://www.funtoo.org/distfiles/keychain/${KEYCHAIN_TAR} -o ${KEYCHAIN_TAR}
tar xjf ${KEYCHAIN_TAR}
cd keychain-${KEYCHAIN_VER}
cp keychain keychain.pod ${HOME_BIN}/

: "----- setup my dotfiles"
cd ~
if [ ! -d dotfiles ]
then
  git clone https://github.com/goldeneggg/dotfiles.git
fi
cd dotfiles
git pull --rebase origin master
bash setup.sh -L --github-user ${GITHUB_USER} --github-mail ${GITHUB_MAIL}
